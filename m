Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D376D4E43
	for <lists+kvm@lfdr.de>; Sat, 12 Oct 2019 10:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfJLIUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Oct 2019 04:20:21 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:44386 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfJLIUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Oct 2019 04:20:21 -0400
Received: by mail-pg1-f201.google.com with SMTP id z7so8624735pgk.11
        for <kvm@vger.kernel.org>; Sat, 12 Oct 2019 01:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rOseJJCccx3BXbm8CgRKxIjZpwpktd5KdYgAOg8B8/A=;
        b=RRhy1dxupblwHgfUSaSASGlWUlPCu3Tb/qpehXDWEkLfM2gmN70yWulMLYahTlCBVG
         OB62bFiMSlX2ii4EFInumZgGZMrGdbGxOOZhzqhTS1/4DLbrv9sJjfxGAFYpWlDBpDUV
         ojtG8qUsY/uqz9wh1a5vP0HgvcxRe8EqzlqKZWI6O+6nm9d6vzFcZulrwPYyxNfelr17
         voeJ1IFoAopxwymvkNUDkNJP0jIQ4kgBLlbmtfxJubGKf0J25PAcOlA5iRu3VDKq6odj
         0ZkOjF6h1ZMTp/fxn5xObOWFDK5KnsuWrdEDkrxiPs+G3R/FoItwxsTUfxOxcrgCQzwZ
         lEVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rOseJJCccx3BXbm8CgRKxIjZpwpktd5KdYgAOg8B8/A=;
        b=AeHxw1Yrr2NNem3WyR1fP2Y+v3QpZljyTDn7d0XX1dQbLEZbZ6KokWWXRI1DMaoG7k
         a0LG9Gp5Wy0Cfm/irB6CvS9WWviCZz4M9EK9H1tNiYFovMOgwdcGNeo3rNZ6OVfcsVA9
         ttMX3O44mkzod0VeqxI/TSxT6zdh+BsH6iIBfjIpbUwOro5APDC4ugqBVtTW4wA9HR0h
         47JzQEiFPJXtyLl6n24BNB2MnGTk9ZgQJLZDdT+sHDCE+kmKiXcTLy2aLCJPQTHjPzNX
         Ef1pNh+OMTElrIeJfEHUdreAACs0phMFViL9ldhz2KxQ4tEJgxDaLL8DcBl9CcwT7qlC
         YHjg==
X-Gm-Message-State: APjAAAX3fSf7i9sttHApW1RJh9mnzdJ+77YoYhq8ff6dEutGAy6W1/0C
        mSZW8aZ+Cfplc86Z2XAZcm5x0Gmxj2Ov1VxkVjHAK1STER2r8mXMjs6xtmJwXkWeKwpqb5mScKp
        Zv+mhICJ8+TdNO11eonkMFgK6QxjQWAXwYQSMyhJs8+7YnexiRjm1qw==
X-Google-Smtp-Source: APXvYqwlzzolXzxit6WcEKfVzjjviTWu3HKyKqEjuDmMG6w576LSgRG8HbwuoYMhfI+jOX0A/ihrlEEgyg==
X-Received: by 2002:a65:5249:: with SMTP id q9mr15158097pgp.390.1570868420101;
 Sat, 12 Oct 2019 01:20:20 -0700 (PDT)
Date:   Sat, 12 Oct 2019 01:20:15 -0700
In-Reply-To: <20191012074454.208377-1-morbo@google.com>
Message-Id: <20191012082015.247954-1-morbo@google.com>
Mime-Version: 1.0
References: <20191012074454.208377-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 2/2] Use a status enum for reporting pass/fail
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some values passed into "report" as "pass/fail" are larger than the
size of the parameter. Use instead a status enum so that the size of the
argument no longer matters.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/libcflat.h | 14 ++++++++++++--
 lib/report.c   | 24 ++++++++++++------------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index b6635d9..847c24f 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -95,13 +95,23 @@ extern int vsnprintf(char *buf, int size, const char *fmt, va_list va)
 extern int vprintf(const char *fmt, va_list va)
 					__attribute__((format(printf, 1, 0)));
 
+enum status { PASSED, FAILED };
+
+#define STATUS(x) ((x) != 0 ? PASSED : FAILED)
+
+#define VA_ARGS(...) , ##__VA_ARGS__
+#define report(msg_fmt, status, ...) \
+	report_status(msg_fmt, STATUS(status) VA_ARGS(__VA_ARGS__))
+#define report_xfail(msg_fmt, xfail, status, ...) \
+	report_xfail_status(msg_fmt, xfail, STATUS(status) VA_ARGS(__VA_ARGS__))
+
 void report_prefix_pushf(const char *prefix_fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern void report_prefix_push(const char *prefix);
 extern void report_prefix_pop(void);
-extern void report(const char *msg_fmt, unsigned pass, ...)
+extern void report_status(const char *msg_fmt, unsigned pass, ...)
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

