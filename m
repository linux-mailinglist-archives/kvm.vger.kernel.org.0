Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0491B438B
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 13:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgDVLu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 07:50:27 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:30048
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726043AbgDVLu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 07:50:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZGYrnXj0/HRw20mrWUORIUyWru3UC6xn7kZkebNbd3MNHAwERHhJs9+WNdV1GplVMlI2gvjbPWM2ru2mfLeykIcLGhG8hHb7bEJeFPHMDKsdC/kU7/IQQpW7NrtIRKPTaRdK4w0EOmZRV3YlWXCJAT0/sMjyhr2cbE89RhXQmR2wcr3Nm8JGyg0i9p404xVD/i/6iDI31PZKOy9NDM1FFNaJgTTmmO2Ai8qGj9JIT2nVGDIeRP6/9nxRKY0NSBjmdpMJ95XRni7sRucveDF5LI+oRKmPeJwHq1Zgdc93emKON3YFqMDgQnXquvr4sfjfugagk9jQZpuPQsdnHAzXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiHdXJZxGaInGlyTvej0EWR4G9fxBg/5DXDTQYIkFAE=;
 b=T3jN40IN1+d6dvizvnCSSyCamGmwQD6znJGY7cQsBBTkTV0qXyqDkKwu7kAqbo1bz9C561nYSXJQpRWGh43gBiXXe30fpmdtEh1HaL2ynkq7wSkyINN5HwYYJRF/do76PRxrKfSpJBYhKEjb7eSEAHSYzpjt6qgsRSiuTVBD0hhD3AQXZ9FddwvUECkEsCGYRVp7VVT0v4m4H1rtzWMdmfmtDUbSDI4EK0rk0NwD9kRa4Gw8p7NEVQc8vEEq/lPGzueYYKY6InJtYbsO8PgBJSHdHcT6PlYhlMZ1KMsQkbdYyeLQhde45IubIc64l794CtfHu3Lh1e/t85jxnVmmUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiHdXJZxGaInGlyTvej0EWR4G9fxBg/5DXDTQYIkFAE=;
 b=ahOUpgrFMc0K8skWLDg/6RFm1AgTW8sBlFCAnm9Vr1h6An53igVeYH60AEFYLooUR/4T1TERAsmLRytVFKfII0rB9a30YyGf325g8tVAJl9wo4et2jAcq8dyF0S6gqJAv+z2qqAGXFRG8MZddB4sF+9EBFTDop4oQCwYvILfaxs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6144.eurprd05.prod.outlook.com (2603:10a6:803:e8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 22 Apr
 2020 11:50:21 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 11:50:21 +0000
Date:   Wed, 22 Apr 2020 08:50:17 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Jiang, Dave" <dave.jiang@intel.com>,
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
        "Raj, Ashok" <ashok.raj@intel.com>,
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
Message-ID: <20200422115017.GQ11945@mellanox.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <20200421235442.GO11945@mellanox.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D86EE26@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR15CA0004.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::17) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR15CA0004.namprd15.prod.outlook.com (2603:10b6:208:1b4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 11:50:20 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jRDtR-0005Jl-6J; Wed, 22 Apr 2020 08:50:17 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b8f61273-44a1-436e-ec98-08d7e6b355c4
X-MS-TrafficTypeDiagnostic: VI1PR05MB6144:|VI1PR05MB6144:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB61441FF49D2E8F59F8C8BA25CFD20@VI1PR05MB6144.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(52116002)(9746002)(186003)(9786002)(26005)(8936002)(81156014)(8676002)(478600001)(36756003)(7416002)(2906002)(54906003)(316002)(6916009)(2616005)(66556008)(66476007)(1076003)(66946007)(4326008)(33656002)(86362001)(5660300002)(24400500001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g2hhWJZx18CpRfjbS+Oh6BWXZ22hlU53I+inlXjFWSch6Xb/aVxhnw51PvCg5FE7NeKaY4+WFrIaoYx0Qo/rsGStrYHgAVlwtIOV21pbHTud4cse00qnagorPOv/X+NmbQg0wkn2eStUlxBFSr9sbXZLpxJQOF7M8aS3JofDenM2r//jLXo4vJMrJKgqRuJDVdfmWeU9ZWg1la/mJFqk3kTOp6TboglgVprnKhOWz9JhJNVEKQdmLgpt3mCKePLUEoyllVGeiQkJCRs3orMoAkNjBB5AdDl0v8xrGHRdPeu6daodmwuhekyUGuI5btQ1r1SrzW8eZVPr3uPoLYb7qMR4fcnbz04GxfIgoNoXbPrZJuEaGCPEDZVf4Zv7XptqdZOqelew/5pomVIwukW85FamdTckyFnFzJ2JFtfnZzl9rYLvLhZsbaL3Yb3IBIxzVzIg7LM/ZR1lTB1HQuH/MotdkCuEyQhS9cTO07W8RboCZ1YMInBBvqS3+O8SgtM4
X-MS-Exchange-AntiSpam-MessageData: stkA1MXK4zOck7r69UNwJBGhBKDT+RMVW+XVmhpgnd60BceiJBlscBQY3/fb6i7RR5Z6n+jXEUaUjF0uJfCAojoivYwFI7n67HcSSqIhl9ofEOhj28i8xZjYTYyf9MedmTuoMlbZhvbbD+XO0HbrQw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f61273-44a1-436e-ec98-08d7e6b355c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 11:50:21.4944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xu5DnnwejPSswsnrh77OfwllhVrst09R4Fed5uZfCW4CqvD1NTjk0F4no1lnUzWgfTNqNGrFtJF6uR0+1V5k2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 12:53:25AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe
> > Sent: Wednesday, April 22, 2020 7:55 AM
> > 
> > On Tue, Apr 21, 2020 at 04:33:46PM -0700, Dave Jiang wrote:
> > > The actual code is independent of the stage 2 driver code submission that
> > adds
> > > support for SVM, ENQCMD(S), PASID, and shared workqueues. This code
> > series will
> > > support dedicated workqueue on a guest with no vIOMMU.
> > >
> > > A new device type "mdev" is introduced for the idxd driver. This allows the
> > wq
> > > to be dedicated to the usage of a VFIO mediated device (mdev). Once the
> > work
> > > queue (wq) is enabled, an uuid generated by the user can be added to the
> > wq
> > > through the uuid sysfs attribute for the wq.  After the association, a mdev
> > can
> > > be created using this UUID. The mdev driver code will associate the uuid
> > and
> > > setup the mdev on the driver side. When the create operation is successful,
> > the
> > > uuid can be passed to qemu. When the guest boots up, it should discover a
> > DSA
> > > device when doing PCI discovery.
> > 
> > I'm feeling really skeptical that adding all this PCI config space and
> > MMIO BAR emulation to the kernel just to cram this into a VFIO
> > interface is a good idea, that kind of stuff is much safer in
> > userspace.
> > 
> > Particularly since vfio is not really needed once a driver is using
> > the PASID stuff. We already have general code for drivers to use to
> > attach a PASID to a mm_struct - and using vfio while disabling all the
> > DMA/iommu config really seems like an abuse.
> 
> Well, this series is for virtualizing idxd device to VMs, instead of
> supporting SVA for bare metal processes. idxd implements a
> hardware-assisted mediated device technique called Intel Scalable
> I/O Virtualization,

I'm familiar with the intel naming scheme.

> which allows each Assignable Device Interface (ADI, e.g. a work
> queue) tagged with an unique PASID to ensure fine-grained DMA
> isolation when those ADIs are assigned to different VMs. For this
> purpose idxd utilizes the VFIO mdev framework and IOMMU aux-domain
> extension. Bare metal SVA will be enabled for idxd later by using
> the general SVA code that you mentioned.  Both paths will co-exist
> in the end so there is no such case of disabling DMA/iommu config.
 
Again, if you will have a normal SVA interface, there is no need for a
VFIO version, just use normal SVA for both.

PCI emulation should try to be in userspace, not the kernel, for
security.

Jason
