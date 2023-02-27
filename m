Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FF86A3A49
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 06:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjB0FKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 00:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjB0FJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 00:09:59 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C5C1C316;
        Sun, 26 Feb 2023 21:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677474598; x=1709010598;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TNm9LvLFeNzKL522byTJAM8sYptDiziABOF8wYdvriM=;
  b=I6FH1ZGoYqMApkmhogcdN+al94lVAhg12LpnvPCdMVLCb1DNIzX0Lllx
   H27kpD3OoXNLe9OIhiBJdZ9GCjoeHEpL/JwxRUi8x6jR75pMX70xS0IU5
   SK2FqXa3IpWRsiBrs1FYBEiZbhotq402AUathM9UTI3ZT/Lqt2kZ5Mxyl
   Oaz+LLYMbNcrXChIkq7EBPwPjKX60dXihfc4Y65P9ktdfA1s7Gqo2vK1G
   wOK7RAd46GCspPZH3ntBudOaoig2tRI4BZdmt92zx1eE42bbOqqL74Q02
   c5NaCSTRlW5C1nEjqEFmCqdAG9IXBVBo5OlT74x/PqOxw59R9iyTrjts8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="335258907"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="335258907"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2023 21:09:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="737510072"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="737510072"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 26 Feb 2023 21:09:56 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 26 Feb 2023 21:09:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 26 Feb 2023 21:09:55 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 26 Feb 2023 21:09:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4bPV+3/Zk6AIr8VCqUKkfmUq3WxZToNLQOyTaSH8lGAIis+32TUgpf9mHyKQ6+nL3QnwvkHf3AWPuqGRzhKs/+coW0Gb6iOGzr/cRhq+MMf0sq6/P//W4CHq4e0AYyVsYrKlVjIiCohBkYsRpSxYr/jy73hCWlfi3uJRaJCdup/9UWW/jqV0oajYkvh9nhwzjhCOhsHUh5if2vuxYjwvTAI8cVWBArogXqnoD5rc+Z0k7MExgDlGpfwgHBrBL1scDDCoy8a4m5uXcKLzOcdh04ncmXXsb8te0Ktuc3u9br83n5QhLIn86+KmYrC9VOLALyxaAngqPBK7Fb5C8N7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kTvmND5O6wMM5jHtnNLt6kMkkpW+6dSK5iBsxQfAVU=;
 b=Hte07cjMeaNxRV/c3Axy+jjfwKko4spxm9R+frCefhGwYno4pEKQ1+JqLEC3Oh0eCLS6nx7ICqoCbBa75vaaCc1pAiU/3PiBLIHlXA56QjMDcaz1yrAjDSrVqYydU/eeKEK0hgmy5jYiEM3PhjjVW8VKlonVaww67hJSsdLnLjXgy8xY7b0NRUguxvHTldx8+1CWoLuN+g0E5se9wKWjfvX9t7GfjWdn07sRXFiSJC41/EAFUPaOgshi5hQcUQMPVx4UIfUeULWo/XKkSZAYWRQxwYlzG/npceGm8/ycK5JOAJWmxfiBFG2XSXtujrobtBxbtvH0Fpbp+XIp7u8Amg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB6348.namprd11.prod.outlook.com (2603:10b6:208:3af::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 05:09:52 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6134.021; Mon, 27 Feb 2023
 05:09:51 +0000
Date:   Mon, 27 Feb 2023 12:46:03 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH v4 16/19] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <Y/w1i37WQQ1Wqkh9@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-17-yi.l.liu@intel.com>
 <BL1PR11MB5271AB3735F7A783C2871DB88CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529D04D2EB9B5C69C306C16C3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/YRx7jLuyEoLxZg@nvidia.com>
 <Y/hD7sRCLaD+/QlP@yzhao56-desk.sh.intel.com>
 <Y/jKR/+x6ASp0LUL@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y/jKR/+x6ASp0LUL@nvidia.com>
X-ClientProxiedBy: SG2PR06CA0181.apcprd06.prod.outlook.com (2603:1096:4:1::13)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fe7fdda-b06c-4f7f-438b-08db1880db21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dApt28WkpWsV8JA1oOER/+24qeBFsF5xKitNM9OR/2+c601Mc0m/kOnq2sM26nAkOEmePBHUhVI9VxPVjgh5FbMQq4IDAiGLSXDmYYwJuGvS94c8gEaShyiuhVJIIUMKqfk3TiCJ8f4MTxFCAkPTvfhQTg2W/kXcWNDR0kY3oaTJGOv5umq50FLEOUcn2BQNkExZK2+/g4o0brRScXvNJ4s5LRtvw3BaO+qzDjnxKiWcYucL0n5Y2dJ3pzHgWWD+6zVwd7s3YNpUiR5jbcSlgfyN+k6tlfethEFp5d/f/dj6rVaVxGdwlLybKSqXucDv6JeE+TdkEpOh1V3iBvXBoisvjnWPeN2OzfpYqwKC10sUfU2fueM4xL0MfNw4/MJRliqPgrxlaVCua10THrPTKe+IKFpmeTJ3W0dOJmwMe0kCamjoO3UwaCyja6yAqBrQqcyt1EGt9ObYQVrs99qB7HV52xKP1bgA0UX/plBDDDL6/4/iGOJ8Pp0n779Dy6Nrxl+gL/4/oOHqrXQjqSrNy5RHoCtGKnWprUcwZaOsyCtN1Sj65GLJ019U4ABp31f3LiuKR39RmpVcEcmV6GAcninanKEruLmX5hDiNltWZmchgXp3hUZHDz0Q4cRUj+wCAlIQ5gaSHDBZ9iULRx4vUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(136003)(346002)(376002)(451199018)(82960400001)(2906002)(3450700001)(316002)(478600001)(83380400001)(7416002)(5660300002)(86362001)(8936002)(8676002)(4326008)(6916009)(66946007)(66476007)(66556008)(54906003)(38100700002)(41300700001)(6666004)(6512007)(6506007)(186003)(26005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uzePNDTcn+hUvD04PbmOCl+vzGB1M/e3gJGOK25yv0x6EFbbDshwQj5fEGG1?=
 =?us-ascii?Q?Ws1asorPf3a9CLsU6YxdFB1njb3b6dLKWQlYlz5qtC6DxFoyI4NybLuoFyLk?=
 =?us-ascii?Q?xTyJ5g9Z6SNihdpMDNDM2mqKuDD9Jy+tM3D0Srgm3tocLa8YzRpmJXcNfWzW?=
 =?us-ascii?Q?KDdPob9xckMRqdoR82wseO3F6FTMf+CPxOqIEqsY9J7NC11LXjwbzNeMzcJk?=
 =?us-ascii?Q?nmwsDP5sHC2m+Uy9RQUlCJKlZ3OjPSuVRYedHPmp/aPTMspOB9DGoEXasghQ?=
 =?us-ascii?Q?4I4RM2pzkzeuSg+++Xew7MoMYTjWg5yaTP1e5JFYybYvHxA/oZ+FxowHUjiu?=
 =?us-ascii?Q?cceXyOTBWX5mGzMlj4xsYmU32Ag3FvIcwAz6GWLNtH5fRJNdi8ROVwHJk9q9?=
 =?us-ascii?Q?XYQH3VNI8rkibjOi5s9wrTRzxecepKm3FBs0gx1o8xpqhnGMRaaRTETRBxhw?=
 =?us-ascii?Q?F6i+J3YhjiWViw9VrSpauVw/1vByj5Y8mXFI6fBb8ARdouskdcnzK6G5jDKj?=
 =?us-ascii?Q?mt5IW51YqYc+5Auew5E3pa6y0iU4jnScGrVWvR0MhUkEio4zshlEgeomNlU+?=
 =?us-ascii?Q?r24FixwBb6ymvdH5NB8xuYQgV/WleEv/tp3iSP8H5WYcfS4jBcV2ZZZuF3Zt?=
 =?us-ascii?Q?4aoqJirdNZqDFi6ML5Y8GfhCr+wJt6T3sLqI3PE4utD4MlR/nvbkrBZNvBN4?=
 =?us-ascii?Q?5QGNo9m+LAgi9HR+8n60nRAeIJA0YDlV4zMM8dJlvj6GCrBoLZKoPQJhF2uz?=
 =?us-ascii?Q?1h/hgIYzyj5RhQxSbTa96P7WKOgYA1HVuzdWBwWGf8NaoM1D+gEYHE4+Rytk?=
 =?us-ascii?Q?/4gxd2IcFmdfI4DcqxCT+hwrWgORQVbtjovKZcCYPxMaUtuHZMjcb5KSKASO?=
 =?us-ascii?Q?KvcM84UaclltPIz5FTL8Q8Xk2fV+/UNxh4ZYXTqkhqbB1SQRhz9TcPAoLGU+?=
 =?us-ascii?Q?xq8xIa/IyxT5sXwpZVypvxqGyb+k2u2BeeQ0Y4uvVEVruniNIAOg5hZ0O146?=
 =?us-ascii?Q?nUuRWnJ/4hil/RjIHK+LVcSHYlAkady3YN0YWcX5Jq/ukTmgj40Jhe/SWRR0?=
 =?us-ascii?Q?kyxuGBoCmRh+ErMMV47w9N2UowFuyZ4twYpxz5DBV1PI6NfifVfw0hM9RsTj?=
 =?us-ascii?Q?etd6iso48DWg3827FBeD8pGgnTds63aLQGLjTdMzwqbMr2kekr8OZg4gZEnd?=
 =?us-ascii?Q?NZxceLvEFJTR7Zl931MUGtopWHZ8IJVr2LJaDUkVyhCFnMrnt7b1RKbC+DLp?=
 =?us-ascii?Q?XJFBaBs/V3cHydLRR7lxPJblSaJMqZ8MWrE8PUP6abQH+4sD/w2tfNHg1rW+?=
 =?us-ascii?Q?7kFlySSH1jay5OhrBR6BkjFvvZHFdowp9v80rXnwGMRvGWSv8L7QmfvX07HY?=
 =?us-ascii?Q?3v+vVDcjQZmGQTXSdMQVM2LWgBKKqhizg2y19bvW+PRRjV3haaXtwyzmniIN?=
 =?us-ascii?Q?fPlgNR2C5d41bvbVv3X9qVqcSImv/X10NpkyBzcU1IjH84glZO4mwQTtcbB4?=
 =?us-ascii?Q?UQJYSCkei/mjIrtsL0bFGmr2QLFBt89Xn22UcpTNLEwctI9FkGfkZShwGOSy?=
 =?us-ascii?Q?/2JqpSXjo5mqO7UAWabcqWkYcFlunylzbXm+UBHpelfPJGjb9KOvdEY/27z8?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fe7fdda-b06c-4f7f-438b-08db1880db21
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 05:09:51.6515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EuiXEqVz7nQ65FyrxvUiGTk71SrGEql56qc/w9/F0XP9u2bDEP7mPVcNPNf2JeOru3nTIeWct3NnEDhVWc5qzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6348
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 10:31:35AM -0400, Jason Gunthorpe wrote:
> On Fri, Feb 24, 2023 at 12:58:22PM +0800, Yan Zhao wrote:
> > On Wed, Feb 22, 2023 at 08:59:51AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Feb 22, 2023 at 07:44:12AM +0000, Liu, Yi L wrote:
> > > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > > Sent: Wednesday, February 22, 2023 3:40 PM
> > > > > 
> > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Sent: Tuesday, February 21, 2023 11:48 AM
> > > > > >
> > > > > > +
> > > > > > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > > > > > +{
> > > > > > +	struct vfio_device *device = df->device;
> > > > > > +
> > > > > > +	mutex_lock(&device->dev_set->lock);
> > > > > > +	if (!smp_load_acquire(&df->access_granted)) {
> > > > > 
> > > > > there is no contention with another one changing this flag at this
> > > > > point so directly accessing it is fine.
> > > > 
> > > > make sense. 
> > > 
> > > Have to use READ_ONCE though
> > >
> > Just a curious question:
> > given df->access_granted is now written with device->dev_set->lock held and
> > also read with this lock held in vfio_device_cdev_close(), is READ_ONCE
> > still required? And what about df->iommufd ?
> 
> No, if the writer is under a lock held by the reader then it is always
> OK to use naked read. Best to document it with a comment
>
Thanks for the clarification!
