Return-Path: <kvm+bounces-3606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA629805AC9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:08:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5D1D1C2175C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1243561FD9;
	Tue,  5 Dec 2023 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cAe95jSG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0314E1A3
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eqP/iw1Oome8zPyobB9Qc1JoAc+ZfgCyZJflhQr6Ks64BiGB4rQrH3Kdpi+ULVLgufD3XVgP1Q3Y3cRGW/ENMMQKc/XeT7Krd7y79ilffju6f5ocpgExfvCFgPf7aF9x63mbH0Mj8wo7RH6c5RRhmsWoFSPd+JMKsPUFOhu9KFX/nt5eC7QUARKdugOQ0iqJ1YLsp5CA9QOs8cQJokRSVlp2x1jJZg8bHZEnHwq37yeM6IMog6L6ZFDCdFAfbx79/1XdLFHXpzcTbCtY+TcZ7wUhYb49q2Eu1dahc0npMs0wO1fSyiyzyGp3qem99fy181oCBGk/XZDsYDPki9bqlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkM/aYNKVzdTgTMkS8jEGaII22y9kWtRVNK16DYDStI=;
 b=Kx97wePvoGfZ2rb7u7qEpFomn53vRhnwz/8Om9GCePwn1yPCXdOt/T/Z+IcMThGJKxGxHBFm9l6tgJt9JJ4a7qq3lijYmbrbzNJ3oDKJDYIt9NQ1nfvku+Jz2fHf1N45hbLvud2FUiv1FGU2Ui8raiGkoBb6endxhzQPxu5My//6Do89gOHBgGZ/K5TJXpQ2mTo+IaPCLPy5pGXZwGJKFCglMZTTnHDQ4hRXaIeKhTnShbFKPFDwqU5YCVrvNo01Ro1VBSthwbhDAan17mZSwz0/rn5oRFhf4Hb0krJ8GFFXjRHvDJ3Lmnt4ZK2UL/VjiC7RbsFmnKSSdnO4QwsHlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkM/aYNKVzdTgTMkS8jEGaII22y9kWtRVNK16DYDStI=;
 b=cAe95jSGvSma03T5EMSOl5qpahXsM+W/43UENDwk+9QFoVvWNhO6W6VVo7fVaYlT5EO3luBUhFuCl67lGNHAb1STt1O7Y8YcT5/alsHdlyXE0qr7av9vVAZxEdHK5EJxfYybwwJ8+uZ/eXDkgS/M1i93Pz9TC/GPTOv9NJQms2N4iWSod+hVL3WjGCDwcloLDtEGjwShBR0Vt4DgzKWrL0coGxd3dEbQ7FfWYPdegf/vf4wbR9sN1P/Mk1WcmPjIUSigYcP+qlQ8wlqWqt2Qf5Vu30CiXvVQPqwNH4U8WctMCLoM6u64MYhpBy56Wz/9grPswjCE2UqeJBMyIvDTEA==
Received: from SJ0PR13CA0165.namprd13.prod.outlook.com (2603:10b6:a03:2c7::20)
 by SN7PR12MB7131.namprd12.prod.outlook.com (2603:10b6:806:2a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:47 +0000
Received: from MWH0EPF000989E8.namprd02.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::f4) by SJ0PR13CA0165.outlook.office365.com
 (2603:10b6:a03:2c7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.24 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E8.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 17:07:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:24 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:07:20 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Tue, 5 Dec 2023 19:06:21 +0200
Message-ID: <20231205170623.197877-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231205170623.197877-1-yishaih@nvidia.com>
References: <20231205170623.197877-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E8:EE_|SN7PR12MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4bf2c6-6081-41de-a038-08dbf5b4b43b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HPpLlNeMo/eaviXnoCU2OzaKzZSAX48KFVL5iSynRAVZR7SEZCh+lGYdrueXPzZuJt72jDH7RJu561B03zk4A78Btt9VFedb1pubB1t6pasySTnTENLmvQel4Gg/9f18o5YVVyaKQD86C69skvGkuP3N43ed1TzJerTLsA4VmakSaftnGrchnpsYNPIezmMQx8WY7wPtL5h/FEZQIrkEZNCPTuFlncFEUUq7kYFB5K2sh887z3khwfggmQ6ofpEAiTLQ9Pyt3etxcpcZy4+QTuaoNMrVd7dVYjO5OmB/JOXZWVzoo0YqWnqymWlteWbAA59hAD2Cuk9V0oANX4uMJkeDMEN3A4K+vaUUDdO6ZOWZ46TJEobQ/3v0SFd0h6b0rrTzp4jkFHJCTplGeN+zZlzvy15MYNIGJFHVip2t6BebUSGIEutgxmOY7vjOvI7QTrx32GSu9v/R9qM+zeuPuqc9mROHMoafE477F++8PQwPIhqLFG3joX+XY9pm5nNFsSowSGwxc76w8Q36RoNBuSGDCC3ZUVDXChsHL7EaZ0AMuhwG0xh9h3tIfJkS+eOImVqb/oXIWeP/eXWKf7z075lkuD54mcSnSyn6SYxw7IbSZmbSVQMBTyUbUrEWFH0rIyKsG1BvNT3KjPagVlFfH4ULhlpQV9TU7pZe7Ovxl1XwEyud/V98C72QdaDUO3f/eAsUxdtLfIghQAHoA+5EJO2X1NvrLlhF8Wgw/W8el5FLEs+d3cG2XDLAITUe8WlpRDThBLKljbXnUjW+atxuUA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(376002)(136003)(396003)(230922051799003)(186009)(64100799003)(82310400011)(451199024)(1800799012)(36840700001)(40470700004)(46966006)(40480700001)(36860700001)(2906002)(316002)(110136005)(54906003)(6636002)(7636003)(70586007)(8676002)(86362001)(70206006)(36756003)(41300700001)(8936002)(4326008)(356005)(47076005)(5660300002)(82740400003)(83380400001)(478600001)(40460700003)(426003)(26005)(1076003)(336012)(7696005)(107886003)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:46.8375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4bf2c6-6081-41de-a038-08dbf5b4b43b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7131

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

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


