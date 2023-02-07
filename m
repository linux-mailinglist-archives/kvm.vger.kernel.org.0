Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F5868CDE7
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 05:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBGEFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 23:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjBGEE7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 23:04:59 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC1293C2;
        Mon,  6 Feb 2023 20:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675742698; x=1707278698;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Y5m3MJaTP13Bt+o20BVDAqOZ8uXeF+XFs8lCuAY8Mso=;
  b=QDRdwk0ijizAQQ0OAZY8f2K9Ek5sh+nvZBJoUhWkt0e4+lFerha+a+5Y
   ZMf/3je1RATCZqScq0pBYbOIAm2XBMfjgO0ZQ7cLQN8k6xRuv/Kujm9SM
   G/w4P6vi9s0Kv085Vo+E0qXCyTaBnlcpKxhSaQXR3dlh8cBXY5pIwDRaV
   omin0SaTjFEridJHvPckJ6bEklhe8f15uaZDnGqto5YQi+dm9CRX9H3iM
   MTP4WZkFrEssPy8aWMxrJWA2gVogVQ1nCM6QG+fpXzlZFOBg0AmBGXUCi
   IUe6+XETEY9Nc8JGK+GeO13FQyWuo5S3CQ/gDIT7I5NU0I7fUxtMOKDKe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="327083624"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="327083624"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 20:04:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="755490066"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="755490066"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Feb 2023 20:04:56 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 6 Feb 2023 20:04:56 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 6 Feb 2023 20:04:56 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 6 Feb 2023 20:04:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSBiPm78+c8ZktiwJVoj0JbJhyaqgMQDjiqCiUjkeIsdFr31X+2yEiSwQ2EJFbYTgpjHFh69c5Si5EMxNERP89h/iUaOERfaugcDZvqM/aCyhpW5XTuUTybQHteSQFB5sY9tMXgv7c/IpRzfTad9MN3ENoTNtdArahiqnfVGYw4bzy7xtPuEnc8YBbHHARSWzzcF36lrEbL2GR9lqvbyVGigmcWAuKpfkos5Q2GCzHiw8UYdWpnJMXPwvuWZ9n6Ii2Ck2skvLHzzdPPcbd+Yovx0yXr31MfVWPWWkk5hhlZCVtLsUGjanocWY2tniqsp0zwKavumj3uOqfgAa3p+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lV9nTeuOsbeKqyQgs+6ivobIqZpblFqd0G3V4QzKMa4=;
 b=jNwODukDj+8XEKe3Bgw/6qUNkQEt/Q10ly8+70TStcykQPx7DxLkPuQU5oNciHEs7TPxYrDK61Mn3PeB2Qe0dctJjAX8BATSFPOfIGlB3VE0jA5nj+4yqlop/TCWJ5cJxMNTr0x7MsLCl/rB8FnmDeusNtCVynKeQjINLa3hVdZgeHT4OFg/x+bK01f5kbLSulRQCaB7uo3b0mraoAxWnlqt+MAGSmCMDJ1bksR6lAqPnAL+K2vPWRBs0udLuTZ93WXiAmVWmRkbp4QFIsPWXUpRBpTthM/8NTNO6dnWOGoIDIHfHaPUTDlwn74vM4SYYMM1VbnCx3tdhaQxh8QuiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7582.namprd11.prod.outlook.com (2603:10b6:806:31e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 04:04:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::82d2:d341:4138:17ef%8]) with mapi id 15.20.6064.032; Tue, 7 Feb 2023
 04:04:54 +0000
Date:   Tue, 7 Feb 2023 11:41:13 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Yi Liu <yi.l.liu@intel.com>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <kevin.tian@intel.com>, <linux-s390@vger.kernel.org>,
        <yi.y.sun@linux.intel.com>, <kvm@vger.kernel.org>,
        <mjrosato@linux.ibm.com>, <jasowang@redhat.com>,
        <cohuck@redhat.com>, <linux-kernel@vger.kernel.org>,
        <peterx@redhat.com>, <eric.auger@redhat.com>,
        <nicolinc@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <suravee.suthikulpanit@amd.com>, <chao.p.peng@linux.intel.com>,
        <lulu@redhat.com>, <intel-gvt-dev@lists.freedesktop.org>,
        <intel-gfx@lists.freedesktop.org>
Subject: Re: [PATCH v2 13/14] vfio: Add ioctls for device cdev using iommufd
Message-ID: <Y+HIWRM/TjWcuT6I@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230206090532.95598-1-yi.l.liu@intel.com>
 <20230206090532.95598-14-yi.l.liu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230206090532.95598-14-yi.l.liu@intel.com>
X-ClientProxiedBy: SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7582:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bb99a40-11fb-4e0b-996f-08db08c077dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzESgseA0znjDwYMGvs1Ya0t/i2YeRIfp2USB9W2BU+KrRalAn0hAX/bIizMnqFNsU1QCnEcu0S9wpGFCAOpvAa8x0C4gbMWwSJB9Tn7bmUUemPeo8zyUAh1QOy4PrN46QxWdv3AUB2upzXxocIkdE8gN0hvsPtgUqeyqw9zzEEQshvs/LtNq7W/Ckim/pz4lsOf0WJr2yaTnAZ/0rgftT/mjr0bBpeM9D7QbzVFF4npmplf7TsUMCd7mVVakZb3+KZJLcNyeJO6ilK1U+n1MukwBAUFbgVm/y0/uqv9XpHxFjTDQcAMhCoMXUQmeLhvNOKbQlwLmBWSH0nVEQuQ0Hg83z9bUoozbhezCXgUacYylqVxrdvfjH2Z2dYJgBiZ0ADKTzfehglUWTtYTiaeXNIUCIyEsR9CfEVlpxoEyxE14cV2nXF9r0JjWHhUajBuX2SUHY8d5cqVTXym7EfSr4xZFJHT3Is8eMgcJKxGsm9giC7/bG8XtaFwIGRKxBorqfrCXZME9DWPe1jQELfXcecnr58HEqqE5ZghMDi9eMXB0BEzLskTWkQEc20rjNFYCt8tCGtTFhOUahPW2bGSLuHzWqpBB/d0hRT+hVPaptdZnMV6u6f7Z7A/XzxhdQipKzB3nsImCYd4wjIXll8gqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199018)(38100700002)(82960400001)(86362001)(41300700001)(4326008)(5660300002)(66476007)(66946007)(8676002)(8936002)(6862004)(316002)(6636002)(7416002)(3450700001)(2906002)(83380400001)(478600001)(6486002)(6666004)(6506007)(66556008)(186003)(26005)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKCmzgwGmE3ZSC+zzqKx5fRGGQ9vb/QJ1yNyXcFrz89sjyO+SKmcp2rOKtWP?=
 =?us-ascii?Q?9EZV7PRFokRw9n3cU+Xi4DHFAYKk3Oat/NKgX5NDv5BtIlQP6lSyCp06Q1Mg?=
 =?us-ascii?Q?2m+IyBNCjRXD9JGpoQBbM8pWsFQZ6DaEA/rGgaazsDxtjLwvt+vZOYY9arTE?=
 =?us-ascii?Q?EV4TLySPmRWtbeaq/EdF0hM0Phg+Qu2Eqf1/uk5vTd+Xae1fTcRc3i3bIDI4?=
 =?us-ascii?Q?9yy1lE8ldZ1Enb3+J2toWeJsPrbFIuFl2X2wvz7RbdhJ2a1H4dJBoAOXcM5v?=
 =?us-ascii?Q?RnYDKhm/H2iy+IgQzNGlwIkVzdgiPj0dnHsM0X4T+xjsP+A7AXShK/LpRA28?=
 =?us-ascii?Q?ViAuoO8Ce9/XeN50BBr04adn8chG3Bcv04KVDmbLXsjYThuoCbhmZVLt38+R?=
 =?us-ascii?Q?PNbcRNlTfuI1ZD5IBVs8YHcFY/1LdfQtKUywx6RPEuNeVtqYDG8Zk8aSzbHU?=
 =?us-ascii?Q?QaMfcRkEtLmxsH+0/1ZRbch4NncU1FdVmBgKqSlaUpBGQFv6MIbYOXHINXBW?=
 =?us-ascii?Q?VrpL6P8ItTdjDFR0yRhqhh4xXt7Gc1iIyIZ2Abnptfk5d1ZhbfHCoBV3vI2l?=
 =?us-ascii?Q?sQy6INDdrjYH2/GlkNle47iPvmaUt9TCBdJrrdmdCxKo26pqe7wKzf0E55Ws?=
 =?us-ascii?Q?MK/0k9GW60zpZt2xVYmyVAx0J/vsRVwi6gx8g+nKOIlQo97M+RCFE6T+u5x0?=
 =?us-ascii?Q?0Djvx7MrrxEOBOkszLiBZS3r7OuCalcd4WSPpSpz0jZ2kRG98iXUXKEsdqxN?=
 =?us-ascii?Q?IJsNkslKXS6k2RdabbkRJnQ7Z12Fdz5ve/bhU3JXxBf3IbLr4rMjlKS/g+dy?=
 =?us-ascii?Q?oFaUG8CRin8MJxu02D4OKAKPUe3y3N4Hm2Fch+UYj1GAIDTC5PIOgTtInZYt?=
 =?us-ascii?Q?uDPqbRrjlZMy1oUUME8XWC7TVTcHbPcPQcbWnmYnBW8A7otfkRNLXKJtFJvr?=
 =?us-ascii?Q?5zZOdSd1hH+cYsoML5qldWZSqgPkQObxQ+BhNfvXGIDkRSimVoE4U500GFiS?=
 =?us-ascii?Q?4FYvoVgZSwgzYJL/4BJnJn9tz8Kj/gjz0a/LtsA01tAb/jjDwDLGKS35kc8H?=
 =?us-ascii?Q?BFZ8MzikqwG5Jll/jmwVS54+1qRpfK8DfqiN13kcFkIYJdo6DiKte4qdlWHy?=
 =?us-ascii?Q?osjVAba3ZP9iK80q/O4sps5qiRKScrygearQsJdW3hIQ5q1kjZfxX5/CnG6z?=
 =?us-ascii?Q?aE4/oq4l4v+53M4YBNAVqkLspbDSSyB/qn5DFq9xNZc+MtlVhMHiWZQvpgF6?=
 =?us-ascii?Q?fbFUCQ/k/mVVpC5MtWQZfs3vMs0+qEDiP10vr8UiWSRzZhsa9PjxAZ1hi1fw?=
 =?us-ascii?Q?2w9Ey5or6P/QUesujWXqOWic1cnE73NH+y41h1B/WAf6BdjIJ6QRTG9l0f0u?=
 =?us-ascii?Q?buRY/4q4RxsNuTiXfEoOOfvSZ//s8JVqQA9W6bqFRnfJ6rdLH7nzoRaSchxj?=
 =?us-ascii?Q?5o6k4Tto84EMlU7JiCjL1YPBU2z1kK0uNJI1AdP95Ky/2FYhbQIbC0WT44oa?=
 =?us-ascii?Q?XDVz8eZtJvS3K2+7zEK0IoM7hDC2rwNXC1IVAzxdtIFh3Qt236Y3/eykpAkp?=
 =?us-ascii?Q?V1FihYpzwWikRbhrW32YvnAe2PDu9MJ1T0enq2g1OwOzWKWyOaNxGY2qISdF?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb99a40-11fb-4e0b-996f-08db08c077dd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 04:04:54.2842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NhKkEqzY9FE1XnLxeQDByz4ZXdLccCq7x/nSxJ+TULG6apAQn8HCzddOiEtN7UkGU7iWvQ3p+DFif32MhgXVyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7582
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 01:05:31AM -0800, Yi Liu wrote:
...

> +void vfio_device_cdev_close(struct vfio_device_file *df)
> +{
> +	mutex_lock(&df->device->dev_set->lock);
> +	vfio_device_close(df);
> +	vfio_device_put_kvm(df->device);
> +	mutex_unlock(&df->device->dev_set->lock);
> +}
> +

...

> +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> +				    unsigned long arg)
> +{
> +	struct vfio_device *device = df->device;
> +	struct vfio_device_bind_iommufd bind;
> +	struct iommufd_ctx *iommufd = NULL;
> +	unsigned long minsz;
> +	struct fd f;
> +	int ret;
> +
> +	minsz = offsetofend(struct vfio_device_bind_iommufd, iommufd);
> +
> +	if (copy_from_user(&bind, (void __user *)arg, minsz))
> +		return -EFAULT;
> +
> +	if (bind.argsz < minsz || bind.flags)
> +		return -EINVAL;
> +
> +	if (!device->ops->bind_iommufd)
> +		return -ENODEV;
> +
> +	mutex_lock(&device->dev_set->lock);
> +	/*
> +	 * If already been bound to an iommufd, or already set noiommu
> +	 * then fail it.
> +	 */
> +	if (df->iommufd || df->noiommu) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	/* iommufd < 0 means noiommu mode */
> +	if (bind.iommufd < 0) {
> +		if (!capable(CAP_SYS_RAWIO)) {
> +			ret = -EPERM;
> +			goto out_unlock;
> +		}
> +		df->noiommu = true;
> +	} else {
> +		f = fdget(bind.iommufd);
> +		if (!f.file) {
> +			ret = -EBADF;
> +			goto out_unlock;
> +		}
> +		iommufd = iommufd_ctx_from_file(f.file);
> +		if (IS_ERR(iommufd)) {
> +			ret = PTR_ERR(iommufd);
> +			goto out_put_file;
> +		}
> +	}
> +
> +	/*
> +	 * Before the first device open, get the KVM pointer currently
> +	 * associated with the device file (if there is) and obtain a
> +	 * reference. This reference is held until device closed. Save
> +	 * the pointer in the device for use by drivers.
> +	 */
> +	vfio_device_get_kvm_safe(df);
> +
> +	df->iommufd = iommufd;
> +	ret = vfio_device_open(df, &bind.out_devid, NULL);
> +	if (ret)
> +		goto out_put_kvm;
> +
> +	ret = copy_to_user((void __user *)arg + minsz,
> +			   &bind.out_devid,
> +			   sizeof(bind.out_devid)) ? -EFAULT : 0;
> +	if (ret)
> +		goto out_close_device;
> +
> +	if (iommufd)
> +		fdput(f);
> +	else if (df->noiommu)
> +		dev_warn(device->dev, "vfio-noiommu device used by user "
> +			 "(%s:%d)\n", current->comm, task_pid_nr(current));
> +	mutex_unlock(&device->dev_set->lock);
> +	return 0;
> +
> +out_close_device:
> +	vfio_device_close(df);
vfio_device_close() is called here if any error after vfio_device_open().
But it will also be called unconditionally in vfio_device_cdev_close() and
cause a wrong value of device->open_count.

df->access_granted in patch 07 can also be of wrong true value after
this vfio_device_close().


> +out_put_kvm:
> +	vfio_device_put_kvm(device);
> +out_put_file:
> +	if (iommufd)
> +		fdput(f);
> +out_unlock:
> +	df->iommufd = NULL;
> +	df->noiommu = false;
> +	mutex_unlock(&device->dev_set->lock);
> +	return ret;
> +}
> +
