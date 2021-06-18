Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14F03AD500
	for <lists+kvm@lfdr.de>; Sat, 19 Jun 2021 00:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhFRW2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 18:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhFRW2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 18:28:20 -0400
Received: from forward105o.mail.yandex.net (forward105o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21C4C061574
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 15:26:09 -0700 (PDT)
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward105o.mail.yandex.net (Yandex) with ESMTP id 01E204201711;
        Sat, 19 Jun 2021 01:26:08 +0300 (MSK)
Received: from vla1-9bfbcecd0651.qloud-c.yandex.net (vla1-9bfbcecd0651.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:4591:0:640:9bfb:cecd])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id F0ADE61E0002;
        Sat, 19 Jun 2021 01:26:07 +0300 (MSK)
Received: from vla5-3832771863b8.qloud-c.yandex.net (vla5-3832771863b8.qloud-c.yandex.net [2a02:6b8:c18:3417:0:640:3832:7718])
        by vla1-9bfbcecd0651.qloud-c.yandex.net (mxback/Yandex) with ESMTP id Vc0Sp8xEeQ-Q7HiOqpg;
        Sat, 19 Jun 2021 01:26:07 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624055167;
        bh=NH3RyQeT5sw3yYqyLnAOqva3rhV6ae9khfvH9hoOyBM=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=BhEt4J59G0DK3nVfUMV9tEHFZUA3eTpwE7Waf9k/Vva4kHj+Ld4cMOkgVsctonUNE
         dMogKV95a/qmfnJ+nOuVt+mLu73giIA0HVDypb05JGR8QS/Mtq0d6Jv/FjfkoaoT8K
         nlRa9yUVs9TvncjF8I5ovRJYlrzRrmOjd2EP9k2s=
Authentication-Results: vla1-9bfbcecd0651.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla5-3832771863b8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id S2QL6kS1QU-Q738r0md;
        Sat, 19 Jun 2021 01:26:07 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: guest/host mem out of sync on core2duo?
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <ca311331-c862-eed6-22ff-a82f0806797f@yandex.ru>
 <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <e2efcbcb-a0cb-999b-b81e-4721f3b41775@yandex.ru>
Date:   Sat, 19 Jun 2021 01:26:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQxys64U-r5xdF_wdunqn8ynBoOBPRDSjTDMh-gF3EEpg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

19.06.2021 01:06, Jim Mattson пишет:
> On Fri, Jun 18, 2021 at 2:55 PM stsp <stsp2@yandex.ru> wrote:
>> 19.06.2021 00:07, Jim Mattson пишет:
>>> On Fri, Jun 18, 2021 at 9:02 AM stsp <stsp2@yandex.ru> wrote:
>>>
>>>> Here it goes.
>>>> But I studied it quite thoroughly
>>>> and can't see anything obviously
>>>> wrong.
>>>>
>>>>
>>>> [7011807.029737] *** Guest State ***
>>>> [7011807.029742] CR0: actual=0x0000000080000031,
>>>> shadow=0x00000000e0000031, gh_mask=fffffffffffffff7
>>>> [7011807.029743] CR4: actual=0x0000000000002041,
>>>> shadow=0x0000000000000001, gh_mask=ffffffffffffe871
>>>> [7011807.029744] CR3 = 0x000000000a709000
>>>> [7011807.029745] RSP = 0x000000000000eff0  RIP = 0x000000000000017c
>>>> [7011807.029746] RFLAGS=0x00080202         DR7 = 0x0000000000000400
>>>> [7011807.029747] Sysenter RSP=0000000000000000 CS:RIP=0000:0000000000000000
>>>> [7011807.029749] CS:   sel=0x0097, attr=0x040fb, limit=0x000001a0,
>>>> base=0x0000000002110000
>>>> [7011807.029751] DS:   sel=0x00f7, attr=0x0c0f2, limit=0xffffffff,
>>>> base=0x0000000000000000
>>> I believe DS is illegal. Per the SDM, Checks on Guest Segment Registers:
>>>
>>> * If the guest will not be virtual-8086, the different sub-fields are
>>> considered separately:
>>>     - Bits 3:0 (Type).
>>>       * DS, ES, FS, GS. The following checks apply if the register is usable:
>>>         - Bit 0 of the Type must be 1 (accessed).
>> That seems to be it, thank you!
>> At least for the minimal reproducer
>> I've done.
>>
>> So only with unrestricted guest its
>> possible to ignore that field?
> The VM-entry constraints are the same with unrestricted guest.
>
> Note that *without* unrestricted guest, kvm will generally have to
> emulate the early guest protected mode code--until the last vestiges
> of real-address mode are purged from the descriptor cache. Maybe it
> fails to set the accessed bits in the LDT on emulated segment register
> loads?
I believe this is where the KVM_SET_SREGS
difference kicks in. When the segregs are
loaded in guest's ring0, there is no problem.
Likely in this case the accessed bit is properly
set.
But if we bypass the ring0 trampoline, then
the just created new LDT entry doesn't yet
have the accessed bit, and that propagates
to KVM_SET_SREGS. I believe I should just
force the accessed bit for KVM_SET_SREGS?

But there is no such problem if unrestricted
guest is available, so not everything is yet
clear.
