Return-Path: <kvm+bounces-56843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F652B44585
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 20:35:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FCB6A00EF4
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 18:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D393093DE;
	Thu,  4 Sep 2025 18:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ihky4hZ4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26159136988
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 18:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757010950; cv=none; b=Oux1hYIRDycPVCbHKE9kWPGPWYFDUrDZFpxUTw5QNmgvGG3eaeDiMLDK9GSdalqCQGGHtq9wN802Dm3iaqJFzJR/vXaAp7wyBO12bLgs6kBM6BYOXJZLxpnl8Z4lWYbyXK+DJKR0zP53xJoRBD/AqL6tmHqAVJcUs60dZ1NNN04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757010950; c=relaxed/simple;
	bh=trQVciou02BhqLI+wLFz+BJzOyksrkiGATsW4fd67aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSk9JQm+N3zMF6Yj4995Y/N8LKS3YKS6y8KL/sfK+HPS8q/U7aDnsziUW4pnj1MxZR8uSHfjqV7Iq1u61h9n7ogAHObfT4S5cvpAYrQm9ZnFrDNDVoq0y+URSbznSBsZWNa3WdYkpc6MmOCPD0Lgas0qHbVWQlyKIqhlc7N7zMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ihky4hZ4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E899C4CEF0;
	Thu,  4 Sep 2025 18:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757010949;
	bh=trQVciou02BhqLI+wLFz+BJzOyksrkiGATsW4fd67aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ihky4hZ4E+XQ42mrB/CS5I0heoGeCXyCbT/1Fueeqv/j00uMHlAZ/9YriK9b+F18G
	 QcBWb7kdSIGPnBiIRPwkNgl6z1J0Z9C4qngplVwtWNP1qJck4VqOmmm1hY4PDDjnjk
	 o0ZV9qQicydEkfClA+4v/2rkmAcXRP0oR5olhQff0CpD1iO14wUZw0sMylTb13KbTP
	 /imJaCNaKtyl3Tda3q+DAw7XbOTfsakr4Xq9unkueypO2pbhLi3MoWitwsD9nZ0f5b
	 MbGYVI0/GYMVCGWOANuFda38NArht7KZiTO51xD2cU+KpInf1rFxdSVapnZFrZNJTz
	 fn9sezQ/RZonA==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>,
	<kvm@vger.kernel.org>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [RESEND v4 2/7] KVM: SVM: Add a helper to look up the max physical ID for AVIC
Date: Fri,  5 Sep 2025 00:03:02 +0530
Message-ID: <0ab9bf5e20a3463a4aa3a5ea9bbbac66beedf1d1.1757009416.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1757009416.git.naveen@kernel.org>
References: <cover.1757009416.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To help with a future change, add a helper to look up the maximum
physical ID depending on the vCPU AVIC mode. No functional change
intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 arch/x86/kvm/svm/avic.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a6908ac5298d..4f00e31347c3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -79,13 +79,31 @@ static bool next_vm_id_wrapped = 0;
 static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
 bool x2avic_enabled;
 
+static u32 avic_get_max_physical_id(struct kvm_vcpu *vcpu)
+{
+	u32 arch_max;
+
+	if (x2avic_enabled && apic_x2apic_mode(vcpu->arch.apic))
+		arch_max = X2AVIC_MAX_PHYSICAL_ID;
+	else
+		arch_max = AVIC_MAX_PHYSICAL_ID;
+
+	/*
+	 * Despite its name, KVM_CAP_MAX_VCPU_ID represents the maximum APIC ID plus one,
+	 * so the max possible APIC ID is one less than that.
+	 */
+	return min(vcpu->kvm->arch.max_vcpu_ids - 1, arch_max);
+}
+
 static void avic_activate_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
-	struct kvm *kvm = svm->vcpu.kvm;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
+
 	vmcb->control.avic_physical_id &= ~AVIC_PHYSICAL_MAX_INDEX_MASK;
+	vmcb->control.avic_physical_id |= avic_get_max_physical_id(vcpu);
 
 	vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
 
@@ -98,8 +116,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 	 */
 	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
 		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
-		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
-						      X2AVIC_MAX_PHYSICAL_ID);
+
 		/* Disabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, false);
 	} else {
@@ -109,9 +126,6 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
 		 */
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
 
-		/* For xAVIC and hybrid-xAVIC modes */
-		vmcb->control.avic_physical_id |= min(kvm->arch.max_vcpu_ids - 1,
-						      AVIC_MAX_PHYSICAL_ID);
 		/* Enabling MSR intercept for x2APIC registers */
 		svm_set_x2apic_msr_interception(svm, true);
 	}
-- 
2.50.1


