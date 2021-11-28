Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8EF460381
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 04:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348797AbhK1ECa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 23:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344053AbhK1EAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 23:00:25 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EA1C06175A;
        Sat, 27 Nov 2021 19:57:09 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id o17so12925801qtk.1;
        Sat, 27 Nov 2021 19:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oyYw0S0uIYbzbJlT2sTRB5/AL9ZCZW5naP5e066GZEw=;
        b=pRmYH3DF71YxuUIeQtUZruUdNNbsy9VbRav7B36MJevKZvkrVj0n380VwT9ymC/6tG
         I3jRVCazSdBphHgxopQgwYWsemberSxSLLmEZ3tbZZbD8KpHpZflSpa+2S0k6f6QnB63
         LB8J/U92ggXSM5heSnBWXElO/lbm0h3GvHDm+xfKfMbvFUiCUQhf7pfNhI/oaY9IVP8w
         7t+nf549TZ3BfT1eSpUgpkQbcUE7bqe1pWWQUMdmdt6c2ZEHLOYC5EdviqL4d6Gm0jRf
         3M/+zB1qnWTzYKLjhE16NC3G38+E6HR1NvaA5CMDVSJ3aiJNz0XRVEXMB3VTCE4t50qm
         Oo5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oyYw0S0uIYbzbJlT2sTRB5/AL9ZCZW5naP5e066GZEw=;
        b=asRwVMb1UBf0/n8FkTOXeRZo1CXyPGb6NloGP1eBWaTwY3pFz1Liym4sdQoQ7NQb46
         cOvZNMxfNWZomB/lvSW4HeODrcU+svdFwC6Z0ORpDr7ptEuyn4SDHIZdTi2SZ7XVRg4G
         7A1589ZEYt8DS6edtQAi1gKmmci34XWy4hw0QPFx1uZksqheu2GMpUERobZajeWV1sDd
         ic9CJUUN5xX2UBoq83Qj05coI8ErFxy5Pctw/UgurddDymE8/5Ss0xNI683cXkMfGOlG
         Eb6CELIiFG2dZXMJV0P81NQElk5dMNyjmlcol2dhNW1+PGu+jTakTzd9qWK2yP9OlPiA
         pKUQ==
X-Gm-Message-State: AOAM532c6uUpow4zBl8VYRi/18WHan4XpKjCMTgmLSUia+5hl+MoSw6y
        HeJd7eGppqlhC5u65TU+oJHTp2APHI/zdA==
X-Google-Smtp-Source: ABdhPJzCSIHK5gqoZpz/7aPIEpGhuYe/wtGfXQ5VTkZ0R5LJuGRI9ufln+7naenMGGb1nvoOREIAZQ==
X-Received: by 2002:ac8:7fca:: with SMTP id b10mr26533825qtk.500.1638071828690;
        Sat, 27 Nov 2021 19:57:08 -0800 (PST)
Received: from localhost ([66.216.211.25])
        by smtp.gmail.com with ESMTPSA id v1sm6498979qtw.65.2021.11.27.19.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 19:57:08 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Klimov <aklimov@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Andy Shevchenko <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        David Laight <David.Laight@ACULAB.COM>,
        Dennis Zhou <dennis@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jens Axboe <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>, Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/9] lib/bitmap: add bitmap_weight_{eq,gt,le}
Date:   Sat, 27 Nov 2021 19:56:56 -0800
Message-Id: <20211128035704.270739-2-yury.norov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128035704.270739-1-yury.norov@gmail.com>
References: <20211128035704.270739-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many kernel users call bitmap_weight() to compare the result against
some number or expression:
	if (bitmap_weight(...) > 1)
		do_something();

It works OK, but may be significantly improved for large bitmaps: if
first few words count set bits to a number greater than given, we can
stop counting and immediately return.

The same idea would work in other direction: if we know that the number
of set bits that we counted so far is small enough, so that it would be
smaller than required number even if all bits of the rest of the bitmap
are set, we can return earlier.

This patch adds new bitmap_weight_{eq,gt,le} functions to allow this
optimization, and the following patches apply them where appropriate.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/bitmap.h | 33 ++++++++++++++++++++++
 lib/bitmap.c           | 63 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7dba0847510c..996041f771c8 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -51,6 +51,9 @@ struct device;
  *  bitmap_empty(src, nbits)                    Are all bits zero in *src?
  *  bitmap_full(src, nbits)                     Are all bits set in *src?
  *  bitmap_weight(src, nbits)                   Hamming Weight: number set bits
+ *  bitmap_weight_eq(src, nbits, num)           Hamming Weight is equal to num
+ *  bitmap_weight_gt(src, nbits, num)           Hamming Weight is greater than num
+ *  bitmap_weight_le(src, nbits, num)           Hamming Weight is less than num
  *  bitmap_set(dst, pos, nbits)                 Set specified bit area
  *  bitmap_clear(dst, pos, nbits)               Clear specified bit area
  *  bitmap_find_next_zero_area(buf, len, pos, n, mask)  Find bit free area
@@ -162,6 +165,9 @@ int __bitmap_intersects(const unsigned long *bitmap1,
 int __bitmap_subset(const unsigned long *bitmap1,
 		    const unsigned long *bitmap2, unsigned int nbits);
 int __bitmap_weight(const unsigned long *bitmap, unsigned int nbits);
+bool __bitmap_weight_eq(const unsigned long *bitmap, unsigned int nbits, unsigned int num);
+bool __bitmap_weight_gt(const unsigned long *bitmap, unsigned int nbits, unsigned int num);
+bool __bitmap_weight_le(const unsigned long *bitmap, unsigned int nbits, unsigned int num);
 void __bitmap_set(unsigned long *map, unsigned int start, int len);
 void __bitmap_clear(unsigned long *map, unsigned int start, int len);
 
@@ -403,6 +409,33 @@ static __always_inline int bitmap_weight(const unsigned long *src, unsigned int
 	return __bitmap_weight(src, nbits);
 }
 
+static __always_inline bool bitmap_weight_eq(const unsigned long *src,
+			unsigned int nbits, unsigned int num)
+{
+	if (small_const_nbits(nbits))
+		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits)) == num;
+
+	return __bitmap_weight_eq(src, nbits, num);
+}
+
+static __always_inline bool bitmap_weight_gt(const unsigned long *src,
+			unsigned int nbits, unsigned int num)
+{
+	if (small_const_nbits(nbits))
+		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits)) > num;
+
+	return __bitmap_weight_gt(src, nbits, num);
+}
+
+static __always_inline bool bitmap_weight_le(const unsigned long *src,
+			unsigned int nbits, unsigned int num)
+{
+	if (small_const_nbits(nbits))
+		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits)) < num;
+
+	return __bitmap_weight_le(src, nbits, num);
+}
+
 static __always_inline void bitmap_set(unsigned long *map, unsigned int start,
 		unsigned int nbits)
 {
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 926408883456..72e7ab2d7bdd 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -348,6 +348,69 @@ int __bitmap_weight(const unsigned long *bitmap, unsigned int bits)
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
+bool __bitmap_weight_eq(const unsigned long *bitmap, unsigned int bits, unsigned int num)
+{
+	unsigned int k, w, lim = bits / BITS_PER_LONG;
+
+	for (k = 0, w = 0; k < lim; k++) {
+		if (w + bits - k * BITS_PER_LONG < num)
+			return false;
+
+		w += hweight_long(bitmap[k]);
+
+		if (w > num)
+			return false;
+	}
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+
+	return w == num;
+}
+EXPORT_SYMBOL(__bitmap_weight_eq);
+
+bool __bitmap_weight_gt(const unsigned long *bitmap, unsigned int bits, unsigned int num)
+{
+	unsigned int k, w, lim = bits / BITS_PER_LONG;
+
+	for (k = 0, w = 0; k < lim; k++) {
+		if (w + bits - k * BITS_PER_LONG <= num)
+			return false;
+
+		w += hweight_long(bitmap[k]);
+
+		if (w > num)
+			return true;
+	}
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+
+	return w > num;
+}
+EXPORT_SYMBOL(__bitmap_weight_gt);
+
+bool __bitmap_weight_le(const unsigned long *bitmap, unsigned int bits, unsigned int num)
+{
+	unsigned int k, w, lim = bits / BITS_PER_LONG;
+
+	for (k = 0, w = 0; k < lim; k++) {
+		if (w + bits - k * BITS_PER_LONG < num)
+			return true;
+
+		w += hweight_long(bitmap[k]);
+
+		if (w >= num)
+			return false;
+	}
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+
+	return w < num;
+}
+EXPORT_SYMBOL(__bitmap_weight_le);
+
 void __bitmap_set(unsigned long *map, unsigned int start, int len)
 {
 	unsigned long *p = map + BIT_WORD(start);
-- 
2.25.1

