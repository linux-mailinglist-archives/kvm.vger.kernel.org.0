Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1916A72A8EB
	for <lists+kvm@lfdr.de>; Sat, 10 Jun 2023 05:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjFJDvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 23:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233647AbjFJDvY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 23:51:24 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE903C17
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 20:51:10 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-53fbb3a013dso1418741a12.1
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 20:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1686369069; x=1688961069;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=keZFtC4q7nGqwkwPIt24fKDWj9qoKt9aTQihY50Kp8I=;
        b=Si9MEC3oTAJhiURwtR8P5gVAaFxtWeTt850pFCJE48TwO99/bFDala+9/5+PbDVLP4
         iCd4T6/vbnRzkSGJdzXESOquK+mfbnbjOA8RMhBRuSw1mqzZEFVJv4VeuflGpkijj6Bi
         45UbVXXFLhUbSB1gsTUnlD1NATbxruaSIyGyilw3INO28GBhXmegHNOrsehGYMF7WNeD
         M2zhJNJ1SmN1NNEBqO6JHQx4zuRiAPPQusGd+6coYUNqndZ9rfSygFqc2X+QcKL28igi
         FD31RcQ/ry5ySNQASN/nSws+Zt+ISzk7AtsdzIlbtIVkS0sDJMu7sFWVGDNFyDbmlf3c
         8jsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686369069; x=1688961069;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=keZFtC4q7nGqwkwPIt24fKDWj9qoKt9aTQihY50Kp8I=;
        b=A3lcHHuqXP6636pORysSU4nrFbr/Bq2dK6UXAZNoeobmQ0bG3Bcw8Of0Af+8KZVBb4
         K2hy+7ENBKsj9uWD9Jkh87qukJhPVnDNyNWKPz5TnCVX6s9VExxdzqBtQpyn2Bm8KAGi
         e22QEx/9pZud7FSCu8fWFrKhRQbeVR/BLz7TFIH3mqRc1c7sX1keBrnOGhR9TxCfwSg+
         6+caA0cqI1H7ZVycRpxagOFQrWdPOXgV0b72f0/onj25J2W6XBv5TE+o2nde8MKPX4dw
         vYMFavD7zECK1IJtFKGImXUoBSMTpJGXffy9Rm3oZA8GbDGWHuldU13YdAvTeQRczwna
         6pOQ==
X-Gm-Message-State: AC+VfDw41BxDburhrqFAiDjyQrnLcsPXt8485UHBa2sCbayOi5ETcJke
        FWgAjIuDRM9YDx9cQeWnnEM3e+LLdDydyXDnjUk=
X-Google-Smtp-Source: ACHHUZ7yCMAmE2exlUNJ1g0D+dgZViDTjS54GrGA//Ko8QotzeAqgDXs0V94Z/TLFIcvE2Jcy8wWhQ==
X-Received: by 2002:a17:90b:1d0e:b0:259:bf3e:5f8b with SMTP id on14-20020a17090b1d0e00b00259bf3e5f8bmr3286706pjb.17.1686369069601;
        Fri, 09 Jun 2023 20:51:09 -0700 (PDT)
Received: from [157.82.204.253] ([157.82.204.253])
        by smtp.gmail.com with ESMTPSA id im16-20020a170902bb1000b001b008b3dee2sm3985040plb.287.2023.06.09.20.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 20:51:09 -0700 (PDT)
Message-ID: <ed62645a-ec48-14ff-4b7e-15314a0da30e@daynix.com>
Date:   Sat, 10 Jun 2023 12:51:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
Content-Language: en-US
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221201102728.69751-1-akihiko.odaki@daynix.com>
 <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com>
 <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com>
In-Reply-To: <a3cc1116-272d-a8e5-a131-7becf98115e0@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/01 20:00, Akihiko Odaki wrote:
> On 2022/12/01 19:40, Peter Maydell wrote:
>> On Thu, 1 Dec 2022 at 10:27, Akihiko Odaki <akihiko.odaki@daynix.com> 
>> wrote:
>>>
>>> A register access error typically means something seriously wrong
>>> happened so that anything bad can happen after that and recovery is
>>> impossible.
>>> Even failing one register access is catastorophic as
>>> architecture-specific code are not written so that it torelates such
>>> failures.
>>>
>>> Make sure the VM stop and nothing worse happens if such an error occurs.
>>>
>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>
>> In a similar vein there was also
>> https://lore.kernel.org/all/20220617144857.34189-1-peterx@redhat.com/
>> back in June, which on the one hand was less comprehensive but on
>> the other does the plumbing to pass the error upwards rather than
>> reporting it immediately at point of failure.
>>
>> I'm in principle in favour but suspect we'll run into some corner
>> cases where we were happily ignoring not-very-important failures
>> (eg if you're running Linux as the host OS on a Mac M1 and your
>> host kernel doesn't have this fix:
>> https://lore.kernel.org/all/YnHz6Cw5ONR2e+KA@google.com/T/
>> then QEMU will go from "works by sheer luck" to "consistently
>> hits this error check"). So we should aim to land this extra
>> error checking early in the release cycle so we have plenty of
>> time to deal with any bug reports we get about it.
>>
>> thanks
>> -- PMM
> 
> Actually I found this problem when I tried to run QEMU with KVM on M2 
> MacBook Air and encountered a failure described and fixed at:
> https://lore.kernel.org/all/20221201104914.28944-2-akihiko.odaki@daynix.com/
> 
> Although the affected register was not really important, QEMU couldn't 
> run the guest well enough because kvm_arch_put_registers for ARM64 is 
> written in a way that it fails early. I guess the situation is not so 
> different for other architectures as well.
> 
> I still agree that this should be postponed until a new release cycle 
> starts as register saving/restoring is too important to fail.
> 
> Regards,
> Akihiko Odaki

Hi,

QEMU 8.0 is already released so I think it's time to revisit this.

Regards,
Akihiko Odaki
