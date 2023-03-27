Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F236CA464
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 14:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbjC0Mp5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 08:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjC0Mpz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 08:45:55 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD284220
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id k2so8299578pll.8
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 05:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679921152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QSWF70XC53IehgoGdTjHjvwQLhBxkQYax50EhzSCdko=;
        b=JRwi0cQMarSyPJi9mejflbePMO/Krhq5N4+ek+e6MtsfpTJDh25Eruag961c+tHjoT
         UF1lhyJFtL+INAnU4wMAMc+N8BzhVqjOXR11Ucc0DOu6Fb9RhmON7jlkmcEtzQ1Ct/80
         QFBeVD/i2dHpbMdj1w6fIObTO4MsDP+kD5FdzveGfXX3yp8sS3qnDh0OOfl6e8H/C8ET
         eRr+TkMKYyFZX/vqi9lsUpHX0Hr3v+U5/L7cTWAnwMaFlCZ19+xgapVS/9F9JWO4B5jw
         23ojyzE7fJyyx/E+8WiqTCRPDqhR1JOIbE+kOEzE87NEtM/FJks3JtIt1coaEt1zGSU3
         InNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679921152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSWF70XC53IehgoGdTjHjvwQLhBxkQYax50EhzSCdko=;
        b=gn3wjn9FWW1mfBYcZhdQEb5Y4cgN+tE8EQiNMWRdYqXpIzWZA9mapjR6m2ELFoB7yP
         i0wZs/fK6NwYDKoJHwa7ew/ZouxTLqUA5IlpemKGZGf1tn1Oa6HNPfRBZTmTp7ejRsfy
         ELjR9k587dCdS8B43osTxBYgRupDDJfEIawdWbqE4aONc3K735MaO91aNwNcisoOHnwo
         yjh/MGlk3ihOsgsrCeWv+SpOjVC9DdQxhHXlu/ZDjIoehTlmHJmIeQSIu5HQwB27htuH
         +bM+ZPW1AjaEq7rc9kpOWlYqA22RzBSn+nWIBtu9D3yXppPrEEqdkuy3dKuAxmfjLRX1
         kBPQ==
X-Gm-Message-State: AAQBX9eav9mxMbpU/NQM8MJcGyPhVYywdsY7VIdqIVlCUgOzPcficjX9
        RFlKjFC0kDkx2pca7Ucyy6i7KbEhqf8=
X-Google-Smtp-Source: AKy350bVnJu+x98KMTOh6IPe/LcqsRr+huz0uw2drNFOaxTWY/PpctDKw2oaSuKxynu4FxdAZjXEwg==
X-Received: by 2002:a17:902:cf4e:b0:1a2:1922:985b with SMTP id e14-20020a170902cf4e00b001a21922985bmr9224512plg.59.1679921151914;
        Mon, 27 Mar 2023 05:45:51 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([203.221.180.225])
        by smtp.gmail.com with ESMTPSA id ay6-20020a1709028b8600b0019a997bca5csm19053965plb.121.2023.03.27.05.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 05:45:51 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [kvm-unit-tests v3 06/13] powerpc: Extract some common helpers and defines to headers
Date:   Mon, 27 Mar 2023 22:45:13 +1000
Message-Id: <20230327124520.2707537-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move some common helpers and defines to processor.h.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
Since v2:
- New patch

 lib/powerpc/asm/processor.h | 38 +++++++++++++++++++++++++++++++++----
 powerpc/spapr_hcall.c       |  9 +--------
 powerpc/sprs.c              |  9 ---------
 3 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index ebfeff2..4ad6612 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -9,13 +9,43 @@ void handle_exception(int trap, void (*func)(struct pt_regs *, void *), void *);
 void do_handle_exception(struct pt_regs *regs);
 #endif /* __ASSEMBLY__ */
 
-static inline uint64_t get_tb(void)
+#define SPR_TB		0x10c
+#define SPR_SPRG0	0x110
+#define SPR_SPRG1	0x111
+#define SPR_SPRG2	0x112
+#define SPR_SPRG3	0x113
+
+static inline uint64_t mfspr(int nr)
 {
-	uint64_t tb;
+	uint64_t ret;
+
+	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr) : "memory");
+
+	return ret;
+}
 
-	asm volatile ("mfspr %[tb],268" : [tb] "=r" (tb));
+static inline void mtspr(int nr, uint64_t val)
+{
+	asm volatile("mtspr %0,%1" : : "i"(nr), "r"(val) : "memory");
+}
+
+static inline uint64_t mfmsr(void)
+{
+	uint64_t msr;
 
-	return tb;
+	asm volatile ("mfmsr %[msr]" : [msr] "=r" (msr) :: "memory");
+
+	return msr;
+}
+
+static inline void mtmsr(uint64_t msr)
+{
+	asm volatile ("mtmsrd %[msr]" :: [msr] "r" (msr) : "memory");
+}
+
+static inline uint64_t get_tb(void)
+{
+	return mfspr(SPR_TB);
 }
 
 extern void delay(uint64_t cycles);
diff --git a/powerpc/spapr_hcall.c b/powerpc/spapr_hcall.c
index 823a574..0d0f25a 100644
--- a/powerpc/spapr_hcall.c
+++ b/powerpc/spapr_hcall.c
@@ -9,20 +9,13 @@
 #include <util.h>
 #include <alloc.h>
 #include <asm/hcall.h>
+#include <asm/processor.h>
 
 #define PAGE_SIZE 4096
 
 #define H_ZERO_PAGE	(1UL << (63-48))
 #define H_COPY_PAGE	(1UL << (63-49))
 
-#define mfspr(nr) ({ \
-	uint64_t ret; \
-	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr)); \
-	ret; \
-})
-
-#define SPR_SPRG0	0x110
-
 /**
  * Test the H_SET_SPRG0 h-call by setting some values and checking whether
  * the SPRG0 register contains the correct values afterwards
diff --git a/powerpc/sprs.c b/powerpc/sprs.c
index 6ee6dba..57e487c 100644
--- a/powerpc/sprs.c
+++ b/powerpc/sprs.c
@@ -28,15 +28,6 @@
 #include <asm/processor.h>
 #include <asm/barrier.h>
 
-#define mfspr(nr) ({ \
-	uint64_t ret; \
-	asm volatile("mfspr %0,%1" : "=r"(ret) : "i"(nr)); \
-	ret; \
-})
-
-#define mtspr(nr, val) \
-	asm volatile("mtspr %0,%1" : : "i"(nr), "r"(val))
-
 uint64_t before[1024], after[1024];
 
 /* Common SPRs for all PowerPC CPUs */
-- 
2.37.2

