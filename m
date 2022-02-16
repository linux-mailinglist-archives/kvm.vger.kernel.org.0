Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38D6B4B8194
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 08:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiBPHbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 02:31:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiBPHbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 02:31:14 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBF2D0B73;
        Tue, 15 Feb 2022 23:31:02 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id e17so1473637pfv.5;
        Tue, 15 Feb 2022 23:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=QO04mi9P51FCKMM2/J+pZrM97cQ38QT9y3ElCPNBoIU=;
        b=Krtl4kWCMaa1gpG+fVCvZCIctsIF8KiO6YsiP/PZ4FfvuqFNpp2gfhbHXS2+D1vmf0
         Jyfoa0AGYzOFBhdyi/aEgJ7ac7WR6LVYEkeNCbyuheUKFJGHNf7qqRZ9ytqz5AW0esYb
         tnqp2P1TFXL1u6sg+sMmx0JOnsJCm5mCr43mnYb1/zmSw5Xs9xD2EtInyAJkubOQqo1z
         yqLiuSC4ZwVMh3LIK62E2BOBWmPcvb+RSm8B4wOo29ww5j7P8ktLyQNDYkT4fmjCQRFb
         9n/yDtwzF4gumykY2dOSO+Z4j5DkWIXlir6mn2t606XK3KSahrGE/PMTxYChsAhLCkG2
         K5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=QO04mi9P51FCKMM2/J+pZrM97cQ38QT9y3ElCPNBoIU=;
        b=5vtEEW/BaeEOZGLqClNJyCpcbURWOgv+hfUtSGHf8LngsPQSkPp6tIoP7MCV/McNn3
         6x9Qs/KpvL7opJ80vgZg/byGeWaRbhGMCrfFBBNVVLG/H287di0b2xHD3rFVvVTfdeXH
         jHUeFwFTcMn9ghFphf+sHjfQXL/gT52+4ybWkg81CjkoMiy5QRT1FNTW6sUg5/IUyA9S
         mQGwjmFRIxbqxGEB3FRgO2BLbWvKVC9YXJDHL9Of9GtzinMn18s1waeJaApsejKiwtKb
         alB+YNepSDb0dC9bykA8eycYUdHiUC3vvG89AUwpWu8q/cLKLEKpDZDHVkKu7TBD7j7E
         Nzpg==
X-Gm-Message-State: AOAM532IHeNgjzet2Q+LVtF0+2WYS33z0QiklOb/2+yujfb+AhT9+fEJ
        c3Gm0lOrWtma1f8b4vG2XnI=
X-Google-Smtp-Source: ABdhPJwIRsEcqXMKzVOyLThBX92p4pM7DgDFeAIIYkSKAJNoLimBwAoIMmosMRyIkby+VsH/8c33kQ==
X-Received: by 2002:a05:6a00:26e0:b0:4e1:7131:de2b with SMTP id p32-20020a056a0026e000b004e17131de2bmr1828821pfw.20.1644996661875;
        Tue, 15 Feb 2022 23:31:01 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id c11sm43169808pfv.76.2022.02.15.23.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 23:31:01 -0800 (PST)
Message-ID: <ceb56bc2-e154-2e37-863c-b075ee174d5e@gmail.com>
Date:   Wed, 16 Feb 2022 15:30:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH kvm/queue v2 2/3] perf: x86/core: Add interface to query
 perfmon_event_map[] directly
Content-Language: en-US
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Dunn <daviddunn@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>
References: <20220117085307.93030-1-likexu@tencent.com>
 <20220117085307.93030-3-likexu@tencent.com>
 <20220202144308.GB20638@worktop.programming.kicks-ass.net>
 <CALMp9eRBOmwz=mspp0m5Q093K3rMUeAsF3vEL39MGV5Br9wEQQ@mail.gmail.com>
 <YgO/3usazae9rCEh@hirez.programming.kicks-ass.net>
 <69c0fc41-a5bd-fea9-43f6-4724368baf66@intel.com>
 <CALMp9eS=1U7T39L-vL_cTXTNN2Li8epjtAPoP_+Hwefe9d+teQ@mail.gmail.com>
 <67a731dd-53ba-0eb8-377f-9707e5c9be1b@intel.com>
 <CABOYuvbPL0DeEgV4gsC+v786xfBAo3T6+7XQr7cVVzbaoFoEAg@mail.gmail.com>
 <7b5012d8-6ae1-7cde-a381-e82685dfed4f@linux.intel.com>
 <CALMp9eTOaWxQPfdwMSAn-OYAHKPLcuCyse7BpsSOM35vg5d0Jg@mail.gmail.com>
 <e06db1a5-1b67-28ac-ee4c-34ece5857b1f@linux.intel.com>
 <CALMp9eSjDro169JjTXyCZn=Rf3PT0uHhdNXEifiXGYQK-Zn8LA@mail.gmail.com>
 <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <d86ba87b-d98a-53a0-b2cd-5bf77b97b592@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/2/2022 3:46 am, Liang, Kan wrote:
> 
> 
> On 2/10/2022 2:16 PM, Jim Mattson wrote:
>> On Thu, Feb 10, 2022 at 10:30 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>
>>>
>>>
>>> On 2/10/2022 11:34 AM, Jim Mattson wrote:
>>>> On Thu, Feb 10, 2022 at 7:34 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 2/9/2022 2:24 PM, David Dunn wrote:
>>>>>> Dave,
>>>>>>
>>>>>> In my opinion, the right policy depends on what the host owner and
>>>>>> guest owner are trying to achieve.
>>>>>>
>>>>>> If the PMU is being used to locate places where performance could be
>>>>>> improved in the system, there are two sub scenarios:
>>>>>>       - The host and guest are owned by same entity that is optimizing
>>>>>> overall system.  In this case, the guest doesn't need PMU access and
>>>>>> better information is provided by profiling the entire system from the
>>>>>> host.
>>>>>>       - The host and guest are owned by different entities.  In this
>>>>>> case, profiling from the host can identify perf issues in the guest.
>>>>>> But what action can be taken?  The host entity must communicate issues
>>>>>> back to the guest owner through some sort of out-of-band information
>>>>>> channel.  On the other hand, preempting the host PMU to give the guest
>>>>>> a fully functional PMU serves this use case well.
>>>>>>
>>>>>> TDX and SGX (outside of debug mode) strongly assume different
>>>>>> entities.  And Intel is doing this to reduce insight of the host into
>>>>>> guest operations.  So in my opinion, preemption makes sense.
>>>>>>
>>>>>> There are also scenarios where the host owner is trying to identify
>>>>>> systemwide impacts of guest actions.  For example, detecting memory
>>>>>> bandwidth consumption or split locks.  In this case, host control
>>>>>> without preemption is necessary.
>>>>>>
>>>>>> To address these various scenarios, it seems like the host needs to be
>>>>>> able to have policy control on whether it is willing to have the PMU
>>>>>> preempted by the guest.
>>>>>>
>>>>>> But I don't see what scenario is well served by the current situation
>>>>>> in KVM.  Currently the guest will either be told it has no PMU (which
>>>>>> is fine) or that it has full control of a PMU.  If the guest is told
>>>>>> it has full control of the PMU, it actually doesn't.  But instead of
>>>>>> losing counters on well defined events (from the guest perspective),
>>>>>> they simply stop counting depending on what the host is doing with the
>>>>>> PMU.
>>>>>
>>>>> For the current perf subsystem, a PMU should be shared among different
>>>>> users via the multiplexing mechanism if the resource is limited. No one
>>>>> has full control of a PMU for lifetime. A user can only have the PMU in
>>>>> its given period. I think the user can understand how long it runs via
>>>>> total_time_enabled and total_time_running.
>>>>
>>>> For most clients, yes. For kvm, no. KVM currently tosses
>>>> total_time_enabled and total_time_running in the bitbucket. It could
>>>> extrapolate, but that would result in loss of precision. Some guest
>>>> uses of the PMU would not be able to cope (e.g.
>>>> https://github.com/rr-debugger/rr).
>>>>
>>>>> For a guest, it should rely on the host to tell whether the PMU resource
>>>>> is available. But unfortunately, I don't think we have such a
>>>>> notification mechanism in KVM. The guest has the wrong impression that
>>>>> the guest can have full control of the PMU.
>>>>
>>>> That is the only impression that the architectural specification
>>>> allows the guest to have. On Intel, we can mask off individual fixed
>>>> counters, and we can reduce the number of GP counters, but AMD offers
>>>> us no such freedom. Whatever resources we advertise to the guest must

The future may look a little better, with more and more server
hardware being designed with virtualization requirement in mind.

>>>> be available for its use whenever it wants. Otherwise, PMU
>>>> virtualization is simply broken.

YES for "simply broken" but no for "available whenever it wants"
If there is no host (core) pmu user, the guest pmu is fully and architecturally 
available.

If there is no perf agent on host (like watchdog),
current guest pmu is working fine except for some emulated instructions.

>>>>
>>>>> In my opinion, we should add the notification mechanism in KVM. When the
>>>>> PMU resource is limited, the guest can know whether it's multiplexing or
>>>>> can choose to reschedule the event.

Eventually, we moved the topic to an open discussion and I am relieved.

The total_time_enabled and total_time_running of the perf_events
created by KVM are quite unreliable and invisible to the guest, and
we may need to clearly define what they reallt mean, for example
when profiling the SGX applications.

The elephant in the vPMU room at the moment is that the guest has
no way of knowing if the physical pmc on the back end of the vPMC
is being multiplexed, even though the KVM is able to know.

One way to mitigate this is to allow perf to not apply a multiplexing
policy (sys knob), for example with a first-come, first-served policy.
In this case, each user of the same priority of PMC is fair, and KVM
goes first to request hardware when the guest uses vPMC, or requests
re-sched to another pCPU, and only fails in the worst case.

>>>>
>>>> That sounds like a paravirtual perf mechanism, rather than PMU
>>>> virtualization. Are you suggesting that we not try to virtualize the
>>>> PMU? Unfortunately, PMU virtualization is what we have customers
>>>> clamoring for. No one is interested in a paravirtual perf mechanism.
>>>> For example, when will VTune in the guest know how to use your
>>>> proposed paravirtual interface?
>>>
>>> OK. If KVM cannot notify the guest, maybe guest can query the usage of
>>> counters before using a counter. There is a IA32_PERF_GLOBAL_INUSE MSR
>>> introduced with Arch perfmon v4. The MSR provides an "InUse" bit for
>>> each counters. But it cannot guarantee that the counter can always be
>>> owned by the guest unless the host treats the guest as a super-user and
>>> agrees to not touch its counter. This should only works for the Intel
>>> platforms.
>>
>> Simple question: Do all existing guests (Windows and Linux are my
>> primary interest) query that MSR today? If not, then this proposal is
>> DOA.
>>
> 
> No, we don't, at least for Linux. Because the host own everything. It doesn't 
> need the MSR to tell which one is in use. We track it in an SW way.

Indeed, "the host own everything", which is also the
starting point for the host perf when it received the changes.

> 
> For the new request from the guest to own a counter, I guess maybe it is worth 
> implementing it. But yes, the existing/legacy guest never check the MSR.

We probably need an X86 generic notification solution for the worst case.

> 
> 
>>>>
>>>>> But seems the notification mechanism may not work for TDX case?

Shared memory can be used for communication between the host and
the guest, if it's allowed by the TDX guest.

>>>>>>
>>>>>> On the other hand, if we flip it around the semantics are more clear.
>>>>>> A guest will be told it has no PMU (which is fine) or that it has full
>>>>>> control of the PMU.  If the guest is told that it has full control of
>>>>>> the PMU, it does.  And the host (which is the thing that granted the
>>>>>> full PMU to the guest) knows that events inside the guest are not
>>>>>> being measured.  This results in all entities seeing something that
>>>>>> can be reasoned about from their perspective.
>>>>>>
>>>>>
>>>>> I assume that this is for the TDX case (where the notification mechanism
>>>>>     doesn't work). The host still control all the PMU resources. The TDX
>>>>> guest is treated as a super-user who can 'own' a PMU. The admin in the
>>>>> host can configure/change the owned PMUs of the TDX. Personally, I think
>>>>> it makes sense. But please keep in mind that the counters are not
>>>>> identical. There are some special events that can only run on a specific
>>>>> counter. If the special counter is assigned to TDX, other entities can
>>>>> never run some events. We should let other entities know if it happens.
>>>>> Or we should never let non-host entities own the special counter.
>>>>
>>>> Right; the counters are not fungible. Ideally, when the guest requests
>>>> a particular counter, that is the counter it gets. If it is given a
>>>> different counter, the counter it is given must provide the same
>>>> behavior as the requested counter for the event in question.
>>>
>>> Ideally, Yes, but sometimes KVM/host may not know whether they can use
>>> another counter to replace the requested counter, because KVM/host
>>> cannot retrieve the event constraint information from guest.
>>
>> In that case, don't do it. When the guest asks for a specific counter,
>> give the guest that counter. This isn't rocket science.
>>
> 
> Sounds like the guest can own everything if they want. Maybe it makes sense from 
> the virtualization's perspective. But it sounds too aggressive to me. :)

Until Perterz changes his will, upstream may not see this kind of change.
(I actually used to like this design too).

> 
> Thanks,
> Kan
> 
> 
>>> For example, we have Precise Distribution (PDist) feature enabled only
>>> for the GP counter 0 on SPR. Perf uses the precise_level 3 (a SW
>>> variable) to indicate the feature. For the KVM/host, they never know
>>> whether the guest apply the PDist feature.

Yes, just check what we did on PEBS, which is Acked-by PeterZ.

>>>
>>> I have a patch that forces the perf scheduler starts from the regular
>>> counters, which may mitigates the issue, but cannot fix it. (I will post
>>> the patch separately.)
>>>
>>> Or we should never let the guest own the special counters. Although the
>>> guest has to lose some special events, I guess the host may more likely
>>> be willing to let the guest own a regular counter.

AMD seems to do this, but it's just another disable-pmu compromise.

>>>
>>>
>>> Thanks,
>>> Kan
>>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Kan
>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Dave Dunn
>>>>>>
>>>>>> On Wed, Feb 9, 2022 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:
>>>>>>
>>>>>>>> I was referring to gaps in the collection of data that the host perf
>>>>>>>> subsystem doesn't know about if ATTRIBUTES.PERFMON is set for a TDX
>>>>>>>> guest. This can potentially be a problem if someone is trying to
>>>>>>>> measure events per unit of time.
>>>>>>>
>>>>>>> Ahh, that makes sense.
>>>>>>>
>>>>>>> Does SGX cause problem for these people?  It can create some of the same
>>>>>>> collection gaps:
>>>>>>>
>>>>>>>            performance monitoring activities are suppressed when entering
>>>>>>>            an opt-out (of performance monitoring) enclave.
