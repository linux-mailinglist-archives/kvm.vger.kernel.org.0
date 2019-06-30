Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 763875AFAE
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2019 12:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfF3KuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jun 2019 06:50:06 -0400
Received: from mout.web.de ([212.227.15.14]:37445 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfF3KuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jun 2019 06:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561891801;
        bh=wFUVo4i7n+V3Z5o09v/i2Qwehi6NSg2qJtEb/OiNCgc=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=nR9mggtSOXhESNthWFcWTDWau1Ap7SzcL9NOc6l0rMUvK7rhmiOs8RKtzJQ3JAJve
         np/CBdU6ZtMl/z/UH03CTlFp8YG8CNVMqVB1u3/XjmNwZgbCcA89zpCHUoHBLM91qa
         TA69I3NhirWNaRLgsBN9+9Y0zo3oPn94RzZ9VZj8=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.54.22]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MHdwC-1hgS0a3mQO-003KpV; Sun, 30
 Jun 2019 12:50:01 +0200
Subject: Re: KVM works on RPi4
From:   Jan Kiszka <jan.kiszka@web.de>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why> <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
 <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
Message-ID: <cbbeb948-23e5-97d9-2410-ef804ae2b80d@web.de>
Date:   Sun, 30 Jun 2019 12:49:59 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:axysJ3BelgeJrbLFQ8BBG8UY7QGR1050x54XqjETZMZD02IviWJ
 MC9UyM0mJDLQJN1a+SphIUtRpFvnN7RKKxJ0h56JWv/hyzz1zPJtRMcjW8/ygQLwBoXT9r9
 egKzDx9C4b11Y4b8t7L2JLhzQcO/KyMjkiVM0QEFgHznWT799eD3Ji0U31yRkV/32/b4Ua8
 WZv7gBQ1PSa/X5s3y0j6w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Kxg4aAPUBfY=:/s9EBv0nEhlobcqldkBP7p
 qFM+SFzLEy7zJaFdcufGsRFZ9cHxOaeg7Ox9RfAsvqN4dyiJr3iHUU61ToFU4AaXpcuf7MD2l
 DnN+FDDjroDqDvTHApM5pf3brdUnDm69WQEqVWxgHt+14PVoel7R5nA7wTC3CDx8jyXThJV2g
 I+81HP9g7/kmRRLvKf2cNjyhk2jidlWv0JLig46w5A/4VKZ8jS49w/uEKQuDv7G5l6WZl9CxS
 YtvPla9GVVd93jtPQuTwu2t1MuyeNPZH2mNermX3zJsWdRa7Bo5pI4E6coF9ye/JEXFdslb13
 qbojWD9VhHkyZ6TcZhW2qNw5vcRgtKeJOLg5+bVR76euR9JlwsfdnyFZgmIC8qX8JtZLbP6hx
 HcncaZGXM+dh2XzXkw2fFnZfW3iprXEEaIpO3JNN3smvwyfnKdU6o1wV7IfHnqaP5lNkN5Mr+
 j0POBMN8IgSly7kGjTh9zx4Xtal0aqrhXpt2fCGWtlGKf0xmjrvUp1BE1x1kxCqw2dwSr/VTh
 /xE0OHlrR2GF1wzFuBCc8IllH6rwhQ1S5L0hlU/vcCYPn1dYTITTkUXynwr0kzDhiRfWQqQ8t
 0hVQQczQNwfH55zXHEfZ86VkxcvW5zeSGejSJov+4XqhlIr7d9oKv8BQOl5KKmWHina8wRIQU
 auh1xxaF7A0eODPd662VT6h41rXDUtK070L3Wm4/c6gY490HZhnh0fwFCXvaGsoWMtrzZvcMk
 rkj7X4+JzVgoP7BnWtWV9SN6K0Uk2ydUTp/GC+27gKYo8XXoxCw7rMXz0cHG1lokPENbfkEVN
 AWUrpfzQ5BpZE/uFtSNJDG/GfBy+fbK+0TLSacVa5cQd7gAIJqC9xrn4R0LcfI9HVjPqIgmPy
 3YO//+OsrCIvwW8kROLoRi9tLZqRHWD12TOhdphTXQZrMFCdmSapfmaFDgibLT5hHmmhYBM/q
 L1JuGZRSXUGEtu3XwwEL9j3lpZdyCguKjKFVs8pyBRO5b7Ee+4/rtpjNjxJe3u5u12wkqYm4Y
 9ARTUdR32tT5Wc1maPv58Y5YbBbSfh7rEhqoXzswggh+JtS0ezIjZS+fqVyEBpwCNvhAgQxae
 lxX3y/RxlleFJ2Qn+QzTFEILuflTNQXoFO5
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.06.19 12:18, Jan Kiszka wrote:
> On 30.06.19 11:34, Jan Kiszka wrote:
>> On 30.06.19 00:42, Marc Zyngier wrote:
>>> On Sat, 29 Jun 2019 19:09:37 +0200
>>> Jan Kiszka <jan.kiszka@web.de> wrote:
>>>> However, as the Raspberry kernel is not yet ready for 64-bit (and
>>>> upstream is not in sight), I had to use legacy 32-bit mode. And there=
 we
>>>> stumble over the core detection. This little patch made it work, thou=
gh:
>>>>
>>>> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
>>>> index 2b8de885b2bf..01606aad73cc 100644
>>>> --- a/arch/arm/kvm/guest.c
>>>> +++ b/arch/arm/kvm/guest.c
>>>> @@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case ARM_CPU_PART_CORTEX_A7:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return KVM_ARM=
_TARGET_CORTEX_A7;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case ARM_CPU_PART_CORTEX_A15:
>>>> +=C2=A0=C2=A0=C2=A0 case ARM_CPU_PART_CORTEX_A72:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return KVM_ARM=
_TARGET_CORTEX_A15;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL=
;
>>>>
>>>> That raises the question if this is hack or a valid change and if the=
re
>>>> is general interest in mapping 64-bit cores on 32-bit if they happen =
to
>>>> run in 32-bit mode.
>>>
>>> The real thing to do here would be to move to a generic target, much
>>> like we did on the 64bit side. Could you investigate that instead? It
>>> would also allow KVM to be used on other 32bit cores such as
>>> A12/A17/A32.
>>
>> You mean something like KVM_ARM_TARGET_GENERIC_V8? Need to study that..=
.
>>
>
> Hmm, looking at what KVM_ARM_TARGET_CORTEX_A7 and ..._A15 differentiates=
, I
> found nothing so far:
>
> kvm_reset_vcpu:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (vcpu->arch.target) {
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_ARM_TARGET_CORTEX_A=
7:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case KVM_ARM_TARGET_CORTEX_A=
15:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 reset_regs =3D &cortexa_regs_reset;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 vcpu->arch.midr =3D read_cpuid_id();
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 break;
>
> And arch/arm/kvm/coproc_a15.c looks like a copy of coproc_a7.c, just wit=
h some
> symbols renamed.

OK, found it: The reset values of SCTLR differ, in one bit. A15 starts wit=
h
branch prediction (11) off, A7 with that feature enabled. Quite some boile=
rplate
code for managing a single bit.

For a generic target, can we simply assume A15 reset behaviour?

Jan
