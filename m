Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC1366269A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 14:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjAINMR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 08:12:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbjAINMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 08:12:02 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5782AF
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 05:12:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNbmtIef6cboyHAMnweGV3FVf23jp0VQgP+bM0RtY+QQKFxKd8lcp/NO3bRFZsUhcEuML9HOTPwxwLq7kS/94U9VjT86XaZnhH1gwBWYgF9tXoasuCe3Fp469fHW3SXmjFkVLFXothrcKHRzSm2fDAlosrSXmkWy0AlpqnAC92dyid1HWZ8iLx7MJg5UbRqwH3n/LXTKt87fzPJhub2rAAGXfLqmzG+D2V1ptJ15LH4jD0lHnrOtsMgfIjTwbJs2N6oLy78MKGf7gFeQXT3GUp9xG/PMTtZOpMwNEf3PvNgCTJNN/ayVuJO0mAaNV7us/TP/Ix1Y95fGLwv+1zuy7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27v+3Qnf3DQ6EmS6x2w1w78aIwHtl5t4yxbVUH2/Jyc=;
 b=TDEnusvRU7ql+sFrg3E590IGwO3BfGbZQcxpr2OsYNqLdhCKGe4MLiWnTYnOfYM0JML5BK77vypuhNjhzX3U77HF+ZYfFoBL3E5NLGwK+U7bAYVbBu4AyJQoL96NHjwmJU2kt+u8NzA8t7Xjo83uEY7m+OAKQXndwI/sLAYJ/8uaUnsx0jpOE5c/6RF5VaLxv8guxwycNpXe+qvVHkONI0g6W1aFv1WFuqPag/cC1KvFoshAcL9bAqYC7LdAitcTSRPMOnrHJsfEZqolqX+fTFSFrEhYm8xkP41Ajfu9S+WVNHfS9sSgGtzFNZfCGGhNAjkQcOZaHmHvAjPKLrCA4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27v+3Qnf3DQ6EmS6x2w1w78aIwHtl5t4yxbVUH2/Jyc=;
 b=fesiiKpHxl13+aCtsD4tMD/JOtA0itXkibqt0z6xjkO1R4YpzPL1ggESP0TqjfnuyC6Ejt/CfwW29LWZqKHZ2zEhFYCuvHm21m+bfCODD/VEiDPHms2jYIPiilnA2ifyg/QFxjzeJrP3ND3Q0fwn5e6QBfUVqFWJ584UWNaNEuroSZofKdMiX4RCBfMXT/ylXbZPOPWPHZ5R877lX7hImdjahPuyLdX9gLwJf3nmSx9QP3ZufYZBfmcb4Hmn/mLr/tknSD7EmyfwZwLqxDOgSchb+1lK3Vdpb9YHSod9vOpVPtzuP9J7fUXAYfnA/aaRU8BDpkL3j5XWJPAOYgMnCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7103.namprd12.prod.outlook.com (2603:10b6:806:2b0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:11:59 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:11:59 +0000
Date:   Mon, 9 Jan 2023 09:11:58 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        diana.craciun@oss.nxp.com, eric.auger@redhat.com, maorg@nvidia.com,
        cohuck@redhat.com, shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V1 vfio 0/6] Move to use cgroups for userspace persistent
 allocations
Message-ID: <Y7wSnsqkKWU+dZgH@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
X-ClientProxiedBy: MN2PR14CA0001.namprd14.prod.outlook.com
 (2603:10b6:208:23e::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7103:EE_
X-MS-Office365-Filtering-Correlation-Id: abdfaee5-2f65-49ca-9305-08daf243177a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XXGaFMvA6zAkITySm2Lr9oQshyFONzQZIn22cS5595lZGZQ9qmeTeyH9NSAViXKbI/m7TQ8QDzEkqBMY+JcaVreG/zNeUg04zF7aglIyxL76fZPeXMiwqiU+mOGymavazHqJqocF2Zc3n/HFrltcNQ/4moDldo41iKizJvdywkzK57QU/8FHyuBQab2ZOM60GmI17gDxFJP5waHXzVQCcvTnFdva9cLZbs72AmE9jqOqsXj0M0nSxEYeWUyt/eW0Gt0QMaerD/Yzdzx484LxROb7CmuQNpWLxETl/cJJq25qPjGF8CKZYg3bbDr5UshD4GdPjVja6d6EBufWo1ts37NS5vnLtculXHrjT4NazgQ6rgkcaOBZYf8IYKPCyvDdM2a8YtOC1iRrqVozHLEHhA9YqQWBAdfvyaExcGpgW/PvOggfTQWkyRtoq4Lb3XBptVCQELYdxmyEV4DWRRXRFuIMg6yWFQRLVKgJ78+UWYOfKk95Eny728F0SNluLKUuK+odBhdff1pSWATh1SRYZsy07xon4iyYQkE6fSXsevPv9PFDpb0ICWbBEUTf6tzktpt6nG2n37He6Sq7Wnhe6RiIgiePuMO74l5HHf3ABtwMteHXHzqW/wV0NfrAFAvKiGSpFZ2KWbV+XmbGh/nU9wAg0dgba/EMyjt3qA8Jh6VXZ0Mo23BMXFTtNDXHGb1d3StUTHqm68XSMi0r+toGOysBlRwJx6D6yvU4sdSvywQaGmirsojSho9VZF/z0EGh1VdN9TzAWRvC4NfMi2mKwyugpMVK4QwZU4xBL/Wt+i8ARiQTeZ0f3guhOH7uAO0u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199015)(41300700001)(6636002)(2616005)(37006003)(316002)(66476007)(36756003)(8676002)(4326008)(66556008)(66946007)(86362001)(38100700002)(5660300002)(83380400001)(6862004)(8936002)(2906002)(6506007)(6486002)(966005)(6512007)(186003)(26005)(478600001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XZ6ITWVHGouprIllOKPdUano981R/PcZtYgS9j72lasUCxJXZ6jFooaowqri?=
 =?us-ascii?Q?l3GdUl/44Ob3TDKWD/Dcz41ASF3Pe5ZFtcLywAmTWuE085HR3Bc0ExOiJ7aj?=
 =?us-ascii?Q?QVslCy0O3UGfuoyd9yvf/1497QJS81McVksVmBgkdsxhmLY3qIa7pEC4i8Gx?=
 =?us-ascii?Q?N8qLZCkAzbcWIpUMj2aSM83QbTNJV23L1+c6rmLvFlO3dOWYtE16DMPjj7s/?=
 =?us-ascii?Q?NrJ1Aj99GkVJ15IHxDhdtzWljs3vtIZCYPKCwvZ8/u8kvMHgVF5wIwd2gst/?=
 =?us-ascii?Q?qXcea9FWMEAfBufnzjculQRl5RU5zathhdF3gRjIbghI4LHNLLCZktvUWf1z?=
 =?us-ascii?Q?1WhbwxUZYqDUlSrOwJTOxyFq+0vf1kFccPTI0cu3RxpWWIbDxLbQGJoeI4Q3?=
 =?us-ascii?Q?nm2cBZAxJin6DcSg1SPJoAVmAh6OyR03t3tz3pufsf1ebo+ML9YtPhwXKk07?=
 =?us-ascii?Q?aOn0q3nKcqJs3qV9Uew8eMcyHyaz3e0OLJEp4JgyChunLHjzu8fnnstSCvCg?=
 =?us-ascii?Q?1XAz/nQid7Ov5F144m/dzYMpYcKqdrqf5/HSJUk4UauaWiVXwcn+5WVbYehV?=
 =?us-ascii?Q?ZJr5dvHhc6LwM1uYnB5q7xFBvTbqW/PZd7RrqSUW4hv52BRKwYVXd589BAOM?=
 =?us-ascii?Q?Sl3py9HSwLeqNo1kLoft2vFEEqtmmQOZ/YvAxefBAs1N1Xos9Z9urz9YE9Qp?=
 =?us-ascii?Q?VE8WUbBoHoPiE7VyUWtyWKEJ8aJ7sROt4aMkpSDjRG51H7I+bvE7jVbEQaOH?=
 =?us-ascii?Q?qf3/8F/uQjQLILVHFLaV93aErAqay+mqEScbKSSIOFjYfEpwlMzdnDthxKQP?=
 =?us-ascii?Q?XK0JddJnX9Zab1WQZea6pJ+JDxiLsbgrg9Kc2qYUezjSwy8QWPFE87zSXRGY?=
 =?us-ascii?Q?6sCgEFOsQTLkaV9o/ckI07DhmmGLYFVUYvIf+ddW0Kc+nu2Rqq3XHWSUsVsY?=
 =?us-ascii?Q?Cgr2+5SpgvK9KL2vKh0vla2BM4TSm7yVGpJxIKgAcyAvsTe6fQVmTqchutkw?=
 =?us-ascii?Q?qgcCUWWMHAw4uCbt+5Vh6O8X13bbsiA2ZnDbt9K6O1bqOPKH8jMJHawoJlAx?=
 =?us-ascii?Q?ES5OOVgF/1/laVz+KiPyLF300bPrwRHxiPvw9UU9W+5DfJMi6Oo9BHKKbaW0?=
 =?us-ascii?Q?4nUUDPM5JP6NlfQl4SKm0J2+0jknLvkZwGwwHrJdPaHCScCKExSyPGpMyeJO?=
 =?us-ascii?Q?v5VPp05DAI4lyt7ab4RL/RWcHjZlsGd+f4v9g4k/UJ8KjJiW78GMv6hrCFqL?=
 =?us-ascii?Q?1ZRwIbkS+y3sbBgTHb+FDbm19zJSE+Dz0LY6cp6oIsoEJFJ3OiDBnDsXLb6X?=
 =?us-ascii?Q?RXLfUd2xz3htbY5xPda33Ex+j+Zsm0gt4ftjWsMa3NwCssRhn2gDZbCD5xN6?=
 =?us-ascii?Q?tzWBAOMVQ0cSDyaVXVXLkDgiwKSKTQ7qr0Qv8fUY3YZrofmk1RAuQ8Bd7J5T?=
 =?us-ascii?Q?HvZ/A2WqgY9ODiA7BefltMbn+38619GUzrLgXuLdKB0MOJ7tAgQP6jkpKX8Z?=
 =?us-ascii?Q?SjFowfGLKTFiXtBrPhlmcAIAZRGZcEBqokdDtPsmooRgRhjRJl8SiFH6SebK?=
 =?us-ascii?Q?A4cojisesX6+rUGn97I=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abdfaee5-2f65-49ca-9305-08daf243177a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:11:59.7936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fFIxq0ZfnSJ/AJX7oJakm1/JWoyfiuU1thCK4bxuzQs1jx5/oscJ4vPHRCsfNYVW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7103
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 08, 2023 at 05:44:21PM +0200, Yishai Hadas wrote:
> This series changes the vfio and its sub drivers to use
> GFP_KERNEL_ACCOUNT for userspace persistent allocations.
> 
> The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
> is untrusted allocation triggered from userspace and should be a subject
> of kmem accountingis, and as such it is controlled by the cgroup
> mechanism. [1]
> 
> As part of this change, we allow loading in mlx5 driver larger images
> than 512 MB by dropping the arbitrary hard-coded value that we have
> today and move to use the max device loading value which is for now 4GB.
> 
> In addition, the first patch from the series fixes a UBSAN note in mlx5
> that was reported once the kernel was compiled with this option.
> 
> [1] https://www.kernel.org/doc/html/latest/core-api/memory-allocation.html
> 
> Changes from V0: https://www.spinics.net/lists/kvm/msg299508.html
> Patch #2 - Fix MAX_LOAD_SIZE to use BIT_ULL instead of BIT as was
>            reported by the krobot test.
> 
> Yishai
> 
> Jason Gunthorpe (1):
>   vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
> 
> Yishai Hadas (5):
>   vfio/mlx5: Fix UBSAN note
>   vfio/mlx5: Allow loading of larger images than 512 MB
>   vfio/hisi: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
>   vfio/fsl-mc: Use GFP_KERNEL_ACCOUNT for userspace persistent
>     allocations
>   vfio/platform: Use GFP_KERNEL_ACCOUNT for userspace persistent
>     allocations

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
