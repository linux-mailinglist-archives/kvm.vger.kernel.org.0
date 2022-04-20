Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6F85092BF
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 00:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382798AbiDTW2g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 18:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376924AbiDTW21 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 18:28:27 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0ACC40E78;
        Wed, 20 Apr 2022 15:25:33 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id s4so2394899qkh.0;
        Wed, 20 Apr 2022 15:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SEW9sH4yh315Yy80b7kF6Br9mFoOl8COFMpMKcd1BB0=;
        b=D2YcdZil5EgnqmY0lEu7pW35FVCXFTN7QBggpmqztS0NydHUmEbFzTvSPSPJT+EQfe
         VAsOzraW5ictSt74zTmYKvwEV1f7iOgoHzQe//8vdTLdnOktIAo585hUVVSYaDyhwd3y
         BpDUzP2dZeDdmceAEI80TzovIy3W0jLYnx42WVgHvMPHxXdR4gUtM2iok1wjOq/ReaXz
         bSD6xMMDajgrg/AF4CSf64rTTkvYL+aB6URvganrC+e5vbexVThSIN+5+MeZDGiA2Qnw
         7GTtqJquXnDmJ0on2iG+CQ92xniACrdLmdgZQD3qyf593g5sizF3R3iGnqgh/jYI+TPw
         ANmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SEW9sH4yh315Yy80b7kF6Br9mFoOl8COFMpMKcd1BB0=;
        b=d+ZoVD7g/f2xGISJxHNzdTehfJku9B6l9DL+dHd4yk+0kw7QEWHRV5mva1J70p7kaZ
         Prg5JGyDXc2js4pW5Mepat/zeb/AZrGrZGkU6raE5x+k9T+kp8xiHbPzJU4ZRhrPLPec
         UAsFtTD83YcWGMJkh4/B82OKkr9xd8qd9CpEY6e4SUXPLmXzCANAYdFbJOynDtgno/iU
         PJUVm41i4FOtinrMtX/Wvi2UPflIA4t1x8trJcBHFMZkAtAdCnhEwL1NXHoxU1O8OibS
         1ERFfmfAdqM7pLEUKusRJQcDK4TBF7Ih+Ik9Vj1o9QWNV6m6Ih1Ja8hDE+p59zM81JPq
         HDIQ==
X-Gm-Message-State: AOAM533PrDu+aH/OBeiEmu/LqXd23g00kBR1lfgDQ+9Zsa7j8v1b7MXa
        I4zerBn8UkAI9++B2a1tnLFQSW4mEzI=
X-Google-Smtp-Source: ABdhPJwA3ZRr3c9oiLejkR6iKE6q9OIySi66LXZ9CXc706o4hud0p2Rfcvn2Dc0vB2CkfOUOavxeYg==
X-Received: by 2002:a37:a689:0:b0:69e:be4d:6d8f with SMTP id p131-20020a37a689000000b0069ebe4d6d8fmr7220315qke.332.1650493532633;
        Wed, 20 Apr 2022 15:25:32 -0700 (PDT)
Received: from localhost ([2601:c4:c432:60a:188a:94a5:4e52:4f76])
        by smtp.gmail.com with ESMTPSA id w82-20020a376255000000b0069ee3f0ae63sm1004534qkb.45.2022.04.20.15.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:25:32 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 2/4] lib: add bitmap_{from,to}_arr64
Date:   Wed, 20 Apr 2022 15:25:28 -0700
Message-Id: <20220420222530.910125-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220420222530.910125-1-yury.norov@gmail.com>
References: <20220420222530.910125-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Manipulating 64-bit arrays with bitmap functions is potentially dangerous
because on 32-bit BE machines the order of halfwords doesn't match. Another
issue is that compiler may throw a warning about out-of-boundary access.

This patch adds bitmap_{from,to}_arr64 functions in addition to existing
bitmap_{from,to}_arr32.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h | 23 +++++++++++++++++----
 lib/bitmap.c           | 47 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 10d805c2893c..f78c534fb814 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -292,6 +292,24 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
 			(const unsigned long *) (bitmap), (nbits))
 #endif
 
+/*
+ * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
+ * machines the order of hi and lo parts of nubmers match the bitmap structure.
+ * In both cases conversion is not needed when copying data from/to arrays of
+ * u64.
+ */
+#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits);
+void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits);
+#else
+#define bitmap_from_arr64(bitmap, buf, nbits)			\
+	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
+			(const unsigned long *) (buf), (nbits))
+#define bitmap_to_arr64(buf, bitmap, nbits)			\
+	bitmap_copy_clear_tail((unsigned long *) (buf),		\
+			(const unsigned long *) (bitmap), (nbits))
+#endif
+
 static inline int bitmap_and(unsigned long *dst, const unsigned long *src1,
 			const unsigned long *src2, unsigned int nbits)
 {
@@ -596,10 +614,7 @@ static inline void bitmap_next_set_region(unsigned long *bitmap,
  */
 static inline void bitmap_from_u64(unsigned long *dst, u64 mask)
 {
-	dst[0] = mask & ULONG_MAX;
-
-	if (sizeof(mask) > sizeof(unsigned long))
-		dst[1] = mask >> 32;
+	bitmap_from_arr64(dst, &mask, 64);
 }
 
 /**
diff --git a/lib/bitmap.c b/lib/bitmap.c
index d9a4480af5b9..aea9493f4216 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1533,5 +1533,52 @@ void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits)
 		buf[halfwords - 1] &= (u32) (UINT_MAX >> ((-nbits) & 31));
 }
 EXPORT_SYMBOL(bitmap_to_arr32);
+#endif
+
+#if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
+/**
+ * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
+ *	@bitmap: array of unsigned longs, the destination bitmap
+ *	@buf: array of u64 (in host byte order), the source bitmap
+ *	@nbits: number of bits in @bitmap
+ */
+void bitmap_from_arr64(unsigned long *bitmap, const u64 *buf, unsigned int nbits)
+{
+	while (nbits > 0) {
+		u64 val = *buf++;
+
+		*bitmap++ = (unsigned long)val;
+		if (nbits > 32)
+			*bitmap++ = (unsigned long)(val >> 32);
+		nbits -= 64;
+	}
 
+	/* Clear tail bits in last word beyond nbits. */
+	if (nbits % BITS_PER_LONG)
+		bitmap[-1] &= BITMAP_LAST_WORD_MASK(nbits);
+}
+EXPORT_SYMBOL(bitmap_from_arr64);
+
+/**
+ * bitmap_to_arr64 - copy the contents of bitmap to a u64 array of bits
+ *	@buf: array of u64 (in host byte order), the dest bitmap
+ *	@bitmap: array of unsigned longs, the source bitmap
+ *	@nbits: number of bits in @bitmap
+ */
+void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
+{
+	unsigned long *end = bitmap + BITS_TO_LONGS(nbits);
+
+	while (bitmap < end) {
+		*buf = *bitmap++;
+		if (bitmap < end)
+			*buf |= *bitmap++ << 32;
+		buf++;
+	}
+
+	/* Clear tail bits in last element of array beyond nbits. */
+	if (nbits % 64)
+		buf[-1] &= GENMASK_ULL(nbits, 0);
+}
+EXPORT_SYMBOL(bitmap_to_arr64);
 #endif
-- 
2.32.0

