Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0E11A9B7C
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 12:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896435AbgDOKzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 06:55:11 -0400
Received: from foss.arm.com ([217.140.110.172]:42188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896428AbgDOKzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 06:55:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 59ED91063;
        Wed, 15 Apr 2020 03:55:01 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71E353F68F;
        Wed, 15 Apr 2020 03:55:00 -0700 (PDT)
Subject: Re: [PATCH kvmtool 00/18] Various fixes
To:     will@kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <a9c7d5ba-872f-7e51-317e-2235af3b8e57@arm.com>
Date:   Wed, 15 Apr 2020 11:54:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/04/2020 15:39, Alexandru Elisei wrote:

Hi Will,

> I've taken the fixes from my reassignable BARs and PCIE support series [1]
> and created this series because 1. they can be taken independently and 2.
> rebasing a 32 patch series was getting very tedious.
> 
> Changes from the original series:
> 
> * Gathered Reviewed-by tags. Only patch #14 "virtio: Don't ignore
>   initialization failures" doesn't have one.

... which is fixed by now.

I compile tested every commit for arm, arm64, x86-64, i386, mips64, and
powerpc64 - no warnings at all.
I also ran a brief test on x86-64 and arm64.

So I would very much recommend this series being merged now.

If you need any further help or tests, please let me know.

Cheers,
Andre


> * The virtio net device now frees the allocated devices and the ops copy on
>   failure in patch #14.
> 
> [1] https://www.spinics.net/lists/kvm/msg211272.html
> 
> Alexandru Elisei (14):
>   Makefile: Use correct objcopy binary when cross-compiling for x86_64
>   hw/i8042: Compile only for x86
>   Remove pci-shmem device
>   Check that a PCI device's memory size is power of two
>   arm/pci: Advertise only PCI bus 0 in the DT
>   vfio/pci: Allocate correct size for MSIX table and PBA BARs
>   vfio/pci: Don't assume that only even numbered BARs are 64bit
>   vfio/pci: Ignore expansion ROM BAR writes
>   vfio/pci: Don't access unallocated regions
>   virtio: Don't ignore initialization failures
>   Don't ignore errors registering a device, ioport or mmio emulation
>   hw/vesa: Don't ignore fatal errors
>   hw/vesa: Set the size for BAR 0
>   ioport: Fail when registering overlapping ports
> 
> Julien Thierry (3):
>   ioport: pci: Move port allocations to PCI devices
>   pci: Fix ioport allocation size
>   virtio/pci: Make memory and IO BARs independent
> 
> Sami Mujawar (1):
>   pci: Fix BAR resource sizing arbitration
> 
>  Makefile                       |   6 +-
>  arm/ioport.c                   |   3 +-
>  arm/pci.c                      |   2 +-
>  builtin-run.c                  |   5 -
>  hw/i8042.c                     |  14 +-
>  hw/pci-shmem.c                 | 400 ---------------------------------
>  hw/vesa.c                      |  34 ++-
>  include/kvm/devices.h          |   3 +-
>  include/kvm/ioport.h           |  10 +-
>  include/kvm/kvm.h              |   7 +-
>  include/kvm/pci-shmem.h        |  32 ---
>  include/kvm/pci.h              |   4 +-
>  include/kvm/util.h             |   2 +
>  include/kvm/vesa.h             |   6 +-
>  include/kvm/virtio.h           |   7 +-
>  include/linux/compiler.h       |   2 +-
>  ioport.c                       |  50 ++---
>  mips/kvm.c                     |   3 +-
>  pci.c                          |  59 ++++-
>  powerpc/include/kvm/kvm-arch.h |   2 +-
>  powerpc/ioport.c               |   3 +-
>  vfio/core.c                    |   6 +-
>  vfio/pci.c                     |  87 +++++--
>  virtio/9p.c                    |   9 +-
>  virtio/balloon.c               |  10 +-
>  virtio/blk.c                   |  14 +-
>  virtio/console.c               |  11 +-
>  virtio/core.c                  |   9 +-
>  virtio/mmio.c                  |  13 +-
>  virtio/net.c                   |  45 ++--
>  virtio/pci.c                   |  78 ++++---
>  virtio/scsi.c                  |  14 +-
>  x86/include/kvm/kvm-arch.h     |   2 +-
>  x86/ioport.c                   |  66 ++++--
>  34 files changed, 384 insertions(+), 634 deletions(-)
>  delete mode 100644 hw/pci-shmem.c
>  delete mode 100644 include/kvm/pci-shmem.h
> 

