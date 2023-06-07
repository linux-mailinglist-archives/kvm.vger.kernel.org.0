Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF9E7271EE
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 00:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjFGWpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 18:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjFGWp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 18:45:29 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5584E19AC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 15:45:28 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-528ab7097afso6875824a12.1
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 15:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686177928; x=1688769928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8LMsdweGtjazuBg5g5mPUO7EVRtXft0hLcztlezlTzI=;
        b=RDh9x/Bj8VCgWH+1cb/sncXTGcXbUL1Xhy2erVQYKOWJ2Z0meiQXFzyAiSJ6YUQagg
         3OkV4ERvcdWm3S5VuiY26+i6a78Bu7xt7TNujJRM3ZDnLkX/ksmswhzDKSHSgcuBu+48
         VcWfshZ5LLZAW/r8qGE93/CERnnKhBnEV88ajPWbHpze3VFNzIhAUZikncz+pNUSoNw7
         sLLJohLyQxfszkc9nBeHcWf0nPqIRxi2jkzRi2LoxgFODUT+yjTkzfSVm6mBWcTd0ynX
         UVQPPoBFGgqlZ6/BLyzxXu1oovzzQ2hvy7cxL0o4c+ja1Hfg6eWk9DRqVjctJjbx+7Ek
         S/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686177928; x=1688769928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8LMsdweGtjazuBg5g5mPUO7EVRtXft0hLcztlezlTzI=;
        b=ETZui5N2aTFIl2EoDX/qwHWi7NZ+QOYiDWO5xsuH2Qj/G7fcbYh7Mel8c48PfYXR8m
         cJBT+CLtnRh905F6Nv1WZjDQkS2gq6shrePHHMS5CX1EYdNMV8cahvzCXEI5hclpO49x
         zsQd3W64vBWzcHkX6kY5rIxkS6CXiv+Z7lJ+qsVcSGYR3gBs4wevoa5BDbrvdd1FOZL0
         3gP0lZxiMEulC6Y3zNi50Q8cfcdGtketitQ9g0Uq069vdVkB5lChnW1HynsOrT7EaNU0
         1gxlbbiK9pfQfWfunn5sOQCDr4ZJqSPdWbT75HK99d4D7yXHueonFwM302hHbS9//mvK
         w2bA==
X-Gm-Message-State: AC+VfDxIOm/716cn962iQSIrcRrQc8K5sSU8XKum7bFToY/VYEAXdrGi
        QBNpd+KoFN6GOuK2mJzXBfpcUtRA7d2vQyV9cKMR8FK6d17PKnOMzhmrz855Xl6VDZPrc4uKNb6
        oqWGhC31dnkN5QeZaxHb4PJpwan42xJcd/MP+dtmhiosI6euu8Hg2F4ZRNAsiKXbcNl+b
X-Google-Smtp-Source: ACHHUZ6L1lgws8x1fKeTDpJhBYd6TbHLB/bSmW/bUm3evRPTTOjLUc6fA/LE/DvBwQF5Kc7ARAlFodDNDYc5fQ3b
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a65:408d:0:b0:52c:999a:fce2 with SMTP
 id t13-20020a65408d000000b0052c999afce2mr1519992pgp.10.1686177927694; Wed, 07
 Jun 2023 15:45:27 -0700 (PDT)
Date:   Wed,  7 Jun 2023 22:45:17 +0000
In-Reply-To: <20230607224520.4164598-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230607224520.4164598-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230607224520.4164598-3-aaronlewis@google.com>
Subject: [PATCH v3 2/5] KVM: selftests: Add guest_snprintf() to KVM selftests
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a local version of guest_snprintf() for use in the guest.

Having a local copy allows the guest access to string formatting
options without dependencies on LIBC.  LIBC is problematic because
it heavily relies on both AVX-512 instructions and a TLS, neither of
which are guaranteed to be set up in the guest.

The file guest_sprintf.c was lifted from arch/x86/boot/printf.c and
adapted to work in the guest, including the addition of buffer length.
I.e. s/sprintf/snprintf/

The functions where prefixed with "guest_" to allow guests to
explicitly call them.

A string formatted by this function is expected to succeed or die.  If
something goes wrong during the formatting process a GUEST_ASSERT()
will be thrown.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/test_util.h |   3 +
 .../testing/selftests/kvm/lib/guest_sprintf.c | 307 ++++++++++++++++++
 3 files changed, 311 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/guest_sprintf.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index adbf94cbc67e..efbe7e6d8f9b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -23,6 +23,7 @@ LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/memstress.c
+LIBKVM += lib/guest_sprintf.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a6e9f215ce70..89ecacec328a 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -186,4 +186,7 @@ static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
 	return num;
 }
 
+int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args);
+int guest_snprintf(char *buf, int n, const char *fmt, ...);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/guest_sprintf.c b/tools/testing/selftests/kvm/lib/guest_sprintf.c
new file mode 100644
index 000000000000..c4a69d8aeb68
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/guest_sprintf.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+#include "kvm_util.h"
+#include "ucall_common.h"
+
+#define APPEND_BUFFER_SAFE(str, end, v) \
+do {					\
+	GUEST_ASSERT(str < end);	\
+	*str++ = (v);			\
+} while (0)
+
+static int isdigit(int ch)
+{
+	return (ch >= '0') && (ch <= '9');
+}
+
+static int skip_atoi(const char **s)
+{
+	int i = 0;
+
+	while (isdigit(**s))
+		i = i * 10 + *((*s)++) - '0';
+	return i;
+}
+
+#define ZEROPAD	1		/* pad with zero */
+#define SIGN	2		/* unsigned/signed long */
+#define PLUS	4		/* show plus */
+#define SPACE	8		/* space if plus */
+#define LEFT	16		/* left justified */
+#define SMALL	32		/* Must be 32 == 0x20 */
+#define SPECIAL	64		/* 0x */
+
+#define __do_div(n, base)				\
+({							\
+	int __res;					\
+							\
+	__res = ((uint64_t) n) % (uint32_t) base;	\
+	n = ((uint64_t) n) / (uint32_t) base;		\
+	__res;						\
+})
+
+static char *number(char *str, const char *end, long num, int base, int size,
+		    int precision, int type)
+{
+	/* we are called with base 8, 10 or 16, only, thus don't need "G..."  */
+	static const char digits[16] = "0123456789ABCDEF"; /* "GHIJKLMNOPQRSTUVWXYZ"; */
+
+	char tmp[66];
+	char c, sign, locase;
+	int i;
+
+	/*
+	 * locase = 0 or 0x20. ORing digits or letters with 'locase'
+	 * produces same digits or (maybe lowercased) letters
+	 */
+	locase = (type & SMALL);
+	if (type & LEFT)
+		type &= ~ZEROPAD;
+	if (base < 2 || base > 16)
+		return NULL;
+	c = (type & ZEROPAD) ? '0' : ' ';
+	sign = 0;
+	if (type & SIGN) {
+		if (num < 0) {
+			sign = '-';
+			num = -num;
+			size--;
+		} else if (type & PLUS) {
+			sign = '+';
+			size--;
+		} else if (type & SPACE) {
+			sign = ' ';
+			size--;
+		}
+	}
+	if (type & SPECIAL) {
+		if (base == 16)
+			size -= 2;
+		else if (base == 8)
+			size--;
+	}
+	i = 0;
+	if (num == 0)
+		tmp[i++] = '0';
+	else
+		while (num != 0)
+			tmp[i++] = (digits[__do_div(num, base)] | locase);
+	if (i > precision)
+		precision = i;
+	size -= precision;
+	if (!(type & (ZEROPAD + LEFT)))
+		while (size-- > 0)
+			APPEND_BUFFER_SAFE(str, end, ' ');
+	if (sign)
+		APPEND_BUFFER_SAFE(str, end, sign);
+	if (type & SPECIAL) {
+		if (base == 8)
+			APPEND_BUFFER_SAFE(str, end, '0');
+		else if (base == 16) {
+			APPEND_BUFFER_SAFE(str, end, '0');
+			APPEND_BUFFER_SAFE(str, end, 'x');
+		}
+	}
+	if (!(type & LEFT))
+		while (size-- > 0)
+			APPEND_BUFFER_SAFE(str, end, c);
+	while (i < precision--)
+		APPEND_BUFFER_SAFE(str, end, '0');
+	while (i-- > 0)
+		APPEND_BUFFER_SAFE(str, end, tmp[i]);
+	while (size-- > 0)
+		APPEND_BUFFER_SAFE(str, end, ' ');
+
+	return str;
+}
+
+int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args)
+{
+	char *str, *end;
+	const char *s;
+	uint64_t num;
+	int i, base;
+	int len;
+
+	int flags;		/* flags to number() */
+
+	int field_width;	/* width of output field */
+	int precision;		/*
+				 * min. # of digits for integers; max
+				 * number of chars for from string
+				 */
+	int qualifier;		/* 'h', 'l', or 'L' for integer fields */
+
+	end = buf + n;
+	GUEST_ASSERT(buf < end);
+	GUEST_ASSERT(n > 0);
+
+	for (str = buf; *fmt; ++fmt) {
+		if (*fmt != '%') {
+			APPEND_BUFFER_SAFE(str, end, *fmt);
+			continue;
+		}
+
+		/* process flags */
+		flags = 0;
+repeat:
+		++fmt;		/* this also skips first '%' */
+		switch (*fmt) {
+		case '-':
+			flags |= LEFT;
+			goto repeat;
+		case '+':
+			flags |= PLUS;
+			goto repeat;
+		case ' ':
+			flags |= SPACE;
+			goto repeat;
+		case '#':
+			flags |= SPECIAL;
+			goto repeat;
+		case '0':
+			flags |= ZEROPAD;
+			goto repeat;
+		}
+
+		/* get field width */
+		field_width = -1;
+		if (isdigit(*fmt))
+			field_width = skip_atoi(&fmt);
+		else if (*fmt == '*') {
+			++fmt;
+			/* it's the next argument */
+			field_width = va_arg(args, int);
+			if (field_width < 0) {
+				field_width = -field_width;
+				flags |= LEFT;
+			}
+		}
+
+		/* get the precision */
+		precision = -1;
+		if (*fmt == '.') {
+			++fmt;
+			if (isdigit(*fmt))
+				precision = skip_atoi(&fmt);
+			else if (*fmt == '*') {
+				++fmt;
+				/* it's the next argument */
+				precision = va_arg(args, int);
+			}
+			if (precision < 0)
+				precision = 0;
+		}
+
+		/* get the conversion qualifier */
+		qualifier = -1;
+		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
+			qualifier = *fmt;
+			++fmt;
+		}
+
+		/* default base */
+		base = 10;
+
+		switch (*fmt) {
+		case 'c':
+			if (!(flags & LEFT))
+				while (--field_width > 0)
+					APPEND_BUFFER_SAFE(str, end, ' ');
+			APPEND_BUFFER_SAFE(str, end,
+					    (uint8_t)va_arg(args, int));
+			while (--field_width > 0)
+				APPEND_BUFFER_SAFE(str, end, ' ');
+			continue;
+
+		case 's':
+			s = va_arg(args, char *);
+			len = strnlen(s, precision);
+
+			if (!(flags & LEFT))
+				while (len < field_width--)
+					APPEND_BUFFER_SAFE(str, end, ' ');
+			for (i = 0; i < len; ++i)
+				APPEND_BUFFER_SAFE(str, end, *s++);
+			while (len < field_width--)
+				APPEND_BUFFER_SAFE(str, end, ' ');
+			continue;
+
+		case 'p':
+			if (field_width == -1) {
+				field_width = 2 * sizeof(void *);
+				flags |= SPECIAL | SMALL | ZEROPAD;
+			}
+			str = number(str, end,
+				     (uint64_t)va_arg(args, void *), 16,
+				     field_width, precision, flags);
+			continue;
+
+		case 'n':
+			if (qualifier == 'l') {
+				long *ip = va_arg(args, long *);
+				*ip = (str - buf);
+			} else {
+				int *ip = va_arg(args, int *);
+				*ip = (str - buf);
+			}
+			continue;
+
+		case '%':
+			APPEND_BUFFER_SAFE(str, end, '%');
+			continue;
+
+		/* integer number formats - set up the flags and "break" */
+		case 'o':
+			base = 8;
+			break;
+
+		case 'x':
+			flags |= SMALL;
+		case 'X':
+			base = 16;
+			break;
+
+		case 'd':
+		case 'i':
+			flags |= SIGN;
+		case 'u':
+			break;
+
+		default:
+			APPEND_BUFFER_SAFE(str, end, '%');
+			if (*fmt)
+				APPEND_BUFFER_SAFE(str, end, *fmt);
+			else
+				--fmt;
+			continue;
+		}
+		if (qualifier == 'l')
+			num = va_arg(args, uint64_t);
+		else if (qualifier == 'h') {
+			num = (uint16_t)va_arg(args, int);
+			if (flags & SIGN)
+				num = (int16_t)num;
+		} else if (flags & SIGN)
+			num = va_arg(args, int);
+		else
+			num = va_arg(args, uint32_t);
+		str = number(str, end, num, base, field_width, precision, flags);
+	}
+
+	GUEST_ASSERT(str < end);
+	*str = '\0';
+	return str - buf;
+}
+
+int guest_snprintf(char *buf, int n, const char *fmt, ...)
+{
+	va_list va;
+	int len;
+
+	va_start(va, fmt);
+	len = guest_vsnprintf(buf, n, fmt, va);
+	va_end(va);
+
+	return len;
+}
-- 
2.41.0.rc0.172.g3f132b7071-goog

