Return-Path: <kvm+bounces-60618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F86EBF5137
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12C8718C6AFF
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF98C2D6629;
	Tue, 21 Oct 2025 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qvhxdN8K"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50406288C34
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032925; cv=none; b=iHwsRt5dTk5CqucPyQq03/Z2tdb8MoK7NWco9ClowQ/ffn8NU4AHiLbnCFs1ksT5qBBAOh/Xb8thuY/qAqr+FuhLhZPc6tagOBoViz0SqEo1dh6Mb1Z0E6OlSA4Biqt98WV55fMWPzNedcQsXdZIoZBZR/T06ojuT0Eu1UBDvBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032925; c=relaxed/simple;
	bh=RzN8S5829P4atioL4zZZl4z+Fpkeovc6CUP/mqAjMNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeS8QscI7lGGFJcg98o4EVJ160oQRmRWX/vqe8ROfPWqyxmhrs+eYfLx1ygfVs7ZcanjPTi4q4TmKpmpacePmr6i9K78DnPMOdyBaxS9LKNezrCw4hDIRgQCMAkpCY1DibG7tqA6s5tt1APnd0xwPdyv/CpFpQ2Tpl/Z3t4vQhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qvhxdN8K; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9i8MKAwzoYVSdvC0SDkeEAnIDmKdE3d63+KzCJlfJBQ=;
	b=qvhxdN8KVRuqfgSxttd4dVJpzWPgIDLIWy1tDrkR1qJHCkal7CCwwghJIfEeaFe2ZjI3xO
	Txb11k8dsqUafPu2bC8WmSnxaoFiwMb7NwOHbgB+bTbouj9ZCHjeUOjDe3iN1AOMCPuVWo
	sl7LYzx7b2dGVqO3IEosOe/OoBdrrSc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 09/23] KVM: selftests: Remove the unused argument to prepare_eptp()
Date: Tue, 21 Oct 2025 07:47:22 +0000
Message-ID: <20251021074736.1324328-10-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

eptp_memslot is unused, remove it. No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/x86/vmx.h        | 3 +--
 tools/testing/selftests/kvm/lib/x86/memstress.c      | 2 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c            | 3 +--
 tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c | 2 +-
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index edb3c391b9824..96e2b4c630a9b 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -568,8 +568,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
-void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint32_t eptp_memslot);
+void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
 
 #endif /* SELFTEST_KVM_VMX_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 7f5d62a65c68a..0b1f288ad5564 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -63,7 +63,7 @@ void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
 	uint64_t start, end;
 
-	prepare_eptp(vmx, vm, 0);
+	prepare_eptp(vmx, vm);
 
 	/*
 	 * Identity map the first 4G and the test region with 1G pages so that
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 1b6d4a0077980..f0023a3b0137e 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -535,8 +535,7 @@ bool kvm_cpu_has_ept(void)
 	return ctrl & SECONDARY_EXEC_ENABLE_EPT;
 }
 
-void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint32_t eptp_memslot)
+void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
 	TEST_ASSERT(kvm_cpu_has_ept(), "KVM doesn't support nested EPT");
 
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 34a57fe747f64..98cb6bdab3e6d 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -120,7 +120,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 * GPAs as the EPT enabled case.
 	 */
 	if (enable_ept) {
-		prepare_eptp(vmx, vm, 0);
+		prepare_eptp(vmx, vm);
 		nested_map_memslot(vmx, vm, 0);
 		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
 		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
-- 
2.51.0.869.ge66316f041-goog


