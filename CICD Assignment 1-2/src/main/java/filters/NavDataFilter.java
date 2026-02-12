package filters;

import dao.serviceCategoryDAO;
import dao.serviceDAO;
import models.serviceCategory;
import models.serviceNavItem;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Ensures the header mega-menu data (categories + services) is available on ALL pages,
 * including JSPs that are accessed directly (e.g. /public/account.jsp).
 *
 * Without this, header.jsp will show "No categories" unless a specific servlet
 * remembered to set request attributes.
 */
@WebFilter("/*")
public class NavDataFilter implements Filter {

    private final serviceCategoryDAO categoryDAO = new serviceCategoryDAO();
    private final serviceDAO serviceDAO = new serviceDAO();

    @Override
    public void init(FilterConfig filterConfig) {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        if (req instanceof HttpServletRequest httpReq) {
            // Only populate when header.jsp is likely used (public pages).
            // This avoids doing extra work for static assets.
            String uri = httpReq.getRequestURI();

            boolean isPublicPage = uri.contains("/public/")
                    || uri.endsWith("/services")
                    || uri.contains("/services/")
                    || uri.endsWith("/home")
                    || uri.endsWith("/");

            boolean isAsset = uri.contains("/public/assets/")
                    || uri.endsWith(".css")
                    || uri.endsWith(".js")
                    || uri.endsWith(".png")
                    || uri.endsWith(".jpg")
                    || uri.endsWith(".jpeg")
                    || uri.endsWith(".webp")
                    || uri.endsWith(".svg")
                    || uri.endsWith(".gif")
                    || uri.endsWith(".ico");

            if (isPublicPage && !isAsset) {
                try {
                    // Cache in application scope to reduce DB calls.
                    var ctx = httpReq.getServletContext();

                    @SuppressWarnings("unchecked")
                    List<serviceCategory> cachedCats = (List<serviceCategory>) ctx.getAttribute("navCategoriesCache");

                    @SuppressWarnings("unchecked")
                    Map<Integer, List<serviceNavItem>> cachedMap =
                            (Map<Integer, List<serviceNavItem>>) ctx.getAttribute("navServicesByCatCache");

                    if (cachedCats == null || cachedMap == null) {
                        cachedCats = categoryDAO.getAllCategories();
                        cachedMap = serviceDAO.getNavServicesByCategory();
                        ctx.setAttribute("navCategoriesCache", cachedCats);
                        ctx.setAttribute("navServicesByCatCache", cachedMap);
                    }

                    // Make it available per-request for header.jsp
                    if (httpReq.getAttribute("navCategories") == null) {
                        httpReq.setAttribute("navCategories", cachedCats);
                    }
                    if (httpReq.getAttribute("navServicesByCat") == null) {
                        httpReq.setAttribute("navServicesByCat", cachedMap);
                    }
                } catch (Exception e) {
                    // Don't block the request if nav fails; header will show fallback.
                    e.printStackTrace();
                }
            }
        }

        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // no-op
    }
}
