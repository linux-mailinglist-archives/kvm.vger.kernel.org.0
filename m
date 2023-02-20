Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DA469D5E5
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 22:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjBTVkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 16:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBTVke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 16:40:34 -0500
X-Greylist: delayed 350 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Feb 2023 13:40:32 PST
Received: from mail.ptr1337.dev (mail.ptr1337.dev [202.61.224.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6921A665;
        Mon, 20 Feb 2023 13:40:32 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 668F1280210;
        Mon, 20 Feb 2023 22:34:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cachyos.org; s=dkim;
        t=1676928877; h=from:subject:date:message-id:to:mime-version:content-type:
         content-transfer-encoding:content-language:in-reply-to:references;
        bh=Ol4kJPN1FGj3D0wZh79xPVHLrHqfMZsGnENgoQj18jc=;
        b=FC9Hn2clk4ydnfjqyfWMRoivvDV5TRvjSeEpXCAfpg1IKPa3zp+i4jAXrqrg8QqXvr5HbS
        EfhVWyDhK/CL8jWeIt1Rqk4rLyT6vEExuEc0Ph8de88FCqbEN+fMAOT2eZgI5p1XW/JH/l
        YewE0AiPz1ksIUkOXMzrAATA/Nxetj8e51wSq5BjcoLRWHJgNDHpoO6Bm0XUamkp2r2sRv
        05gdISBjJkPm88WcG9mZEEDzEs4NYN4y4EabzlS93WzG9NvJtOJHD1ffXOsuy4gLAlF5SX
        HpJZfSe0RKJ80i6u6LQhnjAsCCiHD0C335mf6uwvYP4htphlMMBIQgnfQXhz8w==
Message-ID: <bd0cdf23-080a-eb83-a587-fb6d785cafdf@cachyos.org>
Date:   Mon, 20 Feb 2023 22:34:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
 <2668869.mvXUDI8C0e@natalenko.name>
 <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org>
 <982e1d6140705414e8fd60b990bd259a@natalenko.name>
Content-Language: pl-PL, en-US
From:   Piotr Gorski <piotrgorski@cachyos.org>
To:     ukryci-adresaci:;
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
smp boot patchset, so mentioned Oleksandr. Probably soon the friend will 
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
