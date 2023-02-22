Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B2969EB94
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 01:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjBVAA7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 19:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjBVAA5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 19:00:57 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68222DE65
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 16:00:29 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k14-20020a05600c1c8e00b003e22107b7ccso313927wms.0
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 16:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oz/Iwbv2fLpbfzV50XMlj3n/kZPfJJpWkVANG6/lRVw=;
        b=l5Fh0IIbxiviB1BnGe7WB6ad8W1IYz8P5cJ2BfCux+fbsh8ktqfUDE4xvrKrzpUUFB
         lO8vjGH6GLJW43oj/0OinqCbNGELRrcVzoJGvQlwqqWDoKTZdGz5xDJA5fberrSv/Xkq
         dqcPArKjXD2Xnul6bUBRcnhFlASV5Vx2SHCmSIxdxvrUfhlkRT8c9uK+wBa1NorTwpzl
         ACPXeYuahUF2yt9FvZDmCfYNTm7u0q5fNap8H/WwlG0tJVW1oYyIH6nulfDtbd/St009
         2z776v13awRPe2v02IWZrW9Mt1eRvqU/FABi4rvHoVg/V0nok5WC0BO1fQ3VtrVE1/wG
         EHsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oz/Iwbv2fLpbfzV50XMlj3n/kZPfJJpWkVANG6/lRVw=;
        b=FEp8nq0ldRttO5vL8xx95rh7gMB41ZjKb8GYy+qlbrEB4CpT/6kT+2J6qCbeUhV9YO
         40hxU+7rXns9gC3ou0heGlEyhsKc8GnleknnsDOg6WyoyrOKXP/Euso29DZGtyzxFNuX
         vJSdcjNeTcNPcX9h4A909bh73Gk8Qtshx3ZH2ce3Ia8FmOen4+VDvsV2DBZORNEDLRCN
         4nspWks/+YRsDzvu1CVfiNwhL23FanPQIQT0VNWGLo8P4KelRozcTrdhbrEnH7mVAiVH
         krDCqrbH05P8/G6Y9SAQJNHsOsgxkOFNFxV6/1p3NQGfl348yhct8UKzm4j7vzYmaDqF
         V3Xg==
X-Gm-Message-State: AO0yUKV5bSQDGxOC/WZdrQcuvR4g9+ukTD8HZo3upvOn7cmv1biRcCAV
        J8RqZZcBBHesLWIhIqyqOkTKYQ==
X-Google-Smtp-Source: AK7set8B10aO88abtFcpqZIsTgOqQQHpaYQNgos/njV5kQgUzbgLC7JPB0vnmM8GBQXJal4Jpe/Vzw==
X-Received: by 2002:a05:600c:13ca:b0:3e2:185d:a726 with SMTP id e10-20020a05600c13ca00b003e2185da726mr4551979wmg.29.1677024028275;
        Tue, 21 Feb 2023 16:00:28 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:1a14:8be6:b3a9:a95e? ([2a02:6b6a:b566:0:1a14:8be6:b3a9:a95e])
        by smtp.gmail.com with ESMTPSA id o17-20020a05600c379100b003e70a7c1b73sm4342773wmr.16.2023.02.21.16.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 16:00:27 -0800 (PST)
Message-ID: <11cc090b-82aa-f2f5-0f08-b8e63e662947@bytedance.com>
Date:   Wed, 22 Feb 2023 00:00:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Kim Phillips <kim.phillips@amd.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
 <f71275dc809cfb32df513023786c3faa@natalenko.name>
 <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org>
 <9153284c37a79d303aa79dbf07c10329@natalenko.name>
 <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
 <87356yofw3.ffs@tglx>
 <aac036a17b1bcbabe8ee5a7c69fb2dfbc546d06e.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <aac036a17b1bcbabe8ee5a7c69fb2dfbc546d06e.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21/02/2023 23:18, David Woodhouse wrote:
> On Tue, 2023-02-21 at 22:41 +0100, Thomas Gleixner wrote:
>>
>> @@ -57,6 +58,7 @@ asmlinkage acpi_status __visible x86_acp
>>    */
>>   int x86_acpi_suspend_lowlevel(void)
>>   {
>> +       unsigned int __maybe_unused saved_smpboot_ctrl;
>>          struct wakeup_header *header =
>>                  (struct wakeup_header *) __va(real_mode_header->wakeup_header);
>>   
>> @@ -115,7 +117,8 @@ int x86_acpi_suspend_lowlevel(void)
>>          early_gdt_descr.address =
>>                          (unsigned long)get_cpu_gdt_rw(smp_processor_id());
>>          initial_gs = per_cpu_offset(smp_processor_id());
>> -       smpboot_control = 0;
>> +       /* Force the startup into boot mode */
>> +       saved_smpboot_ctrl = xchg(&smpboot_control, 0);
>>   #endif
>>          initial_code = (unsigned long)wakeup_long64;
>>          saved_magic = 0x123456789abcdef0L;
>> @@ -128,6 +131,9 @@ int x86_acpi_suspend_lowlevel(void)
>>          pause_graph_tracing();
>>          do_suspend_lowlevel();
>>          unpause_graph_tracing();
>> +
>> +       if (IS_ENABLED(CONFIG_64BIT) && IS_ENABLED(CONFIG_SMP))
>> +               smpboot_control = saved_smpboot_ctrl;
>>          return 0;
>>   }
>>   
> 
> But wait, why is this giving it a dedicated temp_stack anyway? Why
> can't it use that CPU's idle thread stack like we usually do? I already
> made idle_thread_get() accessible from here. So we could do this...
> 
> @@ -111,14 +112,16 @@ int x86_acpi_suspend_lowlevel(void)
>          saved_magic = 0x12345678;
>   #else /* CONFIG_64BIT */
>   #ifdef CONFIG_SMP
> -       initial_stack = (unsigned long)temp_stack + sizeof(temp_stack);
> -       early_gdt_descr.address =
> -                       (unsigned long)get_cpu_gdt_rw(smp_processor_id());
> -       initial_gs = per_cpu_offset(smp_processor_id());
> -       smpboot_control = 0;
> +       if (!(smpboot_control & STARTUP_PARALLEL_MASK)) {
> +               unsigned int cpu = smp_processor_id();
> +               initial_stack = (unsigned long)idle_thread_get(cpu)->thread.sp;
> +               early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
> +               initial_gs = per_cpu_offset(cpu);
> +               smpboot_control = 0;
> +       }
>   #endif
>          initial_code = (unsigned long)wakeup_long64;
> 
> 
> But that's a whole bunch of pointless, because it can be even further
> simplified to just let the find its own crap like the secondaries do,
> except in the 'OMG CPUID won't tell me' case where it has to be told:
> 
> So how about we just do something more like this. I'd *quite* like to
> put the actual handling of smpboot_control into a function we call in
> smpboot.c. and that whole x86_acpi_suspend_lowlevel() function wants
> all its horrid 64bit/smp ifdefs fixed up (and is there any reason
> there's a generic part saving CR0 and IA32_MISC_ENABLE right in the
> middle of some !CONFIG_64BIT parts? I don't see ordering constraints
> there). But this should work, I think:
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 33c0d5fd8af6..72b9375fec7c 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -208,4 +208,6 @@ extern unsigned int smpboot_control;
>   #define STARTUP_APICID_CPUID_0B	0x40000000
>   #define STARTUP_APICID_CPUID_01	0x20000000
>   
> +#define STARTUP_PARALLEL_MASK	0x60000000
> +

Probably could define STARTUP_PARALLEL_MASK as STARTUP_APICID_CPUID_0B | 
STARTUP_APICID_CPUID_01 instead? otherwise if its a separate bit, it 
needs to be set in native_smp_prepare_cpus as well for this to work?

>   #endif /* _ASM_X86_SMP_H */
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 06adf340a0f1..a1343a900caf 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -16,17 +16,14 @@
>   #include <asm/cacheflush.h>
>   #include <asm/realmode.h>
>   #include <asm/hypervisor.h>
> -
> +#include <asm/smp.h>
> +#include <linux/smpboot.h>
>   #include <linux/ftrace.h>
>   #include "../../realmode/rm/wakeup.h"
>   #include "sleep.h"
>   
>   unsigned long acpi_realmode_flags;
>   
> -#if defined(CONFIG_SMP) && defined(CONFIG_64BIT)
> -static char temp_stack[4096];
> -#endif
> -
>   /**
>    * acpi_get_wakeup_address - provide physical address for S3 wakeup
>    *
> @@ -111,14 +108,11 @@ int x86_acpi_suspend_lowlevel(void)
>   	saved_magic = 0x12345678;
>   #else /* CONFIG_64BIT */
>   #ifdef CONFIG_SMP
> -	initial_stack = (unsigned long)temp_stack + sizeof(temp_stack);
> -	early_gdt_descr.address =
> -			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
> -	initial_gs = per_cpu_offset(smp_processor_id());
> -	smpboot_control = 0;
> +	if (!(smpboot_control & STARTUP_PARALLEL_MASK))
> +		smpboot_control = STARTUP_SECONDARY | cpu_physical_id(smp_processor_id());
>   #endif
>   	initial_code = (unsigned long)wakeup_long64;
> -       saved_magic = 0x123456789abcdef0L;
> +	saved_magic = 0x123456789abcdef0L;
>   #endif /* CONFIG_64BIT */
>   
>   	/*
> 
> 
