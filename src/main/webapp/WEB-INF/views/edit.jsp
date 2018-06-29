<%--
  Created by IntelliJ IDEA.
  User: HSK
  Date: 2018-06-28
  Time: 오후 6:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <title>Edit</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <link rel="stylesheet" href="css/css-mint.min.css">
    <link rel="stylesheet" href="css/basic.css">
    <style type="text/css">
        table {
            width: 50%;
            background-color: #ffffff;
            border: 0;
            margin-bottom: 30px;
        }

        table td {
            background-color: #ffffff;
        }

        input.cm-input {
            margin-bottom: 0px;
        }

        span[id] {
             margin-top: 50px;
        }
    </style>
</head>
<body>
<div id="div_edit" align="center">
    <main>
        <section>
            <h2>정보 수정</h2>
            <form id="frm_edit" name="frm_edit" action="editProcess" method="post">
                <!-- input fields -->
                <table>
                    <tr>
                        <td><span class="cm-text-bold">ID</span></td>
                        <td>
                            <input type="text" class="cm-input" placeholder="ID" value="${user.id}" disabled="true"/>
                            <input id="txt_id" name="id" type="hidden" value="${user.id}"/>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="cm-text-bold">Password</span></td>
                        <td><input id="txt_pw" name="pw" type="password" class="cm-input" placeholder="Password" value="${user.pw}"/></td>
                    </tr>
                    <tr>
                        <td><span class="cm-text-bold">Name</span></td>
                        <td><input id="txt_name" name="name" type="text" class="cm-input" placeholder="Name" value="${user.name}"/></td>
                    </tr>
                    <tr>
                        <td><span class="cm-text-bold">E-Mail</span></td>
                        <td><input id="txt_email" name="email" type="text" class="cm-input" placeholder="E-mail" value="${user.email}"/></td>
                    </tr>
                </table>
                <!-- buttons -->
                <button id="btn_submit" name="submit" type="submit" class="cm-btn success" disabled="true" value="btn_submit">Submit</button>
                <button id="btn_cancel" name="cancel" class="cm-btn error" value="btn_cancel">Cancel</button><br/>
                <!-- error messages -->
                <span id="error_pw" name="error_pw" class="cm-alert error"></span>
                <span id="error_name" name="error_name" class="cm-alert error"></span>
                <span id="error_email" name="error_email" class="cm-alert error"></span>
            </form>
        </section>
    </main>
</div>
</body>
<script type="text/javascript">
$(document).ready(function() {
    // disable button when input field is empty.
    toggleDisableSubmit(!checkFieldEmpty());

    // disable submit after button clicked.
    $("#btn_submit").submit(function () {
        $(this).attr("disabled", true);
        return true;
    });

    // show span
    showSpan(undefined);

    // check input datas after input focused out and keyup
    // then button toggle
    $("input").each(function() {
        $(this).focusout(function() {
            toggleDisableSubmit(checkValidUser());
        });

        $(this).keyup(function() {
            toggleDisableSubmit(checkValidUser());
        });
    });

    <c:if test="${!empty isUpdated}">
        <c:if test="${!isUpdated}">
            alert("수정을 실패했습니다.");
        </c:if>
    </c:if>
});

function showSpan(objSpanMsg) {
    $("span[id]").each(function() {
        var text = objSpanMsg === undefined ? undefined : objSpanMsg[this.id];

        if (text === undefined) {
            $(this).css("display", "none");
            this.innerText = "";
        } else {
            $(this).css("display", "inline-block");
            this.innerText = objSpanMsg[this.id];
        }
    });
}

function checkFieldEmpty() {
    var frm = document.frm_edit;
    return frm.id.value.length == 0 || frm.pw.value.length == 0 ||
            frm.name.value.length == 0 || frm.email.value.length == 0
            ? true : false;
}

function checkValidUser() {
    var validUser = true;
    var errorMessage = "";
    var objSpanMsg = {};

    if (!checkValidPw()) {
        errorMessage = "비밀번호는 8~20글자로 가능하고, 숫자, 알파벳(대문자, 소문자 모두 가능) 허용된 특수문자(!@#$%^&*)의 조합입니다.";
        objSpanMsg["error_pw"] = errorMessage;
        showSpan(objSpanMsg);

        return validUser = false;
    }
    if (!checkValidName()) {
        errorMessage = "이름은 한글 이름 또는 영문 이름으로 등록이 가능합니다.\n"
            + "한글은 30글자까지, 영문은 공백을 두고 first name은 1~15, last name은 1~15글자 가능합니다. (예: \"Donald Trump\")";
        objSpanMsg["error_name"] = errorMessage;
        showSpan(objSpanMsg);

        return validUser = false;
    }
    if (!checkValidEmail()) {
        errorMessage = "이메일은 account@domain.com처럼 이메일의 형식만 가능합니다.";
        objSpanMsg["error_email"] = errorMessage;
        showSpan(objSpanMsg);

        return validUser = false;
    }

    showSpan(objSpanMsg);
    return validUser;
}

function toggleDisableSubmit(validUser) {   // validUser : boolean
    var frm = document.frm_edit;
    frm.submit.disabled = !validUser;
}

/**
 * 1. pw의 길이는 8 이상 20 이하.
 * 2. pw는 숫자, 알파벳(대문자, 소문자 모두 가능), 허용된 특수문자(!@#$%^&*)의 조합.
 * @returns {boolean}
 */
function checkValidPw() {
    var validPw = true;
    var frm = document.frm_edit;

    if (!frm.pw.value.match(/^(?=.*[0-9A-Za-z])[\w!@#$%^&*]{7,20}$/g)) {
        validPw = false;
    }

    return validPw;
}

/**
 * 1. 이름은 한글 또는 영문 가능
 * 2. 한글은 1~30글자 가능
 * 3. 영문은 공백을 두고 first name은 1~15, last name은 1~15글자 가능. (예: "Donald Trump")
 * @returns {boolean}
 */
function checkValidName() {
    var validName = true;
    var frm = document.frm_edit;

    if (!frm.name.value.match(/^([가-힣]{1,30}|[a-zA-Z]{1,15}\s[a-zA-Z]{1,15})$/g)) {
        validName = false;
    }

    return validName;
}

/**
 * 이메일은 "account@domain.com" 형식만 허용
 * @returns {boolean}
 */
function checkValidEmail() {
    var validEmail = true;
    var frm = document.frm_edit;

    if (!frm.email.value.match(/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/g)) {
        validEmail = false;
    }

    return validEmail;
}
</script>
</html>