Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACC953C1BD
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiFCAqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240090AbiFCAoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:55 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DA935A9A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:40 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so1807726pjb.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=u1IgrS502o6DaNoA2228GMoWiPrKqkjMnHgUvFiLMQ8=;
        b=WMeD7TT4HAy7DZ12Jd0IR3/ER65DJfhCCfFr0y+EXS9bS9hxIlItQcv3/ZT+wvfPIb
         WT1t0BUUxAZKmhGjW6aqiX903SpYYuPqwMghwaoRqJG/XxU9/fp3YIzTF4bB184Eb4cN
         Bv0EkAyiNQIdDWV2icV/Uhgdk2RyhJFYp82Jsay4a4AzOXfaRCl/z4bKSShp52POROhv
         Qu1BqbOXJA8uaWVAJeewwYgMNCy4Y3vmkuTL/teXDhFVBYp07jAkuxEoRDbHTlwY5JFx
         Ykf0k1eTKcu8wPzkpiCYCczRkGXRW0g1MIr+NWjYNEx7NjwK1De1MhYkbEJiWW6JL7Jk
         WiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=u1IgrS502o6DaNoA2228GMoWiPrKqkjMnHgUvFiLMQ8=;
        b=tg9/GHNVqgg2crDpOVk35tOSK6YJAwYBQV0uNZnbLRGbz/3LR+nOZ6PTScxFDxdDYL
         Xwyho1cQ9cZzqwZiGHV40/3Mol4SrUCS1wRVielXVuPIP8fxjZ5bFsJ50PBwP1R4MZRw
         7kqf/CdqaGpKRMq9pxKYN2D1HLumLtOsfdHGhC53KtFptzHK+Q5B5xNqf6t7OGQ6Bg+L
         W1s1nijybO+I2/vZeJ7pWiqWwnK4oxBKPuBgb+MldCnU2eVD1hN0Un090ekqTnh19X4u
         Q049XWN1pDYy4DBWJG12zOao4TYeJ5f+becTYr+S/Kv1bBZjtZxoPei4FPxDPiGS9dmg
         3SrQ==
X-Gm-Message-State: AOAM533Zhi5Pgb92A12RRyIRBoi6ygwE3V0Zrgg0gpxKoiWPj6RazaOv
        UoXNKIdztzlhrPJtCDxGitceTVDVrHc=
X-Google-Smtp-Source: ABdhPJzLHTRTXmbyaRPugggbXGP4hYk4nxHkvVjrWJvbcKD+d9AGltsmbr1NqMUqCDOblmlVxqVOsbEhOEA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d54b:b0:164:bf9:3e1e with SMTP id
 z11-20020a170902d54b00b001640bf93e1emr7800481plf.58.1654217080298; Thu, 02
 Jun 2022 17:44:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:42 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-36-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 035/144] KVM: selftests: Rename MP_STATE and GUEST_DEBUG
 helpers for consistency
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
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

Move the get/set part of the MP_STATE and GUEST_DEBUG helpers to the end
to align with the many other ioctl() wrappers/helpers.  Note, this is not
an endorsement of the predominant style, the goal is purely to provide
consistency in the selftests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/psci_test.c          | 2 +-
 tools/testing/selftests/kvm/include/kvm_util_base.h      | 9 +++++++--
 tools/testing/selftests/kvm/lib/x86_64/processor.c       | 2 +-
 tools/testing/selftests/kvm/x86_64/debug_regs.c          | 2 +-
 .../selftests/kvm/x86_64/svm_nested_soft_inject_test.c   | 2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/psci_test.c b/tools/testing/selftests/kvm/aarch64/psci_test.c
index 1a351f3f443d..1485d0b05b66 100644
--- a/tools/testing/selftests/kvm/aarch64/psci_test.c
+++ b/tools/testing/selftests/kvm/aarch64/psci_test.c
@@ -70,7 +70,7 @@ static void vcpu_power_off(struct kvm_vm *vm, uint32_t vcpuid)
 		.mp_state = KVM_MP_STATE_STOPPED,
 	};
 
-	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+	vcpu_mp_state_set(vm, vcpuid, &mp_state);
 }
 
 static struct kvm_vm *setup_vm(void *guest_code)
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index c9d94c9f2031..edbbbbe4cd5d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -374,13 +374,18 @@ static inline void vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
 	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, &enable_cap);
 }
 
-static inline void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
+static inline void vcpu_guest_debug_set(struct kvm_vm *vm, uint32_t vcpuid,
 					struct kvm_guest_debug *debug)
 {
 	vcpu_ioctl(vm, vcpuid, KVM_SET_GUEST_DEBUG, debug);
 }
 
-static inline void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
+static inline void vcpu_mp_state_get(struct kvm_vm *vm, uint32_t vcpuid,
+				     struct kvm_mp_state *mp_state)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_MP_STATE, mp_state);
+}
+static inline void vcpu_mp_state_set(struct kvm_vm *vm, uint32_t vcpuid,
 				     struct kvm_mp_state *mp_state)
 {
 	vcpu_ioctl(vm, vcpuid, KVM_SET_MP_STATE, mp_state);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a6c35f269013..9268537f9bd7 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -655,7 +655,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 
 	/* Setup the MP state */
 	mp_state.mp_state = 0;
-	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+	vcpu_mp_state_set(vm, vcpuid, &mp_state);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86_64/debug_regs.c b/tools/testing/selftests/kvm/x86_64/debug_regs.c
index 5f078db1bcba..f726645bb9c3 100644
--- a/tools/testing/selftests/kvm/x86_64/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86_64/debug_regs.c
@@ -67,7 +67,7 @@ static void guest_code(void)
 }
 
 #define  CLEAR_DEBUG()  memset(&debug, 0, sizeof(debug))
-#define  APPLY_DEBUG()  vcpu_set_guest_debug(vm, VCPU_ID, &debug)
+#define  APPLY_DEBUG()  vcpu_guest_debug_set(vm, VCPU_ID, &debug)
 #define  CAST_TO_RIP(v)  ((unsigned long long)&(v))
 #define  SET_RIP(v)  do {				\
 		vcpu_regs_get(vm, VCPU_ID, &regs);	\
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index 18061677154f..f834b9a1a7fa 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -166,7 +166,7 @@ static void run_test(bool is_nmi)
 	vcpu_args_set(vm, VCPU_ID, 3, svm_gva, (uint64_t)is_nmi, (uint64_t)idt_alt_vm);
 
 	memset(&debug, 0, sizeof(debug));
-	vcpu_set_guest_debug(vm, VCPU_ID, &debug);
+	vcpu_guest_debug_set(vm, VCPU_ID, &debug);
 
 	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
 	struct ucall uc;
-- 
2.36.1.255.ge46751e96f-goog

