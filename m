Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA7823CF4F
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgHETTE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Aug 2020 15:19:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:25621 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgHETSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 15:18:46 -0400
IronPort-SDR: G9zt/VUL2z3CtH1on6OKpniqUk2TCzWtOjUgmQF1oaZzeSDkUFx2H4PvEDqW2i8wR9BaXbF3Ci
 zltPsqZC1/dw==
X-IronPort-AV: E=McAfee;i="6000,8403,9704"; a="214158511"
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="214158511"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2020 12:18:45 -0700
IronPort-SDR: D0Vk6xev7JAvmeUfynzY+1BEcxv9Z8Bxnl7g4j/s5Q2ig5FW8QRbtY+zFR2Ns5n3z4J95TIZGX
 WJv71hfu1s4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,438,1589266800"; 
   d="scan'208";a="467570191"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga005.jf.intel.com with ESMTP; 05 Aug 2020 12:18:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 12:18:41 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 5 Aug 2020 12:18:40 -0700
Received: from orsmsx612.amr.corp.intel.com ([10.22.229.25]) by
 ORSMSX612.amr.corp.intel.com ([10.22.229.25]) with mapi id 15.01.1713.004;
 Wed, 5 Aug 2020 12:18:40 -0700
From:   "Dey, Megha" <megha.dey@intel.com>
To:     Jason Gunthorpe <jgg@mellanox.com>, Marc Zyngier <maz@kernel.org>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
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
Thread-Index: AQHWX3hgWhQMXvQig0qc4n40fOCoeakUaOyAgAASsgCAFXzAsA==
Date:   Wed, 5 Aug 2020 19:18:39 +0000
Message-ID: <96a1eb5ccc724790b5404a642583919d@intel.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
 <878sfbxtzi.wl-maz@kernel.org> <20200722195928.GN2021248@mellanox.com>
In-Reply-To: <20200722195928.GN2021248@mellanox.com>
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
> Sent: Wednesday, July 22, 2020 12:59 PM
> To: Marc Zyngier <maz@kernel.org>
> Cc: Jiang, Dave <dave.jiang@intel.com>; vkoul@kernel.org; Dey, Megha
> <megha.dey@intel.com>; bhelgaas@google.com; rafael@kernel.org;
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
> On Wed, Jul 22, 2020 at 07:52:33PM +0100, Marc Zyngier wrote:
> 
> > Which is exactly what platform-MSI already does. Why do we need
> > something else?
> 
> It looks to me like all the code is around managing the
> dev->msi_domain of the devices.
> 
> The intended use would have PCI drivers create children devices using mdev or
> virtbus and those devices wouldn't have a msi_domain from the platform. Looks
> like platform_msi_alloc_priv_data() fails immediately because dev->msi_domain
> will be NULL for these kinds of devices.
> 
> Maybe that issue should be handled directly instead of wrappering
> platform_msi_*?
> 
> For instance a trivial addition to the platform_msi API:
> 
>   platform_msi_assign_domain(struct_device *newly_created_virtual_device,
>                              struct device *physical_device);
> 
> Which could set the msi_domain of new device using the topology of
> physical_device to deduce the correct domain?
> 
> Then the question is how to properly create a domain within the hardware
> topology of physical_device with the correct parameters for the platform.
> 
> Why do we need a dummy msi_domain anyhow? Can this just use
> physical_device->msi_domain directly? (I'm at my limit here of how much of this
> I remember, sorry)
> 
> If you solve that it should solve the remapping problem too, as the
> physical_device is already assigned by the platform to a remapping irq domain if
> that is what the platform wants.

Yeah most of what you said is right. For the most part, we are simply introducing a new IRQ domain
which provides specific domain info ops for the classes of devices which want to provide custom
mask/unmask callbacks..

Also, from your other comments, I've realized the same IRQ domain can be used when interrupt
remapping is enabled/disabled.

Hence we will only have one create_dev_msi_domain which can be called by any device driver that
wants to use the dev-msi IRQ domain to alloc/free IRQs. It would be the responsibility of the device
driver to provide the correct device and update the dev->msi_domain.
  
> 
> >> +	parent = irq_get_default_host();
> > Really? How is it going to work once you have devices sending their
> > MSIs to two different downstream blocks? This looks rather
> > short-sighted.
> 
> .. and fix this too, the parent domain should be derived from the topology of the
> physical_device which is originating the interrupt messages.
> 
Yes

> > On the other hand, masking an interrupt is an irqchip operation, and
> > only concerns the irqchip level. Here, you seem to be making it an
> > end-point operation, which doesn't really make sense to me. Or is this
> > device its own interrupt controller as well? That would be extremely
> > surprising, and I'd expect some block downstream of the device to be
> > able to control the masking of the interrupt.
> 
> These are message interrupts so they originate directly from the device and
> generally travel directly to the CPU APIC. On the wire there is no difference
> between a MSI, MSI-X and a device using the dev-msi approach.
> 
> IIRC on Intel/AMD at least once a MSI is launched it is not maskable.
> 
> So the model for MSI is always "mask at source". The closest mapping to the
> Linux IRQ model is to say the end device has a irqchip that encapsulates the
> ability of the device to generate the MSI in the first place.
> 
> It looks like existing platform_msi drivers deal with "masking"
> implicitly by halting the device interrupt generation before releasing the
> interrupt and have no way for the generic irqchip layer to mask the interrupt.
> 
> I suppose the motivation to make it explicit is related to vfio using the generic
> mask/unmask functionality?
> 
> Explicit seems better, IMHO.

I don't think I understand this fully, ive still kept the device specific mask/unmask calls in the next
patch series, please let me know if it needs further modifications.
> 
> Jason
