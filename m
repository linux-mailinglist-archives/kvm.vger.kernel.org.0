Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0175A32C60C
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343610AbhCDA1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16667 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbhCCMyp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 07:54:45 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603f86eb0001>; Wed, 03 Mar 2021 04:54:03 -0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 12:54:01 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 3 Mar
 2021 12:52:21 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 3 Mar 2021 12:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJSdnYGph1d27X6byaAhATRUksNlJ7+kcnOcY7K1Ljx4uztAGTvE31SQSIv6t7LUqSGC9PN0nKHZr3IS4wcHpdXoy+KNvKn+sJAQ6EF1xhfwxiD8l605Z57Y9cSirlfzqmOsq93DPFjC41GGB7USUvE0WuGrrSLN7G34EHP6nbqfqv6l4pZTeGJjLsMbQYf2uOYYYlxWtVbUH2CzKuBL/BxetX23H52Pw+uxylgHzGO324HYKG+U80L3YSd+Im51EPPu+audWdzW1OZefBDTkYq7ViVgQFtR61Gk8xeE6TVVNSyp7hdjiAmUgwFIflHi9blfoJUwL+F7/wO8hCEAxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EZlNEHfWFMmFMzYVR0TL0LsECrg7yu/F5/kxtLO3fYM=;
 b=FHT/wwqTUGRd/Gay9Ohh8eRtr+WX22H3j+3ja9mcsLAl50nssvBgVhgbJFI5xnxtdJY4l4DbE3agYNWLiFEjORP+CxOMahP3+b9islxntmxYWFuAP8NOt4b4p7xOkpeQhLmwsxjE0HNtRHLCAcWPbo5Qx538YaezV3a/0GVeTUjivGJeDYGzQqY1t9P02x4HionqLgmVm1aM71ds6tUouBKs5UE+T35vhorqW24f8hveYW2NbNzeP4z1+1SlCtWE1PTjzuZuoCNEG6uAki5QnwS9F9vTtGUtb+WXbuscpPcz2iUg7fl4cHMua+JucloeQRrnfKmCR5Uv4gstiuS6nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 3 Mar
 2021 12:52:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 12:52:18 +0000
Date:   Wed, 3 Mar 2021 08:52:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/3] vfio: IOMMU_API should be selected
Message-ID: <20210303125217.GO4247@nvidia.com>
References: <0-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
 <1-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
 <20210303133626.3598b41b.cohuck@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210303133626.3598b41b.cohuck@redhat.com>
X-ClientProxiedBy: BL1PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0239.namprd13.prod.outlook.com (2603:10b6:208:2bf::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Wed, 3 Mar 2021 12:52:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lHQzB-005xYL-65; Wed, 03 Mar 2021 08:52:17 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614776043; bh=EZlNEHfWFMmFMzYVR0TL0LsECrg7yu/F5/kxtLO3fYM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=LoWGLl/NSKA86z0Ve1scLIqXMT6NbzAC7MLaa4DGb9SyW4T/Yb8uMqkr0lL2zYLjj
         zsvaDRgfR7OQGcotk3x+YqseqwK1K72yKHsFjQpMlMmfHiXv3ByHqXVKgXq2RCO9k8
         MAMgp7JVhfsed9m7ruRPZz4a6A3xpnKpUHFNQbHZSkpaVMQ+EzTS6MaUVKG4tSpsGK
         8sOgO5+ZS9/aOAzFUjaqzy2Q0fJTMW2shrPeZEfcyNcztETTZrwjodoGpDyDWx1Fvg
         5snv/ldrptJVemRr2qesCA7uGg4wJQqJrtKDI+WLP1jUdBbkTvIUs/QdjsDux80bU2
         inPRcsovunE1w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021 at 01:36:26PM +0100, Cornelia Huck wrote:
> On Tue, 23 Feb 2021 15:17:46 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > As IOMMU_API is a kconfig without a description (eg does not show in the
> > menu) the correct operator is select not 'depends on'. Using 'depends on'
> > for this kind of symbol means VFIO is not selectable unless some other
> > random kconfig has already enabled IOMMU_API for it.
> > 
> > Fixes: cba3345cc494 ("vfio: VFIO core")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 5533df91b257d6..90c0525b1e0cf4 100644
> > +++ b/drivers/vfio/Kconfig
> > @@ -21,7 +21,7 @@ config VFIO_VIRQFD
> >  
> >  menuconfig VFIO
> >  	tristate "VFIO Non-Privileged userspace driver framework"
> > -	depends on IOMMU_API
> > +	select IOMMU_API
> >  	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> 
> I'm wondering whether this should depend on MMU?

Hum. My ARM cross compiler says it won't compile:

../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
  if (write_fault && !pte_write(*ptep))
                      ^~~~~~~~~
                      vfs_write
../drivers/vfio/vfio_iommu_type1.c:539:10: error: implicit declaration of function 'pte_pfn'; did you mean 'put_pfn'? [-Werror=implicit-function-declaration]
   *pfn = pte_pfn(*ptep);
          ^~~~~~~
          put_pfn
In file included from ../include/linux/highmem.h:8,
                 from ../drivers/vfio/vfio_iommu_type1.c:27:
../include/linux/mm.h:2200:2: error: implicit declaration of function 'pte_unmap'; did you mean 'memunmap'? [-Werror=implicit-function-declaration]
  pte_unmap(pte);     \
  ^~~~~~~~~
../drivers/vfio/vfio_iommu_type1.c:541:2: note: in expansion of macro 'pte_unmap_unlock'
  pte_unmap_unlock(ptep, ptl);
  ^~~~~~~~~~~~~~~~

So, yes, it does.

Interesting that a compile bot hasn't reported this before.

-       select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
+       select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)

Is enough to make !MMU ARM compile.

I'll send an additonal patch

Jason
