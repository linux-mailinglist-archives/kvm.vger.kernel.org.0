Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A634F587052
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 20:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiHASXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 14:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiHASXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 14:23:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D79ED1EC64
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 11:23:07 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A04A139F;
        Mon,  1 Aug 2022 11:23:08 -0700 (PDT)
Received: from [10.57.43.143] (unknown [10.57.43.143])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9097F3F67D;
        Mon,  1 Aug 2022 11:23:06 -0700 (PDT)
Message-ID: <a2b33f4d-aad6-1239-465d-118e4f30e509@arm.com>
Date:   Mon, 1 Aug 2022 19:23:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <YtbNin3VTyIT/yYF@monolith.localdoman>
 <86e94983-0c69-88c8-f37f-c772ab6a4847@arm.com>
 <Ytq3Lxwa4fKG63GM@monolith.localdoman>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Ytq3Lxwa4fKG63GM@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 22/07/2022 15:41, Alexandru Elisei wrote:
> Hi Nikos,
> 
> On Fri, Jul 22, 2022 at 11:57:09AM +0100, Nikos Nikoleris wrote:
>> Hi Alex,
>>
>> On 19/07/2022 16:28, Alexandru Elisei wrote:
>>> Hi,
>>>
>>> I've been trying to test the seris and I've come across some issues.
> [..]
>>>
>>> The second error I'm encountering is when I try the selftest-setup test:
>>>
>>> [..]
>>> ProtectUefiImageCommon - 0x4D046040
>>>     - 0x000000004BEC4000 - 0x000000000001F600
>>> SetUefiImageMemoryAttributes - 0x000000004BEC4000 - 0x0000000000001000 (0x0000000000004008)
>>> SetUefiImageMemoryAttributes - 0x000000004BEC5000 - 0x0000000000010000 (0x0000000000020008)
>>> SetUefiImageMemoryAttributes - 0x000000004BED5000 - 0x000000000000F000 (0x0000000000004008)
>>> InstallProtocolInterface: 752F3136-4E16-4FDC-A22A-E5F46812F4CA 4F8014E8
>>> SetUefiImageMemoryAttributes - 0x000000004F640000 - 0x0000000000040000 (0x0000000000000008)
>>> SetUefiImageMemoryAttributes - 0x000000004C2D0000 - 0x0000000000040000 (0x0000000000000008)
>>> SetUefiImageMemoryAttributes - 0x000000004C280000 - 0x0000000000040000 (0x0000000000000008)
>>> SetUefiImageMemoryAttributes - 0x000000004C230000 - 0x0000000000040000 (0x0000000000000008)
>>> SetUefiImageMemoryAttributes - 0x000000004C140000 - 0x0000000000040000 (0x0000000000000008)
>>> SetUefiImageMemoryAttributes - 0x000000004F600000 - 0x0000000000030000 (0x0000000000000008)
>>> SetUefiImageMemoryAttributes - 0x000000004C040000 - 0x0000000000030000 (0x0000000000000008)
>>> SetUefiImageMemoryAttributes - 0x000000004BFC0000 - 0x0000000000030000 (0x0000000000000008)
>>> Load address: 4bec4000
>>> PC: 4beca400 PC offset: 6400
>>> Unhandled exception ec=0x25 (DABT_EL1)
>>> Vector: 4 (el1h_sync)
>>> ESR_EL1:         96000000, ec=0x25 (DABT_EL1)
>>> FAR_EL1: 0000fffffffff0f8 (valid)
>>> Exception frame registers:
>>> pc : [<000000004beca400>] lr : [<000000004beca42c>] pstate: 400002c5
>>> sp : 000000004f7ffe40
>>> x29: 000000004f7ffff0 x28: 0000000000000000
>>> x27: 000000004d046040 x26: 0000000000000000
>>> x25: 0000000000000703 x24: 0000000000000050
>>> x23: 0000000009011000 x22: 0000000000000000
>>> x21: 000000000000001f x20: 0000fffffffff000
>>> x19: 0000000043f92000 x18: 0000000000000000
>>> x17: 00000000ffffa6ab x16: 000000004f513ebc
>>> x15: 0000000000000002 x14: 000000004bed5000
>>> x13: 000000004bee4000 x12: 000000004bed4000
>>> x11: 000000004bec4000 x10: 000000004c03febc
>>> x9 : 000000004bee2938 x8 : 0000000000000000
>>> x7 : 0000000000000000 x6 : 000000004bee2900
>>> x5 : 000000004bee2908 x4 : 0000000048000000
>>> x3 : 0000000048000000 x2 : 000000004bee2928
>>> x1 : 0000000000000003 x0 : ffffffffffffffff
>>>
>>>
>>> EXIT: STATUS=127
>>>
>>> The preceding lines were omitted for brevity, the entire log can be found
>>> at [1] (expires in 6 months).
>>>
>>> Command used to launch the test:
>>>
>>> $ QEMU=/path/to/qemu/build/qemu-system-aarch64 EFI_UEFI=/path/to/QEMU_EFI.fd taskset -c 4-5 arm/efi/run arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
>>>
>>> qemu has been built from source, tag v7.0.0, configured with:
>>>
>>> $ ./configure --target-list=aarch64-softmmu --disable-vnc --disable-gtk --disable-bpf
>>>
>>> EDK2 image has been built from commit e1eef3a8b01a ("NetworkPkg: Add Wi-Fi
>>> Wpa3 support in WifiConnectManager"):
>>>
>>> $ build -a AARCH64 -t GCC5 -p ArmVirtPkg/ArmVirtQemu.dsc -b DEBUG
>>>
>>> I tried to disassemble selftest.efi: $ objdump -d selftest.efi, but there
>>> were no debug symbols in the output and it was impossible to figure what is
>>> going on.
>>>
>>> [1] https://pastebin.com/0mcap1BU
>>
>> I haven't been to able to reproduce this. I've build from source qemu and
>> EDK2 from source (the revisions you provided) and I've used gcc-10 to
>> compile KUT but selftest-smp passes.
> 
> That's weird, I've compiled kvm-unit-tests with gcc 10.3.0 [1] and I'm still
> seeing the error (tried it on my x86 machine), for both selftest-setup
> selftest-smp.
> 
> Did you compile qemu and edk2 with gcc 10.3.0? Or did you use some other
> compiler?
> 
> [1] https://developer.arm.com/-/media/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz
> 

Thanks, I managed to reproduce this and found that with this 
configuration there are more mem_regions than the assumed max. To work 
around it you can change NR_EXTRA_MEM_REGIONS in lib/arm/setup.c to

#define NR_EXTRA_MEM_REGIONS    32

Doubling it would hopefully be enough to run tests for now but I will 
also try to find out a better way to do this.

Thanks,

Nikos
