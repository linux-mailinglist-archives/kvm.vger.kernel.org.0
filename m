Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E4F2A0E2E
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgJ3S7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:59:05 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:44701 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgJ3S7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 14:59:05 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9c62770000>; Sat, 31 Oct 2020 02:59:03 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 30 Oct
 2020 18:59:02 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 30 Oct 2020 18:59:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbDLas1Qq8QhCgtNDOgE1D43sa2m0W+vEDnBdJlyauMyO2XaJo8rfTkdvQ8stf28AqW1gaPWsZs9VYUPwbye5bxBSZZAP0P2MjJUo6Ot6MFLoM7G3sMeANwLetjopMe5RA1Xp/BMhS21vCk4/KliiUPOVOdAeMzlnvt0LHizjkEeBwafns+3W7fht2j/CYVlWbIAkJPG4s5uEMrgpR/lsSqey5TShX8djJCifTx0aL2AlhBxdKA8u4+2gI6egt4XqmwF/HbT6hpr9sIeezBgvcJaAf9BG4a1EWvJ3ANQciVfnd4VdondIxwJmkgtc+lEnUU9PxdnAkUCBa2H+tAhHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYY+InYme0phU/MkMoVEnVOWWlNxTb0gHn0/Oyfj/J4=;
 b=RIOd7Py2kJTyB8Wm6kgIwTSXSY75Xv1tgcJUUxooiiFXBpMk9a9GhBKnFoLHNDeTZdCCLM4GIXvwQf42s7sdH0j2NGILx7iFVTWymkLSZ6kOX253oTBbbvFnraeECAkXUxDwgh4qjAZTB4xzAotZ+Ts1nJUpqNHe6pvAhwh2Dx2nrKo4sCOxAysE7rN5HxSaPdP+03/uIBvN9x/eCBHIXtF1XUV/pywfKbysZAAUS/y0QyGlPjuBzw3dGxhWmMTZ8Myqe3hgHbKeXA2c+69xIKVcv+aZkgguiuMniv7Zzhm3sH9aGYga5UZU/7V6+T9sGo2dENWVlf3ZZHuvZa3sSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Fri, 30 Oct
 2020 18:59:00 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 18:58:59 +0000
Date:   Fri, 30 Oct 2020 15:58:58 -0300
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
Message-ID: <20201030185858.GI2620339@nvidia.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR20CA0019.namprd20.prod.outlook.com (2603:10b6:208:e8::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Fri, 30 Oct 2020 18:58:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kYZc2-00DmW7-E4; Fri, 30 Oct 2020 15:58:58 -0300
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604084343; bh=DYY+InYme0phU/MkMoVEnVOWWlNxTb0gHn0/Oyfj/J4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-LD-Processed;
        b=IKhkGda+Bj4OnNKwbWvKGlrhEIdb+v/KyTIXMUxi8HftGTtlvZ+c/AObUb38UBNvI
         JPZnTQGJbMo6ke+G+L8+jIaQtvclqrGCAhgyEifq1OlYCJ4bpsnpcBAfOxEz7qOdAn
         qgGbrjJ2tWm5Q8JRMkwMyIDaIzFpuo3UHsAQlvcGmxn307O4eMo2zHudLXSyISe6B1
         vcZPFqB5wKbrqVZdIqE8spPUti9vdGb4xSRx021Nh60j8NNCA4IGU+R5yhfbCTW/ve
         Ho+zkXcR1J3vOyFamaKzqzTuaSXSNJEzOkYorL6Re51etS8goQojCFvn4ds5PPU22+
         Iva5Wnstl2ytg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 11:50:47AM -0700, Dave Jiang wrote:
>  .../ABI/stable/sysfs-driver-dma-idxd          |    6 +
>  Documentation/driver-api/vfio/mdev-idxd.rst   |  404 ++++++
>  MAINTAINERS                                   |    1 +
>  drivers/dma/Kconfig                           |    9 +
>  drivers/dma/idxd/Makefile                     |    2 +
>  drivers/dma/idxd/cdev.c                       |    6 +-
>  drivers/dma/idxd/device.c                     |  294 ++++-
>  drivers/dma/idxd/idxd.h                       |   67 +-
>  drivers/dma/idxd/init.c                       |   86 ++
>  drivers/dma/idxd/irq.c                        |    6 +-
>  drivers/dma/idxd/mdev.c                       | 1121 +++++++++++++++++
>  drivers/dma/idxd/mdev.h                       |  116 ++

Again, a subsytem driver belongs in the directory hierarchy of the
subsystem, not in other random places. All this mdev stuff belongs
under drivers/vfio

Jason
