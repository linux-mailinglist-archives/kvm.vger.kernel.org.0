Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD644CD0BE
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236892AbiCDJHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236553AbiCDJG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:06:29 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8276D18CC08;
        Fri,  4 Mar 2022 01:05:28 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id kx1-20020a17090b228100b001bf2dd26729so373400pjb.1;
        Fri, 04 Mar 2022 01:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CsaWSPvjxXkZNcuXrXx0pQ/nko9fCT4cUINgPyTzWN4=;
        b=R5eH0sFo0d+Hdu5IYJM9dNoy01MjJGEsxVesc+EF1TIar/CNI4KkUCyEl43MA/2Gzc
         TwGqTourq5PsQU8XOFQMRxj20Tm8RrfiS7e/yWZwMf05VXflGdi/GmfmyJvGT4zJgVE7
         4gUFsBTzb82kLovTyAyss0nyVPAfmMaO0Ud/5pSu3r79+spTc2WpjGevnTSiLTaP2vJj
         J7e66nFfayw/0XYYsqbAW/Gf/y8VYWalWMv2rPQtP81FBobLqbz1/Lofi+AkKiFtJeNL
         RS77b1XMSVXAMvh0JZvoN9/Jukvt8VLHwB956bDObX0bipYfezOiPwY2Is3BXnI1LPwh
         OmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CsaWSPvjxXkZNcuXrXx0pQ/nko9fCT4cUINgPyTzWN4=;
        b=7uIht7flcx8SoipDd6FljitsD3W25iUTV5t6Igm9r0ELkXyZ/gAQ7j/Lznle36XBOc
         WNDDUe19vIQwuPbW/oxhxAAdSqkCVGrKyVkKzyKecFcw603gITAEla+tnFhpeiLFOdtY
         Wj7Ye0RpEbE1dSJfNHXCJNdYspaEZWXYiYJXmT+R+uEP6GOrJw826QdpfmHNUlvk/hYI
         zh3MCFugzmkde5Wm7jiyc+LMqpNY1APehzHumaRFx7VI8F9nutk20Nw1kgbASefz8BR/
         ADb6+mahWVuwN1iG4gbRwLEA1qcimM1hgZK9gDtGAP91h2KUkQfMMGQ6QQGOMfPM4fhX
         doog==
X-Gm-Message-State: AOAM532c79XAPaG06UGFsmImTji1p+0I4v1pojoBqFOF2qt+xLrmJhsO
        IeBwuytRdJqiq0oInmTbIkA=
X-Google-Smtp-Source: ABdhPJzJfhBvKuKb7RDitqswTm0AYowRVr7MM84KLFYZO6tz543uyWR21q0Lb65OB7gt45XWkmcqNQ==
X-Received: by 2002:a17:902:6902:b0:14d:6aa4:f3f5 with SMTP id j2-20020a170902690200b0014d6aa4f3f5mr40754786plk.20.1646384727700;
        Fri, 04 Mar 2022 01:05:27 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:27 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 14/17] KVM: x86/pmu: Disable guest PEBS temporarily in two rare situations
Date:   Fri,  4 Mar 2022 17:04:24 +0800
Message-Id: <20220304090427.90888-15-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The guest PEBS will be disabled when some users try to perf KVM and
its user-space through the same PEBS facility OR when the host perf
doesn't schedule the guest PEBS counter in a one-to-one mapping manner
(neither of these are typical scenarios).

The PEBS records in the guest DS buffer are still accurate and the
above two restrictions will be checked before each vm-entry only if
guest PEBS is deemed to be enabled.

Suggested-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c    | 11 +++++++++--
 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  4 ++++
 arch/x86/kvm/vmx/vmx.h          |  1 +
 5 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 6d6a8bac5ae2..c064339bdfe3 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4027,8 +4027,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
 	};
 
-	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
-	arr[0].guest |= arr[*nr].guest;
+	if (arr[pebs_enable].host) {
+		/* Disable guest PEBS if host PEBS is enabled. */
+		arr[pebs_enable].guest = 0;
+	} else {
+		/* Disable guest PEBS for cross-mapped PEBS counters. */
+		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
+		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+		arr[global_ctrl].guest |= arr[pebs_enable].guest;
+	}
 
 	return arr;
 }
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 549477700b4d..ea4e64f4339f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -525,6 +525,15 @@ struct kvm_pmu {
 	u64 pebs_data_cfg;
 	u64 pebs_data_cfg_mask;
 
+	/*
+	 * If a guest counter is cross-mapped to host counter with different
+	 * index, its PEBS capability will be temporarily disabled.
+	 *
+	 * The user should make sure that this mask is updated
+	 * after disabling interrupts and before perf_guest_get_msrs();
+	 */
+	u64 host_cross_mapped_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a1fadfa3fbec..e877e1d0a147 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -782,6 +782,26 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
+{
+	struct kvm_pmc *pmc = NULL;
+	int bit;
+
+	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
+			 X86_PMC_IDX_MAX) {
+		pmc = intel_pmc_idx_to_pmc(pmu, bit);
+
+		if (!pmc || !pmc_speculative_in_use(pmc) ||
+		    !intel_pmc_is_enabled(pmc))
+			continue;
+
+		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx)) {
+			pmu->host_cross_mapped_mask |=
+				BIT_ULL(pmc->perf_event->hw.idx);
+		}
+	}
+}
+
 struct kvm_pmu_ops intel_pmu_ops = {
 	.pmc_perf_hw_id = intel_pmc_perf_hw_id,
 	.pmc_is_enabled = intel_pmc_is_enabled,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8fb29bbfe875..84635d6950c9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6712,6 +6712,10 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	struct perf_guest_switch_msr *msrs;
 	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
+	pmu->host_cross_mapped_mask = 0;
+	if (pmu->pebs_enable & pmu->global_ctrl)
+		intel_pmu_cross_mapped_check(pmu);
+
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
 	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
 	if (!msrs)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f2c82e7f38f..2abb1cb63616 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -94,6 +94,7 @@ union vmx_exit_reason {
 #define vcpu_to_lbr_desc(vcpu) (&to_vmx(vcpu)->lbr_desc)
 #define vcpu_to_lbr_records(vcpu) (&to_vmx(vcpu)->lbr_desc.records)
 
+void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
 bool intel_pmu_lbr_is_compatible(struct kvm_vcpu *vcpu);
 bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu);
 
-- 
2.35.1

