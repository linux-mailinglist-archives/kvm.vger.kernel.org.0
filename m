Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354CDD814D
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 22:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388006AbfJOUqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 16:46:13 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:39432 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727673AbfJOUqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 16:46:13 -0400
Received: by mail-pf1-f201.google.com with SMTP id b13so16866110pfp.6
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2019 13:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PHU3S8UkmZlEWDDACryJAggjnd+j8fKXKUj4kaokT1g=;
        b=k6bvWpl+ugwFOqGDgu4F/3D3YCFSzLJvWy6NehP1566IJ/9Hvhktfm9tFFGbH4AaX1
         BLmtA2w8obi5HdwAcu9gyRDXygk7502O29YYHVYGVdpgt64G2w/IraYRNJfgKistAO1H
         ApGvPRxVGkWBPcmmxp2scFE7q5k3sHoJc2WZ5B11FNNnwYoX/jLvwAtlIVjIkKcATuLF
         NQ784iuEaVlEm4CBqJMk1GqtyWEFBLfMHLghNIUqZolXoIiJGMrwpnQbp5hh52RocCut
         AQywBTvSsO/L7TTm69ZdkeKpNYkEXlnqL1U8N17E94OlDaxUcqgVZGM6cThbRLFrdXQA
         0tFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PHU3S8UkmZlEWDDACryJAggjnd+j8fKXKUj4kaokT1g=;
        b=AynRL73nU3c5EUa+rpgq/F9+VqZ2jVRvq6T3dRJbFz4L6z5awRE0VqDhXFaHpqXJzt
         8uOTO1PCeNdox2qg3bbxtlmukA/cMGgy6UllwrOov4bs3shGrZjAZWspxph+ugaD6v9T
         WngoOKfSdPOzlx3s8AepbVv8feyvNWQWV0kZCIXi4OatuDB576JsaZvVF4Xk9aL0RQYw
         SqUIDGUqEZamapOWxktE9NFkUpAv6OGonm/Eq6TuaNV9Mn7FlKMaUYtHyzVuvDozkaaq
         R0voJPzj+Mls28RUrrTWbMu9dVN0C83xPuqgpY4sPbAjv2LLDrp62cVkzvMl1W3stMCT
         xNxg==
X-Gm-Message-State: APjAAAX4DQymV1g5aTcpSi01l7wNCeAHnSFM0DTwZTmVjXEWJvdghXAn
        lgeYKN8PC4wPLcyw37BcTChcmdphRhXmMOvxgkviNLmxP9eF4M3WgfUK3X0PpcTs5b/3nq1xxlr
        4CYHQVL8Yk8V1I1qrsSDJuETlZhISShxL7bt+hxpMIW/9eqY6VkiO3g==
X-Google-Smtp-Source: APXvYqxel6aWp6RFarfN6fwhfOh6ejXJp4N/6FYncVOX4wGo05dnLdNldhMDuEKnEI1/6m68VeTSz1CaHA==
X-Received: by 2002:a63:e1f:: with SMTP id d31mr22089103pgl.379.1571172371730;
 Tue, 15 Oct 2019 13:46:11 -0700 (PDT)
Date:   Tue, 15 Oct 2019 13:46:02 -0700
In-Reply-To: <20191015204603.47845-1-morbo@google.com>
Message-Id: <20191015204603.47845-2-morbo@google.com>
Mime-Version: 1.0
References: <20191012074454.208377-1-morbo@google.com> <20191015204603.47845-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests v2 PATCH 1/2] lib: use a status enum for reporting pass/fail
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        thuth@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some values passed into "report" as "pass/fail" are larger than the
size of the parameter. Instead use a status enum so that the size of the
argument no longer matters.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/libcflat.h | 13 +++++++++++--
 lib/report.c   | 24 ++++++++++++------------
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index b6635d9..8765f67 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -95,13 +95,22 @@ extern int vsnprintf(char *buf, int size, const char *fmt, va_list va)
 extern int vprintf(const char *fmt, va_list va)
 					__attribute__((format(printf, 1, 0)));
 
+enum status { PASSED, FAILED };
+
+#define STATUS(x) ((x) != 0 ? PASSED : FAILED)
+
+#define report(msg_fmt, status, ...) \
+	report_status(msg_fmt, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
+#define report_xfail(msg_fmt, xfail, status, ...) \
+	report_xfail_status(msg_fmt, xfail, STATUS(status) __VA_OPT__(,) __VA_ARGS__)
+
 void report_prefix_pushf(const char *prefix_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
-extern void report(const char *msg_fmt, unsigned pass, ...)
+extern void report_status(const char *msg_fmt, enum status status, ...)
 					__attribute__((format(printf, 1, 3)));
-extern void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
+extern void report_xfail_status(const char *msg_fmt, bool xfail, enum status status, ...)
 					__attribute__((format(printf, 1, 4)));
 extern void report_abort(const char *msg_fmt, ...)
 					__attribute__((format(printf, 1, 2)))
diff --git a/lib/report.c b/lib/report.c
index 2a5f549..4ba2ac0 100644
--- a/lib/report.c
+++ b/lib/report.c
@@ -80,12 +80,12 @@ void report_prefix_pop(void)
 	spin_unlock(&lock);
 }
 
-static void va_report(const char *msg_fmt,
-		bool pass, bool xfail, bool skip, va_list va)
+static void va_report(const char *msg_fmt, enum status status, bool xfail,
+               bool skip, va_list va)
 {
 	const char *prefix = skip ? "SKIP"
-				  : xfail ? (pass ? "XPASS" : "XFAIL")
-					  : (pass ? "PASS"  : "FAIL");
+				  : xfail ? (status == PASSED ? "XPASS" : "XFAIL")
+					  : (status == PASSED ? "PASS"  : "FAIL");
 
 	spin_lock(&lock);
 
@@ -96,27 +96,27 @@ static void va_report(const char *msg_fmt,
 	puts("\n");
 	if (skip)
 		skipped++;
-	else if (xfail && !pass)
+	else if (xfail && status == FAILED)
 		xfailures++;
-	else if (xfail || !pass)
+	else if (xfail || status == FAILED)
 		failures++;
 
 	spin_unlock(&lock);
 }
 
-void report(const char *msg_fmt, unsigned pass, ...)
+void report_status(const char *msg_fmt, enum status status, ...)
 {
 	va_list va;
-	va_start(va, pass);
-	va_report(msg_fmt, pass, false, false, va);
+	va_start(va, status);
+	va_report(msg_fmt, status, false, false, va);
 	va_end(va);
 }
 
-void report_xfail(const char *msg_fmt, bool xfail, unsigned pass, ...)
+void report_xfail_status(const char *msg_fmt, bool xfail, enum status status, ...)
 {
 	va_list va;
-	va_start(va, pass);
-	va_report(msg_fmt, pass, xfail, false, va);
+	va_start(va, status);
+	va_report(msg_fmt, status, xfail, false, va);
 	va_end(va);
 }
 
-- 
2.23.0.700.g56cf767bdb-goog

