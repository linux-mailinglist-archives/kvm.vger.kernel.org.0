Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66ACA2E1108
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 02:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgLWBJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 20:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLWBJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 20:09:34 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D9DC061793
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:54 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 91so16938743wrj.7
        for <kvm@vger.kernel.org>; Tue, 22 Dec 2020 17:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AELlSdlZPX/Uv45zWP6w9R8ftpPQUV4UnQSCu6+uF+8=;
        b=iJ5Lq6x5oXdPH/BMfQ4sZoNOlrdKRMJpI9JBsiIlij3bJheLzlzq/4kqbK/UYTYREN
         nPqFgiD6f7YUMY1+bpekRCna7wp2FTBNluFlRoMqGso6SV8RXKVK5+EsZifCaJTnsXH9
         o6zFYovJ6p4cGaf1K6ydfFX+y73ikQbNlMuq3xbmmoDWiQa6wstKW+i8Q/3b750iuapG
         Cx6Z9HMO6ttvjAGi1hY2sj0OkyBItKtFNavTuFrZuWtjAwZGwVG7B/13mJB9GRkxJi4W
         scMao0Krzku57Do854uSpeRK8gHIpxE5PcbTavk1EiFj+LiT2eTzOhplH28dXsWq2Anw
         68aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=AELlSdlZPX/Uv45zWP6w9R8ftpPQUV4UnQSCu6+uF+8=;
        b=KtaYgPhB9lEL4JM7PjBETxdY1ibjfgmuhY2kl76Du7HrDRzRdS4Mb6FxVHoaRhpwIC
         WoRgnuQG0QtQcsRkveAB6sEaBd7toAC7urecQflhLqc3e8nMJHIavu658yzAdS8rdlos
         eUnTmP7DG2Il7RTaMM+AlNL+8EJ/dxncOBenS3QU6tQK2zSgg55NeTogU79zhuEspr69
         O7aoEkZRdF0VNE4TEqPYt7YqJrEmb0zhfn/nfZXqM7BWGryRqhiLkmnstjDFpfCNt5QF
         eSQCn6HrdzO63YKmMCpMxuKcOmoD46K49OqbXJI/oHR2gAN4ClO5L8+R+SMB0x66vODe
         3iXA==
X-Gm-Message-State: AOAM530xn3D9gQkPhJMUtKnlHgF/t2RPaW2Dh3mTSbbxP3Kpyuvhxvv2
        +5J/PMVvuhWI+r6w3YD5OULaZOVcU80=
X-Google-Smtp-Source: ABdhPJwP6r5DdIbENK4G0rivMdNV1Dxj2qYlxZH4ov4r14vc0sIodi+kIv5yNChc3aOOylLHD2YcBQ==
X-Received: by 2002:a5d:4641:: with SMTP id j1mr27013669wrs.94.1608685733191;
        Tue, 22 Dec 2020 17:08:53 -0800 (PST)
Received: from avogadro.lan ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id h83sm30995047wmf.9.2020.12.22.17.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 17:08:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH kvm-unit-tests 1/4] libcflat: add a few more runtime functions
Date:   Wed, 23 Dec 2020 02:08:47 +0100
Message-Id: <20201223010850.111882-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223010850.111882-1-pbonzini@redhat.com>
References: <20201223010850.111882-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These functions will be used to parse the chaos test's command line.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/alloc.c    |  9 +++++++-
 lib/alloc.h    |  1 +
 lib/libcflat.h |  4 +++-
 lib/string.c   | 59 +++++++++++++++++++++++++++++++++++++++++++++++---
 lib/string.h   |  3 +++
 5 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/lib/alloc.c b/lib/alloc.c
index a46f464..a56f664 100644
--- a/lib/alloc.c
+++ b/lib/alloc.c
@@ -1,7 +1,7 @@
 #include "alloc.h"
 #include "bitops.h"
 #include "asm/page.h"
-#include "bitops.h"
+#include "string.h"
 
 void *malloc(size_t size)
 {
@@ -50,6 +50,13 @@ void *calloc(size_t nmemb, size_t size)
 	return ptr;
 }
 
+char *strdup(const char *s)
+{
+	size_t len = strlen(s) + 1;
+	char *d = malloc(len);
+	return strcpy(d, s);
+}
+
 void free(void *ptr)
 {
 	if (alloc_ops->free)
diff --git a/lib/alloc.h b/lib/alloc.h
index 9b4b634..4139465 100644
--- a/lib/alloc.h
+++ b/lib/alloc.h
@@ -34,5 +34,6 @@ void *malloc(size_t size);
 void *calloc(size_t nmemb, size_t size);
 void free(void *ptr);
 void *memalign(size_t alignment, size_t size);
+char *strdup(const char *s);
 
 #endif /* _ALLOC_H_ */
diff --git a/lib/libcflat.h b/lib/libcflat.h
index 460a123..7d5d02e 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -80,9 +80,11 @@ extern int __getchar(void);
 extern int getchar(void);
 extern void exit(int code) __attribute__((noreturn));
 extern void abort(void) __attribute__((noreturn));
-extern long atol(const char *ptr);
 extern char *getenv(const char *name);
 
+extern long atol(const char *ptr);
+extern int parse_long(const char *s, long *num);
+
 extern int printf(const char *fmt, ...)
 					__attribute__((format(printf, 1, 2)));
 extern int snprintf(char *buf, int size, const char *fmt, ...)
diff --git a/lib/string.c b/lib/string.c
index 75257f5..1ebefcb 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -135,10 +135,9 @@ void *memchr(const void *s, int c, size_t n)
     return NULL;
 }
 
-long atol(const char *ptr)
+int parse_long(const char *s, long *num)
 {
     long acc = 0;
-    const char *s = ptr;
     int neg, c;
 
     while (*s == ' ' || *s == '\t')
@@ -163,7 +162,15 @@ long atol(const char *ptr)
     if (neg)
         acc = -acc;
 
-    return acc;
+    *num = acc;
+    return !*s;
+}
+
+long atol(const char *ptr)
+{
+	long num;
+	parse_long(ptr, &num);
+	return num;
 }
 
 extern char **environ;
@@ -224,3 +231,49 @@ bool simple_glob(const char *text, const char *pattern)
 
 	return !strcmp(text, copy);
 }
+
+/* Based on musl libc.  */
+#define BITOP(a,b,op) \
+ ((a)[(size_t)(b)/(8*sizeof *(a))] op (size_t)1<<((size_t)(b)%(8*sizeof *(a))))
+
+size_t strcspn(const char *s, const char *c)
+{
+	const char *a = s;
+	size_t byteset[32/sizeof(size_t)] = { 0 };
+
+	if (!c[0])
+		return 0;
+	if (!c[1]) {
+		while (*s != *c)
+			s++;
+	} else {
+		while (*c) {
+			BITOP(byteset, *(unsigned char *)c, |=);
+			c++;
+		}
+		while (*s && !BITOP(byteset, *(unsigned char *)s, &))
+			s++;
+	}
+	return s - a;
+}
+
+/*
+ * Slightly more flexible strsep.  The pointer to the token
+ * must be stashed by the caller, the delimiter is the return value.
+ */
+char strdelim(char **p, const char *sep)
+{
+	char *e;
+	char *s = *p;
+	char delim;
+
+	e = s + strcspn(s, sep);
+	delim = *e;
+	if (delim) {
+		*e = 0;
+		*p = ++e;
+	} else {
+		*p = e;
+	}
+	return delim;
+}
diff --git a/lib/string.h b/lib/string.h
index 493d51b..da31668 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -20,4 +20,7 @@ extern int memcmp(const void *s1, const void *s2, size_t n);
 extern void *memmove(void *dest, const void *src, size_t n);
 extern void *memchr(const void *s, int c, size_t n);
 
+size_t strcspn(const char *s, const char *c);
+char strdelim(char **p, const char *sep);
+
 #endif /* _STRING_H */
-- 
2.29.2


