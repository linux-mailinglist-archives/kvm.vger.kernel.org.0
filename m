Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D9F637A91
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 14:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiKXNze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 08:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiKXNzc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 08:55:32 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D75DE3D3B
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 05:55:30 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id ay14-20020a05600c1e0e00b003cf6ab34b61so4001559wmb.2
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 05:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pN+fMTXIbwkvTVCL6teMynvLqCQ1zb8psy5cG5agjcI=;
        b=o29ZVKlW0hg+wTr5SNdc59ZTn7GtkgIjvdfNuhfZ9Go5RYF0bUJQaqw5oksOVSlXKZ
         gcP9TNLHnjIxApSzZCFmyVSHsnHp5d8nqgupDXaf2I2GRs9KooJHuWeafVn03RAPJtr/
         0qkPSxuCTWSkaFU8OuSG1Uq66QpY8nhn69mWWtcNAOe2IaA095kW57glzfzcSggluPjv
         gM2S+9x9+HeAxzpzkyPXaxArRwLN7K37FBGUiotrf5SRPQRRIGyY0GrWM/F6EFK1MOFE
         SuMysdzefbRAZ6CgZjQ+ih+yQp1V+6yCvXoo5pkoW/Kg6aWhZ65xv+8aFUSMN8tbrBJG
         aQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pN+fMTXIbwkvTVCL6teMynvLqCQ1zb8psy5cG5agjcI=;
        b=HE2+k58psFGsJiCtZTZsalOQALkD8LR92CWkiuJPiivD4QUupjCN0xbX01gUHDsHJs
         po3Jcpio/JCMzPSi7lOIXAzXwz0uilK2YhV94BuWzYF5r9TmYAQimgmjI1ALxiFGBUqU
         dOCQSMpv6VUv9pLMgK1/x3fIIjUUw36/V3IAje0MmrJlvfXEqD5K9mu0RYkmPJ3HffKI
         6wcD/a1jTsxkPMShn9LMuM7CGcSiWVIVEJkWEwy6J4po9VJC9P3N+qXgop1WV1HDsoO3
         5Qz7plRzpDcsxgOIvzAIIcRTYX4J/2taoJxiR/iZkPSonxTqrQ2lOCZWt4OsJ7wnaGmR
         mgRA==
X-Gm-Message-State: ANoB5pkVZyINOtwZWxvNPBKVQyFe9y2020OYJKg5RRvKPC83SBHz47Ey
        jmQ+sQYEjDOfFjFhNLhq9l4++Q==
X-Google-Smtp-Source: AA0mqf7LmgqnY5TT62nL6QBBImocwCh9tlDp2Ug4ekB8tl5kFgZ55ulOqFa7jWHsk4HR1gTXeY+Y4A==
X-Received: by 2002:a1c:a381:0:b0:3cf:4d14:5705 with SMTP id m123-20020a1ca381000000b003cf4d145705mr12126137wme.35.1669298128503;
        Thu, 24 Nov 2022 05:55:28 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b4d7:0:f0b8:522f:5d6e:d788? ([2a02:6b6a:b4d7:0:f0b8:522f:5d6e:d788])
        by smtp.gmail.com with ESMTPSA id h20-20020a05600c351400b003b4935f04a4sm2479548wmq.5.2022.11.24.05.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Nov 2022 05:55:28 -0800 (PST)
Message-ID: <95efd030-27f6-5668-a25e-9fbf210bfa1c@bytedance.com>
Date:   Thu, 24 Nov 2022 13:55:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [External] Re: [v2 0/6] KVM: arm64: implement vcpu_is_preempted
 check
Content-Language: en-US
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
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <86r0y1nmep.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18/11/2022 00:20, Marc Zyngier wrote:
> On Mon, 07 Nov 2022 12:00:44 +0000,
> Usama Arif <usama.arif@bytedance.com> wrote:
>>
>>
>>
>> On 06/11/2022 16:35, Marc Zyngier wrote:
>>> On Fri, 04 Nov 2022 06:20:59 +0000,
>>> Usama Arif <usama.arif@bytedance.com> wrote:
>>>>
>>>> This patchset adds support for vcpu_is_preempted in arm64, which
>>>> allows the guest to check if a vcpu was scheduled out, which is
>>>> useful to know incase it was holding a lock. vcpu_is_preempted can
>>>> be used to improve performance in locking (see owner_on_cpu usage in
>>>> mutex_spin_on_owner, mutex_can_spin_on_owner, rtmutex_spin_on_owner
>>>> and osq_lock) and scheduling (see available_idle_cpu which is used
>>>> in several places in kernel/sched/fair.c for e.g. in wake_affine to
>>>> determine which CPU can run soonest):
>>>
>>> [...]
>>>
>>>> pvcy shows a smaller overall improvement (50%) compared to
>>>> vcpu_is_preempted (277%).  Host side flamegraph analysis shows that
>>>> ~60% of the host time when using pvcy is spent in kvm_handle_wfx,
>>>> compared with ~1.5% when using vcpu_is_preempted, hence
>>>> vcpu_is_preempted shows a larger improvement.
>>>
>>> And have you worked out *why* we spend so much time handling WFE?
>>>
>>> 	M.
>>
>> Its from the following change in pvcy patchset:
>>
>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>> index e778eefcf214..915644816a85 100644
>> --- a/arch/arm64/kvm/handle_exit.c
>> +++ b/arch/arm64/kvm/handle_exit.c
>> @@ -118,7 +118,12 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
>>          }
>>
>>          if (esr & ESR_ELx_WFx_ISS_WFE) {
>> -               kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
>> +               int state;
>> +               while ((state = kvm_pvcy_check_state(vcpu)) == 0)
>> +                       schedule();
>> +
>> +               if (state == -1)
>> +                       kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
>>          } else {
>>                  if (esr & ESR_ELx_WFx_ISS_WFxT)
>>                          vcpu_set_flag(vcpu, IN_WFIT);
>>
>>
>> If my understanding is correct of the pvcy changes, whenever pvcy
>> returns an unchanged vcpu state, we would schedule to another
>> vcpu. And its the constant scheduling where the time is spent. I guess
>> the affects are much higher when the lock contention is very
>> high. This can be seem from the pvcy host side flamegraph as well with
>> (~67% of the time spent in the schedule() call in kvm_handle_wfx), For
>> reference, I have put the graph at:
>> https://uarif1.github.io/pvlock/perf_host_pvcy_nmi.svg
> 
> The real issue here is that we don't try to pick the right vcpu to
> run, and strictly rely on schedule() to eventually pick something that
> can run.
> 
> An interesting to do would be to try and fit the directed yield
> mechanism there. It would be a lot more interesting than the one-off
> vcpu_is_preempted hack, as it gives us a low-level primitive on which
> to construct things (pvcy is effectively a mwait-like primitive).

We could use kvm_vcpu_yield_to to yield to a specific vcpu, but how 
would we determine which vcpu to yield to?

IMO vcpu_is_preempted is very well integrated in a lot of core kernel 
code, i.e. mutex, rtmutex, rwsem and osq_lock. It is also used in 
scheduler to determine better which vCPU we can run on soonest, select 
idle core, etc. I am not sure if all of these cases will be optimized by 
pvcy? Also, with vcpu_is_preempted, some of the lock heavy benchmarks 
come down from spending around 50% of the time in lock to less than 1% 
(so not sure how much more room is there for improvement).

We could also use vcpu_is_preempted to optimize IPI performance (along 
with directed yield to target IPI vCPU) similar to how its done in x86 
(https://lore.kernel.org/all/1560255830-8656-2-git-send-email-wanpengli@tencent.com/). 
This case definitely wont be covered by pvcy.

Considering all the above, i.e. the core kernel integration already 
present and possible future usecases of vcpu_is_preempted, maybe its 
worth making vcpu_is_preempted work on arm independently of pvcy?

Thanks,
Usama

> 
> 	M.
> 
