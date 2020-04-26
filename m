Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE01B8C86
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 07:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgDZFTF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 26 Apr 2020 01:19:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:51368 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgDZFTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 01:19:04 -0400
IronPort-SDR: hStMhTZAkqFLa55C01+YYoGLp99FdLDXZ8kddbY0rv/j5Xk+ZJx62WhereHrmJgXp7WCdWB0so
 /sQYssz8qgPQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2020 22:19:04 -0700
IronPort-SDR: 7oUFACyYMaI58TCLvNzIfWtr9icVHR6F93W0fNWs0ro27ExULtxG2c/75WZ1yLrb25XmRP1XIf
 nGedbiD9SlZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,318,1583222400"; 
   d="scan'208";a="256851019"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga003.jf.intel.com with ESMTP; 25 Apr 2020 22:19:03 -0700
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 25 Apr 2020 22:19:03 -0700
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 25 Apr 2020 22:19:03 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.22]) with mapi id 14.03.0439.000;
 Sun, 26 Apr 2020 13:18:58 +0800
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
Thread-Index: AQHWGDVStT24LxQ110qc/YDRWdRX86iDuewAgACI/wCAAD7wgIAAnasAgAFwKICAAOPOMIAAQj8AgACkdbD//7b+gIACl9WQ
Date:   Sun, 26 Apr 2020 05:18:59 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com> <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
In-Reply-To: <20200424181203.GU13640@mellanox.com>
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
> Sent: Saturday, April 25, 2020 2:12 AM
> 
> > > > idxd is just the first device that supports Scalable IOV. We have a
> > > > lot more coming later, in different types. Then putting such
> > > > emulation in user space means that Qemu needs to support all those
> > > > vendor specific interfaces for every new device which supports
> > >
> > > It would be very sad to see an endless amount of device emulation code
> > > crammed into the kernel. Userspace is where device emulation is
> > > supposed to live. For security
> >
> > I think providing an unified abstraction to userspace is also important,
> > which is what VFIO provides today. The merit of using one set of VFIO
> > API to manage all kinds of mediated devices and VF devices is a major
> > gain. Instead, inventing a new vDPA-like interface for every Scalable-IOV
> > or equivalent device is just overkill and doesn't scale. Also the actual
> > emulation code in idxd driver is actually small, if putting aside the PCI
> > config space part for which I already explained most logic could be shared
> > between mdev device drivers.
> 
> If it was just config space you might have an argument, VFIO already
> does some config space mangling, but emulating BAR space is out of
> scope of VFIO, IMHO.

out of scope of vfio-pci, but in scope of vfio-mdev. btw I feel that most
of your objections are actually related to the general idea of vfio-mdev.
Scalable IOV just uses PASID to harden DMA isolation in mediated
pass-through usage which vfio-mdev enables. Then are you just opposing
the whole vfio-mdev? If not, I'm curious about the criteria in your mind 
about when using vfio-mdev is good...

> 
> I also think it is disingenuous to pretend this is similar to
> SR-IOV. SR-IOV is self contained and the BAR does not require
> emulation. What you have here sounds like it is just an ordinary

technically Scalable IOV is definitely different from SR-IOV. It's 
simpler in hardware. And we're not emulating SR-IOV. The point
is just in usage-wise we want to present a consistent user 
experience just like passing through a PCI endpoint (PF or VF) device
through vfio eco-system, including various userspace VMMs (Qemu,
firecracker, rust-vmm, etc.), middleware (Libvirt), and higher level 
management stacks. 

> multi-queue device with the ability to PASID tag queues for IOMMU
> handling. This is absolutely not SRIOV - it is much closer to VDPA,
> which isn't using mdev.
> 
> Further, I disagree with your assessment that this doesn't scale. You
> already said you plan a normal user interface for idxd, so instead of
> having a single sane user interface (ala VDPA) idxd now needs *two*. If
> this is the general pattern of things to come, it is a bad path.
> 
> The only thing we get out of this is someone doesn't have to write a
> idxd emulation driver in qemu, instead they have to write it in the
> kernel. I don't see how that is a win for the ecosystem.
> 

No. The clear win is on leveraging classic VFIO iommu and its eco-system
as explained above.

Thanks
Kevin
