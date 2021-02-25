Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65132555A
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 19:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhBYSUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 13:20:38 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14159 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhBYSU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 13:20:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6037ea440000>; Thu, 25 Feb 2021 10:19:48 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Feb
 2021 18:19:48 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 25 Feb 2021 18:19:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKNmxKRQd0SDm/PH+3hcBwoEh6Zt+FGXgOv94qWkqSViZRSGkWgJ0Qfqk5xopqTiKjMcavNd4CjrdX6OZNnrD5dcZ4+dEMQpDtl7xdBQd8OZsLCoavM6IhkYbLt7+d0/ROc/3akTuGw2ka/mit9sWnkWPYBwqXPBFTLZl5OK/GfkBYWHxYU+6XZWZuDzJxXS2cV5L5h/mJALpnnmhzBCkFhPy3OwYGRaKlkk3C3IqACWWM5btEKCqtc6tBXfOCk/EtZhvbXUru5F7bDyKZOSSc7WL/4Z7uMmZqpV6NFRPKwPqPlv1hNe94VBYkF0ZWiCCqQrAenw9wth5/WZgQw0Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kw6k5W19b2WUMuWfUHT7yBCBQx1aOPwjzT6MwRdeaZs=;
 b=jwDAv40AcPYHIeOnZKQ5jLF99+AGi8cEP+2HOpSGM8vrizpv5gznMmeAZnGoheVP5PF1+icOI0YjXSF4wMTgfkfYQq8OMk5Wyn/0Lvm8n90v/5prWUTzSi64RcLxUC0aQkXMlBM5suql/oLF3pTGWdLaHiDPq3t5S8qrxuWzCvziaklTPzmTcrvNxuxrN9kFzZBjBmcnblOKLrpna0Owz1u1/cEuxRPBAr7ViRirLI4U5s8LfSkQP9wM11D0V+zuNVi8K7VzQ9opo8yml1ocNydian+GeK+0oZ0d/ElrgzaBRNrni2L03AD4YbE6Fn2JJ5hYkPJn/cALaeWt1FDIKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (10.255.76.76) by
 DM6PR12MB4498.namprd12.prod.outlook.com (20.180.252.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.19; Thu, 25 Feb 2021 18:19:47 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Thu, 25 Feb 2021
 18:19:47 +0000
Date:   Thu, 25 Feb 2021 14:19:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210225181945.GT4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401275279.16443.6350471385325897377.stgit@gimli.home>
 <20210222175523.GQ4247@nvidia.com>
 <20210224145508.1f0edb06@omen.home.shazbot.org>
 <20210225002216.GQ4247@nvidia.com> <20210225175457.GD250483@xz-x1>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210225175457.GD250483@xz-x1>
X-ClientProxiedBy: MN2PR19CA0012.namprd19.prod.outlook.com
 (2603:10b6:208:178::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0012.namprd19.prod.outlook.com (2603:10b6:208:178::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 18:19:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lFLEn-000Bcs-2q; Thu, 25 Feb 2021 14:19:45 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614277188; bh=Kw6k5W19b2WUMuWfUHT7yBCBQx1aOPwjzT6MwRdeaZs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=SLoAfl8i9N05q7M2KzahlvVrg80/DvexHxGA+Oj1TX1foELF8v8cIGnfxMtcrrXgO
         XXqOeky7GF+k/JpjfuHHXy4fW5C7qDefLdrR6c6LaHlZIX9e1JPgSRzmUeoBEf2Q47
         6zfhwRjBixMLgI0gbtfsH+RboX9M9v3UUNEQpWRiYsWChh45q2hUjV+mdrrpMFV00m
         r12aP9OKCgBkf8hr2YiJpfTDuznmr5+F1+rBEIj3Sy4UsdfwNFL1aan2DpZxvYIMB3
         eUwmMeB3tJC3UTnHuPNn+Ie7SLc4vKrOSaM4H11sAnPSQNEqlryubRRrERuaF0ayEO
         RvHTO0nBeN9pA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021 at 12:54:57PM -0500, Peter Xu wrote:
 
> I can't say I fully understand the whole rational behind 5cbf3264bc71, but that
> commit still sounds reasonable to me, since I don't see why VFIO cannot do
> VFIO_IOMMU_MAP_DMA upon another memory range that's neither anonymous memory
> nor vfio mapped MMIO range.

It is not so much it can't, more that it doesn't and doesn't need to.

> In those cases, vm_pgoff namespace defined by vfio may not be true
> anymore, iiuc.

Since this series is proposing linking the VMA to an address_space all
the vm_pgoffs must be in the same namespace

> Or does it mean that we don't want to allow VFIO dma to those unknown memory
> backends, for some reason?

Correct. VFIO can map into the IOMMU PFNs it can get a reference
to. pin_user_pages() works for the majority, special VFIO VMAs cover
the rest, and everthing else must be blocked for security.

Jason
