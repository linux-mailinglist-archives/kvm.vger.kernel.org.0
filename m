Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B532314C
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 20:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbhBWTSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 14:18:54 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:14173 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbhBWTSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 14:18:31 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B603554df0000>; Tue, 23 Feb 2021 11:17:51 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Feb
 2021 19:17:50 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 23 Feb 2021 19:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J758P+aYypEuvqZRIRM+dCOjZY5WdpAQ8XR2dJXdeTW1/I8jgU2wvjlRs+dcSv3BcE8qTUs7yWRO5SP1JE8s/h80rDWiysWe3VqVzEHMm0ig5XmM8r67pxjqUhJUi+ILpjaa54SYbDjuGdJgOeaijmxh8uN/fkK8/Drb80OsefnzepKvUH2zPjslchdbSWDP2nIC7w4xlkVim5qJlB4e1SEunZv0Ox3tx7081QLEmZr3yu5AmzaJn9ph85Lf/NgzRTBuOnBEq3/kKxAZPx9O4Dxv814jjQjcSqWS9ssqj87H/fHHk25wyyMq4vOH3YahwA10JpWh3hspmwG/9G49LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQGfBhjILLOGDCYuCalfpYePJzUuN63E7RFskuTpOHY=;
 b=DSfimtwmSlE7h7lwdlg283VwZg6wuKj3/rKfOO2/JKQXNzcUToe5ZVKySIMHLeOKOOb8xdUo39iQOgagz74trmzrGwItg7WbOQowjl9erXhSAjtEFwT7p9MDhjW3vxo721Ai+pvUGh9o3ZjwP/+TglOQ6BSVR/aNejr/Gi6k8NWy245dNOaTcRy+wZ3bbPLXOpXP23JlFgkUN9bRhYHNVKEuGYbGivQ9BxJCN6lL3sYVGPEEYhfppFk7AZTWFqed3MnYl/CzOFF/uGSW/g2zPPoXyCflQ1Y3xGeKnvKgR0I37Q/Z8kW8ccekL6lLCBJ7Kv0Y5AekVq8mlEXi3lh86Q==
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
 19:17:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/3] vfio: IOMMU_API should be selected
Date:   Tue, 23 Feb 2021 15:17:46 -0400
Message-ID: <1-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
In-Reply-To: <0-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:208:257::9) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0034.namprd13.prod.outlook.com (2603:10b6:208:257::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.8 via Frontend Transport; Tue, 23 Feb 2021 19:17:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEdBs-00FUTW-IX; Tue, 23 Feb 2021 15:17:48 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614107871; bh=GM3lTqgSstKYkJKHJWcsUwmhCyLfTCLb50+37wERqgA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Date:Message-ID:In-Reply-To:References:
         Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=NMnsYp+KcYrPrIRsV75imT7L0q0XwSvmPdQG3I7e9aL6SZLJ4Z1lnYfhV3Chw7qe+
         6s5VcrrhJOULWqw9Xm0NqPw479awtzoDzFrjNCeFdyIzrhrtVpBiUXRE5jRQsa7USF
         QiCMeYaCn5tdJf0nBES9J/yWLkNdwns6C6fylA3ZqtsSOiXNXhPtZJdijnMvlRJn/k
         YSay6pVlYX1UgTK7BYpvFgb/G0+9Tc13OclLwFwYBKgjG4r9vTGCULRy6ffOw4R/qM
         cXEU9WFo26E90RcxI9fmeivtQwYlBtEpVDlJmo4yw5s0P40sVabSknCesUqFC8In0y
         +OfbFaWMg15qA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As IOMMU_API is a kconfig without a description (eg does not show in the
menu) the correct operator is select not 'depends on'. Using 'depends on'
for this kind of symbol means VFIO is not selectable unless some other
random kconfig has already enabled IOMMU_API for it.

Fixes: cba3345cc494 ("vfio: VFIO core")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 5533df91b257d6..90c0525b1e0cf4 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -21,7 +21,7 @@ config VFIO_VIRQFD
=20
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
-	depends on IOMMU_API
+	select IOMMU_API
 	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
 	help
 	  VFIO provides a framework for secure userspace device drivers.
--=20
2.30.0

