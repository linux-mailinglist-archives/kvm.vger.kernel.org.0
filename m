Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5193A5A32BE
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244079AbiHZXnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiHZXnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:43:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::61d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E4CE42E6
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:43:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnCUs3KSqkNLOiODRe1LmmoOJCJIz4nvJyZrmxV6XEgmxrIr//43QJit321Bt8w6Yakx7MvjypbKUOswZbfEfZYiZ0v3vIri8J2g0BjFPVdMpOfSzASKGaR/sB73k86nFv4gy+HKgzdFVc/CSyAmIyOSwxfJBKpVXfQMAb40YZBbm6Njd4x5e6D94befq/hlEkKInRN9WZFHQmywMX5dGYEGNuZ+r5dq4yHRWwT7KX5T0fj6y+r+H8mXw+LDAz5tf+YUqAB4LtP+eyeoa3YTzT1udS6n0ve2PKenn9w9P3irO4OStemvVdto9JTYqWLuO3WXRaVWx/05GzeLWTKDwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4J4rgFVgYPXhvd1svB9QAv3MshPPopg88cPMi+zgQ2Y=;
 b=coZz2KaBJAB0M2vwUFDqxvRXwvCe5neaozNwSKyPArDaxtW66M7j7Whr2AsiewgsVe7L/LWBEmzX60PzLFFSTBwXp82CjX+J6pwl7/iSqTlRTtqzsn/L/PtF9zcmMr+r713ZmtX74sNeMxW4ulNeO8H7ifbDXjRk3I22OjR0PGnAGxN+qY8ZuLUb3AiVSJY10hCXsnfEI70M2W7FeoAT6fGfQYCEuM/7I7hzzXR3ZeW4a2qIrTZgTjV8voRBzVH/YMU3ievrb4BVdYtVlk7Y4V0cDKuiWRYaxd5NzU2Lwyjdc72utgA4UeCAZ9CuuWqB8ISTH6QJuDqUyJ3mU/dVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4J4rgFVgYPXhvd1svB9QAv3MshPPopg88cPMi+zgQ2Y=;
 b=Dym44zrwRmQi6PkW4jUGAI6grVDuhloNoHCB+UKHvFDcsWBF/r3bC1gHf3YhhrMIxVL68/PNSbtfOqeazEIuo5cCYOHuVaiDejNu38MbnkJrCL3laM/D79TheaPyuyDIJLBE95UO5QwOAZ4tDNKW6DcKQKG+7+S/3LZLGKEnhPIg3X2oX75Wmgkd4nc65iefssETGs19GmSBwM1qMlyIYezntL7K8qVY+y8EK9ZWyoF6jo52RkX6S/qc766hIbLBcv7KCr7z+rLthgT6ZGjZSc78ZKJO2/8ZEt+4NhYq2cmCrIfq5reWW04psn8xco/x4SN/bS/n+IJR4SQ9CHR17w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3935.namprd12.prod.outlook.com (2603:10b6:208:168::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Fri, 26 Aug
 2022 23:43:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 23:43:08 +0000
Date:   Fri, 26 Aug 2022 20:43:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH 8/8] vfio: Split VFIO_GROUP_GET_STATUS into a function
Message-ID: <Ywlai0AR7RuF9FlI@nvidia.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <8-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
X-ClientProxiedBy: BL0PR0102CA0071.prod.exchangelabs.com
 (2603:10b6:208:25::48) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9deb7293-34e6-48cd-63f9-08da87bcbafd
X-MS-TrafficTypeDiagnostic: MN2PR12MB3935:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c4QYmksalwBVMggP4aZrL5UQcXn8WqZ8tob3Gy9i+DeoksCT+Rg2+RyJefWjpZLWJt/ouHxPtQ0TzosEqxQEpQMl6etfjCYd4Dr7xELqrg9cEhmbQDY3KrPnsDsdsWJZX1mCxYMSV0/etzvUwqqj2tF3zr9EsSHT9e4SXRaZZP5YxgnjV7xQFCS98yXidG4EQLoMkQIOOHT3vn7dfmU7TQhSVNGKOQlrAdjJtp5KIKHLOQwJylOdDQ9n5V/LLQQdNZ6iH6n9ZV5EVaEKaN8EbPDs11g6gLfAiK0tQZlpMX2Ell8Lym91u7jE8KSgQLcvDVR4QaT9v1ldzuQ//tNXTQ8cpXYuMZUpbS9ncyTv3O54S+SDPCM2JA1ZEoRag1bF3K6uKjjhl9YnZHD2QRfUCHRSGJ6wWrHvxvjXF6kMXKlB1JxJVr1S29EHRKSaK/r59y5xf6NOb+0RHiR2v7rAWJHzMM/qQyhCl6W7rTKCVXujEVlAx+2OpDncAnVCW1XMZSRVFcAInf7T7KBxFGdZf3mm1ilQDne21Y1DooIoARF3RD1FphFrUYVpF32464GpxZdYiiaiRNZAxsvHuT7mJQjikS9cS5d3t3uxdrPb/QujG0rkxzfRr1ZjTGj3zED+yrkrAKJGfKrDxDRrtcvH237fsdsnq6zHe5yJvTc2kATMxDp2/+VoSfRrylUyBhJcmBgPnS5DNiT2U3A2syLMfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(38100700002)(66946007)(8936002)(186003)(66476007)(66556008)(5660300002)(8676002)(83380400001)(2906002)(316002)(26005)(36756003)(6506007)(41300700001)(6486002)(110136005)(86362001)(478600001)(4744005)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P+24RmNqTOl/btoQuXEXo9Yg1pXdjJZ/y8lcfAaOLkOJB2SkdOEVwvJ7PnVR?=
 =?us-ascii?Q?mR3u2gcbUGeqE/CO9U82213MXz4TQvEjbh1mXX38qPaIOsFfMRJIapruSHDY?=
 =?us-ascii?Q?09M0Bus/FMgCagPZzFce3J4rKSfxpxVumbdfXtapcKerQIN95k74hz/GDUlN?=
 =?us-ascii?Q?/3AI2EvRaGR1fTM6aX6KQwsLC1wgHtM+0XnIcTfmDXkCVp5YtuuhkE6ryKgu?=
 =?us-ascii?Q?nCewU22iXoQKys274pcUSs9Q6fqLweanV7dYtijBs/L3DhOe2+z0cYklSN2S?=
 =?us-ascii?Q?2g4S++NflZydfzdC1GeBSlYguLomCKYWgAqo3NE7zzqjnWF9emnAmjkNmQst?=
 =?us-ascii?Q?aKVOObFB++QiHbwoxe8xNaSELsUCG5xBUnDqVgYTS2lbxZi9cqSDbmLIGmw0?=
 =?us-ascii?Q?Kd/XmofVPf8xL3AmetZxL6tDV8CG5hU3WpvL2HFmzUgnl6duvSFsM0Qb0Rj1?=
 =?us-ascii?Q?E9EXM/hiAC3ver96MVDs1f1GjmVhSs7oVpC5NLofSBM0gmBd+jRI6fbA04J6?=
 =?us-ascii?Q?r81GVg/40KzUkUyDiFlVPQZz+skIuXeLTalNi+FlQoGQ9pF3TYBzaYppqYgM?=
 =?us-ascii?Q?iPefpi/1nXl4F5xGh2kUrdc9+Np86pzMtqpKjNGzi0kdF1PpfV9mexIU+NpM?=
 =?us-ascii?Q?SRqOMcQYMooJSsGHJdM6wiwpy3YHeNzMAakBRTb8xJKIcnVog9X5P+GkNNOV?=
 =?us-ascii?Q?Chf0MfB+PSpaJN46eecjJTV7FzfoiLNJYi9AMd7IPrVAL0XdY3C/5HqFsPJd?=
 =?us-ascii?Q?D68CmoK8VQp415W+Jn0bvDpfDj8P/W9PgqrUCMDdcT5+/BymBya8v/guLVV2?=
 =?us-ascii?Q?tPl+YgU75RB+yBWhAO2c6q9Bgk7cBjIbagobojP3MJbri3Fy/Nx+bEzp1jY7?=
 =?us-ascii?Q?yrYZVFBDqIbdTApczm2EMT8RjU3E7YTV9xv3zF3v/pRd2aBksz47C/OzkytU?=
 =?us-ascii?Q?wDQYFgG3noJp/RBzJvnEEkKKiDXkdTXXcaH4LVJOxfZWvIroplUYV5nn6tZP?=
 =?us-ascii?Q?HtNNOQyJuMmqS3GtQiuEztVycpuY+qgFDYidikyI4IMvh1WDzI65v/QLxxs2?=
 =?us-ascii?Q?/IR2Tv/79rzmg2y1sgPCME6BOMv6cSMzMl+T0Bv00AxZ4NCiCQ3EKpZVOCVp?=
 =?us-ascii?Q?82t97Hat3urgRWFsCTQo34CvwYNPyBv3nb3Buuc9rZBWTeO38SYZLzjISK8Q?=
 =?us-ascii?Q?Q21NhgYh+Avx5GYV8RZWup7/jJanA7cMx3EsgQw1EFE4TMKsOJsTRqHsOwGM?=
 =?us-ascii?Q?00GsiPn3cLKOkHYMeLjhMq2OwVjggWpje4AVhcdtna3phVqgCzZa5/c0Wc/l?=
 =?us-ascii?Q?sHN0alTfm6RHAJz5jPAEKIsgiqMIKDiuZ1You06tODWyN2Uwff5mb21CEmku?=
 =?us-ascii?Q?bEc5TkckhRdBhqOiM/AVJS7bjizBEZfzej9ju3mN2K98gUlNQbYA3rSTf4zX?=
 =?us-ascii?Q?ysIZ6r0RmwidYovbd7heHETeKudqbOOBNkpJOxgpUvCU4pbgj2anFkV090dd?=
 =?us-ascii?Q?bI3hg9BilqgSatqh6tH3X8TfCISUuOJrzR0edvWNeDr4oXE/z//WUxUwhp5V?=
 =?us-ascii?Q?TCORpZ/LnaIUYvN9PXOVOCWlk4YuoMWLqkwt0XOf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9deb7293-34e6-48cd-63f9-08da87bcbafd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 23:43:08.8678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FKvdJnTa+jR8BpOoMc6jH5CM5va4hj29AwVNKRY7/aXQp6ZKilhvuFeEBbKp3THW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3935
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SORTED_RECIPS,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022 at 01:07:25PM -0300, Jason Gunthorpe wrote:
> This is the last sizable implementation in vfio_group_fops_unl_ioctl(),
> move it to a function so vfio_group_fops_unl_ioctl() is emptied out.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 55 ++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 78957f45c37a34..6f96e6d07a5e98 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1227,6 +1227,32 @@ static int vfio_group_ioctl_get_device_fd(struct vfio_group *group,
>  	vfio_device_put(device);
>  	return ret;
>  }
> +static int vfio_group_ioctl_get_status(struct vfio_group *group,
> +				       struct vfio_group_status __user *arg)

There is a missing blank line after the } here

Jason
