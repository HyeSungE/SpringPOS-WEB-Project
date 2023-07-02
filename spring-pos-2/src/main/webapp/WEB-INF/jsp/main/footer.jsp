<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
</div>
</div>
<script>
function logout() {
	var confirmLogout = confirm("로그아웃 하시겠습니까?");
	if (confirmLogout) {
		window.location.href = "/pos/logout";
	}
}
</script>
<script src="/js/jquery-3.7.0.min.js"></script>
<script src="/js/bootstrap.min.js"></script>
<script src="/js/main_page.js"></script>
</body>
</html>
