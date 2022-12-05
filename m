Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20E36429C6
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 14:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiLENoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 08:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbiLENnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 08:43:46 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6AC1D669
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 05:43:14 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id o5so18666592wrm.1
        for <kvm@vger.kernel.org>; Mon, 05 Dec 2022 05:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PSfDwZPeG8ibIdq5sbKvkL1VsqUlUscnguEB5oSOxSc=;
        b=ZhFQOk5sHEFKzbm8fBjTNTecUMb6srGFq09hOHXW6kISqLW8gBDE3jNN0izPXaaE3X
         DVOXi2YDNUqfzOv8xB3pFAgcYIuK1FmRV4esx3+KJ3cyZFEiVKFzu7NPXpA2+JEoADaD
         13amI67POzIZYrUkAoNZH8B4OE4iZiDvYqvAJYQnER8FK5PwsZr6ShoWEvnTLGky3x/A
         HhQd1huG4wKL1p1O37IhT2z73k7GLly9/OUH08rQU99hjNPkV9UzyOOqX2HNMEd3rXei
         1tFaqBk4u8sgKKmkYUA8ncwGRbe6Jl7fYsJpJVyDCV6HGhhlyfUEgS5LpfZztLytNEiy
         wlog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PSfDwZPeG8ibIdq5sbKvkL1VsqUlUscnguEB5oSOxSc=;
        b=orxaqOv/9R9e3rjAW6qRg/Iw1xDqMd5Dn/xn9LR9BP051Pk02qlKvVRbhQc8SxM5/u
         PDShZ68CGp5uQJwJUMUvQ75ZLXeythMm8XCRny8tVR6KA+dMN2kChqrdzYZJNkhrexWx
         WLaGUlwgAJsgpfnDy/4UvAJL1U/h6/LLzsA/OZZhgs9TOP6KhtEvx5jdW1nZNY/ehLk+
         Qv/ow/0VfIGy0azNR4a/+cYN2BIbHcijzyJV/3WkrDK7bWZZ4Fpwh3crU6/EB5LJzX+e
         8uTUpH+mpKG3p0rHmYeXNSrYlEvU7bwiHM35flBivtlxUOx2vazpLhMgaDPlt8Hc/2cQ
         kzSg==
X-Gm-Message-State: ANoB5pnj8guCJmnbHFsQwlVfYPfRg1xVrkHO87zo2oprkzT0u5082F1t
        aqYQMYkfI4JCIJ28FmlAoHtsuw==
X-Google-Smtp-Source: AA0mqf68CFsZMOCd88AhAlMizn4w9UrnERv3KIachtaDvBlHTCAHLOEwLF5Gb8KkdqSMJF8Id58Pag==
X-Received: by 2002:a5d:6e8e:0:b0:236:5e77:b58e with SMTP id k14-20020a5d6e8e000000b002365e77b58emr44809235wrz.320.1670247793408;
        Mon, 05 Dec 2022 05:43:13 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4bd:0:4759:d90c:43ca:e8f0? ([2a02:6b6a:b4bd:0:4759:d90c:43ca:e8f0])
        by smtp.gmail.com with ESMTPSA id n3-20020a05600c3b8300b003cfbbd54178sm28603622wms.2.2022.12.05.05.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 05:43:12 -0800 (PST)
Message-ID: <66bc7368-aabc-9ec3-f4ba-a3bbeed5938b@bytedance.com>
Date:   Mon, 5 Dec 2022 13:43:12 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted
 check
Content-Language: en-US
From:   Usama Arif <usama.arif@bytedance.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        steven.price@arm.com, mark.rutland@arm.com, bagasdotme@gmail.com,
        fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
 <87k048f3cm.wl-maz@kernel.org>
 <180b91af-a2aa-2cfd-eb7f-b2825c4e3dbe@bytedance.com>
 <86r0y1nmep.wl-maz@kernel.org>
 <95efd030-27f6-5668-a25e-9fbf210bfa1c@bytedance.com>
In-Reply-To: <95efd030-27f6-5668-a25e-9fbf210bfa1c@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24/11/2022 13:55, Usama Arif wrote:
> 
> 
> On 18/11/2022 00:20, Marc Zyngier wrote:
>> On Mon, 07 Nov 2022 12:00:44 +0000,
>> Usama Arif <usama.arif@bytedance.com> wrote:
>>>
>>>
>>>
>>> On 06/11/2022 16:35, Marc Zyngier wrote:
>>>> On Fri, 04 Nov 2022 06:20:59 +0000,
>>>> Usama Arif <usama.arif@bytedance.com> wrote:
>>>>>
>>>>> This patchset adds support for vcpu_is_preempted in arm64, which
>>>>> allows the guest to check if a vcpu was scheduled out, which is
>>>>> useful to know incase it was holding a lock. vcpu_is_preempted can
>>>>> be used to improve performance in locking (see owner_on_cpu usage in
>>>>> mutex_spin_on_owner, mutex_can_spin_on_owner, rtmutex_spin_on_owner
>>>>> and osq_lock) and scheduling (see available_idle_cpu which is used
>>>>> in several places in kernel/sched/fair.c for e.g. in wake_affine to
>>>>> determine which CPU can run soonest):
>>>>
>>>> [...]
>>>>
>>>>> pvcy shows a smaller overall improvement (50%) compared to
>>>>> vcpu_is_preempted (277%).  Host side flamegraph analysis shows that
>>>>> ~60% of the host time when using pvcy is spent in kvm_handle_wfx,
>>>>> compared with ~1.5% when using vcpu_is_preempted, hence
>>>>> vcpu_is_preempted shows a larger improvement.
>>>>
>>>> And have you worked out *why* we spend so much time handling WFE?
>>>>
>>>>     M.
>>>
>>> Its from the following change in pvcy patchset:
>>>
>>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>>> index e778eefcf214..915644816a85 100644
>>> --- a/arch/arm64/kvm/handle_exit.c
>>> +++ b/arch/arm64/kvm/handle_exit.c
>>> @@ -118,7 +118,12 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>>>          }
>>>
>>>          if (esr & ESR_ELx_WFx_ISS_WFE) {
>>> -               kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
>>> +               int state;
>>> +               while ((state = kvm_pvcy_check_state(vcpu)) == 0)
>>> +                       schedule();
>>> +
>>> +               if (state == -1)
>>> +                       kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
>>>          } else {
>>>                  if (esr & ESR_ELx_WFx_ISS_WFxT)
>>>                          vcpu_set_flag(vcpu, IN_WFIT);
>>>
>>>
>>> If my understanding is correct of the pvcy changes, whenever pvcy
>>> returns an unchanged vcpu state, we would schedule to another
>>> vcpu. And its the constant scheduling where the time is spent. I guess
>>> the affects are much higher when the lock contention is very
>>> high. This can be seem from the pvcy host side flamegraph as well with
>>> (~67% of the time spent in the schedule() call in kvm_handle_wfx), For
>>> reference, I have put the graph at:
>>> https://uarif1.github.io/pvlock/perf_host_pvcy_nmi.svg
>>
>> The real issue here is that we don't try to pick the right vcpu to
>> run, and strictly rely on schedule() to eventually pick something that
>> can run.
>>
>> An interesting to do would be to try and fit the directed yield
>> mechanism there. It would be a lot more interesting than the one-off
>> vcpu_is_preempted hack, as it gives us a low-level primitive on which
>> to construct things (pvcy is effectively a mwait-like primitive).
> 
> We could use kvm_vcpu_yield_to to yield to a specific vcpu, but how 
> would we determine which vcpu to yield to?
> 
> IMO vcpu_is_preempted is very well integrated in a lot of core kernel 
> code, i.e. mutex, rtmutex, rwsem and osq_lock. It is also used in 
> scheduler to determine better which vCPU we can run on soonest, select 
> idle core, etc. I am not sure if all of these cases will be optimized by 
> pvcy? Also, with vcpu_is_preempted, some of the lock heavy benchmarks 
> come down from spending around 50% of the time in lock to less than 1% 
> (so not sure how much more room is there for improvement).
> 
> We could also use vcpu_is_preempted to optimize IPI performance (along 
> with directed yield to target IPI vCPU) similar to how its done in x86 
> (https://lore.kernel.org/all/1560255830-8656-2-git-send-email-wanpengli@tencent.com/). 
> This case definitely wont be covered by pvcy.
> 
> Considering all the above, i.e. the core kernel integration already 
> present and possible future usecases of vcpu_is_preempted, maybe its 
> worth making vcpu_is_preempted work on arm independently of pvcy?
> 

Hi,

Just wanted to check if there are any comments on above? I can send a v3 
with the doc and code fixes suggested in the earlier reviews if it makes 
sense?

Thanks,
Usama

> Thanks,
> Usama
> 
>>
>>     M.
>>
