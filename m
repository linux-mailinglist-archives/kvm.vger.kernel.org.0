Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337AA3AD4A7
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 23:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbhFRV5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 17:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234714AbhFRV5n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 17:57:43 -0400
Received: from forward105o.mail.yandex.net (forward105o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B4DC061760
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 14:55:33 -0700 (PDT)
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward105o.mail.yandex.net (Yandex) with ESMTP id F21844201896;
        Sat, 19 Jun 2021 00:55:30 +0300 (MSK)
Received: from vla1-faefe240866f.qloud-c.yandex.net (vla1-faefe240866f.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:98f:0:640:faef:e240])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id EC8C97080002;
        Sat, 19 Jun 2021 00:55:30 +0300 (MSK)
Received: from vla5-3832771863b8.qloud-c.yandex.net (vla5-3832771863b8.qloud-c.yandex.net [2a02:6b8:c18:3417:0:640:3832:7718])
        by vla1-faefe240866f.qloud-c.yandex.net (mxback/Yandex) with ESMTP id a9JpwdzLSo-tUHC5WxU;
        Sat, 19 Jun 2021 00:55:30 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624053330;
        bh=97vijMOZ1VfUvPQYfr3RTIKvAyu4D0r6o/vMLP8vcOw=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=vqCRBcdxGNTr7QV9yWi3kjzZ3gTeZGyAPBjdFOxV9zYCAINNvnahY1i5g+YsAPKC4
         7JxUzLhPrSRtit6CH9Y1crOcGvW7JRd5KoAVIBIb5l2JlYuP8H0Z5OQaenF6HOzleW
         QpN8nPum87AxwaLi+RyszlSVTvotBtW2GG1CcPhU=
Authentication-Results: vla1-faefe240866f.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-3832771863b8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id KBsLTu8ioB-tU30VpNI;
        Sat, 19 Jun 2021 00:55:30 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: guest/host mem out of sync on core2duo?
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
Date:   Sat, 19 Jun 2021 00:55:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

19.06.2021 00:07, Jim Mattson пишет:
> On Fri, Jun 18, 2021 at 9:02 AM stsp <stsp2@yandex.ru> wrote:
>
>> Here it goes.
>> But I studied it quite thoroughly
>> and can't see anything obviously
>> wrong.
>>
>>
>> [7011807.029737] *** Guest State ***
>> [7011807.029742] CR0: actual=0x0000000080000031,
>> shadow=0x00000000e0000031, gh_mask=fffffffffffffff7
>> [7011807.029743] CR4: actual=0x0000000000002041,
>> shadow=0x0000000000000001, gh_mask=ffffffffffffe871
>> [7011807.029744] CR3 = 0x000000000a709000
>> [7011807.029745] RSP = 0x000000000000eff0  RIP = 0x000000000000017c
>> [7011807.029746] RFLAGS=0x00080202         DR7 = 0x0000000000000400
>> [7011807.029747] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
>> [7011807.029749] CS:   sel=0x0097, attr=0x040fb, limit=0x000001a0,
>> base=0x0000000002110000
>> [7011807.029751] DS:   sel=0x00f7, attr=0x0c0f2, limit=0xffffffff,
>> base=0x0000000000000000
> I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers:
>
> * If the guest will not be virtual-8086, the different sub-fields are
> considered separately:
>    - Bits 3:0 (Type).
>      * DS, ES, FS, GS. The following checks apply if the register is usable:
>        - Bit 0 of the Type must be 1 (accessed).

That seems to be it, thank you!
At least for the minimal reproducer
I've done.

So only with unrestricted guest its
possible to ignore that field?


> [7011807.029764] FS:   sel=0x0000, attr=0x10000, limit=0x00000000,
> base=0x0000000000000000
> [7011807.029765] GS:   sel=0x0000, attr=0x10000, limit=0x00000000,
> base=0x0000000000000000
> [7011807.029767] GDTR:                           limit=0x00000017,
> base=0x000000000a708100
> [7011807.029768] LDTR: sel=0x0010, attr=0x00082, limit=0x0000ffff,
> base=0x000000000ab0a000
> [7011807.029769] IDTR:                           limit=0x000007ff,
> base=0x000000000a708200
> [7011807.029770] TR:   sel=0x0010, attr=0x0008b, limit=0x00002088,
> base=0x000000000a706000
> It seems a bit odd that TR and LDTR are both 0x10,  but that's perfectly legal.

This selector is fake.
Our guest doesn't do LLDT or LTR,
so we didn't care to even reserve
the GDT entries for those.

