Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CBD5AFA4
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2019 12:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfF3KTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jun 2019 06:19:05 -0400
Received: from mout.web.de ([212.227.15.3]:38479 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfF3KTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jun 2019 06:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561889940;
        bh=bLhlpcS3Du6/J70yEMs1c6ggw5kDdNhYdM136+k71T0=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=EkWw07tLAGMWKqKCDSX+ZxU6TJyESeJfwIJfmz+QuLc+hWLRD9GVOegvn01L1NH1x
         EWq6FeDdjWRDy00Z1qlV/OfJaBnQMlWwQU5UAKPan6IdxSfR3KTVmblhiiDT8HwZq+
         jW/mliXV3hd3rXPiVUBh3mcNwm4x0SzW4F9mD8a0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.54.22]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MI6JC-1hgy9y0ZEU-003xRY; Sun, 30
 Jun 2019 12:19:00 +0200
Subject: Re: KVM works on RPi4
From:   Jan Kiszka <jan.kiszka@web.de>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why> <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
Message-ID: <3f6ea07b-975b-3d66-e12d-f0a9cadb83a9@web.de>
Date:   Sun, 30 Jun 2019 12:18:59 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:04w92vQEYTT8pNExe/B59Ak2jCirTtbX1hTIl64kTfUc7ZuF4Vr
 SxiGs7y7wzi28iWqyJcckIkR6VcRkFIoPDrTpCK7RY9wXeU6vmxxBBIfKywQfagu4FLiW18
 cOoZj3h1lxVC0VuZPF+TmUbF5jH4lcBGv4z98vqcS9mHdUIOq75l+2RD7rD/MBEt/LETara
 c3DXmhO/9RbiSq5KLMlRg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/GDKbidp1Og=:Ja3BHrbn2HKwBierKeWW8y
 4iEhhs80n2S9VGeo69lEeF+uUr3T+VX6e0vjsFZIgUIZn3NlfPE+L+FDDkgpkMpZdRHToSRaS
 KTWnyp+pRtFe/TiWfPVpsrp8+r5ZqilaiAkQuMkjyGwrZpKMJuv9UkiUBsJpjTCgrMxVDWxHO
 7jTc0bo9YymEJzdJBY4SLnTXwgpcdnFzEwmw48ZSv1SEn45/iCXVFACl4XOGlc0J7sgKxj1Tc
 Z1VnEImlO9FLjWIx8Xpj2hCv7ZZyyyHtFuCtOw2nFUORnPsAc/w/q/5W98fEfFs/0oRrLR7Ss
 XyUSKB0+T/HSFnmVJpCiu7fya4oq3gjsSAgDZbhuzCHmDmPpxdz8+PJX1cOBL48UznJR+se1r
 rwknjiMa9kyq0v9WUhjUqcElAjqcf3lpg8dmx7Vz+psmC5Ki6o2kgygzTvIjjmSGjIukMD0zk
 txKPqpvQh3cqj5iX72PnJAbfTHAaWrBdxsgpjad/pY2BQd6GvZYHSxb6/DxnmuW0Amo5ZhVUZ
 xat3Ne9ohcDZ2nkHzOG1BJh2ihrFzIeLKiYCNHY2dFCGKCy0DD/jsItfO1gT/fOEUkYQE7izJ
 MK1D2hg1S44RS33em5dSLAafmviyBab0nXCxwVO9NkmHcvsU3Wqaz7nmG5AYESaXwIYHjqKWa
 eVBisu4Wm7zkj2oqdJ88O5y7Ze09KGlIzM4aaG7U6divYz3u2nYKRHUf2zoMXwofy4ROEiwpO
 ziABfimhOheWmC6b1L49nzMbSnOA4UKH2YfdLi2TIkFo57equUUjJ9/9INpltPhPj74qUZgnx
 c3tSU8C6hm48RLdrdKsmfbxt2TqEcw9BBwWVSBd1r48ai8ZSMfqqBjgYDdtDQ+az1j5OVagnu
 P0kOKdqOyo+FjP9mfvkk6QsTdWA08VnOzDtsq7KW2/Oq7LGbfAX3BQZ05FZzqUsBhb8gQ8n2P
 TM0E6A0OclPesK3taqhcnS2WMmIVwVjRvUbHK5qujZRACIGOYByfdzBy5v+wAYzEOhOBNlXXP
 9GfBNzKl4Y62zEYcowdhvsFYkMpJKTw16j7paYuHy07UJdOOZBGDGaBD/QvdON0mnCtDF9KRt
 Pa6VsOqt9o0HNfoioIXRzN7RI6phMQDm2MB
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.06.19 11:34, Jan Kiszka wrote:
> On 30.06.19 00:42, Marc Zyngier wrote:
>> On Sat, 29 Jun 2019 19:09:37 +0200
>> Jan Kiszka <jan.kiszka@web.de> wrote:
>>> However, as the Raspberry kernel is not yet ready for 64-bit (and
>>> upstream is not in sight), I had to use legacy 32-bit mode. And there =
we
>>> stumble over the core detection. This little patch made it work, thoug=
h:
>>>
>>> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
>>> index 2b8de885b2bf..01606aad73cc 100644
>>> --- a/arch/arm/kvm/guest.c
>>> +++ b/arch/arm/kvm/guest.c
>>> @@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case ARM_CPU_PART_CORTEX_A7:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return KVM_ARM_=
TARGET_CORTEX_A7;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case ARM_CPU_PART_CORTEX_A15:
>>> +=C2=A0=C2=A0=C2=A0 case ARM_CPU_PART_CORTEX_A72:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return KVM_ARM_=
TARGET_CORTEX_A15;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
>>>
>>> That raises the question if this is hack or a valid change and if ther=
e
>>> is general interest in mapping 64-bit cores on 32-bit if they happen t=
o
>>> run in 32-bit mode.
>>
>> The real thing to do here would be to move to a generic target, much
>> like we did on the 64bit side. Could you investigate that instead? It
>> would also allow KVM to be used on other 32bit cores such as
>> A12/A17/A32.
>
> You mean something like KVM_ARM_TARGET_GENERIC_V8? Need to study that...
>

Hmm, looking at what KVM_ARM_TARGET_CORTEX_A7 and ..._A15 differentiates, =
I
found nothing so far:

kvm_reset_vcpu:
         switch (vcpu->arch.target) {
         case KVM_ARM_TARGET_CORTEX_A7:
         case KVM_ARM_TARGET_CORTEX_A15:
                 reset_regs =3D &cortexa_regs_reset;
                 vcpu->arch.midr =3D read_cpuid_id();
                 break;

And arch/arm/kvm/coproc_a15.c looks like a copy of coproc_a7.c, just with =
some
symbols renamed.

What's the purpose of all that? Planned for something bigger but never
implemented? From that perspective, there seems to be no need to arch.targ=
et and
kvm_coproc_target_table at all.

Jan
