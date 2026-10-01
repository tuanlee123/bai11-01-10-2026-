<a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-success me-3" style="text-decoration: none;">
    🛒 Giỏ hàng 
    <c:if test="${not empty sessionScope.cart}">
        <span class="badge bg-danger rounded-pill">${sessionScope.cart.size()}</span>
    </c:if>
</a>