Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06F92AAE58
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 00:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgKHXlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Nov 2020 18:41:52 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:8994 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727929AbgKHXlv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Nov 2020 18:41:51 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa8823b0000>; Mon, 09 Nov 2020 07:41:50 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 8 Nov
 2020 23:41:46 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 8 Nov 2020 23:41:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jfnd+lOskl6J7SnN5En45Mst+Z4UiVR3/VAXWTVclSPyh3KOcyrov36olkP7W19JTreGfwos41v4FgYJf6wVTN6H15tumR+htzMzndeUu4SPsc/QhA++zaxbaN7MjrB/GDauyJ8xrPEh5gnHFXI2ADtN3Y5ZHqyGdb+2k9o8oo1ECET+M8tLlRD8C01ofOpjJR0Hb6twrHcqeCy4wQKYcTcTk3oYLi+C7x95Vv5SUVKR8f3SP23fIfoo3RaSKjvB1C05q83EdAnVpWEgR0uoQRc7s/RnlwsTgTMX3J+HZCirPA4L+m+p5tMSVDlHzkeMqDIXBCjkVWTgNnyw2MvnBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyQgFcagNLvj5CGIcgvqxl7yQQqRxNgUFqeXMmPi3/0=;
 b=LoDNOSf02sgADsTwWk566MWpDicI1z2jpmuLbFqgo6x1DLfTCDa1UUmXRnlRe1/48bEW8FLl5/ubaZtKcn5enPOonCljvZp2UInFoHwLFEyGKxAP1f/6w8JlKRt0VgAuQvGWA7aDkfqAQaLaqqVBgEDxHuBOI7rN/Auwjo4cIoxlxVVQXk4KK2UOFoyhhTbOslneMKazha+HxJnGoq04VID4M8Sg4RXw73R3Gh5bq4ZzTTZUndQuTYumY36cmBk0rlOTwM+jgWby2ca75yLBkolKQPu5uTvnp+y2rhzPRPt+Ev3P+ZXBkeNAQu7QpoxaTk+sqiBGfNRE+2K53suX6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0203.namprd12.prod.outlook.com (2603:10b6:4:56::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Sun, 8 Nov
 2020 23:41:43 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Sun, 8 Nov 2020
 23:41:43 +0000
Date:   Sun, 8 Nov 2020 19:41:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Dan Williams <dan.j.williams@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
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
Message-ID: <20201108234142.GD2620339@nvidia.com>
References: <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104135415.GX2620339@nvidia.com>
 <MWHPR11MB1645524BDEDF8899914F32AE8CED0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201106131415.GT2620339@nvidia.com> <20201106164850.GA85879@otc-nc-03>
 <20201106175131.GW2620339@nvidia.com>
 <CAPcyv4iYHA1acfo=+fTk+U_TrLbSWJjA6v4oeTXgVYDTrnCoGw@mail.gmail.com>
 <20201107001207.GA2620339@nvidia.com>
 <20201108181124.GA28173@araj-mobl1.jf.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201108181124.GA28173@araj-mobl1.jf.intel.com>
X-ClientProxiedBy: MN2PR17CA0033.namprd17.prod.outlook.com
 (2603:10b6:208:15e::46) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR17CA0033.namprd17.prod.outlook.com (2603:10b6:208:15e::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sun, 8 Nov 2020 23:41:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kbuJa-001jmr-BZ; Sun, 08 Nov 2020 19:41:42 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604878910; bh=qyQgFcagNLvj5CGIcgvqxl7yQQqRxNgUFqeXMmPi3/0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=Gjlhbnxq0vU9Gdn8NHmuPj8GalxuFY1m9YjpgYkxxbmUcQlsq7fhHEa0gbk27MPg1
         Ms861TpkU11Ahr7+85ED8ha4M+79VZXKO5hIY9uKYzM3wes/k+WlnJxRoRhgwAZaCC
         ZP9N4KfYlK2qJTEoN3YVBrI54upQNsAFnbj78ECJoWWLrph6Xy27l+ssamBnajb+je
         f3BK5BWuY/L+pYkrityDCnw4e73ed3DgvzUOIzavwufAp/obJQn34ltfUd6aQXg/yF
         FJcWzMiisjpsR532wIUtyqe1K49LB9RksanySjjecAEYEs7vomL+zPD2boXTLBF68W
         oQIQIFNpRO6Fw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 08, 2020 at 10:11:24AM -0800, Raj, Ashok wrote:

> > On (kvm) virtualization the addr/data pair the IRQ domain hands out
> > doesn't work. It is some fake thing.
> 
> Is it really some fake thing? I thought the vCPU and vector are real
> for a guest, and VMM ensures when interrupts are delivered they are either.

It is fake in the sense it is programmed into no hardware.
 
It is real in the sense it is an ABI contract with the VMM.

> > On something like IDXD this emulation is not so hard, on something
> > like mlx5 this is completely unworkable. Further we never do
> > emulation on our devices, they always pass native hardware through,
> > even for SIOV-like cases.
> 
> So is that true for interrupts too? 

There is no *mlx5* emulation. We ride on the generic MSI emulation KVM
is going.

> Possibly you have the interrupt entries sitting in memory resident
> on the device?

For SRIOV, yes. The appeal of IMS is to move away from that.

> Don't we need the VMM to ensure they are brokered by VMM in either
> one of the two ways above?

Yes, no matter what the VMM has to know the guest wants an interrupt
routed in and setup the VMM part of the equation. With SRIOV this is
all done with the MSI trapping.

> What if the guest creates some addr in the 0xfee... range how do we
> take care of interrupt remapping and such without any VMM assist?

Not sure I understand this?

> That's true. Probably this can work the same even for MSIx types too then?

Yes, once you have the ability to hypercall to create the addr/data
pair then it can work with MSI and the VMM can stop emulation. It
would be a nice bit of uniformity to close this, but switching the VMM
from legacy to new mode is going to be tricky, I fear.

> I agree with the overall idea and we should certainly take that into
> consideration when we need IMS in guest support and in context of
> interrupt remapping.

The issue with things, as they sit now, is SRIOV.

If any driver starts using pci_subdevice_msi_create_irq_domain() then
it fails if the VF is assigned to a guest with SRVIO. This is a real
and important, use case for many devices today!

The "solution" can't be to go back and retroactively change every
shipping device to add PCI capability blocks, and ensure that every
existing VMM strips them out before assigning the device (including
Hyper-V!!)  :(

Jason
