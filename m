Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084CA1AAE75
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 18:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416167AbgDOQgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 12:36:17 -0400
Received: from foss.arm.com ([217.140.110.172]:49828 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416090AbgDOQgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 12:36:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 282DD1FB;
        Wed, 15 Apr 2020 09:36:14 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D67313F6C4;
        Wed, 15 Apr 2020 09:36:12 -0700 (PDT)
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, sami.mujawar@arm.com,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com>
 <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
 <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
 <d9ae6d29-c2c5-6aa7-15b6-6549fc89c043@arm.com>
 <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <32355204-30b1-4615-0d08-b484f0340e82@arm.com>
Date:   Wed, 15 Apr 2020 17:35:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/2020 17:20, Ard Biesheuvel wrote:
> On Wed, 15 Apr 2020 at 18:11, André Przywara <andre.przywara@arm.com> wrote:
>>
>> On 15/04/2020 16:55, Ard Biesheuvel wrote:
>>> On Wed, 15 Apr 2020 at 17:43, Ard Biesheuvel <ardb@kernel.org> wrote:
>>>>
>>>> On Tue, 7 Apr 2020 at 17:15, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> I've tested this patch by running badblocks and fio on a flash device inside a
>>>>> guest, everything worked as expected.
>>>>>
>>>>> I've also looked at the flowcharts for device operation from Intel Application
>>>>> Note 646, pages 12-21, and they seem implemented correctly.
>>>>>
>>>>> A few minor issues below.
>>>>>
>>>>> On 2/21/20 4:55 PM, Andre Przywara wrote:
>>>>>> From: Raphael Gault <raphael.gault@arm.com>
>>>>>>
>>>>>> The EDK II UEFI firmware implementation requires some storage for the EFI
>>>>>> variables, which is typically some flash storage.
>>>>>> Since this is already supported on the EDK II side, we add a CFI flash
>>>>>> emulation to kvmtool.
>>>>>> This is backed by a file, specified via the --flash or -F command line
>>>>>> option. Any flash writes done by the guest will immediately be reflected
>>>>>> into this file (kvmtool mmap's the file).
>>>>>> The flash will be limited to the nearest power-of-2 size, so only the
>>>>>> first 2 MB of a 3 MB file will be used.
>>>>>>
>>>>>> This implements a CFI flash using the "Intel/Sharp extended command
>>>>>> set", as specified in:
>>>>>> - JEDEC JESD68.01
>>>>>> - JEDEC JEP137B
>>>>>> - Intel Application Note 646
>>>>>> Some gaps in those specs have been filled by looking at real devices and
>>>>>> other implementations (QEMU, Linux kernel driver).
>>>>>>
>>>>>> At the moment this relies on DT to advertise the base address of the
>>>>>> flash memory (mapped into the MMIO address space) and is only enabled
>>>>>> for ARM/ARM64. The emulation itself is architecture agnostic, though.
>>>>>>
>>>>>> This is one missing piece toward a working UEFI boot with kvmtool on
>>>>>> ARM guests, the other is to provide writable PCI BARs, which is WIP.
>>>>>>
>>>>
>>>> I have given this a spin with UEFI built for kvmtool, and it appears
>>>> to be working correctly. However, I noticed that it is intolerably
>>>> slow, which seems to be caused by the fact that both array mode and
>>>> command mode (or whatever it is called in the CFI spec) are fully
>>>> emulated, whereas in the QEMU implementation (for instance), the
>>>> region is actually exposed to the guest using a read-only KVM memslot
>>>> in array mode, and so the read accesses are made natively.
>>>>
>>>> It is also causing problems in the UEFI implementation, as we can no
>>>> longer use unaligned accesses to read from the region, which is
>>>> something the code currently relies on (and which works fine on actual
>>>> hardware as long as you use normal non-cacheable mappings)
>>>>
>>>
>>> Actually, the issue is not alignment. The issue is with instructions
>>> with multiple outputs, which means you cannot do an ordinary memcpy()
>>> from the NOR region using ldp instructions, aligned or not.
>>
>> Yes, we traced that down to an "ldrb with post-inc", in the memcpy code.
>> My suggestion was to provide a version of memcpy_{from,to}_io(), as
>> Linux does, which only uses MMIO accessors to avoid "fancy" instructions.
>>
> 
> That is possible, and the impact on the code is manageable, given the
> modular nature of EDK2.
> 
>> Back at this point I was challenging the idea of accessing a flash
>> device with a normal memory mapping, because of it failing when being in
>> some query mode. Do you know of any best practices for flash mappings?
>> Are two mappings common?
>>
> 
> In the QEMU port of EDK2, we use normal non-cacheable for the first
> flash device, which contains the executable image, and is not
> updatable by the guest. The second flash bank is used for the variable
> store, and is actually mapped as a device all the time.
> 
> Another thing I just realized is that you cannot fetch instructions
> from an emulated flash device either, so to execute from NOR flash,
> you will need a true memory mapping as well.

Wait, did you put the whole of EDK-2 image in the flash? My assumption
(and testing) was to use

$ lkvm run -f KVMTOOL_EFI.fd --flash just_the_variables.img

Hence my ignorance about performance, because it would just be a few
bytes written/read. -f loads the firmware image into guest RAM.

> So in summary, I think the mode switch is needed to be generally
> useful, even if the current approach is sufficient for (slow)
> read/write using special memory accessors.

Well,in hindsight I regret pursuing this whole flash emulation approach
in kvmtool in the first place. Just some magic "this memory region is
persistent" (mmapping a file and presenting as a memslot) would be
*much* easier on the kvmtool side. It just seems that there wasn't any
good DT binding or existing device class for this (to my surprise), or
at least not one without issues. And then EDK-2 had this CFI flash
support already, so we figured this should be the way to go. We just
need some emulation code ... months later ...

So do you know of some persistent storage device we could use? This
would come at the cost of adding support to EDK-2, but I guess it should
be straight-forward given the simple semantic?

Cheers,
Andre
