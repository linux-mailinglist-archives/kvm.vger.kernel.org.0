Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B3E690482
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBIKTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBIKTn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:19:43 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E128718B1D
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 02:19:41 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id y1so1260288wru.2
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 02:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o7nXjYUAJe0c4WLMHTFjnjlD4cocALBpSRZfaJQqgEk=;
        b=e1fxAKvfXSrp1k9VGsl1QKST7yhBe0BNlLL/Iz+AVh4h+Tel0jfOeVumpH8Ivf4qiw
         EzvQ+fcRqN2nuzeZosVgC85zw1vIebgFklkGPbIfpajb4GzXrxeA+4uHr2SeqvxSl4jT
         9Jf3rU+Q8a1hcXd3olK59afiOJsdrs9mfa4cYndQWIDPb2rauyTdnWYk9SAgUz/GvDST
         3OlfJjgNHgkufffvfHokPT8MpTbgKQZNfAzHo2bYr/4uyKDoD1dqcKyypcJyNLQemezp
         L/rinS4bhOOIe6SgKocqsStaFjAvl3WwdeA1KyfrrWyvMf4HpHjm5fUV/penfPylkCRU
         NyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7nXjYUAJe0c4WLMHTFjnjlD4cocALBpSRZfaJQqgEk=;
        b=cx+p62B+aONHfVwczxSMGEVaCZDGxrpW9EE35bSnx1OPp40qrMtvfImL9AeWkTkbfi
         kJTqmY26hNXxWvjhk8RKONi+TGf2TamevthrANIlOzBwsBqUEd3lasJNpRsrVWDqNvqJ
         RJoNht3pn06QghxpoRdKSNUhf2T5KyazWmTEc4ybPR2ggsHiaSM4cmU6+ZaKJinMj5Dz
         SSxYL1iLjXxTHr34iyvVy+smraAQYLtm41ASD5VhV7QPVJ9wZ1vUhkXLaCc2PU3WTOIj
         pB0KwzXXfD+TGAvSp0UwrNZ2IXYPMODUQ2YpdYrLxWzro4nIZRRyuyIbufhbmijJZnMa
         dkEg==
X-Gm-Message-State: AO0yUKUH5LLaYLjcQw+4mmC6XFSWcqesqo8EgZdPhFC7FDynFgqjo0BH
        GIA83RrSxAP7t4JJ0m8jn5tjWQ==
X-Google-Smtp-Source: AK7set9kutQKT1vIzInVG0wk4AWlrSDOIpMvfWz3SWsDByS8nhiQWTEHU6AQLo/n+cdjjSxIRHJFvQ==
X-Received: by 2002:a05:6000:12cb:b0:2c3:4ef0:343e with SMTP id l11-20020a05600012cb00b002c34ef0343emr10132679wrx.5.1675937980415;
        Thu, 09 Feb 2023 02:19:40 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8009:2525:9580:8db2? ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id y1-20020a5d6201000000b002c3ea5ebc73sm852467wru.101.2023.02.09.02.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 02:19:39 -0800 (PST)
Message-ID: <4377e0bc-5954-c0c3-0daa-24a4427c144e@bytedance.com>
Date:   Thu, 9 Feb 2023 10:19:38 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v7 0/9] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, paulmck@kernel.org,
        tglx@linutronix.de
Cc:     kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230209035300.GA3216394@paulmck-ThinkPad-P17-Gen-1>
 <8e2f03e2-9517-aeb4-df60-b36ef3ff3a75@bytedance.com>
 <79fa4d65a0d906dd42c41324dfe065aa8ad06d6f.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <79fa4d65a0d906dd42c41324dfe065aa8ad06d6f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/02/2023 10:06, David Woodhouse wrote:
> On Thu, 2023-02-09 at 09:49 +0000, Usama Arif wrote:
>>
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1080,6 +1080,7 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long
>> start_ip, int apicid,
>>                                             wakeup_cpu0_nmi, 0, "wake_cpu0");
>>
>>           if (!boot_error) {
>> +               initial_gs = per_cpu_offset(cpu);
> 
> That's for 64-bit.
> 
>>                   enable_start_cpu0 = 1;
>>                   *cpu0_nmi_registered = 1;
>>                   id = apic->dest_mode_logical ? cpu0_logical_apicid :
>> apicid;
>> @@ -1188,10 +1189,14 @@ static int do_boot_cpu(int apicid, int cpu,
>> struct task_struct *idle,
>>                   boot_error = apic->wakeup_secondary_cpu_64(apicid,
>> start_ip);
>>           else if (apic->wakeup_secondary_cpu)
>>                   boot_error = apic->wakeup_secondary_cpu(apicid, start_ip);
>> -       else
>> +       else {
>> +               if(!cpu) {
>> +                       early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
>> +                       initial_stack  = idle->thread.sp;
>> +               }
> 
> And that's 32-bit.
> 
> These were previously done in common_cpu_up() or do_boot_cpu(), which
> means they were done not only for the wakeup_cpu_via_init_nmi() code
> path, but also when we call apic->wakeup_secondary_cpu() (or _64()) for
> the esoteric UV/NumaConnect machines.
> 
> Thanks for diagnosing it so quickly; I'll work up a subtly different
> fix.
> 

Yeah, was just a hacky fix while I was trying to figure out the issue.

do_boot_cpu is only called in cpu0 in hotplug case, so I think this a 
much better diff:

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3ec5182d9698..f7ae82969ee4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1136,13 +1136,16 @@ static int do_boot_cpu(int apicid, int cpu, 
struct task_struct *idle,
         idle->thread.sp = (unsigned long)task_pt_regs(idle);
         initial_code = (unsigned long)start_secondary;

-       if (IS_ENABLED(CONFIG_X86_32)) {
+       if (IS_ENABLED(CONFIG_X86_32) || !cpu) {
                 early_gdt_descr.address = (unsigned 
long)get_cpu_gdt_rw(cpu);
                 initial_stack  = idle->thread.sp;
         } else if (!do_parallel_bringup) {
                 smpboot_control = STARTUP_SECONDARY | apicid;
         }

+       if (!cpu)
+               initial_gs = per_cpu_offset(cpu);
+
         /* Enable the espfix hack for this CPU */
         init_espfix_ap(cpu);



>>                   boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
>>                                                        cpu0_nmi_registered);
>> -
>> +       }
>>           return boot_error;
>>    }
>>
> 
