Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE3A26596D
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 08:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725769AbgIKGgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 02:36:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:14213 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgIKGge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 02:36:34 -0400
IronPort-SDR: ffTjqllB86hcw9SeHzkIa0nbPv1cH8BcE3mnZsOw+zebubP7doaOR635FQMZMDyZQj2X3ab83c
 um2Pkkg6W/zA==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="146427539"
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="146427539"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 23:36:33 -0700
IronPort-SDR: MnKTbz1wKUKBSKlcq4a3/jdmnOH/0Ai3/6yFLezlrY3VPNJMjNqoF6J61fRjLKsMRVaxUT5QMY
 gFcETucm4vYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,414,1592895600"; 
   d="scan'208";a="305150579"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.141])
  by orsmga006.jf.intel.com with ESMTP; 10 Sep 2020 23:36:30 -0700
Date:   Fri, 11 Sep 2020 14:32:13 +0800
From:   Xu Yilun <yilun.xu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     mdf@kernel.org, kwankhede@nvidia.com, linux-fpga@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, trix@redhat.com,
        lgoncalv@redhat.com,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>, yilun.xu@intel.com
Subject: Re: [PATCH 3/3] Documentation: fpga: dfl: Add description for VFIO
   Mdev support
Message-ID: <20200911063213.GA7802@yilunxu-OptiPlex-7050>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
 <1599549212-24253-4-git-send-email-yilun.xu@intel.com>
 <20200908151002.553ed7ae@w520.home>
 <20200910083230.GA16318@yilunxu-OptiPlex-7050>
 <20200910094903.51deb038@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910094903.51deb038@x1.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 09:49:03AM -0600, Alex Williamson wrote:
> On Thu, 10 Sep 2020 16:32:30 +0800
> Xu Yilun <yilun.xu@intel.com> wrote:
> 
> > Hi Alex:
> > 
> > Thanks for your quick response and is helpful to me. I did some more
> > investigation and some comments inline.
> > 
> > On Tue, Sep 08, 2020 at 03:10:02PM -0600, Alex Williamson wrote:
> > > On Tue,  8 Sep 2020 15:13:32 +0800
> > > Xu Yilun <yilun.xu@intel.com> wrote:
> > >   
> > > > This patch adds description for VFIO Mdev support for dfl devices on
> > > > dfl bus.
> > > > 
> > > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > > Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
> > > > ---
> > > >  Documentation/fpga/dfl.rst | 20 ++++++++++++++++++++
> > > >  1 file changed, 20 insertions(+)
> > > > 
> > > > diff --git a/Documentation/fpga/dfl.rst b/Documentation/fpga/dfl.rst
> > > > index 0404fe6..f077754 100644
> > > > --- a/Documentation/fpga/dfl.rst
> > > > +++ b/Documentation/fpga/dfl.rst
> > > > @@ -502,6 +502,26 @@ FME Partial Reconfiguration Sub Feature driver (see drivers/fpga/dfl-fme-pr.c)
> > > >  could be a reference.
> > > >  
> > > >  
> > > > +VFIO Mdev support for DFL devices
> > > > +=================================
> > > > +As we introduced a dfl bus for private features, they could be added to dfl bus
> > > > +as independent dfl devices. There is a requirement to handle these devices
> > > > +either by kernel drivers or by direct access from userspace. Usually we bind
> > > > +the kernel drivers to devices which provide board management functions, and
> > > > +gives user direct access to devices which cooperate closely with user
> > > > +controlled Accelerated Function Unit (AFU). We realize this with a VFIO Mdev
> > > > +implementation. When we bind the vfio-mdev-dfl driver to a dfl device, it
> > > > +realizes a group of callbacks and registers to the Mdev framework as a
> > > > +parent (physical) device. It could then create one (available_instances == 1)
> > > > +mdev device.
> > > > +Since dfl devices are sub devices of FPGA DFL physical devices (e.g. PCIE
> > > > +device), which provide no DMA isolation for each sub device, this may leads to
> > > > +DMA isolation problem if a private feature is designed to be capable of DMA.
> > > > +The AFU user could potentially access the whole device addressing space and
> > > > +impact the private feature. So now the general HW design rule is, no DMA
> > > > +capability for private features. It eliminates the DMA isolation problem.  
> > > 
> > > What's the advantage of entangling mdev/vfio in this approach versus
> > > simply exposing the MMIO region of the device via sysfs (similar to a
> > > resource file in pci-sysfs)?  This implementation doesn't support
> > > interrupts, it doesn't support multiplexing of a device, it doesn't
> > > perform any degree of mediation, it seems to simply say "please don't
> > > do DMA".  I don't think that's acceptable for an mdev driver.  If you
> > > want to play loose with isolation, do it somewhere else.  Thanks,  
> > 
> > The intention of the patchset is to enable the userspace drivers for dfl
> > devices. The dfl devices are actually different IP blocks integrated in
> > FPGA to support different board functionalities. They are sub devices of
> > the FPGA PCIe device. Their mmio blocks are in PCIE bar regions. And we
> > want some of the dfl devices handled by the userspace drivers.
> > 
> > Some dfl devices are capable of interrupt. I didn't add interrupt code
> > in this patch cause now the IRQ capable dfl devices are all handled by
> > kernel drivers. But as a generic FPGA platform, IRQ handling for userspace
> > drivers should be supported.
> > 
> > And I can see there are several ways to enable the userspace driver.
> > 
> > 1. Some specific sysfs like pci do. But seems it is not the common way for
> > userspace driver. It does't support interrupt. And potentially users
> > operate on the same mmio region together with kernel driver at the same
> > time.
> > 
> > 2. VFIO driver with NOIOMMU enabled. I think it meets our needs. Do you
> > think it is good we implement an VFIO driver for dfl devices?
> > 
> > 3. VFIO mdev. I implemented it because it will not block us from lacking
> > of valid iommu group. And since the driver didn't perform any mediation,
> > I should give up.
> > 
> > 4. UIO driver. It should work. I'm wondering if option 2 covers the
> > functionalities of UIO and has more enhancement. So option 2 may be
> > better?
> > 
> > Thanks again for your time, and I really appreciate you would give some
> > guide on it.
> 
> 
> VFIO no-iommu was intended as a transition helper for platforms that do
> not support an IOMMU, particularly running within a VM where we use
> regular, IOMMU protected devices within the host, but allow no-iommu
> within the guest such that the host is still protected from the guest
> sandbox.  There should be no new use cases of no-iommu, it's unsafe, it
> taints the kernel where it's used (guest in the above intended use
> case).  If you intend long term distribution support of a solution,
> VFIO no-iommu should not be considered an option.
> 
> VFIO mdev requires that the mdev vendor driver mediates access to the
> device in order to provide isolation.  In the initial vGPU use cases,
> we expect that isolation to be provided via devices specific means, ex.
> GPU GART, but we've since included system level components like IOMMU
> backing devices and auxiliary domains, the latter to make use of IOMMU
> PASID support.
> 
> As implemented in this proposal, mdev is being used only to subvert the
> IOMMU grouping requirements of VFIO in order to order to expose a
> device that is potentially fully capable of DMA to userspace with no
> isolation whatsoever.  If not for the IOMMU grouping, this driver could
> simply be a VFIO bus driver making use of the vfio-platform interface.
> Either way, without isolation, this does not belong in the realm of
> VFIO.
> 
> Given your architecture, the only potentially valid mdev use case I can
> see would be if the mdev vendor driver binds to the PCIe device,
> allowing multiplexing of the parent device by carving out fpga
> functional blocks from MMIO BAR space, and providing isolation by
> enforcing that the parent device never enables bus master, assuming
> that would prevent any of the fpga sub-components from performing DMA.
> 
> Are there worthwhile use cases of these fpga devices without DMA?

The board (Intel PAC N3000) we want to support is a Smart NIC. The FPGA
part is responsible for the various MAC layer offloading. The software
for FPGA usually doesn't touch the network data stream (they are all
handled by FPGA logic), it does some configurations and link status
reading so no DMA is required. These configurations are sometimes very
specific to dynamic RTL logic developed by user, so this is the purpose
we handle them in userspace.

There are some other usercases, which use FPGA to do some dedicated
algorithm like for deep learning. They need to perform memory in and
memory out. For these cases, it seems possible we carving out the
related part as the mdev, leaving management part in parent device
driver.

> 
> If you need DMA (or the device is potentially capable of DMA and
> cannot be audited to prevent it) and cannot provide isolation then
> please don't use VFIO or mdev, doing so would violate the notion of
> secure userspace device access that we've worked to achieve in this
> ecosystem.
> 
> If you choose another route, pci-sysfs already provides full BAR access
> via the resource files in sysfs, but you could also expose individual
> sysfs files with the same capabilities per fpga functional unit to
> resolve the conflict between kernel and userspace "ownership".  UIO
> might also be a solution.  This proposal to restrict userspace usage to
> devices that don't perform DMA is akin to uio_pci_generic, where the
> user is not expected to enable bus master, but nothing prevents them

We are going to exposes these devices not capable of DMA, so seems UIO
is the right way to go.

> from doing so and as a result it's a gateway for all sorts of
> unsupportable drivers.  mdev should not be used to follow that example.



I should thank you again for the detail explanation.

Yilun


> Thanks,
> 
> Alex
