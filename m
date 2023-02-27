Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63E56A470D
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 17:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjB0Qc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 11:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjB0Qcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 11:32:54 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DE3527E
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 08:32:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id e37so4393018wri.10
        for <kvm@vger.kernel.org>; Mon, 27 Feb 2023 08:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IoYGatWSvQRgweQA0GC8tXFSXKJ5/Iad9YexwVGxcig=;
        b=DBzJ4Kh1nAhW9mzymQMn0YEQKZmEthpxpRNWaXWEnyEPpWQ7O57QKdOvn/it4W238T
         toL+B6i+zEzGIAAZSw0V/3WW+UpN/Se0hUwgMladYn0fx2YZIB4h2FEcja4d+4+PDKv+
         1Q6Bvd45NkbZ2dLPqN+oOEToHY77kK5zp1UI9HLTo1k3naJD9TufyDHo5ltW5EDJDt+l
         5U0nDz0nhS6f1Wc0roDcGrMxDZuT4Y4KkKHkXUOYYdf93/+6SXt94d3R6cPZxifIUYgM
         0zBGgipF7s4SQQz3DMWh861aeSZ6YmWclTLPOL09wlPfUpbztD34Y/mX4XaE11h+PORx
         amsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IoYGatWSvQRgweQA0GC8tXFSXKJ5/Iad9YexwVGxcig=;
        b=Bi3CerRg1Cv8IDhg+nbObb5v1ZJfSGgx/PoT24hr51eTbNwkTKd9xAteVKFfXk5vqw
         k7bMkYYeTFl4ubrNjmUmWyIRMAyrvTRH681dQdhpV1nxg9Z3/p0h65OPBjCcEwm2zCSD
         l7mKfmH6gVmPwbR6LXGiDxxI/f/giYuI0wFxf7nCBgBRSyApw4lg8+AoB0IT50zfUu6Z
         HljV1gDxxQZ45dMAoDlvAmySIdk18OdKyXFlN5npXpEZDygQ1y0LYiSfb7Lx6IWSMUih
         i3yrJi8sVbntAbFbWObAmWARabCBxtZqf6Gq5NV8Va3I9LAlDSiBZKYvhXeP7+Ox9l0d
         MxFQ==
X-Gm-Message-State: AO0yUKWtBc4KRIc3HGdopamEBVNsvk8IjOo1FMm3ufvrnz2Ypwd5M2vz
        AkVWPYIPElRiyyu+p/66dKJBXw==
X-Google-Smtp-Source: AK7set+BmZtVxjSiExjRciXj4iu4AswXVOqK7ahGer1JspHdlO4S1Xv8EqAaO8/tgqfzEr/CPfuOjA==
X-Received: by 2002:adf:eccf:0:b0:2c7:e424:eeb8 with SMTP id s15-20020adfeccf000000b002c7e424eeb8mr8344937wro.57.1677515571554;
        Mon, 27 Feb 2023 08:32:51 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:6caa:9121:bec9:a2a9? ([2a02:6b6a:b566:0:6caa:9121:bec9:a2a9])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe947000000b002c70f5627d5sm7389120wrn.63.2023.02.27.08.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 08:32:51 -0800 (PST)
Message-ID: <0f4dc622-6273-8abc-bf9a-d4f737ccb8e9@bytedance.com>
Date:   Mon, 27 Feb 2023 16:32:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v12 00/11] Parallel CPU bringup for x86_64
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        tglx@linutronix.de, kim.phillips@amd.com, brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
References: <20230226110802.103134-1-usama.arif@bytedance.com>
 <5650744.DvuYhMxLoT@natalenko.name>
 <819d8fa2-b73e-e32f-5442-452aa2c0d752@bytedance.com>
 <5e8ad90a-1dc6-95c2-e020-5e95da6f9eda@bytedance.com>
 <90c7efe278fed0616275ed64215ec1fe249f16f5.camel@infradead.org>
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <90c7efe278fed0616275ed64215ec1fe249f16f5.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27/02/2023 15:29, David Woodhouse wrote:
> On Mon, 2023-02-27 at 06:14 +0000, Usama Arif wrote:
>>
>> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
>> index 17bdd6122dca..5d709aa67df4 100644
>> --- a/arch/x86/kernel/head_64.S
>> +++ b/arch/x86/kernel/head_64.S
>> @@ -273,7 +273,11 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify,
>> SYM_L_GLOBAL)
>>           cmpl    (%rbx,%rcx,4), %edx
>>           jz      .Lsetup_cpu
>>           inc     %ecx
>> +#if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
>> +       cmpl    $NR_CPUS, %ecx
>> +#else
>>           cmpl    nr_cpu_ids(%rip), %ecx
>> +#endif
>>           jb      .Lfind_cpunr
>>
>>           /*  APIC ID not found in the table. Drop the trampoline lock
>> and bail. */
> 
> The whitespace looks dodgy there but maybe that's just your mail client?
> 
> Given this code is already in #ifdef CONFIG_SMP, can NR_CPUS be 1?

Ah yes, we have

config NR_CPUS_RANGE_BEGIN
	int
	default NR_CPUS_RANGE_END if MAXSMP
	default    1 if !SMP
	default    2

in arch/x86/Kconfig which doesn't let us select 1 for NR_CPUS if SMP is 
enabled, so this should be enough
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 17bdd6122dca..c79ae67492e1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -273,7 +273,11 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, 
SYM_L_GLOBAL)
         cmpl    (%rbx,%rcx,4), %edx
         jz      .Lsetup_cpu
         inc     %ecx
+#if defined(CONFIG_FORCE_NR_CPUS)
+       cmpl    $NR_CPUS, %ebx
+#else
         cmpl    nr_cpu_ids(%rip), %ecx
+#endif
         jb      .Lfind_cpunr
