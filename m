Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C06603524
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 23:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiJRVqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 17:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiJRVqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 17:46:22 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E2DB56D6
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-349423f04dbso153137677b3.13
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 14:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HReMimd/H0bznbCp0FcGUwVU95KXf+ukGx45CyBX7Z8=;
        b=qqDTf++UkzDQHQkKEdFVVu9Ud7rITz8INeDQxoR+L61vdbzKSyLeEuyGwj03V7wrM2
         tqq1NuYfiHT+XStV2YIvpTmk2f3O2dOtMu05rdjdmUnVEAGzzxbjYYX+hGS06P9l8nCc
         XFH7rebz/qxFriJhys7f39PnP97XYqTT9/FEj1k9lGHK6e7n7M4HIHYm4kgCz4khYpgw
         AewOSakcGmHVFDCYxZobpZDdcLj2qSJGw1ssFlVUJJzqZ+if6mr7ZNxcSdInsgRO1CD2
         rMCXvorV0loMpuNTSCFudDlPjwITcS6LuGUi7uUCeizGlY8Vnb9uZ8k4y3wngpyHNRMK
         a5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HReMimd/H0bznbCp0FcGUwVU95KXf+ukGx45CyBX7Z8=;
        b=2BbY0xVEPUn9EAxpRN5WFcvZdBIzjmFC4gUtVw+q7sCdhTJva8FdzvZYgk7ZpqTK+M
         WQnx8gdnh9PFP2zU9Mghe14gITmucUF/dCiwh8Eyrbhi+/Zk0/8gbfwH7lNqPldrt39I
         diWk3wYnys4gOSOozLh4vQ4c0mwDm+7kJPs+K78FJrKU6xOBLuRpyICJzclOV733WUxU
         BSl7FcuTm7rZdVasb8Q+7g7YczcwhoBDtkMGvNYHN7qTjZGFhio30YT0Qd8D6Gq2Rrg+
         ZZ2rQ7iIg9drc4r8uVKI/wRbo5tEqYfOSzaUm2W6Kq75o/RJauTjJb9S3BxJP7q3e1Zo
         vzUQ==
X-Gm-Message-State: ACrzQf2N4SHBvwPYmRocC0nLs8SrGNQ2yO5r3RHSH3bDX/OdmR+gGMyq
        KZPmx7804wdMWq/j6t7fofliOa8irgY1rg==
X-Google-Smtp-Source: AMsMyM7QEL0E/u9r8326E9p5OHlltCrnGwax65vlXOMd31mGPTXlCMuwFbPs+fweX9+aOEgUpM2qdwUCTWWPkQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:bd0f:0:b0:6c0:8cb1:d2b4 with SMTP id
 f15-20020a25bd0f000000b006c08cb1d2b4mr4192425ybk.95.1666129580677; Tue, 18
 Oct 2022 14:46:20 -0700 (PDT)
Date:   Tue, 18 Oct 2022 14:46:07 -0700
In-Reply-To: <20221018214612.3445074-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221018214612.3445074-4-dmatlack@google.com>
Subject: [PATCH v2 3/8] KVM: selftests: Delete dead ucall code
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>
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
---
 .../smaller_maxphyaddr_emulation_test.c       | 54 +------------------
 1 file changed, 2 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
index c5353ad0e06d..d6e71549ca08 100644
--- a/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smaller_maxphyaddr_emulation_test.c
@@ -90,64 +90,15 @@ static void process_exit_on_emulation_error(struct kvm_vcpu *vcpu)
 	vcpu_regs_set(vcpu, &regs);
 }
 
-static void do_guest_assert(struct ucall *uc)
-{
-	REPORT_GUEST_ASSERT(*uc);
-}
-
-static void check_for_guest_assert(struct kvm_vcpu *vcpu)
+static void assert_ucall_done(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
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
 	TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_DONE,
 		    "Unexpected ucall command: %lu, expected UCALL_DONE (%d)",
 		    uc.cmd, UCALL_DONE);
 }
 
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
@@ -184,8 +135,7 @@ int main(int argc, char *argv[])
 	vcpu_run(vcpu);
 	process_exit_on_emulation_error(vcpu);
 	vcpu_run(vcpu);
-
-	TEST_ASSERT(process_ucall(vcpu) == UCALL_DONE, "Expected UCALL_DONE");
+	assert_ucall_done(vcpu);
 
 	kvm_vm_free(vm);
 
-- 
2.38.0.413.g74048e4d9e-goog

