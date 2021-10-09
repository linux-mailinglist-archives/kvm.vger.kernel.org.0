Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0E5427847
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 11:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbhJIJLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 Oct 2021 05:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244305AbhJIJLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 Oct 2021 05:11:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64DAC061570;
        Sat,  9 Oct 2021 02:09:46 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ls18so9344660pjb.3;
        Sat, 09 Oct 2021 02:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wuqphgKvr5OKJUpCclpJueDTJYxdQ5QHiNBmL1E9oj4=;
        b=e549eoABPAYOULGwuz5cXPZ8pUpri7ZPQiMo/32Ts16+KXghaviDkl/05Lq0j9onmm
         HtORzXLjbS7JQwJ7B+/KJbyU24I1NJox0LLNe/1U/mlFUTQylIf2lPyxLXK1umXk1eCP
         jomZeTVU/u4tZYJgAvfJcnVAFL+ttS+TkvvEqdkX/8Xvp7BiigByJNqVWG4rVsp+Cqn/
         8/VhjN99qEZNqwK9ez6lBXYR42OyM9n/u56QSwI0V+PKLrZ/cU7jUu6Ey+Bpvb1iZrA+
         KO7upaTvdZe9rpDm9tn4bbJ/IK4Wd0eibOdz3GGTCdtlBI8Lu8CAV2LF62cGpEaNq3CB
         NErg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wuqphgKvr5OKJUpCclpJueDTJYxdQ5QHiNBmL1E9oj4=;
        b=JNvjRz73zLGKfZF6pYQ4dsF8TpHuAof7cbZqdrRmKM0A9qnEJSdScb8XrbGhvAyMtA
         qDhh6gZxMDH11nXWrlPRCSqbFwsHiJuWVsD53GdL/0lxb3/KCV0W9TZvMrN6a0/Otvgo
         p1sGRL567SdEFRDcyrABHt0kbTW4ZwrSiVIw6ZKa0+yPGWl/XlRXqPG44tVrcj08iab+
         Sjlex//z6RNGBWyEIwAi+CO9XWhPjDe6THzUnBKJkvarGL+t4TyUCNLnElOAFxHPJkpy
         ptpcujZNeAqs0m9mzgBwwIiiiiiUmvC1JghexU/wGIKr5Wtb5JM77nCedkMKzTnyacFB
         ooRA==
X-Gm-Message-State: AOAM5300kojXVdc93l8ydU7rLjwJMzNbCVGOolblEWz/YWO9P9OCNWry
        5S0jx6dyhTGbu42gFKYot8xkTJJ4H28GDw==
X-Google-Smtp-Source: ABdhPJzGRfiHAAak1Nm3nyjyGOuhSPnoY4eVJXfgeoMzXVoNt3eLBi192f3jpWB/begGfykx14NyJg==
X-Received: by 2002:a17:90b:248:: with SMTP id fz8mr8349986pjb.157.1633770585982;
        Sat, 09 Oct 2021 02:09:45 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.googlemail.com with ESMTPSA id u2sm13607217pji.30.2021.10.09.02.09.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Oct 2021 02:09:45 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/3] KVM: vPMU: Fill get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0
Date:   Sat,  9 Oct 2021 02:08:51 -0700
Message-Id: <1633770532-23664-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
References: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

SDM section 18.2.3 mentioned that:

  "IA32_PERF_GLOBAL_OVF_CTL MSR allows software to clear overflow indicator(s) of 
   any general-purpose or fixed-function counters via a single WRMSR."

It is R/W mentioned by SDM, we read this msr on bare-metal during perf testing, 
the value is always 0 for ICX/SKX boxes on hands. Let's fill get_msr
MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0 as hardware behavior and drop
global_ovf_ctrl variable.

Tested-by: Like Xu <likexu@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * drop 'u64 global_ovf_ctrl' directly

 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/vmx/pmu_intel.c    | 6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..7aaac918e992 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -499,7 +499,6 @@ struct kvm_pmu {
 	u64 fixed_ctr_ctrl;
 	u64 global_ctrl;
 	u64 global_status;
-	u64 global_ovf_ctrl;
 	u64 counter_bitmask[2];
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10cc4f65c4ef..b8e0d21b7c8a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -365,7 +365,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = pmu->global_ctrl;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		msr_info->data = pmu->global_ovf_ctrl;
+		msr_info->data = 0;
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
@@ -423,7 +423,6 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!(data & pmu->global_ovf_ctrl_mask)) {
 			if (!msr_info->host_initiated)
 				pmu->global_status &= ~data;
-			pmu->global_ovf_ctrl = data;
 			return 0;
 		}
 		break;
@@ -588,8 +587,7 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = 0;
 	}
 
-	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
-		pmu->global_ovf_ctrl = 0;
+	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
 
 	intel_pmu_release_guest_lbr_event(vcpu);
 }
-- 
2.25.1

