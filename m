Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18FF3315DC
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 19:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCHSXf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 13:23:35 -0500
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:26291
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230480AbhCHSXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 13:23:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qfm5VggIYixedJpwU9NitWYS813Sl2UtidWxgoGeUDr1uwNa0dq1YNP24+DJX6MOcN0fbvye6wMlCZTXzD0z3j+rEzIyItQkF6oDq7Jtn0G2Vaq4vzMEyoXl/MGWzTkYH8vsquaxSOmdWfh/WT8KUoJcgLwkrp93wc6RLNiPBlG93Ia5xYyI5LJFkLiJnjp+p7Y65G0jVWMb+fJp+gWnQz4INgGzk6b/IAjIkhOYVRGQCF3GdWCt4bQJWC5qqNFz2AtnF7gGTDsvL4P0k+wHEeUCWsILedRVBMq7eHD4Q9c5wje/nZ9ffbgkZf8cFU70Pxf/Iu0pWelWk+ToOYpLwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7zGzwnwGi7S+Arrn3zGSuZH21CHEcwcqIpVhUci63k=;
 b=ZpfplZsMqJ7mb0a0wnS7ZMhtfq7lJ+Y7HZVGsAIGBHDowWYGs2AmI+JB0oCUWrl/UyzzX2YsJqJz1KX6WuH0fe0eVW2RfTd0/pt3xYozXaMkrveSqajHRA5rLvvGUJdmsgEaKkcVprgVdqg8tiKjxNuvODyEFDh+vgBpkHRu+V3I20Yyw5Dzqf8DaN4679p9VIMkt+Tz0fGwbAYVgSjWKxWt/ftinTqcCj1XVi4UV6bHvPIklMYlMHjMXp6S+KuvIJrcu/62R8/MYgjWyCQ/D0JT7mruHknKRpC9bs6Tiq8QdC8khvWdZ/Q3K8ILwf+aqfJzjdAYnHbFbJbduZuOEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7zGzwnwGi7S+Arrn3zGSuZH21CHEcwcqIpVhUci63k=;
 b=nSsV7HxKz5GJv06hXe6HOLTsa96GylCuZQsaCQrKFD+ypcxhQuNGZaX7BwrDDcX+AUdht+P8UWOz89UGRZt+Hz5cNn99T3biNeMF4No4PfaBOBfu3UzbjeeEINKd5MKxYPvqSUwa4LNgGdULmdf45kLxTLi1OkucpqOjHf+x0Fs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3929.namprd12.prod.outlook.com (2603:10b6:5:148::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Mon, 8 Mar
 2021 18:23:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 18:23:14 +0000
Date:   Mon, 8 Mar 2021 14:23:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: Depend on MMU
Message-ID: <20210308182313.GA4247@nvidia.com>
References: <0-v1-02cb5500df6e+78-vfio_no_mmu_jgg@nvidia.com>
 <20210305094649.25991311.cohuck@redhat.com>
 <20210305231141.GS4247@nvidia.com>
 <20210308191421.7f823b28.cohuck@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308191421.7f823b28.cohuck@redhat.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:208:32a::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0105.namprd03.prod.outlook.com (2603:10b6:208:32a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 18:23:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJKXB-009Yr9-2Q; Mon, 08 Mar 2021 14:23:13 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f43e259a-d1cc-4370-9802-08d8e25f3cc5
X-MS-TrafficTypeDiagnostic: DM6PR12MB3929:
X-Microsoft-Antispam-PRVS: <DM6PR12MB392959D3AFFA436025A3C109C2939@DM6PR12MB3929.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BDDLDJVhh/xK3X1V6imAZnHw+CzSQvbRxshIHIvFfTUflwEp33U3S7HyD6U6tJnVBASkIz7YXRvzcZZsFtDsBCZm5JLq/gXK2+IwUvYeOSjaKaf0DvAgcRsd5gSc2BMNP3vkXPiiuth+qZuiScJ4nM1U45rNkE48Evvp0McstiNGIhddFcuErwUmelUKrMp6Sgj6SD18jEZwkKJLgp7HXm8Fzln2oJmK03TsincgwBZbgNJ9i0gqB6ZTVecFfa8zBsbkag9OZDtFEHcXY00SItGYPrcZJpAye+CcXidNTlIvsA+6jS8Wf1vd4rLGk57ZmX3bpuDwNjR++SQNFAwsnXsetguG976eg/N2HgG5K1YxGrkKsfeaWxBhUAdU1SI85uXGA2BDkqX4utAr0cWRIodI4Pfql4sqrtObyHuG2rgc5lqGhMfn/AXzS9aQGL+1/9X9qS26XTac1Xx66VHoMNjmWNICXWH5oxvdIwYCPHiIZQJUiH1Suj+YFY86ySmsVLIHYeMrEQGHiy1uM/l1OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(83380400001)(8936002)(5660300002)(186003)(6916009)(26005)(33656002)(86362001)(2906002)(9786002)(36756003)(9746002)(2616005)(426003)(4326008)(8676002)(66476007)(66556008)(66946007)(316002)(478600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?56N36Zbr23T13/Fz6ODofkOp9i8tFU+SyWCQVD2xbdQclLGNyNxsXAYdzhdW?=
 =?us-ascii?Q?KySX4lZ1HLAtaUFb58k35tmeUSeK1ibP/AaQrvU3O7LQwR/LGgk+4vo5kFNP?=
 =?us-ascii?Q?yVa8/XLwolsDKSAeu/6rYM5PYXMPMHnO1IpmqsJelOFxm4pfVcF3ndHPldsC?=
 =?us-ascii?Q?by12qjewqusmpgHv5Z3Fv/1YQd3q8EDgTInDtYPkhMxtsAcpkrNz3Py4F4Hi?=
 =?us-ascii?Q?dy68W1WFxc/3DHqqzWHWUoeIUQ+UaTKBrlm2/ESFrx2Wrz+YCY7b4decVpqO?=
 =?us-ascii?Q?suFKnozs5okojgFMfX7EOWGtVOHTG5BwmOp9sTnH4oaa4yks3xzVdE4H2CDd?=
 =?us-ascii?Q?BNhfbF2VUiRQ40OWCw497vrDZcDvYCCTCcA+FmFp/fzQwlic7qFCODROaQDA?=
 =?us-ascii?Q?X47dGZbKU9uc2/vDu3f/qF2D+21UAHr4eAVvRh/EYOoRnl2OfrCjQ5OXQRUY?=
 =?us-ascii?Q?gzFMNpgUz8j3cPJWIYVxMcfd8nFGruYsd1Ptod+seA/Kf03iysw9YdLeEJ9Z?=
 =?us-ascii?Q?RwDSSqurCK10cD9dR1icSj9VVvMoenVpoStW6UEsUz4/BY7fK1aRZcG08ptr?=
 =?us-ascii?Q?1mAy/T10E/YPBj3QMIPogwE4LvdDqpVltWW47/6PXsm14fbLY3j1cGHtLjPE?=
 =?us-ascii?Q?3N2n+l3gdvd5Xr389uBlvgMLL0+I/2cRc/3/mfCAzh/N9M5vr6yJ18eUAxxP?=
 =?us-ascii?Q?YLsvRYxljeUTE1Y/bMEYCq7KQUPoWzUhCIGJC9KqZSscphOS/8gLNub1Uap5?=
 =?us-ascii?Q?k6SpjHAYG4B6/qYNiC3vlXwRzpmjoxJYew3ywdLIPg/QICrBecFXEUjr48pa?=
 =?us-ascii?Q?MufxK5kttKdFpvX3LGk6TMxDEswbFk/Vhd519R4FUBDUaDlK1AviVCZWLewq?=
 =?us-ascii?Q?gUQpWpYNhbfHtrSHaUfgXBapjL+qLqZwU74Fb/oLISn8Zlnu60HcNalarlFA?=
 =?us-ascii?Q?HHflax7/pxqlIpMEwKxAW/CvQc42bR+7I4PvJV6svnoZooc9YQUn2OTkp5RV?=
 =?us-ascii?Q?uaOxngXM4gvaKdsSaoDdQf91DrWHjUJGAfHCt8XJvu1fLmNSiJBdF1RtuOeE?=
 =?us-ascii?Q?SreviEDL+vRTa0Kbrm3QXF9J5sowBRHzAbnXGTrn11XBewwdLrgREibQahpQ?=
 =?us-ascii?Q?aIIiObtj/LGLwFbaN+3NXHfVjN61M9SVLU2KvgWFjfDUldCP/cztsHUCOAqx?=
 =?us-ascii?Q?lFkYgk7+8Km7+v2jg/pLPJeDz3vwEkujKBiuFlx4EMahbXiZkLD0C55PVYz2?=
 =?us-ascii?Q?NhWmXog3JVeZi++OH8CT+uglJriqlqg+nUmTSO0ZnJOPhKkTKcqL9vGdkXB3?=
 =?us-ascii?Q?p3hc7aeeAfly7mEGbSDAf4EeDG5GO2IFne/ix+Zj9bu7pQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43e259a-d1cc-4370-9802-08d8e25f3cc5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 18:23:14.3737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XArGFgnuzU+bvMvd2JdorLPPuyhtk5hupQPxsYzkJHMUAw7+YS/lQxvVO5mh/oDx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3929
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 07:14:21PM +0100, Cornelia Huck wrote:
> On Fri, 5 Mar 2021 19:11:41 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Mar 05, 2021 at 09:46:49AM +0100, Cornelia Huck wrote:
> > > On Thu, 4 Mar 2021 21:30:03 -0400
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > VFIO_IOMMU_TYPE1 does not compile with !MMU:
> > > > 
> > > > ../drivers/vfio/vfio_iommu_type1.c: In function 'follow_fault_pfn':
> > > > ../drivers/vfio/vfio_iommu_type1.c:536:22: error: implicit declaration of function 'pte_write'; did you mean 'vfs_write'? [-Werror=implicit-function-declaration]
> > > > 
> > > > So require it.
> > > > 
> > > > Suggested-by: Cornelia Huck <cohuck@redhat.com>
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > >  drivers/vfio/Kconfig | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > > > index 90c0525b1e0cf4..67d0bf4efa1606 100644
> > > > +++ b/drivers/vfio/Kconfig
> > > > @@ -22,7 +22,7 @@ config VFIO_VIRQFD
> > > >  menuconfig VFIO
> > > >  	tristate "VFIO Non-Privileged userspace driver framework"
> > > >  	select IOMMU_API
> > > > -	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> > > > +	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
> > > >  	help
> > > >  	  VFIO provides a framework for secure userspace device drivers.
> > > >  	  See Documentation/driver-api/vfio.rst for more details.  
> > > 
> > > Actually, I'm wondering how much sense vfio makes on !MMU at all? (And
> > > maybe just merge this with your patch that switches IOMMU_API from a
> > > depend to a select, because that is the change that makes the MMU
> > > dependency required?)  
> > 
> > Why does changing depend to select affect MMU vs !MMU? Am I missing
> > something?
> > 
> > It looks like IOMMU_API can be turned with ARM !MMU here, for
> > instance:
> > 
> > config MSM_IOMMU
> >         bool "MSM IOMMU Support"
> >         depends on ARM
> >         depends on ARCH_MSM8X60 || ARCH_MSM8960 || COMPILE_TEST
> >         select IOMMU_API
> 
> But that one is sitting under a menu depending on MMU, isn't it?

Yep.

Still, I'd keep the two ideas as two patches - order this one first.

Jason
