Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD69897407
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 09:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfHUHzt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Aug 2019 03:55:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55184 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbfHUHzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 03:55:47 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B7C38535D
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 07:55:46 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id g127so1640772wme.0
        for <kvm@vger.kernel.org>; Wed, 21 Aug 2019 00:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4vtDy+oYLccEJv8Sb5ysrn3Ll8TQTjQAuhILZtXY+9Y=;
        b=Ilfnl9zCqg7qgPQbVulr1Sol8qGxJTGPKOVqvD+1eeu6NuMqrCQAHsyNuZKdqMVfMG
         UCzT2nhcQ8QBwWHILPeF3HAQtMdxJey/4GDXW5e/iHZVoaEeHotduPTPlqUjuAhgGp6d
         E0MnLY4LojUzngoH2xYACNBNSKaEe1Sp4rZdQSyoJ//Rrj5kzRJUlD2V+bx2162palgy
         aJrQ0PuxtCQNA1HO7JCmjQGOIZFdy6ssaSaE930wsAuEqzq6xJZM7Jses6q3+Dxl0tGq
         KH2tRm9vFRFTqB9a+LAWMi7ze5fa0cx+TtqYWUZGVMhaMGZPhnZwu5rn0yo1v8mhWLUZ
         YWyA==
X-Gm-Message-State: APjAAAXwyOGl1YlZC2xsaE+2w344Z+P4riVsTZIkk/x8i/7jtmJY7nKJ
        dM7xDl8d64nfqdBePQCpmwTIyJHLi77NiRHPyZDmlHH4dVJU9p1gWT5DyIvYQLUDYOk4a7ZkiUP
        dnBNPxgx6rRKM
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr4365235wmf.156.1566374145081;
        Wed, 21 Aug 2019 00:55:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxPOU17u3ZFYZ4bFYLjxyE5sHSLsZn1vvHBoeWKtl1lscdeLHgbtn5lCkRgGZUrPGmi4kuUpQ==
X-Received: by 2002:a05:600c:2292:: with SMTP id 18mr4365223wmf.156.1566374144777;
        Wed, 21 Aug 2019 00:55:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id f10sm17994990wrm.31.2019.08.21.00.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2019 00:55:44 -0700 (PDT)
Subject: Re: [PATCH RESEND] i386/kvm: support guest access CORE cstate
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <1563154124-18579-1-git-send-email-wanpengli@tencent.com>
 <ba3ae595-7f82-d17b-e8ed-6e86e9195ce5@redhat.com>
 <CANRm+Cx1bEOXBx50K9gv08UWEGadKOCtCbAwVo0CFC-g1gS+Xg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <82a0eb75-5710-3b03-cf8e-a00b156ee275@redhat.com>
Date:   Wed, 21 Aug 2019 09:55:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cx1bEOXBx50K9gv08UWEGadKOCtCbAwVo0CFC-g1gS+Xg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/19 09:16, Wanpeng Li wrote:
> Kindly reminder, :)

It's already in my pull request from yesterday.

Palo

> On Mon, 15 Jul 2019 at 17:16, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 15/07/19 03:28, Wanpeng Li wrote:
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> Allow guest reads CORE cstate when exposing host CPU power management capabilities
>>> to the guest. PKG cstate is restricted to avoid a guest to get the whole package
>>> information in multi-tenant scenario.
>>>
>>> Cc: Eduardo Habkost <ehabkost@redhat.com>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>
>> Hi,
>>
>> QEMU is in hard freeze now.  This will be applied after the release.
>>
>> Thanks,
>>
>> Paolo
>>
>>> ---
>>>  linux-headers/linux/kvm.h | 4 +++-
>>>  target/i386/kvm.c         | 3 ++-
>>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
>>> index b53ee59..d648fde 100644
>>> --- a/linux-headers/linux/kvm.h
>>> +++ b/linux-headers/linux/kvm.h
>>> @@ -696,9 +696,11 @@ struct kvm_ioeventfd {
>>>  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
>>>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>>>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
>>> +#define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
>>>  #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
>>>                                                KVM_X86_DISABLE_EXITS_HLT | \
>>> -                                              KVM_X86_DISABLE_EXITS_PAUSE)
>>> +                                              KVM_X86_DISABLE_EXITS_PAUSE | \
>>> +                                              KVM_X86_DISABLE_EXITS_CSTATE)
>>>
>>>  /* for KVM_ENABLE_CAP */
>>>  struct kvm_enable_cap {
>>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>>> index 3b29ce5..49a0cc1 100644
>>> --- a/target/i386/kvm.c
>>> +++ b/target/i386/kvm.c
>>> @@ -1645,7 +1645,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>          if (disable_exits) {
>>>              disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
>>>                                KVM_X86_DISABLE_EXITS_HLT |
>>> -                              KVM_X86_DISABLE_EXITS_PAUSE);
>>> +                              KVM_X86_DISABLE_EXITS_PAUSE |
>>> +                              KVM_X86_DISABLE_EXITS_CSTATE);
>>>          }
>>>
>>>          ret = kvm_vm_enable_cap(s, KVM_CAP_X86_DISABLE_EXITS, 0,
>>>
>>

