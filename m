Return-Path: <kvm+bounces-1430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C6867E7741
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:15:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 885AF1F20B53
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71EA610974;
	Fri, 10 Nov 2023 02:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5KysjAC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828DF10796
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:54 +0000 (UTC)
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C339A478B
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:53 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-692bf04c548so1514359b3a.0
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582433; x=1700187233; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k2UNp8+7yoYn4+LUw6sJaKJMtfEPLdWk0fOhhGx9xpo=;
        b=I5KysjAC/xRQsZQ3em14VPrHjae9se4pD5OyUnt82hW+VurHdCrjq+aY4Kd0RJMtiL
         T26SR8oCoCgH/+KVyh0We5oJBDDv96On55b/Y/t3O3rsdUcPruxLWF9THHDDfdqdTxPg
         JrhHJQRd3ecAQQRP0JpMx8l17JvdRUyw37rG7UiyOM4dklnnA9Fgb8Rr1NdViuwI1MHj
         8rsF8a/bmci7d4+3Nv6dHxNLgTfgp8oAjETqj0tX/SAp487jnknKQuXT3ZdULEjzKd6p
         yrqv4uIb5pp/P78GnZ3gL9oOuQ21gd0SF94J9PqZ5VSLdsFNWuoWePjtgMjvl2q+EHXu
         TZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582433; x=1700187233;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k2UNp8+7yoYn4+LUw6sJaKJMtfEPLdWk0fOhhGx9xpo=;
        b=tAG14Qc7FSIY1ZNu4fdFQppgxbj0+WXCjYCQ2DSKd5PAcvP/ldomFxifVWo1DVYwP6
         Kk3dqoy0Klxdh9HFegqjnPbx5hlDXSD8FDb5kzGuS3r6aEMxBCVUm1eiFvHU9JccWd99
         lSrz5EqNjpgY+aKXr+yPIeV0wB2ibuFLZXsq/lKSsSbSIYvDVh4GZOpd7dE/LgCuCzQw
         2orzjmagxkviZrlULFb+tIp7Nrpx2QKmgUQiDfMF3GBFsr48efY6pI/Vhap+y00IxTBk
         7ovn1KEuv6599Q7GZ16Yluj/UyZihPajWPaGyGB0dtAMoAwHKpQKH/EKkIG2z6JaUPaX
         ff3w==
X-Gm-Message-State: AOJu0Yy4Zqp8A/IqxPoUdiWVfJo6omu0/WVs4jZDw6cg9Kc7X+ITixgZ
	+SktbrK4hMENmSmFxynuiMdA8lJALew=
X-Google-Smtp-Source: AGHT+IHjUSczE6Y0tBqL7hIEMLPuQTi+uWMgb8voA7U2V69G0HEeyFdqIyz5Uu21RIgb7yk1CFBGckCUYwA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:7cc:b0:6bc:8df2:a536 with SMTP id
 n12-20020a056a0007cc00b006bc8df2a536mr875864pfu.1.1699582433302; Thu, 09 Nov
 2023 18:13:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:13:01 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-22-seanjc@google.com>
Subject: [PATCH v8 21/26] KVM: selftests: Query module param to detect FEP in
 MSR filtering test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to detect KVM support for forced emulation by querying the
module param, and use the helper to detect support for the MSR filtering
test instead of throwing a noodle/NOP at KVM to see if it sticks.

Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  5 ++++
 .../kvm/x86_64/userspace_msr_exit_test.c      | 27 +++++++------------
 2 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index c261e0941dfe..8a404faafb21 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1221,6 +1221,11 @@ static inline bool kvm_is_pmu_enabled(void)
 	return get_kvm_param_bool("enable_pmu");
 }
 
+static inline bool kvm_is_forced_emulation_enabled(void)
+{
+	return !!get_kvm_param_integer("force_emulation_prefix");
+}
+
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
diff --git a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
index 3533dc2fbfee..9e12dbc47a72 100644
--- a/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
+++ b/tools/testing/selftests/kvm/x86_64/userspace_msr_exit_test.c
@@ -14,8 +14,7 @@
 
 /* Forced emulation prefix, used to invoke the emulator unconditionally. */
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
-#define KVM_FEP_LENGTH 5
-static int fep_available = 1;
+static bool fep_available;
 
 #define MSR_NON_EXISTENT 0x474f4f00
 
@@ -260,13 +259,6 @@ static void guest_code_filter_allow(void)
 	GUEST_ASSERT(data == 2);
 	GUEST_ASSERT(guest_exception_count == 0);
 
-	/*
-	 * Test to see if the instruction emulator is available (ie: the module
-	 * parameter 'kvm.force_emulation_prefix=1' is set).  This instruction
-	 * will #UD if it isn't available.
-	 */
-	__asm__ __volatile__(KVM_FEP "nop");
-
 	if (fep_available) {
 		/* Let userspace know we aren't done. */
 		GUEST_SYNC(0);
@@ -388,12 +380,6 @@ static void guest_fep_gp_handler(struct ex_regs *regs)
 			   &em_wrmsr_start, &em_wrmsr_end);
 }
 
-static void guest_ud_handler(struct ex_regs *regs)
-{
-	fep_available = 0;
-	regs->rip += KVM_FEP_LENGTH;
-}
-
 static void check_for_guest_assert(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
@@ -531,9 +517,11 @@ static void test_msr_filter_allow(void)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
+	uint64_t cmd;
 	int rc;
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code_filter_allow);
+	sync_global_to_guest(vm, fep_available);
 
 	rc = kvm_check_cap(KVM_CAP_X86_USER_SPACE_MSR);
 	TEST_ASSERT(rc, "KVM_CAP_X86_USER_SPACE_MSR is available");
@@ -561,11 +549,11 @@ static void test_msr_filter_allow(void)
 	run_guest_then_process_wrmsr(vcpu, MSR_NON_EXISTENT);
 	run_guest_then_process_rdmsr(vcpu, MSR_NON_EXISTENT);
 
-	vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 	vcpu_run(vcpu);
-	vm_install_exception_handler(vm, UD_VECTOR, NULL);
+	cmd = process_ucall(vcpu);
 
-	if (process_ucall(vcpu) != UCALL_DONE) {
+	if (fep_available) {
+		TEST_ASSERT_EQ(cmd, UCALL_SYNC);
 		vm_install_exception_handler(vm, GP_VECTOR, guest_fep_gp_handler);
 
 		/* Process emulated rdmsr and wrmsr instructions. */
@@ -583,6 +571,7 @@ static void test_msr_filter_allow(void)
 		/* Confirm the guest completed without issues. */
 		run_guest_then_process_ucall_done(vcpu);
 	} else {
+		TEST_ASSERT_EQ(cmd, UCALL_DONE);
 		printf("To run the instruction emulated tests set the module parameter 'kvm.force_emulation_prefix=1'\n");
 	}
 
@@ -804,6 +793,8 @@ static void test_user_exit_msr_flags(void)
 
 int main(int argc, char *argv[])
 {
+	fep_available = kvm_is_forced_emulation_enabled();
+
 	test_msr_filter_allow();
 
 	test_msr_filter_deny();
-- 
2.42.0.869.gea05f2083d-goog


