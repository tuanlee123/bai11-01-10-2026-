<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- ... -->
<c:if test="${not empty sessionScope.cart}">
    <span class="badge bg-danger rounded-pill">${fn:length(sessionScope.cart)}</span>
</c:if>