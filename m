Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27B130CA89
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 19:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238966AbhBBSwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 13:52:32 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13876 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbhBBSvC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:51:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60199eed0001>; Tue, 02 Feb 2021 10:50:21 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 2 Feb
 2021 18:50:21 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.53) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 2 Feb 2021 18:50:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYTpHdhAbusqqC6X9Vxe0bynyZ/89M1oQdkHNg6pNb8N2BXyYRlvRlkUW3azfnoNGF5zAB385RvYuvXvvA0aZzdA+rPj9bupmk4lYLN9bU2wBHZchdXFB/p2wPnr+yHPAZ0/1tTg/EDsx+BJP1Ye8sB6oRvJqBWuwraZvr8xPPszDBEjunYnnPqw7V0L4wEN+XB4+cIspDZIibm+xr1LiBYRqrJekFZmgBfOrZp8OwGv+GhJKekP+GEdmvBD9oLxadWI83vLOLCIob0sjPAJryoeov5XD/ENPimplsDAE3ndM2QqkX4JOF8WBfI1QSOMdTATxUe+aGI8HwhlSwoiwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gkex7vMQ9zhR87q+WItG6ZF9m882RbP6Z14016bkLEg=;
 b=HGlwZQoMWfTG2In5M6g8ia4cki9MWEBXN84/+4ePNivZjMTyR+RsLK/OxueTlNvWnKxF1JVhIfjzIMx94go5N85QxqyzeymCqFRUtF2yGUSPGqEXY1qwYVoAbtPFhsYyRt+w/XfKhDDdda2ir/1K7EAK17cyVdDY3a2W9+eZfX6DAm2JAfX7UDLzxztGrc9UyQvGfWhJg7kB0tJJnntBNRFKlEyrRot1p9Und5xxUc+QUmJr7mNGVqqT3lKauK7ie3P1yqPTv6V6jcVNkNLtHx2gbEuUzM1lIClsayHnVdSxG5WyzVQG1E0cCkUcgDo6CDvjorSq+g+7sg/od2IyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2860.namprd12.prod.outlook.com (2603:10b6:5:186::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.27; Tue, 2 Feb
 2021 18:50:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Tue, 2 Feb 2021
 18:50:19 +0000
Date:   Tue, 2 Feb 2021 14:50:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <aik@ozlabs.ru>
Subject: Re: [PATCH 8/9] vfio/pci: use x86 naming instead of igd
Message-ID: <20210202185017.GZ4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
 <20210201162828.5938-9-mgurtovoy@nvidia.com>
 <20210201181454.22112b57.cohuck@redhat.com>
 <599c6452-8ba6-a00a-65e7-0167f21eac35@linux.ibm.com>
 <20210201114230.37c18abd@omen.home.shazbot.org>
 <20210202170659.1c62a9e8.cohuck@redhat.com>
 <a413334c-3319-c6a3-3d8a-0bb68a10b9c1@nvidia.com>
 <20210202105455.5a358980@omen.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202105455.5a358980@omen.home.shazbot.org>
X-ClientProxiedBy: MN2PR01CA0005.prod.exchangelabs.com (2603:10b6:208:10c::18)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0005.prod.exchangelabs.com (2603:10b6:208:10c::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 2 Feb 2021 18:50:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l70kj-002hMr-AG; Tue, 02 Feb 2021 14:50:17 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612291821; bh=Gkex7vMQ9zhR87q+WItG6ZF9m882RbP6Z14016bkLEg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=M8OQXT0CbAJAqNPOeUyKtTZmPEzTEpEDLETTVNEh4EJjbvak/auTXe7kGhOwrFTyp
         nawGPT1dUvHhk6jdeN4T80hTYg24VS9k+cMcS+QuRUCaSrGOVvVz122W3rPlIr4flP
         stnb+8G5F+iocaCuUyonNwfeLbBH8g/CKvDAuuIDkdrA4uYvtQvVGOaAv6PhySy0UL
         qKYVTgWnq0itrYYoTc7WF1fx7XEdQGRfWT5JaIpLubeAdrMTkofaiqrz5LaWXo8gwj
         lVj2kGsHEvKBmFZR3I4sb/z5/cy0Z0h/zJ2KnoKfGQziheneT5E/0purYGKgqznuXD
         y/KGTBIS64a3Q==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021 at 10:54:55AM -0700, Alex Williamson wrote:

> As noted previously, if we start adding ids for vfio drivers then we
> create conflicts with the native host driver.  We cannot register a
> vfio PCI driver that automatically claims devices.

We can't do that in vfio_pci.ko, but a nvlink_vfio_pci.ko can, just
like the RFC showed with the mlx5 example. The key thing is the module
is not autoloadable and there is no modules.alias data for the PCI
IDs.

The admin must explicitly load the module, just like the admin must
explicitly do "cat > new_id". "modprobe nvlink_vfio_pci" replaces
"newid", and preloading the correct IDs into the module's driver makes
the entire admin experience much more natural and safe.

This could be improved with some simple work in the driver core:

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 2f32f38a11ed0b..dc3b088ad44d69 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -828,6 +828,9 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	bool async_allowed;
 	int ret;
 
+	if (drv->flags & DRIVER_EXPLICIT_BIND_ONLY)
+		continue;
+
 	ret = driver_match_device(drv, dev);
 	if (ret == 0) {
 		/* no match */

Thus the match table could be properly specified, but only explicit
manual bind would attach the driver. This would cleanly resolve the
duplicate ID problem, and we could even set a wildcard PCI match table
for vfio_pci and eliminate the new_id part of the sequence.

However, I'd prefer to split any driver core work from VFIO parts - so
I'd propose starting by splitting to vfio_pci_core.ko, vfio_pci.ko,
nvlink_vfio_pci.ko, and igd_vfio_pci.ko working as above.

For uAPI compatability vfio_pci.ko would need some
request_module()/symbol_get() trick to pass control over to the device
specific module.

Jason
