Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7001639D86
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 23:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiK0WNB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 17:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiK0WM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 17:12:59 -0500
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E0BDF00;
        Sun, 27 Nov 2022 14:12:58 -0800 (PST)
Received: by mail-wr1-f47.google.com with SMTP id w15so917322wrl.9;
        Sun, 27 Nov 2022 14:12:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H93P/+btHMmnUHfAxiUxxWr+DgQtxwEFifMZUFb22Lo=;
        b=lVayMRecf2VR+UhFlsGcD8Z1eVqCI4RexZRzJ0tSxSfuI09yi1s6Llh330SCaGkDWR
         xQY2WdVHa3f3Fv6vmgohqXugBu4ghOT20gcoPHwS6BbaftOVzbGTku3PPhS4p9FfIGkE
         E1sDq5VCl2klUpEXCtJVLUBlY0Fat8Z375gg7jld8jN+P79p7T049Opka+axjvaGsi69
         3rpyJVJ4Nc4FUfC8HxQu4ejeEup55KAo04mdmizUAnC/FqNxsRId3ZNnjugCeqnG7MWZ
         yQSzqxZ6k/qnvssaoU47J83CoeCoQfdlOfd9ZmFmI8BYbgxmwHd1bq2S6Vsm34R/trrz
         wibw==
X-Gm-Message-State: ANoB5ploOPPpe4U2rli0TP662rxvgi+WrqlR+PGq9tUwbgDieK8hZAey
        H3bMG1wUER+KsdelPKC3syDb1WpMgaM=
X-Google-Smtp-Source: AA0mqf74qn8YSCcOe6m+lWpMmTSFR6gKv3nG+XEOP5Pz1jn9MTTUXrZzRbQ/o3+7BRATarbJGSYUIA==
X-Received: by 2002:a05:6000:783:b0:241:bc34:3149 with SMTP id bu3-20020a056000078300b00241bc343149mr23821253wrb.351.1669587176312;
        Sun, 27 Nov 2022 14:12:56 -0800 (PST)
Received: from liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id m16-20020a05600c3b1000b003cfd0bd8c0asm14232298wms.30.2022.11.27.14.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 14:12:55 -0800 (PST)
From:   Wei Liu <wei.liu@kernel.org>
To:     kvm@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH] KVM: x86/mmu: fix an incorrect comment in kvm_mmu_new_pgd
Date:   Sun, 27 Nov 2022 22:12:45 +0000
Message-Id: <20221127221245.204208-1-wei.liu@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no function named kvm_mmu_ensure_valid_pgd.

Fix the comment and remove the pair of braces to conform to Linux kernel
coding style.

Signed-off-by: Wei Liu <wei.liu@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b6f96d47e596..361574124fbe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4452,10 +4452,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role new_role = mmu->root_role;
 
-	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
-		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
+	/*
+	 * Return immediately if no usable root is found. A new root will be
+	 * set up in vcpu_enter_guest prior to the next vmenter.
+	 */
+	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role))
 		return;
-	}
 
 	/*
 	 * It's possible that the cached previous root page is obsolete because
-- 
2.35.1

