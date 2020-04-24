Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDAA1B739A
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgDXMIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 08:08:55 -0400
Received: from foss.arm.com ([217.140.110.172]:60966 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbgDXMIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 08:08:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9C9C1FB;
        Fri, 24 Apr 2020 05:08:53 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C10C3F6CF;
        Fri, 24 Apr 2020 05:08:52 -0700 (PDT)
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, kvmarm <kvmarm@lists.cs.columbia.edu>,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Leif Lindholm <leif@nuviainc.com>
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
 <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
 <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com>
 <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <df9a0aeb-39ed-f9bc-c506-71d2f134bc62@arm.com>
Date:   Fri, 24 Apr 2020 13:08:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/2020 07:45, Ard Biesheuvel wrote:

Hi,

(adding Leif for EDK-2 discussion)

> On Thu, 23 Apr 2020 at 23:32, André Przywara <andre.przywara@arm.com> wrote:
>>
>> On 23/04/2020 21:43, Ard Biesheuvel wrote:

[ ... kvmtool series to add CFI flash emulation allowing EDK-2 to store
variables. Starting with this version (v4) the flash memory region is
presented as a read-only memslot to KVM, to allow direct guest accesses
as opposed to trap-and-emulate even read accesses to the array.]

>>
>>
>> Just curious: the images Sami gave me this morning did not show any
>> issues anymore (no no-syndrome fault, no alignment issues), even without
>> the mapping [1]. And even though I saw the 800k read traps, I didn't
>> notice any real performance difference (on a Juno). The PXE timeout was
>> definitely much more noticeable.
>>
>> So did you see any performance impact with this series?
>>
> 
> You normally don't PXE boot. There is an issue with the iSCSI driver
> as well, which causes a boot delay for some reason, so I disabled that
> in my build.
> 
> I definitely *feels* faster :-) But in any case, exposing the array
> mode as a r/o memslot is definitely the right way to deal with this.
> Even if Sami did find a workaround that masks the error, it is no
> guarantee that all accesses go through that library.

So I was wondering about this, maybe you can confirm or debunk this:
- Any memory given to the compiler (through a pointer) is assumed to be
"normal" memory: the compiler can re-arrange accesses, split them up or
collate them. Also unaligned accesses should be allowed - although I
guess most compilers would avoid them.
- This normally forbids to give a pointer to memory mapped as "device
memory" to the compiler, since this would violate all of the assumptions
above.
- If the device mapped as "device memory" is actually memory (SRAM,
ROM/flash, framebuffer), then most of the assumptions are met, except
the alignment requirement, which is bound to the mapping type, not the
actual device (ARMv8 ARM: Unaligned accesses to device memory always
trap, regardless of SCTLR.A)
- To accommodate the latter, GCC knows the option -malign-strict, to
avoid unaligned accesses. TF-A and U-Boot use this option, to run
without the MMU enabled.

Now if EDK-2 lets the compiler deal with the flash memory region
directly, I think this would still be prone to alignment faults. In fact
an earlier build I got from Sami faulted on exactly that, when I ran it,
even with the r/o memslot mapping in place.

So should EDK-2 add -malign-strict to be safe?
	or
Should EDK-2 add an additional or alternate mapping using a non-device
memory type (with all the mismatched attributes consequences)?
	or
Should EDK-2 only touch the flash region using MMIO accessors, and
forbid the compiler direct access to that region?

So does EDK-2 get away with this because the compiler typically avoids
unaligned accesses?

Cheers,
Andre

>>> [0] https://people.linaro.org/~ard.biesheuvel/KVMTOOL_EFI.fd
>>
>> Ah, nice, will this stay there for a while? I can't provide binaries,
>> but wanted others to be able to easily test this.
>>
> 
> Sure, I will leave it up until Linaro decides to take down my account.
> 

