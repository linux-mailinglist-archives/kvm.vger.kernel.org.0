Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A61723D2E3
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 22:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgHEUTj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Aug 2020 16:19:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:63556 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbgHEUTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 16:19:38 -0400
IronPort-SDR: jRg6g+aihljhKVo7IYgeHbtq/vxkD9PLlw7GqoDD5LgS2Pxs/4edTf5QWjmOs6aOllXRuZDjeL
 k0x+5YqCH5Cw==
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="132211385"
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="132211385"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 13:19:38 -0700
IronPort-SDR: w9VSCNrISXm96GGjOlNyk4yJ4AZEqjxtdap/DxRUPdcHd6GR7/SdzO2DGKE9Nih3CrBJdlNu3m
 RCa+339YsD3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="467585502"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 05 Aug 2020 13:19:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 13:19:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 13:19:36 -0700
Received: from orsmsx612.amr.corp.intel.com ([10.22.229.25]) by
 ORSMSX612.amr.corp.intel.com ([10.22.229.25]) with mapi id 15.01.1713.004;
 Wed, 5 Aug 2020 13:19:36 -0700
From:   "Dey, Megha" <megha.dey@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
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
Subject: RE: [PATCH RFC v2 04/18] irq/dev-msi: Introduce APIs to allocate/free
 dev-msi interrupts
Thread-Topic: [PATCH RFC v2 04/18] irq/dev-msi: Introduce APIs to
 allocate/free dev-msi interrupts
Thread-Index: AQHWX3heqXf8B+7kfUafGS9cbpYfH6kSrV6AgAExB0iAFi3TEA==
Date:   Wed, 5 Aug 2020 20:19:36 +0000
Message-ID: <8cdfef10438047f5ae7fc81770d32351@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534736176.28840.5547007059232964457.stgit@djiang5-desk3.ch.intel.com>
 <20200721162501.GC2021248@mellanox.com>
 <b3bc68b3-937e-4b64-e1c7-84942d7ba60c@intel.com>
 <20200722173515.GL2021248@mellanox.com>
In-Reply-To: <20200722173515.GL2021248@mellanox.com>
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
> Sent: Wednesday, July 22, 2020 10:35 AM
> To: Dey, Megha <megha.dey@intel.com>
> Cc: Jiang, Dave <dave.jiang@intel.com>; vkoul@kernel.org; maz@kernel.org;
> bhelgaas@google.com; rafael@kernel.org; gregkh@linuxfoundation.org;
> tglx@linutronix.de; hpa@zytor.com; alex.williamson@redhat.com; Pan, Jacob
> jun <jacob.jun.pan@intel.com>; Raj, Ashok <ashok.raj@intel.com>; Liu, Yi L
> <yi.l.liu@intel.com>; Lu, Baolu <baolu.lu@intel.com>; Tian, Kevin
> <kevin.tian@intel.com>; Kumar, Sanjay K <sanjay.k.kumar@intel.com>; Luck,
> Tony <tony.luck@intel.com>; Lin, Jing <jing.lin@intel.com>; Williams, Dan J
> <dan.j.williams@intel.com>; kwankhede@nvidia.com; eric.auger@redhat.com;
> parav@mellanox.com; Hansen, Dave <dave.hansen@intel.com>;
> netanelg@mellanox.com; shahafs@mellanox.com; yan.y.zhao@linux.intel.com;
> pbonzini@redhat.com; Ortiz, Samuel <samuel.ortiz@intel.com>; Hossain, Mona
> <mona.hossain@intel.com>; dmaengine@vger.kernel.org; linux-
> kernel@vger.kernel.org; x86@kernel.org; linux-pci@vger.kernel.org;
> kvm@vger.kernel.org
> Subject: Re: [PATCH RFC v2 04/18] irq/dev-msi: Introduce APIs to allocate/free
> dev-msi interrupts
> 
> On Wed, Jul 22, 2020 at 10:05:52AM -0700, Dey, Megha wrote:
> >
> >
> > On 7/21/2020 9:25 AM, Jason Gunthorpe wrote:
> > > On Tue, Jul 21, 2020 at 09:02:41AM -0700, Dave Jiang wrote:
> > > > From: Megha Dey <megha.dey@intel.com>
> > > >
> > > > The dev-msi interrupts are to be allocated/freed only for custom
> > > > devices, not standard PCI-MSIX devices.
> > > >
> > > > These interrupts are device-defined and they are distinct from the
> > > > already existing msi interrupts:
> > > > pci-msi: Standard PCI MSI/MSI-X setup format
> > > > platform-msi: Platform custom, but device-driver opaque MSI
> > > > setup/control
> > > > arch-msi: fallback for devices not assigned to the generic PCI
> > > > domain
> > > > dev-msi: device defined IRQ domain for ancillary devices. For e.g.
> > > > DSA portal devices use device specific IMS(Interrupt message store)
> interrupts.
> > > >
> > > > dev-msi interrupts are represented by their own device-type. That
> > > > means
> > > > dev->msi_list is never contended for different interrupt types. It
> > > > will either be all PCI-MSI or all device-defined.
> > >
> > > Not sure I follow this, where is the enforcement that only dev-msi
> > > or normal MSI is being used at one time on a single struct device?
> > >
> >
> > So, in the dev_msi_alloc_irqs, I first check if the dev_is_pci..
> > If it is a pci device, it is forbidden to use dev-msi and must use the
> > pci subsystem calls. dev-msi is to be used for all other custom
> > devices, mdev or otherwise.
> 
> What prevents creating a dev-msi directly on the struct pci_device ?

In the next patchset, I have explicitly added code which denies PCI devices from using the dev_msi alloc/free APIS
> 
> Jason
