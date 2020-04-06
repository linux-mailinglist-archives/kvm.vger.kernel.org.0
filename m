Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1524F19F7B8
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 16:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgDFOOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 10:14:48 -0400
Received: from foss.arm.com ([217.140.110.172]:46340 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgDFOOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 10:14:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D57911D4;
        Mon,  6 Apr 2020 07:14:47 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8EDF3F73D;
        Mon,  6 Apr 2020 07:14:46 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 00/32] Add reassignable BARs and PCIE 1.1
 support
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <7b74420e-cc19-bbca-8572-0c372812cd8e@arm.com>
Date:   Mon, 6 Apr 2020 15:14:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:

Hi Will, Alex,

> kvmtool uses the Linux-only dt property 'linux,pci-probe-only' to prevent
> it from trying to reassign the BARs. Let's make the BARs reassignable so we
> can get rid of this band-aid.
> 
> Let's also extend the legacy PCI emulation, which came out in 1992, so we
> can properly emulate the PCI Express version 1.1 protocol, which is new in
> comparison, being published in 2005.
> 
> During device configuration, Linux can assign a region resource to a BAR
> that temporarily overlaps with another device. This means that the code
> that emulates BAR reassignment must be aware of all the registered PCI
> devices. Because of this, and to avoid re-implementing the same code for
> each emulated device, the algorithm for activating/deactivating emulation
> as BAR addresses change lives completely inside the PCI code. Each device
> registers two callback functions which are called when device emulation is
> activated (for example, to activate emulation for a newly assigned BAR
> address), respectively, when device emulation is deactivated (a previous
> BAR address is changed, and emulation for that region must be deactivated).

[ ... ]

> 
> Patches 1-18 are fixes and cleanups, and can be merged independently. They
> are pretty straightforward, so if the size of the series looks off-putting,
> please review these first. I am aware that the series has grown quite a
> lot, I am willing to split the fixes from the rest of the patches, or
> whatever else can make reviewing easier.

I am done with the review of this series. I had only one small comment
on the first 18 patches, so I would suggest that Alex sends a new
version of only those fix&cleanup patches, so we can fix those bugs and
also make the rest of the series easier to digest.

In general this series looks to be in a really good shape, I don't see
anything major anymore.

Alex, many thanks for the accurate and tedious work on this, surely not
the most grateful of tasks.

Cheers,
Andre.

> 
> Changes in v3:
> * Patches 18, 24 and 26 are new.
> * Dropped #9 "arm/pci: Fix PCI IO region" for reasons explained above.
> * Reworded commit message for #12 "vfio/pci: Ignore expansion ROM BAR
>   writes" to make it clear that kvmtool's implementation of VFIO doesn't
>   support expansion BAR emulation.
> * Moved variable declaration at the start of the function for #13
>   "vfio/pci: Don't access unallocated regions".
> * Patch #15 "Don't ignore errors registering a device, ioport or mmio
>   emulation" uses ioport__remove consistenly.
> * Reworked error cleanup for #16 "hw/vesa: Don't ignore fatal errors".
> * Reworded commit message for #17 "hw/vesa: Set the size for BAR 0".
> * Reworked #19 "ioport: mmio: Use a mutex and reference counting for
>   locking" to also use reference counting to prevent races (and updated the
>   commit message in the process).
> * Added the function pci__bar_size to #20 "pci: Add helpers for BAR values
>   and memory/IO space access".
> * Protect mem_banks list with a mutex in #22 "vfio: Destroy memslot when
>   unmapping the associated VAs"; also moved the munmap after the slot is
>   destroyed, as per the KVM api.
> * Dropped the rework of the vesa device in patch #27 "pci: Implement
>   callbacks for toggling BAR emulation". Also added a few assert statements
>   in some callbacks to make sure that they don't get called with an
>   unxpected BAR number (which can only result from a coding error). Also
>   return -ENOENT when kvm__deregister_mmio fails, to match ioport behavior
>   and for better diagnostics.
> * Dropped the PCI configuration write callback from the vesa device in #28
>   "pci: Toggle BAR I/O and memory space emulation". Apparently, if we don't
>   allow the guest kernel to disable BAR access, it treats the VESA device
>   as a VGA boot device, instead of a regular VGA device, and Xorg cannot
>   use it.
> * Droped struct bar_info from #29 "pci: Implement reassignable BARs". Also
>   changed pci_dev_err to pci_dev_warn in pci_{activate,deactivate}_bar,
>   because the errors can be benign (they can happen because two vcpus race
>   against each other to deactivate memory or I/O access, for example).
> * Replaced the PCI device configuration space define with the actual
>   number in #32 "arm/arm64: Add PCI Express 1.1 support". On some distros
>   the defines weren't present in /usr/include/linux/pci_regs.h.
> * Implemented other minor review comments.
> * Gathered Reviewed-by tags.
> 
> Changes in v2:
> * Patches 2, 11-18, 20, 22-27, 29 are new.
> * Patches 11, 13, and 14 have been dropped.
> * Reworked the way BAR reassignment is implemented.
> * The patch "Add PCI Express 1.1 support" has been reworked to apply only
>   to arm64. For x86 we would need ACPI support in order to advertise the
>   location of the ECAM space.
> * Gathered Reviewed-by tags.
> * Implemented review comments.
> 
> [1] https://www.spinics.net/lists/kvm/msg209178.html
> [2] https://www.spinics.net/lists/kvm/msg209178.html
> [3] https://www.spinics.net/lists/arm-kernel/msg778623.html
> 
> 
> Alexandru Elisei (27):
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
>   ioport: mmio: Use a mutex and reference counting for locking
>   pci: Add helpers for BAR values and memory/IO space access
>   virtio/pci: Get emulated region address from BARs
>   vfio: Destroy memslot when unmapping the associated VAs
>   vfio: Reserve ioports when configuring the BAR
>   pci: Limit configuration transaction size to 32 bits
>   vfio/pci: Don't write configuration value twice
>   vesa: Create device exactly once
>   pci: Implement callbacks for toggling BAR emulation
>   pci: Toggle BAR I/O and memory space emulation
>   pci: Implement reassignable BARs
>   vfio: Trap MMIO access to BAR addresses which aren't page aligned
>   arm/arm64: Add PCI Express 1.1 support
> 
> Julien Thierry (4):
>   ioport: pci: Move port allocations to PCI devices
>   pci: Fix ioport allocation size
>   virtio/pci: Make memory and IO BARs independent
>   arm/fdt: Remove 'linux,pci-probe-only' property
> 
> Sami Mujawar (1):
>   pci: Fix BAR resource sizing arbitration
> 
>  Makefile                          |   6 +-
>  arm/fdt.c                         |   1 -
>  arm/include/arm-common/kvm-arch.h |   4 +-
>  arm/ioport.c                      |   3 +-
>  arm/pci.c                         |   4 +-
>  builtin-run.c                     |   6 +-
>  hw/i8042.c                        |  14 +-
>  hw/pci-shmem.c                    | 400 ------------------------------
>  hw/vesa.c                         | 113 ++++++---
>  include/kvm/devices.h             |   3 +-
>  include/kvm/ioport.h              |  12 +-
>  include/kvm/kvm-config.h          |   2 +-
>  include/kvm/kvm.h                 |  11 +-
>  include/kvm/pci-shmem.h           |  32 ---
>  include/kvm/pci.h                 | 163 +++++++++++-
>  include/kvm/rbtree-interval.h     |   4 +-
>  include/kvm/util.h                |   2 +
>  include/kvm/vesa.h                |   6 +-
>  include/kvm/virtio-pci.h          |   3 -
>  include/kvm/virtio.h              |   7 +-
>  include/linux/compiler.h          |   2 +-
>  ioport.c                          | 108 ++++----
>  kvm.c                             | 101 +++++++-
>  mips/kvm.c                        |   3 +-
>  mmio.c                            |  91 +++++--
>  pci.c                             | 334 +++++++++++++++++++++++--
>  powerpc/include/kvm/kvm-arch.h    |   2 +-
>  powerpc/ioport.c                  |   3 +-
>  powerpc/spapr_pci.c               |   2 +-
>  vfio/core.c                       |  22 +-
>  vfio/pci.c                        | 233 +++++++++++++----
>  virtio/9p.c                       |   9 +-
>  virtio/balloon.c                  |  10 +-
>  virtio/blk.c                      |  14 +-
>  virtio/console.c                  |  11 +-
>  virtio/core.c                     |   9 +-
>  virtio/mmio.c                     |  13 +-
>  virtio/net.c                      |  32 +--
>  virtio/pci.c                      | 206 ++++++++++-----
>  virtio/scsi.c                     |  14 +-
>  x86/include/kvm/kvm-arch.h        |   2 +-
>  x86/ioport.c                      |  66 +++--
>  42 files changed, 1287 insertions(+), 796 deletions(-)
>  delete mode 100644 hw/pci-shmem.c
>  delete mode 100644 include/kvm/pci-shmem.h
> 

