<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NO PERMISSION</title>
    <script>
        function showAlertAndGoBack() {
            alert("권한이 없습니다 !!");
            window.history.back();
            window.close();
        }
    </script>
</head>
<body>
    <script>
        showAlertAndGoBack();
    </script>
</body>
</html>
