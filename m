Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ADC5ABC0F
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 03:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiICB31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 21:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiICB3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 21:29:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FAAF2C83
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 18:29:17 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e16-20020a17090301d000b00172fbf52e7dso2196347plh.11
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 18:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=cqeY+grZVEhRguTUUeqvYOSdNQfIs+sWu8vr9QDoht8=;
        b=ew3oq0QlDXeiga/a4o56WUnaQoA8tSTqzn6P1h8N6KPD89ud1VuUwgt5JT9RjNTrxy
         spZz2ZjUU7FIz9kSFWwKFN3Tbzcn4ZXJ/lArwvHaD6jhpGy5oMG1Mcxl5S7D0Mm4p8Eb
         4mXCQeugDAU5S4k2eNGNfJg0oESlkeLaSjr2TLebe7AyWXgG0xRPBTLdVMEUXhZLuqpH
         /KXXPC3EoWn9PWeHm07i6wSW64sPQ15pLDPOVrrtf8rCrmsFlkO45MvO6uLIaBgGPS9C
         4Lm9EpFvdNaPvYzA2jMjqIrLqZ9F/zU3EYvi+5/7dTzThWq3/idXzvDlbe5lWFKrRqWw
         i73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=cqeY+grZVEhRguTUUeqvYOSdNQfIs+sWu8vr9QDoht8=;
        b=SnVV4UbJ3AB6jkYFPLyIAW9cwGFNsDOd19pt0hHpxLigXICebNIZsVCdWHvSXKv3Cu
         kqLoLqInaZ7sA7hViLT13ZkF8ivBWuvgIGOgunDAc9Nv6dPiL9NfZXpobZWBeYAgCK+K
         M6qCqlFXTB1Nsy1SXPKJWeyIvc9BAInNv+Pb0s/Vbe+fZAn4oLy16f2FvSvXG9+Xubtx
         74sz3hYwYc5mL2ru/dZn/vS3T9RnT1PeYDnh4ogtTjhzSPguop1CuxUsDUIvBeAO7CNk
         vHdlZcRrfY+uMkHVCsxhNj+JnJLjbOdo4VpHE4o7vQGhlPhEj2CdLW1CCl9dDg2B0WXj
         vlgg==
X-Gm-Message-State: ACgBeo2bk6h597xwZourCXlmH9E9VqkPjUwJwAa/M9Ou9obhnwfep/JZ
        pJmwtWfdxlwWEWOnQAltqKyoHXf+M8pvPz5M
X-Google-Smtp-Source: AA6agR7JimEDwH6PgWfw9vo/qKMh6zueekKuIUqRudZGwvAdv0ECioREghixSWr/yuoL6YAjN4V3M6wVKdCrxlHi
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:aa7:9098:0:b0:538:58ab:8fee with SMTP
 id i24-20020aa79098000000b0053858ab8feemr25172507pfa.7.1662168557132; Fri, 02
 Sep 2022 18:29:17 -0700 (PDT)
Date:   Sat,  3 Sep 2022 01:28:48 +0000
In-Reply-To: <20220903012849.938069-1-vannapurve@google.com>
Mime-Version: 1.0
References: <20220903012849.938069-1-vannapurve@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903012849.938069-5-vannapurve@google.com>
Subject: [V1 PATCH 4/5] selftests: kvm: delete svm_vmcall_test
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, bgardon@google.com,
        seanjc@google.com, oupton@google.com, peterx@redhat.com,
        vkuznets@redhat.com, drjones@redhat.com, dmatlack@google.com,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm_vmcall_test is superseded by fix_hypercall_test.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 -
 .../selftests/kvm/x86_64/svm_vmcall_test.c    | 73 -------------------
 2 files changed, 74 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d625a3f83780..22e9a5b5488c 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -36,7 +36,6 @@
 /x86_64/sev_migrate_tests
 /x86_64/smm_test
 /x86_64/state_test
-/x86_64/svm_vmcall_test
 /x86_64/svm_int_ctl_test
 /x86_64/svm_nested_soft_inject_test
 /x86_64/sync_regs_test
diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
deleted file mode 100644
index 95ddc2bff332..000000000000
--- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
+++ /dev/null
@@ -1,73 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * svm_vmcall_test
- *
- * Copyright (C) 2020, Red Hat, Inc.
- *
- * Nested SVM testing: VMCALL
- */
-
-#include "test_util.h"
-#include "kvm_util.h"
-#include "processor.h"
-#include "svm_util.h"
-
-static void l2_guest_code(struct svm_test_data *svm)
-{
-	__asm__ __volatile__("vmcall");
-}
-
-static void l1_guest_code(struct svm_test_data *svm)
-{
-	#define L2_GUEST_STACK_SIZE 64
-	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
-	struct vmcb *vmcb = svm->vmcb;
-
-	/* Prepare for L2 execution. */
-	generic_svm_setup(svm, l2_guest_code,
-			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
-
-	run_guest(vmcb, svm->vmcb_gpa);
-
-	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
-	GUEST_DONE();
-}
-
-void __main(int argc, char *argv[])
-{
-	struct kvm_vcpu *vcpu;
-	vm_vaddr_t svm_gva;
-	struct kvm_vm *vm;
-
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
-
-	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
-
-	vcpu_alloc_svm(vm, &svm_gva);
-	vcpu_args_set(vcpu, 1, svm_gva);
-
-	for (;;) {
-		volatile struct kvm_run *run = vcpu->run;
-		struct ucall uc;
-
-		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
-			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
-			    run->exit_reason,
-			    exit_reason_str(run->exit_reason));
-
-		switch (get_ucall(vcpu, &uc)) {
-		case UCALL_ABORT:
-			REPORT_GUEST_ASSERT(uc);
-			/* NOT REACHED */
-		case UCALL_SYNC:
-			break;
-		case UCALL_DONE:
-			goto done;
-		default:
-			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
-		}
-	}
-done:
-	kvm_vm_free(vm);
-}
-- 
2.37.2.789.g6183377224-goog

