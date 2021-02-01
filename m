Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5663130AF85
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 19:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhBAShR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 13:37:17 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19690 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhBASgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 13:36:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60184a170002>; Mon, 01 Feb 2021 10:36:07 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 18:36:05 +0000
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 18:36:03 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 18:36:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZeUhKCvA9N4AiF4RlcIflSIjma3pDzXDhGUctVTErkg53X7GfC+VNCgCmEjaOYrNS+wrnWr3gEuAJHs1fGmydj7K8IRX43z0ZEKdBQ4MFI0FL65X/YHFfC7jwNvcbYlujkLMo5dIZeJrKpZjvKalQPuyku116NIcP6WHBxVEMYQ4SO9pdnZsm4JcxhFxe0x0n7rn0lNLgPGKEc+v0rhqaP2F/j/Mtirb0ze8v7MYLuhiqImvnGOQrAvIIkN97Eq/ar/REntCzyHIBp57X6y3qys7ogquFr18uY+zcJA+36zesn/0HhzZUd4te8tEmndTimysPWRgMhBFk2KKU7hJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jiTKruJO1AZI7fiHFHE5Rl0gmUMUSvyc/wvIj4+AKSs=;
 b=cGA+oPVlIkknT9qBCBHYXdUh2KOjARMTod2KYS6tuiMFW7AGXdya9V49PMzuakNQXDq4h97g7ot7lva3iUa3RiREf2a1QvcWwaqGnyXWJ2CHrbyQ2/6jbWer1htO+6m2H3xr5VjOVCNIK2aCovzeI204ImD0QCQWhY9B8WscgAmA1xKgiyCqHKrwmALfry6W/b9R+A3ogZNpeQvqHQm8QN4ElKp/rTc1kRgqNF4mSM3Ea6UT5wIFOXKGxIDFNdjlmVVEyjJCdQORhj2EFBz3aVXqMpNyWLhvWYbpIVaLwFqX63kYD04C8xgrisqMlwNN0GO/UbvmEU5q1bEhWERuxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1244.namprd12.prod.outlook.com (2603:10b6:3:73::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Mon, 1 Feb
 2021 18:36:00 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 18:35:59 +0000
Date:   Mon, 1 Feb 2021 14:35:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alex.williamson@redhat.com>,
        <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <gmataev@nvidia.com>, <cjia@nvidia.com>,
        <mjrosato@linux.ibm.com>, <yishaih@nvidia.com>, <aik@ozlabs.ru>
Subject: Re: [PATCH 9/9] vfio/pci: use powernv naming instead of nvlink2
Message-ID: <20210201183558.GM4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-10-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210201162828.5938-10-mgurtovoy@nvidia.com>
X-ClientProxiedBy: MN2PR18CA0001.namprd18.prod.outlook.com
 (2603:10b6:208:23c::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR18CA0001.namprd18.prod.outlook.com (2603:10b6:208:23c::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Mon, 1 Feb 2021 18:35:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6e3K-002HtE-DT; Mon, 01 Feb 2021 14:35:58 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612204567; bh=jiTKruJO1AZI7fiHFHE5Rl0gmUMUSvyc/wvIj4+AKSs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=bi0UtzZlOamrA+yhLa1lWgGCqd0FtocnaKl4jMJoy3wgDwlUsHdeaVHznocEABouK
         XK/11lEkaknpupxwuMadwzjeZmX+sZJst4ySu0i7iF2PqCQ54CLAFFMARgkZDBkAeC
         IN5WI0S+eBB7gS1KJi9dORXHwNqMKBJpIGOofHKRFMz8wfWSvmqVbmE9ciAcuV0M/5
         PRPvNLyLlxpP43KXNIsXO0ouPVx7ZMYg6DrwQADVdCbPjTZzRnI/sFAhBSlI3DJ/SF
         4Pk9LXbD/CLCaTYxQ9LxvlxoJ+PkzdOQ0+o/jHKb1usMA5bA9IHPH1BJ2oEsbrEJfM
         woZz3zmHep8qA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 01, 2021 at 04:28:28PM +0000, Max Gurtovoy wrote:
> This patch doesn't change any logic but only align to the concept of
> vfio_pci_core extensions. Extensions that are related to a platform
> and not to a specific vendor of PCI devices should be part of the
> core driver. Extensions that are specific for PCI device vendor should go
> to a dedicated vendor vfio-pci driver.
> 
> For now, powernv extensions will include only nvlink2.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>  drivers/vfio/pci/Kconfig                                    | 6 ++++--
>  drivers/vfio/pci/Makefile                                   | 2 +-
>  drivers/vfio/pci/vfio_pci_core.c                            | 4 ++--
>  drivers/vfio/pci/{vfio_pci_nvlink2.c => vfio_pci_powernv.c} | 0
>  drivers/vfio/pci/vfio_pci_private.h                         | 2 +-
>  5 files changed, 8 insertions(+), 6 deletions(-)
>  rename drivers/vfio/pci/{vfio_pci_nvlink2.c => vfio_pci_powernv.c} (100%)

This is really nothing to do with PPC, "nvlink" is a PCI device that
shows the entire GPU memory space on these special power systems, and
the this driver changes the normal vfio-pci behavior to match the
single device.

This is probably the best existing example of something that could be
a vendor PCI driver because of how single-device specific it really
is.

Read 7f92891778dff62303c070ac81de7b7d80de331a to get some sense of how
very special a device it is.

This could be like mlx5, with the single PCI ID pre-populated in a
match table.

That is probably the key test for vfio_pci_core vs vfio_pci - if the
modification is triggered by a single PCI ID that can be matched it is
vfio_pci side, not core.  Compared to the s390 stuff which applies to
all PCI devices in the system.

Jason
