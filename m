Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E59032314E
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 20:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhBWTTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 14:19:14 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1375 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhBWTSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 14:18:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603554df0002>; Tue, 23 Feb 2021 11:17:51 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 19:17:50 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 23 Feb 2021 19:17:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTc2RIt73oiHA/pPDVX33h4JgKkdGs5+a+hB5x+Q6USHW6FHvyBqncM9lPK0fBuTif+qBlGeNalDrV27g6p4SvfRFDEoScNjD+Y2oaWUzPoBNsxhk41RjkQ0ITYqtE5angCYJY2t7gd2/bVldPhLzrzySoLHJGGLaVIf9nSKRokVKmgzJzCWc2Q+KtBWrH7bDTJPZf9tG7EsmYPStLuoZGvwiNVKizeQu9AFLA8H58A14l9V/BK6RNdFAErnWM1dHq6Og44bq0R8iP4Cr8ZC7bybsr8M7VANaqrU5vO3u/iT/io581e9h0+tKFvFamOmeGzC6iJ09ULk4RNGRIoswA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LaDRrha/DvYqjh86g+PKDbQ4qnYeM/go64YqZ01c5c=;
 b=QnQqA99BpW6hjXQUOO0x5RL75CUaaTmsQzYIi3TsJmlQyxEeX/BQqHX/t0hwY6BC1V3TusQnKvxQpNu1mGeOM+eFsCyqTLPsSQy/WU83+g6a08YaM/4mbOIZELxKmhprgsdmCwmrdd8RpkC96Yd4S42g0LE6mUXW6Jr/IqhOdtUyzdotsK6jo8ExBCD4i1puyuH+1kDvPAjUxVbMdUeRQDBYS0+zHfMiojHi6EOBh97QriGYE21mpiI25XiYXH2E29FgpOMeab0uGawzHrQlUihGajwLCUhHgC3+xZQF4PZEfWyQlibjKROaXvlyEVxe+b6rGQcx04DYpQ8aD2bXng==
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
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>
Subject: [PATCH 2/3] vfio-platform: Add COMPILE_TEST to VFIO_PLATFORM
Date:   Tue, 23 Feb 2021 15:17:47 -0400
Message-ID: <2-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
In-Reply-To: <0-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:32b::28) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0023.namprd03.prod.outlook.com (2603:10b6:208:32b::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Tue, 23 Feb 2021 19:17:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEdBs-00FUTa-Jq; Tue, 23 Feb 2021 15:17:48 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614107871; bh=l+z0mVE56wW8SAkWjbXvJH59muDXI8ygtNGamCYHaWw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Date:Message-ID:In-Reply-To:References:
         Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Le6EeaP0MHswwKvxM4J6ScUlyC9Eqg15nOwEZ3rUfkGdiwKHAxSxGe4ZvQz9G92A3
         BzXvRUllQnIj/TIxM48OQj29MXcJ+pT+So/yDyZC0i+SQAPKotiJp5kusaXtbncWkC
         rPFHIlWxpFGVCY+yIwnp5eQrwXcDqvO9h9yWJCacHHwYidf0PczEQ2isN+VuZt2tLG
         rxr8Kt6dTzPJq27U5dzOsMsooogiUErvmoO9ZFl6ptRxdK4TRzbSMm9XvrU+PPlEDy
         RDkZODT/30Pbw/Z6yTZWuB7EojGAf8P/skndTYFfeqvWgYZv5g8TXL//lHdJkHNXnO
         /QSF5lPO6xFAQ==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86 can build platform bus code too, so vfio-platform and all the platform
reset implementations compile successfully on x86.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index dc1a3c44f2c62b..233efde219cc10 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM
 	tristate "VFIO support for platform devices"
-	depends on VFIO && EVENTFD && (ARM || ARM64)
+	depends on VFIO && EVENTFD && (ARM || ARM64 || COMPILE_TEST)
 	select VFIO_VIRQFD
 	help
 	  Support for platform devices with VFIO. This is required to make
--=20
2.30.0

