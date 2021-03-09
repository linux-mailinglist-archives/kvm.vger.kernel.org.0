Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D457331BEA
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 01:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhCIArD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 19:47:03 -0500
Received: from mail-eopbgr700085.outbound.protection.outlook.com ([40.107.70.85]:5504
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229517AbhCIAqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 19:46:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwViTJxa6SdsU6ZoQ+wqbhQvkwdIFCPvU/DIrnmuOaU5BOxWBBnKlyNCpx3kKzsVgGWi4Oyrv07LZSUwCQEaafmC9yogDWHAYNY7ssQruDsPk1DTJLEOvFWoM7IQKK7bJdqvVLKyb7AXWSxc6B2ipKnJ56zy//ieUqukCrqwfQa8UY26O8B7seDtBGdFbVJHzbkrIYq1qspacGSAfWyAgld242pUk7j3DUOdDrcdxvZ8vnphBKb5ltNSFL+qDpA+Lypi1QAePWe8JzlcCiGuzwOjC28hJbJiD/VTxsTT55c+MfihQerN7CjdbJwyqXu55aEYancnMj4VITSNAkj8dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dElh83NjKEiMx6KlwaHTuMsHvuxVXhB5FxD9Y67tuGU=;
 b=Q2k8Dx6TWKkF05//Mh1GM7aWT/jwneZfa2kZSnsPbNr5CMQhF/21eKGMSyjBpjk4rEVd9OpdnDG3fgqacoh3Ait1MmyZ9Tn4qaZgfKRCS9ofN1w0viUhPdJiVncWGHmhlPF5VSbbXBmtIivc1Qhraxd0i/B94fe+OXhmRBye2kUIuxYTWu4wiOYiLFZwiEp511EEA2EtVHBruSlR1flDCCpxIryUT2M7V5x+8hsH718nZX+HOBM1/G3oX8YVqkUIHEtdH+8ftnWYKzPlvnzD2oh6SAQ5ua1VMPzbdp7ZBoQrKAzVtzMipKtLOazkBhBcqFVg3IjIVNeiPlpdBLjlNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dElh83NjKEiMx6KlwaHTuMsHvuxVXhB5FxD9Y67tuGU=;
 b=PWc5Jh0429ayZvTuxc8w1zLmv9Q257I748L6suhlUTn1Qk3hWXIqwlbT5siszi7HVbEOZItXcCeT3zNQqyosfiKWYe78bKO/k4PB6KQcPXJeeY2Ov9d8o5q4M5gZtitfL5RJYLiJDW85PANiTBfHiwMpyfz6gwbja3o78u7rveU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1658.namprd12.prod.outlook.com (2603:10b6:4:5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Tue, 9 Mar 2021 00:46:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 00:46:29 +0000
Date:   Mon, 8 Mar 2021 20:46:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 07/14] vfio: Add a device notifier interface
Message-ID: <20210309004627.GD4247@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524010999.3480.14282676267275402685.stgit@gimli.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524010999.3480.14282676267275402685.stgit@gimli.home>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0040.namprd20.prod.outlook.com
 (2603:10b6:208:235::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0040.namprd20.prod.outlook.com (2603:10b6:208:235::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 00:46:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJQW3-009si3-Dr; Mon, 08 Mar 2021 20:46:27 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a87b59af-dda4-491c-ec0c-08d8e294c681
X-MS-TrafficTypeDiagnostic: DM5PR12MB1658:
X-Microsoft-Antispam-PRVS: <DM5PR12MB165840C4AAB5A83BDEC9F6CBC2929@DM5PR12MB1658.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 03E+wYE9kpZvOckCLTKGgh3rLvbGC53MrT8E7M9na7hQZcBFtpYhUqTqh6En7elWdb/wzFNtf5LzW2AC8BXtC6MvIlkhGNaC+KX/ObhwFWgJettqtg5VXXDDtaSNzYTbKLuAW/X1DNB032pLCaY9J2mrgVSP5oNb3oiQcUWsDM3lbjcRHB96KGq/l0ewudyGamsMfIE75iffF7VniWt7Nu5S64EizrfY/Cri5jjuqrWDVbCmIChhvIlHOBEBg/Uf++/EA1KYsudhDPSeD4X+rZ66f9nt7IObt9E2LoxpkSgZcUV06zC9KUSSq2UYGZ/DVdhYrPwOIfZD5JH+veBHrar39f62OwV7sHA1ivgoXJKpzKxWeJKqi0lAC/x/XkoREH868ZEyzkUJWcXsCBlytsQq3I/ey7ADUTjDplvnTJFzzSu54I6kg1XoL2CC4d4TMj7u0XoZFz4l5UKWRUaHmP0YOWXAEZvovhL4J1H2kIuhmww4+DbobfpvqNeu34mKiMS+jzDXYIQc/aEZ0MQjGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(5660300002)(26005)(4326008)(66556008)(2616005)(6916009)(66946007)(66476007)(1076003)(478600001)(86362001)(186003)(2906002)(9746002)(8936002)(316002)(8676002)(426003)(9786002)(33656002)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6Qx39xUBYYjWtNgbRsI9w5bL8uZNxqx4KcxhzxlRn/RqyClmz1GoB8exFhqN?=
 =?us-ascii?Q?zk5tVwd2Z6Hb4iJvlD/jSJ7I8L4Z9oDj6pIDU8xiSsId6LBHdwJ+cDF3dUwA?=
 =?us-ascii?Q?OSommD9B/O29gkBCnQ2kk4huZXbU9bJqdjB7UTcIOvjW9xPcotdtdnsCGbd9?=
 =?us-ascii?Q?3ZG1KWOXgL1cdvtxkGcdQATID/YVHWc8QfRn5Kkra+87jCLMpKUCIhd6FOKP?=
 =?us-ascii?Q?LAfT6AnujRPc6lDiIsSR7lumpc52prZ4j06nawq3OpnpLMIbKT9irDycpsNM?=
 =?us-ascii?Q?whQ924ldJ+3HjzFN5Ne6nWWeuLp4fYYP8xepYl6ZATOgiZWMHq4nF44R+HAp?=
 =?us-ascii?Q?TS19Gkw2PmFqjOWy5vEaGxMQertnJX5YHuPTUf7yIROmIIsYAQWv69IAGgID?=
 =?us-ascii?Q?lo8QnUoBJqUxBrNbwOB+ZpH/LSUI603ZowhEUaSslGHQKXpZ9lM4iIKL2KbE?=
 =?us-ascii?Q?l31zyb6uAN6ueE3MxuhInVfQ93tB1hsj49s2UNwzMrxfevMnysI0rg+QQr1J?=
 =?us-ascii?Q?rCQgg1+TO1bpsQxegqNJ9/fzlDf1Z9mJ/XGrJmMqAAwH7PaE+PPgtGDk2a8w?=
 =?us-ascii?Q?yKqLs2d11lTYAa/AbLb3A9RPHgE++qpprg4gPbKoiUcRXbuRiFyrObJQ1opa?=
 =?us-ascii?Q?BQIxRD1Yvj+BYYU6eiui5oftzl44jd3aMfv/rYnvX/wtzvUoSWxLnmzUyFkN?=
 =?us-ascii?Q?4mFcW/HToHEDfZa8KbdbnB3wUCAvIzBHbYBjronvy7bpbE8e5XNeHh5WPobi?=
 =?us-ascii?Q?p+QIs33u0RbfwEtwboI7E+VydgAf8QaPj/lkYu1K8Fwh+72QJ6rnGjHBEW6J?=
 =?us-ascii?Q?pDo2c+7X3YNrxaFcal7nJ4Qk3ujJeCheWOIy/UEgNmEpx5/D9g+ewNnHZDW4?=
 =?us-ascii?Q?gIObXC4b5C1+T6kBjhkpW5ghJuQfcN06ZxVUk61Y6okDJOyhORRHXEtUn7Jc?=
 =?us-ascii?Q?7fsf0Hnf2PRHQeTHjSR7IONRp/RVdb17DumPCcDNIvGIMj5eonmIO4oqKyF6?=
 =?us-ascii?Q?I6vXOtRMw5pl9dMtDVgWNuo5iLtJlKSHoyzqoERpcuQU+f5PmBQRmtcRuPwZ?=
 =?us-ascii?Q?S4Ck4HE/D6hPm6fJPpxa/WJagWjVFf4DHUB4gWO9UW8wIepuJYoE/JMvSEm/?=
 =?us-ascii?Q?tmOVohznOpMlf6p1bMoxibOtpXbbOS5MjZFcaNTaMU5h9+heAsSWcZYkWzXP?=
 =?us-ascii?Q?nY5Je9r00Zc4OVJCGCGG0RSYp+FVzzBhHyWtaL/sYUR3l3WxgiDwu9A+zstq?=
 =?us-ascii?Q?3htUB8F630EZcjmPo27ndmelF0g05Lb11s3r8Rr4V3nQmUU0M7Fn8jLi2oMH?=
 =?us-ascii?Q?PCuUgkTrhAiqZrOrKldS7DLMzmsgX5JuX2TIVNaDQL0tqA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a87b59af-dda4-491c-ec0c-08d8e294c681
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 00:46:28.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBMYCsqA+TTH1rrH/4C8GrpeBX7Fp/Ys/v6+F3nQXZukqmO5/e3/4vXzmRgVT04+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1658
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:48:30PM -0700, Alex Williamson wrote:
> Using a vfio device, a notifier block can be registered to receive
> select device events.  Notifiers can only be registered for contained
> devices, ie. they are available through a user context.  Registration
> of a notifier increments the reference to that container context
> therefore notifiers must minimally respond to the release event by
> asynchronously removing notifiers.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>  drivers/vfio/Kconfig |    1 +
>  drivers/vfio/vfio.c  |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h |    9 +++++++++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 90c0525b1e0c..9a67675c9b6c 100644
> +++ b/drivers/vfio/Kconfig
> @@ -23,6 +23,7 @@ menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	select IOMMU_API
>  	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> +	select SRCU
>  	help
>  	  VFIO provides a framework for secure userspace device drivers.
>  	  See Documentation/driver-api/vfio.rst for more details.
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index c47895539a1a..7f6d00e54e83 100644
> +++ b/drivers/vfio/vfio.c
> @@ -105,6 +105,7 @@ struct vfio_device {
>  	struct list_head		group_next;
>  	void				*device_data;
>  	struct inode			*inode;
> +	struct srcu_notifier_head	notifier;
>  };
>  
>  #ifdef CONFIG_VFIO_NOIOMMU
> @@ -601,6 +602,7 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
>  	device->ops = ops;
>  	device->device_data = device_data;
>  	dev_set_drvdata(dev, device);
> +	srcu_init_notifier_head(&device->notifier);
>  
>  	/* No need to get group_lock, caller has group reference */
>  	vfio_group_get(group);
> @@ -1785,6 +1787,39 @@ static const struct file_operations vfio_device_fops = {
>  	.mmap		= vfio_device_fops_mmap,
>  };
>  
> +int vfio_device_register_notifier(struct vfio_device *device,
> +				  struct notifier_block *nb)
> +{
> +	int ret;
> +
> +	/* Container ref persists until unregister on success */
> +	ret =  vfio_group_add_container_user(device->group);

I'm having trouble guessing why we need to refcount the group to add a
notifier to the device's notifier chain? 

I suppose it actually has to do with the MMIO mapping? But I don't
know what the relation is between MMIO mappings in the IOMMU and the
container? This could deserve a comment?

> +void vfio_device_unregister_notifier(struct vfio_device *device,
> +				    struct notifier_block *nb)
> +{
> +	if (!srcu_notifier_chain_unregister(&device->notifier, nb))
> +		vfio_group_try_dissolve_container(device->group);
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_unregister_notifier);

Is the SRCU still needed with the new locking? With a cursory look I
only noticed this called under the reflck->lock ?

Jason
