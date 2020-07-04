Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1482144B5
	for <lists+kvm@lfdr.de>; Sat,  4 Jul 2020 11:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGDJx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Jul 2020 05:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgGDJx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Jul 2020 05:53:27 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201A5C061794
        for <kvm@vger.kernel.org>; Sat,  4 Jul 2020 02:53:27 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id f7so32253737wrw.1
        for <kvm@vger.kernel.org>; Sat, 04 Jul 2020 02:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ou+aNkcv9LCQBlsQrwAFagxbTlyfWRNE7XbCh8l7dyY=;
        b=PZlgAsG9xrZrlG9GhtRUw6gCMGCW3+41JK6uDtFg/i87267w/D5Nc6+xbKTExEdRCe
         Z0mhKRFzF8SFLGLU4LobJBtvgVIhjbjRVHB5s+gUciIZGlmZJJe78PTSBRtVVcR3j/Yf
         OjGD+sjbi5Jkwl5+/xuwF6Xg6nxBWCzW6IzyCm8OEBD3EthN5oK4vaEOfoG2al2Qd/tj
         3n7w1GDkyCc2WhfiFrgOSajhYj1cfoEyv/ONa8KpBDPmxTnberwRt3Uv8459wQ+kWv3w
         F3k4Nc9HrSyZtzPvoAPpsgzzmJaj/YOqzPnl1mZihSkUcHXCf+wuviK8RRwV3UOUkmRe
         SpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ou+aNkcv9LCQBlsQrwAFagxbTlyfWRNE7XbCh8l7dyY=;
        b=Xw05T765v14OHwxvTG17dpoBj/qYi1bCE2ByWDoZ0iEn+18QIItUobM4ABOvtZLMpw
         npnLQfwkPnmpZxB7y21/q922onto7cFzGr/hnOy36EIc4pK6MXYcFdmcMwsp9wce/FJ6
         TdwKIx4KeVNpjhmONmB1bqesq6/MyeaZOGSeTSKJ9s2Yg4XeJA/OHNRNhMyW6+xonqUJ
         GeoUWh8Qa0Zzb8Lh+2HaVBzSwWb8+UB47ep+wHLpD0L8CXmYCpAjHeWxVSaER96h4sPV
         j4IX9tne/ffmHPH6o/MVbZqskjuLQqcAmNYq6Er8vfqYml0BMrh0Dhp2PNY8LOBHKss9
         YnLQ==
X-Gm-Message-State: AOAM531VlXziPLhL1SF/PCdvxtbuFZsBIdGdUW6dgrhHuAj2+vVWqzlg
        klEjiIvKHGdrJgUrRu9BnscZTQlOCx18v2p3tE4gf+ou
X-Google-Smtp-Source: ABdhPJx67XOWygWg7EMQNA6isQXukXMWCSCxVemHzhm/c5V9E7rhqnJJQ8PnFNvub8L9YE0/o8TLLCUjwxxfjN1jVDY=
X-Received: by 2002:adf:ed87:: with SMTP id c7mr38868380wro.422.1593856405871;
 Sat, 04 Jul 2020 02:53:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAG4AFWZ3zd1LEZa6RHbUYyMsT8vGzOJSmw9G0CK-pnpRLv6Hfw@mail.gmail.com>
 <CABgObfbXnYoNNZ9SmF56XHhJ8Lx4bN4L-ZYnGF_UBFfkEMyBHQ@mail.gmail.com>
In-Reply-To: <CABgObfbXnYoNNZ9SmF56XHhJ8Lx4bN4L-ZYnGF_UBFfkEMyBHQ@mail.gmail.com>
From:   Jidong Xiao <jidong.xiao@gmail.com>
Date:   Sat, 4 Jul 2020 03:53:14 -0600
Message-ID: <CAG4AFWbwEtxsvCVyOJ0cvHQ1RNGaCPRMEEmoGzAp-=TRdLExLw@mail.gmail.com>
Subject: Re: KVM upcall questions
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On Sat, Jul 4, 2020 at 3:12 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> KVM has an interrupt MSR that is currently used for asynchronous page faults. It can be extended to general upcalls if useful.
>
> Paolo
>
Thanks! Are you talking about this MSR: MSR_KVM_ASYNC_PF_EN?

I look at the document in the Documentation/virtual/kvm/msr.txt file
and see this:

MSR_KVM_ASYNC_PF_EN: 0x4b564d02
data: Bits 63-6 hold 64-byte aligned physical address of a
64 byte memory area which must be in guest RAM and must be
zeroed....First 4 byte of 64 byte memory location will be written to by
the hypervisor at the time of asynchronous page fault (APF)
injection to indicate type of asynchronous page fault. Value
of 1 means that the page referred to by the page fault is not
present. Value 2 means that the page is now available.

When you say "it can be extended to general upcalls", do you mean we
use a value higher than 2 to represent a different reason, and the
guest will take an action according to that value? Should the return
value of the upcall be written in the 64-byte memory space, or how
does the hypervisor know the return value of the upcall?

-Jidong

> Il sab 4 lug 2020, 11:09 Jidong Xiao <jidong.xiao@gmail.com> ha scritto:
>>
>> Hi, Paolo and all,
>>
>> Do KVM support upcalls, which enable the hypervisor to make requests
>> to the guest? Or if I want to add one more upcall by myself, which
>> part of the KVM code should I examine? I know Xen has implemented
>> upcalls, but I can't find any documents about upcalls in KVM.
>>
>> Thank you!
>>
>> -Jidong
>>
