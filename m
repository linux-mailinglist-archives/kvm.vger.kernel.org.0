Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B5A6A245B
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBXWhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjBXWhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:37:14 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E226F81E
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:12 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536cad819c7so12990717b3.6
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qL7Ja+TASVm6K1qCmtdmDAoojZSvdRk42Rau58IW4rM=;
        b=TERGtr1H3+7mQV/dLjQMGQuZeUczuxuFoQGy3OcPfWRutBwaX35vi+PEU9r86Wg71H
         eucyBe8upxo/gtB4kK6lHott/xp78/2SqSC7yqOBBq+5bte5KqYcZ4bhIkVYsheXSGCy
         2FunVvw59QCydDG1IFoaadW4UwMnyRcVyNGXUbjsaL4Wx08h5plGJRbkYfIgu/hTmWzi
         9mEMup4/UGX5ZqEjn49RaSI+cQWNxyUW0weFmvLVa5UATBHlkpiL7EbjQ7Py9P1h0kTX
         D64Aufs5qeG0FEUs/fC0lyTigTif4e3O6J8poLpMHapNjZoU9afkPW3XoEwPmPSoh91v
         MWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qL7Ja+TASVm6K1qCmtdmDAoojZSvdRk42Rau58IW4rM=;
        b=4CEi9Z4CRjPkKOHupyTM4P2Y/ywp3/JmS+lCxSLT9mLZaay7S/Qd1Mpj4MRpzmvYrW
         EzM4fADwKcVNgXJrjQ/rqdnsMpbcKJEUwTXBS8JUe+V7jTmpQWGhvv/3/LXvyXmkbhTe
         CJc+Luk4pzdCpWwMuRtIhUPT7K3AaorQTQZpSKCmz3SsggOWaa3Dwgk40+rPkOf6g3LG
         x/clZLktLgRpF3tP9/th6utyjo/N9qVhzNiQ27QoeUTQBb8kuf7m7Qk39UGpJ7FcLtPQ
         8McLwG+W+2C8zU/xSDSHxbP/LUqe93LDK7LmBIt7m2z0r/RLdELdgM/PiW8DDvTNO2I5
         0Njw==
X-Gm-Message-State: AO0yUKUIwRvmNuAoZbDDL+qwlScednwua2gdUWMlJ6h8LJ3SNadWTcMJ
        UoQdxddsXKlGOe7sSXDw7vgFR8+7i1x6bWiAZDeWQ+4d2mgX/UwqPYgFO0Cg35KuiuUHBt2pFtR
        0PcDHqGLn3eWpvsPk+EwhTT3ZvLAAWtgqqEVbLG5Iu7l+sJR9qGpCu+rFVM5LohYnS9s/
X-Google-Smtp-Source: AK7set9OfXRkGcmOUImLWCd8mmvTt+Yp9DLWug2gqb4nOMxfNg7QBMx7XK0pwJhugDE01g6MFniI8A1m595fX6tm
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a81:b705:0:b0:530:a340:bcd7 with SMTP
 id v5-20020a81b705000000b00530a340bcd7mr5513168ywh.8.1677278232044; Fri, 24
 Feb 2023 14:37:12 -0800 (PST)
Date:   Fri, 24 Feb 2023 22:36:06 +0000
In-Reply-To: <20230224223607.1580880-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230224223607.1580880-8-aaronlewis@google.com>
Subject: [PATCH v3 7/8] KVM: selftests: Add XFEATURE masks to common code
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        mizhang@google.com, Aaron Lewis <aaronlewis@google.com>
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

Add XFEATURE masks to processor.h to make them more broadly available
in KVM selftests.

Use the names from the kernel's fpu/types.h for consistency, i.e.
rename XTILECFG and XTILEDATA to XTILE_CFG and XTILE_DATA respectively.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 17 ++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 22 +++++++------------
 2 files changed, 25 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 62dc54c8e0c4..ebe83cfe521c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -48,6 +48,23 @@ extern bool host_cpu_is_amd;
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
+#define XFEATURE_MASK_FP		BIT_ULL(0)
+#define XFEATURE_MASK_SSE		BIT_ULL(1)
+#define XFEATURE_MASK_YMM		BIT_ULL(2)
+#define XFEATURE_MASK_BNDREGS		BIT_ULL(3)
+#define XFEATURE_MASK_BNDCSR		BIT_ULL(4)
+#define XFEATURE_MASK_OPMASK		BIT_ULL(5)
+#define XFEATURE_MASK_ZMM_Hi256		BIT_ULL(6)
+#define XFEATURE_MASK_Hi16_ZMM		BIT_ULL(7)
+#define XFEATURE_MASK_XTILE_CFG		BIT_ULL(17)
+#define XFEATURE_MASK_XTILE_DATA	BIT_ULL(18)
+
+#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK | \
+					 XFEATURE_MASK_ZMM_Hi256 | \
+					 XFEATURE_MASK_Hi16_ZMM)
+#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILE_DATA | \
+					 XFEATURE_MASK_XTILE_CFG)
+
 /* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  Eww. */
 enum cpuid_output_regs {
 	KVM_CPUID_EAX,
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 4b733ad21831..14a7656620d5 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -33,12 +33,6 @@
 #define MAX_TILES			16
 #define RESERVED_BYTES			14
 
-#define XFEATURE_XTILECFG		17
-#define XFEATURE_XTILEDATA		18
-#define XFEATURE_MASK_XTILECFG		(1 << XFEATURE_XTILECFG)
-#define XFEATURE_MASK_XTILEDATA		(1 << XFEATURE_XTILEDATA)
-#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILECFG | XFEATURE_MASK_XTILEDATA)
-
 #define XSAVE_HDR_OFFSET		512
 
 struct xsave_data {
@@ -187,14 +181,14 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	__tilerelease();
 	GUEST_SYNC(5);
 	/* bit 18 not in the XCOMP_BV after xsavec() */
-	set_xstatebv(xsave_data, XFEATURE_MASK_XTILEDATA);
-	__xsavec(xsave_data, XFEATURE_MASK_XTILEDATA);
-	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILEDATA) == 0);
+	set_xstatebv(xsave_data, XFEATURE_MASK_XTILE_DATA);
+	__xsavec(xsave_data, XFEATURE_MASK_XTILE_DATA);
+	GUEST_ASSERT((get_xstatebv(xsave_data) & XFEATURE_MASK_XTILE_DATA) == 0);
 
 	/* xfd=0x40000, disable amx tiledata */
-	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILEDATA);
+	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 	GUEST_SYNC(6);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
 	/* Trigger #NM exception */
@@ -206,11 +200,11 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 
 void guest_nm_handler(struct ex_regs *regs)
 {
-	/* Check if #NM is triggered by XFEATURE_MASK_XTILEDATA */
+	/* Check if #NM is triggered by XFEATURE_MASK_XTILE_DATA */
 	GUEST_SYNC(7);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_SYNC(8);
-	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILEDATA);
+	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
-- 
2.39.2.637.g21b0678d19-goog

