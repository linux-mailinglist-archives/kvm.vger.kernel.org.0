Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052C1321DAB
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 18:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhBVRCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 12:02:50 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13222 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhBVRCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 12:02:41 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6033e3850000>; Mon, 22 Feb 2021 09:01:57 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 17:01:56 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 22 Feb 2021 17:01:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EbiewWYlwEFOJntoGDTERhWN3nJQoZWACV/cvA6rH/qQtdtLSltslN0YAPI+8fcjb4qeL66HSmhoniKIamFWdXUSE1S6UmcjLBz0Hl92OU+Wg1DoiNZMn/TnKpa9ETI6xmJ4HnKVjUNCMPvH5a5czWVNCycf5ytuk9LhTk4u/0OkQgkUTJ6+t0F/c680HvC0vr49JaknmkgO6p5hcb1n7yfR8qd1YnLUd0kp96gFHGj9mNGPsFnc46kMf0F4ZE1aPDs33vSo5Ecl0BjBwomT0hscydw7+/01jDmuEU/qKUqH9hnpgX0GjgZ63wKYHTZk8vcE+3q6ywdyROx1JjZ8Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h67s1nCfBtDwpKvUhdWEc7st7LyoX4JctSC/I5x922w=;
 b=KKnpEDdYmxgtdOEcOjN+ItQyXRhjBSjBOlSosB42xrlLjy6H+4Cn5cLGWNB5e6EOlJDer0kLqBfYUQLRuB2JGypk2gBGAY6I9ovaqXztdlt5i6drWWKvmWN0zOPj6SB0NZBbeBB6gDX7m2PYwFlQ6vNspVxfSStyXcYGkSK9OjziwOZbbOOO4l+BMQMzRd9+7XM5+nBWo5tCwkvu70g88XmrFWku0CmJHtvbctKreDoI1eKYMoW29a5Xp18/Ag8GU2zyX3fk5vU/kol/VB8U6OanCf2TW6NBd0jcOiyaQEP+u/mZwrAtNnG8A9Zg/ys9UpH57G+vpKWarzCBl+BIgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4041.namprd12.prod.outlook.com (2603:10b6:5:210::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Mon, 22 Feb
 2021 17:01:55 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.045; Mon, 22 Feb 2021
 17:01:55 +0000
Date:   Mon, 22 Feb 2021 13:01:53 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 02/10] vfio: Update vfio_add_group_dev() API
Message-ID: <20210222170153.GN4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
 <161401264735.16443.5908636631567017543.stgit@gimli.home>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <161401264735.16443.5908636631567017543.stgit@gimli.home>
X-ClientProxiedBy: BL0PR02CA0079.namprd02.prod.outlook.com
 (2603:10b6:208:51::20) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0079.namprd02.prod.outlook.com (2603:10b6:208:51::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 17:01:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEEan-00ESBi-Lp; Mon, 22 Feb 2021 13:01:53 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614013317; bh=h67s1nCfBtDwpKvUhdWEc7st7LyoX4JctSC/I5x922w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=loP4zRplp7W9Jfgtpvtr4qx8jC+35NBLclUD+ahvWaThi9SdZ4T2MsEDEDvFhbwY8
         U3e539azYOWUPYcOw0BdsT3JAF6SZ6AeeQk5BYc2XTGIurJqqRheDI9JhtP2DJyz1w
         SapfXS+UP4HSEuJjZ2K8cGltJ0FDkBbCTroEtpHksDEEhZo+AXQfE6uGO2kRjUIswq
         1yYgu++v9ZJfeC2QCJSoiYGnR+HCz7bNN3r0D3eeNcXdrr1fl4lj5LkhBF0DssnM3v
         Riu9KExT/QLRBf2smbnNYbEkSQwN6xvER4l8eT6VkU4+Cv3lmpXmKeATKjEO8iPWPO
         ldN71RQy39VjA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 22, 2021 at 09:50:47AM -0700, Alex Williamson wrote:
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 464caef97aff..067cd843961c 100644
> +++ b/drivers/vfio/vfio.c
> @@ -848,8 +848,9 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
>  /**
>   * VFIO driver API
>   */
> -int vfio_add_group_dev(struct device *dev,
> -		       const struct vfio_device_ops *ops, void *device_data)
> +struct vfio_device *vfio_add_group_dev(struct device *dev,
> +				       const struct vfio_device_ops *ops,
> +				       void *device_data)
>  {
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> @@ -857,14 +858,14 @@ int vfio_add_group_dev(struct device *dev,
>  
>  	iommu_group = iommu_group_get(dev);
>  	if (!iommu_group)
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
>  
>  	group = vfio_group_get_from_iommu(iommu_group);
>  	if (!group) {
>  		group = vfio_create_group(iommu_group);
>  		if (IS_ERR(group)) {
>  			iommu_group_put(iommu_group);
> -			return PTR_ERR(group);
> +			return (struct vfio_device *)group;

Use ERR_CAST() here

Also, I've wrote a small series last week that goes further than this,
I made 'struct vfio_device *' the universal handle to refer to the
device, instead of using 'void *' or 'struct device *' as a surrogate.

It is interesting that you hit on the same issue as a blocker to this
series. So for I've found quite a few other things that are out of
sorts because of this.

Cheers,
Jason
