Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5E485EAB81
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 17:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbiIZPpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 11:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236731AbiIZPpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 11:45:05 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D39B72B60;
        Mon, 26 Sep 2022 07:30:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t3so6423351ply.2;
        Mon, 26 Sep 2022 07:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=QQlJngE5VezXo/8MQot4/0g/a+VfDBHY7JrP45q6Buc=;
        b=lrDGfYgxKe3J9dnQ5GuXfb/3aVuay1bD48i1l7U0YSnm5d9KEjM/V4JFq9MZADKnc6
         KZh9SDR/ncKrOBXBejh6hNoq0iK9dFSeQdtVXFlxgI9iPKFjML2Ljnv1E4IajTlDMXuE
         A/VDymSFhaSi5NM/Q1PlgV3CY5UlRgU/msYeoMXCynoBVP8TY3l/dEM7CQKJnXdSPnFZ
         bGHqDv2regmnlEVH+DdMc3b6Rs+J5RUPAznHhmD9Huf0XH1o4PncuynGubzyJNXoW5Wk
         +764umVMwrc3vVExsJ+YjUjHBQpWnOMYHDFLj2Z+XOsYuEFanhkeA0W1qWQNkudR6SnJ
         qTOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=QQlJngE5VezXo/8MQot4/0g/a+VfDBHY7JrP45q6Buc=;
        b=u2lat36jo/FUXdK/c5aIgo95/dibcyOgmX1o/PMfOycRb50ebceWxD19uVP3w5n4P/
         pkfjc4F4rj/btEIV5IPsqjs1XBOToqZR+uFW711B5bLRIT8Q74h9idWBDWzuqktN6HCa
         jdphrMYFMvM1wHg8V9CKd66lx5o8pb35Fbg4CeQqWPrURc8haF2wwDu1Qz2Y5mfZktg9
         TphTP0Zdtdin5R48PpWBqPxN2ptTMfhq2z2kZSx+69Y50NZogeAmUkZLdPRSnNfd/swl
         eOQGC9tOYLPxDzDJgjooR9MunnbAEPYxlg3C9XNIjUvcBFrnlY9Rw8R4xwEtVArO0Ddh
         qRhA==
X-Gm-Message-State: ACrzQf0Pio2lmGCahMQkxiCxzako1C0DglTGUpB+K+Ziaa/ruj13/o/o
        bJZBPjEhCgLRLEkn9utY4ac=
X-Google-Smtp-Source: AMsMyM7O/84KrceO47ymPO2gk8APTzCbqcUTGi496XiNuVA2njiKzmRkdv8Jn8lH3hK9nq3hF7yGwQ==
X-Received: by 2002:a17:902:680d:b0:176:9f46:bebb with SMTP id h13-20020a170902680d00b001769f46bebbmr22012587plk.122.1664202611045;
        Mon, 26 Sep 2022 07:30:11 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f15-20020aa7968f000000b00543a098a6ffsm12218733pfk.212.2022.09.26.07.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 07:30:10 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH RFC 3/3] KVM: x86/pmu: Add Intel Guest Branch Trace Store Support
Date:   Mon, 26 Sep 2022 22:29:38 +0800
Message-Id: <20220926142938.89608-4-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926142938.89608-1-likexu@tencent.com>
References: <20220926142938.89608-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The processor supports the Branch Trace Store facility (BTS) if it has DS
buffer and the MISC_ENABLE_BTS_UNAVAIL (RO) bit is cleared. The processor
can supports the CPL-qualified branch trace mechanism (DSCPL) if
CPUID.01H:ECX[bit 4] = 1.

To support guest BTS, we need expose three IA32_DEBUGCTL bits to the guest:
The TR bit makes processor to send the branch record out on the system bus
as a branch trace message (BTM) when it detects a taken branch, interrupt,
or exception. The BTS bit makes processor to log BTMs to a memory-resident
BTS buffer that is part of the DS save area. The BTINT bit makes processor
generates an interrupt when the BTS buffer is full.

A simple perf test case could be:
	perf record --per-thread -e intel_bts// ./workload
and a valid sample looks like:
	branches:            401243 cmp_end+0x0 (./workload)
			=> ffffffffb6e01410 asm_exc_nmi+0x0 ([kernel.kallsyms])

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/bts.c     |  2 ++
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/pmu.h              |  3 +++
 arch/x86/kvm/vmx/capabilities.h |  7 +++++++
 arch/x86/kvm/vmx/vmx.c          | 32 ++++++++++++++++++++++++++++----
 5 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index ffdcde5b97b1..32a7bfe24deb 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -463,6 +463,8 @@ int intel_bts_interrupt(void)
 	 */
 	if (ds && (ds->bts_index >= ds->bts_interrupt_threshold))
 		handled = 1;
+	else if (perf_guest_state() && perf_handle_guest_intr(GUEST_INTEL_BTS))
+		return 1;
 
 	/*
 	 * this is wrapped in intel_bts_enable_local/intel_bts_disable_local,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 166a77a61f2d..3b0116340399 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1663,6 +1663,7 @@ struct kvm_x86_nested_ops {
 
 enum {
 	GUEST_INTEL_PT = 0,
+	GUEST_INTEL_BTS,
 	GUEST_INVALID
 };
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 889d064d5ddd..bd3eb5339376 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -11,6 +11,9 @@
 #define MSR_IA32_MISC_ENABLE_PMU_RO_MASK (MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL |	\
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
+#define DEBUGCTLMSR_BTS_MASK		(DEBUGCTLMSR_TR | DEBUGCTLMSR_BTS | DEBUGCTLMSR_BTINT)
+#define DEBUGCTLMSR_DSCPL_MASK		(DEBUGCTLMSR_BTS_OFF_OS | DEBUGCTLMSR_BTS_OFF_USR)
+
 /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
 #define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 4dc4bbe18821..cd3b97528ab0 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -435,6 +435,13 @@ static inline u64 vmx_supported_debugctl(void)
 	if (vmx_get_perf_capabilities() & PMU_CAP_LBR_FMT)
 		debugctl |= DEBUGCTLMSR_LBR_MASK;
 
+	if (vmx_pebs_supported() && boot_cpu_has(X86_FEATURE_BTS)) {
+		debugctl |= DEBUGCTLMSR_BTS_MASK;
+		/* CPL-Qualified Branch Trace Mechanism */
+		if (boot_cpu_has(X86_FEATURE_DSCPL))
+			debugctl |= DEBUGCTLMSR_DSCPL_MASK;
+	}
+
 	return debugctl;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3622323d57c2..cd396ca3c001 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2016,6 +2016,13 @@ static u64 vcpu_supported_debugctl(struct kvm_vcpu *vcpu)
 	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
 		debugctl &= ~DEBUGCTLMSR_BUS_LOCK_DETECT;
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_DS) ||
+	    (vcpu->arch.ia32_misc_enable_msr & MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)) {
+		debugctl &= ~(DEBUGCTLMSR_BTS_MASK | DEBUGCTLMSR_DSCPL_MASK);
+	} else if (!guest_cpuid_has(vcpu, X86_FEATURE_DSCPL)) {
+		debugctl &= ~DEBUGCTLMSR_DSCPL_MASK;
+	}
+
 	return debugctl;
 }
 
@@ -7691,6 +7698,8 @@ static __init void vmx_set_cpu_caps(void)
 	if (vmx_pebs_supported()) {
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
+		if (kvm_cpu_cap_has(X86_FEATURE_DS))
+			kvm_cpu_cap_check_and_set(X86_FEATURE_DSCPL);
 	}
 
 	if (!enable_pmu)
@@ -8149,6 +8158,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 static unsigned int vmx_handle_guest_intr(unsigned int vector)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	u64 data;
 
 	/* '0' on failure so that the !PT case can use a RET0 static call. */
 	if (!vcpu || !kvm_handling_nmi_from_guest(vcpu))
@@ -8157,10 +8167,24 @@ static unsigned int vmx_handle_guest_intr(unsigned int vector)
 	if (vector >= GUEST_INVALID)
 		return 0;
 
-	kvm_make_request(KVM_REQ_PMI, vcpu);
-	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
-		  (unsigned long *)&vcpu->arch.pmu.global_status);
-	return 1;
+	switch (vector) {
+	case GUEST_INTEL_PT:
+		__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
+			  (unsigned long *)&vcpu->arch.pmu.global_status);
+		kvm_make_request(KVM_REQ_PMI, vcpu);
+		return 1;
+	case GUEST_INTEL_BTS:
+		data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		if ((data & DEBUGCTLMSR_BTS_MASK) == DEBUGCTLMSR_BTS_MASK) {
+			kvm_make_request(KVM_REQ_PMI, vcpu);
+			return 1;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return 0;
 }
 
 static __init void vmx_setup_user_return_msrs(void)
-- 
2.37.3

