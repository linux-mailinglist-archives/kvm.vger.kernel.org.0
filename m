Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC464701C5
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242182AbhLJNkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241949AbhLJNjl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:41 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8688FC061746;
        Fri, 10 Dec 2021 05:36:04 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so8186955pjj.0;
        Fri, 10 Dec 2021 05:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8BUNRnbtACg9s5tj0qs0msyI/Yh6w1c2C3VgApfTVNY=;
        b=ao3Cgyo4ZoZGONJciUDZzTwGKrO1tYT8QdJnG9DZOY2TwgTU0eFkWVs+giwXU94CHt
         /HzElFluYnlT1dtXdPYnuJxz5xDdHLHeOFKIEX00Z7jwq3NWRieZOrTryzD3r/tdPc4u
         a8jds6oGAZndJ8gBaBlnKHIZmzufdGMqo/Hl2Xy0msc68G9NM0Q8uac4/r5xYe/0XhqN
         f7RydutTVbHj651YL3iMrgLNg1Wcv0CNSk5WrCtRAPkxA7oU7O4T5Lw9A6OfSVc2wiaj
         HO+EYj7ht72QS6NuLPyr/TRDKUTZRNw3gXzPr7mZK0ddsHaIT0PZBpuPvbR2Akfdiqok
         vXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8BUNRnbtACg9s5tj0qs0msyI/Yh6w1c2C3VgApfTVNY=;
        b=SOYhDn+CZppybiQeRRvMtctq8KqzS9wji9+vDm3zH/YJxHWBc3nzX1gXxtkxZ6bU/G
         BIw5y7iS2atNnSx64QuvShIjiu3QtZCsBm8CjRpccq0bgCWxSmilEfkCzSfnCvbOtLdS
         QCMGfosjOisoXqSHz46O/bGbdvZdny+T7jKloxtfn0VJJJ7BvishhGtvJgKrWumvuubK
         fkdvA6BAb/jTWJpzuDPSoJ8HfgkQZrjCdpvwHTIjRWYbgHXDl6Rc0z4OreXYU0eraJ72
         Nuu+8G47yJEKMP2b3mncC7FTpnjd3kPy/l+JCximDVxNQ4rHj5DpqgTvF64RlWNHoVTE
         iwYQ==
X-Gm-Message-State: AOAM530pWS1DjDylCb/NHSgSmYYL/hEPvqqfvrp0aA6u+YL6NnNjkT1f
        cHUrj3+by0ZQu03AvJ84SAQ=
X-Google-Smtp-Source: ABdhPJyT9eOYJueXOWzZDMo6IAESQ0EEpE+rnae1f63mQeSuX+DEq0QF9wBe77GgJ9pj3z3h2VPMXA==
X-Received: by 2002:a17:902:e806:b0:142:830:eaa4 with SMTP id u6-20020a170902e80600b001420830eaa4mr74695518plg.16.1639143364041;
        Fri, 10 Dec 2021 05:36:04 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:03 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 07/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
Date:   Fri, 10 Dec 2021 21:35:15 +0800
Message-Id: <20211210133525.46465-8-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the
IA32_PEBS_ENABLE MSR exists and all architecturally enumerated fixed
and general-purpose counters have corresponding bits in IA32_PEBS_ENABLE
that enable generation of PEBS records. The general-purpose counter bits
start at bit IA32_PEBS_ENABLE[0], and the fixed counter bits start at
bit IA32_PEBS_ENABLE[32].

When guest PEBS is enabled, the IA32_PEBS_ENABLE MSR will be
added to the perf_guest_switch_msr() and atomically switched during
the VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Based on whether the platform supports x86_pmu.pebs_vmx, it has also
refactored the way to add more msrs to arr[] in intel_guest_get_msrs()
for extensibility.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c     | 75 ++++++++++++++++++++++++--------
 arch/x86/include/asm/kvm_host.h  |  3 ++
 arch/x86/include/asm/msr-index.h |  6 +++
 arch/x86/kvm/vmx/pmu_intel.c     | 31 +++++++++++++
 4 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c886e360698c..2860be9f3887 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3951,33 +3951,72 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * Currently, the only caller of this function is the atomic_switch_perf_msrs().
+ * The host perf conext helps to prepare the values of the real hardware for
+ * a set of msrs that need to be switched atomically in a vmx transaction.
+ *
+ * For example, the pseudocode needed to add a new msr should look like:
+ *
+ * arr[(*nr)++] = (struct perf_guest_switch_msr){
+ *	.msr = the hardware msr address,
+ *	.host = the value the hardware has when it doesn't run a guest,
+ *	.guest = the value the hardware has when it runs a guest,
+ * };
+ *
+ * These values have nothing to do with the emulated values the guest sees
+ * when it uses {RD,WR}MSR, which should be handled by the KVM context,
+ * specifically in the intel_pmu_{get,set}_msr().
+ */
 static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
+	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
+	int global_ctrl, pebs_enable;
+
+	*nr = 0;
+	global_ctrl = (*nr)++;
+	arr[global_ctrl] = (struct perf_guest_switch_msr){
+		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
+		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
+		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+	};
 
-	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
-	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
-	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
-	*nr = 1;
+	if (!x86_pmu.pebs)
+		return arr;
 
-	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
-		/*
-		 * If PMU counter has PEBS enabled it is not enough to
-		 * disable counter on a guest entry since PEBS memory
-		 * write can overshoot guest entry and corrupt guest
-		 * memory. Disabling PEBS solves the problem.
-		 *
-		 * Don't do this if the CPU already enforces it.
-		 */
-		arr[1].msr = MSR_IA32_PEBS_ENABLE;
-		arr[1].host = cpuc->pebs_enabled;
-		arr[1].guest = 0;
-		*nr = 2;
+	/*
+	 * If PMU counter has PEBS enabled it is not enough to
+	 * disable counter on a guest entry since PEBS memory
+	 * write can overshoot guest entry and corrupt guest
+	 * memory. Disabling PEBS solves the problem.
+	 *
+	 * Don't do this if the CPU already enforces it.
+	 */
+	if (x86_pmu.pebs_no_isolation) {
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = MSR_IA32_PEBS_ENABLE,
+			.host = cpuc->pebs_enabled,
+			.guest = 0,
+		};
+		return arr;
 	}
 
+	if (!x86_pmu.pebs_vmx)
+		return arr;
+	pebs_enable = (*nr)++;
+
+	arr[pebs_enable] = (struct perf_guest_switch_msr){
+		.msr = MSR_IA32_PEBS_ENABLE,
+		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
+		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
+	};
+
+	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+	arr[0].guest |= arr[*nr].guest;
+
 	return arr;
 }
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cee034445e3..d8b4d2072abb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -518,6 +518,9 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 pebs_enable;
+	u64 pebs_enable_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 01e2650b9585..32958425fef1 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -189,6 +189,12 @@
 #define PERF_CAP_PT_IDX			16
 
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
+#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
+#define PERF_CAP_ARCH_REG              BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT           0xf00
+#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
+#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
+				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
 
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b76210622232..b7afd10c098e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -208,6 +208,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -355,6 +358,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = 0;
 		return 0;
+	case MSR_IA32_PEBS_ENABLE:
+		msr_info->data = pmu->pebs_enable;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -414,6 +420,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		if (pmu->pebs_enable == data)
+			return 0;
+		if (!(data & pmu->pebs_enable_mask)) {
+			pmu->pebs_enable = data;
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -481,6 +495,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
+	pmu->pebs_enable_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -548,6 +563,22 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
+
+	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
+			pmu->pebs_enable_mask = ~pmu->global_ctrl;
+			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
+			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+				pmu->fixed_ctr_ctrl_mask &=
+					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
+			}
+		} else {
+			pmu->pebs_enable_mask =
+				~((1ull << pmu->nr_arch_gp_counters) - 1);
+		}
+	} else {
+		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.33.1

