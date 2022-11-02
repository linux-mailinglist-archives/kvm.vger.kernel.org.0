Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB825616D08
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbiKBSrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiKBSrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:03 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B89D2CE27
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:03 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36fc0644f51so165660277b3.17
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cMB6TX5uDf1QAJ7HvbUaBRObClM1MNgowri3IAfpFFY=;
        b=VauRlSFVm86d5oJHtfg4zSldCKdbxKThcr5I1twnfjAgsrppOQ0DbeQRgCa/HXam/Q
         F94c+F7Ek6v10tbSmme1HDxuMaM0ZK78uhE/DR/xGFMUaCw/Z3UxYop+jaliu3xydblO
         oSFTWwMXjoDH9V2WzB5BH/xcZ2FpjaN0B0MI9A6+Jb0++jVvTgfi/Hz1hAZYasr1rfjs
         VvZQpGkagO18C2IaWWMUja/grz3WSJrwkbV3CvvY6GtUiL+G2CoSsReyqq/1IH/mgWHA
         PF0lWD28fv6JcdmQLusZJ6ZHpzINCaPDT5KYGWg0EKdyeS9DJN1xh4gHKkboNl+QVPnL
         UkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cMB6TX5uDf1QAJ7HvbUaBRObClM1MNgowri3IAfpFFY=;
        b=68vDa4xgTw01vfHkMQWNEFG6GuQ00kl66NdCO2UH/gkw2oZDZDgisV2NQxSvZT54vU
         xPiEawBu9vDZ5F4ZRx1DDPtF3QrfRa4loUObfbzrt7/yoFtlkSaLUxFGfeWle3lTOXKm
         0V1ZQFz2gHjYcHypl9srOT2yTb9v1+MjWEPE51qtb25bc+xwNZsgzIbGGZ1JEIX7OebY
         Je2vUjawpcmT1mHRW0IGl3mPISggs3UeXUQ5uEWN5w4Saf0N/bXoxJq4a0FjZmNdLDcn
         O0Hf/SoN7wU/z8TpSndNcj1/XrktlVHtl/MSF41sE3+kLdSQwgaWFlRRImwCTYYvUT2i
         jAuw==
X-Gm-Message-State: ACrzQf0zl16TE0e2Y2QF+7BVTjdhDr91ByGh31y07tEyU0DEhR+PAlmF
        v6PckK9Z25A0dyuA8LnodN8CKB2HBseTKw==
X-Google-Smtp-Source: AMsMyM4+47uBszbYBydrPC4GTCo0jqqlsf8OemUUFXinQvbfOQDsvqzYf9lbWqCVoc2BTk+jDzfNgYPmPZ20bQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:6f88:0:b0:35f:df0e:3a7a with SMTP id
 k130-20020a816f88000000b0035fdf0e3a7amr25239243ywc.416.1667414822529; Wed, 02
 Nov 2022 11:47:02 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:47 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-4-dmatlack@google.com>
Subject: [PATCH v4 03/10] KVM: selftests: Delete dead ucall code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

Delete a bunch of code related to ucall handling from
smaller_maxphyaddr_emulation_test. The only thing
smaller_maxphyaddr_emulation_test needs to check is that the vCPU exits
with UCALL_DONE after the second vcpu_run().

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../smaller_maxphyaddr_emulation_test.c       | 61 +------------------
 1 file changed, 1 insertion(+), 60 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index d92cd4139f6d..f9fdf365dff7 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -63,64 +63,6 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
 	vcpu_regs_set(vcpu, &regs);
 }
 
-static void do_guest_assert(struct ucall *uc)
-{
-	REPORT_GUEST_ASSERT(*uc);
-}
-
-static void check_for_guest_assert(struct kvm_vcpu *vcpu)
-{
-	struct ucall uc;
-
-	if (vcpu->run->exit_reason == KVM_EXIT_IO &&
-	    get_ucall(vcpu, &uc) == UCALL_ABORT) {
-		do_guest_assert(&uc);
-	}
-}
-
-static void process_ucall_done(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	struct ucall uc;
-
-	check_for_guest_assert(vcpu);
-
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-
-	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
-		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
-		    uc.cmd, UCALL_DONE);
-}
-
-static uint64_t process_ucall(struct kvm_vcpu *vcpu)
-{
-	struct kvm_run *run = vcpu->run;
-	struct ucall uc;
-
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-		    "Unexpected exit reason: %u (%s)",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
-
-	switch (get_ucall(vcpu, &uc)) {
-	case UCALL_SYNC:
-		break;
-	case UCALL_ABORT:
-		do_guest_assert(&uc);
-		break;
-	case UCALL_DONE:
-		process_ucall_done(vcpu);
-		break;
-	default:
-		TEST_ASSERT(false, "Unexpected ucall");
-	}
-
-	return uc.cmd;
-}
-
 int main(int argc, char *argv[])
 {
 	struct kvm_vcpu *vcpu;
@@ -157,8 +99,7 @@ int main(int argc, char *argv[])
 	vcpu_run(vcpu);
 	process_exit_on_emulation_error(vcpu);
 	vcpu_run(vcpu);
-
-	TEST_ASSERT(process_ucall(vcpu) == UCALL_DONE, "Expected UCALL_DONE");
+	ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
 
 	kvm_vm_free(vm);
 
-- 
2.38.1.273.g43a17bfeac-goog

