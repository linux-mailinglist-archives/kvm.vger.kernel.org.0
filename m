Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721CD1370F2
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 16:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgAJPRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 10:17:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51652 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgAJPRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 10:17:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so2401064wmd.1
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 07:17:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U0+HwA4wKFY9D6e/1hcl/iLuo/q00aJgCMGLLMkPfTQ=;
        b=RU08XnoN967TXrBDUnFfphysBqdJbjsXLSsoiOxFvS+DZrm+8KcwPD1tTMtiR4YDNL
         txD/4X4ga12WXq995CrbQctebIMtoUo5PD5JOQHIH6gLO28D28c72LdYV5QppSzh4AFS
         UnMU1XJp55syeAeD2Z0fiN+1Jve+abgoB6lWwGVVQGhYDJGkp6Hz1B9F2Y5J9KUnjcIK
         JIIZx1vi3VYuQZbCob1D0+9lpnqp+qmo8kJJBySjv2W4SiWvGR4dNbI1+IxhtnkAIB1v
         bCoqSnV91YwAIM2VxS1dsw+Vgy4o8lANclyjanXMX54cxx9LiStHhMBad5onMU9rLYN1
         sF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U0+HwA4wKFY9D6e/1hcl/iLuo/q00aJgCMGLLMkPfTQ=;
        b=Sma3n2IleUvW710adMrX+DTUiKMbw4iiUzVedVkQ/cuSIO7WMVDLS4IYfMLz6yfeJp
         szgoL99xx0Pc2N8HB4oHnNnMrWLrcOVkJx1dX5uIt0HTh7NuGwbhFuJJTY7ZAOy5jQQz
         +iC2ZfihCQG169W7F/pRubduZxZc2WUAM+lGixw5g+ddtR/DeMGqy+m/vGfPuW6UuNqE
         0vb9Yql6Bgik0XB9kw3No9xeR8OMDNuB92V0bh6xvKGAEZOhJArEu0sVcdiTuX05n+75
         dqJVnrbngHqpGoA2P3uJgRb6vBO7LXrUdf31+DX/U00MJdR31s3A2h8Mpltwt+6Cxlqc
         +6IA==
X-Gm-Message-State: APjAAAXlws/hDAwlkPmaxINW9X3rgPUaW2mJ3+Vqz+ThHkRYU57ZUjzU
        KGtUTTz7Xi9JCpx0dlrsJzTnJm6CfLY=
X-Google-Smtp-Source: APXvYqx4jgl6wMC870+RmaBlX4RewIPMc0yLY5sWuP/jaAYWZeSHlRNxTnGTxaxPWoczBf74W1ok3g==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr5125601wma.6.1578669461856;
        Fri, 10 Jan 2020 07:17:41 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id j12sm2532146wrt.55.2020.01.10.07.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:17:40 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id C627B1FF87;
        Fri, 10 Jan 2020 15:17:39 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH] add .editorconfig definition
Date:   Fri, 10 Jan 2020 15:17:27 +0000
Message-Id: <20200110151727.7920-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a editor agnostic configuration file to specify the
indentation style for the project. It is supported by both Emacs and
Vim as well as some other inconsequential editors.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 .editorconfig | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 .editorconfig

diff --git a/.editorconfig b/.editorconfig
new file mode 100644
index 0000000..46d4ac6
--- /dev/null
+++ b/.editorconfig
@@ -0,0 +1,15 @@
+# EditorConfig is a file format and collection of text editor plugins
+# for maintaining consistent coding styles between different editors
+# and IDEs. Most popular editors support this either natively or via
+# plugin.
+#
+# Check https://editorconfig.org for details.
+
+root = true
+
+[*]
+end_of_line = lf
+insert_final_newline = true
+charset = utf-8
+indent_style = tab
+indent_size = 8
-- 
2.20.1

