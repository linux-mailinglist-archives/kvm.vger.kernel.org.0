Return-Path: <kvm+bounces-1512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2787E86C1
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39CEC1C20A23
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C6F3D982;
	Fri, 10 Nov 2023 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xioiww6C"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B17C3E48E
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:47 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FDE44B3
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:45 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5b31e000e97so35610877b3.1
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660545; x=1700265345; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Fb9o9vTAMmqpgdOCiBkm6k44a/yj7aZt1WRlJMtEY4o=;
        b=Xioiww6CRtU7NhVAue6jOlwQ2uX39yPyeR2avaQTenK6yZhBnDh3W7qoeVsjV1qtoX
         SkJi9sA0E9X8JjWh3KzSqfz7yCwagtmzZlDHiFzYfUwHogpG1f9o4OmwUct03HBLJaTP
         IZBU2UgqTFMfE6Z5WTDVGFWqwjoZFS45PYnBeif9fSmaDSqQYb6B+NdBoP54NYrONtfQ
         B1/6COJplyL+u2nd93tr/eGASRUcLQsPESH/YG3wS9zeGIrJ5GC8vggc+K+pSQwbXvrv
         UTln9UGpDeRW6Q1R4iXWSX43uOT01Hr9GYJ+8hf/3n9CqUynTMPN7zx9JBM/yULnjxx6
         UZUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660545; x=1700265345;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fb9o9vTAMmqpgdOCiBkm6k44a/yj7aZt1WRlJMtEY4o=;
        b=n4k5YOmz0dhDme/4vRc1kLzM72dhANQ30Uob6EbkJtUrIJbKiq7FLANWLkcxKSshh7
         p77ryDZlo8wj9uQhlicznBeYvGgCivKtPlxHVpT02ZUw7wO/DJ3TJbE/lW+TE2uimFMC
         zqK3kKe8X9wAJ0YTtqP2/JzKvN1DWsxOv4OYHRsYuiaklvt83KTN1e7zvsQrQp7H1bBx
         tQ0znQVKz6nhGH1VgNkYC06W2SbIVB/dvK+8RXMp/myAwV5325sdqvR8UnNCJ+GjlT8e
         eSvVLVuPEGJOOMI6k/Teno0dr4ZmX02XHPSyFkTwSwmE8VmXw3TBCvq/6pg/Mcvp7fuc
         8tfQ==
X-Gm-Message-State: AOJu0YyUNwHA3/sNSlfKyYqHt5hIdy52PGBnMRf+c3Tiiib92rJ8q2bZ
	tvYTD1j5tMbplKhFVy0jXbGOIZ6eL+8=
X-Google-Smtp-Source: AGHT+IFqBdtg0HXh/YArsdBLAwe9BL3Yvb3UvXpeYX1kEg2TJDL7UyOILsOkr21bny94fhrfzcPukMFYbpE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:318a:0:b0:d9a:36cd:482e with SMTP id
 x132-20020a25318a000000b00d9a36cd482emr14832ybx.13.1699660544920; Fri, 10 Nov
 2023 15:55:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:25 -0800
In-Reply-To: <20231110235528.1561679-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-7-seanjc@google.com>
Subject: [PATCH 6/9] KVM: x86: Update guest cpu_caps at runtime for dynamic
 CPUID-based features
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

When updating guest CPUID entries to emulate runtime behavior, e.g. when
the guest enables a CR4-based feature that is tied to a CPUID flag, also
update the vCPU's cpu_caps accordingly.  This will allow replacing all
usage of guest_cpuid_has() with guest_cpu_cap_has().

Take care not to update guest capabilities when KVM is updating CPUID
entries that *may* become the vCPU's CPUID, e.g. if userspace tries to set
bogus CPUID information.  No extra call to update cpu_caps is needed as
the cpu_caps are initialized from the incoming guest CPUID, i.e. will
automatically get the updated values.

Note, none of the features in question use guest_cpu_cap_has() at this
time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 48 +++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 36bd04030989..37a991439fe6 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -262,31 +262,48 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
+static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
+						       struct kvm_cpuid_entry2 *entry,
+						       unsigned int x86_feature,
+						       bool has_feature)
+{
+	if (entry)
+		cpuid_entry_change(entry, x86_feature, has_feature);
+
+	if (vcpu)
+		guest_cpu_cap_change(vcpu, x86_feature, has_feature);
+}
+
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
+	struct kvm_vcpu *caps = vcpu;
+
+	/*
+	 * Don't update vCPU capabilities if KVM is updating CPUID entries that
+	 * are coming in from userspace!
+	 */
+	if (entries != vcpu->arch.cpuid_entries)
+		caps = NULL;
 
 	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
-	if (best) {
-		/* Update OSXSAVE bit */
-		if (boot_cpu_has(X86_FEATURE_XSAVE))
-			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
+
+	if (boot_cpu_has(X86_FEATURE_XSAVE))
+		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSXSAVE,
 					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
 
-		cpuid_entry_change(best, X86_FEATURE_APIC,
-			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
+	kvm_update_feature_runtime(caps, best, X86_FEATURE_APIC,
+				   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 
-		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
-			cpuid_entry_change(best, X86_FEATURE_MWAIT,
-					   vcpu->arch.ia32_misc_enable_msr &
-					   MSR_IA32_MISC_ENABLE_MWAIT);
-	}
+	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
+		kvm_update_feature_runtime(caps, best, X86_FEATURE_MWAIT,
+					   vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_MWAIT);
 
 	best = cpuid_entry2_find(entries, nent, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU))
-		cpuid_entry_change(best, X86_FEATURE_OSPKE,
-				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
+	if (boot_cpu_has(X86_FEATURE_PKU))
+		kvm_update_feature_runtime(caps, best, X86_FEATURE_OSPKE,
+					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
 	best = cpuid_entry2_find(entries, nent, 0xD, 0);
 	if (best)
@@ -353,6 +370,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * Reset guest capabilities to userspace's guest CPUID definition, i.e.
 	 * honor userspace's definition for features that don't require KVM or
 	 * hardware management/support (or that KVM simply doesn't care about).
+	 *
+	 * Note, KVM has already done runtime updates on guest CPUID, i.e. this
+	 * will also correctly set runtime features in guest CPU capabilities.
 	 */
 	for (i = 0; i < NR_KVM_CPU_CAPS; i++) {
 		const struct cpuid_reg cpuid = reverse_cpuid[i];
-- 
2.42.0.869.gea05f2083d-goog


