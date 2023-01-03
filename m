Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE7F65C769
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 20:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238141AbjACTZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 14:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239133AbjACTYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 14:24:52 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20603.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::603])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6411868A
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 11:21:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JF0MmjKyaK7DB4Y/PMUY8lHvEuiHCw2SDNDsOa53vvNMSyOFUKh6hKje3jYvakYa1I+VuMFLNYc3MFhQHGeweFnmahLyPZB3PRHQ3tEGKZlaLyXmT4pjdRTJBEM4/M3HjpE7CoRNzn4QnqNg44sFzDgBdYCLG12XKpzLQNlNFL0ab8xv7m6crnDCb3sUzUhFpSUSmxM0CBDaJLnk9EPM5aV7exUuzy4eldWdh5l0r62PlUAPPAW4EeznKl1DQrIlvFTAmt6/WfWBlNshnbOlINv7Dsmuri0DoJIr2MskZHxW+IdkqIyIbXS+yZST83IgD40KdA56ORuUF0r+altycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yWVdXGaWp5OrIp6Sy4BlpfIw3+6Z20TcSrbInsh72E=;
 b=VrrTO7wf3IbgnFp5C4Yc92xuFK/1JBf/AMIO8lJ8bybOw5PvG0HcN6O+ybQeyVActzvqcmWm9nI2xMAndWk0SMlg7JGv6o/wc8TaD36OhGF9lovoIB0fvrfyJ6hfJLPtkLBqAuQDHfCu0Y1bsf+oKXA4a55eZHFTFNwZ2EhJPrcwDogeyGD0CCoqoVD/2Vb28HDVPOeM4iRpMCdJYtMNx4rwys4lT+cJsw0gbALCODn2026Vj73jj4KdJSQ3ec13mEJ5aewainQkX2fQXWZTsM/aZDvzKR9uxMhyWv6u6aBVnJnv3UQj211IxVh8Vz+bZy5vBVt8MaGuIt3O6cCERQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yWVdXGaWp5OrIp6Sy4BlpfIw3+6Z20TcSrbInsh72E=;
 b=tUVqWtlzqg0EU1o8f1wCVqXEhgbUeyCi1DWofbV15lopo8AErShl2+ev95PUUjf5OZ1ZgfikDdfKJblx7HVWE7ZCdRFYN+QVBUJyDgp7h9mF9NUs7+9aKVWqlDysXw6WvGunksKKc9f8zIMUDPf6UsPaXRYI2dIjZTsmOWIWQgkUFc8p1B5EhhLn8wy9QmuTVCLsEthsr1eMGExwTrnF3hxiFa8NAIj5OhUZX2627bEuRW4zSBoVyyDqk9MglL1TL1agkEnvjB2cb6ZTMcsv/tenWX09gkjG68Cg6YbTpJef7MjOGtexgpz3MbttpIitDvMjgR7oHBC5rJ3UM5lbLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6287.namprd12.prod.outlook.com (2603:10b6:8:94::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 19:20:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 19:20:36 +0000
Date:   Tue, 3 Jan 2023 15:20:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V7 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Message-ID: <Y7SAA6eJKK91F6rE@nvidia.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
 <Y7RHtRnHOcrBuxBi@nvidia.com>
 <61e24891-28a6-8012-c2c3-f90f9c81c1c0@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61e24891-28a6-8012-c2c3-f90f9c81c1c0@oracle.com>
X-ClientProxiedBy: BL0PR01CA0005.prod.exchangelabs.com (2603:10b6:208:71::18)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 26a4d8c4-8453-4e87-e5c5-08daedbf9793
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: olirIwY4Pju2cesEj7ySeMdUetX3r07hAKABkxrGoKDUozyCypypSVsiNgJkCY3n9mbIF25ifbaWSNK2z4F74ulzWCreynacCPaNpg+R3QvooHDebZmcdKBi7NVLG7VLlrzFkdUmuMsCDg2WJrWcywmctlRuZGqNHWVCykLYoGm0ep8YCAZo3f7n7uls1JISu36XA0PqXwq3Jftido+aR86vMzLg91r/6e4bNkp9FLlzG5DRfvePNYJBSBGg54AhbT8EFw32ih/AxRcMGLZWtn94tAsuAyHT39Yq6q1QI5xV5RYtr5eAQNIwGrvqTS261kTN4BtpmA0w46B+RnG/et6HAEdc5hR7JprxP8ga6N26Z0XavVWyvjuCWA7e6ZTj4cKzpYPtL0X1TRuCItbhTUxwirkFDng6WgW7FZXw7ftdilp9l1M/2S/hwzAcwvK/TJ69sKLDiL0d2lGBkzDO208onTG+BKnQUpXwV8cNLwC87dQuZ71Rv8RYqEgGEL1rqH9zV+jNAEj9rI2KjvknFY1Mip5SWGqorY8/mOpQQu4YMB8AuEUTinAGRSqXBaUG5sLu3OFcia5H3h7a92H+NlOBRFAz6FrpnZbE9dxLgr5NOJP3lgBgYSWAIhSKY8FrTcPua60xfvpq+2xNWT3e5qJ5pfgXmuLd7McVYUtU3cJYAXXjMlYueKKJ0+EmTKqD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(66946007)(54906003)(316002)(2906002)(6916009)(4326008)(36756003)(8676002)(38100700002)(478600001)(6486002)(53546011)(6506007)(26005)(186003)(83380400001)(6512007)(86362001)(2616005)(5660300002)(66556008)(8936002)(66476007)(41300700001)(22166006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?srhJlN+c9rlL5GpaDVRykfzeNaP8Pb1zyyA6B55Q5nU2hiU6xmjIA59ev6zA?=
 =?us-ascii?Q?W2iw3lmsubs4iA2nyQfPe6t8Q8Pbk/TPN8lAl7CyebX1g4IoqISNYJ83YUDG?=
 =?us-ascii?Q?+qmRJ1gbakroEV7TQk4aGKsGKZGKex8vI6/NBD3GFVRXRSJmuMMa2QjGD11C?=
 =?us-ascii?Q?LZBzBBSJVJltoGNG9+tXYQF2E3vQSopI0gtUs8II+CplI9Jozdt531jBbfDS?=
 =?us-ascii?Q?i7bJqVlGqBrJxLbIzswHv/YhC6OGkCY8ALN1WHHd0wpK64TXzUOBpvfaWS58?=
 =?us-ascii?Q?Q31FN35gq7sA3NFWYge1nUiZ9QBPtDBZmGCGDl1Mfk+3EDsek49pdHZ4esLB?=
 =?us-ascii?Q?CtV2ncdYcBelyaO8YEP60sairP61ZUG7LamSVqrauCTBMRV5+GCdt1AWHJUA?=
 =?us-ascii?Q?B0nzeUhRgwa71wEH2VrNySbC6T/nUtgKxOJtC20qL6/2WSsYWGKp6uyCswdr?=
 =?us-ascii?Q?iP/8H3iCbJx7IOsqUGG4YUmpbzGv5sto6GkH6UOp20eC/KpnOm7iVmzCn3rA?=
 =?us-ascii?Q?JftQTIJOnBJOPCrxi+Np8UXOIbOOCIRx0A/vmAnnww55jCYnYPRY7g50btYm?=
 =?us-ascii?Q?Tyea4i8uuxOxrhwl/lerjCU4D2j6NHMC7V9W8mY5w2NdcQl3UHhUP+hzY9pj?=
 =?us-ascii?Q?7VX3XJkP6rAbomT17xb/RJtK4fi4R5rU/XyuMylOQmt4rhfSerrY8m8+kuAg?=
 =?us-ascii?Q?68MunL+R5HNz/kdaKfigU6fWxVMNr6o20VTKZXhdSoX2aVcJT1s2asAwb/Oo?=
 =?us-ascii?Q?7tUuURKOF5bG+NqGO0GZxQrYQfhqcdkNSQjLHjKw4TsPO2gMXUoixsrw1CmX?=
 =?us-ascii?Q?79gevwmskmf0BD1KbC3W10SSElepBz1AE/7cfchnMsfajiSFVnc49pbUrxJO?=
 =?us-ascii?Q?mQgwXJadYs7MKjM2MwW8DN+lS4UniNcmLr1+t852t75qcNupmF6EBs9ISfq7?=
 =?us-ascii?Q?gO5jYlgQlFgUUPJqALGLcpFB2lh1PHlMRxUTw4300nwz77FajEWSl1C5AMXS?=
 =?us-ascii?Q?sExUBJdUjEVKiMPgIa/GqHrWd+stvLzIYAEimY4iu/e3jzagkivpQfkapftB?=
 =?us-ascii?Q?HdABk2EWtTJwdQ21g7oaH8c0yHdEruJiIjZ8uGcwoe16YJBhwEZxUEFKr8n6?=
 =?us-ascii?Q?eYGuAGgEKrdmZMnnRQsqCLWA3tzlVBT7GvOiDU2B5eS0EUw5pbcDa4YKkMZW?=
 =?us-ascii?Q?KaSxv4mComLM5IMgg8DEzHcsjczTZG6lDTvWG5RyS28HA59/rQ6g9bLHWIbh?=
 =?us-ascii?Q?H4rPQWHIeQsKjss4q8dXRsO0MH0Iu2RzLm80wOVYshAnjzIeF0ubU87/NWZj?=
 =?us-ascii?Q?PPemp0IZrp2Tx13kMD/WyPVfcjfIgFZzx6yI7EnAW5cMbLwWO4afAOqdIzh4?=
 =?us-ascii?Q?ZJT6LXqRGkmpr4ALRH8ZFTr95/IOYQlJkp1+V27+WyVdL42AOozOi29IPLJE?=
 =?us-ascii?Q?OArVd4txPNLlVsrrEbefM2ZuOvDk7MoRR1IA2D2Nl0qX2mfmTPtwpo1s/NoY?=
 =?us-ascii?Q?NxshvOIehtpyHnhGJ49J3IMiGpAim1ZR1v1VzYTq1dRtFPnDaJp63LfeqYdL?=
 =?us-ascii?Q?lBlBaKINkm784pgroEtFlLBAjvsB2H9PByo73Iv8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26a4d8c4-8453-4e87-e5c5-08daedbf9793
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 19:20:36.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRWYnEgth3ZXveKrjNmrVFI6m8ESLVZeuGA1LiKDNjDgwnfugQOQb54C25NXy6E6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6287
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 03, 2023 at 01:12:53PM -0500, Steven Sistare wrote:
> On 1/3/2023 10:20 AM, Jason Gunthorpe wrote:
> > On Tue, Dec 20, 2022 at 12:39:20PM -0800, Steve Sistare wrote:
> >> When a vfio container is preserved across exec, the task does not change,
> >> but it gets a new mm with locked_vm=0, and loses the count from existing
> >> dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
> >> to a large unsigned value, and a subsequent dma map request fails with
> >> ENOMEM in __account_locked_vm.
> >>
> >> To avoid underflow, grab and save the mm at the time a dma is mapped.
> >> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
> >> task's mm, which may have changed.  If the saved mm is dead, do nothing.
> >>
> >> locked_vm is incremented for existing mappings in a subsequent patch.
> >>
> >> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >> ---
> >>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
> >>  1 file changed, 11 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 144f5bb..71f980b 100644
> >> --- a/drivers/vfio/vfio_iommu_type1.c
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -100,6 +100,7 @@ struct vfio_dma {
> >>  	struct task_struct	*task;
> >>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >>  	unsigned long		*bitmap;
> >> +	struct mm_struct	*mm;
> >>  };
> >>  
> >>  struct vfio_batch {
> >> @@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
> >>  	if (!npage)
> >>  		return 0;
> >>  
> >> -	mm = async ? get_task_mm(dma->task) : dma->task->mm;
> >> -	if (!mm)
> >> +	mm = dma->mm;
> >> +	if (async && !mmget_not_zero(mm))
> >>  		return -ESRCH; /* process exited */
> > 
> > Just delete the async, the lock_acct always acts on the dma which
> > always has a singular mm.
> > 
> > FIx the few callers that need it to do the mmget_no_zero() before
> > calling in.
> 
> Most of the callers pass async=true:
>   ret = vfio_lock_acct(dma, lock_acct, false);
>   vfio_lock_acct(dma, locked - unlocked, true);
>   ret = vfio_lock_acct(dma, 1, true);
>   vfio_lock_acct(dma, -unlocked, true);
>   vfio_lock_acct(dma, -1, true);
>   vfio_lock_acct(dma, -unlocked, true);
>   ret = mm_lock_acct(task, mm, lock_cap, npage, false);
>   mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage, true);
>   vfio_lock_acct(dma, locked - unlocked, true);

Seems like if you make a lock_sub_acct() function that does the -1*
and does the mmget it will be OK?

Jason
