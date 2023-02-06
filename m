Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDD568BC85
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 13:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjBFMLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 07:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjBFMLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 07:11:34 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620D84EF8
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 04:11:32 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o18so10164380wrj.3
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 04:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jNU2E4rEU6lK6E5UnBCR+OOWZtLTF1apeoMjKMv1xVo=;
        b=0BJuhb2SP8v0SAx2cFQrOf9KdQKmuD14IU5rp3ELE5hzV++SiFno0c6jIja1iAaH+m
         KgmbC7JqL38C41B4ROhgq/8gllmhnX1ats4xUrAtUESKykxl4Bhq9bWeoRPNivtxI9Hj
         nYhDoVCIJPIHrdrEMQD9jB6z9I0tjVPW65Lw5eiG8082b1iH26IIWoMYpIG7ohhhRSDJ
         d/stbmGlv9lLaLkYKSc/m3vXzRkgZpRnS2l5zo05sO/5/3P16zrp5Plh3DAdTU8VhpER
         xh44jKllCDz4+tumuIUaqoeH6ccmBeq49305euHcb3bbysnNiJxbA/JqcgkfFtzf6uWD
         fgkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jNU2E4rEU6lK6E5UnBCR+OOWZtLTF1apeoMjKMv1xVo=;
        b=OFRf3ZsOACJdkJ+ta95unzB4j20aRh/uS2a6OrRhjwi5ZUVX9Vbson8qB8AMeEXtXH
         kKrbz9lq96sJqIBrPmmnVO4siRqnlqyCj2Q1S11Q4P+yRydeqgXE4kyzhx8V50D/WBz/
         DlG9RXEu2mnIY+/NmIvvGHkJ4skLWKZcncbNgpArgFhy2ucvwf8pV8fWWbCDmRetB1yg
         UtCJsGWllYOISIAh95Q7JhKtQkjVjnvHSw60mrKsgocTOPB4Fhep20ZQn/xHZ1II9pbC
         f1JuHPUUYSUtBVAVyraVUi+jYjaVVrCex7KdlGhMaDJ66NdJDQWEItJ1XzekkBSwwF6x
         odrQ==
X-Gm-Message-State: AO0yUKVMRSAN3vR+x9C/lorRbbX6r1X4n28Jlpy/wpzSodAuvS59/C7C
        TqAiJYXTYscrMbxt4xVQoMAo007r9YoUtrT2AOM=
X-Google-Smtp-Source: AK7set+l6WZMcYdFTPEhuqOx7bXf+8SqBlvLrjlLxHBtr5qFvT42GvR0j4f0uSOjBIGP3rZh6CfJbg==
X-Received: by 2002:a5d:4b50:0:b0:2c3:eaff:aaf1 with SMTP id w16-20020a5d4b50000000b002c3eaffaaf1mr2381474wrs.18.1675685490947;
        Mon, 06 Feb 2023 04:11:30 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:39c7:f90d:557:dc30? ([2a02:6b6a:b566:0:39c7:f90d:557:dc30])
        by smtp.gmail.com with ESMTPSA id y10-20020a05600015ca00b002bfd137ecddsm8918926wry.11.2023.02.06.04.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 04:11:30 -0800 (PST)
Message-ID: <de7524ce-563c-2ff6-84a5-6a347c36855b@bytedance.com>
Date:   Mon, 6 Feb 2023 12:11:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v6 07/11] x86/smpboot: Disable parallel
 boot for AMD CPUs
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>, tglx@linutronix.de,
        rja@hpe.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Mario Limonciello <Mario.Limonciello@amd.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-8-usama.arif@bytedance.com>
 <b3d9fbbf-e760-5d1d-9182-44c144abd1bf@amd.com>
 <d3ec562fd2e03c3aef9534f64915a14a8cb89ae1.camel@infradead.org>
 <5ba476f3-e0ac-d630-ce1d-18ab9885496f@linux.intel.com>
 <E2286684-F8AD-4708-9A3D-74C5EAE183B4@infradead.org>
 <434b4b74-54ab-68a3-4a81-9cc02ea75e39@bytedance.com>
 <411cbdb2c8255e48f3e65c59a98bc02410f5dfc7.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <411cbdb2c8255e48f3e65c59a98bc02410f5dfc7.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/02/2023 08:05, David Woodhouse wrote:
> On Sun, 2023-02-05 at 22:13 +0000, Usama Arif wrote:
>>
>>
>> On 04/02/2023 22:31, David Woodhouse wrote:
>>>
>>>
>>> On 4 February 2023 18:18:55 GMT, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>>>>
>>>>> However...
>>>>>
>>>>> Even though we *can* support non-X2APIC processors, we *might* want to
>>>>> play it safe and not go back that far; only enabling parallel bringup
>>>>> on machines with X2APIC which roughly correlates with "lots of CPUs"
>>>>> since that's where the benefit is.
>>>>
>>>> I think that this is the right approach, at least on the initial patch series.
>>>> KISS principle; do all the easy-but-important cases first, get it stable and working
>>>> and in later series/kernels the range can be expanded.... if it matters.
>>>
>>> Agreed. I'll split it to do it only with X2APIC for the initial series, and then hold the CPUID 0x1 part back for the next phase.
>>
>> This was an interesting find! I tested the latest branch
>> parallel-6.2-rc6 and it works well. The numbers from Russ makes the
>> patch series look so much better! :)
>>
>> If we do it with x2apic only and not support non-x2apic CPUID 0x1 case,
>> maybe we apply the following diff to part 1?
> 
> Using x2apic_mode would also disable parallel boot when the CPU *does*
> have X2APIC support but the kernel just isn't using it at the moment. I
> think boot_cpu_has(X86_FEATURE_X2APIC) is the better criterion?
> 

x2apic_mode is set to 0 only in the case when nox2apic is specified in 
the kernel cmdline or if x2apic_setup fails. As 0xB leaf gets the 
"x2apic id" and not the "apic id", I thought it would be better to not 
use the x2apic id if the user doesnt want to use x2apic (cmdline), or 
the kernel fails to set it up.

Another thing I noticed from the Intel Architecture Manual CPUID—CPU 
Identification section:

"CPUID leaf 1FH is a preferred superset to leaf 0BH. Intel recommends 
first checking for the existence of Leaf 1FH before using leaf 0BH."

So I think we should switch from 0BH to using the 1FH leaf EDX register.

> I was thinking I'd tweak the 'no_parallel_bringup' command line
> argument into something that also allows us to *enable* it without
> X2APIC being supported.
> 
> But I've also been pondering the fact that this is all only for 64-bit
> anyway. It's not like we're doing it for the zoo of ancient i586 and
> even i486 machines where the APICs were hooked up with blue wire and
> duct tape.
> 
> Maybe "64-bit only" is good enough, with a command line opt-out. And
> maybe a printk pointing out the existence of that command line option
> before the bringup, just in case?
> 

I think that makes sense, the patch only has a significant impact when 
the core count is high, and x2apic was made to support higher CPU count.


>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index f53a060a899b..f6b89cf40076 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1564,7 +1564,7 @@ void __init native_smp_prepare_cpus(unsigned int
>> max_cpus)
>>            * sufficient). Otherwise it's too hard. And not for SEV-ES
>>            * guests because they can't use CPUID that early.
>>            */
>> -       if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 1 ||
>> +       if (IS_ENABLED(CONFIG_X86_32) || !x2apic_mode ||
>>               (x2apic_mode && boot_cpu_data.cpuid_level < 0xb) ||
>>               cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
>>                   do_parallel_bringup = false;
>>
>>
>>
>> For reusing timer calibration, calibrate_delay ends up being used in
>> start_kernel, smp_callin, debug_calc_bogomips and check_cx686_slop. I
>> think reusing timer calibration would be ok in the first 2 uses?
>>
> 
> It already explicitly allows the calibration to be reused from another
> CPU in the same *core*, but no further. I think we'd need to be sure
> about the correctness of extending that further, and which of the mess
> of constant/invariant/we-really-mean-it-this-time TSC flags need to be
> set for that to be OK.
> 
>> but not really sure about the other 2. cx686 seems to be quite old so not sure
>> if anyone will have it to test or will ever run 6.2 kernel on it :).  I
>> guess if unsure, better to leave out initially and try and get part1 merged?
> 
> I doubt cx686 advertises constant TSC; the early ones didn't even *have* a TSC.
> Does it even support SMP?

Just checked the wiki page, and it says core count is 1 :)
