Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C8C32314F
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 20:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhBWTT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 14:19:28 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14174 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233755AbhBWTSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 14:18:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603554df0001>; Tue, 23 Feb 2021 11:17:51 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 19:17:51 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 23 Feb 2021 19:17:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5sbRcRb3EAqrdkcxK0yTRSejzsoV3h0uRv8poa6M3WFn7PXvSyZH4XwWlYS37sJOomT/xNeB0usfree8BR9AFtCL+Cd695P4v2iRNi5OIcQpKoJEuKGkTmmo8HNqvGXx6h5NpwKf3NluAUDquY8/R3rEGjSW5SABpbO0D6CsWcUIfPHtILjLEVnqNd1dOGGT3hEtX9r1Qt564tsjaXn9b1YnG70w1TTgOsv4x8UIBjfEv74VniFYeUxwJPhQZT01KvqupDRQ6rfBQQUKNmJzJRLUPAVNY9EpRQb5NMa6bAjRxxMc1h2HB4gS4qMwKuDNMwlT/tG3bioLWQtnvzpqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aziIRWOvnmhi/KUzoHcwSOX+J++Sue1vZX/SHKH/9rM=;
 b=ZSXBJVCf+InhV29Unm6ugS5PU98gld2jVc7zoI+cbfugSvesp5XPl/O1AWWnSncDCjhlyHE5NF2AHrtI4nfau012rSac8hl9XB3uXmzso+0MkX9wlZ2hjWOVDPYXjiIpO7xcl1/SeX1TXHhF81UlxCOs9oEjwY46Ds3bbB4eTl6xEhhK5GOeuCu7VeYkU6uxnX76RqAz9cLIxuY44JBLbXfsZ25uWkNV+PWh7MTOWUlC3frCfpFiiWAVIsIrtqMq6hsCR3FqAbrFrmSMDHIBuR54jnOzFtiqPqehuTk8QfjgWyRUwtGCXEZnzqlLr/hFihPVaQXqYpCs07EA2B5l+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4943.namprd12.prod.outlook.com (2603:10b6:5:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 19:17:50 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 19:17:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 3/3] ARM: amba: Allow some ARM_AMBA users to compile with COMPILE_TEST
Date:   Tue, 23 Feb 2021 15:17:48 -0400
Message-ID: <3-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
In-Reply-To: <0-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0014.prod.exchangelabs.com (2603:10b6:208:10c::27)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR01CA0014.prod.exchangelabs.com (2603:10b6:208:10c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 19:17:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEdBs-00FUTe-Ks; Tue, 23 Feb 2021 15:17:48 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614107871; bh=OqtyLB3zJ0orbqau48q1SX6dOXqHs7rbXKAjHzQ/Km0=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Date:Message-ID:In-Reply-To:References:
         Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=N5ynn6IRwcP7UIdIvLG8BSJ3OehJm8odAW9bChtvXi3RpFBRAdBV5/LJNqWRuseQo
         5FdqBzGecL6rCalgB8/bf73tY0c9vt2lA3kBUMo+0JevaHbn2GTW2M41ijyjSDmFS3
         iqKOUh26B04cpyRKyiB5+A1UzDh/i5pg2p6/Wl6KNPFFvQ2IKWRdLAB+sq6xtb31b/
         FAFWQGHlFiFDH4NmhkTLiz13ZJPgrKrpYzsd3rtlFWrWDlZpg3oVgxqqstjNYVS/DB
         vJ2hGvt/RvVBBdRTEbRix4ZUgsjb2gWK8U/4se1xiM6Zv406XR4bCUiIq1Bro9n3My
         k0Wadpzy5RZGw==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CONFIG_VFIO_AMBA has a light use of AMBA, adding some inline fallbacks
when AMBA is disabled will allow it to be compiled under COMPILE_TEST and
make VFIO easier to maintain.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/platform/Kconfig |  2 +-
 include/linux/amba/bus.h      | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index 233efde219cc10..ab341108a0be94 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -12,7 +12,7 @@ config VFIO_PLATFORM
=20
 config VFIO_AMBA
 	tristate "VFIO support for AMBA devices"
-	depends on VFIO_PLATFORM && ARM_AMBA
+	depends on VFIO_PLATFORM && (ARM_AMBA || COMPILE_TEST)
 	help
 	  Support for ARM AMBA devices with VFIO. This is required to make
 	  use of ARM AMBA devices present on the system using the VFIO
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index 0bbfd647f5c6de..977edd6e541ddd 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -105,8 +105,19 @@ extern struct bus_type amba_bustype;
 #define amba_get_drvdata(d)	dev_get_drvdata(&d->dev)
 #define amba_set_drvdata(d,p)	dev_set_drvdata(&d->dev, p)
=20
+#ifdef CONFIG_ARM_AMBA
 int amba_driver_register(struct amba_driver *);
 void amba_driver_unregister(struct amba_driver *);
+#else
+static inline int amba_driver_register(struct amba_driver *drv)
+{
+	return -EINVAL;
+}
+static inline void amba_driver_unregister(struct amba_driver *drv)
+{
+}
+#endif
+
 struct amba_device *amba_device_alloc(const char *, resource_size_t, size_=
t);
 void amba_device_put(struct amba_device *);
 int amba_device_add(struct amba_device *, struct resource *);
--=20
2.30.0

