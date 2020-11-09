Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7152AC136
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 17:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgKIQqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 11:46:21 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:2175 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgKIQqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 11:46:21 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa9725a0001>; Tue, 10 Nov 2020 00:46:18 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 9 Nov
 2020 16:46:14 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 9 Nov 2020 16:46:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpHuuuKU3GbdZOzlQUgXrdLgqvH7JSlBF9gromn7ypaxbSYvMmHMhxkhX5Sc4/4kq0TF6P7jsSfqUnKOSOojZsZr2cEY7egcprbSKnukGtvQ3IpMS9bMTjVuLGqT5FINkzM/NrqQcqLJezkGwcrpsMFFIfP9p2Yi6M2/asS701siO4NGmSbQcfs+eM3G0dqnPmRRjcrZ+OBWHQWu8/HOenPhsWlZVvWFc94yDSfkjLl/7s9qJ29PNRIfeFPlzfBNW1aLeL6+PL5j3LjPM/QgMof9oZwIUCfVqSaMJEQsOJTaWY/jESDCdtLidL+xGBMKMzuvZzSGJKsyiuaIhUTijg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=277rR03Fmd1c1EPd3wl3XEAXUDcur6tnQke8sHJIKgU=;
 b=KaKpxJhNa+NR74Bj5t+nGkkFu4+h0Yslk9fuCC247yIBui/BolHGv9aoXlPsMxm20He3CPALG2AKVBlZJNH/PcXEg4ztQ8BBd7/ao3isCgPIkcejB3brU1/AWD4TZueRhV63Zckygam1edItlUptGQ8BW6LzPtsFUWKbkOGz+wEfk6+Ks6VHrMzOfQ1ARvOVWnr0F81EI91zJ66Cj8U4ZUNTCKL94UZZOQyQKispyI0KIMk5J2qo/mR1qKobj3hR3EyusE3eOjgyOgCmrkPl93eQZpuEWPRXS2njwa3zht3NoyYWU9Y/ykgYf4/94NK6MkgiCGHt3yACRE3meLZs/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3401.namprd12.prod.outlook.com (2603:10b6:5:39::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Mon, 9 Nov
 2020 16:46:11 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 16:46:11 +0000
Date:   Mon, 9 Nov 2020 12:46:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Message-ID: <20201109164608.GF2620339@nvidia.com>
References: <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108232341.GB2620339@nvidia.com>
 <MWHPR11MB164578A1CC38EB28F6EA8F918CEA0@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB164578A1CC38EB28F6EA8F918CEA0@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0112.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0112.namprd13.prod.outlook.com (2603:10b6:208:2b9::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Mon, 9 Nov 2020 16:46:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kcAIy-00200t-Kf; Mon, 09 Nov 2020 12:46:08 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604940378; bh=277rR03Fmd1c1EPd3wl3XEAXUDcur6tnQke8sHJIKgU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=PsjoQMAkqijoe2iem/o0wve7NJ74DR06EK6R+8CyyhzugI8aKrLJThOIYFKZ+nEbm
         3L4E8hq/PfBX8lmqQaJyXaGasE5/jmmrAawRHteN3sMIF1ucaKOQy37UttiK19Ccyg
         Nbt3SNLGayHK/O8DQU/Az7tPDWNdRM3bxiVZbKkBgOMOBsCdWd83ZvLkA2sFzfRoPE
         e2lqw7Sx0RCfsO0BZPaROqsZYaQYpZuhODrzBVb8UVzYXWgblsMD3Q2D9EUaILNTKA
         Mt/VnM1499XV25YmAm98ZLslPoOZQ7XUdKuhdRcBsdpW4zJKND7knR+tThZlwJNyhL
         7O79HXUOe7c8Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 09, 2020 at 07:37:03AM +0000, Tian, Kevin wrote:
> >  3) SIOV sub device assigned to the guest.
> > 
> >     The difference between SIOV and SRIOV is the device must attach a
> >     PASID to every TLP triggered by the guest. Logically we'd expect
> >     when IMS is used in this situation the interrupt MemWr is tagged
> >     with bus/device/function/PASID to uniquly ID the guest and the same
> >     security protection scheme from #2 applies.
> 
> Unfortunately no. Intel VT-d only treats MemWr w/o PASID to 0xFEExxxxx
> as interrupt request. MemWr w/ PASID, even to 0xFEE, is translated
> normally through DMA remapping page table. 

I've heard that current IOMMUs are limited as well, but IMHO, as I
describe, if you want full symmetry then you want to route interrupts
via PASID for SIOV. Otherwise the architecture is incomplete.

At least from a Linux and VMM perspective this should be planned
for. It is the only generic way to have a sub device assigned to a
guest and still have access to IMS.

> Does your device already implement such capability? We can bring this 
> request back to the hardware team. 

In some cases we can generate PASID tagged TLPs for interrupt
messages, if there was a reason to do that.

> Yes, this is the main worry here. While all agree that using hypercall is 
> the proper way to virtualize IMS, how to disable it when hypercall is
> not available is a more urgent demand at current stage.

Hopefully Thomas's note about checking for virtualization will help..

> btw in reality such ACPI extension doesn't exist yet, which likely will
> take some time. In the meantime we already have pending usages 
> like IDXD. Do you suggest holding these patches until we get ASWG 
> to accept the extension, or accept using Intel IMS cap as a vendor
> specific mitigation to move forward while the platform flag is being 
> worked on? Anyway the IMS cap is already defined and can help fix 
> some broken cases.

I think you need to sort something generic out, these half baked
architectures just make it some other teams problem.

Thomas's suggestion to check cpuid seems reasonably workable

Jason
