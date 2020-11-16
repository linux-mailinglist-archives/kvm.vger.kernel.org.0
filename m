Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AF22B49CC
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 16:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgKPPqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 10:46:48 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:13778 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730348AbgKPPqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 10:46:47 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb29ee50002>; Mon, 16 Nov 2020 23:46:45 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Nov
 2020 15:46:43 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 16 Nov 2020 15:46:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcApvm+0g+8NyVAeZ88mACT8AJPGHFnN0VTNPR35NjR4vrmC6/8oioPMIBDnQeOWT0IM15YqrfEdME9GgKQUvuql28IASb85scJuhozqwY9lZiEJDeOOKTuQTK7h44QBhbsGPv6p9+fZHlcEbwDLFgWPmQIPBPEwVPUCwrKNpnpB9RpzHuHUyMjd5boH6NTelqxPTKHiH9/uzRawtOmGhyyDmZcOhkT2bs7HydC8ukNupgL2lbtx2z/2kOLSyRzSspupyc7wBA5HfzO5OwrTkLrAYYnK0FJEo20paGK7ffrz3dO1tjKbQlEnbyie5+wwUgJE8ySjLHsllqOIUSEZiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4BjpB65SoTJZuPGXdFARRRXcsqbAgEnaFh8uYpLgw8=;
 b=f6Euw05Mo7qeeAmOh/03MriRol/BfpV7OetZ/jlKsoDWZgJQK0+6XODO6GFk7iwt8icdrYSt/LIhU4wCO4WhECyNKD8PkM6qkWg4exb4uZUP2zrgQIEA6NJKlVHyvAuwMw5lPIQ6rA6h0A6d7L5ldXggDB9JygyGrZGha7Bh9CVvVT4meRy7NlU4ejtIWNRkMu7FlfB5VnvCfrzu9QjOvzWfHfLvWpZ2BzgT2Zv/mdR0ByMWIxITgIhXiHVMhX2LBZQMmQbSFmk2xjruAe0UZKQDQljkWU+YcSI8rMIlirZCq7TWFPzDTBY2BH3NgJbib3lMbLUDCyO0QpwifdhsXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3403.namprd12.prod.outlook.com (2603:10b6:5:11d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Mon, 16 Nov
 2020 15:46:37 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 15:46:37 +0000
Date:   Mon, 16 Nov 2020 11:46:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@infradead.org>,
        "Wilk, Konrad" <konrad.wilk@oracle.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20201116154635.GK917484@nvidia.com>
References: <MWHPR11MB16455B594B1B48B6E3C97C108CE80@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201112193253.GG19638@char.us.oracle.com>
 <877dqqmc2h.fsf@nanos.tec.linutronix.de>
 <20201114103430.GA9810@infradead.org>
 <20201114211837.GB12197@araj-mobl1.jf.intel.com>
 <877dqmamjl.fsf@nanos.tec.linutronix.de>
 <20201115193156.GB14750@araj-mobl1.jf.intel.com>
 <875z665kz4.fsf@nanos.tec.linutronix.de>
 <20201116002232.GA2440@araj-mobl1.jf.intel.com>
 <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB164539B8FDE63D5CBDA300E18CE30@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR07CA0011.namprd07.prod.outlook.com (2603:10b6:208:1a0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 15:46:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kegiB-006EbP-M3; Mon, 16 Nov 2020 11:46:35 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605541605; bh=W4BjpB65SoTJZuPGXdFARRRXcsqbAgEnaFh8uYpLgw8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=RDj5mu/ljsvi2ZrXib2UeUKUByT/+e8s8U/i7kvuTCnmA1AawNy7q6wDr8PR4lLFT
         0HAytLjDs3qYxnnH0p22GFfJdJaiBPCOtBjRVbc2y6YxsSpB7DOydHja5VQuM0oqOG
         8dWaUGpHC0x1kGBMc2cPF87YhIHJDTXdFGk6wlUwlLhE/DSrkj3wmEco0/uTJb3ZoU
         b1jX7VDPz2nj+yrz0xjJ6CtKbOc4zLBegHHaw3Mu5sxNHE9xKSY7+t/ZQ2zrO1C8af
         rru8NRvECtVqoUlT7vAPDqD6eaY2NFA/xoCVaeJacPp8wjwbZF4u7VpRw/n3M4t88R
         sPmxj5lU0ZLOw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 07:31:49AM +0000, Tian, Kevin wrote:

> > The subdevices require PASID & IOMMU in native, but inside the guest there
> > is no
> > need for IOMMU unless you want to build SVM on top. subdevices work
> > without
> > any vIOMMU or hypercall in the guest. Only because they look like normal
> > PCI devices we could map interrupts to legacy MSIx.
> 
> Guest managed subdevices on PF/VF requires vIOMMU. 

Why? I've never heard we need vIOMMU for our existing SRIOV flows in
VMs??

Jason
