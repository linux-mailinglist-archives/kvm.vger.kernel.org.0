Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10C659A82
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 17:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbiL3QZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 11:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiL3QZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 11:25:08 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF0D1C126
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:07 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 84-20020a630257000000b00477f88d334eso10443073pgc.11
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 08:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjr9E/VJc/P1Y7whIHcfDB38hDTLVG7H3PGa2lFNg8A=;
        b=CACIqhk2Mcy9Y9dKKCyYNWkoyeo8SOyi5MY5EGh/sBeB/CMrBb1Bdkz1HuAiCAjguz
         tznjRnLJz/koaRBxmjjGwtTWl9KcyjsLb9YPx3ENhvhVm0jg+ZU0eURKlU+S7hv7IPaE
         k/8HWOTlBIzM6Y88sZw78xvqSc3u70C4ejU98fTfVj9f1nHtU0LjgF/Qk6+hVPOu73Nm
         BrzfuDR75ztUq4IJyu6d+vykz3hG6fTOkDOmWZ4OhhrTtdSKjl+Ay6Oeq6uiqwxOfXly
         ld9ix7EOxcLkbOjA9yBDEoffV01pAZ11Rv9Qzh8qT/KU1D3jm0C8fDN5j/qrqC6yg0l5
         nktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjr9E/VJc/P1Y7whIHcfDB38hDTLVG7H3PGa2lFNg8A=;
        b=ioaBJ0S/sYff7MI9qHOxGvxURN6Xy8Ixz1tCr34P+zX4rufkdfNqUNPmjmKUDHKrCZ
         SfavuW2LfbsWfnsTe6Sxd7IG08xfLk87t2R+JC6AfQl0IiFVeA7xzIA+SybF07eSFKf0
         HBiyJiEgSQt2XUehahmrtG3q4IYdNZK+yCy2cy2JOlPnvnywlIUJFnbjBISP3B6vwpWt
         VeangM6uN5ADKANyvI/1w0yChiiFy7BfVhI4kR3d7dN5IfOI8au0gv13Fnzq2P6lBrJg
         C+hUcvNqD6J8HyloZgSFT8nnm2lRZPeLUyDQm/reSQB0Ms5XHLKXs6g38YBBlPidobLy
         LZYQ==
X-Gm-Message-State: AFqh2krHCmv3VGMdQnCU7JhvPT/eCQClBAwRQkEZzSlT7s2X/abnrMWv
        0+wTbszH4E48lhpUEQXu3OfKecVIoKV0ZV+EHzTnasgs2bwGcbm3kSCr1KDRr6Epb/qFio8jFaw
        S2Y9hbLDW8Yrrv4zNwdSwZiQtV84Qnyi+tfT4Znvia3PufCIc65A/YRrKVSz51dQF8MH2
X-Google-Smtp-Source: AMrXdXvX86inkt8Gw5ivwZ8h18y7lCjZwIrL2Zq++0XgxfguMo6PjUeGUuCUa5qjoOsJxQfzSlagBKrzUNY4kuy3
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:4393:b0:56b:e64c:5c7e with
 SMTP id bt19-20020a056a00439300b0056be64c5c7emr1272345pfb.18.1672417507151;
 Fri, 30 Dec 2022 08:25:07 -0800 (PST)
Date:   Fri, 30 Dec 2022 16:24:41 +0000
In-Reply-To: <20221230162442.3781098-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221230162442.3781098-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221230162442.3781098-6-aaronlewis@google.com>
Subject: [PATCH v2 5/6] KVM: selftests: Add XFEATURE masks to common code
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

Add XFEATURE masks to processor.h to make them more broadly available
in KVM selftests.

They were taken from fpu/types.h, which included a difference in
spacing between the ones in amx_test from XTILECFG and XTILEDATA, to
XTILE_CFG and XTILE_DATA.  This has been reflected in amx_test.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 16 ++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 22 +++++++------------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 5f06d6f27edf7..c1132ac277227 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -45,6 +45,22 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
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
+#define XFEATURE_MASK_AVX512		(XFEATURE_MASK_OPMASK \
+					 | XFEATURE_MASK_ZMM_Hi256 \
+					 | XFEATURE_MASK_Hi16_ZMM)
+#define XFEATURE_MASK_XTILE		(XFEATURE_MASK_XTILE_DATA \
+					 | XFEATURE_MASK_XTILE_CFG)
+
 /* Note, these are ordered alphabetically to match kvm_cpuid_entry2.  Eww. */
 enum cpuid_output_regs {
 	KVM_CPUID_EAX,
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 4b733ad218313..14a7656620d5f 100644
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
2.39.0.314.g84b9a713c41-goog

