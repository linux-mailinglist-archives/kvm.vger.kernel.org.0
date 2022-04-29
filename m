Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6686514268
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 08:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354571AbiD2GiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 02:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232281AbiD2GiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 02:38:11 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CBAB9F1D;
        Thu, 28 Apr 2022 23:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651214094; x=1682750094;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=SQHceauWJWDbx4dQ4RD3nCy2YCKzrHcJFy/6dkhMb30=;
  b=LcK2nc6QWTARU2GEhIUARYfxaRV6pjD/gTIbCmYiUiYVP7xyq/QBlcva
   mDuDzcMAFDUcgwPJTG9eo20Qyxx51IYDw4OyMd/9EKlBCBE8YwxwEox4L
   fgvFDtOW0zc3ky5K0Ji+0UBbpzzW0prjUYod8dmgakxH47O2ZYWJGnA/H
   mR7VtLlsdBk22gUevU2aL4hh4RzRXP1mQ6yd7XcLheh51y+xn33qJ1dTT
   ktptgbGA92IWyjbS+BCyR8pHIKuL8iUMPbtEFqXTXYS3iebOJGt3zCuvo
   shj8FZxxp3ZHQfZEZelfCMlG26/NB50ztgdmyTZ47t3cHMDUy/0c+MVQi
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266365708"
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="266365708"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 23:34:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,297,1647327600"; 
   d="scan'208";a="560147609"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.171.134]) ([10.249.171.134])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 23:34:49 -0700
Message-ID: <2cc9d183-0bb5-9d4b-f284-9bbb1b4c21be@intel.com>
Date:   Fri, 29 Apr 2022 14:34:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v10 15/16] KVM: x86: Add Arch LBR data MSR access
 interface
Content-Language: en-US
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
 <20220422075509.353942-16-weijiang.yang@intel.com>
 <6f2107fd-4475-86c7-e410-fe02c37b0f4d@linux.intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <6f2107fd-4475-86c7-e410-fe02c37b0f4d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/28/2022 11:05 PM, Liang, Kan wrote:
>
> On 4/22/2022 3:55 AM, Yang Weijiang wrote:
>> Arch LBR MSRs are xsave-supported, but they're operated as "independent"
>> xsave feature by PMU code, i.e., during thread/process context switch,
>> the MSRs are saved/restored with PMU specific code instead of generic
>> kernel fpu XSAVES/XRSTORS operation.
> During thread/process context switch, Linux perf still uses the
> XSAVES/XRSTORS operation to save/restore the LBR MSRs.

I meant Arch LBR MSRs are switched with perf_event_task_sched_out()/

perf_event_task_sched_in() instead of save_fpregs_to_fpstate()/ 
restore_fpregs_from_fpstate().

sorry for the confusion, will modify it a bit.

>
> Linux perf only manipulates these MSRs only when the xsave feature is
> not supported.
Exactly.
>
> Thanks,
> Kan
>
>> When vcpu guest/host fpu state swap
>> happens, Arch LBR MSRs won't be touched so access them directly.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>    arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
>>    1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 79eecbffa07b..5f81644c4612 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -431,6 +431,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>    	case MSR_ARCH_LBR_CTL:
>>    		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>>    		return 0;
>> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
>> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
>> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>> +		rdmsrl(msr_info->index, msr_info->data);
>> +		return 0;
>>    	default:
>>    		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>    		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -512,6 +517,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>    		    (data & ARCH_LBR_CTL_LBREN))
>>    			intel_pmu_create_guest_lbr_event(vcpu);
>>    		return 0;
>> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
>> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
>> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>> +		wrmsrl(msr_info->index, msr_info->data);
>> +		return 0;
>>    	default:
>>    		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>    		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
