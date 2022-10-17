Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135C1601850
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 21:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJQT6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 15:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJQT6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 15:58:47 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C29786F9
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-360b9418f64so119122087b3.7
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 12:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QkRwLMy5RwIV/exnh+1hPOodeGM8Loprdb0EiejIoEo=;
        b=XJHny5Jynl6SvyiO0fVqPl0BPVfp4DLLTzi5SUqVJLQZrNgzGGjdnt0VwBTtObEKAB
         /roZoLcoyt2/17y6JqYhxHNqDW5oUkjn3HGvaXcF1iwxXHn+JPnleOx/9lari0usspdK
         w7jHBR97ahJZLZYg4HHqyW3DO6EFfZZkKONlEqvt41on5EOtNbd2YgWkaRP9hj7Wc0Da
         OoVC4+tmmj4zjsHO2oFIkKKRed6xjYhIixru1OnUXeeiqoJ8SHGrxzsU1cb3+DS4pbA7
         REOZLU7mTxOyzbg+LH34rL+0V1RRZkw/OmowZgrFg1ucnxNv9AM77heVnuEbMlaKtI26
         +ugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QkRwLMy5RwIV/exnh+1hPOodeGM8Loprdb0EiejIoEo=;
        b=mOXloHzX3qCrAV/VdPy0PrTmQeCKPHoHupf9CEjlxUO7WT3deLUr8iRXyPPpx7j0Y9
         0w1H9t6VPLQMvmCGpcQbmEMxYoMe3VnLm2eJTyS7FcUdKqUsralYXcC29QsqZG6XvkpU
         3DXSW7IKkHJDxyZxibPN1Tp2/KDLK3j9B8n3QAFX7/o5PbZtCsXFt+eszU7HB1u4zdlk
         CEPC+jPKpYqK6XIImYIlai0+lX9OBtqsTcGZA85RwtiWtByUVcvsQXyb3qz4I96sZ/Nm
         2gXaQ7RYfN8N9xyDdcIj+auQ1sZ+YRjr8lmxfJh0+j+BiUvKKBetIt6MmmUW82GXxSGx
         sVfA==
X-Gm-Message-State: ACrzQf1dYezqKgVIifrrwF13uu+8kLcvfXyguHuF5j6zXhi9GNSnOfUR
        ozRvfLVFiqoLegjfw59HYYY86WM91sZbVyzM9klgg6aqcDB7ZvIE96BC1rSNzX7SNgYScwDu3t6
        S5YDnujPFDklZi9vLlUAOT+tfe7wmCTtnGSrxzwQonUMO568MQBHcQdoyVIIzttU=
X-Google-Smtp-Source: AMsMyM6mdt5SA5X14bNCJQsRta5lRxmJyAAtpow4ih5A/Uqvpug2MGXT+yKsVfjPcuSzfkGp6JMQ1OaJLYjEfQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:9983:0:b0:6bc:71fb:75fe with SMTP id
 p3-20020a259983000000b006bc71fb75femr10802134ybo.393.1666036725139; Mon, 17
 Oct 2022 12:58:45 -0700 (PDT)
Date:   Mon, 17 Oct 2022 19:58:25 +0000
In-Reply-To: <20221017195834.2295901-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221017195834.2295901-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221017195834.2295901-6-ricarkol@google.com>
Subject: [PATCH v10 05/14] tools: Copy bitfield.h from the kernel sources
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Copy bitfield.h from include/linux/bitfield.h.  A subsequent change will
make use of some FIELD_{GET,PREP} macros defined in this header.

The header was copied as-is, no changes needed.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/include/linux/bitfield.h | 176 +++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)
 create mode 100644 tools/include/linux/bitfield.h

diff --git a/tools/include/linux/bitfield.h b/tools/include/linux/bitfield.h
new file mode 100644
index 000000000000..6093fa6db260
--- /dev/null
+++ b/tools/include/linux/bitfield.h
@@ -0,0 +1,176 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+ */
+
+#ifndef _LINUX_BITFIELD_H
+#define _LINUX_BITFIELD_H
+
+#include <linux/build_bug.h>
+#include <asm/byteorder.h>
+
+/*
+ * Bitfield access macros
+ *
+ * FIELD_{GET,PREP} macros take as first parameter shifted mask
+ * from which they extract the base mask and shift amount.
+ * Mask must be a compilation time constant.
+ *
+ * Example:
+ *
+ *  #define REG_FIELD_A  GENMASK(6, 0)
+ *  #define REG_FIELD_B  BIT(7)
+ *  #define REG_FIELD_C  GENMASK(15, 8)
+ *  #define REG_FIELD_D  GENMASK(31, 16)
+ *
+ * Get:
+ *  a = FIELD_GET(REG_FIELD_A, reg);
+ *  b = FIELD_GET(REG_FIELD_B, reg);
+ *
+ * Set:
+ *  reg = FIELD_PREP(REG_FIELD_A, 1) |
+ *	  FIELD_PREP(REG_FIELD_B, 0) |
+ *	  FIELD_PREP(REG_FIELD_C, c) |
+ *	  FIELD_PREP(REG_FIELD_D, 0x40);
+ *
+ * Modify:
+ *  reg &= ~REG_FIELD_C;
+ *  reg |= FIELD_PREP(REG_FIELD_C, c);
+ */
+
+#define __bf_shf(x) (__builtin_ffsll(x) - 1)
+
+#define __scalar_type_to_unsigned_cases(type)				\
+		unsigned type:	(unsigned type)0,			\
+		signed type:	(unsigned type)0
+
+#define __unsigned_scalar_typeof(x) typeof(				\
+		_Generic((x),						\
+			char:	(unsigned char)0,			\
+			__scalar_type_to_unsigned_cases(char),		\
+			__scalar_type_to_unsigned_cases(short),		\
+			__scalar_type_to_unsigned_cases(int),		\
+			__scalar_type_to_unsigned_cases(long),		\
+			__scalar_type_to_unsigned_cases(long long),	\
+			default: (x)))
+
+#define __bf_cast_unsigned(type, x)	((__unsigned_scalar_typeof(type))(x))
+
+#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
+	({								\
+		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
+				 _pfx "mask is not constant");		\
+		BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");	\
+		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
+				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
+				 _pfx "value too large for the field"); \
+		BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >	\
+				 __bf_cast_unsigned(_reg, ~0ull),	\
+				 _pfx "type of reg too small for mask"); \
+		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
+					      (1ULL << __bf_shf(_mask))); \
+	})
+
+/**
+ * FIELD_MAX() - produce the maximum value representable by a field
+ * @_mask: shifted mask defining the field's length and position
+ *
+ * FIELD_MAX() returns the maximum value that can be held in the field
+ * specified by @_mask.
+ */
+#define FIELD_MAX(_mask)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_MAX: ");	\
+		(typeof(_mask))((_mask) >> __bf_shf(_mask));		\
+	})
+
+/**
+ * FIELD_FIT() - check if value fits in the field
+ * @_mask: shifted mask defining the field's length and position
+ * @_val:  value to test against the field
+ *
+ * Return: true if @_val can fit inside @_mask, false if @_val is too big.
+ */
+#define FIELD_FIT(_mask, _val)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");	\
+		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
+	})
+
+/**
+ * FIELD_PREP() - prepare a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_val:  value to put in the field
+ *
+ * FIELD_PREP() masks and shifts up the value.  The result should
+ * be combined with other fields of the bitfield using logical OR.
+ */
+#define FIELD_PREP(_mask, _val)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
+		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
+	})
+
+/**
+ * FIELD_GET() - extract a bitfield element
+ * @_mask: shifted mask defining the field's length and position
+ * @_reg:  value of entire bitfield
+ *
+ * FIELD_GET() extracts the field specified by @_mask from the
+ * bitfield passed in as @_reg by masking and shifting it down.
+ */
+#define FIELD_GET(_mask, _reg)						\
+	({								\
+		__BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");	\
+		(typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask));	\
+	})
+
+extern void __compiletime_error("value doesn't fit into mask")
+__field_overflow(void);
+extern void __compiletime_error("bad bitfield mask")
+__bad_mask(void);
+static __always_inline u64 field_multiplier(u64 field)
+{
+	if ((field | (field - 1)) & ((field | (field - 1)) + 1))
+		__bad_mask();
+	return field & -field;
+}
+static __always_inline u64 field_mask(u64 field)
+{
+	return field / field_multiplier(field);
+}
+#define field_max(field)	((typeof(field))field_mask(field))
+#define ____MAKE_OP(type,base,to,from)					\
+static __always_inline __##type type##_encode_bits(base v, base field)	\
+{									\
+	if (__builtin_constant_p(v) && (v & ~field_mask(field)))	\
+		__field_overflow();					\
+	return to((v & field_mask(field)) * field_multiplier(field));	\
+}									\
+static __always_inline __##type type##_replace_bits(__##type old,	\
+					base val, base field)		\
+{									\
+	return (old & ~to(field)) | type##_encode_bits(val, field);	\
+}									\
+static __always_inline void type##p_replace_bits(__##type *p,		\
+					base val, base field)		\
+{									\
+	*p = (*p & ~to(field)) | type##_encode_bits(val, field);	\
+}									\
+static __always_inline base type##_get_bits(__##type v, base field)	\
+{									\
+	return (from(v) & field)/field_multiplier(field);		\
+}
+#define __MAKE_OP(size)							\
+	____MAKE_OP(le##size,u##size,cpu_to_le##size,le##size##_to_cpu)	\
+	____MAKE_OP(be##size,u##size,cpu_to_be##size,be##size##_to_cpu)	\
+	____MAKE_OP(u##size,u##size,,)
+____MAKE_OP(u8,u8,,)
+__MAKE_OP(16)
+__MAKE_OP(32)
+__MAKE_OP(64)
+#undef __MAKE_OP
+#undef ____MAKE_OP
+
+#endif
-- 
2.38.0.413.g74048e4d9e-goog

