Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C647690811
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 12:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBIL6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 06:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjBIL4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 06:56:23 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117B45BA55
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 03:45:35 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id ba1so1477420wrb.5
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 03:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hu6GdqNd3zsA84btgPFw8USXgsViqaEjdbJQnrfaI4w=;
        b=n1Ienk5lRO8cXWiArd74AhjKDLGYOjoSuLC0rRa/zikn36qgUP3ui7o/AwrN8hMBJX
         Unk1ZpgBgrbfEPmhmnDsOuX8wI/DXel0M23Cv3AFj20qQtDxsqSdOtbZING9EmqacyF5
         I0CYpWWOdPX0s4w/LtCTfnYqomtoRnUbIiyK6SnPXTJISnHBN1CKCPxrxUKbJBnqCm9h
         5bCFrgasalLc0XAf3HlJpcuY+hQv9KNX0JXNQL9K1C2R64TDmFaeabXOkmj7HRVzHIwU
         ohqxTol+g/Ulqc1WRLf2HQnSWR6kbjoIgFLp6LsthUfIK2kCmFi+jEma6CTxY9+FhmhK
         YsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hu6GdqNd3zsA84btgPFw8USXgsViqaEjdbJQnrfaI4w=;
        b=M9O5c+nOx3YcBHNx75DbRW628z3XiNBj3RwNWW9jzc2vaW0J5Pt+lyN5+gWbk1EnW3
         bUNcI9V84vzW/1n6es1OZVWgdx5A3LbFuluZXssA/EnX0vtbReQgfzY98ShjJ8lbNqEb
         qg98koghtLeuFqHXYqdWSUQ5Ksrng1pR2gGY+BCkMshmR06KiFCAALcWKX3/aCzFUpIY
         lub0XA1kRpJi5WLJMSx75OP3GjsA2qLWKI1NDxHmB+xmHYPiYyMYt6TFQJwzPMb5vE+h
         wJ1xWmBJlz7GHVqAANnXPCX7mT20hybGeJTReGIZva082YvKuF1iY2nZEILzYNJOTsXk
         eZLg==
X-Gm-Message-State: AO0yUKVIZ5PKJzvqMgj+Waibsznano5zixKnGPob+RvWCTA8A46Vm7aW
        bqGub+H9ofTemDgB2N/2BWplKQ==
X-Google-Smtp-Source: AK7set+SdD0YDgg4BCREGyg/o6ZuyXLyU0+ajza8lIhXN2idY2jcgPdHDEeeYVo1q6dNnVXyEeB29Q==
X-Received: by 2002:a5d:6585:0:b0:2c3:c453:5dd3 with SMTP id q5-20020a5d6585000000b002c3c4535dd3mr10725274wru.36.1675943133621;
        Thu, 09 Feb 2023 03:45:33 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8009:2525:9580:8db2? ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id t2-20020adfe102000000b002c3f280bdc7sm1085376wrz.96.2023.02.09.03.45.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 03:45:33 -0800 (PST)
Message-ID: <541a3e2a-d72e-98f7-bfc6-f64ef65f3043@bytedance.com>
Date:   Thu, 9 Feb 2023 11:45:32 +0000
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
 <f07b371ae2eb11f541c665b488b3d4b6bf1a81b3.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <f07b371ae2eb11f541c665b488b3d4b6bf1a81b3.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/02/2023 11:03, David Woodhouse wrote:
> On Thu, 2023-02-09 at 09:49 +0000, Usama Arif wrote:
>>
>> Its easy to test, just by doing
>> echo 0 > /sys/devices/system/cpu/cpu0/online;
>> echo 1 > /sys/devices/system/cpu/cpu0/online;
> 
> This one also fixes it for me. If we're happy with this approach, I'll
> work it into Thomas's original patch (and hopefully eventually he'll be
> happy enough with it and the commit message that he'll give us his
> Signed-off-by for it.)
> 

Yes, I think its better!

> 
> I could probably add a Co-developed-by: tglx for that first x2apic
> patch in the series too, but then it would *also* need his SoB and I
> didn't want to be owed two, so I just pasted his suggested code and
> didn't credit him.
> 
> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 5462464fe3ef..ea6052a97619 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -450,7 +450,16 @@ SYM_CODE_END(secondary_startup_64)
>   SYM_CODE_START(start_cpu0)
>          ANNOTATE_NOENDBR
>          UNWIND_HINT_EMPTY
> -       movq    initial_stack(%rip), %rsp
> +       /* Load the per-cpu base for CPU#0 */
> +       leaq    __per_cpu_offset(%rip), %rbx
> +       movq    (%rbx), %rbx
> +
> +       /* Find the idle task stack */
> +       movq    $idle_threads, %rcx
> +       addq    %rbx, %rcx
> +       movq    (%rcx), %rcx
> +       movq    TASK_threadsp(%rcx), %rsp
> +
>          jmp     .Ljump_to_C_code
>   SYM_CODE_END(start_cpu0)
>   #endif
> 
> I cut and pasted some of that, I'm not entirely sure why we have three
> instructions to do the equivalent of 'movq idle_threads(%ebx), %ecx'
> and may fix that in the original as I work this in.
