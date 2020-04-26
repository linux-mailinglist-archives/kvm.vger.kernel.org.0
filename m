Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446A01B9390
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 21:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgDZTOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 15:14:08 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:42876
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726004AbgDZTOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 15:14:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvNTXUW8RhZO6otErh/OJvle/ggGYe8/TbvscsKS550RajHMYAPOuj5pv7VveCvkbVNvokjnS/shvYNeE+FaJX0sFmnh0LjOsnhnfEStJswGmrDAM2hSYK7omc+Li+5LWdwqDCXwA2sQ7+uuOrcwY2+bH4m3lX/R/u3XJ1IT7IzaRNQ7UD11ET/U2QQHNBB6pT0eInj7zh+Xd0Yk6Oiuh16A8FzGTYPYmaE7xzhYb9Ug8iYAI8rlZx/PCUyURjPN/bIGsA5r24yI+/7GghCJlMZtBYHa4xtaPhIXQm9R3eyxLfT1Ny9e1SzMIwndZ3NiypS0Jj7Vud1O9TzsPRG1vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7aMWA/2IKOuG/BONC+zv4bpwD1IQzpSJPXKVALm8Gs=;
 b=Szsy6bincNSq+jvAXP96Epz/cxI22qBbuWl7GunybUV5w2xOOZtJLi6tL6vyciIYWLS6QaYtol/tapA93YxG0s1kX30a4XWGGeTQGfn2GFau7jtYuPnfWspBqAnRMFSPA6bzCA91+b2VQHly1XdAocmZZ497kwx9OtpaNb5c75RVgk/HpRb4RMnch9k67TradnV9NrCj85BK2htcG7VbKAW9nJdtAwhjlNp1xFx2PR1mKZbZJ7XPp+GQjY+OncoXjDOsBfyKzwk2Tn+7lXJCDKKKTZ8AZnQ0tzdmQijVChg8+MRn92wA3yBnPwo3W8oZ07NYYRjgP3IeTTM8mFE+VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v7aMWA/2IKOuG/BONC+zv4bpwD1IQzpSJPXKVALm8Gs=;
 b=ilfr2gGDFMihl9aI8ZTJUVMfMqx/kDJeO8uk6jus1Mk/2jc7Q5Phu8t+cqwyzn/qglfrotSMgtlQbDD774/eqyIIBNEUl8hoT4UbrEFtGkuA5SWmRlKDr7F9xbFwMVmnc0xQS2ZSvFoklCxam7tKK0UB/vpyjxRllUwuEFBfq3Y=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6141.eurprd05.prod.outlook.com (2603:10a6:803:e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Sun, 26 Apr
 2020 19:14:02 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Sun, 26 Apr 2020
 19:14:02 +0000
Date:   Sun, 26 Apr 2020 16:13:57 -0300
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
Message-ID: <20200426191357.GB13640@mellanox.com>
References: <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
 <20200422115017.GQ11945@mellanox.com>
 <20200422211436.GA103345@otc-nc-03>
 <20200423191217.GD13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
 <20200424124444.GJ13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
 <20200424181203.GU13640@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR22CA0017.namprd22.prod.outlook.com
 (2603:10b6:208:238::22) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR22CA0017.namprd22.prod.outlook.com (2603:10b6:208:238::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Sun, 26 Apr 2020 19:14:01 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jSmiz-0003q9-BO; Sun, 26 Apr 2020 16:13:57 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 201e7c3c-f320-45bb-c0b8-08d7ea15fa47
X-MS-TrafficTypeDiagnostic: VI1PR05MB6141:|VI1PR05MB6141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6141E71228B8C038D0FA3DC9CFAE0@VI1PR05MB6141.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03853D523D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(86362001)(2616005)(52116002)(9786002)(36756003)(26005)(8936002)(9746002)(2906002)(4326008)(1076003)(8676002)(33656002)(478600001)(316002)(7416002)(54906003)(66476007)(6916009)(66946007)(186003)(5660300002)(66556008)(81156014)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ruzwbEPQD/S9UZdghk3MUN8TAggXfWyNm2GcJfFRDW4NjNfVGO4HiVCPC9ROqfDhHlIL4IT4kkpDfxMDDDtVvAwuywuaHI9UrI8N/QCqwN/xdcSyQvqZP2MEot+yLJqIoZsnrZycNvlA++n29buNdnoSQ8kJL9YV7MMqbP4BgxN86h1GRrmsLB7O7VUf44dg80Miy60l6V8EzsAU01mywBNcPEw+cqdmW9qA+y3KCIzxUTR98WxVccRKISGaY7O77GB7s0xsEadZ+nVsRwYq3QIPIavoPT+Dk42tQ+PjTTto5aAHXbIrlgLUsPPne0DnDpcS8mrFmJ+K/bRJpDYQ1rwDuBZuzjGxCW1WCXgnMz1TZDM+KPMtOPdg17iBMTJ+WSA/1pAynA5OXul3XI1NNJHy6h0Bo4TgEfFouEPqem6YD1nKsUWozz8vH94Ye6yKMz6zyLUc7hCH0t5YnSWp68O7VNa4iDKB69xkOdBBqeDJajVORwwJoeuQkLr12F0v
X-MS-Exchange-AntiSpam-MessageData: aup8lU0XXU6cNtYtZ81Yn28UXGwwagcRxr894lxlONPCpv4nUho52VOn1HRdld6omuMkhxvKxMhawPgI4WCxPD8FLvkE9ha1bBfGpLXbenK4Mfsb2wnrkRwrnLfOBEgsvUKVDOcTE4dvdROa8nTjuPhql9V3iwazv4SNa15VAhankhwv1xCqTPlGT8oSjxQ/eoyWX2ICdkXToq/cIhJmLYRsczaHtM/03WyWu1/9CLSMBhGvOeQ01yjwS2MtofeygTkdEX6JrPCRZMK+Nw0Vf7y0HJ8V+RDmSWR5Ta3hrGfhuiAVQZVlD3ND61CUCwRKpTATtKfnh1m+AXts8Lr0s1/cQwlI4Z2s0hFaNdrDuuMMIL3VnvUhzEOKHGfOL+7FWBKVYkkcgTfmsuIdTbsqrZ9cJQaioWW69OQ8I9+vfcQPythZo/uLJK5RZYgu9MSU+EWSp6nSHifYXdWntxig7WwxdTZ35o1Eqo/rhK6pJaGiCdHS7CUON0F9+J/juFsT01i0SEJtw4FDQAH5sgKLCrJaXRxSk8W3vuzPjQJwnGV96wzGh+w965cE8AhLDvVcJMiK7jtOQxVVb39UjcAauKxRvC8syqrsFmvBL10WOogBl7Q5ObIJpjINR4XdMXkbtEPBSvTaZs8YCdoKegc+RQJ97DqMhPSdOd2wA48IGsT6kpGh11BObXJO9+uG4UwvCAPbH8pvGAnlnDQhVbTXHWyXzDV2ruJdC4LD/b1llyMFUbJLoyLQCGPfvdt8VNfocWh0ointnW5XZVhA1sD3nQTaZPb83T1keoB3GaBIgoc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201e7c3c-f320-45bb-c0b8-08d7ea15fa47
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2020 19:14:01.8039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFDU1WY2UAU3Gn1zsh27cyrB7QtNs0xddueXY5GHRgm0nFKaO7XbSxef60ZFCVeQXd+hjiiuo9EejDJtWyv/GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 26, 2020 at 05:18:59AM +0000, Tian, Kevin wrote:

> > > I think providing an unified abstraction to userspace is also important,
> > > which is what VFIO provides today. The merit of using one set of VFIO
> > > API to manage all kinds of mediated devices and VF devices is a major
> > > gain. Instead, inventing a new vDPA-like interface for every Scalable-IOV
> > > or equivalent device is just overkill and doesn't scale. Also the actual
> > > emulation code in idxd driver is actually small, if putting aside the PCI
> > > config space part for which I already explained most logic could be shared
> > > between mdev device drivers.
> > 
> > If it was just config space you might have an argument, VFIO already
> > does some config space mangling, but emulating BAR space is out of
> > scope of VFIO, IMHO.
> 
> out of scope of vfio-pci, but in scope of vfio-mdev. btw I feel that most
> of your objections are actually related to the general idea of
> vfio-mdev.

There have been several abusive proposals of vfio-mdev, everything
from a way to create device drivers to this kind of generic emulation
framework.

> Scalable IOV just uses PASID to harden DMA isolation in mediated
> pass-through usage which vfio-mdev enables. Then are you just opposing
> the whole vfio-mdev? If not, I'm curious about the criteria in your mind 
> about when using vfio-mdev is good...

It is appropriate when non-PCI standard techniques are needed to do
raw device assignment, just like VFIO.

Basically if vfio-pci is already doing it then it seems reasonable
that vfio-mdev should do the same. This mission creep where vfio-mdev
gains functionality far beyond VFIO is the problem.

> technically Scalable IOV is definitely different from SR-IOV. It's 
> simpler in hardware. And we're not emulating SR-IOV. The point
> is just in usage-wise we want to present a consistent user 
> experience just like passing through a PCI endpoint (PF or VF) device
> through vfio eco-system, including various userspace VMMs (Qemu,
> firecracker, rust-vmm, etc.), middleware (Libvirt), and higher level 
> management stacks. 

Yes, I understand your desire, but at the same time we have not been
doing device emulation in the kernel. You should at least be
forthwright about that major change in the cover letters/etc.
 
> > The only thing we get out of this is someone doesn't have to write a
> > idxd emulation driver in qemu, instead they have to write it in the
> > kernel. I don't see how that is a win for the ecosystem.
> 
> No. The clear win is on leveraging classic VFIO iommu and its eco-system
> as explained above.

vdpa had no problem implementing iommu support without VFIO. This was
their original argument too, it turned out to be erroneous.

Jason
