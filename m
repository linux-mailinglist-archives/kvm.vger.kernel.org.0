Return-Path: <kvm+bounces-4484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF95813056
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:40:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9067BB21955
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08AF8524D3;
	Thu, 14 Dec 2023 12:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VZQE7Djl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE9D113
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:39:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTNZla9qX1T5yVpmnNvTLPMeIDj81w5EsD3R4LVlnzoPPzOiWC4Wuns9s6XhF0fWYp2VgqW8hH0VjTYoQeQDWiUBSqORW3Ww5tXjuFk3kMJsymJIg/rUYX91UHlOIGI96FzsN8/c+odlyF/ePb8dAFiaLvnPn2yOhfQr66IIUTOz234Gg0IkquYminOazSZCX6IKJW5KldXh//OjJOzJKYIS78ZoNHJ6XTzTVC037Kl+Q1uDGDpfVu6OvlMNiD5Hgc4B73mMuJHFgh8Qf1AEqxaeX8jaHvX38s2pSDOxG+PguAWhltZptAAdm4cDooHvWyhfkOtX0V9VZ1J21lQH1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A++3yuKKQheNoq/8ne69fmALtWgjNee3wpBIrcBt4lA=;
 b=Gw9TSB6XjRtg34z/DU/qe3BK+woF7xU9SlD/4uEJIcJVuX6ge8pnJbanQ7uibQsgzqHyL8e+QqYF5C4iq2EECOkwjAzjguCzDRec5e3tWFJ0LWvnEjd64b6mhOPqbiGi85Zt/CVyBRNoy5USiz3TdZU7DaqbMyjgG4QZhL13YXNhjB9v4ZpQuw0IbLvT/QmOc2nItTNPPTLGRxOwc2MGievo6ZV5x/hq/VhiarV1p+7Lx1EJUUFB1/uyP77lB+opyzLJfpuR/quuXRMxVXlLB7GpE8Diaj86VbZYKHZujkkqScsWwhFev4vwVeGNme/XxvotAylWRbss2Rcv0YB9cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A++3yuKKQheNoq/8ne69fmALtWgjNee3wpBIrcBt4lA=;
 b=VZQE7DjlmHhfq2Qnauth64IGWa7k9h/R9IhMqSqhY/9/PG5Cj99IAV4/NvwXZ+NYVsTerdJY8fArseBSSx9oHo1e4nScQsiQERQFzXR5fVcpUjrjXn9oVs9d53SyXaZFZpXC4/8P/SIV6KVTFp202YI8bGuuaIoxwBxx1UZm/IhQKegXLTN1zbe4gp7QSdGnXS/W1fJZAQDZzw0YhD0OuzNOcPEPJqRTbXjD2jIjQy0ykAyZ95yUSkVUs/QtHqhAtd/3JSlx1oiKvkIYXPsLDQNVn19iC1Ei+WdDQFRIinWTGnvaQLKMutIY8TEiB6TMJHqoOGKi7mOLL5MOcpot7Q==
Received: from DS7P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::34) by
 BY5PR12MB4241.namprd12.prod.outlook.com (2603:10b6:a03:20c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.28; Thu, 14 Dec 2023 12:39:12 +0000
Received: from CY4PEPF0000E9DC.namprd05.prod.outlook.com
 (2603:10b6:8:2e:cafe::e4) by DS7P222CA0014.outlook.office365.com
 (2603:10b6:8:2e::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 12:39:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9DC.mail.protection.outlook.com (10.167.241.82) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 12:39:11 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:58 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 14 Dec
 2023 04:38:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V8 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Thu, 14 Dec 2023 14:38:06 +0200
Message-ID: <20231214123808.76664-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231214123808.76664-1-yishaih@nvidia.com>
References: <20231214123808.76664-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DC:EE_|BY5PR12MB4241:EE_
X-MS-Office365-Filtering-Correlation-Id: a684083e-6177-41e5-0afe-08dbfca1ac65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Lq2Zr06WIpe12TR8ZCIaKbqHI6O9WjnTSc7W3h+kPaPNjrKqoxmYsnUj2yOY8Pu3XlGzeh5u0qCVRmi3K+Z+kYv6w0gcENv+IEGSQ9g/L2Qk3FRnsf/Mzcu3D6Uz4TEj1FPcKM9+a0iuWLy8n8Tmgqc3iNLFGZ/G+s8NolABWnhOND/9PogDvVOV2y9Gsb3JYGa/pZkO1nKSybfi1Udrd/qQSRxdDc8jojGHIAI/Apg+J8yBpIoCfxvwokN1eyF4b10EWT7hU7DGkSyV12hp6WPvP64c38FS8tGbiC2iFAPsRi1Rql68Df50G8R7ZlYH3u5n2RHbqqnMOUt1oC46FHefGTdFbKvHqBos3XZQ6h28GCyWcv7NyLb/0/vhRp2Lg4MoXpv2JeKDubx/jiNkXpE1BOBI59oxnTP7vhpKr+ssov8x0aBbGt1DAbRDZG11sPx1EYdU2atbUgBy4yEyVhmV4zP4Ewbhzy66pHCy5eeUm4OM7z49Cl+iuBQ0sGeuoHagICtpMotN2NhRdyhIaSCr76HShgVBr8pQLmhYwbONzBEYelD7UvIbZILtD4QnTYIgGV1VFiEPPehUsAN/3YrymvbOk+TGtteDulDOeXJX+VvrXxMEC5Hh2t6I+7KPFZNjAmReI0+ODkTglXY5kKCqk+Fnzp/ZKUKUFkQKJzlxlPpMWtvj6PKB3ILjd4Us8Pg+igcw7bEBCjgRigb9DJXdbwMuNApbG0058K0M+k8l6JucR4fCJdAjxfWrTQ1+m7gWFNtiKgst33fPBsMPyQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(396003)(136003)(230922051799003)(186009)(82310400011)(451199024)(64100799003)(1800799012)(46966006)(36840700001)(40470700004)(40460700003)(107886003)(26005)(2616005)(1076003)(336012)(426003)(7636003)(7696005)(36860700001)(83380400001)(5660300002)(41300700001)(2906002)(6666004)(478600001)(8676002)(8936002)(110136005)(70206006)(70586007)(316002)(6636002)(4326008)(54906003)(47076005)(82740400003)(86362001)(356005)(36756003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 12:39:11.4200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a684083e-6177-41e5-0afe-08dbfca1ac65
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4241

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 7 ++++---
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe..a9887fd6de46 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -200,7 +200,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -223,6 +223,7 @@ static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_setup_barmap);
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
@@ -262,7 +263,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		}
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
+		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
 			done = ret;
 			goto out;
@@ -438,7 +439,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
+	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..67ac58e20e1d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -127,6 +127,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-- 
2.27.0


