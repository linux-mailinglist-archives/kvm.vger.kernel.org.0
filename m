Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D06227F53C
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 00:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgI3WjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 18:39:05 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11318 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730876AbgI3WjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 18:39:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7508d50000>; Wed, 30 Sep 2020 15:38:13 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 22:39:00 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 30 Sep 2020 22:39:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HHNjCtTX3mFHtyiYBu1pC8WPH2ZOYRD2I7AeraUzrwSBbwzNRMZ8jKFBx7q7V/H+KZ77qvtq/0NhvH8M/SUR6LdJFrkjFlA4bAF7ooiBgsYb/cbVqeQys9pQludF3au1VuiuB2lG4Ywpgk3DblkJEHjn5MCBW92+c0NBi/7VxSMvpmAmWDPDjYg4r1xA31nLB4UqtYXghgoX/J2POZwTQQrG0+kcCUSjhcwsVMRCm62QjXuV6ikKIoWsP/LR2HpCXxsA2ASop0gyvhZR/HU5fSczFkCyyrc6WvViOXITDH+s98WbaCw072frdCn/FuE3E/DGWgtbIFroi7I10ChiOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ai6Omny5JKBWcNpwYiVu/UDutJhsSBmTMmzj6la7f8=;
 b=gCmSolI0LabELxiEp1s3gqmB33cMmz79abHorzvJzV2VyMgM4MAhZ8oE+olL2TmUVfJZmk3+4aAsO18d3iEQN/A+eEH4QKtXRAgfmJE2AaULbhxHadR/zWUqT5h9sMXOPpw931Bls5wyCDdIaxnjfK5k2oBIPsIVZAKCiUIDaVb9t6FKTtPZDeMraEHDciv2Xo4oR/ccgvq1ClJ1gmgTSmnk4Ls5RWs4JBnwi9MhvvoBLR/+/kWaHfdAmMBvvZd3roOt1L4EcfAdB3nHBQFYtimX9wZD0fDAMJveTKKWJ9uKy3GoLPMjbN3dWDfxZpbtPrqHax+LLzpXYfCJF1eSag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1548.namprd12.prod.outlook.com (2603:10b6:4:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Wed, 30 Sep 2020 22:38:59 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3433.032; Wed, 30 Sep 2020
 22:38:59 +0000
Date:   Wed, 30 Sep 2020 19:38:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <yi.l.liu@intel.com>, <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/18] dmaengine: idxd: add IMS support in base driver
Message-ID: <20200930223857.GV816047@nvidia.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com>
 <160021248979.67751.3799965857372703876.stgit@djiang5-desk3.ch.intel.com>
 <87sgazgl0b.fsf@nanos.tec.linutronix.de> <20200930185103.GT816047@nvidia.com>
 <20200930214941.GB26492@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200930214941.GB26492@otc-nc-03>
X-ClientProxiedBy: MN2PR14CA0025.namprd14.prod.outlook.com
 (2603:10b6:208:23e::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR14CA0025.namprd14.prod.outlook.com (2603:10b6:208:23e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Wed, 30 Sep 2020 22:38:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kNkkT-004OLW-IM; Wed, 30 Sep 2020 19:38:57 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601505493; bh=6ai6Omny5JKBWcNpwYiVu/UDutJhsSBmTMmzj6la7f8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=ChI8qzlu7isZS2cgzXXjWILwfGDRYNyLmuP91JcxzU8ptCIBFxhVd79xfGmSLKsWt
         q7PGrzqPo8Xd+XK0joJnkA/iYk66b8VdM+bLOaG4WUZOkcDDdLjfOGdf6/ijxq6+y5
         UwqeHXrJBzT029P+eVfHXlpgIwVfV0ifPiN5Cpely9zUH5n69YU3o8WZvIm4oOPWpK
         du4lZhBYJV56C4qgDxvmuLabhYNMnn2LqTBzMwzT02auQu4qz2Uf1sGye15Z6I3POk
         tFKu7md7l1eDhoDbW4y/tYK/Bcdg62fc6F9CA/5j1Hvne33gIh94Epz5KMRkVwJekp
         /hk2RK1hQ7h/w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 30, 2020 at 02:49:41PM -0700, Raj, Ashok wrote:

> One of the parameters it has is the "supported system page-sizes" which is
> usually there in the SRIOV properties. So it needed a place holder for
> that. 

No idea why this would be a PCI cap. It is certainly not something so
universal it needs standardizing. There are many ways a device can
manage a BAR to match a required protection granularity.

> When we provision an entire PCI device that is IMS capable. The guest
> driver does know it can update the IMS entries directly without going to
> the host. But in order to do remapping we need something like how we manage
> PASID allocation from guest, so an IRTE entry can be allocated and the host
> driver can write the proper values for IMS.

Look at the architecture we ended up with.

You need to make pci_subdevice_msi_create_irq_domain() fail if the
platform can't provide the functionality.

Working around that with PCI caps is pretty gross.

Jason
