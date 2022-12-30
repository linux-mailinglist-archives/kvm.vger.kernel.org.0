Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E6E659A81
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiL3QZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 11:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbiL3QZH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 11:25:07 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D411C137
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:06 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b16-20020a17090a551000b00225aa26f1dbso9023614pji.8
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f0C5GuIe1dBEke5RFrB7sVhrtoLubRh+09eyq8bpu38=;
        b=jgdeIXQYzIIMbPKhgL4kLqlPAPQ+RG2Wy1veKzA6UHZrbtpehEgdieXul6vNX35s2X
         Tn21NYLGz2x04rB2ezeOil/TPZe/8hhEN0il4o0bMTGKnNDcL6eT06tFeV71p+EFk9kX
         APjhc3a3Q/W2grGxPMtditmP7wHcJdMQxjXtPs60MvoRTUW9B3U6G0GQ+X+YTn5U6tU0
         uqBlTNwvtk3CAEKRp9IxZmOuMdk9+knIg17euA0PAOSAd+uT/Cfy9BVrkJ8jWsCMwrac
         PQn91Sg5cgZJrmoUu0GTrIxgkeMNj+ZNcmGMR3U7AxVgVjEOUD/pUT1V5T1HCPc80WbM
         NUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f0C5GuIe1dBEke5RFrB7sVhrtoLubRh+09eyq8bpu38=;
        b=fFK12rsijIaAfj2nsGEFqfajNptUZaQOw7pKhTRHhWKrLLj4qEVI3enl6H5+EbSfOb
         RI17DuJhbuJcwjo0HgdhcKJ7WXTM8p1LUt0fPkRxWT2nJ4IJcl4p5CSizyRHAVaY3Szn
         oml64YTXczQ25+E1PGA/E/yDq9XpeFkxBk3qiytdEDLryoWNgNRaQ2BcOI7orzIC6HY/
         Tz1SMGFoSi8866JlKPyA5uKC/HKq18ukqZW2hW4UCGbQF9ApHpibFWH2FRI/KdNhobaR
         a3568ykV0L7IHij0ucTzqULf76xsa+WlRTS6QpGj0/dE33knjyY3fBcBwoyPn6bnYNMk
         n8dw==
X-Gm-Message-State: AFqh2kpIRrQ/oxLNd9EWG2ztAvHia+AB/I19cF/wKFstd4I7QoD4r0ZZ
        OVY+9FOrKiyNrTBRDHKaZgOwQwWZfgkCmokHo8p2xKgRmJrZB/KKFKFXFtHja9vR+8IH+hZr1Ff
        C9aqttwIG50mWPmr3OyCgLDdge3pnTu4fc16fIlIrYBiUYl/+RtM4VW3pNogCmquxNdo7
X-Google-Smtp-Source: AMrXdXsUsWHsXzmZhnFE6ZaD/6jagcSMucA7McVfwdsc30amZTvpzlD7IRZUbCsYepcWDuS+iZKpdTomWsiAFRUd
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a62:30c6:0:b0:581:6059:b7c8 with SMTP
 id w189-20020a6230c6000000b005816059b7c8mr1001008pfw.26.1672417505490; Fri,
 30 Dec 2022 08:25:05 -0800 (PST)
Date:   Fri, 30 Dec 2022 16:24:40 +0000
In-Reply-To: <20221230162442.3781098-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230162442.3781098-5-aaronlewis@google.com>
Subject: [PATCH v2 4/6] KVM: selftests: Hoist XGETBV and XSETBV to make them
 more accessible
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The instructions XGETBV and XSETBV are useful to other tests.  Move
them to processor.h to make them available to be used more broadly.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 19 +++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 24 +++----------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2a5f47d513884..5f06d6f27edf7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -493,6 +493,25 @@ static inline void set_cr4(uint64_t val)
 	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
 }
 
+static inline u64 xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	__asm__ __volatile__("xgetbv;"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax | ((u64)edx << 32);
+}
+
+static inline void xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	__asm__ __volatile__("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
+}
+
+
 static inline struct desc_ptr get_gdt(void)
 {
 	struct desc_ptr gdt;
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b670..4b733ad218313 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -68,24 +68,6 @@ struct xtile_info {
 
 static struct xtile_info xtile;
 
-static inline u64 __xgetbv(u32 index)
-{
-	u32 eax, edx;
-
-	asm volatile("xgetbv;"
-		     : "=a" (eax), "=d" (edx)
-		     : "c" (index));
-	return eax + ((u64)edx << 32);
-}
-
-static inline void __xsetbv(u32 index, u64 value)
-{
-	u32 eax = value;
-	u32 edx = value >> 32;
-
-	asm volatile("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
-}
-
 static inline void __ldtilecfg(void *cfg)
 {
 	asm volatile(".byte 0xc4,0xe2,0x78,0x49,0x00"
@@ -121,7 +103,7 @@ static inline void check_cpuid_xsave(void)
 
 static bool check_xsave_supports_xtile(void)
 {
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
+	return xgetbv(0) & XFEATURE_MASK_XTILE;
 }
 
 static void check_xtile_info(void)
@@ -177,9 +159,9 @@ static void init_regs(void)
 	cr4 |= X86_CR4_OSXSAVE;
 	set_cr4(cr4);
 
-	xcr0 = __xgetbv(0);
+	xcr0 = xgetbv(0);
 	xcr0 |= XFEATURE_MASK_XTILE;
-	__xsetbv(0x0, xcr0);
+	xsetbv(0x0, xcr0);
 }
 
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
-- 
2.39.0.314.g84b9a713c41-goog

