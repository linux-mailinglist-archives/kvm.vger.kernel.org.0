Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939331B7D9D
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 20:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgDXSMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 14:12:14 -0400
Received: from mail-eopbgr80040.outbound.protection.outlook.com ([40.107.8.40]:20666
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbgDXSMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 14:12:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWKezk3lSzUyA368iZ+wG79Q0Vq5ChB1L72PE2H/FeD9RGM/9JPY3dJd8v3X2kwtv0BriDXWKqdby5LSfHHQIQzF02bVXjfLz26WJQB2XlbxiXMkYOHuTF9uGIKKY+YaB/ImRL7mnx0jIlGnL6E8ncbA+eKz6UC5FYPN/TVTdIS3YywjucB8dxfFK69+0svmnmZYmUePWPAQYtiwmsXnCGygZVrsk7b3dxa6YjH7htWBfzd7g1Rsg/c8YmHCk4eg7OUAPtuR2fHUIonx2YH2/LL4RBuSSgEGGUwyAIVbzYT5w1+1i73ScNK65C6sKx3v3KrfMaUUZ1Jj7IE0knseoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xi1/v8lRPYKX8BFGb8p99HdvvkUruzlBeMG3YQNOgI=;
 b=WVTpQHt9wZ2yZ95FN25cgnH7y3WT8CO8xf7vX9GVA4/KA7BRqpLoklesKHM2wnR5bvaU6cSG+3RLVtYSN0QPsqpVG80EJfpKsel/x9Vic/Z6mBWMr7aBdE6Hwr/RdTZ9vD5vnpTEFGqQgkJP3GC9Xq1eH6Vy2Rzj4KJfmI6YqnAAsTSau4pRe8YXqTMSiCY+OMMj+X6uAA5xcBtyjlvN2jydIiwQcrWL1Vq/mjTmbK2i1Th3qyH+nGtCHUx2kARL42NsKMrueruGJ6dAbOyjYpAzbbmI5IdyIk+oACavGncXbSla91+0fXPgYzLXcMQn+D2x4f5gePuSn+vKsuy96w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xi1/v8lRPYKX8BFGb8p99HdvvkUruzlBeMG3YQNOgI=;
 b=SWsHWFYvZiZA5Nz3Uv1OKZkGeEfPDtPQdjnuejK/JDzQJrn6CApFlR6luzPyTJPtVzUl45Vr11C9hsZxhYuIj9rIiL34KqIqxBj1ElvkcdJmy/OsVur4Bitnu/GT2BDUSJ2yc9AKi55Kg/Z4TLuH2r5cAVTDhwFR97Cdo8i5uuE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB3328.eurprd05.prod.outlook.com (2603:10a6:802:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 18:12:08 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 18:12:08 +0000
Date:   Fri, 24 Apr 2020 15:12:03 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200424181203.GU13640@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com>
 <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR12CA0022.namprd12.prod.outlook.com
 (2603:10b6:208:a8::35) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR12CA0022.namprd12.prod.outlook.com (2603:10b6:208:a8::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 18:12:07 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jS2nz-0004Bq-Su; Fri, 24 Apr 2020 15:12:03 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b3dfe29-de26-451a-3e2d-08d7e87b004c
X-MS-TrafficTypeDiagnostic: VI1PR05MB3328:|VI1PR05MB3328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3328281B78C12A0E5E46FF81CFD00@VI1PR05MB3328.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(7416002)(186003)(52116002)(66556008)(66476007)(9786002)(9746002)(5660300002)(26005)(66946007)(316002)(8936002)(8676002)(81156014)(1076003)(54906003)(2906002)(4326008)(36756003)(33656002)(478600001)(2616005)(86362001)(6916009)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cqgNLgUMTqJLGDIPfbZGTNMMxqq5SanTE1G4cHWhFg5Wd3nkcTFgGMRgxpLybfDQ/lH+8BJTiWev1e9VhocuIltgYoSh43Ag737I16psRnyV9h7AiegzmIlxY9064VKFZ5USiyRYLPhWe/AvEU8NdPgGSL1Hd+6DTSGvpQ1xCqlzr/0HNbGl+3GSR8P5Hx/E5h7Y9ofJfS8XqSJ8IiP6EsmVzHtaeBP0MY1vRn8N45LP/nk0jX8YqB2f4rJuQLbhozzlbDrlm6pldYqPj0E7zBYUmnQ6fLOq7evVDbJYX3vTe9QeGVF2xrwZx2PiQ6VxxM8qIkACzHnNAtFu5Oniww3P51WmEdrObbZhZxKBHo8rpxcK9H4MnYj2CKVN3VkA1IWnPX3lO18zyYxX4I6LR8HU7/EpY6kveovXMqLXswF6iRYem1QeicA7sFZ5KWTJ7zMtzd7t3SdU2yB28k6ZFFxfB2LHZG35jwrjBbL4LE1J04OpkdvXfvYxnPjxFbB+
X-MS-Exchange-AntiSpam-MessageData: V3wY9CTZZQ0t00yhovdBw8hi9q+4QNFXi3o1fq1hmJOcDv/b2muMSq1AbIEqr2Z23akeicHg8s8LKVE0gH3swIazf/1IC/w9jxUVqlEH6wD0A7WOgVrpazKQ88gtfVtLLVzxfpDIve+Og6oXiXN5cQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b3dfe29-de26-451a-3e2d-08d7e87b004c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 18:12:08.3290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sINDcmSSBbNdMOfH3WUpuf+P5YOJB2x7yvqHAuela2CeUAhXdkh9eWP3HF6W6CcNj9c8/uhh9R1/ZlkVkw/Cug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3328
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 04:25:56PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe
> > Sent: Friday, April 24, 2020 8:45 PM
> > 
> > On Fri, Apr 24, 2020 at 03:27:41AM +0000, Tian, Kevin wrote:
> > 
> > > > > That by itself doesn't translate to what a guest typically does
> > > > > with a VDEV. There are other control paths that need to be serviced
> > > > > from the kernel code via VFIO. For speed path operations like
> > > > > ringing doorbells and such they are directly managed from guest.
> > > >
> > > > You don't need vfio to mmap BAR pages to userspace. The unique thing
> > > > that vfio gives is it provides a way to program the classic non-PASID
> > > > iommu, which you are not using here.
> > >
> > > That unique thing is indeed used here. Please note sharing CPU virtual
> > > address space with device (what SVA API is invented for) is not the
> > > purpose of this series. We still rely on classic non-PASID iommu
> > programming,
> > > i.e. mapping/unmapping IOVA->HPA per iommu_domain. Although
> > > we do use PASID to tag ADI, the PASID is contained within iommu_domain
> > > and invisible to VFIO. From userspace p.o.v, this is a device passthrough
> > > usage instead of PASID-based address space binding.
> > 
> > So you have PASID support but don't use it? Why? PASID is much better
> > than classic VFIO iommu, it doesn't require page pinning...
> 
> PASID and I/O page fault (through ATS/PRI) are orthogonal things. Don't
> draw the equation between them. The host driver can tag PASID to 
> ADI so every DMA request out of that ADI has a PASID prefix, allowing VT-d
> to do PASID-granular DMA isolation. However I/O page fault cannot be
> taken for granted. A scalable IOV device may support PASID while without
> ATS/PRI. Even when ATS/PRI is supported, the tolerance of I/O page fault
> is decided by the work queue mode that is configured by the guest. For 
> example, if the guest put the work queue in non-faultable transaction 
> mode, the device doesn't do PRI and simply report error if no valid IOMMU 
> mapping.

Okay, that makes sense, I wasn't aware people were doing PASID without
ATS at this point..

> > > idxd is just the first device that supports Scalable IOV. We have a
> > > lot more coming later, in different types. Then putting such
> > > emulation in user space means that Qemu needs to support all those
> > > vendor specific interfaces for every new device which supports
> > 
> > It would be very sad to see an endless amount of device emulation code
> > crammed into the kernel. Userspace is where device emulation is
> > supposed to live. For security
> 
> I think providing an unified abstraction to userspace is also important,
> which is what VFIO provides today. The merit of using one set of VFIO 
> API to manage all kinds of mediated devices and VF devices is a major
> gain. Instead, inventing a new vDPA-like interface for every Scalable-IOV
> or equivalent device is just overkill and doesn't scale. Also the actual
> emulation code in idxd driver is actually small, if putting aside the PCI
> config space part for which I already explained most logic could be shared
> between mdev device drivers.

If it was just config space you might have an argument, VFIO already
does some config space mangling, but emulating BAR space is out of
scope of VFIO, IMHO.

I also think it is disingenuous to pretend this is similar to
SR-IOV. SR-IOV is self contained and the BAR does not require
emulation. What you have here sounds like it is just an ordinary
multi-queue device with the ability to PASID tag queues for IOMMU
handling. This is absolutely not SRIOV - it is much closer to VDPA,
which isn't using mdev.

Further, I disagree with your assessment that this doesn't scale. You
already said you plan a normal user interface for idxd, so instead of
having a single sane user interface (ala VDPA) idxd now needs *two*. If
this is the general pattern of things to come, it is a bad path.

The only thing we get out of this is someone doesn't have to write a
idxd emulation driver in qemu, instead they have to write it in the
kernel. I don't see how that is a win for the ecosystem.

Jason
