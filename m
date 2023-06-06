Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DC27245D8
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 16:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbjFFOZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 10:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbjFFOZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 10:25:39 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B299C10F1
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 07:25:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EB0YkI+bn4Dm6neN1TBYYNajiWOSMdPzDsLL6GGMXbjaZiLcsb3u1ye6RYtmuYiYTTWCR2o+dHkVNi1r82PkBveog4UFSeuKMamgy3qgo1KYvxC1cWU5U251kVbBv2TeTpuAp+bWZZ3IWezFMIfLZH5Hc0V8ruUjfbBb1MzAGiYi38SB8kLRd5deofxmBLhbXvn5NhkytCKd8P7IZjvUjJLWGKC9kXuVn0Cqirx1ti0pGWjrHHgpYHYI/s3QDDA8pNhqBXUiuRJd5teJtwIYdT+oTiTXhpLZv3nHK8yyTCnFvkwt06tuP11atILlPcI38u78gtlGLmrBrsZjINDd4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Y+b3IP6V0iCUZv0kzB0m/dgobCS6jBNwHyMgIgacqE=;
 b=jqZ7KQPajt5KSiufmZdbxzdJxAmQ1cbi2jrrHio6Z/hNjdaw1269y32iol48K7YO9udFYptFM2J1rH1sjlMcOG8i41GlAO2x8+7KG5S0/ExOSCRQ2oCGLF3iwCypfyvN0naclDYouKhcU/6Kpeya43TtcpjBb78njKjeP8hQV2zaThMzbG08HgHDvV9sSE30FJpNfCCxbcvnP96QIXcTAHl7YGpHypNaUv9lixS9kNL1J7UbRx8vf4zpMAT2xSjYOjp0SL3qNZnfEz3Kwwcbydc9ql1CyvsibB9J6P17QRubN7WZpUQH4Bgk3GPEnBciwMVjW89TsQl0EqmzOOgRcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Y+b3IP6V0iCUZv0kzB0m/dgobCS6jBNwHyMgIgacqE=;
 b=VGK0YhgxPUytgy/ItNjrqSML6GENaoIFy9buRQRCLb7PuD8mcmXxlVxxR1auydPaQC85wzfokymFx+5VCRmyOR/BzKjNMxRYJTZGW+1Mz+3jc5K6EYjf5EbSCrZVsbaTJ6jJp3QUE5p62b0V8Ibrxl6mZ3C+voSmq9SE9CBCdGeIztTEoZ2RThGlV68pRYaB27IylKbY6YL0Zm06ksxXkzAhM4tVa8yxJSw8bDTSXXCUNuVl8zBdgT2tUL7aHvQB/bD02koberSDnQq9T1uFSp9kQ7iyBEVuM31hgbEv96CDWqeYlyGAIT0+Ddd5yB2eXARDy4xskCSW6bya3K2fkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6213.namprd12.prod.outlook.com (2603:10b6:8:97::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 14:25:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 14:25:03 +0000
Date:   Tue, 6 Jun 2023 11:25:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Message-ID: <ZH9BvcgHvX7HFBAa@nvidia.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-2-alex.williamson@redhat.com>
 <ZH4U6ElPSC3wIp1E@nvidia.com>
 <20230605132518.2d536373.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605132518.2d536373.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:610:e6::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: a7f3a472-1810-4214-a3ad-08db6699d161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Aw1DICHNTZFioGk3DjMeDcT1kCBvl0EeTnwyBXKSPuNR4dbxPdE4zzAWTtmNcCACCQimNLr/rREpKNOCjbHLSq4fVYj2vQapmrXCdBMHcYSTPWj4SbSbIpdD6SM7KwRFlmbSzxJmd2WI0dLrw9S8LddQInNZFuWVeS13ouCq88+uKKdM/Aq4pqeEahigDLxxhLfBIFs81YUAOOjy1aQLYVa3/gFSNXjtLXmqN1DHO8oQO5AldoyfxV4q1SPkcuR9ITk3GXrQ6EwjU02VWEKsDL8LwS0ByzLRY9PIiuElfZ7gCf9z8g7IHg5XmAj2E39DJh3WZTDMUeGp7fJfrHASJgabpssIV0ovX/+hcZpvGyCQ7WLNJ8G0VPytVs6uJtsADB1oSY+0VyO8DhOskAS/nZ2jGoG4t4ypxQD65aVTpLFDDloMNaP0NYL6oJ2pJowIvSK95TsQuq9fvG7/AsfoC9FkVDzD/uRWh6lbKm5p8Lz1PA7ylEW/b5ApkbZwyot4twMd3fMX6VtA7ZJppbtlyawAcmba6uGMFQvYsFczsuJxjr3QG55h1uw64pKBC37M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199021)(186003)(478600001)(6916009)(8676002)(8936002)(4326008)(41300700001)(66946007)(38100700002)(316002)(66556008)(66476007)(2616005)(6486002)(6512007)(26005)(6506007)(86362001)(5660300002)(2906002)(36756003)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?37aZG0CKxh7XRBPDGHNQvY0DTvEnVtrjWKK9fUcaejXOmE539l/ePwYY2f/e?=
 =?us-ascii?Q?p7uM/122l4+7xJRvd3fwcZ2vXdv0xHkG8Q5UOKVr5zCV2SRk3cRZ/Nw96sYS?=
 =?us-ascii?Q?4Z1lVeUKUusoiKi+xVx3GnxdZPx6OzaCwjaxArq0m5vN2yISpXBp52w/ZWtt?=
 =?us-ascii?Q?E/jxONUsCAA5vdKlYbIehw4rTqNhrdr8+pccjIimUXMlj3/W5ZsiY8bofMa9?=
 =?us-ascii?Q?L7C6zH6HOy4EM689f0PT9xSKKje5Oo9TqmR9Gq65S52+mTbzimwp0BMVgUcM?=
 =?us-ascii?Q?O01Gbyym2UN2GY7301HnNA54nzUytpdxtn+60CkQ3RZjj59sMiQ+X0y1mhVv?=
 =?us-ascii?Q?0JaDI/Lnfbn09WoSZ6Ip+TGyzwOXm288cDyd+o8qIZVVC1a0fv3lHaFHjQko?=
 =?us-ascii?Q?lcJrHlrLI4evK8NGzrvyshMiWhcIFZZdU4ZHfcI8SMvYi14VSJkUd3ruf63b?=
 =?us-ascii?Q?W2TsPdq8WltC8XLKMRVOVknplIIqu7UVMLqQd1r01qrGVMXFlLRUo7AHyZIW?=
 =?us-ascii?Q?JXkTpFioNbsjdlgmKyP47BUKoguEyPRHRAkNT7H0VeQK7HO2eG8mMGLuBwE8?=
 =?us-ascii?Q?iHMPsfX851s/vVbnM6n3ZRO9ItC0EnAFviwt/g6zCUw0K0X0f1EtMSbHPVqC?=
 =?us-ascii?Q?umnBmzH5n6Lh2aYuABbxfDcc9O+xKMbbQoEd6mO+1OA837+NPRJuynsQ6kpz?=
 =?us-ascii?Q?DQIgp2QooahJg6zosvdIH48rT/kL5uMeYfwq6nqi8N3MQ2nxX4AqRoZXUd/s?=
 =?us-ascii?Q?sdkKBJokRn+d2IkMnTPzGGtu1Uj1W3TqUa+xftF3wJ6HRpGNKv35VnTmXmEc?=
 =?us-ascii?Q?kn52oT92y12Ldw4hzCRx7sDVrtDsazMImv1eL1jHJ3MOC5hZBFo9xTnTKt1m?=
 =?us-ascii?Q?FmxV1UEkSpmkZ0UpAtWK+rjptePwlrCRUhLNWzT8NkJhhbcnXWlLR+0YM9sP?=
 =?us-ascii?Q?QgskjG9sAMOlGNK9dUW8Cb3tbAEEpsi4L8yUQOrCxxcYnig427VgCoosKoYH?=
 =?us-ascii?Q?dTc4H/G2SbYMex3zEcJhaPkkJpULfGIvkh5Iuu1evH4AWMsP7pWfhcOyVkHD?=
 =?us-ascii?Q?lmJSzaBzl4mnjvEaR7XN51oZTnJHUKB+SmsbGHog0AUwxncu3QymvZ1RTla0?=
 =?us-ascii?Q?0orixlbMpcrihfkLy6Cnui/T3+lI/gbhdicXEb4qXJc5dS01Qc4lk4JGOkJQ?=
 =?us-ascii?Q?pTUh6HM83cg8+FBswAKe5IFDoISX3BuSUg6G/4UHY87hagAZV4HbnV8/Fufd?=
 =?us-ascii?Q?0khc5VdCY++oGU+BgSfqVU8D9eS86HacDbXy2sLfAEZcUBvxX5cfda6k0pYV?=
 =?us-ascii?Q?PVejG69tA2z18XwvZrO8vPpQH4V1vDsdBBUP3KbP6HVkk4dLS3r/zoJ6DhEJ?=
 =?us-ascii?Q?qkO9ENKGrBMuKy355wxhiTvxBLCLiGJtFUcSHNSFcePzsEcyzTeSXSvn++DW?=
 =?us-ascii?Q?Px4KdjZTrV2lW01vITeHstiHiBPok2jFVl3J5xCskf22JevJbVAIIaHOZ/1+?=
 =?us-ascii?Q?OB+pp8BzFRps0oWyS0xT9wvso/7cTNy4/s+MauTbengj2DwbYSz9VZcNrxp7?=
 =?us-ascii?Q?Kjun3gsuzK0uJXn1wN2lCcFu+c1yWU3CNQGJgfRU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f3a472-1810-4214-a3ad-08db6699d161
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 14:25:03.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/HVX1zEd6Qnq4HknPWV6Axc8bPoa3roHeG3q4NGVwGuitSYvLbHglT66cRaFYmH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6213
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 01:25:18PM -0600, Alex Williamson wrote:
> On Mon, 5 Jun 2023 14:01:28 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Fri, Jun 02, 2023 at 03:33:13PM -0600, Alex Williamson wrote:
> > > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > > index 70e7dcb302ef..151e816b2ff9 100644
> > > --- a/drivers/vfio/Makefile
> > > +++ b/drivers/vfio/Makefile
> > > @@ -10,7 +10,7 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> > >  
> > >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> > >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> > > -obj-$(CONFIG_VFIO_PCI) += pci/
> > > +obj-$(CONFIG_VFIO_PCI_CORE) += pci/
> > >  obj-$(CONFIG_VFIO_PLATFORM) += platform/
> > >  obj-$(CONFIG_VFIO_MDEV) += mdev/
> > >  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/  
> > 
> > This makes sense on its own even today
> 
> It's only an academic fix today, currently nothing in pci/ can be
> selected without VFIO_PCI.
> 
> > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > index f9d0c908e738..86bb7835cf3c 100644
> > > --- a/drivers/vfio/pci/Kconfig
> > > +++ b/drivers/vfio/pci/Kconfig
> > > @@ -1,5 +1,7 @@
> > >  # SPDX-License-Identifier: GPL-2.0-only
> > > -if PCI && MMU
> > > +menu "VFIO support for PCI devices"
> > > +	depends on PCI && MMU  
> > 
> > 
> > I still think this is excessive, it is normal to hang the makefile
> > components off the kconfig for the "core". Even VFIO is already doing this:
> > 
> > menuconfig VFIO
> >         tristate "VFIO Non-Privileged userspace driver framework"
> >         select IOMMU_API
> >         depends on IOMMUFD || !IOMMUFD
> >         select INTERVAL_TREE
> >         select VFIO_CONTAINER if IOMMUFD=n
> > 
> > [..]
> > 
> > obj-$(CONFIG_VFIO) += vfio.o
> 
> I think the "core" usually does something on its own though without
> out-of-tree drivers,

Not really, maybe it creates a sysfs class, but it certainly doesn't
do anything useful unless there is a vfio driver also selected.

> so I don't see this as an example of how things
> should work as much as it is another target for improvement.

It is the common pattern in the kernel, I'm not sure where you are
getting this "improvement" idea from.

> Ideally I think we'd still have a top level menuconfig, but it should
> look more like VIRT_DRIVERS, which just enables Makefile traversal and
> unhides menu options.  It should be things like VFIO_PCI_CORE or
> VFIO_MDEV that actually select VFIO.  

There are many ways to use kconfig, but I think this is not typical
usage and becomes over complicated to solve an unimportant problem.

The menu configs follow the makefiles which is nice and simple to
understand and implement.

Jason
