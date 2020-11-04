Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7C72A6593
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 14:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgKDNyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 08:54:24 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2541 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbgKDNyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 08:54:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa2b28e0000>; Wed, 04 Nov 2020 05:54:22 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Nov
 2020 13:54:18 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Nov 2020 13:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5phU6MHRDsDKjLWGotD4pvSS2sxRprtXWDuUxOB7CXJ9h02mDzgbRYtBBAJsHMLZvegqhUKw77XO23M0GMCHGeZitnBewgA9qmZy+w978vlBPyh96gYwKtFY1JDGAD7ng0CGt4i/6Q+WTQYxgnt5JE5oxa7cSZ//ZHayUW3yYuseMryvSbnB2coE+0uk0OaIr2yX2FqddDBlAsGuyN3jsBLMp1SavzqqLB3sipmtcjzdYe1JRm6L6zvoCZydnjf//aDKSnpH+7mfEc/pQAWshuAXAPncUlBSSWY0hZXbVOev5DajiZa7jztCXy7IW0pIZMS/9GzPSEPExxs63JhZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OS+j/JRQd8b9YsbgiaLQTv4wIIqtQ+2dLVC7Z+di6a4=;
 b=Sz4SFugMnHZXgjZYV7WFS19v7jutdQczrdBQwqDQBJk08XQOgh/haEkAc2FMLS7j64KGOGBaYF8blsNGRGnTwwQAJ57qehZAz/mKLersey/LvA62vBeRqVUjbiEU4uCa9yuFWFOVpPvw0sRfqB1y1y5E8ml5741XMntXLPwfetoK9ImSenv88pLu9vJjMTZWYrBMNtj+1eiRMwzryGBEAdDzMigZOEy4j/Jq5pgQnJ3MdclnMnXsDjkyRgwddAxxBZgljBaoo+GQ5p1wrtnofWzIDBoyKZ5QB8Cm2FoR4ngmnIO8zHOJ6JNe1CkTXHO5Vz4GdsYwF+1EbVVk1BmfLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4499.namprd12.prod.outlook.com (2603:10b6:5:2ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 4 Nov
 2020 13:54:17 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 13:54:17 +0000
Date:   Wed, 4 Nov 2020 09:54:15 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
CC:     "Jiang, Dave" <dave.jiang@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Dey, Megha" <megha.dey@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "jing.lin@intel.com" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
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
Message-ID: <20201104135415.GX2620339@nvidia.com>
References: <20201030195159.GA589138@bjorn-Precision-5520>
 <71da5f66-e929-bab1-a1c6-a9ac9627a141@intel.com>
 <20201030224534.GN2620339@nvidia.com>
 <ec52cedf-3a99-5ca1-ffbb-d8f8c4f62395@intel.com>
 <20201102132158.GA3352700@nvidia.com>
 <MWHPR11MB1645675ED03E23674A705DF68C110@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201103124351.GM2620339@nvidia.com>
 <MWHPR11MB164544C9CFCC3F162C1C6FC18CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
 <20201104124017.GW2620339@nvidia.com>
 <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1645862A8F7CF7FB8DD011778CEF0@MWHPR11MB1645.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR0102CA0072.prod.exchangelabs.com
 (2603:10b6:208:25::49) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0072.prod.exchangelabs.com (2603:10b6:208:25::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 13:54:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kaJEt-00GVZX-DP; Wed, 04 Nov 2020 09:54:15 -0400
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604498062; bh=OS+j/JRQd8b9YsbgiaLQTv4wIIqtQ+2dLVC7Z+di6a4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=Qrf2hhWA9Yco+9wWvNkNf32IlAKEGSVKmG1lmfLHn/q2B0q5sryRwEEIEDAnUpv9y
         nTy0ICQKVQD4iDtZ/Fah0GuKtVrEYwBRrXD+FhHmBY2AJNqb8IH0orsTqg0NT6Ksd/
         AoO4iZRA/euvuxXrLynnQAnIn2AizTvUk29Vj1beZrumMq5k6B7SPuXrmQJbxN31tH
         9eb4UuuSVapQQIl34X6vf5Hc1z8E4YXYVARIT6tNU2ZlT2NqMtM4eb2wdUC9K/7r9I
         rQByB2n6PWEEWJQBcY2q2+lDWwtYZJzEyfD/2i1dVKmaiJxPhwCIBhxNhc2Lbh0JaX
         zl4oSPSUzvSzg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 01:34:08PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, November 4, 2020 8:40 PM
> > 
> > On Wed, Nov 04, 2020 at 03:41:33AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, November 3, 2020 8:44 PM
> > > >
> > > > On Tue, Nov 03, 2020 at 02:49:27AM +0000, Tian, Kevin wrote:
> > > >
> > > > > > There is a missing hypercall to allow the guest to do this on its own,
> > > > > > presumably it will someday be fixed so IMS can work in guests.
> > > > >
> > > > > Hypercall is VMM specific, while IMS cap provides a VMM-agnostic
> > > > > interface so any guest driver (if following the spec) can seamlessly
> > > > > work on all hypervisors.
> > > >
> > > > It is a *VMM* issue, not PCI. Adding a PCI cap to describe a VMM issue
> > > > is architecturally wrong.
> > > >
> > > > IMS *can not work* in any hypervsior without some special
> > > > hypercall. Just block it in the platform code and forget about the PCI
> > > > cap.
> > > >
> > >
> > > It's per-device thing instead of platform thing. If the VMM understands
> > > the IMS format of a specific device and virtualize it to the guest,
> > 
> > Please no! Adding device specific emulation is just going down deeper
> > into this bad architecture.
> > 
> > Interrupts is a platform issue. Using emulation of MSI to dynamically
> 
> Interrupt controller is a platform issue. Interrupt source is about device.

The interrupt controller is responsible to create an addr/data pair
for an interrupt message. It sets the message format and ensures it
routes to the proper CPU interrupt handler. Everything about the
addr/data pair is owned by the platform interrupt controller.

Devices do not create interrupts. They only trigger the addr/data pair
the platform gives them.

> > insert vectors to a VM was a reasonable, but hacky thing. Now it needs
> > proper platform support.
>
> why is MSI emulation a hacky thing? isn't it defined by PCISIG? I guess
> that I must misunderstand your real point here...

It means the interrupt controller in the VM's platform is a fiction,
the addr/data pairs it creates are not real.

A PCI device assigned to a VM is supposed to be fully contained by the
IOMMU, interrupts included, so there is no reason to do MSI emulation
if the VM's interrupt controller is aware of what addr/data pairs it
can use with the device - eg by getting them through a hypercall. This
is much cleaner and supports things like IMS

Trying to do IMS emulation is nutz, the entire point of IMS is the
device can do what it likes, and emulating that is not going to
feasible. For instance go read the discussion I had with Thomas how a
object-centric device would manage interrupts.

Jason
