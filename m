Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335FD372BE2
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 16:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhEDOU5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 4 May 2021 10:20:57 -0400
Received: from 2.mo51.mail-out.ovh.net ([178.33.255.19]:39581 "EHLO
        2.mo51.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhEDOU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 10:20:56 -0400
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 May 2021 10:20:56 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.109.143.103])
        by mo51.mail-out.ovh.net (Postfix) with ESMTPS id 1829F297B71;
        Tue,  4 May 2021 16:11:55 +0200 (CEST)
Received: from kaod.org (37.59.142.104) by DAG8EX1.mxp5.local (172.16.2.71)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Tue, 4 May 2021
 16:11:32 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-104R0059937f50a-f377-4106-9467-b3b86bf2979e,
                    233BADB9E061AA125F593C9F78707CF28220F307) smtp.auth=groug@kaod.org
X-OVh-ClientIp: 78.197.208.248
Date:   Tue, 4 May 2021 16:11:31 +0200
From:   Greg Kurz <groug@kaod.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Christoph Hellwig <hch@lst.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <kvm@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "Paul Mackerras" <paulus@samba.org>,
        Daniel Vetter <daniel@ffwll.ch>, <linux-api@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <qemu-devel@nongnu.org>,
        <qemu-ppc@nongnu.org>
Subject: Re: remove the nvlink2 pci_vfio subdriver v2
Message-ID: <20210504161131.2ed74d7b@bahia.lan>
In-Reply-To: <YJFMZ8KYVCDwUBPU@kroah.com>
References: <20210326061311.1497642-1-hch@lst.de>
        <20210504142236.76994047@bahia.lan>
        <YJFFG1tSP0dUCxcX@kroah.com>
        <20210504152034.18e41ec3@bahia.lan>
        <YJFMZ8KYVCDwUBPU@kroah.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [37.59.142.104]
X-ClientProxiedBy: DAG3EX1.mxp5.local (172.16.2.21) To DAG8EX1.mxp5.local
 (172.16.2.71)
X-Ovh-Tracer-GUID: effd68a3-6459-416d-a28c-4964cefb2245
X-Ovh-Tracer-Id: 6202864065056512385
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrvdefiedgjeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfhisehtqhertdertdejnecuhfhrohhmpefirhgvghcumfhurhiiuceoghhrohhugheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeevlefhtddufffhieevhefhleegleelgfetffetkedugeehjeffgfehhfefueduffenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepghhrohhugheskhgrohgurdhorhhgpdhrtghpthhtohepqhgvmhhuqdhpphgtsehnohhnghhnuhdrohhrgh
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 4 May 2021 15:30:15 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Tue, May 04, 2021 at 03:20:34PM +0200, Greg Kurz wrote:
> > On Tue, 4 May 2021 14:59:07 +0200
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > > On Tue, May 04, 2021 at 02:22:36PM +0200, Greg Kurz wrote:
> > > > On Fri, 26 Mar 2021 07:13:09 +0100
> > > > Christoph Hellwig <hch@lst.de> wrote:
> > > > 
> > > > > Hi all,
> > > > > 
> > > > > the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
> > > > > feature without any open source component - what would normally be
> > > > > the normal open source userspace that we require for kernel drivers,
> > > > > although in this particular case user space could of course be a
> > > > > kernel driver in a VM.  It also happens to be a complete mess that
> > > > > does not properly bind to PCI IDs, is hacked into the vfio_pci driver
> > > > > and also pulles in over 1000 lines of code always build into powerpc
> > > > > kernels that have Power NV support enabled.  Because of all these
> > > > > issues and the lack of breaking userspace when it is removed I think
> > > > > the best idea is to simply kill.
> > > > > 
> > > > > Changes since v1:
> > > > >  - document the removed subtypes as reserved
> > > > >  - add the ACK from Greg
> > > > > 
> > > > > Diffstat:
> > > > >  arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
> > > > >  b/arch/powerpc/include/asm/opal.h            |    3 
> > > > >  b/arch/powerpc/include/asm/pci-bridge.h      |    1 
> > > > >  b/arch/powerpc/include/asm/pci.h             |    7 
> > > > >  b/arch/powerpc/platforms/powernv/Makefile    |    2 
> > > > >  b/arch/powerpc/platforms/powernv/opal-call.c |    2 
> > > > >  b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
> > > > >  b/arch/powerpc/platforms/powernv/pci.c       |   11 
> > > > >  b/arch/powerpc/platforms/powernv/pci.h       |   17 
> > > > >  b/arch/powerpc/platforms/pseries/pci.c       |   23 
> > > > >  b/drivers/vfio/pci/Kconfig                   |    6 
> > > > >  b/drivers/vfio/pci/Makefile                  |    1 
> > > > >  b/drivers/vfio/pci/vfio_pci.c                |   18 
> > > > >  b/drivers/vfio/pci/vfio_pci_private.h        |   14 
> > > > >  b/include/uapi/linux/vfio.h                  |   38 -
> > > > 
> > > > 
> > > > Hi Christoph,
> > > > 
> > > > FYI, these uapi changes break build of QEMU.
> > > 
> > > What uapi changes?
> > > 
> > 
> > All macros and structure definitions that are being removed
> > from include/uapi/linux/vfio.h by patch 1.
> > 
> > > What exactly breaks?
> > > 
> > 
> > These macros and types are used by the current QEMU code base.
> > Next time the QEMU source tree updates its copy of the kernel
> > headers, the compilation of affected code will fail.
> 
> So does QEMU use this api that is being removed, or does it just have
> some odd build artifacts of the uapi things?
> 

These are region subtypes definition and associated capabilities.
QEMU basically gets information on VFIO regions from the kernel
driver and for those regions with a nvlink2 subtype, it tries
to extract some more nvlink2 related info.

> What exactly is the error messages here?
> 

[55/143] Compiling C object libqemu-ppc64-softmmu.fa.p/hw_vfio_pci-quirks.c.o
FAILED: libqemu-ppc64-softmmu.fa.p/hw_vfio_pci-quirks.c.o 
cc -Ilibqemu-ppc64-softmmu.fa.p -I. -I../.. -Itarget/ppc -I../../target/ppc -I../../capstone/include/capstone -Iqapi -Itrace -Iui -Iui/shader -I/usr/include/pixman-1 -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -fdiagnostics-color=auto -pipe -Wall -Winvalid-pch -Werror -std=gnu99 -O2 -g -isystem /home/greg/Work/qemu/qemu-virtiofs/linux-headers -isystem linux-headers -iquote . -iquote /home/greg/Work/qemu/qemu-virtiofs -iquote /home/greg/Work/qemu/qemu-virtiofs/include -iquote /home/greg/Work/qemu/qemu-virtiofs/disas/libvixl -iquote /home/greg/Work/qemu/qemu-virtiofs/tcg/ppc -iquote /home/greg/Work/qemu/qemu-virtiofs/accel/tcg -pthread -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -Wstrict-prototypes -Wredundant-decls -Wundef -Wwrite-strings -Wmissing-prototypes -fno-strict-aliasing -fno-common -fwrapv -Wold-style-declaration -Wold-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wimplicit-fallthrough=2 -Wno-missing-include-dirs -Wno-shift-negative-value -Wno-psabi -fstack-protector-strong -fPIC -isystem../../linux-headers -isystemlinux-headers -DNEED_CPU_H '-DCONFIG_TARGET="ppc64-softmmu-config-target.h"' '-DCONFIG_DEVICES="ppc64-softmmu-config-devices.h"' -MD -MQ libqemu-ppc64-softmmu.fa.p/hw_vfio_pci-quirks.c.o -MF libqemu-ppc64-softmmu.fa.p/hw_vfio_pci-quirks.c.o.d -o libqemu-ppc64-softmmu.fa.p/hw_vfio_pci-quirks.c.o -c ../../hw/vfio/pci-quirks.c
../../hw/vfio/pci-quirks.c: In function ‘vfio_pci_nvidia_v100_ram_init’:
../../hw/vfio/pci-quirks.c:1597:36: error: ‘VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM’ undeclared (first use in this function); did you mean ‘VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD’?
                                    VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM,
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                    VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD
../../hw/vfio/pci-quirks.c:1597:36: note: each undeclared identifier is reported only once for each function it appears in
../../hw/vfio/pci-quirks.c:1603:44: error: ‘VFIO_REGION_INFO_CAP_NVLINK2_SSATGT’ undeclared (first use in this function); did you mean ‘VFIO_REGION_INFO_CAP_SPARSE_MMAP’?
     hdr = vfio_get_region_info_cap(nv2reg, VFIO_REGION_INFO_CAP_NVLINK2_SSATGT);
                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                            VFIO_REGION_INFO_CAP_SPARSE_MMAP
../../hw/vfio/pci-quirks.c:1624:49: error: dereferencing pointer to incomplete type ‘struct vfio_region_info_cap_nvlink2_ssatgt’
                         (void *) (uintptr_t) cap->tgt);
                                                 ^~
../../hw/vfio/pci-quirks.c: In function ‘vfio_pci_nvlink2_init’:
../../hw/vfio/pci-quirks.c:1646:36: error: ‘VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD’ undeclared (first use in this function); did you mean ‘VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD’?
                                    VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD,
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                    VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD
../../hw/vfio/pci-quirks.c:1653:36: error: ‘VFIO_REGION_INFO_CAP_NVLINK2_SSATGT’ undeclared (first use in this function); did you mean ‘VFIO_REGION_INFO_CAP_SPARSE_MMAP’?
                                    VFIO_REGION_INFO_CAP_NVLINK2_SSATGT);
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                    VFIO_REGION_INFO_CAP_SPARSE_MMAP
../../hw/vfio/pci-quirks.c:1661:36: error: ‘VFIO_REGION_INFO_CAP_NVLINK2_LNKSPD’ undeclared (first use in this function); did you mean ‘VFIO_REGION_INFO_CAP_SPARSE_MMAP’?
                                    VFIO_REGION_INFO_CAP_NVLINK2_LNKSPD);
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                    VFIO_REGION_INFO_CAP_SPARSE_MMAP
../../hw/vfio/pci-quirks.c:1685:52: error: dereferencing pointer to incomplete type ‘struct vfio_region_info_cap_nvlink2_ssatgt’
                         (void *) (uintptr_t) captgt->tgt);
                                                    ^~
../../hw/vfio/pci-quirks.c:1691:54: error: dereferencing pointer to incomplete type ‘struct vfio_region_info_cap_nvlink2_lnkspd’
                         (void *) (uintptr_t) capspeed->link_speed);
                                                      ^~

> And if we put the uapi .h file stuff back, is that sufficient for qemu
> to work, as it should be checking at runtime what the kernel has / has
> not anyway, right?
> 

Right. This will just be dead code in QEMU for newer kernels.

Anyway, as said in some other mail, it is probably time for QEMU to
start deprecating this code as well.

> thanks,
> 
> greg k-h

