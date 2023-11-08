Return-Path: <kvm+bounces-1115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D8B7E4E25
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A17771C20CB6
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:33:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B78D0107A0;
	Wed,  8 Nov 2023 00:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iixq3tzO"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EB3EADD
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:32:14 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1001FF9
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:32:14 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5be6d0a23beso1242497b3.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403533; x=1700008333; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k2UNp8+7yoYn4+LUw6sJaKJMtfEPLdWk0fOhhGx9xpo=;
        b=Iixq3tzORT+IgX0wWdsTYe39XjCfjri+3hqq5sstdz+dasYFEvmohUH+rvLL9STACe
         ej1M4fazP5kxKwlBy4FixDsc5HqRyZjn+SRZOAfS/qprX3iQUboRsemrw+p4GxKSF/41
         i0fOy9vkChzbL5Ry7ZRnKVXC3hx7ZT4dTzKGtW+t/K3xoWn7sUtbHeG31XYVLsfRJVP0
         cx2j4nSNzRlGjddHnjHirc827YGrt25Q+OdbwCApnQJnkR1VCNIVNVtvCRPqJleJdkbh
         jHsFJeOwtkYouduLUK0l1YgtHaVyJlkLTcXv3WUpzZduq+N14LD3sjwg6Xs4k8BLOude
         EKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403533; x=1700008333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k2UNp8+7yoYn4+LUw6sJaKJMtfEPLdWk0fOhhGx9xpo=;
        b=cb2tUGKfxULiHWzGNbkvwc5tKKtTy4cIJNS9JwVCggBZFeSSD2YZxdKLsdytqW2kyv
         GDt6M2JZhIJfcX2JY3uXasRFWiZfYKpKcHTXdJ9Ymw0HbPjYgPFturqXmL2yLk6XlQud
         ul7kHsZOdggLfm0ST6hZUB48lNxzurjLFv+IGh3UqRUWyIq+Jdfy0Qd8f6aXpEtYeqJn
         DlxNRdSFOsz4Jad1iGstzOJePxQGEJOldO7Smey5F1XRNI+RFWFsk4g0Qu30v15jknfD
         ZOwfscDKm+nToBVpNJxAtIR/rrwNJbAd4NT2HzlhLyTCMjQzSyls7n2oWr9g5O7+2N2s
         T8cQ==
X-Gm-Message-State: AOJu0YytgIcZ1P970vobnFiSYTFlit9k2c+iGXYya3ntqDY5jh0XN0NX
	ikx3qULoX7B7bJ3D87Rrg5+encu3rtg=
X-Google-Smtp-Source: AGHT+IHzk92d9DpgEg5k7JHEYJEhj6vZYFUKoC0XOAyUOstvk1Ixla2Mi6+3LwavXr0bE+aGGJ4OR/LJfqU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:d844:0:b0:5b8:d09e:704d with SMTP id
 n4-20020a81d844000000b005b8d09e704dmr99902ywl.1.1699403533438; Tue, 07 Nov
 2023 16:32:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:33 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-18-seanjc@google.com>
Subject: [PATCH v7 17/19] KVM: selftests: Query module param to detect FEP in
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


