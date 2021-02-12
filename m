Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09E131A66B
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 22:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhBLU71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 15:59:27 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19182 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhBLU6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 15:58:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026ebdb0000>; Fri, 12 Feb 2021 12:58:03 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 20:58:02 +0000
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 20:58:00 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 20:58:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aT/Jws6mnjaRE7fJI7QRedMCrlDJY3d8USxd4tQngATklMCTeoHASywU0gSMCeo2Xh3UGsziLDufKZSw3WXhI5aLivFIu4mO/4H7xVBe21U5zrQlMsDO2fgQqx9zOGa/5IBXhvPFnO+T9/QrUvR80Jagr9mugPVFpgmXgqQxEAJ8UplByqvU3+5RSV2/rfA+C0coOLXHZiYBn2+61UQAGb89W1Wuj+9NsjyZ+ilG+76sZZAR8tCTJvnCDfJxbJjvE3BvztlecOnyp7q81KsNqXk6b9yo2UuY+298zF8gNXPeusAuOCP4/xZ+BKa1I97Rx0ip58nRyjrGO7ukq/BXlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXbet/aqZDSYrNDHmw3zTTbkFtCL94DHwD74wqCi4uc=;
 b=YHiz+QsLEbNUXKk5TpOOaLctnoQgcJjX2u8gcdxeoDwwpCAAxIfJh+A4TA6p/lkhvBQOtMiiM46BdxOYr8bTKOfqM8SJdELg0xykDxqBUC7tScIzdMymDqrJ2IMPOW8ZA3AqdgcJXbOQYSCgbaO3Qj7gip+M3Pvj07C2Lu2YIcHXN0YSLFNMYyzDIis37tpQwROythTsAz7T6uRmeqfLBKE9z8pvmuNCj0a3IVUhjak5VKoZGuhQd8B+qaJii/tgIRjkyHtAGH8GTAGYyclRyOkzyCE9wWjM6hmmg+e0uYx8VGH9kHsZxO0cc0hbGe6dVuCka9FXBeYgbsRJnpgnig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2938.namprd12.prod.outlook.com (2603:10b6:5:18a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 20:57:57 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 20:57:57 +0000
Date:   Fri, 12 Feb 2021 16:57:55 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [PATCH 0/3] vfio: Device memory DMA mapping improvements
Message-ID: <20210212205755.GV4247@nvidia.com>
References: <161315658638.7320.9686203003395567745.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161315658638.7320.9686203003395567745.stgit@gimli.home>
X-ClientProxiedBy: MN2PR14CA0006.namprd14.prod.outlook.com
 (2603:10b6:208:23e::11) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR14CA0006.namprd14.prod.outlook.com (2603:10b6:208:23e::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 20:57:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAfVk-007nih-0H; Fri, 12 Feb 2021 16:57:56 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613163483; bh=pXbet/aqZDSYrNDHmw3zTTbkFtCL94DHwD74wqCi4uc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=R7ZWhCwu0lhth2yrDvtnZYYP2WkW1s06XFvvTWoPTH35IsL+6dt2j9N2RnPgnLjm/
         s0a1KI6ycwEoDumGm+KQ81wKmdEP91Ti0Lu7Vcfn2/UNq/VuIDwskOjJ/txEXJEbRQ
         YjXhlXddeEfRvZKgSs7+Xc2hmAyJn/uzxcaPDySCHWI3wXcj9EO90xzfF7lAgO/Ckg
         wd1xEOkGBXw6T4v+neBtsKSnTCjpgGmVYcOc6cIGsSIfk15rJfRwahiL9oMaqBmhxI
         7TJmLVw246FuofVNtTqxlmI4QosQUNIzHGFg+06VJ9xcLVWnUk8BZjGBbjiM4B4+Kr
         YDl+oMgp1cjQA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021 at 12:27:19PM -0700, Alex Williamson wrote:
> This series intends to improve some long standing issues with mapping
> device memory through the vfio IOMMU interface (ie. P2P DMA mappings).
> Unlike mapping DMA to RAM, we can't pin device memory, nor is it
> always accessible.  We attempt to tackle this (predominantly the
> first issue in this iteration) by creating a registration and
> notification interface through vfio-core, between the IOMMU backend
> and the bus driver.  This allows us to do things like automatically
> remove a DMA mapping to device if it's closed by the user.  We also
> keep references to the device container such that it remains isolated
> while this mapping exists.
> 
> Unlike my previous attempt[1], this version works across containers.
> For example if a user has device1 with IOMMU context in container1
> and device2 in container2, a mapping of device2 memory into container1
> IOMMU context would be removed when device2 is released.
> 
> What I don't tackle here is when device memory is disabled, such as
> for a PCI device when the command register memory bit is cleared or
> while the device is in reset.  Ideally is seems like it might be
> nice to have IOMMU API interfaces that could remove r/w permissions
> from the IOTLB entry w/o removing it entirely, but I'm also unsure
> of the ultimate value in modifying the IOTLB entries at this point.
> 
> In the PCI example again, I'd expect a DMA to disabled or unavailable
> device memory to get an Unsupported Request response.  If we play
> with the IOTLB mapping, we might change this to an IOMMU fault for
> either page permissions or page not present, depending on how we
> choose to invalidate that entry.  However, it seems that a system that
> escalates an UR error to fatal, through things like firmware first
> handling, is just as likely to also make the IOMMU fault fatal.  Are
> there cases where we expect otherwise, and if not is there value to
> tracking device memory enable state to that extent in the IOMMU?
> 
> Jason, I'm also curious if this scratches your itch relative to your
> suggestion to solve this with dma-bufs, and if that's still your
> preference, I'd love an outline to accomplish this same with that
> method.

I will look at this more closely later, but given this is solving a
significant security problem and the patches now exist, I'm not
inclined to push too hard to do something different if this works OK.

That said, it is not great to see VFIO create its own little dmabuf
like thing inside itself, in particular if this was in core code we
could add a new vm_operations_struct member like:

   struct dmabuf (*getdma_buf)(struct vm_operations_struct *area);

And completely avoid a lot of the searching and fiddling with
ops. Maybe we can make this look closer to that ideal..

Jason
