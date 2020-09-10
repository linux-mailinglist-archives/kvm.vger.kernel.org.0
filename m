Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0F9264EB7
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 21:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIJTXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 15:23:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55026 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731434AbgIJPte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 11:49:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599752954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rA8BS9/0jZ+l2MQA+dZBWWcPqUsG5Wsdp/FCuxiOFaM=;
        b=NSHPR5zhzsl5t/mbc63Ra8rric8q5IZj4jc6f/+ycvun5bWKz6E+Gx5ysHYXhxQ7asp0mf
        7JCF3bzUlZeDYwkreKrpqqeRvzd5nvJDvZPD8Q18hzs+dWY5shPT3h4rKwOSDe0dvzLdLF
        yHZn6ky+zR7oCt2j4+QQCJzZLIqvjIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-Lu5N34tZPGKIAJMthXwWzA-1; Thu, 10 Sep 2020 11:49:11 -0400
X-MC-Unique: Lu5N34tZPGKIAJMthXwWzA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 087AA84E246;
        Thu, 10 Sep 2020 15:49:05 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43B6319C71;
        Thu, 10 Sep 2020 15:49:04 +0000 (UTC)
Date:   Thu, 10 Sep 2020 09:49:03 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Xu Yilun <yilun.xu@intel.com>
Cc:     mdf@kernel.org, kwankhede@nvidia.com, linux-fpga@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, trix@redhat.com,
        lgoncalv@redhat.com,
        Matthew Gerlach <matthew.gerlach@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
Subject: Re: [PATCH 3/3] Documentation: fpga: dfl: Add description for VFIO
  Mdev support
Message-ID: <20200910094903.51deb038@x1.home>
In-Reply-To: <20200910083230.GA16318@yilunxu-OptiPlex-7050>
References: <1599549212-24253-1-git-send-email-yilun.xu@intel.com>
        <1599549212-24253-4-git-send-email-yilun.xu@intel.com>
        <20200908151002.553ed7ae@w520.home>
        <20200910083230.GA16318@yilunxu-OptiPlex-7050>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 10 Sep 2020 16:32:30 +0800
Xu Yilun <yilun.xu@intel.com> wrote:

> Hi Alex:
> 
> Thanks for your quick response and is helpful to me. I did some more
> investigation and some comments inline.
> 
> On Tue, Sep 08, 2020 at 03:10:02PM -0600, Alex Williamson wrote:
> > On Tue,  8 Sep 2020 15:13:32 +0800
> > Xu Yilun <yilun.xu@intel.com> wrote:
> >   
> > > This patch adds description for VFIO Mdev support for dfl devices on
> > > dfl bus.
> > > 
> > > Signed-off-by: Xu Yilun <yilun.xu@intel.com>
> > > Signed-off-by: Matthew Gerlach <matthew.gerlach@linux.intel.com>
> > > ---
> > >  Documentation/fpga/dfl.rst | 20 ++++++++++++++++++++
> > >  1 file changed, 20 insertions(+)
> > > 
> > > diff --git a/Documentation/fpga/dfl.rst b/Documentation/fpga/dfl.rst
> > > index 0404fe6..f077754 100644
> > > --- a/Documentation/fpga/dfl.rst
> > > +++ b/Documentation/fpga/dfl.rst
> > > @@ -502,6 +502,26 @@ FME Partial Reconfiguration Sub Feature driver (see drivers/fpga/dfl-fme-pr.c)
> > >  could be a reference.
> > >  
> > >  
> > > +VFIO Mdev support for DFL devices
> > > +=================================
> > > +As we introduced a dfl bus for private features, they could be added to dfl bus
> > > +as independent dfl devices. There is a requirement to handle these devices
> > > +either by kernel drivers or by direct access from userspace. Usually we bind
> > > +the kernel drivers to devices which provide board management functions, and
> > > +gives user direct access to devices which cooperate closely with user
> > > +controlled Accelerated Function Unit (AFU). We realize this with a VFIO Mdev
> > > +implementation. When we bind the vfio-mdev-dfl driver to a dfl device, it
> > > +realizes a group of callbacks and registers to the Mdev framework as a
> > > +parent (physical) device. It could then create one (available_instances == 1)
> > > +mdev device.
> > > +Since dfl devices are sub devices of FPGA DFL physical devices (e.g. PCIE
> > > +device), which provide no DMA isolation for each sub device, this may leads to
> > > +DMA isolation problem if a private feature is designed to be capable of DMA.
> > > +The AFU user could potentially access the whole device addressing space and
> > > +impact the private feature. So now the general HW design rule is, no DMA
> > > +capability for private features. It eliminates the DMA isolation problem.  
> > 
> > What's the advantage of entangling mdev/vfio in this approach versus
> > simply exposing the MMIO region of the device via sysfs (similar to a
> > resource file in pci-sysfs)?  This implementation doesn't support
> > interrupts, it doesn't support multiplexing of a device, it doesn't
> > perform any degree of mediation, it seems to simply say "please don't
> > do DMA".  I don't think that's acceptable for an mdev driver.  If you
> > want to play loose with isolation, do it somewhere else.  Thanks,  
> 
> The intention of the patchset is to enable the userspace drivers for dfl
> devices. The dfl devices are actually different IP blocks integrated in
> FPGA to support different board functionalities. They are sub devices of
> the FPGA PCIe device. Their mmio blocks are in PCIE bar regions. And we
> want some of the dfl devices handled by the userspace drivers.
> 
> Some dfl devices are capable of interrupt. I didn't add interrupt code
> in this patch cause now the IRQ capable dfl devices are all handled by
> kernel drivers. But as a generic FPGA platform, IRQ handling for userspace
> drivers should be supported.
> 
> And I can see there are several ways to enable the userspace driver.
> 
> 1. Some specific sysfs like pci do. But seems it is not the common way for
> userspace driver. It does't support interrupt. And potentially users
> operate on the same mmio region together with kernel driver at the same
> time.
> 
> 2. VFIO driver with NOIOMMU enabled. I think it meets our needs. Do you
> think it is good we implement an VFIO driver for dfl devices?
> 
> 3. VFIO mdev. I implemented it because it will not block us from lacking
> of valid iommu group. And since the driver didn't perform any mediation,
> I should give up.
> 
> 4. UIO driver. It should work. I'm wondering if option 2 covers the
> functionalities of UIO and has more enhancement. So option 2 may be
> better?
> 
> Thanks again for your time, and I really appreciate you would give some
> guide on it.


VFIO no-iommu was intended as a transition helper for platforms that do
not support an IOMMU, particularly running within a VM where we use
regular, IOMMU protected devices within the host, but allow no-iommu
within the guest such that the host is still protected from the guest
sandbox.  There should be no new use cases of no-iommu, it's unsafe, it
taints the kernel where it's used (guest in the above intended use
case).  If you intend long term distribution support of a solution,
VFIO no-iommu should not be considered an option.

VFIO mdev requires that the mdev vendor driver mediates access to the
device in order to provide isolation.  In the initial vGPU use cases,
we expect that isolation to be provided via devices specific means, ex.
GPU GART, but we've since included system level components like IOMMU
backing devices and auxiliary domains, the latter to make use of IOMMU
PASID support.

As implemented in this proposal, mdev is being used only to subvert the
IOMMU grouping requirements of VFIO in order to order to expose a
device that is potentially fully capable of DMA to userspace with no
isolation whatsoever.  If not for the IOMMU grouping, this driver could
simply be a VFIO bus driver making use of the vfio-platform interface.
Either way, without isolation, this does not belong in the realm of
VFIO.

Given your architecture, the only potentially valid mdev use case I can
see would be if the mdev vendor driver binds to the PCIe device,
allowing multiplexing of the parent device by carving out fpga
functional blocks from MMIO BAR space, and providing isolation by
enforcing that the parent device never enables bus master, assuming
that would prevent any of the fpga sub-components from performing DMA.

Are there worthwhile use cases of these fpga devices without DMA?

If you need DMA (or the device is potentially capable of DMA and
cannot be audited to prevent it) and cannot provide isolation then
please don't use VFIO or mdev, doing so would violate the notion of
secure userspace device access that we've worked to achieve in this
ecosystem.

If you choose another route, pci-sysfs already provides full BAR access
via the resource files in sysfs, but you could also expose individual
sysfs files with the same capabilities per fpga functional unit to
resolve the conflict between kernel and userspace "ownership".  UIO
might also be a solution.  This proposal to restrict userspace usage to
devices that don't perform DMA is akin to uio_pci_generic, where the
user is not expected to enable bus master, but nothing prevents them
from doing so and as a result it's a gateway for all sorts of
unsupportable drivers.  mdev should not be used to follow that example.
Thanks,

Alex

