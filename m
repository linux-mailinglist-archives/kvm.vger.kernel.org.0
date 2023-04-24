Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B876ED83C
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 00:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjDXW7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 18:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232384AbjDXW7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 18:59:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897716E82
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8f606184a3so9578603276.2
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 15:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682377142; x=1684969142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bhYTpUUdtdZNxIvvO/N9vL9exgBimvdMaOOsqthAZDk=;
        b=EbAovieHBKnK2BEvcP3O1w0NK2wQerFqCjj1dL5FCmm8T/fbUdX4mRVrqO+amT8WuQ
         Z0H/YC2FQY42IakAWHTr0nn63RLqSTziE9quCZhkh2+UOfdKj3+ZiaYOPACT0U9YeBPc
         Xf2uOqfXLT3T3CS0eH2OR1LU3NNTMTK684ChZPdKitW2bwe7bsz9yhHUAo2oUdAj+eUg
         HZ6CfNjHpyyMn4GNs2mmVtpkFWHpDo+MbiSHx5dxvj0CKPcIi9T7nf0wOxjqSxt+5xpb
         8lR20BDBMkBE9Z3rrSj0TdYjC7hndvQ5UWMW3UH2GCKNVIevFqIkqJe1GFHd9z8muSYa
         yTsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682377142; x=1684969142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bhYTpUUdtdZNxIvvO/N9vL9exgBimvdMaOOsqthAZDk=;
        b=WOJWCnxTFjbjOk2hADVQI24PwMNFaqnHuVIfaZ7103CWV7pvfkvgregwK8VsIl1hHp
         OKtryJW06w16LBQQj17Xtep1eUl2IEorNf5zup8TNY/oF9qvmbTU2inmus4dATieGLP3
         YgJ8SrmPDNk6YKYyiqF3inJW7NQHGu2oPYz/7iD6D8LD84Wo2bGajlc5FwvOznhCUy9B
         4+Yq5b8UB3ee8MTbIDiLXGJ1flXe8JY9WgR63AOpu6oFCZTO8l+8RCisug7W0YSFSusE
         m0X798illm5wSgXg7k5aucJw7aEfKuLg40pwKgd22whuGHCoAjbqDsDlO5/4zGgoD1Qx
         Ky+g==
X-Gm-Message-State: AAQBX9eqpMLBGHIPXpzScep+sD9Q/V0yo8lLt8AcuodmA0JKOhSz+xGi
        nfUsQug/fXW8vYoKoC9aQ7SCKXqW4cOOvXtsAG3Qzo5Olv0lBZUlvnEnKcbhTIO3JndUcZ5mpDi
        aCW2xicXpJfZNSGJ0fgOBpCabwSBiKGO4Ffj6D0KSgdLdln22gKoYDllXnw7xOs4ai25j
X-Google-Smtp-Source: AKy350ZA9Ze/2wJ/1XV+vcp5mjv261Da5+tAaQjSCHW9sphOmLSpgQKvxK6K01KSTvdFfkryzbjG7JWH5kycqniS
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a25:c905:0:b0:b8f:6b3b:8a0a with SMTP
 id z5-20020a25c905000000b00b8f6b3b8a0amr8268951ybf.6.1682377141796; Mon, 24
 Apr 2023 15:59:01 -0700 (PDT)
Date:   Mon, 24 Apr 2023 22:58:50 +0000
In-Reply-To: <20230424225854.4023978-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230424225854.4023978-3-aaronlewis@google.com>
Subject: [PATCH v2 2/6] KVM: selftests: Add kvm_snprintf() to KVM selftests
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

Add a local version of kvm_snprintf() for use in the guest.

Having a local copy allows the guest access to string formatting
options without dependencies on LIBC.  LIBC is problematic because
it heavily relies on both AVX-512 instructions and a TLS, neither of
which are guaranteed to be set up in the guest.

The file kvm_sprintf.c was lifted from arch/x86/boot/printf.c and
adapted to work in the guest, including the addition of buffer length.
I.e. s/sprintf/snprintf/

The functions where prefixed with "kvm_" to allow guests to explicitly
call them.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/test_util.h |   3 +
 tools/testing/selftests/kvm/lib/kvm_sprintf.c | 313 ++++++++++++++++++
 3 files changed, 317 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/lib/kvm_sprintf.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d93bee00c72a..84b126398729 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -23,6 +23,7 @@ LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/memstress.c
+LIBKVM += lib/kvm_sprintf.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a6e9f215ce70..45cb0dd41412 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -186,4 +186,7 @@ static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
 	return num;
 }
 
+int kvm_vsnprintf(char *buf, int n, const char *fmt, va_list args);
+int kvm_snprintf(char *buf, int n, const char *fmt, ...);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_sprintf.c b/tools/testing/selftests/kvm/lib/kvm_sprintf.c
new file mode 100644
index 000000000000..db369e00a6fc
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/kvm_sprintf.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+
+#define ASSIGN_AND_INC_SAFE(str, end, v) \
+({					 \
+	if (str < end)			 \
+		*str = (v);		 \
+	str++;				 \
+})
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
+			ASSIGN_AND_INC_SAFE(str, end, ' ');
+	if (sign)
+		ASSIGN_AND_INC_SAFE(str, end, sign);
+	if (type & SPECIAL) {
+		if (base == 8)
+			ASSIGN_AND_INC_SAFE(str, end, '0');
+		else if (base == 16) {
+			ASSIGN_AND_INC_SAFE(str, end, '0');
+			ASSIGN_AND_INC_SAFE(str, end, 'x');
+		}
+	}
+	if (!(type & LEFT))
+		while (size-- > 0)
+			ASSIGN_AND_INC_SAFE(str, end, c);
+	while (i < precision--)
+		ASSIGN_AND_INC_SAFE(str, end, '0');
+	while (i-- > 0)
+		ASSIGN_AND_INC_SAFE(str, end, tmp[i]);
+	while (size-- > 0)
+		ASSIGN_AND_INC_SAFE(str, end, ' ');
+
+	return str;
+}
+
+int kvm_vsnprintf(char *buf, int n, const char *fmt, va_list args)
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
+	/* Make sure end is always >= buf */
+	if (end < buf) {
+		end = ((void *)-1);
+		n = end - buf;
+	}
+
+	for (str = buf; *fmt; ++fmt) {
+		if (*fmt != '%') {
+			ASSIGN_AND_INC_SAFE(str, end, *fmt);
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
+					ASSIGN_AND_INC_SAFE(str, end, ' ');
+			ASSIGN_AND_INC_SAFE(str, end,
+					    (uint8_t)va_arg(args, int));
+			while (--field_width > 0)
+				ASSIGN_AND_INC_SAFE(str, end, ' ');
+			continue;
+
+		case 's':
+			s = va_arg(args, char *);
+			len = strnlen(s, precision);
+
+			if (!(flags & LEFT))
+				while (len < field_width--)
+					ASSIGN_AND_INC_SAFE(str, end, ' ');
+			for (i = 0; i < len; ++i)
+				ASSIGN_AND_INC_SAFE(str, end, *s++);
+			while (len < field_width--)
+				ASSIGN_AND_INC_SAFE(str, end, ' ');
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
+			ASSIGN_AND_INC_SAFE(str, end, '%');
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
+			ASSIGN_AND_INC_SAFE(str, end, '%');
+			if (*fmt)
+				ASSIGN_AND_INC_SAFE(str, end, *fmt);
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
+	if (n > 0) {
+		if (str < end)
+			*str = '\0';
+		else
+			end[-1] = '\0';
+	}
+	return str - buf;
+}
+
+int kvm_snprintf(char *buf, int n, const char *fmt, ...)
+{
+	va_list va;
+	int len;
+
+	va_start(va, fmt);
+	len = kvm_vsnprintf(buf, n, fmt, va);
+	va_end(va);
+
+	return len;
+}
-- 
2.40.0.634.g4ca3ef3211-goog

