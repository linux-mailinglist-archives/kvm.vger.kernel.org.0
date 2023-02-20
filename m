Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B6C69D649
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 23:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbjBTWYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 17:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjBTWYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 17:24:14 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDBE10AA6
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 14:23:46 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id p26so1908111wmc.4
        for <kvm@vger.kernel.org>; Mon, 20 Feb 2023 14:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LczbbPN2kv2frYuEgJiCHxGTOf36S6cKvzlYYeWhcYc=;
        b=ikrp60BCJBudlPSFvolBO82G/COksPn0tDwAWENWUOYwuM+9Db3zUrF8CjanQXljgW
         zQECHzWScYM4p2vVrTeJ69Ss97PnrJLrz7HdICQ+nmYJ/xj94ZrUb1JLnUbn/KceYw+0
         kWsNMaf0qtj1JK6GHbVFFRaIxquzLtxKirbRT3vW1vRq9OmmlEl5Vjr7wX4caqWoEeUJ
         BflbeggOi576F6hy0EeVpww7CTAaPZ5ha+/GaIC29JTCGX2KFjzqIrNQUVy5ZCydpSxP
         yyaRWb+if1u/4D6sM/yRlXsHS6a7oxVyJwpR8v+iIQ09K2JvIWB8X7WsuLa4Q5zdvj1M
         5lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LczbbPN2kv2frYuEgJiCHxGTOf36S6cKvzlYYeWhcYc=;
        b=dBf8iyRrKsXiEUiHec0K6e83GxQxKu6F3aSmZo7GJKMPBI6JBJxjTO2gZa7MLt2tZ0
         1fTVa0+zgI5gO74djyA5U1o7Gm/P/rTbTHvBlb8YJqH6t70Sbc1ahM9NyBaROqObVJZC
         /hNZw30yFHp4oxrHBJQcCpRNasMSxkCXSFbGMN9KG6f0cfcQG3HHj3+6jFZmTiU6hECU
         QBl7GfmWP3uX5hXnO5SyTj9QbgcHSg5AzUwkW9WDSrxHMMJOkvo/49gNaO/Tqu8Dvr/3
         qM651VCnVPJhGIw1LP/nkdefcrRchkdNiLFFfg31AQNCuiFgz1BzDQY6+bP94yLt9PVm
         /dFg==
X-Gm-Message-State: AO0yUKWT/+2jB95SQl79l1DrbIfspFKuUkZ9wiYCMLiuTa1pWE5v/j2z
        9kJUFtSQX6cqvShztqTFCVQ8nA==
X-Google-Smtp-Source: AK7set/AoVRk1CSi530XSOQqXgKgQFGwnbmmgQs7zjKPPMKULilagc+ntPnuh70+ZOczY+cFJWCFww==
X-Received: by 2002:a05:600c:80f:b0:3df:e46f:c226 with SMTP id k15-20020a05600c080f00b003dfe46fc226mr1217438wmp.16.1676931825044;
        Mon, 20 Feb 2023 14:23:45 -0800 (PST)
Received: from ?IPV6:2a02:6b6a:b566:0:8498:f303:14d8:47b5? ([2a02:6b6a:b566:0:8498:f303:14d8:47b5])
        by smtp.gmail.com with ESMTPSA id x8-20020a1c7c08000000b003dc4480df80sm1468425wmc.34.2023.02.20.14.23.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 14:23:44 -0800 (PST)
Message-ID: <4a7b863c-469d-ea61-fc49-7aa8c819bb73@bytedance.com>
Date:   Mon, 20 Feb 2023 22:23:43 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     tglx@linutronix.de, kim.phillips@amd.com, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Piotr Gorski <lucjan.lucjanov@gmail.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
Content-Language: en-US
From:   Usama Arif <usama.arif@bytedance.com>
In-Reply-To: <982e1d6140705414e8fd60b990bd259a@natalenko.name>
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



On 20/02/2023 21:23, Oleksandr Natalenko wrote:
> Hello.
> 
> On 20.02.2023 21:31, David Woodhouse wrote:
>> On Mon, 2023-02-20 at 17:40 +0100, Oleksandr Natalenko wrote:
>>> On pondělí 20. února 2023 17:20:13 CET David Woodhouse wrote:
>>> > On Mon, 2023-02-20 at 17:08 +0100, Oleksandr Natalenko wrote:
>>> > >
>>> > > I've applied this to the v6.2 kernel, and suspend/resume broke on
>>> > > my
>>> > > Ryzen 5950X desktop. The machine suspends just fine, but on
>>> > > resume
>>> > > the screen stays blank, and there's no visible disk I/O.
>>> > >
>>> > > Reverting the series brings suspend/resume back to working state.
>>> >
>>> > Hm, thanks. What if you add 'no_parallel_bringup' on the command
>>> > line?
>>>
>>> If the `no_parallel_bringup` param is added, the suspend/resume
>>> works.
>>
>> Thanks for the testing. Can I ask you to do one further test: apply the
>> series only as far as patch 6/8 'x86/smpboot: Support parallel startup
>> of secondary CPUs'.
>>
>> That will do the new startup asm sequence where each CPU finds its own
>> per-cpu data so it *could* work in parallel, but doesn't actually do
>> the bringup in parallel yet.
> 
> With patches 1 to 6 (including) applied and no extra cmdline params 
> added the resume doesn't work.
> 
>> Does your box have a proper serial port?
> 
> No, sorry. I know it'd help with getting logs, and I do have a 
> serial-to-USB cable that I use for another machine, but in this one the 
> port is not routed to outside. I think I can put a header there as the 
> motherboard does have pins, but I'd have to buy one first. In theory, I 
> can do that, but that won't happen within the next few weeks.
> 
> P.S. Piotr Gorski (in Cc) also reported this: "My friend from CachyOS 
> can confirm bugs with smpboot patches. AMD FX 6300 only shows 1 core 
> when using smp boot patchset". Probably, he can reply to this thread and 
> provide more details.
> 

Hi Oleksandr,

So for initial boot, do all CPUs comes up for you when parallel smp boot 
is enabled or only 1?

I don't have access to Ryzen hardware so can only say from code, but it 
would be weird if initial boot is fine but resume is broken if the same 
code path is being taken.

Thanks,
Usama
