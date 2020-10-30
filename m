Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850BF2A0EC9
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 20:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgJ3ThS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 15:37:18 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15807 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgJ3Tgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 15:36:50 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9c69ef0000>; Fri, 30 Oct 2020 12:30:55 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 19:30:48 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 30 Oct 2020 19:30:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4AKETfHltvM5cJR5QBe7f/awedGbny+rjw9tanHbfggDTgLuBdPd04a8jmfmBcJfMYrgIshmOjDBKbGaNfyGrXWGLq8yG5n0YlCzScjWx/p0GIbitXsSS0jAWSJl+sez9WkJFsyYZI7xXVMXzonDyLdo/sWcwd92qY0Dp+Gzi4PsZ6y9Uq4OaZkaGyV3d1EwwXnaenrK4t9WRx/3YfzgPME0VPTZG8XDdhOq6FnkPZTQBK6mQK2MMXdfd09Ak8cRLStpMdNNQcxPZ0QXxJBFb5ohP3fu0fGgCqqOCG1Q+xfjdcd6v1E60vEe16UOJ8K8VvCwziBU+6MD/rXOGVcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXGcabxM4TF673Hc+y0JtIYJigmuqhYBGOF4c8gH4m4=;
 b=iW0aYCOrqnlgFF4luvwAfhLa2rfvicu9aEtUsgTI/LVeTpuECo4ekhLEfhpTm6k4ou0Kx/HsJt/VaRh3/o+9AVwsj6aalK9/obJ/9HhxIBuA5zyV7iClLw28C+Gf4kld1VPm3NpPQPFrwXLHr5vqye1q1nWyMiQFrrHY+PdUL6ASMcv01BxS8Ex5OtLE3SX0p2c8+SYTvQ/n38/p9EK0VxSWm8g1kbx5oemUhRLXQ5EIcMEhDjLAJSV1mLFvBm2aLh1EfK3/scxKO7QZFPd7hY/x1S1lA3WpmbDgJxnBf9lZJYSPGpA0fBQNBjAtdiZupkuHha+0WCS8mpKfA7ow1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3307.namprd12.prod.outlook.com (2603:10b6:5:15d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 30 Oct
 2020 19:30:47 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 19:30:46 +0000
Date:   Fri, 30 Oct 2020 16:30:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
CC:     Dave Jiang <dave.jiang@intel.com>, <vkoul@kernel.org>,
        <megha.dey@intel.com>, <maz@kernel.org>, <bhelgaas@google.com>,
        <tglx@linutronix.de>, <alex.williamson@redhat.com>,
        <jacob.jun.pan@intel.com>, <yi.l.liu@intel.com>,
        <baolu.lu@intel.com>, <kevin.tian@intel.com>,
        <sanjay.k.kumar@intel.com>, <tony.luck@intel.com>,
        <jing.lin@intel.com>, <dan.j.williams@intel.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <parav@mellanox.com>, <rafael@kernel.org>, <netanelg@mellanox.com>,
        <shahafs@mellanox.com>, <yan.y.zhao@linux.intel.com>,
        <pbonzini@redhat.com>, <samuel.ortiz@intel.com>,
        <mona.hossain@intel.com>, Megha Dey <megha.dey@linux.intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20201030193045.GM2620339@nvidia.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
 <20201030185858.GI2620339@nvidia.com>
 <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com>
 <20201030191706.GK2620339@nvidia.com> <20201030192325.GA105832@otc-nc-03>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201030192325.GA105832@otc-nc-03>
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0188.namprd13.prod.outlook.com (2603:10b6:208:2be::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.4 via Frontend Transport; Fri, 30 Oct 2020 19:30:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kYa6n-00DrjC-44; Fri, 30 Oct 2020 16:30:45 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604086255; bh=nXGcabxM4TF673Hc+y0JtIYJigmuqhYBGOF4c8gH4m4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=O3vdNejcbH6Q9qGDSK2O7GXowNenLe0FH4k84VN6Jaer6Y4J+Rhr+SdNR7WDbjuwl
         xImOJq1Ndn53XeWLKl06WysI9/zPBKr3UhZRCy4o82QCt3xUcPbLIPRhMaXwm6bI+x
         1CpNbiz5bj2pQzdUAuaradW5jsX0ky3HAneT0fmAzXmBy1oYZQz5rsRfX0ikOHmzrV
         Ug6Dzd73Lz/EEMyRDQzShhD8l2V8zPM6EUCkZ+/KIGSkNoC6hkYBQjrG0WZW+2maWM
         SE46pLSch7acP7b7U6sQZfdNvsbPaJ4JMleB7D0TYGJjdY4LG2pMfUzJ2/F6TOe/bH
         NUvTlcJDZBXMQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 12:23:25PM -0700, Raj, Ashok wrote:
> On Fri, Oct 30, 2020 at 04:17:06PM -0300, Jason Gunthorpe wrote:
> > On Fri, Oct 30, 2020 at 12:13:48PM -0700, Dave Jiang wrote:
> > > 
> > > 
> > > On 10/30/2020 11:58 AM, Jason Gunthorpe wrote:
> > > > On Fri, Oct 30, 2020 at 11:50:47AM -0700, Dave Jiang wrote:
> > > > >   .../ABI/stable/sysfs-driver-dma-idxd          |    6 +
> > > > >   Documentation/driver-api/vfio/mdev-idxd.rst   |  404 ++++++
> > > > >   MAINTAINERS                                   |    1 +
> > > > >   drivers/dma/Kconfig                           |    9 +
> > > > >   drivers/dma/idxd/Makefile                     |    2 +
> > > > >   drivers/dma/idxd/cdev.c                       |    6 +-
> > > > >   drivers/dma/idxd/device.c                     |  294 ++++-
> > > > >   drivers/dma/idxd/idxd.h                       |   67 +-
> > > > >   drivers/dma/idxd/init.c                       |   86 ++
> > > > >   drivers/dma/idxd/irq.c                        |    6 +-
> > > > >   drivers/dma/idxd/mdev.c                       | 1121 +++++++++++++++++
> > > > >   drivers/dma/idxd/mdev.h                       |  116 ++
> > > > 
> > > > Again, a subsytem driver belongs in the directory hierarchy of the
> > > > subsystem, not in other random places. All this mdev stuff belongs
> > > > under drivers/vfio
> > > 
> > > Alex seems to have disagreed last time....
> > > https://lore.kernel.org/dmaengine/20200917113016.425dcde7@x1.home/
> > 
> > Nobody else in the kernel is splitting subsystems up anymore
> >  
> > > And I do agree with his perspective. The mdev is an extension of the PF
> > > driver. It's a bit awkward to be a stand alone mdev driver under vfio/mdev/.
> > 
> > By this logic we'd have giagantic drivers under drivers/ethernet
> > touching netdev, rdma, scsi, vdpa, etc just because that is where the
> > PF driver came from.
> 
> What makes you think this is providing services like scsi/rdma/vdpa etc.. ?
> 
> for DSA this playes the exact same role, not a different function 
> as you highlight above. these mdev's are creating DSA for virtualization
> use. They aren't providing a completely different role or subsystem per-se.

It is a different subsystem, different maintainer, and different
reviewers.

It is a development process problem, it doesn't matter what it is
doing.

Jason
