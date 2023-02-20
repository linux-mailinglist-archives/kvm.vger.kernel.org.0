Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6E869D646
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 23:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjBTWWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 17:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjBTWWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 17:22:10 -0500
Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F311C329;
        Mon, 20 Feb 2023 14:22:09 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 89E3E2802CD;
        Mon, 20 Feb 2023 23:22:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
        t=1676931727; h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-transfer-encoding:content-language:in-reply-to:references;
        bh=FE7tH2bfK+sj0nuIj5rgHwQBAVYpoT4rus2zI73ZO4w=;
        b=fk8kiYumtAedeU0R51G0+7UXcCTlgj9pYY4JuNAtaePNXG+USfRpI/uSuw+ue1ZxSC8cMK
        om4xzw1mVyQHp3gvlQ5BX9Ocb/3SnIEVSoP/LLouKJDKQEJV/saN0nxskplNe0l/2afcj4
        BwChCMwEILY0S95UujBA4FMXpgVi7pktNaWsRWNIu6H9WFb939U7qA/FL7BL2SN7J0//Bz
        o2FRjbJVU61xPZh42ozPCJzR24mmHOzghBoKdDrUyqTtS4Q0PcXvqVQHYi59yBrDE38KOD
        CMnsUkLfJFlb/d+59hrey2/Y1y7FOmAGTpVrVHJFg2Wf5cNSgjNBA0SLazX2Ug==
Message-ID: <84737fa2-1838-cb7d-7624-5eb9a46a4d0e@cachyos.org>
Date:   Mon, 20 Feb 2023 23:22:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
To:     Oleksandr Natalenko <oleksandr@natalenko.name>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     tglx@linutronix.de, kim.phillips@amd.com,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
Content-Language: pl-PL, en-US
From:   Piotr Gorski <piotrgorski@cachyos.org>
In-Reply-To: <982e1d6140705414e8fd60b990bd259a@natalenko.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

In my case, admittedly, the error does not occur, while I have 
information from a friend that AMD FX 6300 only shows 1 core when using 
smp boot patchset, so mentioned Oleksandr. Probably soon friend will 
join the discussion and will be able to provide more information.

W dniu 20.02.2023 o 22:23, Oleksandr Natalenko pisze:
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
> serial-to-USB cable that I use for another machine, but in this one 
> the port is not routed to outside. I think I can put a header there as 
> the motherboard does have pins, but I'd have to buy one first. In 
> theory, I can do that, but that won't happen within the next few weeks.
>
> P.S. Piotr Gorski (in Cc) also reported this: "My friend from CachyOS 
> can confirm bugs with smpboot patches. AMD FX 6300 only shows 1 core 
> when using smp boot patchset". Probably, he can reply to this thread 
> and provide more details.
>
