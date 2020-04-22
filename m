Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B401B342F
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 02:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgDVAxc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 21 Apr 2020 20:53:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:52603 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDVAxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 20:53:32 -0400
IronPort-SDR: EKI54qKrr30rVClxbdzn2R6r6SktghpvXfjaDFOE9vu9esEhZapSN3QL0xXG8eqRxBldXJhm/N
 OrtgV69SIJiQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 17:53:31 -0700
IronPort-SDR: 6BvZNWKAkfEmtMuPX9NJM/DT2T0OL58dZHnYXUjIma0xZO8x1qj0CkCR3Q2GnadwpmmFhzZvUf
 sQJMrcy45FuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,412,1580803200"; 
   d="scan'208";a="334451596"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2020 17:53:30 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 17:53:30 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 17:53:30 -0700
Received: from shsmsx105.ccr.corp.intel.com (10.239.4.158) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 Apr 2020 17:53:29 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX105.ccr.corp.intel.com ([169.254.11.213]) with mapi id 14.03.0439.000;
 Wed, 22 Apr 2020 08:53:26 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>,
        "Jiang, Dave" <dave.jiang@intel.com>
CC:     "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Thread-Index: AQHWGDVStT24LxQ110qc/YDRWdRX86iDuewAgACI/wA=
Date:   Wed, 22 Apr 2020 00:53:25 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
In-Reply-To: <20200421235442.GO11945@mellanox.com>
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
> Sent: Wednesday, April 22, 2020 7:55 AM
> 
> On Tue, Apr 21, 2020 at 04:33:46PM -0700, Dave Jiang wrote:
> > The actual code is independent of the stage 2 driver code submission that
> adds
> > support for SVM, ENQCMD(S), PASID, and shared workqueues. This code
> series will
> > support dedicated workqueue on a guest with no vIOMMU.
> >
> > A new device type "mdev" is introduced for the idxd driver. This allows the
> wq
> > to be dedicated to the usage of a VFIO mediated device (mdev). Once the
> work
> > queue (wq) is enabled, an uuid generated by the user can be added to the
> wq
> > through the uuid sysfs attribute for the wq.  After the association, a mdev
> can
> > be created using this UUID. The mdev driver code will associate the uuid
> and
> > setup the mdev on the driver side. When the create operation is successful,
> the
> > uuid can be passed to qemu. When the guest boots up, it should discover a
> DSA
> > device when doing PCI discovery.
> 
> I'm feeling really skeptical that adding all this PCI config space and
> MMIO BAR emulation to the kernel just to cram this into a VFIO
> interface is a good idea, that kind of stuff is much safer in
> userspace.
> 
> Particularly since vfio is not really needed once a driver is using
> the PASID stuff. We already have general code for drivers to use to
> attach a PASID to a mm_struct - and using vfio while disabling all the
> DMA/iommu config really seems like an abuse.

Well, this series is for virtualizing idxd device to VMs, instead of supporting
SVA for bare metal processes. idxd implements a hardware-assisted 
mediated device technique called Intel Scalable I/O Virtualization, which
allows each Assignable Device Interface (ADI, e.g. a work queue) tagged 
with an unique PASID to ensure fine-grained DMA isolation when those 
ADIs are assigned to different VMs. For this purpose idxd utilizes the VFIO 
mdev framework and IOMMU aux-domain extension. Bare metal SVA will
be enabled for idxd later by using the general SVA code that you mentioned.
Both paths will co-exist in the end so there is no such case of disabling
DMA/iommu config.

Thanks
Kevin

> 
> A /dev/idxd char dev that mmaps a bar page and links it to a PASID
> seems a lot simpler and saner kernel wise.
> 
> > The mdev utilizes Interrupt Message Store or IMS[3] instead of MSIX for
> > interrupts for the guest. This preserves MSIX for host usages and also
> allows a
> > significantly larger number of interrupt vectors for guest usage.
> 
> I never did get a reply to my earlier remarks on the IMS patches.
> 
> The concept of a device specific addr/data table format for MSI is not
> Intel specific. This should be general code. We have a device that can
> use this kind of kernel capability today.
> 
> Jason
