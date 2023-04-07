Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2A586DA938
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 09:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbjDGHIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 03:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDGHIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 03:08:41 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD717ED5;
        Fri,  7 Apr 2023 00:08:40 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id ix20so39402142plb.3;
        Fri, 07 Apr 2023 00:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680851320; x=1683443320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fogZpcIhBm+EYQJR/1/ExLYvOd3540V4d7kBYjvBISc=;
        b=k6HZMKQj51o76jbF9gJLkRe9sZkuLAp7u5+eeJYAgXVgpkgegeCMZkVVV5KqwTWAUn
         sPJ1yQDoK1GiOZdJRe1OI/otZ8hpc95RWumZUKVHlApuw+rgQs4EkPUyMHu5wf+JVL77
         kvZ82e7wU24XjcYaM82qyYgkES6XxYvQSO1ngdQn3gVsMb5GTh+SvdbBCQRNtUFCOnxt
         YmvQAFnFuiev/spjE8vWg6YM1yOJjfFnMCQ2+f4mzQuUEz/uSDvl4TXKzYc/3DAkvh0T
         hB4JfciPP3wAR0ZHtGBuZU5HkiJATZVgdxArbtdoB6jdu29376pAQLaZVjd2vu16QHz0
         i7nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680851320; x=1683443320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fogZpcIhBm+EYQJR/1/ExLYvOd3540V4d7kBYjvBISc=;
        b=txtm6dThCEUeXEAXGnrEYWPSaeSC2wJVzAmduPLFIXC6UOhEUYdhy1XiId8352C5DV
         82DSFd4c45LPeR6gn+z76N/txaXJMLf1pIg8zjujlsug2A8ZERJX5t5b1xjqkTSTiNxh
         pVeoc5plLjxJKhsM1wiOb25qYTNYN7SJPv1uUwIc8lKIHdqNzDtD+FLFGw7EusBOC4uL
         0/rsGwywUkjzE4ht61UU/l0mxymG89BQQjpFj/E74W0I/u/OUHjFSEg0SymzOW0dNf7x
         Cm/4p3E0WDKThGcDgJ79cdVtbNmYckiCnp4G6fgwQ9rXvYMm8eIuRkBIAzmsMD7wY8T7
         mIng==
X-Gm-Message-State: AAQBX9efDxIu/b1iWsoLSfyP4tCnK7V4fyVWyVo7iR6/0nOq917zE3Nl
        bAvO6Xhj9abOmH3motGXa0s=
X-Google-Smtp-Source: AKy350ZNTq/beLjyiUwHDgH8lCxSxWJAn1P72EB9rgrSOngKYZUMKh0tnAmSnf3KlDgt6iLI9T7tkw==
X-Received: by 2002:a05:6a20:47cf:b0:d5:3818:6427 with SMTP id ey15-20020a056a2047cf00b000d538186427mr1080718pzb.9.1680851319573;
        Fri, 07 Apr 2023 00:08:39 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id e9-20020a62ee09000000b006259e883ee9sm2340322pfi.189.2023.04.07.00.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 00:08:39 -0700 (PDT)
Message-ID: <dfc5cba8-5efb-8ad6-01e0-2800290a9ac1@gmail.com>
Date:   Fri, 7 Apr 2023 15:08:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH v4 11/12] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>
References: <20230214050757.9623-1-likexu@tencent.com>
 <20230214050757.9623-12-likexu@tencent.com> <ZC9zSjZ7A47v7VCD@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZC9zSjZ7A47v7VCD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/2023 9:35 am, Sean Christopherson wrote:
> On Tue, Feb 14, 2023, Like Xu wrote:
>> +	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
>> +		if (!msr_info->host_initiated)
>> +			return 0; /* Writes are ignored */
> 
> Where is the "writes ignored" behavior documented?  I can't find anything in the
> APM that defines write behavior.

KVM would follow the real hardware behavior once specifications stay silent on 
details or secret.

> 
>>   
>>   		pmu->global_status = data;
>>   		return 0;
>>   	case MSR_CORE_PERF_GLOBAL_CTRL:
>>   		if (!kvm_valid_perf_global_ctrl(pmu, data))
>>   			return 1;
>> -
>> +		fallthrough;
> 
> This _definitely_ needs a comment.  Hmm, and I would prefer to reverse these, i.e.
> 
> 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> 		data &= ~pmu->global_ctrl_mask;
> 		fallthrough;
> 	case MSR_CORE_PERF_GLOBAL_CTRL:
> 		if (!kvm_valid_perf_global_ctrl(pmu, data))
> 			return 1;
> 
> It's a bit arbitrary, but either Intel or AMD is going to end up with extra code,
> and IMO skipping a validity check is more alarming than skipping clearing of
> reserved bits, i.e. will look like a bug to future readers.
> 
>> +	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
>> +		data &= ~pmu->global_ctrl_mask;
>>   		if (pmu->global_ctrl != data) {
>>   			diff = pmu->global_ctrl ^ data;
>>   			pmu->global_ctrl = data;
>> @@ -616,7 +625,8 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
>>   		if (data & pmu->global_ovf_ctrl_mask)
>>   			return 1;
>> -
>> +		fallthrough;
> 
> Here too.  Argh, the APM doesn't actually define what happens on reserved bits,
> it just says "WO".  I vote to be conservative and ignore writes to reserved bits.
> And then we can have one comment for the whole block, e.g.
> 
> 	/*
> 	 * Note, AMD ignores writes to read-only PMU MSRs/bits, whereas Intel
> 	 * generates #GP on attempts to write reserved bits or RO MSRs.
> 	 */
> 	switch (msr) {
> 	case MSR_CORE_PERF_GLOBAL_STATUS:
> 		if (!msr_info->host_initiated)
> 			return 1; /* RO MSR */
> 		fallthrough;
> 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
> 		if (!msr_info->host_initiated)
> 			break;
> 
> 		pmu->global_status = data;
> 		break;
> 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
> 		data &= ~pmu->global_ctrl_mask;
> 		fallthrough;
> 	case MSR_CORE_PERF_GLOBAL_CTRL:
> 		if (!kvm_valid_perf_global_ctrl(pmu, data))
> 			return 1;
> 
> 		if (pmu->global_ctrl != data) {
> 			diff = pmu->global_ctrl ^ data;
> 			pmu->global_ctrl = data;
> 			reprogram_counters(pmu, diff);
> 		}
> 		break;
> 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
> 		fallthrough;
> 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> 		if (data & pmu->global_ovf_ctrl_mask)
> 			return 1;
> 
> 		if (!msr_info->host_initiated)
> 			pmu->global_status &= ~data;
> 		break;
> 	default:
> 		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
> 		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
> 	}
> 
> 	return 0;	

AMD doesn't generates #GP on attempts to write PMU RO MSRs and reserved bits.

How about this:

	/*
	 * Note, AMD ignores writes to reserved bits and read-only PMU MSRs,
	 * whereas Intel generates #GP on attempts to write reserved/RO MSRs.
	 */
	switch (msr) {
	case MSR_CORE_PERF_GLOBAL_STATUS:
		if (!msr_info->host_initiated || (data & pmu->global_ovf_ctrl_mask))
			return 1; /* RO MSR */
		fallthrough;
	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
		if (!msr_info->host_initiated)
			break;

		pmu->global_status = data;
		break;
	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
		data &= ~pmu->global_ctrl_mask;
		fallthrough;
	case MSR_CORE_PERF_GLOBAL_CTRL:
		if (!kvm_valid_perf_global_ctrl(pmu, data))
			return 1;

		if (pmu->global_ctrl != data) {
			diff = pmu->global_ctrl ^ data;
			pmu->global_ctrl = data;
			reprogram_counters(pmu, diff);
		}
		break;
	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
		if (data & pmu->global_ovf_ctrl_mask)
			return 1;
		fallthrough;
	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
		if (!msr_info->host_initiated)
			pmu->global_status &= ~data;
		break;
	default:
		kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
		return static_call(kvm_x86_pmu_set_msr)(vcpu, msr_info);
	}

	return 0;

> 
>> @@ -164,20 +181,34 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>>   {
>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct kvm_cpuid_entry2 *entry;
>> +	union cpuid_0x80000022_ebx ebx;
>>   
>> -	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
>> +	pmu->version = 1;
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
>> +		pmu->version = 2;
>> +		entry = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0);
> 
> No need for the intermediate "entry".
>> +		ebx.full = entry->ebx;
> 
> Oof, at first glance this looks like a potential null-pointer deref bug.  I
> believe we can do
> 
> 		/*
> 		 * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest
> 		 * CPUID entry is guaranteed to be non-NULL.
> 		 */
> 		BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
> 			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index != 0x80000022);

  x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);

> 		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;
> 
>> +		pmu->nr_arch_gp_counters = min_t(unsigned int,
>> +						 ebx.split.num_core_pmc,
>> +						 kvm_pmu_cap.num_counters_gp);
>> +	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
>>   		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
> 
> This needs to be sanitized, no?  E.g. if KVM only has access to 4 counters, but
> userspace sets X86_FEATURE_PERFCTR_CORE anyways.  Hrm, unless I'm missing something,
> that's a pre-existing bug.

Now your point is that if a user space more capbility than KVM can support, KVM 
should constrain it.
Your previous preference was that the user space can set capbilities that evene 
if KVM doesn't support
as long as it doesn't break KVM and host and the guest will eat its own.

> 
> If I'm right, can you add a patch to cap nr_arch_gp_counters at
> kvm_pmu_cap.num_counters_gp in the common flow, i.e. after this if-else block?
> Then there is no change needed in this patch, e.g. we'll naturally end up with:
> 
> 	union cpuid_0x80000022_ebx ebx;
> 
> 	pmu->version = 1;
> 	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
> 		pmu->version = 2;
> 		/*
>                   * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest
>                   * CPUID entry is guaranteed to be non-NULL.
>                   */
>                  BUILD_BUG_ON(x86_feature_cpuid(X86_FEATURE_PERFMON_V2).function != 0x80000022 ||
>                               x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);
> 		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;
> 		pmu->nr_arch_gp_counters = ebx.split.num_core_pmc;
> 	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
> 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
> 	} else {
> 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
> 	}
> 
> 	pmu->nr_arch_gp_counters = min_t(unsigned int,
> 					 pmu->nr_arch_gp_counters,
> 				       	 kvm_pmu_cap.num_counters_gp);
