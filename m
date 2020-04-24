Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905891B7B89
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 18:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgDXQ0I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 24 Apr 2020 12:26:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:59598 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727843AbgDXQ0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 12:26:07 -0400
IronPort-SDR: M45TnLJIdqJfXj3EBAj2yAdJsrso4w+8M34IPjvAZ1w4JOqU41Chv+jzQ34z32guoFL1jY0KXg
 l6WnM54czLFg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 09:26:05 -0700
IronPort-SDR: sMPovo0w/QjfFeZ2GraoucfQ+YJQEMvNP/IzuYLavl671sAlZ01nHrwx6Ol1XKOp6SJBEmb/6l
 Y9fcBfjUsMCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="248104520"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga008.fm.intel.com with ESMTP; 24 Apr 2020 09:26:04 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 24 Apr 2020 09:26:01 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 Apr 2020 09:26:01 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 24 Apr 2020 09:26:00 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.22]) with mapi id 14.03.0439.000;
 Sat, 25 Apr 2020 00:25:56 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
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
Thread-Index: AQHWGDVStT24LxQ110qc/YDRWdRX86iDuewAgACI/wCAAD7wgIAAnasAgAFwKICAAOPOMIAAQj8AgACkdbA=
Date:   Fri, 24 Apr 2020 16:25:56 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com> <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
In-Reply-To: <20200424124444.GJ13640@mellanox.com>
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

> From: Jason Gunthorpe
> Sent: Friday, April 24, 2020 8:45 PM
> 
> On Fri, Apr 24, 2020 at 03:27:41AM +0000, Tian, Kevin wrote:
> 
> > > > That by itself doesn't translate to what a guest typically does
> > > > with a VDEV. There are other control paths that need to be serviced
> > > > from the kernel code via VFIO. For speed path operations like
> > > > ringing doorbells and such they are directly managed from guest.
> > >
> > > You don't need vfio to mmap BAR pages to userspace. The unique thing
> > > that vfio gives is it provides a way to program the classic non-PASID
> > > iommu, which you are not using here.
> >
> > That unique thing is indeed used here. Please note sharing CPU virtual
> > address space with device (what SVA API is invented for) is not the
> > purpose of this series. We still rely on classic non-PASID iommu
> programming,
> > i.e. mapping/unmapping IOVA->HPA per iommu_domain. Although
> > we do use PASID to tag ADI, the PASID is contained within iommu_domain
> > and invisible to VFIO. From userspace p.o.v, this is a device passthrough
> > usage instead of PASID-based address space binding.
> 
> So you have PASID support but don't use it? Why? PASID is much better
> than classic VFIO iommu, it doesn't require page pinning...

PASID and I/O page fault (through ATS/PRI) are orthogonal things. Don't
draw the equation between them. The host driver can tag PASID to 
ADI so every DMA request out of that ADI has a PASID prefix, allowing VT-d
to do PASID-granular DMA isolation. However I/O page fault cannot be
taken for granted. A scalable IOV device may support PASID while without
ATS/PRI. Even when ATS/PRI is supported, the tolerance of I/O page fault
is decided by the work queue mode that is configured by the guest. For 
example, if the guest put the work queue in non-faultable transaction 
mode, the device doesn't do PRI and simply report error if no valid IOMMU 
mapping.

So in this series we support only the basic form for non-faultable transactions,
using the classic VFIO iommu interface plus PASID-granular translation. 
We are working on virtual SVA support in parallel. Once that feature is ready, 
then I/O page fault could be CONDITIONALLY enabled according to guest 
vIOMMU setting, e.g. when virtual context entry has page request enabled 
then we enable nested translation in the physical PASID entry, with 1st 
level linking to guest page table (GVA->GPA) and 2nd-level carrying 
(GPA->HPA).

> 
> > > > How do you propose to use the existing SVA api's  to also provide
> > > > full device emulation as opposed to using an existing infrastructure
> > > > that's already in place?
> > >
> > > You'd provide the 'full device emulation' in userspace (eg qemu),
> > > along side all the other device emulation. Device emulation does not
> > > belong in the kernel without a very good reason.
> >
> > The problem is that we are not doing full device emulation. It's based
> > on mediated passthrough. Some emulation logic requires close
> > engagement with kernel device driver, e.g. resource allocation, WQ
> > configuration, fault report, etc., while the detail interface is very vendor/
> > device specific (just like between PF and VF).
> 
> Which sounds like the fairly classic case of device emulation to me.
> 
> > idxd is just the first device that supports Scalable IOV. We have a
> > lot more coming later, in different types. Then putting such
> > emulation in user space means that Qemu needs to support all those
> > vendor specific interfaces for every new device which supports
> 
> It would be very sad to see an endless amount of device emulation code
> crammed into the kernel. Userspace is where device emulation is
> supposed to live. For security

I think providing an unified abstraction to userspace is also important,
which is what VFIO provides today. The merit of using one set of VFIO 
API to manage all kinds of mediated devices and VF devices is a major
gain. Instead, inventing a new vDPA-like interface for every Scalable-IOV
or equivalent device is just overkill and doesn't scale. Also the actual
emulation code in idxd driver is actually small, if putting aside the PCI
config space part for which I already explained most logic could be shared
between mdev device drivers.

> 
> qemu is the right place to put this stuff.
> 
> > > > Perhaps Alex can ease Jason's concerns?
> > >
> > > Last we talked Alex also had doubts on what mdev should be used
> > > for. It is a feature that seems to lack boundaries, and I'll note that
> > > when the discussion came up for VDPA, they eventually choose not to
> > > use VFIO.
> > >
> >
> > Is there a link to Alex's doubt? I'm not sure why vDPA didn't go
> > for VFIO, but imho it is a different story.
> 
> No, not at all. VDPA HW today is using what Intel has been calling
> ADI. But qemu already had the device emulation part in userspace, (all
> of the virtio emulation parts are in userspace) so they didn't try to
> put it in the kernel.
> 
> This is the pattern. User space is supposed to do the emulation parts,
> the kernel provides the raw elements to manage queues/etc - and it is
> not done through mdev.
> 
> > efficient for all vDPA type devices. However Scalable IOV is
> > similar to SR-IOV, only for resource partitioning. It doesn't change
> > the device programming interface, which could be in any vendor
> > specific form. Here VFIO mdev is good for providing an unified
> > interface for managing resource multiplexing of all such devices.
> 
> SIOV doesn't have a HW config space, and for some reason in these
> patches there is BAR emulation too. So, no, it is not like SR-IOV at
> all.
> 
> This is more like classic device emulation, presumably with some fast
> path for the data plane. ie just like VDPA :)
> 
> Jason

Thanks
Kevin
