Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148FD5E5996
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 05:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiIVDWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 23:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIVDVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 23:21:44 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1946E2F1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:09 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id m1-20020a056a00080100b00543ffc4cfe0so4572704pfk.5
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 20:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=j8jJsNM7Za6z7+jNYScfL9f2PcUBqUH5VLVkcQEa6x0=;
        b=hml56jBdn4jvT3cDHUxiWH+S3TKq3U/mcYyyrZV0z6SYASc6cDnj+s4VclS1A71Gr2
         9+vQmW84OuhnnXWaibxwWqM1ImN/yrxBuIzy8kK/O7C1UVAhsn9AjR2TnZIwcPkv9kwY
         Yfgfza7mvY4pCnM0fdowJtt1KGAF95TOEGrPGReRJkTnrV43M/p88qPxRLC8ENyPNTQB
         dLCdQZXkatd/Sq9yIS3FNZ8G2bdhxZaNvq4Gzg8HG22/QG2Ip/ozPvGQgpLT24h0RPCq
         wkdYrFGWrhoEcwgyCC082BsOU9s8Cdi7dg3A0AvKHrRO7G6N1AKeQxSwQR/WituOEmlf
         YOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=j8jJsNM7Za6z7+jNYScfL9f2PcUBqUH5VLVkcQEa6x0=;
        b=yktE/GnOSZk9fmXVPlS9L0pJp9ty1C6Yxq5ZG4Ja3NUCNvn8idwaWwVa9kC0Nl0I4B
         tQTWiNynwPharAdxlXcbexI3p1Qj4wUa2OFxG97WeciI9y10N7Prjvw7fcod+93Wvxl6
         faOATNhb1uo/kKYJUlGqMnGCRTkiw/iNu757bI7Te8ow9pYTzSK4hwO9ONBrjXBeghdB
         ktYmL1b9P3CJFBZaHvJeqvoed9VCGbi807pXrbuqEGixKE4NoRlB2H2vszZVVER5C5Mj
         b0S8MtZyIJTmQ4yUg1K4M6URi7NFcZDJ3t7Cd6d2Jhu4QKxzwle/t97kQl31WxOkSYsh
         Ndvg==
X-Gm-Message-State: ACrzQf0i2crGMa3VFTpYJbdceyPrj4E/SuXdZwhvMJsl8iElyB/FxwHX
        5W7Vh6rI4Vb2QJXSW+ZJ2AkvwwTDI662kJ5/pyKX3/p1DhP1zT9FstyokmHzcoRvzpDDTQEU4pc
        zB8aJzTY+14Ifi+buESJIMS+J17nbZy6JoejiUPTGiGUJ7gD4Bc8k3we7LJQ2NXw=
X-Google-Smtp-Source: AMsMyM5xQcYM5Wcn+YqRms9Ca6RUENoGEPzbIHc1CjYBcflZepwJDhbc2uut5FT2x7VKu/a/qYtE/kVQhqXDgw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:cd06:b0:203:ae0e:6a21 with SMTP
 id d6-20020a17090acd0600b00203ae0e6a21mr95178pju.0.1663816747800; Wed, 21 Sep
 2022 20:19:07 -0700 (PDT)
Date:   Thu, 22 Sep 2022 03:18:48 +0000
In-Reply-To: <20220922031857.2588688-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220922031857.2588688-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922031857.2588688-6-ricarkol@google.com>
Subject: [PATCH v8 05/14] tools: Copy bitfield.h from the kernel sources
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
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
2.37.3.968.ga6b4b080e4-goog

