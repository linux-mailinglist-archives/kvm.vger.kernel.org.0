Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AC77AA0D1
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjIUUtI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjIUUsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:48:31 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4EA81FD6
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:36:25 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3adf115ba79so802424b6e.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695317785; x=1695922585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/74XBA4XDm+i+o0t1C5ivQvEuNkPqqhN1c6kqQJV2tU=;
        b=ervVSqDXmVrMj1tg/uDZZAySs0OtldRB8ggGwQRoS60cKxuDaLQ5Tot2rpmDEKXQgj
         hQSYJx2BJhAbFjh6dJLDy96OyDd+EPMQDu8K7dZKdBI0gqoTHyndu/Ie3kapwcH44G6y
         +rA2zoZ+sdthWsZJWMCJO99NC8pbPRmiAPPTVONC+SQmyQ7MWvgfOlfdb4gc4eN4StdA
         8GLDa+R6aWTXliDy58BPTTK41mWH5ttJQYOdwW2ERgJ8voyJoYSEABSk9n9TurpLQVxH
         zUYympJk0dRDx7/P2b7Sx+PCgobtM/IbqSA4q9i7OwiFoL3j0xAHj45i3Spp/+6UBTlU
         Ee3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317785; x=1695922585;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/74XBA4XDm+i+o0t1C5ivQvEuNkPqqhN1c6kqQJV2tU=;
        b=EtzFAe1onTECmVeHqUlbuJyLuQo1ROyuzQNToBZJYzNHsNsBffFFFFOfuSK23kTqs6
         c6uO8SkrpC/ATLw3ZbtniXJrT+wT0SDG5MjBuXq8RYxQaPRLW62TVBk6AD7CsOdKtW6r
         BRLMamJKybsreoyW+XM2cbjkK/54nhO44en339dTqOGHb27ASd6rHyLPMypWnkeSAx1M
         nMXsKjkPckD6fuJIBztkm222u1Xt2M6Up/nlTDxa1ApCxPZv1tGUUO9ISIYg1CnIXEqQ
         9jYz0nTrT1E2gFH7Q8siDwQftF3QSk3SU/V3xHvALCuKhenxyC9CkXpe91x6uBlJz66o
         37lQ==
X-Gm-Message-State: AOJu0Yy3P3z8OO+ZYHVQynvEWDCvoVe4wP/FWRqqtOtzInMK+48wB6Eo
        dRZaJ/LhkZmuP03wEhjG8/mPLTvDss5Om8wH2Lc=
X-Google-Smtp-Source: AGHT+IHL3mhTdrZoBqHBqUOhbYs8XRD3azvm/y/EID/gPJe7YlpAjBMZhSwCCYY0msQJJ4bYCKo7dg==
X-Received: by 2002:a05:6808:c2:b0:3a7:55f2:552d with SMTP id t2-20020a05680800c200b003a755f2552dmr4524575oic.58.1695281109036;
        Thu, 21 Sep 2023 00:25:09 -0700 (PDT)
Received: from ?IPV6:2400:4050:a840:1e00:78d2:b862:10a7:d486? ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id fe18-20020a056a002f1200b0069102aa1918sm658750pfb.48.2023.09.21.00.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 00:25:08 -0700 (PDT)
Message-ID: <a5cd5a46-7f33-42b6-99eb-b09159af42d7@daynix.com>
Date:   Thu, 21 Sep 2023 16:25:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221201102728.69751-1-akihiko.odaki@daynix.com>
 <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com>
 <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com>
 <ed62645a-ec48-14ff-4b7e-15314a0da30e@daynix.com>
 <CAFEAcA-pOKf1r+1BzURpv5FnFS79D2V=SSeY_a2Wene1wf+P1A@mail.gmail.com>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA-pOKf1r+1BzURpv5FnFS79D2V=SSeY_a2Wene1wf+P1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/06/19 21:19, Peter Maydell wrote:
> On Sat, 10 Jun 2023 at 04:51, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> On 2022/12/01 20:00, Akihiko Odaki wrote:
>>> On 2022/12/01 19:40, Peter Maydell wrote:
>>>> On Thu, 1 Dec 2022 at 10:27, Akihiko Odaki <akihiko.odaki@daynix.com>
>>>> wrote:
>>>>>
>>>>> A register access error typically means something seriously wrong
>>>>> happened so that anything bad can happen after that and recovery is
>>>>> impossible.
>>>>> Even failing one register access is catastorophic as
>>>>> architecture-specific code are not written so that it torelates such
>>>>> failures.
>>>>>
>>>>> Make sure the VM stop and nothing worse happens if such an error occurs.
>>>>>
>>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>>
>>>> In a similar vein there was also
>>>> https://lore.kernel.org/all/20220617144857.34189-1-peterx@redhat.com/
>>>> back in June, which on the one hand was less comprehensive but on
>>>> the other does the plumbing to pass the error upwards rather than
>>>> reporting it immediately at point of failure.
>>>>
>>>> I'm in principle in favour but suspect we'll run into some corner
>>>> cases where we were happily ignoring not-very-important failures
>>>> (eg if you're running Linux as the host OS on a Mac M1 and your
>>>> host kernel doesn't have this fix:
>>>> https://lore.kernel.org/all/YnHz6Cw5ONR2e+KA@google.com/T/
>>>> then QEMU will go from "works by sheer luck" to "consistently
>>>> hits this error check"). So we should aim to land this extra
>>>> error checking early in the release cycle so we have plenty of
>>>> time to deal with any bug reports we get about it.
> 
>>> Actually I found this problem when I tried to run QEMU with KVM on M2
>>> MacBook Air and encountered a failure described and fixed at:
>>> https://lore.kernel.org/all/20221201104914.28944-2-akihiko.odaki@daynix.com/
>>>
>>> Although the affected register was not really important, QEMU couldn't
>>> run the guest well enough because kvm_arch_put_registers for ARM64 is
>>> written in a way that it fails early. I guess the situation is not so
>>> different for other architectures as well.
>>>
>>> I still agree that this should be postponed until a new release cycle
>>> starts as register saving/restoring is too important to fail.
> 
>> Hi,
>>
>> QEMU 8.0 is already released so I think it's time to revisit this.
> 
> Two months ago would have been a better time :-) We're heading up
> towards softfreeze for 8.1 in about three weeks from now.
> 
> thanks
> -- PMM

Hi Peter,

Please apply this.

Regards,
Akihiko Odaki
