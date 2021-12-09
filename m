Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5799E46E578
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 10:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhLIJ1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 04:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhLIJ1Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 04:27:16 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C3DC061746;
        Thu,  9 Dec 2021 01:23:43 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 8so4885645pfo.4;
        Thu, 09 Dec 2021 01:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from:to:cc
         :references:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=ix3LtrBew/RMx5h8Ldwr0h6disFG6r+cyTWZjtpcymw=;
        b=GdBkaBMPd0hCF3t6inhS4ytSUUqbqW7ETlZF+ue4y1LiWttYi1SEOrCvp/blVMUxjw
         3q/Jstda5eDLyyhcvuB0vH09OPN8Ulvhh24AlpEb0mYZkg2Uq3biU5LUX16BuDKRqAyZ
         64a1URZD1ylmOSIWo0m6Rxts6RbeSUu1eLC1LGXQme3jOTRNxAhtwLT4JxHLjsi+YTgV
         x0Co+t7c4iG40W1vKk69jf8Y7HTbFawNxzWtVCBFeNFn+n6XLhi6HMFdB/j2kLXqvNsp
         s8kp8rP26rvm48xwUszE6aUWQKfBmMImeMw1P8UJyVQYUGH0uWMPPZbv3rNZBXLsVWZj
         dP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=ix3LtrBew/RMx5h8Ldwr0h6disFG6r+cyTWZjtpcymw=;
        b=LRbpe6zXu8WmNERuNbEoiyQ0eRjLMFrwvWNUVPQsUZLZQUl6GT4ufq1c3ZMP1pYWoh
         NPqRJLJrqWujcXT4KLorR+WOViFwNJBqRWP83yTBvVFyIL95daUZeqauRET7zaEi5B0X
         jm/A6fe7nMn6mLEGvfUms9Ua6SayUAvsYwnkazAWhFU2TSvopY3XSNNP/2LGsRw0G/v6
         J9tn6j9liDE2KZB9knhZKM3uzKAk3pHNjXvPxHxdyxLAxWcYHdM+cp0svVzIurNditWl
         cAq+IVTM4EvV/JrXOw2+y7dZgPVr5Ux+BVHI62+9xSwnwV1+HSWPoI6+7Qv5sXbOkgjl
         SG7w==
X-Gm-Message-State: AOAM533rM59OTrYv/UPdirP0w0EkYSrOhOlm+8orvFtPnPFH58gLzRHD
        l2Nd3bV+kdUSFDQWfdhpBxw=
X-Google-Smtp-Source: ABdhPJyoPwb22KS8T/w2NOcpeKhikXvTu2RPXcWy+A5+3GvdIW2+pTwkHTKLtdazwl2mGfapCUYY6A==
X-Received: by 2002:a63:f19:: with SMTP id e25mr13286830pgl.518.1639041822841;
        Thu, 09 Dec 2021 01:23:42 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k8sm6638169pfc.197.2021.12.09.01.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 01:23:42 -0800 (PST)
Message-ID: <38c66794-32f8-aeeb-b2f8-9a0c0f341925@gmail.com>
Date:   Thu, 9 Dec 2021 17:23:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-6-likexu@tencent.com>
 <CALMp9eQxW_0JBe_6doNTGLXHsXM_Y0YSfnrM1yqTumUQqg7A2A@mail.gmail.com>
 <ad06fc9f-4617-3262-414d-e061d3d68b9d@gmail.com>
Organization: Tencent
Subject: Re: [PATCH v2 5/6] KVM: x86: Update vPMCs when retiring instructions
In-Reply-To: <ad06fc9f-4617-3262-414d-e061d3d68b9d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> +               /* Ignore checks for edge detect, pin control, invert and 
>>> CMASK bits */
>>
>> I don't understand how we can ignore these checks. Doesn't that
>> violate the architectural specification?
> 
> OK, let's take a conservative approach in the V3.
> 

Hi Jim, does this version look good to you ?

---

 From 4ad42d98ce26d324fa2f72c38fe2c42fe04f2d6d Mon Sep 17 00:00:00 2001
From: Like Xu <likexu@tencent.com>
Date: Tue, 30 Nov 2021 15:42:20 +0800
Subject: [PATCH 5/6] KVM: x86: Update vPMCs when retiring instructions

From: Like Xu <likexu@tencent.com>

When KVM retires a guest instruction through emulation, increment any
vPMCs that are configured to monitor "instructions retired," and
update the sample period of those counters so that they will overflow
at the right time.

Signed-off-by: Eric Hankland <ehankland@google.com>
[jmattson:
   - Split the code to increment "branch instructions retired" into a
     separate commit.
   - Added 'static' to kvm_pmu_incr_counter() definition.
   - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
     PERF_EVENT_STATE_ACTIVE.
]
Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Signed-off-by: Jim Mattson <jmattson@google.com>
[likexu:
   - Drop checks for pmc->perf_event or event state or event type
   - Increase a counter only its umask bits and the first 8 select bits are matched
   - Rewrite kvm_pmu_incr_counter() with a less invasive approach to the host perf;
   - Rename kvm_pmu_record_event to kvm_pmu_trigger_event;
   - Add counter enable and CPL check for kvm_pmu_trigger_event();
]
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Like Xu <likexu@tencent.com>
---
  arch/x86/kvm/pmu.c | 73 ++++++++++++++++++++++++++++++++++++++++++----
  arch/x86/kvm/pmu.h |  1 +
  arch/x86/kvm/x86.c |  3 ++
  3 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a20207ee4014..db510dae3241 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -22,6 +22,14 @@
  /* This is enough to filter the vast majority of currently defined events. */
  #define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300

+#define PMC_EVENTSEL_ARCH_MASK \
+	(ARCH_PERFMON_EVENTSEL_EVENT | \
+	 ARCH_PERFMON_EVENTSEL_UMASK | \
+	 ARCH_PERFMON_EVENTSEL_USR | \
+	 ARCH_PERFMON_EVENTSEL_OS | \
+	 ARCH_PERFMON_EVENTSEL_INT | \
+	 ARCH_PERFMON_EVENTSEL_ENABLE)
+
  /* NOTE:
   * - Each perf counter is defined as "struct kvm_pmc";
   * - There are two types of perf counters: general purpose (gp) and fixed.
@@ -203,11 +211,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
  	if (!allow_event)
  		return;

-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
-			  ARCH_PERFMON_EVENTSEL_INV |
-			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  HSW_IN_TX |
-			  HSW_IN_TX_CHECKPOINTED))) {
+	if (!(eventsel & ~PMC_EVENTSEL_ARCH_MASK)) {
  		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
  		if (config != PERF_COUNT_HW_MAX)
  			type = PERF_TYPE_HARDWARE;
@@ -482,6 +486,65 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
  	kvm_pmu_reset(vcpu);
  }

+static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
+	u64 prev_count;
+
+	prev_count = pmc->counter;
+	pmc->counter = (pmc->counter + 1) & pmc_bitmask(pmc);
+
+	reprogram_counter(pmu, pmc->idx);
+	if (pmc->counter < prev_count)
+		__kvm_perf_overflow(pmc, false);
+}
+
+static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
+	unsigned int perf_hw_id)
+{
+	if (pmc->eventsel & ~PMC_EVENTSEL_ARCH_MASK)
+		return false;
+
+	return kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc) == perf_hw_id;
+}
+
+static inline bool cpl_is_matched(struct kvm_pmc *pmc)
+{
+	bool select_os, select_user;
+	u64 config = pmc->current_config;
+
+	if (pmc_is_gp(pmc)) {
+		select_os = config & ARCH_PERFMON_EVENTSEL_OS;
+		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
+	} else {
+		select_os = config & 0x1;
+		select_user = config & 0x2;
+	}
+
+	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
+}
+
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	if (!pmu->version)
+		return;
+
+	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
+		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
+
+		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+			continue;
+
+		if (eventsel_match_perf_hw_id(pmc, perf_hw_id) && cpl_is_matched(pmc))
+			kvm_pmu_incr_counter(pmc);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
+
  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
  {
  	struct kvm_pmu_event_filter tmp, *filter;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index c91d9725aafd..7a7b8d5b775e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -157,6 +157,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
  void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
  void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);

  bool is_vmware_backdoor_pmc(u32 pmc_idx);

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1aaf37e1bd0f..68b65e243eb3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7980,6 +7980,8 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
  	if (unlikely(!r))
  		return 0;

+	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
+
  	/*
  	 * rflags is the old, "raw" value of the flags.  The new value has
  	 * not been saved yet.
@@ -8242,6 +8244,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t 
cr2_or_gpa,
  		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
  		if (!ctxt->have_exception ||
  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
+			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
  			kvm_rip_write(vcpu, ctxt->eip);
  			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
  				r = kvm_vcpu_do_singlestep(vcpu);
-- 
2.33.1


