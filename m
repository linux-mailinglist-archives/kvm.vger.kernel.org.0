Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096031B6BEF
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 05:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgDXD2u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 23 Apr 2020 23:28:50 -0400
Received: from mga04.intel.com ([192.55.52.120]:34397 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgDXD2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 23:28:50 -0400
IronPort-SDR: UUrLiGM9xcMsmt+QDF0ewLH8SJrQte05+qCL18uXYumBJ39SISnL4f+eaHD46rl3cQuvANqn+o
 osttQ+guWafQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 20:28:49 -0700
IronPort-SDR: pzl9dtMFRZhChMtwd5ukGkpNPLL/dGlp1aspkx9QDkLzpC25kdGaaoQwJAkSksEwp6WWh4y5UZ
 elqPgn1QSPbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,310,1583222400"; 
   d="scan'208";a="291420455"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga002.fm.intel.com with ESMTP; 23 Apr 2020 20:28:49 -0700
Received: from fmsmsx111.amr.corp.intel.com (10.18.116.5) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Apr 2020 20:27:46 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx111.amr.corp.intel.com (10.18.116.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Apr 2020 20:27:45 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.89]) with mapi id 14.03.0439.000;
 Fri, 24 Apr 2020 11:27:42 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Thread-Topic: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Thread-Index: AQHWGDVStT24LxQ110qc/YDRWdRX86iDuewAgACI/wCAAD7wgIAAnasAgAFwKICAAOPOMA==
Date:   Fri, 24 Apr 2020 03:27:41 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com> <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
In-Reply-To: <20200423191217.GD13640@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@mellanox.com>
> Sent: Friday, April 24, 2020 3:12 AM
> 
> On Wed, Apr 22, 2020 at 02:14:36PM -0700, Raj, Ashok wrote:
> > Hi Jason
> >
> > > > >
> > > > > I'm feeling really skeptical that adding all this PCI config space and
> > > > > MMIO BAR emulation to the kernel just to cram this into a VFIO
> > > > > interface is a good idea, that kind of stuff is much safer in
> > > > > userspace.
> > > > >
> > > > > Particularly since vfio is not really needed once a driver is using
> > > > > the PASID stuff. We already have general code for drivers to use to
> > > > > attach a PASID to a mm_struct - and using vfio while disabling all the
> > > > > DMA/iommu config really seems like an abuse.
> > > >
> > > > Well, this series is for virtualizing idxd device to VMs, instead of
> > > > supporting SVA for bare metal processes. idxd implements a
> > > > hardware-assisted mediated device technique called Intel Scalable
> > > > I/O Virtualization,
> > >
> > > I'm familiar with the intel naming scheme.
> > >
> > > > which allows each Assignable Device Interface (ADI, e.g. a work
> > > > queue) tagged with an unique PASID to ensure fine-grained DMA
> > > > isolation when those ADIs are assigned to different VMs. For this
> > > > purpose idxd utilizes the VFIO mdev framework and IOMMU aux-
> domain
> > > > extension. Bare metal SVA will be enabled for idxd later by using
> > > > the general SVA code that you mentioned.  Both paths will co-exist
> > > > in the end so there is no such case of disabling DMA/iommu config.
> > >
> > > Again, if you will have a normal SVA interface, there is no need for a
> > > VFIO version, just use normal SVA for both.
> > >
> > > PCI emulation should try to be in userspace, not the kernel, for
> > > security.
> >
> > Not sure we completely understand your proposal. Mediated devices
> > are software constructed and they have protected resources like
> > interrupts and stuff and VFIO already provids abstractions to export
> > to user space.
> >
> > Native SVA is simply passing the process CR3 handle to IOMMU so
> > IOMMU knows how to walk process page tables, kernel handles things
> > like page-faults, doing device tlb invalidations and such.
> 
> > That by itself doesn't translate to what a guest typically does
> > with a VDEV. There are other control paths that need to be serviced
> > from the kernel code via VFIO. For speed path operations like
> > ringing doorbells and such they are directly managed from guest.
> 
> You don't need vfio to mmap BAR pages to userspace. The unique thing
> that vfio gives is it provides a way to program the classic non-PASID
> iommu, which you are not using here.

That unique thing is indeed used here. Please note sharing CPU virtual 
address space with device (what SVA API is invented for) is not the
purpose of this series. We still rely on classic non-PASID iommu programming, 
i.e. mapping/unmapping IOVA->HPA per iommu_domain. Although 
we do use PASID to tag ADI, the PASID is contained within iommu_domain 
and invisible to VFIO. From userspace p.o.v, this is a device passthrough
usage instead of PASID-based address space binding.

> 
> > How do you propose to use the existing SVA api's  to also provide
> > full device emulation as opposed to using an existing infrastructure
> > that's already in place?
> 
> You'd provide the 'full device emulation' in userspace (eg qemu),
> along side all the other device emulation. Device emulation does not
> belong in the kernel without a very good reason.

The problem is that we are not doing full device emulation. It's based
on mediated passthrough. Some emulation logic requires close 
engagement with kernel device driver, e.g. resource allocation, WQ 
configuration, fault report, etc., while the detail interface is very vendor/
device specific (just like between PF and VF). idxd is just the first 
device that supports Scalable IOV. We have a lot more coming later, 
in different types. Then putting such emulation in user space means 
that Qemu needs to support all those vendor specific interfaces for 
every new device which supports Scalable IOV. This is contrast to our 
goal of using Scalable IOV as an alternative to SR-IOV. For SR-IOV, 
Qemu only needs to support one VFIO API then any VF type simply 
works. We want to sustain the same user experience through VFIO 
mdev. 

Specifically for PCI config space emulation, now it's already done 
in multiple kernel places, e.g. vfio-pci, kvmgt, etc. We do plan to 
consolidate them later.

> 
> You get the doorbell BAR page from your own char dev
> 
> You setup a PASID IOMMU configuration over your own char dev
> 
> Interrupt delivery is triggering a generic event fd
> 
> What is VFIO needed for?

Based on above explanation VFIO mdev already meets all of our
requirements then why bother inventing a new one...

> 
> > Perhaps Alex can ease Jason's concerns?
> 
> Last we talked Alex also had doubts on what mdev should be used
> for. It is a feature that seems to lack boundaries, and I'll note that
> when the discussion came up for VDPA, they eventually choose not to
> use VFIO.
> 

Is there a link to Alex's doubt? I'm not sure why vDPA didn't go 
for VFIO, but imho it is a different story. vDPA is specifically for
devices which implement standard vhost/virtio interface, thus
it's reasonable that inventing a new mechanism might be more
efficient for all vDPA type devices. However Scalable IOV is
similar to SR-IOV, only for resource partitioning. It doesn't change
the device programming interface, which could be in any vendor
specific form. Here VFIO mdev is good for providing an unified 
interface for managing resource multiplexing of all such devices.

Thanks
Kevin
