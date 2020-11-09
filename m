Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C052AC24B
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 18:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732005AbgKIRar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 12:30:47 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:44483 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730827AbgKIRaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 12:30:46 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa97cc50000>; Tue, 10 Nov 2020 01:30:45 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Nov
 2020 17:30:42 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 9 Nov 2020 17:30:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUDuqGUh4jwTr8MJovYxIRlVGT1rUbf0F20d4sa1VAnNqzM+006kjcbkS+9ljlOZYHXYDpUpMiR1b+KRzMN6yTm6NBRqkR+aHJf/aryROApAJrxnK4HoGtO/MjQbZDyrckwqUb7MZLWoUBtdn7JYDUzdzE3uwN5Nho69ZG3+SeuBiZR6IJ95oGQsn7ZZANvat+4Oj5XJ/kHgVKDl/rH869jXZnRqCmjHL5+gZCPoXVFTb0ZyG9ln4V1lFaIXch9sVVJT2mdLgLnaSC0n7L2WWQ8QX7hNpLqitSfZaYiKRVHgobrIO4d8FtQSVERo05LDIYzUQiORDjUw6me+3Kl2BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OOhT3z29bMPnKfH6ci/B4Z/dybfwXtgbGNCrwV+kgg=;
 b=mNG/vzYafn4qBGDjiX67SiI8ymbrWEj2UcqsUhWOvgx+GgZfu1AP1iuP5r8YnOnjFYznbTFo6xqeTGBJ5TLrIcngDpkl7/Gfn9GVbOgbZ3ZWVkJnP1OUNHfxL1FFPSRVU8RKNw92kpzF0F65dAr90f6mLbVN6KN0TeW4IrxrVmfrC+t8M2sge+6zsB865udp7JPcQG/UwxIcO6mzl/dyT6B1mg8T9ExL6S27Oj3L/pk+bWuIlvVmAYjwrJyQ25lNmWOVLlhU2tmSCfjt61NsMT8d947HzJHAdOGoaRCWclz+HXS45aXWLmxk9QWnrTNxOZ2Dl4onB4dTq/MB2pxAzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3307.namprd12.prod.outlook.com (2603:10b6:5:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Mon, 9 Nov
 2020 17:30:36 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 17:30:36 +0000
Date:   Mon, 9 Nov 2020 13:30:34 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netanelg@mellanox.com" <netanelg@mellanox.com>,
        "shahafs@mellanox.com" <shahafs@mellanox.com>,
        "yan.y.zhao@linux.intel.com" <yan.y.zhao@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>,
        "Hossain, Mona" <mona.hossain@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/17] PCI: add SIOV and IMS capability detection
Message-ID: <20201109173034.GG2620339@nvidia.com>
References: <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <874klykc7h.fsf@nanos.tec.linutronix.de>
X-ClientProxiedBy: BL0PR01CA0028.prod.exchangelabs.com (2603:10b6:208:71::41)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR01CA0028.prod.exchangelabs.com (2603:10b6:208:71::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 17:30:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kcAzy-0020eX-2p; Mon, 09 Nov 2020 13:30:34 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604943045; bh=0OOhT3z29bMPnKfH6ci/B4Z/dybfwXtgbGNCrwV+kgg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=DVCYdcX9eTQs7bknwYVC62MXUw+VWAiH7QP0ejvm58/+wMVDN0K3kxOo8ArHl5AZk
         9j/V2dg4OyglIeBrwOkHwsykBzJX884Kmv8jxVRhp7cfmxyNpdRSaLDWA5ljHpjXDO
         6ZviwZntmKGI5F2xc7BNCyYzVtKRnZpR9E3yVZvAb3xmyX8X8JWkimJMcdbSM5oXVm
         nUHd1sCYu8UtUoOeU4qFWe0pJJr3liOoKyb+se9Tb4VZUo+GVkhbRIHdcGIrgIS8a3
         X/s+/fX6Tj9nswENmaLYSeOrMRhI1/KntZN7brU6qeDaVRkWbpBjUou6uJAppDQlHf
         rMFkpQ4dyIZgw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 12:21:22PM +0100, Thomas Gleixner wrote:

> >> Is the IOMMU/Interrupt remapping unit able to catch such messages which
> >> go outside the space to which the guest is allowed to signal to? If yes,
> >> problem solved. If no, then IMS storage in guest memory can't ever work.
> >
> > This can probably work for SRIOV devices where guest owns the entire device.
> > interrupt remap does have RID checks if interrupt arrives at an Interrupt handle
> > not allocated for that BDF.
> >
> > But for SIOV devices there is no PASID filtering at the remap level since
> > interrupt messages don't carry PASID in the TLP.
> 
> PASID is irrelevant here.
> 
> If the device sends a message then the remap unit will see the requester
> ID of the device and if the message it sends is not matching the remap
> tables then it's caught and the guest is terminated. At least that's how
> it should be.

The SIOV case is to take a single RID and split it to multiple
VMs and also to the hypervisor. All these things concurrently use the
same RID, and the IOMMU can't tell them apart.

The hypervisor security domain owns TLPs with no PASID. Each PASID is
assigned to a VM.

For interrupts, today, they are all generated, with no PASID, to the
same RID. There is no way for remapping to protect against a guest
without checking also PASID.

The relavance of PASID is this:

> Again, trap emulate does not work for IMS when the IMS store is software
> managed guest memory and not part of the device. And that's the whole
> reason why we are discussing this.

With PASID tagged interrupts and a IOMMU interrupt remapping
capability that can trigger on PASID, then the platform can provide
the same level of security as SRIOV - the above is no problem.

The device ensures that all DMAs and all interrupts program by the
guest are PASID tagged and the platform provides security by checking
the PASID when delivering the interrupt. Intel IOMMU doesn't work this
way today, but it makes alot of design sense.

Otherwise the interrupt is effectively delivered to the hypervisor. A
secure device can *never* allow a guest to specify an addr/data pair
for a non-PASID tagged TLP, so the device cannot offer IMS to the
guest.

Jason
