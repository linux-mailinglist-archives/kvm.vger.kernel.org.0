Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8866B6DC644
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 13:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjDJLeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 07:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjDJLeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 07:34:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BB34492;
        Mon, 10 Apr 2023 04:34:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q15-20020a17090a2dcf00b0023efab0e3bfso7044733pjm.3;
        Mon, 10 Apr 2023 04:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681126461; x=1683718461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a44B/CX+FgveEhRcaZEETjS/PV7FJimxs+FqfK6ZGxw=;
        b=qrqNjIvR1mQllP9K4SkBfGAo5WTboewRyFy2jRCpifWuqQQ9Cn+EuS+HiCtQ+GTAr7
         Ai9x035DtGU1U7LQ/6AMEEZfOJJWzM5OJ4sNXDST7DXoXHGDNhHIsp5BbnhAWsUqy70g
         OlnKOwvp1nRkBdZ+qAW3qYkBBwq8n/0bZ8aQfPDhrxl2P7NdRkRv4ds/E/8vktAEjv6K
         XIujlTT7Z4AZUim3qMBzXTdXvvOV2MyfPnr+o6FIi2uleIhUn2S7lBvsTR88i8xsuITq
         Ao3KBcLKPI3hW02fXhL/HNyQUXpP0qS0X6XUR1DSEpp+qp2mliQbGkNMWyctwEm4WkJw
         7AOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681126461; x=1683718461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a44B/CX+FgveEhRcaZEETjS/PV7FJimxs+FqfK6ZGxw=;
        b=VYN3wRbbjPsUfrBEvVN+mqRLr6wJAE+kkpDWNEymBHqZm547YAnTa88isgjKKEMw7h
         k43ZxMvOKjj4J5c7hPrnhEKOlV2mOurZhODZPjBnFZXFYmVa9vUQb96UhdudM43Le2K/
         weCoLov3KV6J9yuAx7VKKylLuzUvRbBnST6FsTuw5J4CZ0RHVbwOfU785QX/rYng6vTt
         n1RJoN76xpO3fb/rfjYCbwRy4Dc6DWr3mXW7aWBgFgO1vLgqEYxtt8EwwFatJkMNW7TT
         HG9GiYg2GH82ViBrVqbGaMRYAsfNykwZD5NmYtx/4NyAXKhEya62vLUfE5kKHfxdh3X1
         0T5g==
X-Gm-Message-State: AAQBX9cmcfkw5JNsm3PsluMKWOL6Nfhapx2rE4iSu6AM95gV6iqvAVuh
        ooOzarZ7ZkZa74apNKJNmLs=
X-Google-Smtp-Source: AKy350YIwbZsbdy896bKNiY9tQAttqMPqfII5QTqVhG8Cm9kRWA6QI+Zlu0YUZ0iYAXu2EODC8k45Q==
X-Received: by 2002:a17:90b:350c:b0:246:bb31:e835 with SMTP id ls12-20020a17090b350c00b00246bb31e835mr1480202pjb.15.1681126460788;
        Mon, 10 Apr 2023 04:34:20 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v3-20020a17090aaf0300b0023f685f7914sm9113115pjq.49.2023.04.10.04.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 04:34:20 -0700 (PDT)
Message-ID: <dd7fa8c8-a141-d036-d3e2-826f90eb97a9@gmail.com>
Date:   Mon, 10 Apr 2023 19:34:12 +0800
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
 <dfc5cba8-5efb-8ad6-01e0-2800290a9ac1@gmail.com>
 <ZDAsaXvx85x+n71S@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZDAsaXvx85x+n71S@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/2023 10:44 pm, Sean Christopherson wrote:
> On Fri, Apr 07, 2023, Like Xu wrote:
>> On 7/4/2023 9:35 am, Sean Christopherson wrote:
>>> On Tue, Feb 14, 2023, Like Xu wrote:
>>>> +	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
>>>> +		if (!msr_info->host_initiated)
>>>> +			return 0; /* Writes are ignored */
>>>
>>> Where is the "writes ignored" behavior documented?  I can't find anything in the
>>> APM that defines write behavior.
>>
>> KVM would follow the real hardware behavior once specifications stay silent
>> on details or secret.
> 
> So is that a "this isn't actually documented anywhere" answer?  It's not your
> responsibility to get AMD to document their CPUs, but I want to clearly document
> when KVM's behavior is based solely off of observed hardware behavior, versus an
> actual specification.

Indeed, you draw a clearer line than APM or PPR.

Spec-defined:

	RO: Read-only. Readable; writes are ignored (Per PPR "AccessType Definitions")
	WO: Writable. Reads are undefined. (Per PPR "AccessType Definitions")

And vPMU will refer to real HW observations for the (hidden) undefined behaviour.
More comments in the new version may help. Please check.

> 
>> How about this:
>>
>> 	/*
>> 	 * Note, AMD ignores writes to reserved bits and read-only PMU MSRs,
>> 	 * whereas Intel generates #GP on attempts to write reserved/RO MSRs.
>> 	 */
> 
> Looks good.
> 
>>>> +		pmu->nr_arch_gp_counters = min_t(unsigned int,
>>>> +						 ebx.split.num_core_pmc,
>>>> +						 kvm_pmu_cap.num_counters_gp);
>>>> +	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
>>>>    		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
>>>
>>> This needs to be sanitized, no?  E.g. if KVM only has access to 4 counters, but
>>> userspace sets X86_FEATURE_PERFCTR_CORE anyways.  Hrm, unless I'm missing something,
>>> that's a pre-existing bug.
>>
>> Now your point is that if a user space more capbility than KVM can support,
>> KVM should constrain it.
>> Your previous preference was that the user space can set capbilities that
>> evene if KVM doesn't support as long as it doesn't break KVM and host and the
>> guest will eat its own.
> 
> Letting userspace define a "bad" configuration is perfectly ok, but KVM needs to
> be careful not to endanger itself by consuming the bad state.  A good example is
> the handling of nested SVM features in svm_vcpu_after_set_cpuid().  KVM lets
> userspace define anything and everything, but KVM only actually tries to utilize
> a feature if the feature is actually supported in hardware.
> 
> In this case, it's not clear to me that putting a bogus value into "nr_arch_gp_counters"
> is safe (for KVM).  And AIUI, the guest can't actually use more than
> kvm_pmu_cap.num_counters_gp counters, i.e. KVM isn't arbitrarily restricting the
> setup.

AFAI,  when a guest has more counters (N) than the host (M), and they are all 
enabled,
thus KVM will create an equal number (N) of perf_events, and these events will 
occupy
real hardware counters (M) in the host perf scheduler subsystem in a round robin 
way.

 From the point of view of a vCPU, its virtual counters can only occupy the hardware
part of the time slice to count for guest payload, which affects the accuracy. 
However,
from the host security point of view, too many counters will only result in too many
perf_events created by KVM, which is a normal usage for the perf subsystem, called
perf counter multiplexing. It seems to be safe (using perf API for KVM).

But considering that scheduling too many perf_events is also a performance overhead,
it can also be seen as a performance attack on the scheduling of vCPU processes 
on host.

Back to the diff itself, code for intel_pmu does a similar sanity check, thus 
here we just
let AMD_PMU follow the same decision pattern. Please refer to the latest version.
