Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE4732F678
	for <lists+kvm@lfdr.de>; Sat,  6 Mar 2021 00:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbhCEXL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 18:11:59 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3403 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhCEXLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 18:11:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6042bab20000>; Fri, 05 Mar 2021 15:11:47 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Mar
 2021 23:11:46 +0000
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 5 Mar 2021 23:11:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJikfieUHkRS7SeDrBpc0JqGbg8lIdO2iQ+G1f/1S+DMJ9BoeWbYoZr/M+z7Kdnp1/MzZ6PsyTlgDDQVmOWAlW9TEtbd2lVs7YGGnkWqlgVMoV4Mdn8jDLss0MJzsZIyynS8hGVVcp4xZlmLYVy27Yw35H3VLVHfdrbUVa9bwR4T70dtGZOnIns5RELqrAaQxN3V+3AueoDJv1BNQws4r/5x6LOsP79zBEXeNR6IAcxHig4XcISIENhXnCwz4OC/z5Mw9l67/Glj8PLbaeZOQnzYMXA6O2wMAuU23k9F4PNE8U9ucSAPYsmOMCRsXV1BYLA70I2JgMmy+g366tYzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yX3YgrMQtxd9+VHPZ2vy13nfv9u2ccn6OU9ppZN9Q7g=;
 b=OQcwnqvSclbzDbWWLz4U9lSKfLwAlO3FvE6DAVqGmkt4qsJ39b68AlUnuXxhZGN3/T7uNYNzlDhgpxzLKufUrypcCA0xhbV3cDrkFlCf31S2L0mMjbE0heW+OHlMkeYOkMc6TLzfGuD4sIEsGam5HkkOuiX+q1NFMfUrssJmVwXqucjxCqGCsEfOsuOVN40DtcoHCakhgsO1YnSNoeEyDSwo8yt7v1fbm0CkroRjb0R88ehx90dhAk/rbI1UTFx+ShutOiBkaKaWy9NDNpdKXRc4JMRb1wuWQMinXi2D+XuT7W8nqhqTj6dbShuB1U76iLoXQMpxq3tH+kvDJpLtMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yX3YgrMQtxd9+VHPZ2vy13nfv9u2ccn6OU9ppZN9Q7g=;
 b=SI6K/1Ib4seBnR/YZR6LAxDbgRADRhDzv8TnW7QtO7A7SxIxlf2kgFA3QBtiE4Xi3zrzDnu2RaLI8+0wI1Pt3x4GNokQ8YsZK8W8SiZkfJp9CNJ9Qw50w5YfvvgjUFLh++VXE7rPFTOwlCox0OAjIaj+9UJCkUKlJkcY41b8KOM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4137.namprd12.prod.outlook.com (2603:10b6:5:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Fri, 5 Mar
 2021 23:11:44 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.024; Fri, 5 Mar 2021
 23:11:43 +0000
Date:   Fri, 5 Mar 2021 19:11:41 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: Depend on MMU
Message-ID: <20210305231141.GS4247@nvidia.com>
References: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
 <20210305094649.25991311.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305094649.25991311.cohuck@redhat.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR1501CA0013.namprd15.prod.outlook.com
 (2603:10b6:207:17::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR1501CA0013.namprd15.prod.outlook.com (2603:10b6:207:17::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 5 Mar 2021 23:11:43 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lIJbh-0089Kj-Dq; Fri, 05 Mar 2021 19:11:41 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d789472-00c7-4aa5-217a-08d8e02c0a8d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4137:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4137C9F74DDAEF7ACFA37774C2969@DM6PR12MB4137.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7JdYnDDIIab5H+tV3R8m5vXjbmN5v2GvOIXTE7godFm9Q2JvuCAAhFNeoB5DKROTYsZDQfRgmjHfLVPxmRCrk/2j51vMCH8kF+Ql6YIvS6sJGURA5lhBvm2MKjVcybORq/ZfBnd1asFysChZo9kZGcz3lssYXs1QTg40YawkQ5W0oT1jbroZ7yyj65orufXSY2hpQeveP3HBiaxqAgkusuRSSm54i39Osmlme0SVIy6OhWVUHmXujhvARFn46/uVp2jZ5zOR9y2Uf0I4sXjDaMN74J/CLPABIrRCkaZ3nmy16XBhUeDC1lw74QnrC+bzHLcjtl+czkFJy9z/9EN+CBZd6pU7cNWY966L50mbkID07zLAPLMiZxPjd7B7L2swFqbEN+Q11vSn5z1rfB93Z/MFwevzwdtvD1cdJxx8ANUFLPvdJjQk7Mp132FiWJDoSHsvMj7sCNewwFBfxv95fRMAPdHp2H9nBIDDp5Z4sGv23oar8tGh96A5z8R7lN+cPBfdnbnnyvMSmmWsJHR+GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(66946007)(86362001)(4326008)(5660300002)(1076003)(33656002)(66556008)(66476007)(83380400001)(478600001)(186003)(36756003)(26005)(2906002)(426003)(2616005)(9746002)(6916009)(316002)(9786002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?l79vCEMMb5r4MgVXw6NQdyY/hmZQy5uHbxlY4Sx4rMTZ1u9jnru4XPffoTZY?=
 =?us-ascii?Q?AzvNM+6/fUMIDl4SnUKzY/6WsX85g2OgPKXJb8vigqlWX/JxRv6+m3Txl2IF?=
 =?us-ascii?Q?ZcRM/FuNn+cVVmJTMPFq188mvlPJMsiXFEXVSanOv1jZi1vOr7mQL/Iiw7fe?=
 =?us-ascii?Q?YOZZRgYGfwNoVMRZJzTiTCl+qfpY+600gjt73YyZMov+ObrILK4FsfK/c4pk?=
 =?us-ascii?Q?+R9sQUPYwRlK0bx7AQ9QqeRHs046GE4ns2XTaa/Q4qBVBmrWTBYXp3up6RBA?=
 =?us-ascii?Q?u/BLAcd4nDf7iQ9ByVYcWlMwFU3rkTiIx/Ptmbmz+bE4ZTfJkJOpot3lV1jO?=
 =?us-ascii?Q?6ft9mTDHfexUuQQytnHNWZgFEHJmqmmT1dJ2j+z5m2G+gE5pjfz8Sr4Hn1LJ?=
 =?us-ascii?Q?w4ImZd3PkhPpWph+bw3wZWYBLdldBgaJJeLXwukA+5f1HJ1jMaHnZcVjB/mI?=
 =?us-ascii?Q?h6XSoNZbVX6q9I+v5pfgasF7CoQR51X0m1jFlDs6cyvktyCt6i6xA1EPrOMf?=
 =?us-ascii?Q?CBa1Uae4JWU1trdYhFPUBK8j2UDdbst4KMKlUS70CMuCCiYuGrQzEwFC7mVp?=
 =?us-ascii?Q?mKocts1NhMlkY+H/vpyD/AC7UXjXyXaTZxu0kOHQF+j9jl/TCzRCY4nPgUM7?=
 =?us-ascii?Q?shspiNAECRUVvPHy7B+5PPWTdANUJQ9fH3UaGY+c6wxOsDkUg1u4gBbMrspP?=
 =?us-ascii?Q?m5tijNLG7qaufd5+TTtD4Dthc2WbYw0mes4hVa+r/g/fx8hAC01vcOfBKRzS?=
 =?us-ascii?Q?3QwUm/ovpigdOIvFKQe/l336oUrK2kl0RlXDQoKYSwLxCy5yvhYBxpCUNRLr?=
 =?us-ascii?Q?7NFuTAYmqiTPgjkLg3jIZNg5woQGdXv6+pcJAeGXhjPt4ERGP+F+KrVB/fzV?=
 =?us-ascii?Q?tz2maoyy8xmNDri6cPzDOEgWX/kfNspbRuKP0Nat19RBVuEoqaKHMtW0Ebl5?=
 =?us-ascii?Q?UPGzdISL8+aQCg8lNHAMzdJN/+BQMWmNURh4I7nOg4y+18HJW8zm2d/yNMey?=
 =?us-ascii?Q?eUJbWH4ObsIAJ6KNovxByFZv5/cPT8ICJnh30XwKzW4+cKqewr/fvpavzx/A?=
 =?us-ascii?Q?4u56CVbGeNCnBAKH5K/GuP+XXDmsoQ+J/dlf0Hiuddkqs5lUVr5SsVr+jwQt?=
 =?us-ascii?Q?giMsOjIAp/vtWgQrCz2qaIeRUNfbSCBOoPs7fRgJXeY7epmG+EMTsEISte19?=
 =?us-ascii?Q?XcU+8B8HgBUcuCGmEq//nlI+zQYLBAJoiH12fDNfvgGN66tiqB9g3m//Txbv?=
 =?us-ascii?Q?f7APk50MpHMTKDs8YfcMnkk3t/e3WobXf90EPJNA0edEzZB7Dj9T/dDqjAvT?=
 =?us-ascii?Q?JXGT0tW2q7kLl4//olWjO+4r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d789472-00c7-4aa5-217a-08d8e02c0a8d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2021 23:11:43.7247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUt0bfb93Stqw6rSf8CHUzquCtawXha/Qoii+Wjh1BQpKE2RK2jAg/jajDtRkHbT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4137
X-OriginatorOrg: Nvidia.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 05, 2021 at 09:46:49AM +0100, Cornelia Huck wrote:
> On Thu, 4 Mar 2021 21:30:03 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > VFIO_IOMMU_TYPE1 does not compile with !MMU:
> > 
> > ../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
> > ../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
> > 
> > So require it.
> > 
> > Suggested-by: Cornelia Huck <cohuck@redhat.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 90c0525b1e0cf4..67d0bf4efa1606 100644
> > +++ b/drivers/vfio/Kconfig
> > @@ -22,7 +22,7 @@ config VFIO_VIRQFD
> >  menuconfig VFIO
> >  	tristate "VFIO Non-Privileged userspace driver framework"
> >  	select IOMMU_API
> > -	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> > +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> >  	  See Documentation/driver-api/vfio.rst for more details.
> 
> Actually, I'm wondering how much sense vfio makes on !MMU at all? (And
> maybe just merge this with your patch that switches IOMMU_API from a
> depend to a select, because that is the change that makes the MMU
> dependency required?)

Why does changing depend to select affect MMU vs !MMU? Am I missing
something?

It looks like IOMMU_API can be turned with ARM !MMU here, for
instance:

config MSM_IOMMU
        bool "MSM IOMMU Support"
        depends on ARM
        depends on ARCH_MSM8X60 || ARCH_MSM8960 || COMPILE_TEST
        select IOMMU_API

Generally with !MMU I try to ignore it as much as possible unless
things don't compile, as I have no idea what people use it for :)

Jason
