Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE816C0B0B
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 08:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCTHES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 03:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjCTHEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 03:04:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52F01B33D
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so11375961pjb.0
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 00:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679295844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DK9dLTAGrMpm0BQxyn19vYjH0cboReyEkRdHItdBxGQ=;
        b=fZbQsbBQUoIFGp1JnZnU8ZMXqH//p630M3/9raEE6NDwYmA620sxEBj7wHOb9irD3v
         V9Rygp+hyp5eU1vPmMFuL90zbpU9bwD6xKVDRwrpWU365Egfsdq0ebn97+QYZUATFh80
         vbu5VtjK+70JeV4EcmrTVS77jHMoDRYEa8BwrqLoZJEPHLq/iJ8qUZ37CgFFlN7fs3sh
         yls7W7GklBk1cgd24hKISfBAUKBPhsKA/DwP9fEemZ+UYNGFDDzh9OxTXKcHHlNGtlBO
         ATG7wf1NsR+43zq31V/F5Ek335Y0IxHOjKjMQK1OueBezhKio7lgsn/nc0v+wyUhszXP
         dMxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679295844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DK9dLTAGrMpm0BQxyn19vYjH0cboReyEkRdHItdBxGQ=;
        b=GCgMmIskR8UC/3W6/XkvwjO3ADmI0PDhlB/w5ny8qiHPZ3sXtlj/xcpLFKuWjRJyiE
         hd0L+3GdRLN/wi0sQWUP3e+XzAfWKgtgvWHlNhQ4o/kGX2fCMYNpxfWJDLcHDsIqtVaL
         x6VHO7gNDY0ZD+u/oNvl3ICHtiF2vWPIbRk4T0vZ2IUoOYQHRSpbzaPmb40ZbldRiCKh
         d5QEHMo+AQaEYRyXjpVMjeBINygjK4NQZ76NFGxfId4JpYx5u5P9bhtbWvjOEB62Gnbc
         euFtmm6lvHuGCyuFnxqc9/8s2whMdFIvRSBJ8afgjUsrvdcfeyeLJfP6eevI/h4mKgIN
         tjsQ==
X-Gm-Message-State: AO0yUKVtRNq1DV1KBsqc8ZPPzdxcFfhgux1rEaVGQF+XYUDCI2baBosx
        2tOftf26sq8H7w0oeWYqFOuHG5xAAJs=
X-Google-Smtp-Source: AK7set+gdr5NPSUQ2wzxNeH+vdLlvghZATI1sJX3v/UIzP9/k3N8tvJADvmM4eoF5n3lucA95ncVDA==
X-Received: by 2002:a17:90b:1bc8:b0:237:a174:ce54 with SMTP id oa8-20020a17090b1bc800b00237a174ce54mr17408446pjb.21.1679295844637;
        Mon, 20 Mar 2023 00:04:04 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (121-44-69-75.tpgi.com.au. [121.44.69.75])
        by smtp.gmail.com with ESMTPSA id r17-20020a632b11000000b0050f7f783ff0sm1039414pgr.76.2023.03.20.00.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 00:04:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v2 05/10] powerpc: Indirect SPR accessor functions
Date:   Mon, 20 Mar 2023 17:03:34 +1000
Message-Id: <20230320070339.915172-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320070339.915172-1-npiggin@gmail.com>
References: <20230320070339.915172-1-npiggin@gmail.com>
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

Make overly-clever SPR accessor functions that allow a non-constant
SPR number to be specified. This will be used to restructure test
in the next change.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 powerpc/sprs.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 6ee6dba..db341a9 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -28,21 +28,66 @@
 #include <asm/processor.h>
 #include <asm/barrier.h>
 
-#define mfspr(nr) ({ \
-	uint64_t ret; \
-	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr)); \
-	ret; \
-})
+/* "Indirect" mfspr/mtspr which accept a non-constant spr number */
+static uint64_t mfspr(unsigned spr)
+{
+	uint64_t tmp;
+	uint64_t ret;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mfspr	%1, .LSPR		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp),
+	  "=r"(ret)
+	: "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr");
+
+	return ret;
+}
 
-#define mtspr(nr, val) \
-	asm volatile("mtspr %0,%1" : : "i"(nr), "r"(val))
+static void mtspr(unsigned spr, uint64_t val)
+{
+	uint64_t tmp;
+
+	asm volatile(
+"	bcl	20, 31, 1f		\n"
+"1:	mflr	%0			\n"
+"	addi	%0, %0, (2f-1b)		\n"
+"	add	%0, %0, %2		\n"
+"	mtctr	%0			\n"
+"	bctr				\n"
+"2:					\n"
+".LSPR=0				\n"
+".rept 1024				\n"
+"	mtspr	.LSPR, %1		\n"
+"	b	3f			\n"
+"	.LSPR=.LSPR+1			\n"
+".endr					\n"
+"3:					\n"
+	: "=&r"(tmp)
+	: "r"(val),
+	  "r"(spr*8) /* 8 bytes per 'mfspr ; b' block */
+	: "lr", "ctr", "xer");
+}
 
 uint64_t before[1024], after[1024];
 
 /* Common SPRs for all PowerPC CPUs */
 static void set_sprs_common(uint64_t val)
 {
-	mtspr(9, val);		/* CTR */
+	// mtspr(9, val);	/* CTR */ /* Used by mfspr/mtspr */
 	// mtspr(273, val);	/* SPRG1 */  /* Used by our exception handler */
 	mtspr(274, val);	/* SPRG2 */
 	mtspr(275, val);	/* SPRG3 */
@@ -156,7 +201,7 @@ static void set_sprs(uint64_t val)
 
 static void get_sprs_common(uint64_t *v)
 {
-	v[9] = mfspr(9);	/* CTR */
+	v[9] = mfspr(9);	/* CTR */ /* Used by mfspr/mtspr */
 	// v[273] = mfspr(273);	/* SPRG1 */ /* Used by our exception handler */
 	v[274] = mfspr(274);	/* SPRG2 */
 	v[275] = mfspr(275);	/* SPRG3 */
-- 
2.37.2

