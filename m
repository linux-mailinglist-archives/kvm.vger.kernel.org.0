Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3901952DAE9
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 19:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbiESRHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 13:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242358AbiESRHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 13:07:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0482D4AE03
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 10:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652980053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1qwu+QGSD1A0oKbes4afSsO3YuclmXHOTtrc8NiltYI=;
        b=O4Q+WQR9UCGYdDukaJxPy88cd2lzjRrLvueg7qKj42u59gdMRjtJ0VWXRvgO5ZE8XLRqOF
        zZCDaWa5l/yeCe+n4SzB4k17SbEYuTOfeYJfolGym76AgFKPcD+z6V+WabxCNLMggMUZRw
        m0fJpGTnT++hzpyYF+ccGVJgIQD8TPE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-u1-z35ZbOMOCL1I4FrhlBw-1; Thu, 19 May 2022 13:07:29 -0400
X-MC-Unique: u1-z35ZbOMOCL1I4FrhlBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62C453802BA5;
        Thu, 19 May 2022 17:07:29 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.194.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 755412024CAE;
        Thu, 19 May 2022 17:07:27 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, nikos.nikoleris@arm.com
Subject: [PATCH kvm-unit-tests 1/2] lib: Fix whitespace
Date:   Thu, 19 May 2022 19:07:23 +0200
Message-Id: <20220519170724.580956-2-drjones@redhat.com>
In-Reply-To: <20220519170724.580956-1-drjones@redhat.com>
References: <20220519170724.580956-1-drjones@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

printf.c and string.c are a couple of the original files and are
the last that still have the original formatting. Let's finally
clean them up!

The change was done by modifying Linux's scripts/Lindent to use
100 columns instead of 80 and then manually reverting a few
changes that I didn't like, which I found by diffing with -b.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/printf.c | 427 +++++++++++++++++++++++++--------------------------
 lib/string.c | 354 +++++++++++++++++++++---------------------
 2 files changed, 390 insertions(+), 391 deletions(-)

diff --git a/lib/printf.c b/lib/printf.c
index 1269723ef720..383799ec0717 100644
--- a/lib/printf.c
+++ b/lib/printf.c
@@ -10,285 +10,284 @@
 #define BUFSZ 2000
 
 typedef struct pstream {
-    char *buffer;
-    int remain;
-    int added;
+	char *buffer;
+	int remain;
+	int added;
 } pstream_t;
 
 typedef struct strprops {
-    char pad;
-    int npad;
-    bool alternate;
+	char pad;
+	int npad;
+	bool alternate;
 } strprops_t;
 
 static void addchar(pstream_t *p, char c)
 {
-    if (p->remain) {
-	*p->buffer++ = c;
-	--p->remain;
-    }
-    ++p->added;
+	if (p->remain) {
+		*p->buffer++ = c;
+		--p->remain;
+	}
+	++p->added;
 }
 
 static void print_str(pstream_t *p, const char *s, strprops_t props)
 {
-    const char *s_orig = s;
-    int npad = props.npad;
-
-    if (npad > 0) {
-	npad -= strlen(s_orig);
-	while (npad > 0) {
-	    addchar(p, props.pad);
-	    --npad;
+	const char *s_orig = s;
+	int npad = props.npad;
+
+	if (npad > 0) {
+		npad -= strlen(s_orig);
+		while (npad > 0) {
+			addchar(p, props.pad);
+			--npad;
+		}
 	}
-    }
 
-    while (*s)
-	addchar(p, *s++);
+	while (*s)
+		addchar(p, *s++);
 
-    if (npad < 0) {
-	props.pad = ' '; /* ignore '0' flag with '-' flag */
-	npad += strlen(s_orig);
-	while (npad < 0) {
-	    addchar(p, props.pad);
-	    ++npad;
+	if (npad < 0) {
+		props.pad = ' ';	/* ignore '0' flag with '-' flag */
+		npad += strlen(s_orig);
+		while (npad < 0) {
+			addchar(p, props.pad);
+			++npad;
+		}
 	}
-    }
 }
 
 static char digits[16] = "0123456789abcdef";
 
 static void print_int(pstream_t *ps, long long n, int base, strprops_t props)
 {
-    char buf[sizeof(long) * 3 + 2], *p = buf;
-    int s = 0, i;
+	char buf[sizeof(long) * 3 + 2], *p = buf;
+	int s = 0, i;
 
-    if (n < 0) {
-	n = -n;
-	s = 1;
-    }
+	if (n < 0) {
+		n = -n;
+		s = 1;
+	}
 
-    while (n) {
-	*p++ = digits[n % base];
-	n /= base;
-    }
+	while (n) {
+		*p++ = digits[n % base];
+		n /= base;
+	}
 
-    if (s)
-	*p++ = '-';
+	if (s)
+		*p++ = '-';
 
-    if (p == buf)
-	*p++ = '0';
+	if (p == buf)
+		*p++ = '0';
 
-    for (i = 0; i < (p - buf) / 2; ++i) {
-	char tmp;
+	for (i = 0; i < (p - buf) / 2; ++i) {
+		char tmp;
 
-	tmp = buf[i];
-	buf[i] = p[-1-i];
-	p[-1-i] = tmp;
-    }
+		tmp = buf[i];
+		buf[i] = p[-1 - i];
+		p[-1 - i] = tmp;
+	}
 
-    *p = 0;
+	*p = 0;
 
-    print_str(ps, buf, props);
+	print_str(ps, buf, props);
 }
 
 static void print_unsigned(pstream_t *ps, unsigned long long n, int base,
 			   strprops_t props)
 {
-    char buf[sizeof(long) * 3 + 3], *p = buf;
-    int i;
-
-    while (n) {
-	*p++ = digits[n % base];
-	n /= base;
-    }
-
-    if (p == buf)
-	*p++ = '0';
-    else if (props.alternate && base == 16) {
-	if (props.pad == '0') {
-	    addchar(ps, '0');
-	    addchar(ps, 'x');
-
-	    if (props.npad > 0)
-		props.npad = MAX(props.npad - 2, 0);
-	} else {
-	    *p++ = 'x';
-	    *p++ = '0';
+	char buf[sizeof(long) * 3 + 3], *p = buf;
+	int i;
+
+	while (n) {
+		*p++ = digits[n % base];
+		n /= base;
+	}
+
+	if (p == buf)
+		*p++ = '0';
+	else if (props.alternate && base == 16) {
+		if (props.pad == '0') {
+			addchar(ps, '0');
+			addchar(ps, 'x');
+
+			if (props.npad > 0)
+				props.npad = MAX(props.npad - 2, 0);
+		} else {
+			*p++ = 'x';
+			*p++ = '0';
+		}
 	}
-    }
 
-    for (i = 0; i < (p - buf) / 2; ++i) {
-	char tmp;
+	for (i = 0; i < (p - buf) / 2; ++i) {
+		char tmp;
 
-	tmp = buf[i];
-	buf[i] = p[-1-i];
-	p[-1-i] = tmp;
-    }
+		tmp = buf[i];
+		buf[i] = p[-1 - i];
+		p[-1 - i] = tmp;
+	}
 
-    *p = 0;
+	*p = 0;
 
-    print_str(ps, buf, props);
+	print_str(ps, buf, props);
 }
 
 static int fmtnum(const char **fmt)
 {
-    const char *f = *fmt;
-    int len = 0, num;
+	const char *f = *fmt;
+	int len = 0, num;
 
-    if (*f == '-')
-	++f, ++len;
+	if (*f == '-')
+		++f, ++len;
 
-    while (*f >= '0' && *f <= '9')
-	++f, ++len;
+	while (*f >= '0' && *f <= '9')
+		++f, ++len;
 
-    num = atol(*fmt);
-    *fmt += len;
-    return num;
+	num = atol(*fmt);
+	*fmt += len;
+	return num;
 }
 
 int vsnprintf(char *buf, int size, const char *fmt, va_list va)
 {
-    pstream_t s;
-
-    s.buffer = buf;
-    s.remain = size - 1;
-    s.added = 0;
-    while (*fmt) {
-	char f = *fmt++;
-	int nlong = 0;
-	strprops_t props;
-	memset(&props, 0, sizeof(props));
-	props.pad = ' ';
-
-	if (f != '%') {
-	    addchar(&s, f);
-	    continue;
-	}
-    morefmt:
-	f = *fmt++;
-	switch (f) {
-	case '%':
-	    addchar(&s, '%');
-	    break;
-	case 'c':
-            addchar(&s, va_arg(va, int));
-	    break;
-	case '\0':
-	    --fmt;
-	    break;
-	case '#':
-	    props.alternate = true;
-	    goto morefmt;
-	case '0':
-	    props.pad = '0';
-	    ++fmt;
-	    /* fall through */
-	case '1'...'9':
-	case '-':
-	    --fmt;
-	    props.npad = fmtnum(&fmt);
-	    goto morefmt;
-	case 'l':
-	    ++nlong;
-	    goto morefmt;
-	case 't':
-	case 'z':
-	    /* Here we only care that sizeof(size_t) == sizeof(long).
-	     * On a 32-bit platform it doesn't matter that size_t is
-	     * typedef'ed to int or long; va_arg will work either way.
-	     * Same for ptrdiff_t (%td).
-	     */
-	    nlong = 1;
-	    goto morefmt;
-	case 'd':
-	    switch (nlong) {
-	    case 0:
-		print_int(&s, va_arg(va, int), 10, props);
-		break;
-	    case 1:
-		print_int(&s, va_arg(va, long), 10, props);
-		break;
-	    default:
-		print_int(&s, va_arg(va, long long), 10, props);
-		break;
-	    }
-	    break;
-	case 'u':
-	    switch (nlong) {
-	    case 0:
-		print_unsigned(&s, va_arg(va, unsigned), 10, props);
-		break;
-	    case 1:
-		print_unsigned(&s, va_arg(va, unsigned long), 10, props);
-		break;
-	    default:
-		print_unsigned(&s, va_arg(va, unsigned long long), 10, props);
-		break;
-	    }
-	    break;
-	case 'x':
-	    switch (nlong) {
-	    case 0:
-		print_unsigned(&s, va_arg(va, unsigned), 16, props);
-		break;
-	    case 1:
-		print_unsigned(&s, va_arg(va, unsigned long), 16, props);
-		break;
-	    default:
-		print_unsigned(&s, va_arg(va, unsigned long long), 16, props);
-		break;
-	    }
-	    break;
-	case 'p':
-	    props.alternate = true;
-	    print_unsigned(&s, (unsigned long)va_arg(va, void *), 16, props);
-	    break;
-	case 's':
-	    print_str(&s, va_arg(va, const char *), props);
-	    break;
-	default:
-	    addchar(&s, f);
-	    break;
+	pstream_t s;
+
+	s.buffer = buf;
+	s.remain = size - 1;
+	s.added = 0;
+	while (*fmt) {
+		char f = *fmt++;
+		int nlong = 0;
+		strprops_t props;
+		memset(&props, 0, sizeof(props));
+		props.pad = ' ';
+
+		if (f != '%') {
+			addchar(&s, f);
+			continue;
+		}
+morefmt:
+		f = *fmt++;
+		switch (f) {
+		case '%':
+			addchar(&s, '%');
+			break;
+		case 'c':
+			addchar(&s, va_arg(va, int));
+			break;
+		case '\0':
+			--fmt;
+			break;
+		case '#':
+			props.alternate = true;
+			goto morefmt;
+		case '0':
+			props.pad = '0';
+			++fmt;
+			/* fall through */
+		case '1' ... '9':
+		case '-':
+			--fmt;
+			props.npad = fmtnum(&fmt);
+			goto morefmt;
+		case 'l':
+			++nlong;
+			goto morefmt;
+		case 't':
+		case 'z':
+			/* Here we only care that sizeof(size_t) == sizeof(long).
+			 * On a 32-bit platform it doesn't matter that size_t is
+			 * typedef'ed to int or long; va_arg will work either way.
+			 * Same for ptrdiff_t (%td).
+			 */
+			nlong = 1;
+			goto morefmt;
+		case 'd':
+			switch (nlong) {
+			case 0:
+				print_int(&s, va_arg(va, int), 10, props);
+				break;
+			case 1:
+				print_int(&s, va_arg(va, long), 10, props);
+				break;
+			default:
+				print_int(&s, va_arg(va, long long), 10, props);
+				break;
+			}
+			break;
+		case 'u':
+			switch (nlong) {
+			case 0:
+				print_unsigned(&s, va_arg(va, unsigned), 10, props);
+				break;
+			case 1:
+				print_unsigned(&s, va_arg(va, unsigned long), 10, props);
+				break;
+			default:
+				print_unsigned(&s, va_arg(va, unsigned long long), 10, props);
+				break;
+			}
+			break;
+		case 'x':
+			switch (nlong) {
+			case 0:
+				print_unsigned(&s, va_arg(va, unsigned), 16, props);
+				break;
+			case 1:
+				print_unsigned(&s, va_arg(va, unsigned long), 16, props);
+				break;
+			default:
+				print_unsigned(&s, va_arg(va, unsigned long long), 16, props);
+				break;
+			}
+			break;
+		case 'p':
+			props.alternate = true;
+			print_unsigned(&s, (unsigned long)va_arg(va, void *), 16, props);
+			break;
+		case 's':
+			print_str(&s, va_arg(va, const char *), props);
+			break;
+		default:
+			addchar(&s, f);
+			break;
+		}
 	}
-    }
-    *s.buffer = 0;
-    return s.added;
+	*s.buffer = 0;
+	return s.added;
 }
 
-
 int snprintf(char *buf, int size, const char *fmt, ...)
 {
-    va_list va;
-    int r;
+	va_list va;
+	int r;
 
-    va_start(va, fmt);
-    r = vsnprintf(buf, size, fmt, va);
-    va_end(va);
-    return r;
+	va_start(va, fmt);
+	r = vsnprintf(buf, size, fmt, va);
+	va_end(va);
+	return r;
 }
 
 int vprintf(const char *fmt, va_list va)
 {
-    char buf[BUFSZ];
-    int r;
+	char buf[BUFSZ];
+	int r;
 
-    r = vsnprintf(buf, sizeof(buf), fmt, va);
-    puts(buf);
-    return r;
+	r = vsnprintf(buf, sizeof(buf), fmt, va);
+	puts(buf);
+	return r;
 }
 
 int printf(const char *fmt, ...)
 {
-    va_list va;
-    char buf[BUFSZ];
-    int r;
-
-    va_start(va, fmt);
-    r = vsnprintf(buf, sizeof buf, fmt, va);
-    va_end(va);
-    puts(buf);
-    return r;
+	va_list va;
+	char buf[BUFSZ];
+	int r;
+
+	va_start(va, fmt);
+	r = vsnprintf(buf, sizeof buf, fmt, va);
+	va_end(va);
+	puts(buf);
+	return r;
 }
 
 void binstr(unsigned long x, char out[BINSTR_SZ])
diff --git a/lib/string.c b/lib/string.c
index 27106dae0b0b..a3a8f3b1ce0b 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -11,281 +11,281 @@
 
 size_t strlen(const char *buf)
 {
-    size_t len = 0;
+	size_t len = 0;
 
-    while (*buf++)
-	++len;
-    return len;
+	while (*buf++)
+		++len;
+	return len;
 }
 
 size_t strnlen(const char *buf, size_t maxlen)
 {
-    const char *sc;
+	const char *sc;
 
-    for (sc = buf; maxlen-- && *sc != '\0'; ++sc)
-        /* nothing */;
-    return sc - buf;
+	for (sc = buf; maxlen-- && *sc != '\0'; ++sc)
+		/* nothing */ ;
+	return sc - buf;
 }
 
 char *strcat(char *dest, const char *src)
 {
-    char *p = dest;
+	char *p = dest;
 
-    while (*p)
-	++p;
-    while ((*p++ = *src++) != 0)
-	;
-    return dest;
+	while (*p)
+		++p;
+	while ((*p++ = *src++) != 0)
+		;
+	return dest;
 }
 
 char *strcpy(char *dest, const char *src)
 {
-    *dest = 0;
-    return strcat(dest, src);
+	*dest = 0;
+	return strcat(dest, src);
 }
 
 int strncmp(const char *a, const char *b, size_t n)
 {
-    for (; n--; ++a, ++b)
-        if (*a != *b || *a == '\0')
-            return *a - *b;
+	for (; n--; ++a, ++b)
+		if (*a != *b || *a == '\0')
+			return *a - *b;
 
-    return 0;
+	return 0;
 }
 
 int strcmp(const char *a, const char *b)
 {
-    return strncmp(a, b, SIZE_MAX);
+	return strncmp(a, b, SIZE_MAX);
 }
 
 char *strchr(const char *s, int c)
 {
-    while (*s != (char)c)
-	if (*s++ == '\0')
-	    return NULL;
-    return (char *)s;
+	while (*s != (char)c)
+		if (*s++ == '\0')
+			return NULL;
+	return (char *)s;
 }
 
 char *strrchr(const char *s, int c)
 {
-    const char *last = NULL;
-    do {
-        if (*s == (char)c)
-            last = s;
-    } while (*s++);
-    return (char *)last;
+	const char *last = NULL;
+	do {
+		if (*s == (char)c)
+			last = s;
+	} while (*s++);
+	return (char *)last;
 }
 
 char *strchrnul(const char *s, int c)
 {
-    while (*s && *s != (char)c)
-        s++;
-    return (char *)s;
+	while (*s && *s != (char)c)
+		s++;
+	return (char *)s;
 }
 
 char *strstr(const char *s1, const char *s2)
 {
-    size_t l1, l2;
-
-    l2 = strlen(s2);
-    if (!l2)
-	return (char *)s1;
-    l1 = strlen(s1);
-    while (l1 >= l2) {
-	l1--;
-	if (!memcmp(s1, s2, l2))
-	    return (char *)s1;
-	s1++;
-    }
-    return NULL;
+	size_t l1, l2;
+
+	l2 = strlen(s2);
+	if (!l2)
+		return (char *)s1;
+	l1 = strlen(s1);
+	while (l1 >= l2) {
+		l1--;
+		if (!memcmp(s1, s2, l2))
+			return (char *)s1;
+		s1++;
+	}
+	return NULL;
 }
 
 void *memset(void *s, int c, size_t n)
 {
-    size_t i;
-    char *a = s;
+	size_t i;
+	char *a = s;
 
-    for (i = 0; i < n; ++i)
-        a[i] = c;
+	for (i = 0; i < n; ++i)
+		a[i] = c;
 
-    return s;
+	return s;
 }
 
 void *memcpy(void *dest, const void *src, size_t n)
 {
-    size_t i;
-    char *a = dest;
-    const char *b = src;
+	size_t i;
+	char *a = dest;
+	const char *b = src;
 
-    for (i = 0; i < n; ++i)
-        a[i] = b[i];
+	for (i = 0; i < n; ++i)
+		a[i] = b[i];
 
-    return dest;
+	return dest;
 }
 
 int memcmp(const void *s1, const void *s2, size_t n)
 {
-    const unsigned char *a = s1, *b = s2;
-    int ret = 0;
-
-    while (n--) {
-	ret = *a - *b;
-	if (ret)
-	    break;
-	++a, ++b;
-    }
-    return ret;
+	const unsigned char *a = s1, *b = s2;
+	int ret = 0;
+
+	while (n--) {
+		ret = *a - *b;
+		if (ret)
+			break;
+		++a, ++b;
+	}
+	return ret;
 }
 
 void *memmove(void *dest, const void *src, size_t n)
 {
-    const unsigned char *s = src;
-    unsigned char *d = dest;
-
-    if (d <= s) {
-	while (n--)
-	    *d++ = *s++;
-    } else {
-	d += n, s += n;
-	while (n--)
-	    *--d = *--s;
-    }
-    return dest;
+	const unsigned char *s = src;
+	unsigned char *d = dest;
+
+	if (d <= s) {
+		while (n--)
+			*d++ = *s++;
+	} else {
+		d += n, s += n;
+		while (n--)
+			*--d = *--s;
+	}
+	return dest;
 }
 
 void *memchr(const void *s, int c, size_t n)
 {
-    const unsigned char *str = s, chr = (unsigned char)c;
+	const unsigned char *str = s, chr = (unsigned char)c;
 
-    while (n--)
-	if (*str++ == chr)
-	    return (void *)(str - 1);
-    return NULL;
+	while (n--)
+		if (*str++ == chr)
+			return (void *)(str - 1);
+	return NULL;
 }
 
 static int isspace(int c)
 {
-    return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
+	return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
 }
 
 static unsigned long long __strtoll(const char *nptr, char **endptr,
-                                    int base, bool is_signed,
-                                    bool is_longlong) {
-    unsigned long long ull = 0;
-    const char *s = nptr;
-    int neg, c;
-
-    assert(base == 0 || (base >= 2 && base <= 36));
-
-    while (isspace(*s))
-        s++;
-
-    if (*s == '-') {
-        neg = 1;
-        s++;
-    } else {
-        neg = 0;
-        if (*s == '+')
-            s++;
-    }
-
-    if (base == 0 || base == 16) {
-        if (*s == '0') {
-            s++;
-            if (*s == 'x' || *s == 'X') {
-                 s++;
-                 base = 16;
-            } else if (base == 0)
-                 base = 8;
-        } else if (base == 0)
-            base = 10;
-    }
-
-    while (*s) {
-        if (*s >= '0' && *s < '0' + base && *s <= '9')
-            c = *s - '0';
-        else if (*s >= 'a' && *s < 'a' + base - 10)
-            c = *s - 'a' + 10;
-        else if (*s >= 'A' && *s < 'A' + base - 10)
-            c = *s - 'A' + 10;
-        else
-            break;
-
-        if (!is_longlong) {
-            if (is_signed) {
-                long sl = (long)ull;
-                assert(!check_mul_overflow(sl, base));
-                assert(!check_add_overflow(sl * base, c));
-            } else {
-                unsigned long ul = (unsigned long)ull;
-                assert(!check_mul_overflow(ul, base));
-                assert(!check_add_overflow(ul * base, c));
-            }
-        } else {
-            if (is_signed) {
-                long long sll = (long long)ull;
-                assert(!check_mul_overflow(sll, base));
-                assert(!check_add_overflow(sll * base, c));
-            } else {
-                assert(!check_mul_overflow(ull, base));
-                assert(!check_add_overflow(ull * base, c));
-            }
-        }
-
-        ull = ull * base + c;
-        s++;
-    }
-
-    if (neg)
-        ull = -ull;
-
-    if (endptr)
-        *endptr = (char *)s;
-
-    return ull;
+				    int base, bool is_signed, bool is_longlong)
+{
+	unsigned long long ull = 0;
+	const char *s = nptr;
+	int neg, c;
+
+	assert(base == 0 || (base >= 2 && base <= 36));
+
+	while (isspace(*s))
+		s++;
+
+	if (*s == '-') {
+		neg = 1;
+		s++;
+	} else {
+		neg = 0;
+		if (*s == '+')
+			s++;
+	}
+
+	if (base == 0 || base == 16) {
+		if (*s == '0') {
+			s++;
+			if (*s == 'x' || *s == 'X') {
+				s++;
+				base = 16;
+			} else if (base == 0)
+				base = 8;
+		} else if (base == 0)
+			base = 10;
+	}
+
+	while (*s) {
+		if (*s >= '0' && *s < '0' + base && *s <= '9')
+			c = *s - '0';
+		else if (*s >= 'a' && *s < 'a' + base - 10)
+			c = *s - 'a' + 10;
+		else if (*s >= 'A' && *s < 'A' + base - 10)
+			c = *s - 'A' + 10;
+		else
+			break;
+
+		if (!is_longlong) {
+			if (is_signed) {
+				long sl = (long)ull;
+				assert(!check_mul_overflow(sl, base));
+				assert(!check_add_overflow(sl * base, c));
+			} else {
+				unsigned long ul = (unsigned long)ull;
+				assert(!check_mul_overflow(ul, base));
+				assert(!check_add_overflow(ul * base, c));
+			}
+		} else {
+			if (is_signed) {
+				long long sll = (long long)ull;
+				assert(!check_mul_overflow(sll, base));
+				assert(!check_add_overflow(sll * base, c));
+			} else {
+				assert(!check_mul_overflow(ull, base));
+				assert(!check_add_overflow(ull * base, c));
+			}
+		}
+
+		ull = ull * base + c;
+		s++;
+	}
+
+	if (neg)
+		ull = -ull;
+
+	if (endptr)
+		*endptr = (char *)s;
+
+	return ull;
 }
 
 long int strtol(const char *nptr, char **endptr, int base)
 {
-    return __strtoll(nptr, endptr, base, true, false);
+	return __strtoll(nptr, endptr, base, true, false);
 }
 
 unsigned long int strtoul(const char *nptr, char **endptr, int base)
 {
-    return __strtoll(nptr, endptr, base, false, false);
+	return __strtoll(nptr, endptr, base, false, false);
 }
 
 long long int strtoll(const char *nptr, char **endptr, int base)
 {
-    return __strtoll(nptr, endptr, base, true, true);
+	return __strtoll(nptr, endptr, base, true, true);
 }
 
 unsigned long long int strtoull(const char *nptr, char **endptr, int base)
 {
-    return __strtoll(nptr, endptr, base, false, true);
+	return __strtoll(nptr, endptr, base, false, true);
 }
 
 long atol(const char *ptr)
 {
-    return strtol(ptr, NULL, 10);
+	return strtol(ptr, NULL, 10);
 }
 
 extern char **environ;
 
 char *getenv(const char *name)
 {
-    char **envp = environ, *delim;
-    int len;
-
-    while (*envp) {
-        delim = strchr(*envp, '=');
-        assert(delim);
-        len = delim - *envp;
-        if (memcmp(name, *envp, len) == 0 && !name[len])
-            return delim + 1;
-        ++envp;
-    }
-    return NULL;
+	char **envp = environ, *delim;
+	int len;
+
+	while (*envp) {
+		delim = strchr(*envp, '=');
+		assert(delim);
+		len = delim - *envp;
+		if (memcmp(name, *envp, len) == 0 && !name[len])
+			return delim + 1;
+		++envp;
+	}
+	return NULL;
 }
 
 /* Very simple glob matching. Allows '*' at beginning and end of pattern. */
-- 
2.34.3

