Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC472513A
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 02:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240260AbjFGAqm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 20:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbjFGAqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 20:46:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95C189
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 17:46:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-52857fc23b1so5957798a12.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 17:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686098799; x=1688690799;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/VjdTgpDcT/dS1LNnv8iDFQQueMacBncHOzc48DAKj8=;
        b=c9AsXxDWT0gzp5q/ErKD1QiqLU2yryyO83LQCVlwv1EUlMSi0tX/m04vbma2cdeLMw
         Ri+hIPgk9ELtir4CkCRQPZKacnJeuweXNPSFZTHLrPJLdQlXXLHFlJcjRgu786HvdwDG
         Oj3gd+ZMMq6WzWagrOhbuqUE+nug6FsxF1/tgX83odv9rQQinUzNaQdGS9WYFlFTjc04
         4lUHOjQhfQqk7+CrW7WW9ZRKlglcYdVsKyQnch5pW8x9YB8EN/XSOrsM4wFFFyG3+b6E
         vbwt1Iro+OYvtb9cR4bXN28eiV++f6XJmgMDMG335qAmy7iGENda63hRxjEZWQpYtT9H
         S9ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686098799; x=1688690799;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/VjdTgpDcT/dS1LNnv8iDFQQueMacBncHOzc48DAKj8=;
        b=Uhr+fL2CatZz6UW2Nt2Ygda+AqfCH6oJdduJGhDPv5cA8zq7Uy7rnUkW3jGQPbjpWf
         SKIbPbI9J/l8Gx7bOndLh2OKCeGvUrv3tdUfiokbJt9dUqTsMuJBIXXKHHbuptzZ4rMD
         v42sf/xB/iGYSCdhh1Rv5DFTskumtJR3qPutnHl16j8bZfDKNIRE8C9/CSY+UXsowUoJ
         0Z/5X4ONvCdOlfVbD/EAlKiHXo2o0K5DHk4uU486kDqCeXZ+U8LkGwh4449XudsgJ9zA
         LLx6yfbxkC5R7sP0J/OkfkDD37G5LlYbgEei1rM9wQN7y48PoGPG4jbac1OOzx+auytd
         2wQg==
X-Gm-Message-State: AC+VfDzTWZtn/Zn3gg5pGI+WuycbPkRl6FeaYGXY5/qZG5J1UFEAllki
        IGSA+bdZyjR/kNPTJx2+QO3PcLCKFQI=
X-Google-Smtp-Source: ACHHUZ4q5Ka7zSH23P2/S5hiUlEw/WG2v18E0Z8k93HTLm5/cYV+Nc8kKNhnYxZSSOToXvgd69Iz5Ye9res=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:225b:0:b0:519:d08d:a4d5 with SMTP id
 t27-20020a63225b000000b00519d08da4d5mr824334pgm.6.1686098799145; Tue, 06 Jun
 2023 17:46:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  6 Jun 2023 17:46:36 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230607004636.1421424-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Update comments about MSR lists exposed to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refresh comments about msrs_to_save, emulated_msrs, and msr_based_features
to remove stale references left behind by commit 2374b7310b66 (KVM:
x86/pmu: Use separate array for defining "PMU MSRs to save"), and to
better reflect the current reality, e.g. emulated_msrs is no longer just
for MSRs that are "kvm-specific".

Reported-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ad55ef71433..c77f72cf6dc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1427,15 +1427,14 @@ int kvm_emulate_rdpmc(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
 
 /*
- * List of msr numbers which we expose to userspace through KVM_GET_MSRS
- * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
- *
- * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features)
- * extract the supported MSRs from the related const lists.
- * msrs_to_save is selected from the msrs_to_save_all to reflect the
- * capabilities of the host cpu. This capabilities test skips MSRs that are
- * kvm-specific. Those are put in emulated_msrs_all; filtering of emulated_msrs
- * may depend on host virtualization features rather than host cpu features.
+ * The three MSR lists(msrs_to_save, emulated_msrs, msr_based_features) track
+ * the set of MSRs that KVM exposes to userspace through KVM_GET_MSRS,
+ * KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.  msrs_to_save holds MSRs that
+ * require host support, i.e. should be probed via RDMSR.  emulated_msrs holds
+ * MSRs that emulates without strictly requiring host support.
+ * msr_based_features holds MSRs that enumerate features, i.e. are effectively
+ * CPUID leafs.  Note, msr_based_features isn't mutually exclusive with
+ * msrs_to_save and emulated_msrs.
  */
 
 static const u32 msrs_to_save_base[] = {
@@ -1531,11 +1530,11 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_UCODE_REV,
 
 	/*
-	 * The following list leaves out MSRs whose values are determined
-	 * by arch/x86/kvm/vmx/nested.c based on CPUID or other MSRs.
-	 * We always support the "true" VMX control MSRs, even if the host
-	 * processor does not, so I am putting these registers here rather
-	 * than in msrs_to_save_all.
+	 * KVM always supports the "true" VMX control MSRs, even if the host
+	 * does not.  The VMX MSRs as a whole are considered "emulated" as KVM
+	 * doesn't strictly require them to exist in the host (ignoring that
+	 * KVM would refuse to load in the first place if the core set of MSRs
+	 * aren't supported).
 	 */
 	MSR_IA32_VMX_BASIC,
 	MSR_IA32_VMX_TRUE_PINBASED_CTLS,

base-commit: 31b4fc3bc64aadd660c5bfa5178c86a7ba61e0f7
-- 
2.41.0.162.gfafddb0af9-goog

