Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAC83247D5
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 01:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhBYAXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 19:23:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12243 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbhBYAXD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 19:23:03 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6036edbf0000>; Wed, 24 Feb 2021 16:22:23 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 00:22:22 +0000
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 00:22:20 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Feb 2021 00:22:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Be4PcEx6lKlCrwrB72X/viXGZxd9f3DvQJDt6kE2XugTqYXbmCLjmJ1+ouAAfJHIghSQBc7qT7mzqPz1AQNECffuNuKAgEwDrIIisA47KTViK3RHx4O6LW811Iy3nnHGhljO2QzmcDL+mvnTDJ2qb8Hx2EvyMN07ob9VHrhZaNJWIsivETMOabGtaB/L/nXvwyD9x02FLNbV/W7LqhwYoCceCTEhDBCXIKcOqJwfUdzftaoNm0eZSJlvFpR6Ka90XiwPgUdU9xJoBrlhS2pHEfF5JsGYch4v+Rn9Z9l+Kk3u1QM2UwNeYGGRnpVyw5o6Q8mjISMmHAjVD+RWngzlUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0egznQxN012sCHfvbqOxv1y1bHEa8O6omkq7tPL9lhM=;
 b=jKMOyUEM+pr32YBmPziBd0YUqRdj9QpT5Ro0mTR/sw//yCPPE394E22l40mQhD7BBeFDv1DGKG91aKmY3ZM1txePjrQs40lyAGnff/OoXF7i6VQkYtmm6fc9jBZqzXQqbqcEgHaWqmT765rrnZsObVREDGA8/xxdiuCRsV1/KH3lH+JClv4fpJUWaMLlOytRjUTngPnufiNfjqMVI80nlGfA6IL9q51b0ZHUBOpISp3CYMsPNjyIADuLCm4FjGqF3V9vv/azNmh/L5MmKu7rlr1jXBRtzjbBeHEBJwrOgeMnXbgO3QMlMJbuvrwcv6HXEUiCZ6Sce7ds16hjnQSJbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2601.namprd12.prod.outlook.com (2603:10b6:5:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Thu, 25 Feb
 2021 00:22:18 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 00:22:18 +0000
Date:   Wed, 24 Feb 2021 20:22:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210225002216.GQ4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
 <20210222175523.GQ4247@nvidia.com>
 <20210224145508.1f0edb06@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210224145508.1f0edb06@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR15CA0001.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0001.namprd15.prod.outlook.com (2603:10b6:208:1b4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 00:22:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lF4Q4-00GtJD-Pl; Wed, 24 Feb 2021 20:22:16 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614212543; bh=0egznQxN012sCHfvbqOxv1y1bHEa8O6omkq7tPL9lhM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=CARsnzLXY9qhbvRlCYRvRaUhkON2hWO6zt6E1pUQ5mp9RetyZBgzxdkOWYPmjM+co
         oEeGVLzJBHzS89kUV/l0rWPnY+xzH7kUXrlrSGHK1oceHw/bFIntrN9p5aHp3k67eh
         zvmHSVo48r6gwHhTE1BXEmTq15k9uOqpQsEBa34fHFyq1C3Zl7G0cc1N9B8TPqhWMG
         NeOmTkfd24FpcvtA/Zu+GHuDXUKA9yOIMccG/D4Sm6fRghXs39xh9nTfMbJPwfrMwx
         +L+JCvs2Cf1+MAOKit1v2XE5aEdsVS79iD4Kpmr9WyW06uKiYFTj6Phf0TdP9MnnHI
         SE4OyzcP2h9Ew==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 02:55:08PM -0700, Alex Williamson wrote:

> > > +static bool strict_mmio_maps = true;
> > > +module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
> > > +MODULE_PARM_DESC(strict_mmio_maps,
> > > +		 "Restrict to safe DMA mappings of device memory (true).");  
> > 
> > I think this should be a kconfig, historically we've required kconfig
> > to opt-in to unsafe things that could violate kernel security. Someone
> > building a secure boot trusted kernel system should not have an
> > options for userspace to just turn off protections.
> 
> It could certainly be further protected that this option might not
> exist based on a Kconfig, but I think we're already risking breaking
> some existing users and I'd rather allow it with an opt-in (like we
> already do for lack of interrupt isolation), possibly even with a
> kernel taint if used, if necessary.

Makes me nervous, security should not be optional.

> > I'd prefer this was written a bit differently, I would like it very
> > much if this doesn't mis-use follow_pte() by returning pfn outside
> > the lock.
> > 
> > vaddr_get_bar_pfn(..)
> > {
> >         vma = find_vma_intersection(mm, vaddr, vaddr + 1);
> > 	if (!vma)
> >            return -ENOENT;
> >         if ((vma->vm_flags & VM_DENYWRITE) && (prot & PROT_WRITE)) // Check me
> >            return -EFAULT;
> >         device = vfio_device_get_from_vma(vma);
> > 	if (!device)
> >            return -ENOENT;
> > 
> > 	/*
> >          * Now do the same as vfio_pci_mmap_fault() - the vm_pgoff must
> > 	 * be the physical pfn when using this mechanism. Delete follow_pte entirely()
> >          */
> >         pfn = (vaddr - vma->vm_start)/PAGE_SIZE + vma->vm_pgoff
> > 	
> >         /* de-dup device and record that we are using device's pages in the
> > 	   pfnmap */
> >         ...
> > }
> 
> 
> This seems to undo both:
> 
> 5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")

No, the bug this commit described is fixed by calling
vfio_device_get_from_vma() which excludes all non-VFIO VMAs already.

We can assert that the vm_pgoff is in a specific format because it is
a VFIO owned VMA and must follow the rules to be part of the address
space. See my last email

Here I was suggesting to use the vm_pgoff == PFN rule, but since
you've clarified that doesn't work we'd have to determine the PFN from
the region number through the vfio_device instead.

> (which also suggests we are going to break users without the module
> option opt-in above)

Not necessarily, this is complaining vfio crashes, it doesn't say they
actually needed the IOMMU to work on those VMAs because they are doing
P2P DMA.

I think, if this does break someone, they are on a real fringe and
must have already modified their kernel, so a kconfig is the right
approach. It is pretty hard to get non-GUP'able DMA'able memory into a
process with the stock kernel.

Generally speaking, I think Linus has felt security bug fixes like
this are more on the OK side of things to break fringe users.

> And:
> 
> 41311242221e ("vfio/type1: Support faulting PFNMAP vmas")
> 
> So we'd have an alternate path in the un-safe mode and we'd lose the
> ability to fault in mappings.

As above we already exclude VMAs that are not from VFIO, and VFIO
sourced VMA's do not meaningfully implement fault for this use
case. So calling fixup_user_fault() is pointless.

Peter just did this so we could ask him what it was for..

I feel pretty strongly that removing the call to follow_pte is
important here. Even if we do cover all the issues with mis-using the
API it just makes a maintenance problem to leave it in.

Jason
