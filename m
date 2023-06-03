Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2562720CD5
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 03:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbjFCBLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 21:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbjFCBLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 21:11:06 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1C9E50
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 18:11:03 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-2553b096ddfso2387464a91.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 18:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685754663; x=1688346663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NU+ycyGnxu88uw+EwETUIF4qNqsYgJat1S24XSYVjxU=;
        b=e5NNdTWQ1K2mv9p3/IYVxsicV6Twj5YqaoVaRDDMw+57CPht33+iismaab5Um2jnwA
         yVMjAmOr3waiqCHDGR8jd7dj1vSMo7majCIl4eKh5jHq8pTdPmNncvguNcNACVT9IwSv
         2Bb05+PWypB8ig/lxkl3NZJ2l3TwDaGk650FUe5wEdSSt5ZBq0DZmx2uupHPUJMAHnQM
         cPe1AyWMwDZs2Mbr5cpyBR0NXunxnx14opDdpnmJREGzQuwyXMu+FEvepyYNFU0Qu/a5
         ArCLErlsyUcuB5kCUc3FoLyfkvK+SINHJ+HunqIggJQ5IRO9e/f4kCmoNwXyLjvBVHbY
         wOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685754663; x=1688346663;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NU+ycyGnxu88uw+EwETUIF4qNqsYgJat1S24XSYVjxU=;
        b=NtqzSJtAaorrV9x58KYzLo6Jm9kw9QPVvgTu4FXKlUW88Sv8NQlv/OIkSdDxGdDFq9
         snwWtu29g11x5s1nAkILhb1gJ3VgpxAPAudnHcieW4DBBLspKXw8fCTrLBTpRe0xK9Fv
         5cRe5DkAcU75o6IdUyIw3+Nd+fahatxDCS+gIBZq9AIjvLwny0xNR/ktNozyG6nrD0nz
         a4RZTzx2t/SNxEh6Uy8QtPHQDg6HhkpxNk4k6SBxZqDsMfzBfLJdkFcOQ7Ijo2WvPJg0
         IwC35DvrfyNemqND1bUo8VawFOAsK3LBRKmrevIlumrf2hbhXPWYH0nQoPy/nxAZMQn5
         jA+Q==
X-Gm-Message-State: AC+VfDx2i4iSKzenxopoHrAAQxEzu88Cyj5JZ2U1Etq2mbraaqOfoyuU
        I1CWb0Um6rTWg/PpSu2+qKBBN/kwki0=
X-Google-Smtp-Source: ACHHUZ790PdH3Eci3gX3EL755X3qEWX8Az2bLyIOmZK6vS3ODTcxHS/0JC9dmzaYgl8W1LDU93utrGQgqvU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:394e:b0:256:2192:2c58 with SMTP id
 oe14-20020a17090b394e00b0025621922c58mr312633pjb.4.1685754663465; Fri, 02 Jun
 2023 18:11:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  2 Jun 2023 18:10:47 -0700
In-Reply-To: <20230603011058.1038821-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230603011058.1038821-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230603011058.1038821-2-seanjc@google.com>
Subject: [PATCH v7 01/12] KVM: x86/pmu: Rename global_ovf_ctrl_mask to global_status_mask
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <likexu@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename global_ovf_ctrl_mask to global_status_mask to avoid confusion now
that Intel has renamed GLOBAL_OVF_CTRL to GLOBAL_STATUS_RESET in PMU v4.
GLOBAL_OVF_CTRL and GLOBAL_STATUS_RESET are the same MSR index, i.e. are
just different names for the same thing, but the SDM provides different
entries in the IA-32 Architectural MSRs table, which gets really confusing
when looking at PMU v4 definitions since it *looks* like GLOBAL_STATUS has
bits that don't exist in GLOBAL_OVF_CTRL, but in reality the bits are
simply defined in the GLOBAL_STATUS_RESET entry.

No functional change intended.

Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c    | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136..28bd38303d70 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -523,7 +523,7 @@ struct kvm_pmu {
 	u64 global_status;
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
-	u64 global_ovf_ctrl_mask;
+	u64 global_status_mask;
 	u64 reserved_bits;
 	u64 raw_event_mask;
 	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 741efe2c497b..fb96cbfc9ae8 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -427,7 +427,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		if (data & pmu->global_ovf_ctrl_mask)
+		/*
+		 * GLOBAL_OVF_CTRL, a.k.a. GLOBAL STATUS_RESET, clears bits in
+		 * GLOBAL_STATUS, and so the set of reserved bits is the same.
+		 */
+		if (data & pmu->global_status_mask)
 			return 1;
 
 		if (!msr_info->host_initiated)
@@ -531,7 +535,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 	pmu->global_ctrl_mask = ~0ull;
-	pmu->global_ovf_ctrl_mask = ~0ull;
+	pmu->global_status_mask = ~0ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;
@@ -585,11 +589,17 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
 	pmu->global_ctrl_mask = counter_mask;
-	pmu->global_ovf_ctrl_mask = pmu->global_ctrl_mask
+
+	/*
+	 * GLOBAL_STATUS and GLOBAL_OVF_CONTROL (a.k.a. GLOBAL_STATUS_RESET)
+	 * share reserved bit definitions.  The kernel just happens to use
+	 * OVF_CTRL for the names.
+	 */
+	pmu->global_status_mask = pmu->global_ctrl_mask
 			& ~(MSR_CORE_PERF_GLOBAL_OVF_CTRL_OVF_BUF |
 			    MSR_CORE_PERF_GLOBAL_OVF_CTRL_COND_CHGD);
 	if (vmx_pt_mode_is_host_guest())
-		pmu->global_ovf_ctrl_mask &=
+		pmu->global_status_mask &=
 				~MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI;
 
 	entry = kvm_find_cpuid_entry_index(vcpu, 7, 0);
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

