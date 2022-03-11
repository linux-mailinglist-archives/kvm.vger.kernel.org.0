Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24504D67D2
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350852AbiCKRmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350831AbiCKRmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:42:10 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6411BE4D0
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:07 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id 3-20020a056e020ca300b002c2cf74037cso5978815ilg.6
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7ZRBkS4U0RFhMHj2rsuxMbzaij5n0dyzv68dBdi/1V4=;
        b=agb3tdzKqOaqoSpS5U/p593tiHNWqqZJpCJfTx6gflLYyYPaiUx9HO1yB+3F8H6FmE
         cVmT3Q3SIyKv2ALdwrHb71MbMAovi69YILYjVnI8iH2bT94dX9eYTXj922gCmpI9Bz4G
         0ICO77FbsL3yb1LVQra6lGmL0ybIgUa5vLxMGVJUJGMWGQplz1gVTXf7+h9teAs/s7ly
         6VS2GxT/OsB7vGqrMOHEmHMZq2e9MRHJ64j7+VwGzT9A3Ct64Kb6KQFimn57Jg1ISLuX
         3I07mWDcVavQz4BZFLNYaY4e67ThPDC2U7U3teJaD5KtlB/2Wu3f/3S8JFbaA0GrCvh3
         sLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7ZRBkS4U0RFhMHj2rsuxMbzaij5n0dyzv68dBdi/1V4=;
        b=HTedc4hv07kNPwpjPAvYmx33V7Al0krjHIJ7NyV2D8Cmm86ebrU3umXbmklM9XR/7q
         0cOLjv/aVxmaHC2Mn/ko7gkp1UlWj9reTurwb939h2EjRpV0S1sKyLPDM1DmI6RRFSom
         LgH9m2dsx/DprTDeci+wBePqY5rIWs1vlS1n77xSYbe2h0dS3QNM3PZmH07qgA7Q1Dl6
         KlUNnhXwDAHbnua3eATLZsi+ANjNx01AW4Zuh1me1Prz6dUbnbqdvwLQQw4MM9mI28BM
         +Jz5i6DUpYMlthRX2JlfCOt/6hVlKqGhLzNzfQ1JyR8A0oF46Rjnyhqon0UDF6Z+Vttb
         j5MA==
X-Gm-Message-State: AOAM530jQHM3HRrgtPzHxIjtmN4HhTyBG5vCk2Cayj6X9AGCEmzb/PWU
        swK71Pg+McNjZHyc0dW4euJq7TyBG5k=
X-Google-Smtp-Source: ABdhPJw9BiYukm5oFkfLFDSfcoF0YG+SBFyjRPDOEtEfu56g5hciDXgPevhVFTjypFLBz3WPqlZZ86y7cJg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5e:a80a:0:b0:645:b477:bc23 with SMTP id
 c10-20020a5ea80a000000b00645b477bc23mr8739969ioa.191.1647020467117; Fri, 11
 Mar 2022 09:41:07 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:39:52 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-7-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 06/15] KVM: arm64: Rename the KVM_REQ_SLEEP handler
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     alexandru.elisei@arm.com, anup@brainfault.org,
        atishp@atishpatra.org, james.morse@arm.com, jingzhangos@google.com,
        jmattson@google.com, joro@8bytes.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, ricarkol@google.com, seanjc@google.com,
        suzuki.poulose@arm.com, vkuznets@redhat.com, wanpengli@tencent.com,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>
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

The naming of the kvm_req_sleep function is confusing: the function
itself sleeps the vCPU, it does not request such an event. Rename the
function to make its purpose more clear.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3918d078fc4d..7c297ddc8177 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -594,7 +594,7 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 	}
 }
 
-static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
+static void kvm_vcpu_sleep(struct kvm_vcpu *vcpu)
 {
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
@@ -652,7 +652,7 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
-			vcpu_req_sleep(vcpu);
+			kvm_vcpu_sleep(vcpu);
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_reset_vcpu(vcpu);
-- 
2.35.1.723.g4982287a31-goog

