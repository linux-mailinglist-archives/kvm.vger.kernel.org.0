Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C63E325692
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 20:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbhBYTUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 14:20:25 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2245 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbhBYTSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 14:18:08 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6037f7bf0000>; Thu, 25 Feb 2021 11:17:19 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 19:17:18 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.53) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Feb 2021 19:17:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZIWAIIT48zkw0bjx+axI+2iLp48A0L+Yf2v1r5thC64AxYHAvsUz9acLlMXJ0XSIj4jPVRctHdb969VCDjPmy9Yom7ZpzTO6PiNjGwMsbMH/S0kdLXcHxMHmnyd8Yujxq8ttDIql0K4Gu0F6Kev2dvvyEjy3iJy6bIYtXhcryHZPEPw4Ivj6FG09BLxIBMe9ir1si6L7PtWgSIXbFBeghDrKYgZCIE4NyhH827wHezT7ZR2klWtXSOA74V/nyChoHV4f7yhLVpuDhJ43ZpYzCmEhgs4Lbjw431/KxTG/4fDuPTxINaryz9/KLckQ0ZZHCc8XvJO3ePOL8jRyTB0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqDpi636jhSWWxboEzhNsvod/t/IqTxlCQxbEALiQWU=;
 b=fBJiyxpLkGK3BDXp2KTx2uasyXm+xgfNqNbrRMEus7G46fXohkhw3mamf4JlEkdfX8a3Eq3X2FDIPMwEl7LLznqGzcHBcKDGytRLxAEJZWRywf3MHx0ctHtFpbU1kw1yGG7yZNIMkFFXW5kts/feS72GhkjGlpry35fmesmvJSH/xQXm/r8GoVhLlUURHl8+JkDgRWqP2EO1jgeQkDw5i4QPmjv7yaRiBp9R2jtZQqc/5FA+zLhaBKlkOIu6G1bPj/Mdll4QJSn7V2UHWDkxREPCIVmb0aolgw20IxgroSp/wlZkLklUegs9duGYqpjvkkozeBYx2HzZ2GgMy1CWag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1339.namprd12.prod.outlook.com (2603:10b6:3:70::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Thu, 25 Feb
 2021 19:17:17 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 19:17:16 +0000
Date:   Thu, 25 Feb 2021 15:17:14 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210225191714.GU4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
 <20210222175523.GQ4247@nvidia.com>
 <20210224145508.1f0edb06@omen.home.shazbot.org>
 <20210225002216.GQ4247@nvidia.com> <20210225175457.GD250483@xz-x1>
 <20210225181945.GT4247@nvidia.com> <20210225190646.GE250483@xz-x1>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210225190646.GE250483@xz-x1>
X-ClientProxiedBy: MN2PR10CA0036.namprd10.prod.outlook.com
 (2603:10b6:208:120::49) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR10CA0036.namprd10.prod.outlook.com (2603:10b6:208:120::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 19:17:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lFM8Q-000Ipw-FX; Thu, 25 Feb 2021 15:17:14 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614280639; bh=HqDpi636jhSWWxboEzhNsvod/t/IqTxlCQxbEALiQWU=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=UVhcvKIl9oy5OU5yUR8MORkien/tD2qgmrTm1+2yE25PFdpjde5GVKmkJPHu8WXv4
         lZ6f+WDdrhqCEwde2D5g61U+fPnHqBBXVGzCUEWPR372P0dpUzZhb50WnWm/8n5ZYc
         dChA3Oii4ZFVKfzJHLVJYJSJn4btNegDNAUw0+YtBWnTLtjL7x2Rka9Nil5kNhTj0U
         QeKW1dNKaD6bs6RUBpMEDj9E4cyQ/Sz+Qot4N850wloItVgl4OmY0oyoUbfIDZpbRb
         Ep4IAe65JrIdqEmTDXX4i/+q0fdAFNo2nYNfD4MzKSe8iEEWw7TyeuVAcrLCxttXdr
         jW2r9b+mfs1pg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 02:06:46PM -0500, Peter Xu wrote:

> Agreed.  I saw discussions around on redefining the vm_pgoff namespace, I can't
> say I followed that closely either, but yes it definitely makes sense to always
> use an unified namespace.  Maybe we should even comment it somewhere on how
> vm_pgoff is encoded?

Yes, it should be described, it is subtle
 
> > Correct. VFIO can map into the IOMMU PFNs it can get a reference
> > to. pin_user_pages() works for the majority, special VFIO VMAs cover
> > the rest, and everthing else must be blocked for security.
> 
> If we all agree that the current follow_pfn() should only apply to vfio
> internal vmas, 

I want to remvoe follow_pfn(). Internal VMAs can deduce the PFN from
the vm_pgoff, they don't need to do follow.

> then it seems we can drop it indeed, as long as the crash reported
> in 5cbf3264b would fail gracefully at e.g. VFIO_IOMMU_MAP_DMA rather
> than triggering a kernel warning somehow.

Yes, this will just fail the ioctl because pin_user_pages() failed and
the VMA was not VFIO.

> However I'm still confused on why it's more secure - the current process to do
> VFIO_IOMMU_MAP_DMA should at least has proper permission for everything to be
> setup, including the special vma, right?  Say, if the process can write to
> those memories, then shouldn't we also allow it to grant this write permission
> to other devices too?

It is a use-after-free. Once the PFN is programmed into the IOMMU it
becomes completely divorced from the VMA. Remember there is no
pin_user_page here, so the PFN has no reference count.

If the owner of the VMA decided to zap it or otherwise then the IOMMU
access keeps going - but now the owner thinks the PFN is free'd and
nobody is referencing it. Goes bad.

Jason
