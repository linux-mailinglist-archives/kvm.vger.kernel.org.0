Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B1F1B75B1
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 14:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgDXMo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 08:44:56 -0400
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:2574
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbgDXMoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 08:44:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TyKHVWpNwDf7aKw1aTARt+0UiIj82MjxvGZ2mmcNvLL6zSRoopc0qAQ5pNehxlz0xxod7sD/KNEqs+jWx9MkIVAnffWE2NhTl+G2cMUhNVzJo4uOQBCluGmk5lsyVnLqJPyXeoWgXffS074gVPay05h37nwgeXfWZxcdinZYdzjJmwkU77cwoq6nhpT1ti//zCtzHPxMwBt3GvOCNDU+XDOhZ5EHFS57s6hKYekPMHxhbpa2hd0z0DMRlkt9XOO+sBX/ldIUWhjHQF7M3TqAsmj28N5LKfiavbToTeDAbPNSx2yntctdtIgXlYqpMwRTcpfBVMG4ezm7NdPEpXo/4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrPxanKHgEs0gd8UnfrnzpT+mw339JcYaNUdemhbQFc=;
 b=OKMgLvSkIhjJa2fq5E+Sm3za1T5t0bO0lxAVYfZ8VOEkTCowbaL0TREW7o/5NzfMFyq4/vF5trAeeMoCffSCVmeRmU24BvSP3y1C2Q12sOfE+uUc1x9EGuQ4oj9CtxEhb/RsY+81rJAqiQ72+eS08DoqfunvDc6aABS4CHx2dt7vC3fvmpRsyvVIP1V6m5qhnt2gW1AsshP4u985PcKYQI7W7Vxk9GQG5UfyYwh0jELw2TywbtCZejFh99lNofwNfNvsyHRdfIj8TuM1/0Y8WDg9gSbK9u5E1GBIYQfLdjU0riUfG6iufE1dRwpUHruw5mWxAa5zemiRvDPmHpi5hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrPxanKHgEs0gd8UnfrnzpT+mw339JcYaNUdemhbQFc=;
 b=XUFD5rWbc2Zo+XXDta2fq4w57Dt/IragLss/yjQJB5o4kwn34yuDpQ45j+TOCtrrFBEga1AG6TO/MX8co+OCV062pVNhh4HERUg92jeduRO0DC41NIsr2KN9RcVJFllHoBKkCVfWc3NxEBGPAJA+cbkFUQ/9B+o8IwJyrQwOgm8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6797.eurprd05.prod.outlook.com (2603:10a6:800:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Fri, 24 Apr
 2020 12:44:50 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 12:44:50 +0000
Date:   Fri, 24 Apr 2020 09:44:44 -0300
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
Message-ID: <20200424124444.GJ13640@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com>
 <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR20CA0052.namprd20.prod.outlook.com
 (2603:10b6:208:235::21) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR20CA0052.namprd20.prod.outlook.com (2603:10b6:208:235::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:44:50 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jRxhE-0005Kp-2k; Fri, 24 Apr 2020 09:44:44 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fff99b36-1cf9-4f46-a332-08d7e84d477a
X-MS-TrafficTypeDiagnostic: VI1PR05MB6797:|VI1PR05MB6797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB679783ACB1EE171F75E6376DCFD00@VI1PR05MB6797.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(186003)(2616005)(4326008)(8936002)(81156014)(86362001)(52116002)(478600001)(36756003)(2906002)(8676002)(9786002)(9746002)(1076003)(33656002)(66946007)(7416002)(26005)(5660300002)(66476007)(66556008)(6916009)(54906003)(316002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e/nZanFyLvJKltp0WBLOUgHxSiESZWqPrApWCCVhw7iMsZIKVUtztTbg1VzVWEwa9IzRY0qPW2GigisZagGuCVBN/KJGzZOQd1+lwJv6DzuiyWbJW0p1UfKZ8R9bib6dgZ4OHpHjgrdtMsl+WwLKw8Jz/bln4IszFOA9Bje0Rnnxn4e3r9mBQIwDi/WaPF0786O2M2yZca1Eeq4VNupdZnRdZCsMkSzymSMujbM9aiuVXqk2HouaEsja2UFOh0KmXxVBrvt9hJmiCtWF084+VIFg/665ZQUvWxjUAUH9oFaFnwWMAxh2K+/ZGt3vjVvR+2KtKzbnOY5g/MSZl1RScz5YNCRlrFfLgO6dbLYBPYC37A1mksDorg8T8TOiNauIxZf+BkoPSLrZDtfOeO0lSmi6A1PNg+8SnLnPxv9n61RU4gPEkAlqruBiDnUuLoImkEpTcYRuzK//UfM49rJcU4DloDHGko9ltcTeYI7//hZqGIlmSqtkOE7e6Nh+Yopz
X-MS-Exchange-AntiSpam-MessageData: L8axWz3xKruAZkiJZ0EZPhP3D7PWoF9mD9qJOwpzjG/4/upLHi+Qdm1Ejh4PUx3GcENrwLpxHP0gRTWliR+LIJCQu/dJVBGNam+okjEprPmEaC6ZjLWGyvB1C+9heETnEhHd0CahoBdyq4qJt8bdxA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fff99b36-1cf9-4f46-a332-08d7e84d477a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:44:50.8358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhJV0ZQzSnDsPjk9fEjTh/RFccRPLJsfM4FT2ofsAcvAuuHQTyk+u/NulWl//NAP2bcjacffrHvKqwmI1+Iucw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6797
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 03:27:41AM +0000, Tian, Kevin wrote:

> > > That by itself doesn't translate to what a guest typically does
> > > with a VDEV. There are other control paths that need to be serviced
> > > from the kernel code via VFIO. For speed path operations like
> > > ringing doorbells and such they are directly managed from guest.
> > 
> > You don't need vfio to mmap BAR pages to userspace. The unique thing
> > that vfio gives is it provides a way to program the classic non-PASID
> > iommu, which you are not using here.
> 
> That unique thing is indeed used here. Please note sharing CPU virtual 
> address space with device (what SVA API is invented for) is not the
> purpose of this series. We still rely on classic non-PASID iommu programming, 
> i.e. mapping/unmapping IOVA->HPA per iommu_domain. Although 
> we do use PASID to tag ADI, the PASID is contained within iommu_domain 
> and invisible to VFIO. From userspace p.o.v, this is a device passthrough
> usage instead of PASID-based address space binding.

So you have PASID support but don't use it? Why? PASID is much better
than classic VFIO iommu, it doesn't require page pinning...

> > > How do you propose to use the existing SVA api's  to also provide
> > > full device emulation as opposed to using an existing infrastructure
> > > that's already in place?
> > 
> > You'd provide the 'full device emulation' in userspace (eg qemu),
> > along side all the other device emulation. Device emulation does not
> > belong in the kernel without a very good reason.
> 
> The problem is that we are not doing full device emulation. It's based
> on mediated passthrough. Some emulation logic requires close
> engagement with kernel device driver, e.g. resource allocation, WQ
> configuration, fault report, etc., while the detail interface is very vendor/
> device specific (just like between PF and VF).

Which sounds like the fairly classic case of device emulation to me.

> idxd is just the first device that supports Scalable IOV. We have a
> lot more coming later, in different types. Then putting such
> emulation in user space means that Qemu needs to support all those
> vendor specific interfaces for every new device which supports

It would be very sad to see an endless amount of device emulation code
crammed into the kernel. Userspace is where device emulation is
supposed to live. For security

qemu is the right place to put this stuff.

> > > Perhaps Alex can ease Jason's concerns?
> > 
> > Last we talked Alex also had doubts on what mdev should be used
> > for. It is a feature that seems to lack boundaries, and I'll note that
> > when the discussion came up for VDPA, they eventually choose not to
> > use VFIO.
> > 
> 
> Is there a link to Alex's doubt? I'm not sure why vDPA didn't go 
> for VFIO, but imho it is a different story.

No, not at all. VDPA HW today is using what Intel has been calling
ADI. But qemu already had the device emulation part in userspace, (all
of the virtio emulation parts are in userspace) so they didn't try to
put it in the kernel.

This is the pattern. User space is supposed to do the emulation parts,
the kernel provides the raw elements to manage queues/etc - and it is
not done through mdev.

> efficient for all vDPA type devices. However Scalable IOV is
> similar to SR-IOV, only for resource partitioning. It doesn't change
> the device programming interface, which could be in any vendor
> specific form. Here VFIO mdev is good for providing an unified 
> interface for managing resource multiplexing of all such devices.

SIOV doesn't have a HW config space, and for some reason in these
patches there is BAR emulation too. So, no, it is not like SR-IOV at
all.

This is more like classic device emulation, presumably with some fast
path for the data plane. ie just like VDPA :)

Jason
