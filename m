Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C6563B469
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 22:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiK1VrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 16:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiK1VrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 16:47:15 -0500
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12782FFF9;
        Mon, 28 Nov 2022 13:47:14 -0800 (PST)
Received: by mail-wm1-f47.google.com with SMTP id v7so9536014wmn.0;
        Mon, 28 Nov 2022 13:47:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0q+pi2LlFPiueuPI6vQdyfzoD0KMzMDwbTWkzbbDN0o=;
        b=V5ZPJdPKU+61pZgMR2H41oYInBCg0BJcNVRByEE47KxmMP8EsKYu6dyAJaGKWnuMPO
         3Y1fNi0K/vuaLlyBgbBLJEdXboWH/dgEP51ruiN7Kx3AL419ixdM59klyXmMaQbdpmP5
         mBdasHX2nQcBz1qnzdn7P9tMObOih4weMuWq7MZpTIcwCk4WDY8rRnXPXKQAFMdPv+wS
         xCMF2Ma5DqHMWkB01Z9JOJ3EL/bYlFPLfdXZMLbUbZtEa+u0hZ/ZmURRfzxcgRWrtycD
         gi2etHsQ9770+5vdNuHqecWgsny/iwyhm3Q9QwBOsBIyXcNwZGQb4UnIce4GNRrSdKA6
         noYg==
X-Gm-Message-State: ANoB5plLBouEd+lDRWM+9YeUKMo/UplqZYUEYsI/OTsihyccayGeUwVX
        1V7REUDozZ7ul7G/qhx7sQcoiG5FTcU=
X-Google-Smtp-Source: AA0mqf7cuRuJLr7B6m6c4Bc1U/AAS/AIhSruO1z1ujOEs/qc1NqAVigeka8XUhl3hxDNw2R2rtxtbw==
X-Received: by 2002:a05:600c:3d8f:b0:3cf:6b14:1033 with SMTP id bi15-20020a05600c3d8f00b003cf6b141033mr39832096wmb.103.1669672032880;
        Mon, 28 Nov 2022 13:47:12 -0800 (PST)
Received: from liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id c15-20020adfe70f000000b00241e8d00b79sm13909433wrm.54.2022.11.28.13.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 13:47:12 -0800 (PST)
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
Subject: [PATCH v2] KVM: x86/mmu: fix an incorrect comment in kvm_mmu_new_pgd()
Date:   Mon, 28 Nov 2022 21:47:09 +0000
Message-Id: <20221128214709.224710-1-wei.liu@kernel.org>
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

There is no function named kvm_mmu_ensure_valid_pgd().

Fix the comment and remove the pair of braces to conform to Linux kernel
coding style.

Signed-off-by: Wei Liu <wei.liu@kernel.org>
---
v2: incorporate Sean's suggestions
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b6f96d47e596..a1895fd9eaf4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4452,10 +4452,12 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role new_role = mmu->root_role;
 
-	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
-		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
+	/*
+	 * Return immediately if no usable root was found, kvm_mmu_reload()
+	 * will establish a valid root prior to the next VM-Enter.
+	 */
+	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role))
 		return;
-	}
 
 	/*
 	 * It's possible that the cached previous root page is obsolete because
-- 
2.35.1

