Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7584D69F005
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 09:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjBVITh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 03:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjBVITg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 03:19:36 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020E3B77A;
        Wed, 22 Feb 2023 00:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677053975; x=1708589975;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=TGkVBNbjG5YFA7Y24aWGH+/0Cpn5JiZtdDRgqvH6eYo=;
  b=KasK0hkj/CzopBTqZUHr2SERh9+mRTGI0DKb9mulqY7BXuxsUCULkwud
   iPOliVY0//uLx6a3YyGkEpIGqJNTTZHGJQFYkihwrJAEkVp1bau3Yesfu
   mleACh8pBtL4hGWfSiRFZGNWTTkrLv1K0jQVf3E+20LRFVPmXAZX8MINE
   VOIm4MQ7LfjoqdwbsoYhb5PjFC7hwiaF+C510vp8IAnk8Xxvw52IjHAUj
   tLUWrLHTSSvmn/zcmzquPKikHqahvXtaFBHCqbg4Nuh4F5bgUIhDTRGGh
   1JDB+ho5uqf5FssEsBbSFgst+djtcMPYX1hSQ3JhgITW2nJzyN6rQzzJL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="330591891"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="330591891"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 00:19:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="846035332"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="846035332"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 22 Feb 2023 00:19:33 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 22 Feb 2023 00:19:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 22 Feb 2023 00:19:33 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 22 Feb 2023 00:19:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C//2eTwyYLTaGnK5KN+gLPrVfNoZ9xPPX02DhOpb/Esu6oLLg7LQTrOoDggfHhLOpG3tiG6LPbDeJ1S7xcijGgGfqLvz7gg7teFGuJ3YceeuoxQDOr61mVw5GeYNbwE9OkX3FMmEDG/aahGfpwK+u2ducVbQuuqrCzF0EgIXe2dQZpS7C+jK9p17klvmLfTqn/xkwNHWKo19gvRmGZBWCTi5A5Srs+P2VtBh+gwbpdDNCtVKnt7OxG6cu0VaKUCOVJViOjujID52dUQ36+IEhJxaKDQb+J4UA+lfMcWRSGmjRK1eA3O6fd0X2A13aZSUoN/ixbeYod4IllPCxgIOpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRzXhnKbQp9iVrwn7Aq5gyxrTL9X+gySedgMk+zmoW0=;
 b=K9eRUFBnXXXrAdL7OlA8fMgREF9vJRiLobPZEXFoWBS0E5mwHv1tWSsobJjLNFYzL9BUXz1s2P4bpwKj4cpkkVa4shrFD4qfj2yL6LgYWzAlsU31NzDQzIx8YNGTTejJT8Hr2HgS2A8hVyk87lVhIj65SC2b4q8ElD3nEfVxJDzduw37hxK836cSYITC06E9y2AEnK2179K/y/ZmseVK0bbDs3V21mLSa5FVx/o58b3e88zoJbSyguJFagPFK6j2I/g6Eos2eisfrltbJ14b8Y7GZnl+7FnbpH6GeC9Bsqu3m3smVF0NkZtdTW4uG/4i0gcdhGh9IUgFdy47+CUHeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.19; Wed, 22 Feb 2023 08:19:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%6]) with mapi id 15.20.6111.019; Wed, 22 Feb 2023
 08:19:30 +0000
Date:   Wed, 22 Feb 2023 15:55:45 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <joro@8bytes.org>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <lulu@redhat.com>,
        <suravee.suthikulpanit@amd.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-s390@vger.kernel.org>,
        <xudong.hao@intel.com>, <terrence.xu@intel.com>
Subject: Re: [PATCH v4 07/19] vfio: Block device access via device fd until
 device is opened
Message-ID: <Y/XKgUSaa9Ld1e8/@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230221034812.138051-8-yi.l.liu@intel.com>
X-ClientProxiedBy: SG2PR06CA0208.apcprd06.prod.outlook.com
 (2603:1096:4:68::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6038:EE_
X-MS-Office365-Filtering-Correlation-Id: 00a05458-3108-4903-6ba7-08db14ad854a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cMEKqGblpnth+ouD2HFMIqVZ9l1EpfWPV0mhxYwI7HJwgk8RTDRgrCx87tQxUpaMFDTdAMPueUqOucY8AFZ3B547/rGAed9qtiWJntQFg2pzDKXw9Lb0JKhnjppfTF5kHxF0hZ3+nOh3AuMSrIASHvWb4QmdsjrxVBTGnaYzTxyuyWZZQIuYN7smTooC7tubYvlrvzjDjCmzH4hEzxdzB2G7Ho2UbM40vX3AKfneibZUSaw6ewPnwB35biBJecr9o1Qnqxpd0tIi8jxepC1UKg1nGi0H3b3G0bUpitTaPlKFqoiqOIeivnb/yxXe2exPL+tp4NlILivZ9ahP3M3CJER8r69SfsnkzlZ2XVs2iDPMDRfvzOS0qV2r0wgJ30e6liY0/pr8gr9V3PngWbHeQ7XOkALeHM9sjrwOQseUMYFCV1LNp9SxRxJBovCfvR7/QqeWSpNjP4ynxxmggRQhm+lEjqS8jpUL0aJtNEDKLUXhJAmcmHCTmxhzCNL3Vz8Hqu4urZQ7+UQYwpfs9xQX4VOpW8uSOGr2JkTHxkRBDA9eeJ7sbIDXeq1IK7c/xw2lzQi4+pIEI0g2f+KRf53HHM2bGfO0wlrNBhjUZHnk7e28k2d/SU8zVpXu3a6DJfm559zZTmChYuJtC13mxiGfPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199018)(66476007)(8676002)(66556008)(4326008)(6486002)(66946007)(7416002)(54906003)(316002)(6636002)(8936002)(41300700001)(86362001)(478600001)(6666004)(6506007)(38100700002)(186003)(6512007)(26005)(2906002)(3450700001)(5660300002)(82960400001)(6862004)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NifagzKAJvU/p+QdFtddbWHGFziHeyG8NlouquwYh/P5RZ1sGzfIfXHrbsCq?=
 =?us-ascii?Q?qs/HVJV+2Fb0q1Oqc6JIxNiN4tDNxT9ZNbxBp5wei7WDeXzgOPFFiKToUW12?=
 =?us-ascii?Q?1qDKHxDVVNf16hs1Uhll+8HzF7xBaCfowGKmSrATeNTNa32it4S9a2NzDnxJ?=
 =?us-ascii?Q?RqwcqO6Dn1fS9QeH3Vm+wlVA/5eimQnbkboaQuV2HK+JmHhv8UYjUlBobRHH?=
 =?us-ascii?Q?sGiXPGxXTcF5woGmSULJOF0UeCdLpcKzYyUa3xbc1a92PpphAOH1UsrqHCZt?=
 =?us-ascii?Q?/b32dAwnb/vDWDBQSgL11Uzjqn8AvlPfsW56SudS6QtSGJSMGgRRTCUDT+X2?=
 =?us-ascii?Q?UxFzIYBasaowpsdBYfpp8ziC4Mm5L7v6omyDDTYvkzZznMU2rTbQlSFbssRD?=
 =?us-ascii?Q?zYDvqW5R/n7DMjFAMHIARMtPNb/PWHmPrepz9lX9sdP+JWMuMGLToQcY2muC?=
 =?us-ascii?Q?JFuNKd3l2kQr/ncvv/S3ChZNpHeXQyO0yRjLliO8nX4s/GnUCuneFGWT87UF?=
 =?us-ascii?Q?K/0++juM19ndjcn4qsDvkFel3MLp1GaxvSqMFegtopHKDdvd7JPDJjGthsr/?=
 =?us-ascii?Q?ElMqEjxB+E+COoUZeYBrUq0hqBAdR9e+VCNeSJqwPjSrlZdyznqaAMN4z+Ww?=
 =?us-ascii?Q?CmW/PPK/D5FkqjrBCzzbLJVFHTdVQXqjtQ80+hWRW9uQPBHLZVcovZp9Ls0/?=
 =?us-ascii?Q?6uMAsH4U8vYCHchb0hKFAcYjuu7O3rFDpu4rwjRRZGExH+l452QOnyCSutKY?=
 =?us-ascii?Q?G2g8BqkSEYJayZay42St4mABmRtBJj+w2bUc10NrYX5tzu/w20jqENTVcWC6?=
 =?us-ascii?Q?aMqR1Cf2wabnSciXW44eJZy+kszpjZ9TuErkJBVWQuSevq8N/DId0BolS9n/?=
 =?us-ascii?Q?hO591z2/adIgFF/of7qwRWTwdq/civynjgpkWy//r1C58lCzqDNaUP/uzz7l?=
 =?us-ascii?Q?f2sFfuvVb2/RfbKga6XdLMJYGhTJ52LHtecCBy0prkFFlZp7c9UeJ8y1BE/Z?=
 =?us-ascii?Q?zdo+4IzAjNkZzPGxjpo06r5cs0Ayew9oPS1z9l6UlpeytU6YSXMAPjN8+VSm?=
 =?us-ascii?Q?1j9u4fXGnfl5TNj07seXKZGYj+AqKhJyXcqhj69iljEVXoi9cNTFe8IPe1++?=
 =?us-ascii?Q?3sGzlDrNoZjglyTgSySZwjp4iAUVomxCKbak6Rp+J6n6S0BBno8WQs9XDoq3?=
 =?us-ascii?Q?xbmOsSZCXez5v7k8OcJzQP5Knus3iAGAGRlVmzN4RILXQyQag0xd+bsrkFNI?=
 =?us-ascii?Q?e9w81F4UepCogMnhItsdqG0KpdRMzucjODDgnCXDDjerh97NbCaL6JCh9k/g?=
 =?us-ascii?Q?OCjv9p+A+j3HbnrCtnYThvG0+n6o7M9PKcE2/42REKyd/l0Qc60BPjzcOGwu?=
 =?us-ascii?Q?tEkii1qQ0NiSaN8v/htm+qNhDHSfu+78nnTY3MTCXb3qGrxoIUOFjQFSBGtE?=
 =?us-ascii?Q?/MbKUVDwOredXJsPeDq97uwBMF0cXk3BMNW/hfFRdJj82fUepdalgeiDdGd2?=
 =?us-ascii?Q?s0SX+R6Zsn6CK4sI1FQCnaGX3JOM1qfKfB2OhGElWVDorxT8/x3OCcLbR617?=
 =?us-ascii?Q?PWOWAwjZw3SrsQlesgHawV/OeUM6t2sLeecVmUPxZjc6YHsLR5WJVGuoNFo4?=
 =?us-ascii?Q?yw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 00a05458-3108-4903-6ba7-08db14ad854a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 08:19:30.3702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tgaQGHD70AnNRFseW8vmpB7AZQi1mavJW044a3Q9aQKDWowQNQSG/OxtpFy9zymxyNWDy+2Cg1vJSAz8QL6U+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6038
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 07:48:00PM -0800, Yi Liu wrote:
> Allow the vfio_device file to be in a state where the device FD is
> opened but the device cannot be used by userspace (i.e. its .open_device()
> hasn't been called). This inbetween state is not used when the device
> FD is spawned from the group FD, however when we create the device FD
> directly by opening a cdev it will be opened in the blocked state.
> 
> The reason for the inbetween state is that userspace only gets a FD but
> doesn't gain access permission until binding the FD to an iommufd. So in
> the blocked state, only the bind operation is allowed. Completing bind
> will allow user to further access the device.
> 
> This is implemented by adding a flag in struct vfio_device_file to mark
> the blocked state and using a simple smp_load_acquire() to obtain the
> flag value and serialize all the device setup with the thread accessing
> this device.
> 
> Following this lockless scheme, it can safely handle the device FD
> unbound->bound but it cannot handle bound->unbound. To allow this we'd
> need to add a lock on all the vfio ioctls which seems costly. So once
> device FD is bound, it remains bound until the FD is closed.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/group.c     |  6 ++++++
>  drivers/vfio/vfio.h      |  1 +
>  drivers/vfio/vfio_main.c | 16 ++++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 2abf55c69281..14e29525e354 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -197,6 +197,12 @@ static int vfio_device_group_open(struct vfio_device_file *df)
>  	if (device->open_count == 0)
>  		vfio_device_put_kvm(device);
>  
> +	/*
> +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> +	 * read/write/mmap
> +	 */
> +	smp_store_release(&df->access_granted, true);
> +
>  	mutex_unlock(&device->dev_set->lock);
>  
>  out_unlock:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 11e56fe079a1..d56cdb114024 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -18,6 +18,7 @@ struct vfio_container;
>  
>  struct vfio_device_file {
>  	struct vfio_device *device;
> +	bool access_granted;
>  	spinlock_t kvm_ref_lock; /* protect kvm field */
>  	struct kvm *kvm;
>  	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index ea507a61e3b7..91c8f25393db 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1106,6 +1106,10 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
>  	struct vfio_device *device = df->device;
>  	int ret;
>  
> +	/* Paired with smp_store_release() in vfio_device_open() */

Nit pick: not vfio_device_open() now :)

> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	ret = vfio_device_pm_runtime_get(device);
>  	if (ret)
>  		return ret;
> @@ -1133,6 +1137,10 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> +	/* Paired with smp_store_release() in vfio_device_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->read))
>  		return -EINVAL;
>  
> @@ -1146,6 +1154,10 @@ static ssize_t vfio_device_fops_write(struct file *filep,
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> +	/* Paired with smp_store_release() in vfio_device_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->write))
>  		return -EINVAL;
>  
> @@ -1157,6 +1169,10 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> +	/* Paired with smp_store_release() in vfio_device_open() */
> +	if (!smp_load_acquire(&df->access_granted))
> +		return -EINVAL;
> +
>  	if (unlikely(!device->ops->mmap))
>  		return -EINVAL;
>  
> -- 
> 2.34.1
> 
