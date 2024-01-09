Return-Path: <kvm+bounces-5926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CFFA829076
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 642851C21590
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E514176C;
	Tue,  9 Jan 2024 23:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D1XxwNMr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D23405FA
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cde2b113e7so1217596a12.2
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841386; x=1705446186; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n61oJSIkyIz46YdK+ygDOevYS8a/o0WDNeUtg2/VEIk=;
        b=D1XxwNMrn2504xGJrx4ZWHB65gBdTMRJ/nYBl3lbbZvpCT5rTx6HCuGTtsmJvqrlsd
         tdy9oA92ZT7besNiE/VGtXIled6rXy2lR4148fErKpOOsSf5s/J0WUDt27XngY1lADtW
         bA+hqawwclRoJBaHxrVu3LR+pQx6qZMW31g7yTVnVKIiWa/eH811JuCyUC6tEuI/3lNW
         68J+OJyPd/uMpcJDUA2HYkekJGjmXKbo3ckHMLnBx+NVZJxrCgMP41Xg1Raq6IhAG1m3
         fcWgvM32FhfxTjFwMF3/nRh3rvrvBYaIJACi7mMuPTxzhLfqwNG2xrDYtLeEBT5aN/Dj
         iK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841386; x=1705446186;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n61oJSIkyIz46YdK+ygDOevYS8a/o0WDNeUtg2/VEIk=;
        b=d89KIHJUiAbRCJ29ZSGFlrmoqViSP1Grnkr7PbkylcL6ajgk5JB5BsHu/gNUFx0Gvd
         42NS2D6sRtss8gqt7a6TYjezQ76w3kkxEVNRFaDQSsye0T2ZDXosi0+ba6+VOlMx6siA
         3/cAERo2o6glxwkOQmV4yJkbLD2XaYoY274KWARwrDD3ZdO/OKY0U7jJWLkraL0BBQSS
         jpqNnnuh9RXNjUwg8UzHue9MHfZxbBoApcOcc5YnpqLv3TMuPVUkKrhAC8QhHqGF+Ww0
         FDD55bUA6ZbnX57phffdHD2cz5KFSRNUy+bapjKIjohgVKLNY9GExSjPfukOYBTb/2nV
         PZUQ==
X-Gm-Message-State: AOJu0Yyit+V0y1ZrUNOTLncKbndtkK836B7VM0BRoCpRMzeNav2818uf
	L9lRnrRRy9vAZOykJkDlXlKHjZIRW4NHdQl4hQ==
X-Google-Smtp-Source: AGHT+IEMfFCdQZL6KpWDo3RxgNuDwCk6F9/iQeHqpmueCUojVQrOFZLdCkB8PlZOme96V1QnmYO7hmyp190=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:4aa:b0:5cd:fa13:7a4 with SMTP id
 bw42-20020a056a0204aa00b005cdfa1307a4mr212pgb.1.1704841386589; Tue, 09 Jan
 2024 15:03:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:27 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-8-seanjc@google.com>
Subject: [PATCH v10 07/29] KVM: x86/pmu: Prioritize VMX interception over #GP
 on RDPMC due to bad index
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Apply the pre-intercepts RDPMC validity check only to AMD, and rename all
relevant functions to make it as clear as possible that the check is not a
standard PMC index check.  On Intel, the basic rule is that only invalid
opcodes and privilege/permission/mode checks have priority over VM-Exit,
i.e. RDPMC with an invalid index should VM-Exit, not #GP.  While the SDM
doesn't explicitly call out RDPMC, it _does_ explicitly use RDMSR of a
non-existent MSR as an example where VM-Exit has priority over #GP, and
RDPMC is effectively just a variation of RDMSR.

Manually testing on various Intel CPUs confirms this behavior, and the
inverted priority was introduced for SVM compatibility, i.e. was not an
intentional change for Intel PMUs.  On AMD, *all* exceptions on RDPMC have
priority over VM-Exit.

Check for a NULL kvm_pmu_ops.check_rdpmc_early instead of using a RET0
static call so as to provide a convenient location to document the
difference between Intel and AMD, and to again try to make it as obvious
as possible that the early check is a one-off thing, not a generic "is
this PMC valid?" helper.

Fixes: 8061252ee0d2 ("KVM: SVM: Add intercept checks for remaining twobyte instructions")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  2 +-
 arch/x86/kvm/emulate.c                 |  2 +-
 arch/x86/kvm/kvm_emulate.h             |  2 +-
 arch/x86/kvm/pmu.c                     | 16 +++++++++++++---
 arch/x86/kvm/pmu.h                     |  4 ++--
 arch/x86/kvm/svm/pmu.c                 |  9 ++++++---
 arch/x86/kvm/vmx/pmu_intel.c           | 12 ------------
 arch/x86/kvm/x86.c                     |  9 +++------
 8 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index d7eebee4450c..f0cd48222133 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -15,7 +15,7 @@ BUILD_BUG_ON(1)
 KVM_X86_PMU_OP(pmc_idx_to_pmc)
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
 KVM_X86_PMU_OP(msr_idx_to_pmc)
-KVM_X86_PMU_OP(is_valid_rdpmc_ecx)
+KVM_X86_PMU_OP_OPTIONAL(check_rdpmc_early)
 KVM_X86_PMU_OP(is_valid_msr)
 KVM_X86_PMU_OP(get_msr)
 KVM_X86_PMU_OP(set_msr)
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e223043ef5b2..695ab5b6055c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3962,7 +3962,7 @@ static int check_rdpmc(struct x86_emulate_ctxt *ctxt)
 	 * protected mode.
 	 */
 	if ((!(cr4 & X86_CR4_PCE) && ctxt->ops->cpl(ctxt)) ||
-	    ctxt->ops->check_pmc(ctxt, rcx))
+	    ctxt->ops->check_rdpmc_early(ctxt, rcx))
 		return emulate_gp(ctxt, 0);
 
 	return X86EMUL_CONTINUE;
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index e6d149825169..4351149484fb 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -208,7 +208,7 @@ struct x86_emulate_ops {
 	int (*set_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 data);
 	int (*get_msr_with_filter)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
 	int (*get_msr)(struct x86_emulate_ctxt *ctxt, u32 msr_index, u64 *pdata);
-	int (*check_pmc)(struct x86_emulate_ctxt *ctxt, u32 pmc);
+	int (*check_rdpmc_early)(struct x86_emulate_ctxt *ctxt, u32 pmc);
 	int (*read_pmc)(struct x86_emulate_ctxt *ctxt, u32 pmc, u64 *pdata);
 	void (*halt)(struct x86_emulate_ctxt *ctxt);
 	void (*wbinvd)(struct x86_emulate_ctxt *ctxt);
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 30945fea6988..0b0d804ee239 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -524,10 +524,20 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 		kvm_pmu_cleanup(vcpu);
 }
 
-/* check if idx is a valid index to access PMU */
-bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
+int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
 {
-	return static_call(kvm_x86_pmu_is_valid_rdpmc_ecx)(vcpu, idx);
+	/*
+	 * On Intel, VMX interception has priority over RDPMC exceptions that
+	 * aren't already handled by the emulator, i.e. there are no additional
+	 * check needed for Intel PMUs.
+	 *
+	 * On AMD, _all_ exceptions on RDPMC have priority over SVM intercepts,
+	 * i.e. an invalid PMC results in a #GP, not #VMEXIT.
+	 */
+	if (!kvm_pmu_ops.check_rdpmc_early)
+		return 0;
+
+	return static_call(kvm_x86_pmu_check_rdpmc_early)(vcpu, idx);
 }
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx)
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 87ecf22f5b25..51bbb01b21c8 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -23,7 +23,7 @@ struct kvm_pmu_ops {
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
 	struct kvm_pmc *(*msr_idx_to_pmc)(struct kvm_vcpu *vcpu, u32 msr);
-	bool (*is_valid_rdpmc_ecx)(struct kvm_vcpu *vcpu, unsigned int idx);
+	int (*check_rdpmc_early)(struct kvm_vcpu *vcpu, unsigned int idx);
 	bool (*is_valid_msr)(struct kvm_vcpu *vcpu, u32 msr);
 	int (*get_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 	int (*set_msr)(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
@@ -215,7 +215,7 @@ static inline bool pmc_is_globally_enabled(struct kvm_pmc *pmc)
 void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu);
 int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
-bool kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx);
+int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx);
 bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr);
 int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
 int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 1fafc46f61c9..e886300f0f97 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -73,11 +73,14 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return amd_pmc_idx_to_pmc(pmu, idx);
 }
 
-static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
+static int amd_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	return idx < pmu->nr_arch_gp_counters;
+	if (idx >= pmu->nr_arch_gp_counters)
+		return -EINVAL;
+
+	return 0;
 }
 
 /* idx is the ECX register of RDPMC instruction */
@@ -229,7 +232,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
-	.is_valid_rdpmc_ecx = amd_is_valid_rdpmc_ecx,
+	.check_rdpmc_early = amd_check_rdpmc_early,
 	.is_valid_msr = amd_is_valid_msr,
 	.get_msr = amd_pmu_get_msr,
 	.set_msr = amd_pmu_set_msr,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ec4feaef3d55..1b1f888ad32b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -55,17 +55,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
-{
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	bool fixed = idx & (1u << 30);
-
-	idx &= ~(3u << 30);
-
-	return fixed ? idx < pmu->nr_arch_fixed_counters
-		     : idx < pmu->nr_arch_gp_counters;
-}
-
 static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 					    unsigned int idx, u64 *mask)
 {
@@ -718,7 +707,6 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-	.is_valid_rdpmc_ecx = intel_is_valid_rdpmc_ecx,
 	.is_valid_msr = intel_is_valid_msr,
 	.get_msr = intel_pmu_get_msr,
 	.set_msr = intel_pmu_set_msr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..4d1191a944f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8389,12 +8389,9 @@ static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
 }
 
-static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
-			      u32 pmc)
+static int emulator_check_rdpmc_early(struct x86_emulate_ctxt *ctxt, u32 pmc)
 {
-	if (kvm_pmu_is_valid_rdpmc_ecx(emul_to_vcpu(ctxt), pmc))
-		return 0;
-	return -EINVAL;
+	return kvm_pmu_check_rdpmc_early(emul_to_vcpu(ctxt), pmc);
 }
 
 static int emulator_read_pmc(struct x86_emulate_ctxt *ctxt,
@@ -8526,7 +8523,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.set_msr_with_filter = emulator_set_msr_with_filter,
 	.get_msr_with_filter = emulator_get_msr_with_filter,
 	.get_msr             = emulator_get_msr,
-	.check_pmc	     = emulator_check_pmc,
+	.check_rdpmc_early   = emulator_check_rdpmc_early,
 	.read_pmc            = emulator_read_pmc,
 	.halt                = emulator_halt,
 	.wbinvd              = emulator_wbinvd,
-- 
2.43.0.472.g3155946c3a-goog


