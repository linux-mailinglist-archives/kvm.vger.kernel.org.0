Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43FF6C24C1
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCTW2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjCTW2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:28:09 -0400
X-Greylist: delayed 2318 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Mar 2023 15:28:07 PDT
Received: from mail.ilande.co.uk (mail.ilande.co.uk [IPv6:2001:41c9:1:41f::167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733A39004
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
        Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
        :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WyY8B4viD4bbQ+bFV2SBsFF2kC5CdxEpDJvMdyYf1TY=; b=PYiYoZPPC0ELlnHt8BthSJV1gJ
        bgv5NzvfOCQ5tdjinwmuvyiHO1+sxSBq8XdbF4qIUT5FJ3Ge8+UmQah5ULiPmFxLxg6yHM8Oim7t4
        IfbBSG1nm1vcsio6LifbGsPK468bwdGDDkx+tXS47wj8Y90SmbKtrBsERbNG42uvf8naHm24toyaC
        zCb+VRgtIXTgbzNGJzClEPVTwfTve/DSxjz98L3JzUVUXtIht33PwB2D45ayI7OwuYX9ZRC6gz/Jp
        0ZhjIFUC5J7hiUDU74IRv8ScYLLsSquUTEFLLlFe33mpXNGvt3ApZ4+/WLRw9avJr0fq6Ed//yMHi
        FUQjqaY91JsAoVfnZOgv1GQxs6o+EPHLEa8DXWpRZydsWqOerrcxv68N5r974Tzl0lQeTRT7l3EMI
        7bA28y0pi60+PU2xAEoYlIexaC9Tyk0mt71NWxacwCKvjiTLbCEBEXxvugduOdnD2bgRTV1SejvT7
        oeP8WTcgcw8Euw7JUyxeE1w1bCeqUqI9zY7ZZElVgpr3/64QI3FrCW7Gq8fav2GMIBOu8idrCGBj3
        06bCdtoP0ApohM69/QVHJFJYRDx8P6vsPZWJ9SNo91UYDNgqz8zL3ruApXl//f0/RWBmdMMtVzEn1
        c94hFWqDjsU20i05fXyda9EKkPYOxPt9rRqea9keg=;
Received: from [2a00:23c4:8bac:200:3870:f067:8488:5afb]
        by mail.ilande.co.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <mark.cave-ayland@ilande.co.uk>)
        id 1peNMz-000B2U-8K; Mon, 20 Mar 2023 21:48:45 +0000
Message-ID: <b971a675-065e-4e0a-a9bc-babc244ff21b@ilande.co.uk>
Date:   Mon, 20 Mar 2023 21:49:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        quintela@redhat.com, qemu-devel <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Bernhard Beschow <shentey@gmail.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
References: <87zg8aj5z3.fsf@secure.mitica>
 <393c8070-e126-70de-4e85-11ac41d6f6be@linaro.org>
From:   Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <393c8070-e126-70de-4e85-11ac41d6f6be@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a00:23c4:8bac:200:3870:f067:8488:5afb
X-SA-Exim-Mail-From: mark.cave-ayland@ilande.co.uk
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: KVM call for agenda for 2023-03-21
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on mail.ilande.co.uk)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/2023 15:47, Philippe Mathieu-Daudé wrote:

> Hi Juan,
> 
> On 18/3/23 18:59, Juan Quintela wrote:
>>
>> Hi
>>
>> NOTE, NOTE, NOTE
>>
>> Remember that we are back in that crazy part of the year when daylight
>> saving applies.  Call is done on US timezone.  If you are anything else,
>> just doublecheck that it is working for you properly.
>>
>> NOTE, NOTE, NOTE
>>
>> Topics in the backburner:
>> - single qemu binary
>>    Philippe?
> 
> Well we wanted a slot to discuss a bit the design problems we have
> around some PCI-to-ISA bridges like the PIIX and VIA south bridges.
> 
> One of the main problem is figure how to instantiate circular IRQs
> with QOM. Ex:
> 
>    devA exposes irqAo output
>         wires to irqAi input
> 
>    devB exposes irqBo output
>         wires to irqBi input
> 
> How to wire irqAo -> irqBi *AND* irqBo -> irqAi?
> 
> However personally I was busy with debugging issues opened for the
> 8.0 release, and it is probably very late to schedule with Mark and
> Bernhard for tomorrow...

Yeah unfortunately it's impossible for me to guarantee I'll be around for the call on 
Tuesdays, but then I've also had an idea that models the hardware in a different way 
so that circular IRQs aren't needed. I'm a bit backlogged with QEMU bits and pieces 
this week, so it will take a little time to come up with a suitable proposal.


ATB,

Mark.
