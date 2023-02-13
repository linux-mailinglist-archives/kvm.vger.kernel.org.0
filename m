Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6949694AEA
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjBMPTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 10:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBMPTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 10:19:45 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BFF6EA2
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 07:19:43 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id y1so12627001wru.2
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 07:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vBVRW3XJB/dsQe28qObDwY1va8U6ugsCHUwHE1TeoHo=;
        b=w+/JciSH3sQgbIKPFpDqeYFFqcYSKc9sfMWWGZ+LuNnQjjCBJGWU7AfDpcq2/is5ph
         10zTwvQ7dV0mTP9/gb0WBLZMy/iH3zkBdFcHCPk9FYD+xH30s9yj/U4S3YV7u+XPL8q5
         TsN37/HlzpOioBVDQtU0S1onvBp/4+fd874/4ifD13jcz8x1Vf0fn4wC6fCiV5aYgyxD
         aGBQuaU5inu7DcWLoAdwixV63e1qH6HdheX5iXH2E74/FTCx9OlBRKnfUcmrmjqmikWz
         Eaq0uTsGLhv+hsInwKj0YQvfEHLExh1XtyJPrDmKivlaKc1Wnz4h0RVTFiMhWV7gp/vm
         w92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vBVRW3XJB/dsQe28qObDwY1va8U6ugsCHUwHE1TeoHo=;
        b=WziG+SMUw7vCYOgnxLlBUETXZfHd+sg6fAds0pzM+CGsxO567eW5g9lIGazQ5pHflY
         pjotvgxd8X4GQ/6k9Oz0Azg/l9AJfgZ4cGTkgQodjAgLC7+Gljcsx3KaJw/nmbDrrgQe
         wuLT3MOJm978RhJQEzQ+iAA1oUYCFnx9x2ujRXE/F1dqdPRQXPWsxtI/JtgjQUSgA6fj
         s8eMX5pF+KmRF7BUOrCH5qhuCoYcUdwvNuDFVZgKqgLcGvQwtjjozQFQyS6dX1Td5BVv
         4hLhJbakxqTiDtLcDPn7upWx1kvofXOifZWw64SAWP5gTTEAh4Kl7kV6LrK7l1IKzMl7
         FY+A==
X-Gm-Message-State: AO0yUKV0ESMRacjUCl9+WK6eJOXbsRpCcDkCwg65Gmiud1NP00ONja9e
        k1nw5kVMq/i0GPXoThM9C4twag==
X-Google-Smtp-Source: AK7set8He8H3zgxnh+9zUlZ4hjUThuw6BcQHtJBmflOPQ7yEaVLCEwj4WUR2/WuiDOiPowXJz2lTSw==
X-Received: by 2002:adf:eb51:0:b0:2c3:dbe0:58b8 with SMTP id u17-20020adfeb51000000b002c3dbe058b8mr20763507wrn.41.1676301582442;
        Mon, 13 Feb 2023 07:19:42 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:9e1:512:feb0:fe83? ([2a02:6b6a:b566:0:9e1:512:feb0:fe83])
        by smtp.gmail.com with ESMTPSA id k1-20020adff5c1000000b002bff574a250sm10904252wrp.2.2023.02.13.07.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 07:19:41 -0800 (PST)
Message-ID: <04d98646-7c2e-9a62-1340-2d8efe69a121@bytedance.com>
Date:   Mon, 13 Feb 2023 15:19:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v8 8/9] x86/mtrr: Avoid repeated save of
 MTRRs on boot-time CPU bringup
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230209154156.266385-1-usama.arif@bytedance.com>
 <20230209154156.266385-9-usama.arif@bytedance.com> <87mt5m1yiz.ffs@tglx>
 <9b6bca9c-7189-a2d5-8c0a-f55c24f54b62@bytedance.com> <878rh61jqx.ffs@tglx>
 <6fc16f3048719058bccce9d488bcb75252f49031.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <6fc16f3048719058bccce9d488bcb75252f49031.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/02/2023 08:55, David Woodhouse wrote:
> On Fri, 2023-02-10 at 00:50 +0100, Thomas Gleixner wrote:
>> On Thu, Feb 09 2023 at 20:32, Usama Arif wrote:
>>> On 09/02/2023 18:31, Thomas Gleixner wrote:
>>>>>          first_cpu = cpumask_first(cpu_online_mask);
>>>>>          smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
>>>>
>>>> So why is this relevant after the initial bringup? The BP MTRRs have
>>>> been saved already above, no?
>>>>
>>>
>>> I will let David confirm if this is correct and why he did it, but this
>>> is what I thought while reviewing before posting v4:
>>>
>>> - At initial boot (system_state < SYSTEM_RUNNING), when mtrr_save_state
>>> is called in do_cpu_up at roughly the same time so MTRR is going to be
>>> the same, we can just save it once and then reuse for other secondary
>>> cores as it wouldn't have changed for the rest of the do_cpu_up calls.
>>>
>>> - When the system is running and you offline and then online a CPU, you
>>> want to make sure that hotplugged CPU gets the current MTRR (which might
>>> have changed since boot?), incase the MTRR has changed after the system
>>> has been booted, you save the MTRR of the first online CPU. When the
>>> hotplugged CPU runs its initialisation code, its fixed-range MTRRs will
>>> be updated with the newly saved fixed-range MTRRs.
>>
>> I knew that already :) But seriously:
>>
>> If the MTRRs are changed post boot then the cached values want to be
>> updated too.
> 

I had previously only done smpboot time measurements for the whole 
patchset, but I tested the patchset without this commit and it doesn't 
make a difference to smpboot time as its negligable work to read those 
MTRR MSRs into mtrr_state.fixed_ranges.
This commit is also independent of parallel smp bringup, similar to 
reusing timer calibration so I think it could be considered as a 
separate patchset if needed. I will post the next revision without this 
commit, but here is my view on MTRR save/restore (which shouldn't matter 
for the next revision...).

If the MTRR changes on a running system, there might be a bug during 
hotplug in the original code that handles MTRR? which is also carried 
over in this patch.
 From what I can see, MTRR is only saved+restored during initial boot, 
hotplugging CPU and __save/__restore_processor_state() (used in creating 
image for hibernation, suspend, kexec...). So if for e.g. in a running 
system (that has not hibernated, suspended, kexeced), if MTRR for CPU0 
(first_cpu) changed post-boot and CPU3 is hotplugged, only MTRR for CPU3 
is updated and CPU0 and CPU3 will hold the same value, while the rest of 
the CPUs will have the older first-boot value? This behavior will happen 
with or without this patch. I think this is what Thomas is referring to 
above when he says that the cached values want to be updated? But the 
issue is present in the original code as well.

Thanks!
Usama

> They are, aren't they? The only way we come out of mtrr_save_state()
> without calling mtrr_save_fixed_ranges() — either directly or via
> smp_call_function_single() — is if they've already been saved once
> *and* system_state < SYSTEM_RUNNING.
> 
> I suppose we could make that clearer by moving the definition of the
> mtrr_saved flags inside the if (system_state < SYSTEM_RUNNING) block?
> 
> @@ -721,11 +721,20 @@ void __init mtrr_bp_init(void)
>    */
>   void mtrr_save_state(void)
>   {
>   	int first_cpu;
>   
>   	if (!mtrr_enabled())
>   		return;
>   
> +	if (system_state < SYSTEM_RUNNING) {
> +		static bool mtrr_saved;
> +		if (!mtrr_saved) {
> +			mtrr_save_fixed_ranges(NULL);
> +			mtrr_saved = true;
> +		}
> +		return;
> +	}
> +
>   	first_cpu = cpumask_first(cpu_online_mask);
>   	smp_call_function_single(first_cpu, mtrr_save_fixed_ranges, NULL, 1);
>   }
> 
