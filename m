Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5ED5F80B6
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 00:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJGWTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 18:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJGWTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 18:19:16 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542C19E0CD
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 15:19:13 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x1so5722857plv.5
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 15:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bgGfGMmgZcTgRkcv5RMEIwz9Tdn3jga876+AoB1hcVM=;
        b=oP8otBidcp+51iAMk8Ul1te2fmxymf/gFlAPGWKmq0IFrWooNvqf20ptiB+juM/8gi
         zyUWt0fXjHAZMERlbNUAOH4H4LMkXOKjkmVL6Kfuqh6Ml+Ar3cEqWjXV1x4entip0e7z
         Q3GDacTaLvtMkUCmf3QDLFCswWTZjCdYMT4onp02sO1plDPH6UZ8oEA6GFR64oUpd4C0
         8uutrIkQjI+14qBSbzD77bKM0uN1EG2dYgqtoihbU9dqAG+IebJBjogmQCKrnXI7RySh
         zzmuPTNiDix20zo+iL5quqCq3W9QLqD4TxIoMrYbHDSNjwuX0SjiBIcRgFfLiDzpCkGM
         IuGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgGfGMmgZcTgRkcv5RMEIwz9Tdn3jga876+AoB1hcVM=;
        b=0WWAfp0Gff8PFiKwZCLxW6RDjDjWsvLXGaL1XZ5VPfpq58quHzwgk3ytbgRtXRWLNh
         ssYFVEXTmtp+WumgyZk1F4iMhysggbNt020Di1l0GOO+RZubUjjRoBmQmkyiG5RjhD6a
         8yLlEM9P3JW1cAkI59v+uMz/eZUmEUdb/pq93/7XbNCWvRjZfOr7e5PvPswxqmCQU7lo
         fQJq5hyZ7006hxTFoHCpWtFpq5T5roK8i8M3gkjIruSpK/aSBDekBLR5Fm0ugtg7wCQC
         XhxZ4HSTwbvFY1s9WywBTq/KVCA5lPaWd4u+MhEq21Jc2HCnZIphHZuCaDalhN6z45pn
         l9WQ==
X-Gm-Message-State: ACrzQf2i317BsohjOA9DifATXHBDklxrxyKr99U0ntOTXI3SN021Y+wb
        zXqFnAwsTQy61bMTv4JxcWq3CQ==
X-Google-Smtp-Source: AMsMyM7euDqs9H7UQ0Yn4ieSA0Glg2rY15Fb9v0W+GySyeIGGfsYP7kRJizUie/DdRpwsbJ7n8EHHQ==
X-Received: by 2002:a17:90a:7c4a:b0:20a:b201:461a with SMTP id e10-20020a17090a7c4a00b0020ab201461amr7545475pjl.181.1665181152680;
        Fri, 07 Oct 2022 15:19:12 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z5-20020a623305000000b00562a0c8a195sm2112417pfz.69.2022.10.07.15.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:19:12 -0700 (PDT)
Date:   Fri, 7 Oct 2022 22:19:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] KVM: x86/pmu: Make part of the Intel v2 PMU MSRs
 handling x86 generic
Message-ID: <Y0Cl3GtMhwr3hwK8@google.com>
References: <20220919093453.71737-1-likexu@tencent.com>
 <20220919093453.71737-2-likexu@tencent.com>
 <CALMp9eRPEFHFfW+MnMkcTBFB+vjcEe3ekg8JMrKJaRQuq7=-8Q@mail.gmail.com>
 <856e3332-9f6b-a5f7-c3ec-afe89003cb84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <856e3332-9f6b-a5f7-c3ec-afe89003cb84@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, Like Xu wrote:
> On 22/9/2022 8:20 am, Jim Mattson wrote:
> > >   int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >   {
> > > +       struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > > +       u32 msr = msr_info->index;
> > > +       u64 data = msr_info->data;
> > > +       u64 diff;
> > > +
> > > +       switch (msr) {
> > > +       case MSR_CORE_PERF_GLOBAL_STATUS:
> > > +               if (msr_info->host_initiated) {
> > > +                       pmu->global_status = data;
> > > +                       return 0;
> > > +               }
> > > +               break; /* RO MSR */
> > Perhaps 'return 1'?
> > > +       case MSR_CORE_PERF_GLOBAL_CTRL:
> > > +               if (pmu->global_ctrl == data)
> > > +                       return 0;
> > > +               if (kvm_valid_perf_global_ctrl(pmu, data)) {
> > > +                       diff = pmu->global_ctrl ^ data;
> > > +                       pmu->global_ctrl = data;
> > > +                       reprogram_counters(pmu, diff);
> > > +                       return 0;
> > > +               }
> > > +               break;
> > Perhaps 'return 1'?
> > > +       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> > > +               if (!(data & pmu->global_ovf_ctrl_mask)) {
> > > +                       if (!msr_info->host_initiated)
> > > +                               pmu->global_status &= ~data;

Pre-existing code question: why are writes from host userspace dropped?  Is the
intent to avoid clearing the status register when the VM is migrated?

> > > +                       return 0;
> > > +               }
> > > +               break;
> > Perhaps 'return 1'?

Assuming the code is inverted, I'd prefer to keep the "break" to be consistent
with the other set_msr() helpers.

> All above applied.

I realize the code is pre-existing, but as opportunistic refactoring this should
be cleaned up to align with pretty much every other set_msr() helper, and with
respect to how the kernel typically handles errors.  The preferred pattern is to do:

		if (xyz)
			return <error>

		<commit change>
	
		return <success>

I.e. intel_pmu_set_msr() is backwards, and having "default" statement silently
fallthrough is a bit nasty.

Cases like MSR_PEBS_DATA_CFG have also needlessly copied the "do check iff the
value is changing".
		
Can you add fold in the below (lightly tested) prep patch to fix intel_pmu_set_msr()?
Then this patch becomes a straight code movement.

--
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 7 Oct 2022 14:40:49 -0700
Subject: [PATCH] KVM: VMX: Refactor intel_pmu_set_msr() to align with other
 set_msr() helpers

Invert the flows in intel_pmu_set_msr()'s case statements so that they
follow the kernel's preferred style of:

	if (<not valid>)
		return <error>

	<commit change>
	return <success>

which is also the style used by every other set_msr() helper (except
AMD's PMU variant, which doesn't use a switch statement).

Opportunstically move the "val == current" checks below the validity
checks.  Except for the one-off case for MSR_P6_EVNTSEL2, the reserved
bit checks are extremely cheap, and the guest is unlikely to frequently
write the current value, i.e. avoiding the reserved bit checks doesn't
add much (any?) value.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 78 ++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 25b70a85bef5..3031baa6742b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -397,44 +397,43 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
-		if (pmu->fixed_ctr_ctrl == data)
-			return 0;
-		if (!(data & pmu->fixed_ctr_ctrl_mask)) {
+		if (data & pmu->fixed_ctr_ctrl_mask)
+			return 1;
+
+		if (pmu->fixed_ctr_ctrl != data)
 			reprogram_fixed_counters(pmu, data);
-			return 0;
-		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_STATUS:
-		if (msr_info->host_initiated) {
-			pmu->global_status = data;
-			return 0;
-		}
-		break; /* RO MSR */
+		if (!msr_info->host_initiated)
+			return 1;
+
+		pmu->global_status = data;
+		break;
 	case MSR_CORE_PERF_GLOBAL_CTRL:
-		if (pmu->global_ctrl == data)
-			return 0;
-		if (kvm_valid_perf_global_ctrl(pmu, data)) {
+		if (!kvm_valid_perf_global_ctrl(pmu, data))
+			return 1;
+
+		if (pmu->global_ctrl != data) {
 			diff = pmu->global_ctrl ^ data;
 			pmu->global_ctrl = data;
 			reprogram_counters(pmu, diff);
-			return 0;
 		}
 		break;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		if (!(data & pmu->global_ovf_ctrl_mask)) {
-			if (!msr_info->host_initiated)
-				pmu->global_status &= ~data;
-			return 0;
-		}
+		if (data & pmu->global_ovf_ctrl_mask)
+			return 1;
+
+		if (!msr_info->host_initiated)
+			pmu->global_status &= ~data;
 		break;
 	case MSR_IA32_PEBS_ENABLE:
-		if (pmu->pebs_enable == data)
-			return 0;
-		if (!(data & pmu->pebs_enable_mask)) {
+		if (data & pmu->pebs_enable_mask)
+			return 1;
+
+		if (pmu->pebs_enable != data) {
 			diff = pmu->pebs_enable ^ data;
 			pmu->pebs_enable = data;
 			reprogram_counters(pmu, diff);
-			return 0;
 		}
 		break;
 	case MSR_IA32_DS_AREA:
@@ -443,14 +442,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
 		pmu->ds_area = data;
-		return 0;
+		break;
 	case MSR_PEBS_DATA_CFG:
-		if (pmu->pebs_data_cfg == data)
-			return 0;
-		if (!(data & pmu->pebs_data_cfg_mask)) {
-			pmu->pebs_data_cfg = data;
-			return 0;
-		}
+		if (data & pmu->pebs_data_cfg_mask)
+			return 1;
+		pmu->pebs_data_cfg = data;
 		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
@@ -463,28 +459,32 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				data = (s64)(s32)data;
 			pmc->counter += data - pmc_read_counter(pmc);
 			pmc_update_sample_period(pmc);
-			return 0;
+			break;
 		} else if ((pmc = get_fixed_pmc(pmu, msr))) {
 			pmc->counter += data - pmc_read_counter(pmc);
 			pmc_update_sample_period(pmc);
-			return 0;
+			break;
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
-			if (data == pmc->eventsel)
-				return 0;
 			reserved_bits = pmu->reserved_bits;
 			if ((pmc->idx == 2) &&
 			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
 				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
-			if (!(data & reserved_bits)) {
+			if (data & reserved_bits)
+				return 1;
+
+			if (data != pmc->eventsel) {
 				pmc->eventsel = data;
 				reprogram_counter(pmc);
-				return 0;
 			}
-		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false))
-			return 0;
+			break;
+		} else if (intel_pmu_handle_lbr_msrs_access(vcpu, msr_info, false)) {
+			break;
+		}
+		/* Not a known PMU MSR. */
+		return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)

base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 


