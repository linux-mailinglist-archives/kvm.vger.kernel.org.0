Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E5523D494
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgHFAcf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Aug 2020 20:32:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:18720 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgHFAce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:32:34 -0400
IronPort-SDR: proXUrCCttZkmzAK03vXodkGImcgi0EhtpJ7bY4ZJni0Plx2H2yQcefov+HTnfLaAYqd6p9Th6
 beCPYutJKmJw==
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="152653002"
X-IronPort-AV: E=Sophos;i="5.75,439,1589266800"; 
   d="scan'208";a="152653002"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 17:32:33 -0700
IronPort-SDR: /RBJXjWK3vicstBbdidngjOiYQze8OfL+WPSfTb10wEIoEBnx5cSLwm2AC+8qC52vom88d+bk/
 /mHJ6glH6EAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,439,1589266800"; 
   d="scan'208";a="493010842"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2020 17:32:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 17:32:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 17:32:31 -0700
Received: from orsmsx612.amr.corp.intel.com ([10.22.229.25]) by
 ORSMSX612.amr.corp.intel.com ([10.22.229.25]) with mapi id 15.01.1713.004;
 Wed, 5 Aug 2020 17:32:31 -0700
From:   "Dey, Megha" <megha.dey@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     Marc Zyngier <maz@kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Thread-Topic: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Thread-Index: AQHWX3hgWhQMXvQig0qc4n40fOCoeakUaOyAgAASsgCAFXzAsIAAqfsA//+MFHCAAH50AP//nxnAgAB464D//4sXoA==
Date:   Thu, 6 Aug 2020 00:32:31 +0000
Message-ID: <c6a1c065ab9b46bbaf9f5713462085a5@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com>
 <96a1eb5ccc724790b5404a642583919d@intel.com>
 <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
 <630e6a4dc17b49aba32675377f5a50e0@intel.com>
 <20200806001927.GM19097@mellanox.com>
In-Reply-To: <20200806001927.GM19097@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe <jgg@mellanox.com>
> Sent: Wednesday, August 5, 2020 5:19 PM
> To: Dey, Megha <megha.dey@intel.com>
> Cc: Marc Zyngier <maz@kernel.org>; Jiang, Dave <dave.jiang@intel.com>;
> vkoul@kernel.org; bhelgaas@google.com; rafael@kernel.org;
> gregkh@linuxfoundation.org; tglx@linutronix.de; hpa@zytor.com;
> alex.williamson@redhat.com; Pan, Jacob jun <jacob.jun.pan@intel.com>; Raj,
> Ashok <ashok.raj@intel.com>; Liu, Yi L <yi.l.liu@intel.com>; Lu, Baolu
> <baolu.lu@intel.com>; Tian, Kevin <kevin.tian@intel.com>; Kumar, Sanjay K
> <sanjay.k.kumar@intel.com>; Luck, Tony <tony.luck@intel.com>; Lin, Jing
> <jing.lin@intel.com>; Williams, Dan J <dan.j.williams@intel.com>;
> kwankhede@nvidia.com; eric.auger@redhat.com; parav@mellanox.com;
> Hansen, Dave <dave.hansen@intel.com>; netanelg@mellanox.com;
> shahafs@mellanox.com; yan.y.zhao@linux.intel.com; pbonzini@redhat.com;
> Ortiz, Samuel <samuel.ortiz@intel.com>; Hossain, Mona
> <mona.hossain@intel.com>; dmaengine@vger.kernel.org; linux-
> kernel@vger.kernel.org; x86@kernel.org; linux-pci@vger.kernel.org;
> kvm@vger.kernel.org
> Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
> irq domain
> 
> On Thu, Aug 06, 2020 at 12:13:24AM +0000, Dey, Megha wrote:
> > > Well, I had suggested to pass in the parent struct device, but it
> > > could certainly use an irq_domain instead:
> > >
> > >   platform_msi_assign_domain(dev,
> > > device_to_iommu(p_dev)->ir_domain);
> > >
> > > Or
> > >
> > >   platform_msi_assign_domain(dev, pdev->msi_domain)
> > >
> > > ?
> > >
> > > Any maybe the natural expression is to add a version of
> > > platform_msi_create_device_domain() that accepts a parent
> > > irq_domain() and if the device doesn't already have a msi_domain
> > > then it creates one. Might be too tricky to manage lifetime of the new
> irq_domain though..
> > >
> > > It feels cleaner to me if everything related to this is contained in
> > > the platform_msi and the driver using it. Not sure it makes sense to
> > > involve the iommu?
> >
> > Well yeah something like this can be done, but what is the missing
> > piece is where the IRQ domain actually gets created, i.e where this
> > new version of platform_msi_create_device_domain() is called. That is
> > the only piece that is currently done in the IOMMU driver only for DSA
> > mdev. Not that all devices need to do it this way.. do you have
> > suggestions as to where you want to call this function?
> 
> Oops, I was thinking of platform_msi_domain_alloc_irqs() not
> create_device_domain()
> 
> ie call it in the device driver that wishes to consume the extra MSIs.
> 
> Is there a harm if each device driver creates a new irq_domain for its use?

Well, the only harm is if we want to reuse the irq domain.

As of today, we only have DSA mdev which uses the dev-msi domain. In the IRQ domain hierarchy,
We will have this:

Vector-> intel-ir->dev-msi 

So tmrw if we have a new device, which would also want to have the intel-ir as the parent and use the same domain ops, we will simply be creating a copy of this IRQ domain, which may not be very fruitful.

But apart from that, I don't think there are any issues..

What do you think is the best approach here?
> 
> Jason
