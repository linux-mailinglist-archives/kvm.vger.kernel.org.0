Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302932A6DD3
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 20:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgKDT3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 14:29:23 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:34340 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKDT3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 14:29:23 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa301120000>; Thu, 05 Nov 2020 03:29:22 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Nov
 2020 19:29:20 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 4 Nov 2020 19:29:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLGEYBtm0Y2yv/0z7+BtLa5Yf+aVTF/vAGrn9KrN+ijEFScF0w30YLbVwRNBZ0pYRWjp1QtDWKul0uZUuN7FcvOBZsZAa77g0rDE6YYuzlTj8auuWRQm9Suu02wnJz/3dYxWqlrMBKSiB+x7qaJyBgJIByItzGeIAUpmZkG9DOVFiLtveT4k/aBAoM1aOgC8vx8PZ209J5MP7cLWoG+f/zPfchoPZ6MY/ko2rNN90yUe1zbsvSc5I8JLq1De11uvDTZUCsu6BnC1ynZG+HVacM0DSHg+FAh8xE0PkaVS91qctvk07mBMhsLjO3cMAAY8SZWJ+c43SmiRxGJha1KRtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdxZRNQhQlxGudrAcPA0I9RD12/9fB2ddJQAbN4pwhA=;
 b=U4AT4MqnYh5ewQ3vRSgc/bxqtjTWfGYvpod+7QkAubAhs31j4HtQy5PNLSNziK6JqCIZyok8emYx/oi+6F+XdTmarlGVeqthfXKCBgv6+WOAySvn0PCxZ1+AhVtD0g7wVbzUQ/kvm1UEDqFf5QlthMRa6ts+a/UJ0GcGn1cIeTuaVLJ9SEi6fVo6UpIpQRgyhzMoMNaUjqEduMx2ilJy0rMfNQiqIkplVtE4ZrILk42e4F6sMCby/AHY7BYjM4yo8PPYZAe4LuJcGpaK7PVYMEpCZqVjykmDC08m46xzgC3wNond8dP7yO67HvN+vJq2PrZ7W8WDJNrhZdrgcGhH5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3212.namprd12.prod.outlook.com (2603:10b6:5:186::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.24; Wed, 4 Nov
 2020 19:29:18 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 19:29:18 +0000
Date:   Wed, 4 Nov 2020 15:29:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "joro@8bytes.org" <joro@8bytes.org>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: (proposal) RE: [PATCH v7 00/16] vfio: expose virtual Shared
 Virtual Addressing to VMs
Message-ID: <20201104192916.GA2620339@nvidia.com>
References: <20201103125643.GN2620339@nvidia.com>
 <20201103131852.GE22888@8bytes.org> <20201103132335.GO2620339@nvidia.com>
 <20201103140318.GL22888@8bytes.org> <20201103140642.GQ2620339@nvidia.com>
 <20201103143532.GM22888@8bytes.org> <20201103152223.GR2620339@nvidia.com>
 <20201103165539.GN22888@8bytes.org> <20201103174851.GS2620339@nvidia.com>
 <20201103191429.GO22888@8bytes.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201103191429.GO22888@8bytes.org>
X-ClientProxiedBy: BL0PR02CA0065.namprd02.prod.outlook.com
 (2603:10b6:207:3d::42) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0065.namprd02.prod.outlook.com (2603:10b6:207:3d::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 4 Nov 2020 19:29:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kaOT6-00Gc7u-N1; Wed, 04 Nov 2020 15:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604518162; bh=JdxZRNQhQlxGudrAcPA0I9RD12/9fB2ddJQAbN4pwhA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=HdmRXl6JdBphMAbaFSoGIrKDLSjKvXeUzi6bCwTNDjrDtRdwNu6nFl3IcmiD81NFo
         +aBiKdc9j+fzoj1ooeiaUIdNkw3UgqoQ1PwOriDo5XxcQiVsAC7XYBEUe6HhPOh4ZQ
         F8UbKY5Vs2n5vJja/S0r6vOsxSfGbxdPr6qutr0Rg+fo/7P6/qf9L709VIMn5H5qWQ
         VWkNGOTIe0/Qc/dtE6AvUuHHvdKi4wqxAoAZ4b4OP7zMKLWuZ5FVB/mUnssUgmAfvc
         tqnQ5c8vRcMFRyFqyvscj07R53H2MkJnwSJUc+sSqs0QPvU3FlZaFFX8U+rX8Wb1yP
         3qL2eSC3Z3lvA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 03, 2020 at 08:14:29PM +0100, joro@8bytes.org wrote:
> On Tue, Nov 03, 2020 at 01:48:51PM -0400, Jason Gunthorpe wrote:
> > I think the same PCI driver with a small flag to support the PF or
> > VF is not the same as two completely different drivers in different
> > subsystems
> 
> There are counter-examples: ixgbe vs. ixgbevf.
>
> Note that also a single driver can support both, an SVA device and an
> mdev device, sharing code for accessing parts of the device like queues
> and handling interrupts.

Needing a mdev device at all is the larger issue, mdev means the
kernel must carry a lot of emulation code depending on how the SVA
device is designed. Eg creating queues may require an emulated BAR.

Shifting that code to userspace and having a single clean 'SVA'
interface from the kernel for the device makes a lot more sense,
esepcially from a security perspective.

Forcing all vIOMMU stuff to only use VFIO permanently closes this as
an option.

Jason
