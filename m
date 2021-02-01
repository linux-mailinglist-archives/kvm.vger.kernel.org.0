Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6172930AD9C
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 18:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhBARS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 12:18:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5880 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhBARSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 12:18:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601837bf0002>; Mon, 01 Feb 2021 09:17:51 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 17:17:50 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 17:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4oKwF9YPD6RyOhm82d81E4HpU8tC1rlGdPYmSb8PLh+kPWroBSa0yjOnaKdKnVIL2MvTQAXDe7u0mgm/tou+BrH37YIiNM/ykabq9z96MAjXk/3/Hc1WVVzCVTemlX6RF5bg7XfVrwUH47Q0Yu59pWdZfb10DJfDA+4t8izWGdNi+IGvm8IrDIDxNELlA+OjvA5iKK9JN00a+eGOCnjtkXm5h3noRDp8l6+R49ffA9/JvZrJT2mCcbUWji/Nqq7zKj8EKsgJA2zFXbvgLh9QiakY/VrzrbCJqEGfBlFxZjfOFT6W4KJC4p6Ct9Z7EM4ohcqDTdCsJ8fPTegzoqsLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zlDaeXvsMZLoS+zUxFll2TfKX6XsP7xgxfdq/RWusWg=;
 b=EZnES5LshsNNfKIF1k79IV8uwxFvARRigQi5hhvDzqklC3NPVL9hJji1+0LGgBTpbXsm6LBCNTGYv9GwoVUiW+ZirfiReYFRp2SFHB9pv0sZjCo2/fozQFQ6R5aRFotrwx4HFYZjgybMAT1hQ7lWidHijIUjqQemUkBZf70YvwLd4WYTOjnP57HxOCcpjff6SAYRQlyl5xb/VoRsicpqP9BJzqaBIpBAOBs5MZhHNCev4wgVTDFs+o+0nIg+FBKcZLavHY/+xzz6h6e6YaPxHd0wgNg5XWnXt/isO0WoQtomFOmFWeXR7yT2SCFt6qgF9kv7yrPP+p/LDNQmKNcIKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0201.namprd12.prod.outlook.com (2603:10b6:4:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Mon, 1 Feb
 2021 17:17:49 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 17:17:49 +0000
Date:   Mon, 1 Feb 2021 13:17:47 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210201171747.GL4247@nvidia.com>
References: <20210125172035.3b61b91b.cohuck@redhat.com>
 <20210125180440.GR4147@nvidia.com>
 <20210125163151.5e0aeecb@omen.home.shazbot.org>
 <20210126004522.GD4147@nvidia.com>
 <20210125203429.587c20fd@x1.home.shazbot.org>
 <1419014f-fad2-9599-d382-9bba7686f1c4@nvidia.com>
 <20210128172930.74baff41.cohuck@redhat.com>
 <20210128140256.178d3912@omen.home.shazbot.org>
 <536caa01-7fef-7256-b281-03b40a6ca217@nvidia.com>
 <20210131213228.0e0573f4@x1.home.shazbot.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210131213228.0e0573f4@x1.home.shazbot.org>
X-ClientProxiedBy: BLAPR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:208:32a::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0111.namprd03.prod.outlook.com (2603:10b6:208:32a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Mon, 1 Feb 2021 17:17:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6cpf-002GYM-T1; Mon, 01 Feb 2021 13:17:47 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612199871; bh=zlDaeXvsMZLoS+zUxFll2TfKX6XsP7xgxfdq/RWusWg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=HfoHOH/EFziX6dF4/Oq6adP54PJG6zN7yQNHBUJsafDJaZGMiGfY+4+mJvbK/nKfV
         CYz+Yw3Lau0+ppcxfnXcA0DcFZbFfxbOM2YCDSFNgjlUOJZmQvqmhZPDRzhcaV08B1
         XK7P2wWeTyHT6vX3pvv9ZZM1w4M8KKF5U89A0W4Li3ernnsBQpZUlIqwB2bkwRHTgl
         IqYQnKRn6t6urbrPzAcoGsyuPDLPeCDS+5IleVRre874oUtNgVTFkHKZwah/0b51NL
         Vvqda5k2tstm+dtG0EszwxpkNvAQTipYnRP1WytqnfchjCHMXB2fj8p7f1AdOSktD8
         5k3kYA6l5Bx1w==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 31, 2021 at 09:32:28PM -0700, Alex Williamson wrote:

> > I think we can leave common arch specific stuff, such as s390 (IIUC) in 
> > the core driver. And only create vfio_pci drivers for 
> > vendor/device/subvendor specific stuff.
> 
> So on one hand you're telling us that the design principles here can be
> applied to various other device/platform specific support, but on the
> other you're saying, but don't do that...

The kernel code for the other three can be reworked to follow this
scheme, but because of the uABI we have established binding vfio_pci
is going to have to continue to automatically use the other drivers
for a long time.

For instance this can be accomplished by structuring the three drivers
in the new way and diverting the driver ops from vfio_pci to the other
drivers in a hardcoded way.

If this is worth doing from a maintability perspective vs just
continuing to hardwire the PCI IDs in vfio_pci, is something to look
at.

The point was it could work.

> > We can add a code to libvirt as mentioned above.
> 
> That's rather the question here, what is that algorithm by which a
> userspace tool such as libvirt would determine the optimal driver for a
> device?

Well, the PCI drivers do specify their PCI ids:

+static const struct pci_device_id mlx5_vfio_pci_table[] = {
+	{ PCI_VDEVICE(MELLANOX, 0x6001) }, /* NVMe SNAP controllers */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1042,
+			 PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID) }, /* Virtio SNAP controllers */
+	{ 0, }
+};

The problem in VFIO is that it doesn't have any way to create a VFIO
from a '/sys/device/blah/'. It expects userspace to know the module
name as part of the uAPI.

Generally speaking in the kernel we'd want to see some uAPI that was
'create a VFIO from /sys/device/blah' that does automatic module
loading and automatic driver selection.

For instance, by forming the '/sys/device/blah' to a normal modalias,
and then searching for the most specific VFIO modalias to handle the
device.

When implemented in netlink the whole thing is fully automatic, users
never have to know or care about any modules or their names. This is
the gold standard.

Jason
