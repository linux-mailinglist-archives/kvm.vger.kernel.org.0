Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFC56CD834
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 13:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbjC2LKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 07:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC2LK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 07:10:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B117D19A1
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 04:10:02 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h17so15218167wrt.8
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 04:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680088201;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6fMyRoI+gDBMSQ1ASPAj5GDfjiLEoGxH9G7/ldjpWq0=;
        b=Q1JX6+bz61+vh+Vzi+sUwW3yMZkzm75oKFpftOGczVAhMrRDKm0YR/bBqfuht4I4G0
         yvMwrHoq81CHuHyybcV/HPEQWF0NIdOH7bDzS37+Gr2coehioxNJ8a59CKMBA2XsZp6h
         8wtpVuc69EPsfRMeKaNWH2Fvmbl9ev5l1PbaHocbOfQ/X0Uwteton/ZLxjXcoCbnErLl
         w1T0tHaZo9yPx2R7aeax5iKD+dsN1rQq98OVSuy14aEp3lvRsjwMj40Oyit5R9o+8gGr
         d28N78YHVgGHJNYCrpiy462211GYs3XiGa2aj2RbW3aqBF24wOZBfKJWhajVPZIj/McR
         iPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680088201;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fMyRoI+gDBMSQ1ASPAj5GDfjiLEoGxH9G7/ldjpWq0=;
        b=GF9xy8TDEiKzWzhbtXLaC4C+AHSKDSrgGJdhNymhHv0fLkOm6TfyLjXspUUjKhZnhr
         POBSYfc+QzP/71Yhd92AzAbLZOBZcH7/231KQPDBykH974GokggCGn3zlSO9/xlqF9RZ
         9csDIUcVUFBFK+4UymvJTyWkcHjJ4lcxDGKbO53Bm2M3a1/d7g9a9nPzzFfyrC4ctJHM
         X6CMDxVIUQScobISi3MrwG9e5+ThfdSUCCRDKHzk+AqvLyqYerD7y65dKkPO9xsnWA1I
         Zg1a7xpDMSMG4e4wD+uA64kxr4AY1vr9oDHh2YrcC/Gexg6lrBgpxMEesVzY0u0z4zV/
         cwPQ==
X-Gm-Message-State: AAQBX9eo444q0TOfLiUmSiHkFjwxZE7vwlkcqlPkQ8ZzLXP1c6nGGsbg
        DPO3WFB/y3fnXfOSHVaWiBo5CA==
X-Google-Smtp-Source: AKy350ZMd5xDkTUJpUgfq6tGD1h9j1CDSgZ2snnpFp2odtgk5TA+d4edR7BJm6x3BDtTdIHsEhjZgg==
X-Received: by 2002:adf:dd4f:0:b0:2cf:ec75:8090 with SMTP id u15-20020adfdd4f000000b002cfec758090mr14969737wrm.14.1680088201184;
        Wed, 29 Mar 2023 04:10:01 -0700 (PDT)
Received: from ?IPV6:2a02:6b6a:b566:0:4aac:c45d:f15a:d179? ([2a02:6b6a:b566:0:4aac:c45d:f15a:d179])
        by smtp.gmail.com with ESMTPSA id i7-20020adffc07000000b002c5706f7c6dsm29908071wrr.94.2023.03.29.04.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Mar 2023 04:10:00 -0700 (PDT)
Message-ID: <8b6eeca2-bc35-6e17-e1e9-27d77565db67@bytedance.com>
Date:   Wed, 29 Mar 2023 12:09:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v17 2/8] cpu/hotplug: Reset task stack state in _cpu_up()
Content-Language: en-US
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Mark Rutland <mark.rutland@arm.com>
References: <20230328195758.1049469-1-usama.arif@bytedance.com>
 <20230328195758.1049469-3-usama.arif@bytedance.com>
In-Reply-To: <20230328195758.1049469-3-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28/03/2023 20:57, Usama Arif wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit dce1ca0525bf ("sched/scs: Reset task stack state in bringup_cpu()")
> ensured that the shadow call stack was reset and KASAN poisoning removed
> from a CPU's stack each time that CPU is brought up, not just once.
> 
> This is not incorrect. However, with parallel bringup, an architecture
> may obtain the idle thread for a new CPU from a pre-bringup stage, by
> calling idle_thread_get() for itself. This would mean that the cleanup
> in bringup_cpu() would be too late.
> 
> Move the SCS/KASAN cleanup to the generic _cpu_up() function instead,
> which already ensures that the new CPU's stack is available, purely to
> allow for early failure. This occurs when the CPU to be brought up is
> in the CPUHP_OFFLINE state, which should correctly do the cleanup any
> time the CPU has been taken down to the point where such is needed.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com> [arm64]

Forgot to include my sign-off. Thanks David for pointing it out.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>

> ---
>   kernel/cpu.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 6c0a92ca6bb5..43e0a77f21e8 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -591,12 +591,6 @@ static int bringup_cpu(unsigned int cpu)
>   	struct task_struct *idle = idle_thread_get(cpu);
>   	int ret;
>   
> -	/*
> -	 * Reset stale stack state from the last time this CPU was online.
> -	 */
> -	scs_task_reset(idle);
> -	kasan_unpoison_task_stack(idle);
> -
>   	/*
>   	 * Some architectures have to walk the irq descriptors to
>   	 * setup the vector space for the cpu which comes online.
> @@ -1383,6 +1377,12 @@ static int _cpu_up(unsigned int cpu, int tasks_frozen, enum cpuhp_state target)
>   			ret = PTR_ERR(idle);
>   			goto out;
>   		}
> +
> +		/*
> +		 * Reset stale stack state from the last time this CPU was online.
> +		 */
> +		scs_task_reset(idle);
> +		kasan_unpoison_task_stack(idle);
>   	}
>   
>   	cpuhp_tasks_frozen = tasks_frozen;
