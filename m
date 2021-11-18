Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9254C4557CD
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 10:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245062AbhKRJRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 04:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbhKRJRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 04:17:10 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCC4C061200;
        Thu, 18 Nov 2021 01:14:10 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 136so4849250pgc.0;
        Thu, 18 Nov 2021 01:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=3s8G0Xd/9x2hLp5GIKxUiDxtVxH8VbvhOU5LzwFcfIU=;
        b=AUZmQoTK9YnO08scdYdulngxYtgBzkai8M98aX0mM7wElb/PN/BM18ZVNdnhfrIK0W
         gCwjaGDWESUm0KoIs34T1qyH5tzSv3EIDBZPB/LIqhI8tIsjCw99uA2nzugbWlY2Uk9L
         TMYOH6/QMdmT2ve4Z9fXe6nYoemZ/ofX/mpChHAspII6j655E5+SesLCvrbOfw0IKMNl
         mcYtpfkHlc8PvkcXv1C3yxsyAzucX+f389bbkb4tDEdw50jcVeGiO2UDmYrBy/vQXwZB
         FoZCRG/k12b/ZH7hl6LpYk60o3laxTbnjMLmjwyqPyzrnr/mJRRhrd3mevXrHpD0J6IJ
         Tf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=3s8G0Xd/9x2hLp5GIKxUiDxtVxH8VbvhOU5LzwFcfIU=;
        b=TNL8ydt/BToW7RZDv7bvLslRhh6jy6Kc7lB1qLwcoLthWK92iyJd5Kw9RcxtwLfX2X
         naqiI8qKxe/+3Z0evavby4cA5JPKqOIU3u4TlpIFB0tA8CEjqK2SjCeviRsM/L0q/1hH
         g3NdG3N6f1w8wSVlfcd5kU1qIuGtsnZxZ2kmeCF/DdV4bFPQvR0ZxGd/E/yXGx5zSjrZ
         CX26pLnhXwRDahUKjMT+9qu4fOI76yPnja2W/xw+QwRpURxckg5p1uUiyDkRUY0v3du7
         aVYyBx6YliUtLexZI2JSWWt+F6mdgVTrI/5LXsqFlXjWE12ykVQk9j61zla879aZkJhl
         ylSQ==
X-Gm-Message-State: AOAM532p0im2jUwh57UYi+9/bjPlyixWBk/aTQDRByNB+ltPQk6ykbx2
        BpaqfYnefBhDAruyl6491Cs=
X-Google-Smtp-Source: ABdhPJwrchPlEzopuP/0g5KsAcWXAg2R16ip/wL/2jr2g76hGiiYLrzve8MGvqYBKKhQX10id4e4qQ==
X-Received: by 2002:a63:6c44:: with SMTP id h65mr10321820pgc.423.1637226847280;
        Thu, 18 Nov 2021 01:14:07 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z22sm2598124pfe.93.2021.11.18.01.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 01:14:06 -0800 (PST)
Message-ID: <19868ec5-75f4-0ca5-71f7-cc12d135335d@gmail.com>
Date:   Thu, 18 Nov 2021 17:13:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org)" 
        <pbonzini@redhat.com>, Eric Hankland <ehankland@google.com>,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra (Intel OTC, Netherlander)" <peterz@infradead.org>
References: <20211112235235.1125060-1-jmattson@google.com>
 <20211112235235.1125060-2-jmattson@google.com>
 <fcb9aea5-2cf5-897f-5a3d-054ead555da4@gmail.com>
 <CALMp9eR5oi=ZrrEsZpcAJ7AP-Jo2cLGz9GA=SoTjX--TiG4=sw@mail.gmail.com>
 <afb108ed-a2f3-cb49-d0b4-b1bd6739cdb6@gmail.com>
 <CALMp9eSYvGW=EfuDCyc+fu7gVNnKHmEvFMackYcuZ-sGT8H5uA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: [PATCH 1/2] KVM: x86: Update vPMCs when retiring instructions
In-Reply-To: <CALMp9eSYvGW=EfuDCyc+fu7gVNnKHmEvFMackYcuZ-sGT8H5uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/11/2021 4:01 am, Jim Mattson wrote:
> On Tue, Nov 16, 2021 at 7:22 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>> On 17/11/2021 6:15 am, Jim Mattson wrote:
>>> On Tue, Nov 16, 2021 at 4:44 AM Like Xu <like.xu.linux@gmail.com> wrote:
>>>>
>>>> Hi Jim,
>>>>
>>>> On 13/11/2021 7:52 am, Jim Mattson wrote:
>>>>> When KVM retires a guest instruction through emulation, increment any
>>>>> vPMCs that are configured to monitor "instructions retired," and
>>>>> update the sample period of those counters so that they will overflow
>>>>> at the right time.
>>>>>
>>>>> Signed-off-by: Eric Hankland <ehankland@google.com>
>>>>> [jmattson:
>>>>>      - Split the code to increment "branch instructions retired" into a
>>>>>        separate commit.
>>>>>      - Added 'static' to kvm_pmu_incr_counter() definition.
>>>>>      - Modified kvm_pmu_incr_counter() to check pmc->perf_event->state ==
>>>>>        PERF_EVENT_STATE_ACTIVE.
>>>>> ]
>>>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>>>> Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
>>>>> ---
>>>>>     arch/x86/kvm/pmu.c | 31 +++++++++++++++++++++++++++++++
>>>>>     arch/x86/kvm/pmu.h |  1 +
>>>>>     arch/x86/kvm/x86.c |  3 +++
>>>>>     3 files changed, 35 insertions(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
>>>>> index 09873f6488f7..153c488032a5 100644
>>>>> --- a/arch/x86/kvm/pmu.c
>>>>> +++ b/arch/x86/kvm/pmu.c
>>>>> @@ -490,6 +490,37 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>>>>>         kvm_pmu_reset(vcpu);
>>>>>     }
>>>>>
>>>>> +static void kvm_pmu_incr_counter(struct kvm_pmc *pmc, u64 evt)
>>>>> +{
>>>>> +     u64 counter_value, sample_period;
>>>>> +
>>>>> +     if (pmc->perf_event &&
>>>>
>>>> We need to incr pmc->counter whether it has a perf_event or not.
>>>>
>>>>> +         pmc->perf_event->attr.type == PERF_TYPE_HARDWARE &&
>>>>
>>>> We need to cover PERF_TYPE_RAW as well, for example,
>>>> it has the basic bits for "{ 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },"
>>>> plus HSW_IN_TX or ARCH_PERFMON_EVENTSEL_EDGE stuff.
>>>>
>>>> We just need to focus on checking the select and umask bits:
>>>
>>> [What follows applies only to Intel CPUs. I haven't looked at AMD's
>>> PMU implementation yet.]
>>
>> x86 has the same bit definition and semantics on at least the select and umask bits.
> 
> Yes, but AMD supports 12 bits of event selector. AMD also has the
> HG_ONLY bits, which affect whether or not to count the event based on
> context.

You're right, "EVENT_SELECT[11:8] (Event Select): read/write.
This field extends the EVENT_SELECT field from 8 bits to 12 bits."

But as a legacy way, we're using amd_event_mapping[]
(which checking the shared select and umask bits) to
get the two generalized performance event
"instructions retired" and "branch instructions retired".

So we may insist on checking x86 shared 16-bits and comment the risk from extra 
4 bits.

We may not support HG_ONLY bit in the KVM world (df51fe7ea1c1).

> 
>>>
>>> Looking at the SDM, volume 3, Figure 18-1: Layout of IA32_PERFEVTSELx
>>> MSRs, there seems to be a lot of complexity here, actually. In
>>
>> The devil is in the details.
>>
>>> addition to checking for the desired event select and unit mask, it
>>> looks like we need to check the following:
>>>
>>> 1. The EN bit is set.
>>
>> We need to cover the EN bit of fixed counter 0 for HW_INSTRUCTIONS.
> 
> I don't know what you mean by that.

The four fixed ctrl bits for fixed counter 0 should be consulted as well.

> 
>>> 2. The CMASK field is 0 (for events that can only happen once per cycle).
>>> 3. The E bit is clear (maybe?).
>>
>> The "Edge detect" bit is about hw detail and let's ignore it.
> 
>   From my reading of the SDM, I don't think the edge detect bit can be
> ignored, but I will do some empirical tests to convince myself when I
> get back from vacation.

Sorry to bother you on vacation.

I assume turning edge detection on or off causes certain event
to occur depending on the HW implementation.

Can we trap the edge status of an emulated instruction ?

> 
>>> 4. The OS bit is set if the guest is running at CPL0.
>>> 5. The USR bit is set if the guest is running at CPL>0.
>>
>> CPL is a necessity.
>>
> 
> As is host/guest mode on AMD.
> 
>>>
>>>
>>>> static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
>>>>           unsigned int perf_hw_id)
>>>> {
>>>>           u64 old_eventsel = pmc->eventsel;
>>>>           unsigned int config;
>>>>
>>>>           pmc->eventsel &=
>>>>                   (ARCH_PERFMON_EVENTSEL_EVENT | ARCH_PERFMON_EVENTSEL_UMASK);
>>>>           config = kvm_x86_ops.pmu_ops->find_perf_hw_id(pmc);
>>>>           pmc->eventsel = old_eventsel;
>>>>           return config == perf_hw_id;
>>>> }
>>
>> My proposal is to incr counter as long as the select and mask bits match the
>> generi event.
>>
>> What do you think?
>>
>>>>
>>>>> +         pmc->perf_event->state == PERF_EVENT_STATE_ACTIVE &&
>>>>
>>>> Again, we should not care the pmc->perf_event.
>>>
>>> This test was intended as a proxy for checking that the counter is
>>> enabled in the guest's IA32_PERF_GLOBAL_CTRL MSR.
>>
>> The two are not equivalent.
> 
> Yes. I'm getting that now.
> 
>> A enabled counter means true from "pmc_is_enabled(pmc)  &&
>> pmc_speculative_in_use(pmc)".
>> A well-emulated counter means true from "perf_event->state ==
>> PERF_EVENT_STATE_ACTIVE".
>>
>> A bad-emulated but enabled counter should be incremented for emulated instructions.
> 
> What is a "bad-emulated" counter?

When pmc->perf_event is not created or not scheduled by the host perf scheduler.

> 
>>>
>>>>> +         pmc->perf_event->attr.config == evt) {
>>>>
>>>> So how about the emulated instructions for
>>>> ARCH_PERFMON_EVENTSEL_USR and ARCH_PERFMON_EVENTSEL_USR ?
>>>
>>> I assume you're referring to the OS and USR bits of the corresponding
>>> IA32_PERFEVTSELx MSR. I agree that these bits have to be consulted,
>>> along with guest privilege level, before deciding whether or not to
>>> count the event.
>>
>> Thanks and we may need update the testcase as well.
> 
> Indeed.
> 
>>>
>>>>> +             pmc->counter++;
>>>>> +             counter_value = pmc_read_counter(pmc);
>>>>> +             sample_period = get_sample_period(pmc, counter_value);
>>>>> +             if (!counter_value)
>>>>> +                     perf_event_overflow(pmc->perf_event, NULL, NULL);
>>>>
>>>> We need to call kvm_perf_overflow() or kvm_perf_overflow_intr().
>>>> And the patch set doesn't export the perf_event_overflow() SYMBOL.
>>>
>>> Oops. I was compiling with kvm built into vmlinux, so I missed this.
>>
>> In fact, I don't think the perf code would accept such rude symbolic export
>> And I do propose to apply kvm_pmu_incr_counter() in a less invasive way.
>>
>>>
>>>>> +             if (local64_read(&pmc->perf_event->hw.period_left) >
>>>>> +                 sample_period)
>>>>> +                     perf_event_period(pmc->perf_event, sample_period);
>>>>> +     }
>>>>> +}
>>>>
>>>> Not cc PeterZ or perf reviewers for this part of code is not a good thing.
>>>
>>> Added.
>>>
>>>> How about this:
>>>>
>>>> static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
>>>> {
>>>>           struct kvm_pmu *pmu = pmc_to_pmu(pmc);
>>>>
>>>>           pmc->counter++;
>>>>           reprogram_counter(pmu, pmc->idx);
>>>>           if (!pmc_read_counter(pmc))
>>>>                   // https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/T/#t
>>>>                   kvm_pmu_counter_overflow(pmc, need_overflow_intr(pmc));
>>>> }
>>>>
>>>>> +
>>>>> +void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt)
>>>>
>>>> s/kvm_pmu_record_event/kvm_pmu_trigger_event/
>>>>
>>>>> +{
>>>>> +     struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>>>> +     int i;
>>>>> +
>>>>> +     for (i = 0; i < pmu->nr_arch_gp_counters; i++)
>>>>> +             kvm_pmu_incr_counter(&pmu->gp_counters[i], evt);
>>>>
>>>> Why do we need to accumulate a counter that is not enabled at all ?
>>>
>>> In the original code, the condition checked in kmu_pmu_incr_counter()
>>> was intended to filter out disabled counters.
>>
>> The bar of code review haven't been lowered, eh?
> 
> I have no idea what you mean. If anything, I'd like the bar for both
> review and acceptance to be higher than it is today. No one was more
> surprised than I was when Paolo accepted these patches so quickly.

Personally, I have great sympathy for the maintainers who are always overworked.

Surely, we need more eyes on all corners of the KVM code. At least I may offer a 
little help.

> 
>>>
>>>>> +     for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
>>>>> +             kvm_pmu_incr_counter(&pmu->fixed_counters[i], evt);
>>>>
>>>> How about this:
>>>>
>>>>           for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
>>>>                   pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
>>>>
>>>>                   if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
>>>>                           continue;
>>>>
>>>>                   // https://lore.kernel.org/kvm/20211116122030.4698-1-likexu@tencent.com/T/#t
>>>>                   if (eventsel_match_perf_hw_id(pmc, perf_hw_id))
>>>>                           kvm_pmu_incr_counter(pmc);
>>>>           }
>>>>
>>>
>>> Let me expand the list of reviewers and come back with v2 after I
>>> collect more input.
>>
>> I'm not sure Paolo will revert the "Queued both" decision,
>> but I'm not taking my eyes or hands off the vPMU code.
> 
> I'm going on vacation for a couple of weeks. If Paolo doesn't want to
> revert the buggy submissions from kvm-queue, then I will gladly defer
> to you as the self-declared warden of the vPMU code to fix it as you
> see fit.
> 

Sorry to disturb you before a wonderful holiday.

It looks we committed the test case and reverted this patch set.
Please let me know if you need me to take over for a V2 w/ your SOBs.

> Thanks!
> 
> --jim
> 
>>>
>>> Thanks!
>>>
>>>
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(kvm_pmu_record_event);
>>>>> +
>>>>>     int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>>>>>     {
>>>>>         struct kvm_pmu_event_filter tmp, *filter;
>>>>> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
>>>>> index 59d6b76203d5..d1dd2294f8fb 100644
>>>>> --- a/arch/x86/kvm/pmu.h
>>>>> +++ b/arch/x86/kvm/pmu.h
>>>>> @@ -159,6 +159,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
>>>>>     void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
>>>>>     void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
>>>>>     int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
>>>>> +void kvm_pmu_record_event(struct kvm_vcpu *vcpu, u64 evt);
>>>>>
>>>>>     bool is_vmware_backdoor_pmc(u32 pmc_idx);
>>>>>
>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>> index d7def720227d..bd49e2a204d5 100644
>>>>> --- a/arch/x86/kvm/x86.c
>>>>> +++ b/arch/x86/kvm/x86.c
>>>>> @@ -7854,6 +7854,8 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>>>>>         if (unlikely(!r))
>>>>>                 return 0;
>>>>>
>>>>> +     kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
>>>>> +
>>>>>         /*
>>>>>          * rflags is the old, "raw" value of the flags.  The new value has
>>>>>          * not been saved yet.
>>>>> @@ -8101,6 +8103,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>>>>                 vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
>>>>>                 if (!ctxt->have_exception ||
>>>>>                     exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
>>>>> +                     kvm_pmu_record_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
>>>>>                         kvm_rip_write(vcpu, ctxt->eip);
>>>>>                         if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
>>>>>                                 r = kvm_vcpu_do_singlestep(vcpu);
>>>>>
>>>
> 
