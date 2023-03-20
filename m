Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EC26C1A71
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjCTP4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 11:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjCTP4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 11:56:03 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE8A1B54B
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:47:37 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so9454537wmb.5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 08:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679327256;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=703RDtzK5aHBgd1F3RzHtlXSIxMPVA8GxQPmUARvs7g=;
        b=BjqaExN/LKmn5OeTxyUL6JrGqpABOM6tnX1rjdmokdWuIDt9IE2+RtNIJxDlZX+UdD
         /WJh/7wE9ibdDvmw1MUicV/9r0hJE1aRcJom8zzkWGOUycXMUAbVmAB4LQtUYCPrzdzR
         CBl43XJdFTwVRC7RgBIbQxO+taTuER/j8y4YvbwTchhOwm4RAlRdazdhLiixotxXlCCD
         i3P7wFw8qjVtZNfboRHgoCM/DandYmpQkuvXziXcub4/R/L52EKLBMlkhYm7s8VTseLY
         BHMkuZ/BDSmp/uegBS8pi4pueNwV1n6OSYSO3c8LiRzS4hxQ7HR4AJYD0INffM5ARpv1
         IykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327256;
        h=content-transfer-encoding:in-reply-to:from:cc:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=703RDtzK5aHBgd1F3RzHtlXSIxMPVA8GxQPmUARvs7g=;
        b=SYxR/FyugZxHS0fym61RT+y4XejkV8yTYIY7JrjfkdYCSrIkJf/PDSyKf0IoO6GPXb
         Vc+eA4PuttyoZBP7L1e+r+zfZpZMT+jpuR2EOT+XJz36q8Dz1G8wdrIE+Oqh9TyYlAeP
         I7mxHtXE7JNTzIEvVY+zWYhf1RWL6GtmuQzt4bTLDhHcET+qDmspFhSfk47P88bIZFx9
         xiX6Pk7lvzFqauTyyd4ql6tKeSEFPVKmj5vf8qsiGO8Lth5dWbuTDhA2rYJfGYI541jd
         t5InB+QQS8VrUdTYQjGFcD0BTa6GoZyFblFUScLLa2Rs9+PkmZULkMJVYX8MRPS+EGSP
         xFDQ==
X-Gm-Message-State: AO0yUKXAWggerzAzCrHaodUNfkEXEAFs5jkpisgAGl9eeVl+ejwBVnsd
        +HSQZ7U+vHcmiaAFuKe+3yJ0OA==
X-Google-Smtp-Source: AK7set8oBw1PIRS3MshO0LCSlLZeMQAAh25+LtrkjAdNcVPhcFUP4Ze/WbgNM59FgOJ7LXmw6DDbug==
X-Received: by 2002:a7b:c382:0:b0:3ed:2949:985b with SMTP id s2-20020a7bc382000000b003ed2949985bmr4100wmj.23.1679327256272;
        Mon, 20 Mar 2023 08:47:36 -0700 (PDT)
Received: from [192.168.30.216] ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id l26-20020a05600c2cda00b003dd1bd0b915sm16964570wmc.22.2023.03.20.08.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 08:47:35 -0700 (PDT)
Message-ID: <393c8070-e126-70de-4e85-11ac41d6f6be@linaro.org>
Date:   Mon, 20 Mar 2023 16:47:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: KVM call for agenda for 2023-03-21
Content-Language: en-US
To:     quintela@redhat.com, qemu-devel <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <87zg8aj5z3.fsf@secure.mitica>
Cc:     Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Bernhard Beschow <shentey@gmail.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <87zg8aj5z3.fsf@secure.mitica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Juan,

On 18/3/23 18:59, Juan Quintela wrote:
> 
> Hi
> 
> NOTE, NOTE, NOTE
> 
> Remember that we are back in that crazy part of the year when daylight
> saving applies.  Call is done on US timezone.  If you are anything else,
> just doublecheck that it is working for you properly.
> 
> NOTE, NOTE, NOTE
> 
> Topics in the backburner:
> - single qemu binary
>    Philippe?

Well we wanted a slot to discuss a bit the design problems we have
around some PCI-to-ISA bridges like the PIIX and VIA south bridges.

One of the main problem is figure how to instantiate circular IRQs
with QOM. Ex:

   devA exposes irqAo output
        wires to irqAi input

   devB exposes irqBo output
        wires to irqBi input

How to wire irqAo -> irqBi *AND* irqBo -> irqAi?

However personally I was busy with debugging issues opened for the
8.0 release, and it is probably very late to schedule with Mark and
Bernhard for tomorrow...

> - The future of icount.
>    Alex?  My understanding is that you are interested in
>    qemu 8.1 to open.
> 
> Anything else?
> 
> 
> Please, send any topic that you are interested in covering.
> 
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
