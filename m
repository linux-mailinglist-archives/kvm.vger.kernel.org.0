Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1366F2AD8AA
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 15:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgKJOXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 09:23:54 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14706 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730059AbgKJOXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 09:23:53 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5faaa27f0000>; Tue, 10 Nov 2020 06:23:59 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 10 Nov
 2020 14:23:48 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 10 Nov 2020 14:23:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZJlzSCm0+TJUEqTqwbY3rnW+XQNRsIOu5f6lvTe7Oyf2HCSdN6h5lgV7QLpTWr3RByGYZr1Hf0Uo3+a+1JiHkuabjjT6YHbLU0IfKCpKwrGf43I73J0qXGFN6Q8i9ZW4IXiftxA+pxM+uFaCDASHBKpesYQF9AKmc5BFsor+6BH+M1u98ASQEovCEwjJ1pl5tZsAvxVLXsK5BN+SzNoukXYTfD83bqUQVVAPO8abbptlzhqc86fYxFML6Ix5Oj17Hnem3/qGgDbwifSEaoLLWfB8u8ZHBqw3tlQRyVb4oVm6/q8fccGflDqrRn1TcT2c445Ovfymm/LmmWSydPo+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qEV/0XBn12mhJm5c4zAZGjhSfWLL9TPDZ1T+H9lCEY=;
 b=kvtm1n8ktHXVBZHOUgk+GHj5j2e5AOs4OWS+gIpSiyPPIa7ucn/6QgFGf8/yVngbXWkAxzUw6x8idB9Al+0hD4+daDGw6wBmRqkpOqLsk2zAHQAvpTkt20vHd3LVpMb1WvkEFJ/n+7YvhbFWMr8w+tTxGx9w/c3WdSYEBr4HVD9qbmz2BAVXWq385QhgcgL1Vy69jIXZ/OyQEkvWUB6DLx5wANSRoCtRpkXXWD8xQvCKGH0BEOi4T8uQpKmaHbBkVS0HbjxsHm8Oz+4S8iNzFTAL3YoIlgpxp0jRcri8+HCp/I0udTQNJN9Vi2I6cBSNuZUTiMOzyJDWUXHmhCaRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1753.namprd12.prod.outlook.com (2603:10b6:3:10d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 10 Nov
 2020 14:23:41 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Tue, 10 Nov 2020
 14:23:41 +0000
Date:   Tue, 10 Nov 2020 10:23:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20201110142340.GP2620339@nvidia.com>
References: <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <87pn4nk7nn.fsf@nanos.tec.linutronix.de>
 <20201108235852.GC32074@araj-mobl1.jf.intel.com>
 <874klykc7h.fsf@nanos.tec.linutronix.de>
 <20201109173034.GG2620339@nvidia.com>
 <87pn4mi23u.fsf@nanos.tec.linutronix.de> <20201110051412.GA20147@otc-nc-03>
 <875z6dik1a.fsf@nanos.tec.linutronix.de> <20201110141323.GB22336@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201110141323.GB22336@otc-nc-03>
X-ClientProxiedBy: MN2PR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:208:239::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR08CA0027.namprd08.prod.outlook.com (2603:10b6:208:239::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 14:23:41 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kcUYe-002Qs2-Ag; Tue, 10 Nov 2020 10:23:40 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605018239; bh=5qEV/0XBn12mhJm5c4zAZGjhSfWLL9TPDZ1T+H9lCEY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=R/yLrdp123XabZQ3mY+IEk7tfYLVlJiMwKzFEdHLLWNMUS583A2Mu4v1XcDultkpF
         STVJemWJ1/lAP/Wtyvf3ykuRl9hlZEO1qO+zgAP1HX7ezgZR++Z6+cPihPKcXbdrMe
         D6Pef9hMDNVojWpRQjUypON5uuDIv7oTM7nPUrVrIpgf25PBMnRkp7rYDGNnkwL2Zw
         vmTZyuIX4saWJ+ijxZ5MlP5LuRs0PBny60kLkxVSQshqW0RgGOZ7nG5LxV5Bw46TDu
         4EYrEFeGP11owJMU4hE/GcB3RF1EApYIPb/V+CsfruKwB9UYb2PDtB9O/txFRifrtt
         Ku852y/pikJdg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 06:13:23AM -0800, Raj, Ashok wrote:

> This isn't just for idxd, as I mentioned earlier, there are vendors other
> than Intel already working on this. In all cases the need for guest direct
> manipulation of interrupt store hasn't come up. From the discussion, it
> seems like there are devices today or in future that will require direct
> manipulation of interrupt store in the guest. This needs additional work
> in both the device hardware providing the right plumbing and OS work to
> comprehend those.

We'd want to see SRIOV's assigned to guests to be able to use
IMS. This allows a SRIOV instance in a guest to spawn SIOV's which is
useful.

SIOV's assigned to guests could use IMS, but the use cases we see in
the short term can be handled by using SRIOV instead.

I would expect in general for SIOV to use MSI-X emulation to expose
interrupts - it would be really weird for a SIOV emulator to do
something else and we should probably discourage that.

Jason
