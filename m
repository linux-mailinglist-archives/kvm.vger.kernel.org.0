Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4EE5689AB
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 15:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbiGFNhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 09:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiGFNhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 09:37:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB49E1706C;
        Wed,  6 Jul 2022 06:37:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vrv6LHc15JigId3J2Eujei4o5XB0zPovQ/SlZRz07UUUiOfQDFBx/iQiYqFsNto8jYoRfR4kWOJxfMq2RdumyiinF7pGmqzdWnmckTyuBxvwIViK+Op7LPoPwgT3XBeFkjLZqV2/ADiLd14lt+U/hAp8wQklE+PZU46U9vEAUoZT2if1IQ/oo6hdq5j7iI+RPpKwgGLLZeG7yR1bDeIoW3IEyBYk+AnCD/n+DYH0dMUEiHxVzj7ReE4GnpknsiPMoVDRtv55SrsetYRcnTsLwZCN/MvTzY1NKkyHpQOovd3tAOtZ5XsaSIi0T661WrUqozFfOKCSfe0JxIArvfaFmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcGer4V9YX2ur0Yqzzd3VxRTbH8j8JZnnu+rqxBqJNQ=;
 b=mrN6NDIogrWYhz6y4lLViqvp2C3gxX6FqIT+D8a+ylmYfW4MY6cF7YQ7f5ZW5Q4oq5h+ICs49axF4V+E43RURQKamRqPwO0Z8HieUIuQXjFb42j0Kjpc3j/f4uqytvB42jo/ftou5ZlozBWYv9nhtamfBYr+woBvMtTHORT179R55Vvyk7zXIKpYspZyPXOi65Mh0Uos9nr28odh++cGPGtJD3Ff4CJGQYP/1Teg+hSzIs5JDO8lnY7F1KrnpblI1ZqW6yTzSsghcJpFn0sYPVt/gGrBh3B4AiyJc0OqiZSTWe927CZuaB+VImG0LVKtrUhL/klpj4h25ydouUPNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcGer4V9YX2ur0Yqzzd3VxRTbH8j8JZnnu+rqxBqJNQ=;
 b=UcOY9OrY8HPdU4Xbp0nX5kHe9Pcju7QayguBDn4Y0D6iRue86rvR+xYyd873klZcWJJnHrUkhMtF2ZyPKHyIH7huKKmWm8M06niuigX/TmzI/W9QZiNJPhktT2umSsu0ghp13YN9Zts+9FVSw8wP+kuoE05Cee4xB+lauGTtEf6rsRot2ZURBeKJ4Rq+oYtyisTMLbIKFG96pOmh9hqXBvKMid6/j+y9pSQ0C2mJsb7eui49SQHOzDcJPlQOtmG8nkL1S25ld6J+l4PIo++KvsFC2fchE8ddnQMMEEtVB7CVnHAJZLSJaDnq4pNbAQX4wSp+awv+rdtSOzW8Kq1THg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM5PR1201MB0059.namprd12.prod.outlook.com (2603:10b6:4:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Wed, 6 Jul
 2022 13:37:17 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::e16c:261d:891d:676c%3]) with mapi id 15.20.5395.022; Wed, 6 Jul 2022
 13:37:17 +0000
Message-ID: <f7ddc3b0-ea94-9e1a-41fb-f21d2748d0cc@nvidia.com>
Date:   Wed, 6 Jul 2022 19:07:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 14/15] vfio/mdev: add mdev available instance checking to
 the core
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Kevin Tian <kevin.tian@intel.com>,
        Tarun Gupta <targupta@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Shounak Deshpande <shdeshpande@nvidia.com>
References: <20220706074219.3614-1-hch@lst.de>
 <20220706074219.3614-15-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220706074219.3614-15-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXPR0101CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::15) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a3e0170-ff63-414f-815d-08da5f54a4e2
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0059:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A/ZEVYBTdVB1tPVxlEtUGCWjvVtwgI+DGu4ZQEHzlNf0qQk8HodhyKDlMV/8tNbo/6D+fLl/+uruDlSLGrruHm2hzuzLAI0z/eA+BxKB4S184Z5E7AAN9oetPFklBhbVKaCe6nVxdqkXV4Gr7w1GUD3oLkY/0joY+sLGbL6M2RAOnpZGNRok2RqPVFOD+7UIcKW2FqEg3cjusiVCv6JuckqpCR+iR6fE7GFwaaEucT26gnRgtV2CjAdIn8S5fegd6f5WazkYNjIYZekndnqkOaSUtE0yF2E/slpaBcwN5GE1kX9yPrn69UK15NUkPYVJ/OI801v6RfQczmOdVcGdO7rI8E5O4nscpzeHmXlpFaJRlonYfqcnNnMrVo1PB7vgxwsqrAkUXWImNc9JsobxQWryZ9hWRNhUt9d8G8RSxeAmk0c8muEpdg86y6ie7aWjGARX2Y4tP1z4Vsmh4VRX2l63pglmuPzj2VFwLJlPLjut9MHcimoGHZGYpW+ikmO2FS1elW9Zl6IRmBC5w1TQyQGqfDhcJM7gpMEng3bt499Uc+4BSLjkqpQoLnqXNt+KJvafIUMpISOMjtaqp9sUtRaYv6Ovwt/DdL8ePJCdTQSOBNU8RhDIIZRE84JP2JQPRvPd9cIlf34tQaORkHgmYKQfEAykUHKJ6BlrgtTBZ1ZwcbiPAMSgqeIZhsFkSixuwSSoCCivGV3mA6DFG6HRND/Cwo0ZtlNXkWpJNU9TXC2aJ1jwmEQuFvgFMae7eqeB/oo6Dr773eAT5ZiJ4Xee8tGmgJg9/FHlLyPJeurdJgjjMnAwW1c7x2sWOtKGlYWRIMd2ehoguwMt4KjbFWe2m9+lzdnq6c+rZyCtM4PZIC2p5vVklRVkNahgSJHtGMYK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(8936002)(107886003)(31696002)(6486002)(66946007)(478600001)(86362001)(4326008)(6512007)(8676002)(66476007)(5660300002)(66556008)(30864003)(2616005)(7416002)(26005)(186003)(53546011)(36756003)(55236004)(316002)(38100700002)(31686004)(2906002)(41300700001)(83380400001)(110136005)(6506007)(6666004)(54906003)(131093003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0Zrc3NVeWJWMHhoelI0V2VrTGgrYWRPYU9TOGRSZnFMOVU3ZUZtdTFkL1Br?=
 =?utf-8?B?MUphMHo4Y1hqalNCNlBvS0h6UlRiTjl3NFg1Rnp5bFRQWGwvQWNUUjl3VXcx?=
 =?utf-8?B?Ni9PMEd6M2FaRVVLcXQxWDJRVlhXQ0lYVUdXNUs2eXRubHJnZGgrRzF1WGFJ?=
 =?utf-8?B?VGFIYkNFYnQvN0hKQzk0MFpJZ2xpVUNMMTJwQVA3ZklTNk1MVWJxV05MRjRF?=
 =?utf-8?B?Z3g2Q0Izc05aUGJIVnMvTWRiSnpLbmFuaTcvMnJUV3pGZkx5bkU2ek1DTkNC?=
 =?utf-8?B?bWJkMlMzMzExVkY5VEMzY2ZHc2V4bGFPMFh3WHhncG5UZEZoaHBZRVZFUzhl?=
 =?utf-8?B?ZlFmYThuRFh2UTJqNFNJeGY0M2pHV1hkTmF0OE5STWJCT0E0RjRxZm1qL2RV?=
 =?utf-8?B?aER4bm9WMjJCdFd2UktycDRJUHVlVFQ2RWhZY3gra0JVOGpsYTNua3NYS2NX?=
 =?utf-8?B?M0JhZ2V1VVJwRVVkZS9tdldWK2Y4cWZYSjNKSXJCRTk2bkJCTDhKSUxzSW8z?=
 =?utf-8?B?dU8wdktabU9wV0pBNFk1TWl5THhJdy9udWs2aFFFa1dMU1FhU0Fjd3gycHZX?=
 =?utf-8?B?RmtHMjgwc0daUHdycjJ0NVNicEV4Yk1IaytpMDlJZkxLK3kxcGJSa2FFKzNs?=
 =?utf-8?B?bGljMUxBQnlBTkM5YkhLWTBYY2RkMnRieU5QOFFlZUNXSW1lYTROMDlaWm9G?=
 =?utf-8?B?TDVYUmErdkZCSExZSE0yVXpKTDBpenZYelh3ZHY1d2RHaHJkV09sQnkvejho?=
 =?utf-8?B?OHp4b21wQTk2RXRJbHl5ZnpnR1FWbWdFWThjb3ROYnN6Q1dhZGxTTmNXb0FY?=
 =?utf-8?B?UnUvcUlsMTllQ01lQVo5dHhhZ2FLVW1USGZPSzJGQ0xuL0doTzZVVURnSkUv?=
 =?utf-8?B?RXNhT29RRWphQnhKVjBXWG44b3pybDQxcGVHMnQ5MXo5U1I4ckdiKzJ6aEhq?=
 =?utf-8?B?QzNqR05VWkhvNlR4amhYaWcwWno5TjI3OTRKdUQ5TmROSVowYVd2YTVvTFVQ?=
 =?utf-8?B?YU5vM2ZSWEhQRXE4SUhCK3JDZDRCeUZjZy83YUZPeGNBaVFscGlJRit3anVw?=
 =?utf-8?B?TlR4eVJ2T25vZ3ZzMm1TYzYvaHZHaGFCTHNYRzlFUllRNk5EWEE0azVBbEdP?=
 =?utf-8?B?UitUYVR4YW1QNDJDSkU5TGdxdHlDaldic0RYd0pZaUpyOHkrbHlLSlBqdGVU?=
 =?utf-8?B?SlpyUWxoZzF4aG1hL2tvbkFBMUY3emJWeEliRDlQVjZOQzRuWmdjd2plYXdV?=
 =?utf-8?B?Skd0UXhYQmN4VXIvY1NkLzU3SmN0RzdlRTBXM0tuck1LbThEb09lYkkrNUI4?=
 =?utf-8?B?WWJMSllmdDNoQzBCYmhNUzVNOXcyNG04VzNUMXVDMVIzdUkzT3owMHVDd2I1?=
 =?utf-8?B?d0FkaUxnVXQzek1yQ2JDdE1ScC9RRWUvclZBbHRNT3QzazdxSmNkaUo5Q2Zh?=
 =?utf-8?B?ZVlpMTBXL2NwSjFGWDBPbFhuc1V1c1FuZy9rbFJQUUlua0R2NnpYSXFpZ1lr?=
 =?utf-8?B?V0dZTE1nUjd6aGhXMHdWUXJmYllzM0lMUGd6S0dMZmQwU1dTUDFmaVYzSkJT?=
 =?utf-8?B?dm1iaXIxK1BVWHhKVHRZNkUvdUxaTnhGWUE4MXpKbXBXKzdadDdQWVlIODFI?=
 =?utf-8?B?MHlJRWZUN1FlZ2RlWm9XK2gyalhTaU82OWRHSUxxTk90RkdmWFowZ0llWVJR?=
 =?utf-8?B?cU41T2hwM2h0dkhwemNyckZhNlo0OSs5Y3FoQUNXMDExWlduYXhhRGJsYWJq?=
 =?utf-8?B?Y1Noa2R0djdDWEtvY09FbnhNWGFISTZhTkRLR0cvRkVhdG56cDg1aHlNQU03?=
 =?utf-8?B?UW9yOHdmMEV3NzRmQVUxOE5RN040MWh4cmZ0bVVUb3VWcVdaSDU2MVRDSXJQ?=
 =?utf-8?B?T0RlUDkxMmZ3TDRvTlNhMm55MUJMVGtaSFNHVEYreUpEZFJJL1U5UFZNVzBI?=
 =?utf-8?B?cGFQUGZPL0ZFanZsWStVLzk3dE5XQ2Z1cTRRQlVpYVI5dW1xeDdENUFoY3Fz?=
 =?utf-8?B?Rk9RMGsxSFRlL0FWU3J4eGJ6M1FYZjV0UVdEeTRBMFJNZ3RJVjZ0TzJxdTN6?=
 =?utf-8?B?dzBTbXJpQzI0VTFrTllERkZSMDIxelRRb0lOUlg2ZGRHLzlRSHljR0d3NVdr?=
 =?utf-8?Q?O7GEwd6MqVrF68aOXNIO9Pgpx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a3e0170-ff63-414f-815d-08da5f54a4e2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 13:37:17.7513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSLf9Vkol7QEbwW2ga/H3IZYAJjfQL7lKE6AXoi6x1XNq/ZdByP36sr670+RIrZa03jhukKsGkl7yDMPYZ/qOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0059
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

On 7/6/2022 1:12 PM, Christoph Hellwig wrote:
> Many of the mdev drivers use a simple counter for keeping track of the
> available instances. Move this code to the core code and store the counter
> in the mdev_parent. Implement it using correct locking, fixing mdpy.
> 
> Drivers just provide the value in the mdev_driver at registration time
> and the core code takes care of maintaining it and exposing the value in
> sysfs.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> [count instances per-parent instead of per-type]
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/s390/cio/vfio_ccw_drv.c       |  1 -
>   drivers/s390/cio/vfio_ccw_ops.c       | 14 +-------------
>   drivers/s390/cio/vfio_ccw_private.h   |  2 --
>   drivers/s390/crypto/vfio_ap_ops.c     | 21 +++------------------
>   drivers/s390/crypto/vfio_ap_private.h |  2 --
>   drivers/vfio/mdev/mdev_core.c         | 18 +++++++++++++++---
>   include/linux/mdev.h                  |  3 +++
>   samples/vfio-mdev/mdpy.c              | 23 ++++-------------------
>   8 files changed, 26 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 750d0315f1f5b..449c76b29a3b5 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -149,7 +149,6 @@ static struct vfio_ccw_private *vfio_ccw_alloc_private(struct subchannel *sch)
>   	INIT_LIST_HEAD(&private->crw);
>   	INIT_WORK(&private->io_work, vfio_ccw_sch_io_todo);
>   	INIT_WORK(&private->crw_work, vfio_ccw_crw_todo);
> -	atomic_set(&private->avail, 1);
>   
>   	private->cp.guest_cp = kcalloc(CCWCHAIN_LEN_MAX, sizeof(struct ccw1),
>   				       GFP_KERNEL);
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 6f6a0f2695059..c05d80add7be2 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -70,13 +70,6 @@ static int vfio_ccw_mdev_notifier(struct notifier_block *nb,
>   	return NOTIFY_DONE;
>   }
>   
> -static unsigned int vfio_ccw_get_available(struct mdev_type *mtype)
> -{
> -	struct vfio_ccw_private *private = dev_get_drvdata(mtype->parent->dev);
> -
> -	return atomic_read(&private->avail);
> -}
> -
>   static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   {
>   	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
> @@ -85,9 +78,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   	if (private->state == VFIO_CCW_STATE_NOT_OPER)
>   		return -ENODEV;
>   
> -	if (atomic_dec_if_positive(&private->avail) < 0)
> -		return -EPERM;
> -
>   	memset(&private->vdev, 0, sizeof(private->vdev));
>   	vfio_init_group_dev(&private->vdev, &mdev->dev,
>   			    &vfio_ccw_dev_ops);
> @@ -108,7 +98,6 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
>   
>   err_atomic:
>   	vfio_uninit_group_dev(&private->vdev);
> -	atomic_inc(&private->avail);
>   	private->mdev = NULL;
>   	private->state = VFIO_CCW_STATE_IDLE;
>   	return ret;
> @@ -135,7 +124,6 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
>   	vfio_uninit_group_dev(&private->vdev);
>   	cp_free(&private->cp);
>   	private->mdev = NULL;
> -	atomic_inc(&private->avail);
>   }
>   
>   static int vfio_ccw_mdev_open_device(struct vfio_device *vdev)
> @@ -613,6 +601,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
>   
>   struct mdev_driver vfio_ccw_mdev_driver = {
>   	.device_api = VFIO_DEVICE_API_CCW_STRING,
> +	.max_instances = 1,
>   	.driver = {
>   		.name = "vfio_ccw_mdev",
>   		.owner = THIS_MODULE,
> @@ -620,7 +609,6 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   	},
>   	.probe = vfio_ccw_mdev_probe,
>   	.remove = vfio_ccw_mdev_remove,
> -	.get_available = vfio_ccw_get_available,
>   };
>   
>   int vfio_ccw_mdev_reg(struct subchannel *sch)
> diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
> index b7163bac8cc75..9be5baed0cb7f 100644
> --- a/drivers/s390/cio/vfio_ccw_private.h
> +++ b/drivers/s390/cio/vfio_ccw_private.h
> @@ -72,7 +72,6 @@ struct vfio_ccw_crw {
>    * @sch: pointer to the subchannel
>    * @state: internal state of the device
>    * @completion: synchronization helper of the I/O completion
> - * @avail: available for creating a mediated device
>    * @mdev: pointer to the mediated device
>    * @nb: notifier for vfio events
>    * @io_region: MMIO region to input/output I/O arguments/results
> @@ -96,7 +95,6 @@ struct vfio_ccw_private {
>   	struct subchannel	*sch;
>   	int			state;
>   	struct completion	*completion;
> -	atomic_t		avail;
>   	struct mdev_device	*mdev;
>   	struct notifier_block	nb;
>   	struct ccw_io_region	*io_region;
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index edeec11c56560..69ed88fdaf383 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -461,14 +461,9 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>   	struct ap_matrix_mdev *matrix_mdev;
>   	int ret;
>   
> -	if ((atomic_dec_if_positive(&matrix_dev->available_instances) < 0))
> -		return -EPERM;
> -
>   	matrix_mdev = kzalloc(sizeof(*matrix_mdev), GFP_KERNEL);
> -	if (!matrix_mdev) {
> -		ret = -ENOMEM;
> -		goto err_dec_available;
> -	}
> +	if (!matrix_mdev)
> +		return -ENOMEM;
>   	vfio_init_group_dev(&matrix_mdev->vdev, &mdev->dev,
>   			    &vfio_ap_matrix_dev_ops);
>   
> @@ -491,8 +486,6 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>   	mutex_unlock(&matrix_dev->lock);
>   	vfio_uninit_group_dev(&matrix_mdev->vdev);
>   	kfree(matrix_mdev);
> -err_dec_available:
> -	atomic_inc(&matrix_dev->available_instances);
>   	return ret;
>   }
>   
> @@ -508,12 +501,6 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	mutex_unlock(&matrix_dev->lock);
>   	vfio_uninit_group_dev(&matrix_mdev->vdev);
>   	kfree(matrix_mdev);
> -	atomic_inc(&matrix_dev->available_instances);
> -}
> -
> -static unsigned int vfio_ap_mdev_get_available(struct mdev_type *mtype)
> -{
> -	return atomic_read(&matrix_dev->available_instances);
>   }
>   
>   struct vfio_ap_queue_reserved {
> @@ -1427,6 +1414,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
>   
>   static struct mdev_driver vfio_ap_matrix_driver = {
>   	.device_api = VFIO_DEVICE_API_AP_STRING,
> +	.max_instances = MAX_ZDEV_ENTRIES_EXT,
>   	.driver = {
>   		.name = "vfio_ap_mdev",
>   		.owner = THIS_MODULE,
> @@ -1435,15 +1423,12 @@ static struct mdev_driver vfio_ap_matrix_driver = {
>   	},
>   	.probe = vfio_ap_mdev_probe,
>   	.remove = vfio_ap_mdev_remove,
> -	.get_available = vfio_ap_mdev_get_available,
>   };
>   
>   int vfio_ap_mdev_register(void)
>   {
>   	int ret;
>   
> -	atomic_set(&matrix_dev->available_instances, MAX_ZDEV_ENTRIES_EXT);
> -
>   	ret = mdev_register_driver(&vfio_ap_matrix_driver);
>   	if (ret)
>   		return ret;
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 5dc5050d03791..b808b343b771f 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -28,7 +28,6 @@
>    * struct ap_matrix_dev - Contains the data for the matrix device.
>    *
>    * @device:	generic device structure associated with the AP matrix device
> - * @available_instances: number of mediated matrix devices that can be created
>    * @info:	the struct containing the output from the PQAP(QCI) instruction
>    * @mdev_list:	the list of mediated matrix devices created
>    * @lock:	mutex for locking the AP matrix device. This lock will be
> @@ -40,7 +39,6 @@
>    */
>   struct ap_matrix_dev {
>   	struct device device;
> -	atomic_t available_instances;
>   	struct ap_config_info info;
>   	struct list_head mdev_list;
>   	struct mutex lock;
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 93f8caf2e5f77..9bc897235c492 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -70,6 +70,7 @@ int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>   	parent->mdev_driver = mdev_driver;
>   	parent->types = types;
>   	parent->nr_types = nr_types;
> +	parent->available_instances = mdev_driver->max_instances;
>   
>   	if (!mdev_bus_compat_class) {
>   		mdev_bus_compat_class = class_compat_register("mdev_bus");
> @@ -115,14 +116,17 @@ EXPORT_SYMBOL(mdev_unregister_parent);
>   static void mdev_device_release(struct device *dev)
>   {
>   	struct mdev_device *mdev = to_mdev_device(dev);
> -
> -	/* Pairs with the get in mdev_device_create() */
> -	kobject_put(&mdev->type->kobj);
> +	struct mdev_parent *parent = mdev->type->parent;
>   
>   	mutex_lock(&mdev_list_lock);
>   	list_del(&mdev->next);
> +	if (!parent->mdev_driver->get_available)
> +		parent->available_instances++;
>   	mutex_unlock(&mdev_list_lock);
>   
> +	/* Pairs with the get in mdev_device_create() */
> +	kobject_put(&mdev->type->kobj);
> +
>   	dev_dbg(&mdev->dev, "MDEV: destroying\n");
>   	kfree(mdev);
>   }
> @@ -144,6 +148,14 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
>   		}
>   	}
>   
> +	if (!drv->get_available) {
> +		if (!parent->available_instances) {
> +			mutex_unlock(&mdev_list_lock);
> +			return -EUSERS;
> +		}
> +		parent->available_instances--;
> +	}
> +
>   	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
>   	if (!mdev) {
>   		mutex_unlock(&mdev_list_lock);
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index dc38ad2b07883..641ed18a61247 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -45,6 +45,7 @@ struct mdev_parent {
>   	struct rw_semaphore unreg_sem;
>   	struct mdev_type **types;
>   	unsigned int nr_types;
> +	unsigned int available_instances;
>   };
>   
>   static inline struct mdev_device *to_mdev_device(struct device *dev)
> @@ -55,6 +56,7 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
>   /**
>    * struct mdev_driver - Mediated device driver
>    * @device_api: string to return for the device_api sysfs
> + * @max_instances: maximum number of instances supported (optional)
>    * @probe: called when new device created
>    * @remove: called when device removed
>    * @get_available: Return the max number of instances that can be created
> @@ -63,6 +65,7 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
>    **/
>   struct mdev_driver {
>   	const char *device_api;
> +	unsigned int max_instances;
>   	int (*probe)(struct mdev_device *dev);
>   	void (*remove)(struct mdev_device *dev);
>   	unsigned int (*get_available)(struct mdev_type *mtype);
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 250b7ea2df2e4..7f7ac5491407e 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -42,11 +42,6 @@
>   
>   MODULE_LICENSE("GPL v2");
>   
> -static int max_devices = 4;
> -module_param_named(count, max_devices, int, 0444);
> -MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
> -
> -
>   #define MDPY_TYPE_1 "vga"
>   #define MDPY_TYPE_2 "xga"
>   #define MDPY_TYPE_3 "hd"
> @@ -93,7 +88,6 @@ static struct class	*mdpy_class;
>   static struct cdev	mdpy_cdev;
>   static struct device	mdpy_dev;
>   static struct mdev_parent mdpy_parent;
> -static u32		mdpy_count;
>   static const struct vfio_device_ops mdpy_dev_ops;
>   
>   /* State of each mdev device */
> @@ -234,9 +228,6 @@ static int mdpy_probe(struct mdev_device *mdev)
>   	u32 fbsize;
>   	int ret;
>   
> -	if (mdpy_count >= max_devices)
> -		return -ENOMEM;
> -
>   	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
>   	if (mdev_state == NULL)
>   		return -ENOMEM;
> @@ -265,8 +256,6 @@ static int mdpy_probe(struct mdev_device *mdev)
>   	mdpy_create_config_space(mdev_state);
>   	mdpy_reset(mdev_state);
>   
> -	mdpy_count++;
> -
>   	ret = vfio_register_emulated_iommu_dev(&mdev_state->vdev);
>   	if (ret)
>   		goto err_mem;
> @@ -293,8 +282,6 @@ static void mdpy_remove(struct mdev_device *mdev)
>   	kfree(mdev_state->vconfig);
>   	vfio_uninit_group_dev(&mdev_state->vdev);
>   	kfree(mdev_state);
> -
> -	mdpy_count--;
>   }
>   
>   static ssize_t mdpy_read(struct vfio_device *vdev, char __user *buf,
> @@ -658,11 +645,6 @@ static ssize_t mdpy_show_description(struct mdev_type *mtype, char *buf)
>   		       type->width, type->height);
>   }
>   
> -static unsigned int mdpy_get_available(struct mdev_type *mtype)
> -{
> -	return max_devices - mdpy_count;
> -}
> -
>   static const struct vfio_device_ops mdpy_dev_ops = {
>   	.read = mdpy_read,
>   	.write = mdpy_write,
> @@ -672,6 +654,7 @@ static const struct vfio_device_ops mdpy_dev_ops = {
>   
>   static struct mdev_driver mdpy_driver = {
>   	.device_api = VFIO_DEVICE_API_PCI_STRING,
> +	.max_instances = 4,
>   	.driver = {
>   		.name = "mdpy",
>   		.owner = THIS_MODULE,
> @@ -680,7 +663,6 @@ static struct mdev_driver mdpy_driver = {
>   	},
>   	.probe = mdpy_probe,
>   	.remove	= mdpy_remove,
> -	.get_available = mdpy_get_available,
>   	.show_description = mdpy_show_description,
>   };
>   
> @@ -757,5 +739,8 @@ static void __exit mdpy_dev_exit(void)
>   	mdpy_class = NULL;
>   }
>   
> +module_param_named(count, mdpy_driver.max_instances, int, 0444);
> +MODULE_PARM_DESC(count, "number of " MDPY_NAME " devices");
> +
>   module_init(mdpy_dev_init)
>   module_exit(mdpy_dev_exit)
