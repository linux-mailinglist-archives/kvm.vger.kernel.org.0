Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1747A57E9F6
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiGVWoS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236928AbiGVWoP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:44:15 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6BDFC5
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o6-20020a17090aac0600b001f23d8bfe2bso2181055pjq.7
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WN/xY6gOj1e2WnlDEa/rBl2RMeNZSHfOPPkC15IuT+I=;
        b=dFdqM1GImgHSmfrpMtWX2mFjGG/F4k4bC4JDEKFNocnSz4yh7wq90o7YCEvOBKVl0B
         LaVkYJCQtVQTaAb+JOmTBlrOkKUoZM0brfVL9P93bw6wiIpzBIAcw69Y8JBPW3+vro2A
         gvRPVFz7etzVTFpeiAsagZz0Ia2ssLUTxxpEr1mho987VPLniFmBjsi16ur28R8gYxjh
         G9FLE93SXKfFsbiQvB5eVEKM10Mikz7owdgIhJGp8aP0+wqTcjbnFqLECiMPmcaLZyF0
         S8wObyB7+xzi7lf4ZxGD9idq8djA58qN1NNMhIiJeaepPmoHTtlDulurF8uw8LTxNO8N
         TZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WN/xY6gOj1e2WnlDEa/rBl2RMeNZSHfOPPkC15IuT+I=;
        b=PCM3Lmw0WmDsQFwHGH0I3iz/exGDGTBgSXR6OsWIGBmJLOcFyKEgjH0iLWcAhciieL
         UA36QDu9LsdjD4x+5T0zBfiUeHw5OzwSpB6KQwSeDhupl0F8kpou3kgd5/8MQ3BLEQ+7
         8EKvN4ew9zTnL8EfML4QdAtnnvSSlMRxYtslAWmrI6KAGtuvP2PSZgkSkPJYCRJZkrd8
         34MUfH7poebowI4Mh8RgrPJwdFqLVYJ+La50m8+NU1V37XSOUCBwqkA+3co3mf4GRdII
         zvLlDgNED9mbQaEm7KxtwrtnZEqVlsd64+FS/sq1wmta1JYlorW1CMWfKkY1nYx2eoM7
         vy8A==
X-Gm-Message-State: AJIora9eqjWg3mx0lcJmrevgkW91rQOxdBjlBVa26bC5AfqAinxsXHiG
        0Pok1QOCxACaVDVY3v3VCrNJo9SRQu0=
X-Google-Smtp-Source: AGRyM1tVHf2nBEKhoB+GuOB6GF7HefI8tK4cljRmv+pNdm37LTjAtoSL298ZmzoSg/lMvhUp8MSNeGdFClA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:158e:b0:52a:e628:8b3b with SMTP id
 u14-20020a056a00158e00b0052ae6288b3bmr2164120pfk.80.1658529854264; Fri, 22
 Jul 2022 15:44:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jul 2022 22:44:05 +0000
In-Reply-To: <20220722224409.1336532-1-seanjc@google.com>
Message-Id: <20220722224409.1336532-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220722224409.1336532-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 1/5] Revert "Revert "KVM: nVMX: Expose load
 IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control""
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

This reverts commit 00590a3844086384b584eb9e7c8155baa6e33e49.

Intended to be fixup, not a standalone revert.
---
 arch/x86/kvm/vmx/nested.c    | 26 +++++++++++++++++++++++---
 arch/x86/kvm/vmx/nested.h    |  2 ++
 arch/x86/kvm/vmx/pmu_intel.c |  3 +++
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b9425b142028..451cbb9c56c3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2623,7 +2623,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	}
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
-	    vmcs12->guest_ia32_perf_global_ctrl != vcpu_to_pmu(vcpu)->global_ctrl &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
@@ -4334,8 +4333,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->host_ia32_pat);
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
-	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-	    && vmcs12->host_ia32_perf_global_ctrl != vcpu_to_pmu(vcpu)->global_ctrl)
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
 		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 					 vmcs12->host_ia32_perf_global_ctrl));
 
@@ -4824,6 +4822,28 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
+void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
+			    bool vcpu_has_perf_global_ctrl)
+{
+	struct vcpu_vmx *vmx;
+
+	if (!nested_vmx_allowed(vcpu))
+		return;
+
+	vmx = to_vmx(vcpu);
+	if (vcpu_has_perf_global_ctrl) {
+		vmx->nested.msrs.entry_ctls_high |=
+				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high |=
+				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &=
+				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high &=
+				~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	}
+}
+
 static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 				int *ret)
 {
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 88b00a7359e4..129ae4e01f7c 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -32,6 +32,8 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
+void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
+			    bool vcpu_has_perf_global_ctrl);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index cfcb590afaa7..4bc098fbec31 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -590,6 +590,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
+	nested_vmx_pmu_refresh(vcpu,
+			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
+
 	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
-- 
2.37.1.359.gd136c6c3e2-goog

