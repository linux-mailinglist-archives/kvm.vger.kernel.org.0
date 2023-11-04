Return-Path: <kvm+bounces-565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC8C7E0C85
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1468B216F5
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F2ADDCF;
	Sat,  4 Nov 2023 00:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="by8pITx+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC10C155
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:03:23 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E569171E
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:03:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a828bdcfbaso36865867b3.2
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056195; x=1699660995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HFthXLKtlL9b7mBubOTPYiyOU6v8Gj2JZ4woVFum6XM=;
        b=by8pITx+EMCBczP6kzbbixDrUhSQj30BM182/RyuTP30JojaQnB5of+wXTDoq2mM2d
         Hjl5axfvpPvFnbmimGYj+arya80VxKz0I4TznJV+EgKB6pT8me0eKDCwKedOtUefRgel
         3hZWvPtoCkYCP+EAWFq7Cq7iuflkh3qTMHjm2vRomMXHJdbU0zgRurelQhRFnVwly7Os
         he+xobM8XxYyiDiRFwB5v/acWTPaH6iERdmX2aG5KJAmYFaCVN0xbCD92s8JQ5Z4F4P1
         R2Tq3JrsouHuLWLn58miaWIeg5YyAbLc8F8kZRWx2L2QtW3ZL+rOAH1iGAqkIcUgw/2j
         wKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056195; x=1699660995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HFthXLKtlL9b7mBubOTPYiyOU6v8Gj2JZ4woVFum6XM=;
        b=UDZVx3u8KoLPhWCqCDil7fKSuflVHjZLkvGUwLfnQbTrnRC4QHWgGfynrZ1vPiZhdz
         J9hCoQPcu8WIxvltL+vQ+gvRMsLvstYRu/zr/DSfOEKWMYIDtNUJl0Tk4tk0Pk7Wj4mu
         dbAJlHfOD26zRHzTapTnp7aaczdFx6aWpfrXqEb/5ri7bmggWKp4fm2hafvyJf5TcJaY
         BBVhoBk52JN7EZfKoIOZ+/Z3ynOlUtZUFpfELDfuYoLjLu78uteAB0koeqqjPWgj1Xpn
         PYK7oCL4Cvi76ghASZy0X8vtzoF2yNz/3YCmW0iybV5S6BlXp2rXes6c1EDB3ihDliXu
         DD3A==
X-Gm-Message-State: AOJu0Yz6kGroKm8ToP8XRKHO870Lupwu+GptqmkqQH4oMxqgPk7tSEUq
	7ZqQH/WD8qBh9/2uZmWogtEkJ7u/xbE=
X-Google-Smtp-Source: AGHT+IHTTpBzyXyQN0ZtT21SwVbMTq9SAPPy3wxRjl8ibsJWY8ES+9li6afGjxo0DEhZCc/VHfa+niIWSbM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:549:b0:da3:b96c:6c48 with SMTP id
 z9-20020a056902054900b00da3b96c6c48mr187684ybs.9.1699056195235; Fri, 03 Nov
 2023 17:03:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:36 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-19-seanjc@google.com>
Subject: [PATCH v6 18/20] KVM: selftests: Query module param to detect FEP in
 MSR filtering test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
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
index 1885e758eb4d..47612742968d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1219,6 +1219,11 @@ static inline bool kvm_is_pmu_enabled(void)
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


