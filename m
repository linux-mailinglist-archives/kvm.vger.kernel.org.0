Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7783C1B6451
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgDWTM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:12:27 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:8000
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726296AbgDWTM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:12:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6ddtwzKjYqA1kwmfU1b1fLD3uGCN4yiU76aAX9igazYevUNTMUaUDeDgYJ+mWeQpLVziW3K7nmIPUv9cK38b3ULV8A0WjfPmCcxThEQ3ypJP4OmjWzyTZUlQtCEehbOAq3wSwn8hgP8UiLTZMn0ZHAcdGPU74Yx8tymDliBwUL1utOVkHD04o2PCT/SjMZQD59NvBHtCphGVh5fpuh1mZyGPfWjbMqs9tc7pzFZ7ev6KGZ9BIoYNtBA0vcTE3ZhLBMbz6faQaEpyXSsQW33xawHgkPy8RgbvC5HkX5GRqqLYDkVgSirWt3O+n2ofdGaSDtjnBjVlEN2L/2FOtM5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB+iWplYEKT4bgSJmyTWVF/M1IfZC6avqDk+oCMgJgU=;
 b=ZnKsh3koCmqxPbcvOXqRBpzFDqrkcikrUEezceAMBRBWPJp+zHnHRDtN5EgK+zbqN1BYPJZGPHt37DYOFH5Jv8gprBdAlmCxAdmJuNeCK3o28yq4updaEveu7Z6oPE+hLIKDuG4uMymKg+tdmgeLv44lFrlcqCHAjvEl+cRTRRIK8w0Mkr8rXZVk5WW3VDtKdxyOrtgFygP1w8UQigX2plqw3S7tiIIwTYtJQIQp9DqbbbBR33PgH252W49iaCTwz6mCqGbBzBBf9UIi/JPIQ61MH4Tu5pmgxD1I/F/LYvoYv9x0BujGzWXcyRdqTO0A/HwE2h/M57P861UJkCMc+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lB+iWplYEKT4bgSJmyTWVF/M1IfZC6avqDk+oCMgJgU=;
 b=HRsRzsNforrb7kS1r5ApyYjedGNAnf9t9oWUL0VQtTmTJh0wp/t1mEkneOttzXbnrRSq2tI4qYO3f+JatgCLlPAehJ9FRl0ujF9nRXehRPFhOfCKyNhlkjgopKS0TcotEKKib0bhwe8dosOvxO6nvjyE9bGeXVlgDwoG2WzoiII=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4958.eurprd05.prod.outlook.com (2603:10a6:803:58::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Thu, 23 Apr
 2020 19:12:21 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Thu, 23 Apr 2020
 19:12:20 +0000
Date:   Thu, 23 Apr 2020 16:12:17 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20200423191217.GD13640@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com>
 <20200422211436.GA103345@otc-nc-03>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422211436.GA103345@otc-nc-03>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:208:fc::20) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR02CA0007.namprd02.prod.outlook.com (2603:10b6:208:fc::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 23 Apr 2020 19:12:20 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jRhGj-0006uL-8Y; Thu, 23 Apr 2020 16:12:17 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09c67aba-d63e-4d0b-f348-08d7e7ba3f24
X-MS-TrafficTypeDiagnostic: VI1PR05MB4958:|VI1PR05MB4958:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB495817CB8F29435AF852BAA5CFD30@VI1PR05MB4958.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03827AF76E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(8936002)(478600001)(2906002)(5660300002)(6916009)(2616005)(52116002)(36756003)(4326008)(86362001)(81156014)(9746002)(9786002)(1076003)(8676002)(66556008)(33656002)(26005)(316002)(66946007)(54906003)(186003)(7416002)(66476007)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAM+pprR4yUQbLq3p0e6S3VFp5WeiA+AJgY2ul9RP76s29+E35WJruVo4pt/lIV36j6bC6LXXjJ7k0KMmS/FLbje5y65zPKRDV4AOULEeDxFA6/i5zkEalFcp8eK0M7+IzrUyXehscQ36GP/eKNJeenCTw4Woba6ckcvXh+pVD3INMnqRtsowKc6vrKZ/wzOIwnD5C3q8+DoxBP5fWOiOeIudI82d2kN9d0tZgu1NTphpOxLWRIkkbXQkx+PVer0XWZWT1Lx9GyoH+ZjEelHCkLNtMecIzgJF6xW1jfQ15FwU0Xvv1exdTR1iUz3NIQsitPBZMXoNII/Q8YSpmRoBs++qySGioIAo6VdTBEkVTJOTAyqcQZDH0uvCe0tCKrVxsE/eIIX0MYEMec1sLX4Ne9JUdP3Wvu6/Ic4Ac9s8iRQh0xFpDoLcZGLkP/mMPQe93KyqmOnBZHli/dmBuelWaHf5pgTw4M23EFJwJef5bt38Y0qZ/DKjdeSKd0edGsp
X-MS-Exchange-AntiSpam-MessageData: UVsdrsnYOrM37NsticKTdTYtEw6FXqS3d4QQCS77P/R5AKDlxlyp5Nlk2wQliKq8tgEaHpgtE/uAkPNPX03Skrp6R7myNFmKY9ztCaZtDGuo19K9nmyiE23cla+RwIkl8kAuexmu4LLrxAyE0xe5Kg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c67aba-d63e-4d0b-f348-08d7e7ba3f24
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2020 19:12:20.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4WvMtKZ3GfNIGv8F5B8H111rLMRsTHkJkH2xxmaj5rHkXF4cT/ROnd//62ZAP6/EeNQ9l8GfoR6tlSLAyEpp6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4958
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 02:14:36PM -0700, Raj, Ashok wrote:
> Hi Jason
> 
> > > > 
> > > > I'm feeling really skeptical that adding all this PCI config space and
> > > > MMIO BAR emulation to the kernel just to cram this into a VFIO
> > > > interface is a good idea, that kind of stuff is much safer in
> > > > userspace.
> > > > 
> > > > Particularly since vfio is not really needed once a driver is using
> > > > the PASID stuff. We already have general code for drivers to use to
> > > > attach a PASID to a mm_struct - and using vfio while disabling all the
> > > > DMA/iommu config really seems like an abuse.
> > > 
> > > Well, this series is for virtualizing idxd device to VMs, instead of
> > > supporting SVA for bare metal processes. idxd implements a
> > > hardware-assisted mediated device technique called Intel Scalable
> > > I/O Virtualization,
> > 
> > I'm familiar with the intel naming scheme.
> > 
> > > which allows each Assignable Device Interface (ADI, e.g. a work
> > > queue) tagged with an unique PASID to ensure fine-grained DMA
> > > isolation when those ADIs are assigned to different VMs. For this
> > > purpose idxd utilizes the VFIO mdev framework and IOMMU aux-domain
> > > extension. Bare metal SVA will be enabled for idxd later by using
> > > the general SVA code that you mentioned.  Both paths will co-exist
> > > in the end so there is no such case of disabling DMA/iommu config.
> >  
> > Again, if you will have a normal SVA interface, there is no need for a
> > VFIO version, just use normal SVA for both.
> > 
> > PCI emulation should try to be in userspace, not the kernel, for
> > security.
> 
> Not sure we completely understand your proposal. Mediated devices
> are software constructed and they have protected resources like
> interrupts and stuff and VFIO already provids abstractions to export
> to user space.
> 
> Native SVA is simply passing the process CR3 handle to IOMMU so
> IOMMU knows how to walk process page tables, kernel handles things
> like page-faults, doing device tlb invalidations and such.

> That by itself doesn't translate to what a guest typically does
> with a VDEV. There are other control paths that need to be serviced
> from the kernel code via VFIO. For speed path operations like
> ringing doorbells and such they are directly managed from guest.

You don't need vfio to mmap BAR pages to userspace. The unique thing
that vfio gives is it provides a way to program the classic non-PASID
iommu, which you are not using here.

> How do you propose to use the existing SVA api's  to also provide
> full device emulation as opposed to using an existing infrastructure 
> that's already in place?

You'd provide the 'full device emulation' in userspace (eg qemu),
along side all the other device emulation. Device emulation does not
belong in the kernel without a very good reason.

You get the doorbell BAR page from your own char dev

You setup a PASID IOMMU configuration over your own char dev

Interrupt delivery is triggering a generic event fd

What is VFIO needed for?
 
> Perhaps Alex can ease Jason's concerns?

Last we talked Alex also had doubts on what mdev should be used
for. It is a feature that seems to lack boundaries, and I'll note that
when the discussion came up for VDPA, they eventually choose not to
use VFIO.

Jason
