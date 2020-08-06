Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC2423D46B
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgHFANc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Aug 2020 20:13:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:43086 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgHFANb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 20:13:31 -0400
IronPort-SDR: CCnQvBXdQG2rAKgIJwjByYUcADcRB+JRR4UTJHcJUxusEBT5saKeMepGqWk1P28eirIY5KJwZX
 h6Dc1VPv9KFw==
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="153826693"
X-IronPort-AV: E=Sophos;i="5.75,439,1589266800"; 
   d="scan'208";a="153826693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 17:13:26 -0700
IronPort-SDR: O+4ZBxorw0u5ywPhlz5HYztfE7PG/PVS2kRihrUtZGzMN4Cep/aEuXblIykJ5YwhLjuI41z2Jv
 y9HSTDrEPPlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,439,1589266800"; 
   d="scan'208";a="276237168"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 05 Aug 2020 17:13:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 17:13:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 17:13:24 -0700
Received: from orsmsx612.amr.corp.intel.com ([10.22.229.25]) by
 ORSMSX612.amr.corp.intel.com ([10.22.229.25]) with mapi id 15.01.1713.004;
 Wed, 5 Aug 2020 17:13:24 -0700
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
Thread-Index: AQHWX3hgWhQMXvQig0qc4n40fOCoeakUaOyAgAASsgCAFXzAsIAAqfsA//+MFHCAAH50AP//nxnA
Date:   Thu, 6 Aug 2020 00:13:24 +0000
Message-ID: <630e6a4dc17b49aba32675377f5a50e0@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com>
 <96a1eb5ccc724790b5404a642583919d@intel.com>
 <20200805221548.GK19097@mellanox.com>
 <70465fd3a7ae428a82e19f98daa779e8@intel.com>
 <20200805225330.GL19097@mellanox.com>
In-Reply-To: <20200805225330.GL19097@mellanox.com>
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
> Sent: Wednesday, August 5, 2020 3:54 PM
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
> On Wed, Aug 05, 2020 at 10:36:23PM +0000, Dey, Megha wrote:
> > Hi Jason,
> >
> > > From: Jason Gunthorpe <jgg@mellanox.com>
> > > Sent: Wednesday, August 5, 2020 3:16 PM
> > > To: Dey, Megha <megha.dey@intel.com>
> > > Cc: Marc Zyngier <maz@kernel.org>; Jiang, Dave
> > > <dave.jiang@intel.com>; vkoul@kernel.org; bhelgaas@google.com;
> > > rafael@kernel.org; gregkh@linuxfoundation.org; tglx@linutronix.de;
> > > hpa@zytor.com; alex.williamson@redhat.com; Pan, Jacob jun
> > > <jacob.jun.pan@intel.com>; Raj, Ashok <ashok.raj@intel.com>; Liu, Yi
> > > L <yi.l.liu@intel.com>; Lu, Baolu <baolu.lu@intel.com>; Tian, Kevin
> > > <kevin.tian@intel.com>; Kumar, Sanjay K <sanjay.k.kumar@intel.com>;
> > > Luck, Tony <tony.luck@intel.com>; Lin, Jing <jing.lin@intel.com>;
> > > Williams, Dan J <dan.j.williams@intel.com>; kwankhede@nvidia.com;
> > > eric.auger@redhat.com; parav@mellanox.com; Hansen, Dave
> > > <dave.hansen@intel.com>; netanelg@mellanox.com;
> > > shahafs@mellanox.com; yan.y.zhao@linux.intel.com;
> > > pbonzini@redhat.com; Ortiz, Samuel <samuel.ortiz@intel.com>;
> > > Hossain, Mona <mona.hossain@intel.com>; dmaengine@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; x86@kernel.org;
> > > linux-pci@vger.kernel.org; kvm@vger.kernel.org
> > > Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new
> > > DEV_MSI irq domain
> > >
> > > On Wed, Aug 05, 2020 at 07:18:39PM +0000, Dey, Megha wrote:
> > >
> > > > Hence we will only have one create_dev_msi_domain which can be
> > > > called by any device driver that wants to use the dev-msi IRQ
> > > > domain to alloc/free IRQs. It would be the responsibility of the
> > > > device driver to provide the correct device and update the dev-
> >msi_domain.
> > >
> > > I'm not sure that sounds like a good idea, why should a device
> > > driver touch dev-
> > > >msi_domain?
> > >
> > > There was a certain appeal to the api I suggested by having
> > > everything related to setting up the new IRQs being in the core code.
> >
> > The basic API to create the dev_msi domain would be :
> >
> > struct irq_domain *create_dev_msi_irq_domain(struct irq_domain
> > *parent)
> >
> > This can be called by devices according to their use case.
> >
> > For e.g. in dsa case, it is called from the irq remapping driver:
> > iommu->ir_dev_msi_domain = create_dev_msi_domain(iommu->ir_domain)
> >
> > and from the dsa mdev driver:
> > p_dev = get_parent_pci_dev(dev);
> > iommu = device_to_iommu(p_dev);
> >
> > dev->msi_domain = iommu->ir_dev_msi_domain;
> >
> > So we are creating the domain in the IRQ  remapping domain which can be
> used by other devices which want to have the same IRQ parent domain and use
> dev-msi APIs. We are only updating that device's msi_domain to the already
> created dev-msi domain in the driver.
> >
> > Other devices (your rdma driver etc) can create their own dev-msi domain by
> passing the appropriate parent IRq domain.
> >
> > We cannot have this in the core code since the parent domain cannot be
> > the same?
> 
> Well, I had suggested to pass in the parent struct device, but it could certainly
> use an irq_domain instead:
> 
>   platform_msi_assign_domain(dev, device_to_iommu(p_dev)->ir_domain);
> 
> Or
> 
>   platform_msi_assign_domain(dev, pdev->msi_domain)
> 
> ?
> 
> Any maybe the natural expression is to add a version of
> platform_msi_create_device_domain() that accepts a parent irq_domain() and if
> the device doesn't already have a msi_domain then it creates one. Might be too
> tricky to manage lifetime of the new irq_domain though..
> 
> It feels cleaner to me if everything related to this is contained in the
> platform_msi and the driver using it. Not sure it makes sense to involve the
> iommu?

Well yeah something like this can be done, but what is the missing piece is where the IRQ domain actually gets created, i.e where this new version of platform_msi_create_device_domain() is called. That is the only piece that is currently done in the IOMMU driver only for DSA mdev. Not that all devices need to do it this way.. do you have suggestions as to where you want to call this function?
> 
> Jason
