Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982662A0E73
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 20:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgJ3TSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 15:18:37 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:2152 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbgJ3TRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 15:17:18 -0400
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9c66bd0000>; Sat, 31 Oct 2020 03:17:17 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 19:17:12 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 30 Oct 2020 19:17:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Me22rpeSRXQMUQrvhoJECVJQcsyzbvOwqK56MqkoQUss6cSmIKAArGjDiH1MROYUj13JrhyEE2NT2xckuM0uf0ybMfep43YcyU0lQkUca+czf13+zi4POu07HGfQ5wybiJ5okToxQdpqajg+e58VApq90wbqZVBtgLG26hSrG7Q26l73NfEZGLWiBxDp+eS1RtTptcB/XDYcIf31VHwKQsgprPyTwbLSQ3fXr/huzehRQuop/zrfSDNLTPyA8G1JN8fEpNkaENAPFXXy6kEGdDF5USo1+Bhsm92SlFlCWiw6SC5y8PmmeycODVMK/SyAOxem57+7YVHPivLKPEGaQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfBoqHxivg6uTLVzAFWI9pTdmDRwGjaFwky8ZgmWvWQ=;
 b=FEtBNXorjar1q0fNlTI/rshT/Supv7bmtGZn0CwFjDANiB+E0JlBU7aCqfztB8P4LPaWpcuhjcGEM1EImdyq3YaXU+2El/K1t20/T5bzfWlYivvq1oOHE3UgMFYXs/rgjXo+Mg0EOJ1BKR3yDuNTrPQYqB92pj2fDFi4rBW7Fl4zb5lbkTo9t1wCxSX7hW3c7azy7L+3kSaFiz/+2hq8+FmghK5rMLuL+TjKXUxlzEqSv7V3wgVSeqYUoLy9MPXj6r+SnKfUvvGVDg2EzKSbBINYt1+mKC8LWGfy7O5T+/XXvE7OAIlbXfoZfm+MNZroNjd5Wy/hP+4v//T/nUvOrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0106.namprd12.prod.outlook.com (2603:10b6:4:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 30 Oct
 2020 19:17:07 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 19:17:07 +0000
Date:   Fri, 30 Oct 2020 16:17:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
CC:     <vkoul@kernel.org>, <megha.dey@intel.com>, <maz@kernel.org>,
        <bhelgaas@google.com>, <tglx@linutronix.de>,
        <alex.williamson@redhat.com>, <jacob.jun.pan@intel.com>,
        <ashok.raj@intel.com>, <yi.l.liu@intel.com>, <baolu.lu@intel.com>,
        <kevin.tian@intel.com>, <sanjay.k.kumar@intel.com>,
        <tony.luck@intel.com>, <jing.lin@intel.com>,
        <dan.j.williams@intel.com>, <kwankhede@nvidia.com>,
        <eric.auger@redhat.com>, <parav@mellanox.com>, <rafael@kernel.org>,
        <netanelg@mellanox.com>, <shahafs@mellanox.com>,
        <yan.y.zhao@linux.intel.com>, <pbonzini@redhat.com>,
        <samuel.ortiz@intel.com>, <mona.hossain@intel.com>,
        Megha Dey <megha.dey@linux.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201030191706.GK2620339@nvidia.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
X-ClientProxiedBy: MN2PR20CA0059.namprd20.prod.outlook.com
 (2603:10b6:208:235::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0059.namprd20.prod.outlook.com (2603:10b6:208:235::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 19:17:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kYZta-00DrCR-2K; Fri, 30 Oct 2020 16:17:06 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604085437; bh=hfBoqHxivg6uTLVzAFWI9pTdmDRwGjaFwky8ZgmWvWQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=gDJs3g2hN/7GA2dHSQYhgMGc5uzcnjP+0qXasETAf4NrJzEfQ79AZqLgkZ29j0rCy
         KAEmJO4p1VmhVHLB7mIwTRkS4aYugZwnsCL7qBVilNYxNQ5hS8bysj8h7wnaZMIKJI
         S4yoOLeICHyihyOei26izJEnj5OywKlh9Iw93eNavCn4Gn86vaBbZEz9QT9V7m6pt4
         xIWHjQILfJ+imMhoOvJ1XUGFobSlJ7asuSj87VtiR0VluCMoqnFS6sfpb3laYiQ0iB
         yz1Zt9mk4Sj110hLGDP7kjgc5CZMe2jCwhDXro/FQFHx6SAJw1fDNDoYqfpxbctlBc
         PCagKmEl5zZEQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 12:13:48PM -0700, Dave Jiang wrote:
> 
> 
> On 10/30/2020 11:58 AM, Jason Gunthorpe wrote:
> > On Fri, Oct 30, 2020 at 11:50:47AM -0700, Dave Jiang wrote:
> > >   .../ABI/stable/sysfs-driver-dma-idxd          |    6 +
> > >   Documentation/driver-api/vfio/mdev-idxd.rst   |  404 ++++++
> > >   MAINTAINERS                                   |    1 +
> > >   drivers/dma/Kconfig                           |    9 +
> > >   drivers/dma/idxd/Makefile                     |    2 +
> > >   drivers/dma/idxd/cdev.c                       |    6 +-
> > >   drivers/dma/idxd/device.c                     |  294 ++++-
> > >   drivers/dma/idxd/idxd.h                       |   67 +-
> > >   drivers/dma/idxd/init.c                       |   86 ++
> > >   drivers/dma/idxd/irq.c                        |    6 +-
> > >   drivers/dma/idxd/mdev.c                       | 1121 +++++++++++++++++
> > >   drivers/dma/idxd/mdev.h                       |  116 ++
> > 
> > Again, a subsytem driver belongs in the directory hierarchy of the
> > subsystem, not in other random places. All this mdev stuff belongs
> > under drivers/vfio
> 
> Alex seems to have disagreed last time....
> https://lore.kernel.org/dmaengine/20200917113016.425dcde7@x1.home/

Nobody else in the kernel is splitting subsystems up anymore
 
> And I do agree with his perspective. The mdev is an extension of the PF
> driver. It's a bit awkward to be a stand alone mdev driver under vfio/mdev/.

By this logic we'd have giagantic drivers under drivers/ethernet
touching netdev, rdma, scsi, vdpa, etc just because that is where the
PF driver came from.

It is not how the kernel works. Subsystem owners are responsible for
their subsystem, drivers implementing their subsystem are under the
subsystem directory.

Jason
