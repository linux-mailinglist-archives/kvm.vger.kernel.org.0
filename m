Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC7257E9FE
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiGVWo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237157AbiGVWoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:44:24 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA11E109C
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x8-20020a5b0948000000b006707a126318so4642251ybq.1
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 15:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jRW5b1AwRLqsPtLiYdI940KWFJTYfsllVCwerR050ZU=;
        b=D8eIyfatj63AATbuT4yK79CYNRpWCdlOFFTNSBorLgJO+q/hJ5nV89U5TjLw6DZBZZ
         qw+N5RXkL/TGUd+1cYEDYJfZfJ1AWJFeMKxTIb00mThzxHet/1RgARY04VEHNqLmYSWX
         P2cNe2aAyLEUZOJc22aeJZUYhpxV9x3pSTGMi8iNhERx3oxKjnlAUOPUrqZULVLK0Qh+
         +o6epHrYJGiXBedHgTkMzJFOMzbuJiZu8ZlNg5A2jiSGrnjBYfwIkkt+XNpy8B7oURAr
         baXlL9zKk5DNkNQD2mrVduTSgty+4A5cI/vBON56KOqXnzWIT+3V9LvtTzAK2OoWC968
         3Lqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jRW5b1AwRLqsPtLiYdI940KWFJTYfsllVCwerR050ZU=;
        b=MKwUe8qPgnE76higq+JZdd72ewZGycOnf5FTTqOgST87kFjAt3njFz7wHPKpvfSTZB
         L9KolLMLOJ94aZmTpE8sjdv3PRldHOJ1lV8mB1ZYVQ9UOkFgZ/rSLwujuwkBH9Lka86I
         JYdJfRRphFbAmnzH+vDqNyxN2I6xR3RbBk1tqQToEH+evcMY5YQHuzzMyaHJGB0H3GSD
         blw945KnMs+z1a1Gc6QZlvMKNlTi095HZIK1808NR5PvKhqxxawWbkYDc9IJoScCeyUF
         Y5DHb8X6Idl7ZiwK6eo6y0HFodrheyQVrHOt5pXGmkEKHzOsZNtrVFiNhtQQTlLSMHmq
         /6bg==
X-Gm-Message-State: AJIora8DnvH+urNUWsZrtXmBBAqDqtxskhICz//vjFxrtL3Uc8lk6GbF
        gSqxxND5yBZ8cbwsMWKdbZ+gp4pI6m0=
X-Google-Smtp-Source: AGRyM1sgw9WQOgJabF3Ug/th0ONJN646sekDkdkEtGqcxujSgR7CN8sF2pu2CMtToTgmyEy4btnnimQLJU0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:fcc5:0:b0:31e:7544:9806 with SMTP id
 m188-20020a0dfcc5000000b0031e75449806mr1806701ywf.193.1658529860663; Fri, 22
 Jul 2022 15:44:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jul 2022 22:44:09 +0000
In-Reply-To: <20220722224409.1336532-1-seanjc@google.com>
Message-Id: <20220722224409.1336532-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220722224409.1336532-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 5/5] Revert "KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
 VM-{Entry,Exit} control"
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

From: Paolo Bonzini <pbonzini@redhat.com>

This reverts commit 03a8871add95213827e2bea84c12133ae5df952e.

Since commit 03a8871add95 ("KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
VM-{Entry,Exit} control"), KVM has taken ownership of the "load
IA32_PERF_GLOBAL_CTRL" VMX entry/exit control bits, trying to set these
bits in the IA32_VMX_TRUE_{ENTRY,EXIT}_CTLS MSRs if the guest's CPUID
supports the architectural PMU (CPUID[EAX=0Ah].EAX[7:0]=1), and clear
otherwise.

This was a misguided attempt at mimicking what commit 5f76f6f5ff96
("KVM: nVMX: Do not expose MPX VMX controls when guest MPX disabled",
2018-10-01) did for MPX.  However, that commit was a workaround for
another KVM bug and not something that should be imitated.  Mucking with
the VMX MSRs creates a subtle, difficult to maintain ABI as KVM must
ensure that any internal changes, e.g. to how KVM handles _any_ guest
CPUID changes, yield the same functional result.  Therefore, KVM's policy
is to let userspace have full control of the guest vCPU model so long
as the host kernel is not at risk.

Now that KVM really truly ensures kvm_set_msr() will succeed by loading
PERF_GLOBAL_CTRL if and only if it exists, revert KVM's misguided and
roundabout behavior.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: make it a pure revert]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 22 ----------------------
 arch/x86/kvm/vmx/nested.h    |  2 --
 arch/x86/kvm/vmx/pmu_intel.c |  3 ---
 3 files changed, 27 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 52fb45e23910..ed247a121325 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4824,28 +4824,6 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
-void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
-			    bool vcpu_has_perf_global_ctrl)
-{
-	struct vcpu_vmx *vmx;
-
-	if (!nested_vmx_allowed(vcpu))
-		return;
-
-	vmx = to_vmx(vcpu);
-	if (vcpu_has_perf_global_ctrl) {
-		vmx->nested.msrs.entry_ctls_high |=
-				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		vmx->nested.msrs.exit_ctls_high |=
-				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-	} else {
-		vmx->nested.msrs.entry_ctls_high &=
-				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		vmx->nested.msrs.exit_ctls_high &=
-				~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-	}
-}
-
 static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer,
 				int *ret)
 {
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 129ae4e01f7c..88b00a7359e4 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -32,8 +32,6 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
-void nested_vmx_pmu_refresh(struct kvm_vcpu *vcpu,
-			    bool vcpu_has_perf_global_ctrl);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 78f2800fd850..862c1a4d971b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -592,9 +592,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	bitmap_set(pmu->all_valid_pmc_idx,
 		INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);
 
-	nested_vmx_pmu_refresh(vcpu,
-			       intel_is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL));
-
 	if (cpuid_model_is_consistent(vcpu))
 		x86_perf_get_lbr(&lbr_desc->records);
 	else
-- 
2.37.1.359.gd136c6c3e2-goog

