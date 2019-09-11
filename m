Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60674AF797
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 10:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfIKITJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 04:19:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfIKITI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 04:19:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCA07308624A;
        Wed, 11 Sep 2019 08:19:07 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-192.ams2.redhat.com [10.36.116.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CE9F100194E;
        Wed, 11 Sep 2019 08:19:05 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] arm: prevent compiler from using unaligned
 accesses
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190905171502.215183-1-andre.przywara@arm.com>
 <d41649bc-5061-3c65-146c-d7dff3f086e7@redhat.com>
 <20190911091604.380c6df9@donnerap.cambridge.arm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <c2904d78-45aa-46ef-8cfd-5e544a94e446@redhat.com>
Date:   Wed, 11 Sep 2019 10:19:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911091604.380c6df9@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 11 Sep 2019 08:19:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/2019 10.16, Andre Przywara wrote:
> On Tue, 10 Sep 2019 20:15:19 +0200
> Thomas Huth <thuth@redhat.com> wrote:
> 
> Hi,
> 
>> On 05/09/2019 19.15, Andre Przywara wrote:
>>> The ARM architecture requires all accesses to device memory to be
>>> naturally aligned[1][2]. Normal memory does not have this strict
>>> requirement, and in fact many systems do ignore unaligned accesses
>>> (by the means of clearing the A bit in SCTLR and accessing normal
>>> memory). So the default behaviour of GCC assumes that unaligned accesses
>>> are fine, at least if happening on the stack.
>>>
>>> Now kvm-unit-tests runs some C code with the MMU off, which degrades the
>>> whole system memory to device memory. Now every unaligned access will
>>> fault, regardless of the A bit.
>>> In fact there is at least one place in lib/printf.c where GCC merges
>>> two consecutive char* accesses into one "strh" instruction, writing to
>>> a potentially unaligned address.
>>> This can be reproduced by configuring kvm-unit-tests for kvmtool, but
>>> running it on QEMU, which triggers an early printf that exercises this
>>> particular code path.
>>>
>>> Add the -mstrict-align compiler option to the arm64 CFLAGS to fix this
>>> problem. Also add the respective -mno-unaligned-access flag for arm.
>>>
>>> Thanks to Alexandru for helping debugging this.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>
>>> [1] ARMv8 ARM DDI 0487E.a, B2.5.2
>>> [2] ARMv7 ARM DDI 0406C.d, A3.2.1
>>> ---
>>>  arm/Makefile.arm   | 1 +
>>>  arm/Makefile.arm64 | 1 +
>>>  2 files changed, 2 insertions(+)
>>>
>>> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
>>> index a625267..43b4be1 100644
>>> --- a/arm/Makefile.arm
>>> +++ b/arm/Makefile.arm
>>> @@ -12,6 +12,7 @@ KEEP_FRAME_POINTER := y
>>>  
>>>  CFLAGS += $(machine)
>>>  CFLAGS += -mcpu=$(PROCESSOR)
>>> +CFLAGS += -mno-unaligned-access
>>>  
>>>  arch_LDFLAGS = -Ttext=40010000
>>>  
>>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>>> index 02c24e8..35de5ea 100644
>>> --- a/arm/Makefile.arm64
>>> +++ b/arm/Makefile.arm64
>>> @@ -7,6 +7,7 @@ bits = 64
>>>  ldarch = elf64-littleaarch64
>>>  
>>>  arch_LDFLAGS = -pie -n
>>> +CFLAGS += -mstrict-align  
>>
>> Instead of adding it to both, Makefile.arm and Makefile.arm64, you could
>> also simply add it to Makefile.common instead.
> 
> But the arguments are not the same (admittedly against intuition)?
> I thought about defining arch_CFLAGS in both files, then adding that to Makefile.common, but didn't see the advantage over this straightforward approach here.

D'oh, never mind, I didn't read the patch properly. I somehow thought
that the arguments are the same. It's quite weird that the compiler
developers chose different names here...

 Thomas
