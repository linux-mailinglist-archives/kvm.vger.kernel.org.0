Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE6F5AF92
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2019 11:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF3Jec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jun 2019 05:34:32 -0400
Received: from mout.web.de ([212.227.15.3]:52177 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbfF3Jec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jun 2019 05:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561887267;
        bh=7JfDrC9uP9c3hnWWgcrZIsPj6pfmHbWDcl5DMU+xFH4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=GWYiWnjkxOwZqVVMX23ffnq49RJmi6tb7czBzVnotcJ9o9Kzoe6K5NQQoWwzsV+vj
         kVMhF5kLn6/cFOToOnEN+h6MR55RYE1Jp+DYDqtBhgaAMTrDtGNtaFmY5AYA8JeVkW
         w7QiD8696adFP82BPYqzFykL4mFELoIIIgNAp23Q=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.54.22]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MhlT9-1hvd0C1NnX-00MuWQ; Sun, 30
 Jun 2019 11:34:27 +0200
Subject: Re: KVM works on RPi4
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
References: <1d1198c2-f362-840d-cb14-9a6d74da745c@web.de>
 <20190629234232.484ca3c0@why>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <9fa56744-9925-6f49-b2a4-368e13fbbc41@web.de>
Date:   Sun, 30 Jun 2019 11:34:25 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <20190629234232.484ca3c0@why>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tyRIyK9SNwr5ypgeQQsNhbL9DVzUZo/Ya6rlq54GMLJKiiRWh7D
 ARU9W0m1TJtH1mRGdCdo/LIxT6XmMBAMqPkHMh3NQbYaXwSS+EJPKJLXUmG09NAMU+7PGnG
 UZEhjhHhs1ghDR4tfxeTuHPtecwF56EJspp9i4idfr0N025+o+IoGfCn16v3oT6tARGRfq8
 sp+Cee1edjotk5yVg4LKg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FubqFI9F6s0=:WvGcBqr+FAmFglGaVzebEK
 WHPLtzq3vErPW+vL3gUgL/9UnbZ7CUByd2UC0hbi3meqe9VPdD+3csSw69g35gkphiciVDyOO
 TtHcW/6r9lxPl44ECLJsD/h7pfl4nNm2q/NVEELkDBsyiT/k65tLp4PabBmFF9/Ee7ED3o2iL
 PYCkVL5Jb2tWGUnjGRg/JjBG2T4luuyBZKBSDavR3t9+XDR6RW89rJ0Gp/7er71IsHeajP4h6
 pAmSz13CNISHFbGZ9kOyTWbBdeWZTmu/ngU10KrJXqnHmM1riIHD8+FtFVGiZKBUrV3AFBHou
 +1SGxkMUVxY731xEmqEgSUJPRLTSf8ZlG8CERnKNe2gqNWTJDt8fwJv2GBour21X0S7Dd09qp
 wlB88lOH7tNK1K3ZUQU755ytw3YToD7Os995VfMHIi87sj5QP9PAbtTUkCraKV/MRhKtKgxvL
 Nmp38B/20Dcl1DN/bTxraEyaGyAIlt0snVw8blK3duGipvNin3mpiJ9yA7L/fErXNQwPVZRHr
 +XvwyByUCpKReE1terSEvbkYUhxNak/h7k4w6iCoUKxWypQIpzQ5zgaXbwzLmCFXh+gzmpwTO
 xaFMSyqHQ/RcsXM9Q4tEVQeMFig9OBtCUM6pHp2OY8X/xjMpTpO4ZQh4ugC1lxcosLx9H1ggw
 yq8EJww9bPgpWghalZNJMz3Wq+UxgoNGcwXTfKgJ7dZNXpxk+D4jzHBOzBkUxrHjAj7hWd88L
 wM8EOyUWb4f5NEJqrIA41Z4KVJmOdDkMu+Q8/kU7bGDrHtv1CfrEuiDiDZ/uwTok8iWYfLdE1
 J28nfxFTqqCkFAHLqlQ7vh0PEWmz8bQ+Fagk6OkL0FGN8lHAJ9QNemBlhVU7F013NqnmO3EZV
 SpBmXsRIW7XZKlWZClOBGKdUDjiuMUglzehLZ7A7QFSA01hI44ZSJWcLNqtcXAPQ2e55Nc0B+
 JZoiVlMl/Xl7yIT/OzNx86/fYmpID9DLxnR6UHCWmZPVKk1SvbEi0FJhlFl4t6Qp7Pp+iX2Bk
 oncQZa7w5OK6GFy8RFrBpwKbrPUMxSQ0u9JhtPM/rU7EEWBVYqPJeUigvdso7P95LmJGUQBXG
 7Kx56vI9Vy+1lFSw6M6f/rVK+D0kREkq+2u
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.06.19 00:42, Marc Zyngier wrote:
> On Sat, 29 Jun 2019 19:09:37 +0200
> Jan Kiszka <jan.kiszka@web.de> wrote:
>
> Hi Jan,
>
>> Hi all,
>>
>> just got KVM running on the Raspberry Pi4. Seems they now embedded all
>> required logic into that new SoC.
>
> Yeah, someone saw the light and decided to enter the 21st century by
> attaching a GICv2 to the thing. Who knows, they may plug a GICv3 and a
> SMMU in 2050 at that rate! ;-)
>

Optimistic.

>> However, as the Raspberry kernel is not yet ready for 64-bit (and
>> upstream is not in sight), I had to use legacy 32-bit mode. And there w=
e
>> stumble over the core detection. This little patch made it work, though=
:
>>
>> diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
>> index 2b8de885b2bf..01606aad73cc 100644
>> --- a/arch/arm/kvm/guest.c
>> +++ b/arch/arm/kvm/guest.c
>> @@ -290,6 +290,7 @@ int __attribute_const__ kvm_target_cpu(void)
>>   	case ARM_CPU_PART_CORTEX_A7:
>>   		return KVM_ARM_TARGET_CORTEX_A7;
>>   	case ARM_CPU_PART_CORTEX_A15:
>> +	case ARM_CPU_PART_CORTEX_A72:
>>   		return KVM_ARM_TARGET_CORTEX_A15;
>>   	default:
>>   		return -EINVAL;
>>
>> That raises the question if this is hack or a valid change and if there
>> is general interest in mapping 64-bit cores on 32-bit if they happen to
>> run in 32-bit mode.
>
> The real thing to do here would be to move to a generic target, much
> like we did on the 64bit side. Could you investigate that instead? It
> would also allow KVM to be used on other 32bit cores such as
> A12/A17/A32.

You mean something like KVM_ARM_TARGET_GENERIC_V8? Need to study that...

>
> Although some would argue that the *real* real thing to do would be "rm
> -rf arch/arm/kvm" and be done with it, but that's a discussion for next
> week... ;-)
>
>> Jan
>>
>> PS: The RPi device tree lacks description of the GICH maintenance
>> interrupts. Seems KVM is fine without that - because it has the
>> information hard-coded or because it can live without that interrupt?
>
> Nah, it really should have an interrupt here. You can end-up in
> situation where new virtual interrupts are delayed until the next
> natural exit if you don't get a maintenance interrupt. Feels like a bug.

Probably just in their DT. How can I check if the maintenance IRQ is worki=
ng?

>
> Anyway, if you know of any effort to get a 64bit kernel on that thing,
> I'm interested in helping. I bought one on Monday, but didn't get a
> change to do any hacking on it just yet...

I played with compiling the rpi kernel for 64-bit. Lots of pieces from the
graphic drivers are falling from the truck, but you can make it build at l=
east.
Not that it boots so far or gives any early messages. Probably that is the=
 reason:

https://github.com/raspberrypi/linux/issues/3032

Jan
