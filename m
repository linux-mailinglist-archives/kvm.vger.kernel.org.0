Return-Path: <kvm+bounces-3674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECC618069E6
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D6AC1F2189D
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BB4D1A706;
	Wed,  6 Dec 2023 08:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CRli2gZB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DB1D4E
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:40:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gauBiAdmHI5dwmLFjtFel/k0ELeGDNo7V6M0LSsvtIWVAwR2tifpH0HBfn/nLEyYAYY/1X1uRPp0ij9LwfHo8Sgad+6fyRHGHUz/iAhPkhOb7eODVGAygFT/pHH+weH040WwVcESNXq/5Gye1FTrS0g9XfBNZ1zU1lN044BgBsz576dzJDfNDMqs2yvYg1JksCi9reeGGJLuaDqQh4HnzTdOTz8DjCONdqfg7p9/JE73Sr+qKWg+En/Sih4enParMxVUIAsfU5uiiPblCMQEXVDVdvkeO/wc8fj/L0a6BesyAPw72S+5vWVr9jnq0ojYkrkbuezNmA1z2EzLH7gStg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGmRdEdVELBxVAySevGFhr41Y8ddFDLr+9xH1qDUbvw=;
 b=Nk5G1SIwmdXjGnV7m5Fk3KuY5RyxQ8bMjE7aBVA7c7Wg3xaX9VlBoYgeNEtD7Wf/VZpiipaU9ptZYwrOCs8h573h8n2if7vi2SAR/feKK7u7Whl/AnWtWgsTL2a9Y+yiiGG1eWPp9r8E9Kc1d5XoiG7n3Ec2NZxkLFvBY9uECRudLpxjsRL5N2RwQ67IYiybYLZB8QPFytM4E/0ic7XoGHnUtBuCyoZkw2Ayg3kD2i6OA7NHgm1XZd+x1jVpEnZTo/fUr5zTGiakjNQKc3Ovw8j7RLGsWAaNgmUn8JmB0WIXIednSgpeCYeLKGHYjSu7020lijLG+JsBfJI16WKy5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGmRdEdVELBxVAySevGFhr41Y8ddFDLr+9xH1qDUbvw=;
 b=CRli2gZBOmuQnHMYjrbUj/77FQC0/nRgAdZfrko7zE3qoI8fLJlzg2CazDBlGmUn7ncXin6DmcUjrBN9Gwcc9mIj6Ukz2RsmybJjLfElhUYJl5KPE8YHLuNeaywtk0SGOSMqPTzfH2eGpXiYPLRLvU32DcBU6P3YgcS1Xaif1ZclDOGPI8QyNf+uaNoGCxFWZAP1zK4FEEdG8ye59YVFn8Q+tY0qIGAACmsYGa5/qHziMsH1OSvF03NO1pQ57WhYFeEe3u0cU1G3H5JtBX8jirRptXVfXImHTSVnJU1nDQn0XPUGCgjz+NJwrHxnbsAVkTanZdCnc0BVPKiJhQXhIg==
Received: from PH0PR07CA0097.namprd07.prod.outlook.com (2603:10b6:510:4::12)
 by LV3PR12MB9215.namprd12.prod.outlook.com (2603:10b6:408:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 08:40:06 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::93) by PH0PR07CA0097.outlook.office365.com
 (2603:10b6:510:4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.36 via Frontend
 Transport; Wed, 6 Dec 2023 08:40:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 08:40:05 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:51 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:39:51 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:39:47 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 3/9] virtio-pci: Introduce admin command sending function
Date: Wed, 6 Dec 2023 10:38:51 +0200
Message-ID: <20231206083857.241946-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231206083857.241946-1-yishaih@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|LV3PR12MB9215:EE_
X-MS-Office365-Filtering-Correlation-Id: 0faa4e24-55d6-455d-551d-08dbf636f258
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tak4WBhLxyO93h9z4J/5YpNqRDYPwUWT0MQeA+KJIy8d9qGJrnmyRGRT3nYCzgG+eOLqT+L5UxkNxzcaoaE5b4UTcFH0IIH1/bzkYcFlgGP3MqzBbcgP2N5ZNx58jcYfMsqQ98RNRufABzHQJupfzR7kaVVv8QoNwh5ENbTZUhuXZV/KFkn9iLZDHs64u1/labEd3ecoYgkOX1rbMyHi6F/s5yUxoEQX4ELYVeNDpZIdP+3OWAOOKx+okMRjHl4Wej+xgPpR1DGrzS0BGe49HJbUKaoIyPVujbneNgqzr1OSmn5mXv1w934Rqng47kw1OxR1iKqVx6ja4o3vGjW3WNSlWgsqPzIbC2zi/DvL9FgSFHTC+7RCFuHL/7BHFxi3xcjqmln9sevnfkql8Y+s+qdGvgRUkJSExvIf3JsOXMNP0SMZSb5Un5TYHs/wRSCgIzzy7ebZWAASKacvxh3+ir5yjfVB8+XZWyW53bbyLLINs+ml4Rcqr41gzvKykpVuYmd490AuazGu2Q0LmfBoZ27M5TRBtX3kKsLSrlLnoe2EQ1qXjpzo9Ion2iHj32yVv3AqWejpmptEM+78tcrKBtIA+Tb0C9StMVtlVmjq6kOPfgGSIh872LMuGNTGL8b3K19ECR1vcrpPsyRT2GSKs0iGLjLNcgxZfmTMRKgeYjrdgvo1HpW7La0fF9ySq4OQr7BrbtPN+f0gA0xP2XW7wNn+bpFjFvEPBVi14nHcc+aC/Y3CWD8alhsOCnat2SbH3aBkGwirD46cQ4atTzkBmw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(376002)(396003)(346002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(82310400011)(40470700004)(36840700001)(46966006)(7636003)(1076003)(356005)(36860700001)(107886003)(2616005)(8936002)(8676002)(4326008)(40480700001)(7696005)(47076005)(82740400003)(83380400001)(26005)(426003)(336012)(6666004)(40460700003)(478600001)(54906003)(70206006)(70586007)(110136005)(6636002)(316002)(41300700001)(2906002)(36756003)(86362001)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:40:05.6349
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0faa4e24-55d6-455d-551d-08dbf636f258
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9215

From: Feng Liu <feliu@nvidia.com>

Add support for sending admin command through admin virtqueue interface.
Abort any inflight admin commands once device reset completes. Activate
admin queue when device becomes ready; deactivate on device reset.

To comply to the below specification statement [1], the admin virtqueue
is activated for upper layer users only after setting DRIVER_OK status.

[1] The driver MUST NOT send any buffer available notifications to the
device before setting DRIVER_OK.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/virtio/virtio_pci_common.h |   3 +
 drivers/virtio/virtio_pci_modern.c | 143 ++++++++++++++++++++++++++++-
 include/linux/virtio.h             |   8 ++
 include/uapi/linux/virtio_pci.h    |  22 +++++
 4 files changed, 174 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 7306128e63e9..a50a58014c9f 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -29,6 +29,7 @@
 #include <linux/virtio_pci_modern.h>
 #include <linux/highmem.h>
 #include <linux/spinlock.h>
+#include <linux/mutex.h>
 
 struct virtio_pci_vq_info {
 	/* the actual virtqueue */
@@ -44,6 +45,8 @@ struct virtio_pci_vq_info {
 struct virtio_pci_admin_vq {
 	/* Virtqueue info associated with this admin queue. */
 	struct virtio_pci_vq_info info;
+	/* serializing admin commands execution and virtqueue deletion */
+	struct mutex cmd_lock;
 	/* Name of the admin queue: avq.$vq_index. */
 	char name[10];
 	u16 vq_index;
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index ce915018b5b0..18366a82408c 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -38,6 +38,132 @@ static bool vp_is_avq(struct virtio_device *vdev, unsigned int index)
 	return index == vp_dev->admin_vq.vq_index;
 }
 
+static int virtqueue_exec_admin_cmd(struct virtio_pci_admin_vq *admin_vq,
+				    struct scatterlist **sgs,
+				    unsigned int out_num,
+				    unsigned int in_num,
+				    void *data)
+{
+	struct virtqueue *vq;
+	int ret, len;
+
+	vq = admin_vq->info.vq;
+	if (!vq)
+		return -EIO;
+
+	ret = virtqueue_add_sgs(vq, sgs, out_num, in_num, data, GFP_KERNEL);
+	if (ret < 0)
+		return -EIO;
+
+	if (unlikely(!virtqueue_kick(vq)))
+		return -EIO;
+
+	while (!virtqueue_get_buf(vq, &len) &&
+	       !virtqueue_is_broken(vq))
+		cpu_relax();
+
+	if (virtqueue_is_broken(vq))
+		return -EIO;
+
+	return 0;
+}
+
+static int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+				    struct virtio_admin_cmd *cmd)
+{
+	struct scatterlist *sgs[VIRTIO_AVQ_SGS_MAX], hdr, stat;
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_admin_cmd_status *va_status;
+	unsigned int out_num = 0, in_num = 0;
+	struct virtio_admin_cmd_hdr *va_hdr;
+	u16 status;
+	int ret;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return -EOPNOTSUPP;
+
+	va_status = kzalloc(sizeof(*va_status), GFP_KERNEL);
+	if (!va_status)
+		return -ENOMEM;
+
+	va_hdr = kzalloc(sizeof(*va_hdr), GFP_KERNEL);
+	if (!va_hdr) {
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+
+	va_hdr->opcode = cmd->opcode;
+	va_hdr->group_type = cmd->group_type;
+	va_hdr->group_member_id = cmd->group_member_id;
+
+	/* Add header */
+	sg_init_one(&hdr, va_hdr, sizeof(*va_hdr));
+	sgs[out_num] = &hdr;
+	out_num++;
+
+	if (cmd->data_sg) {
+		sgs[out_num] = cmd->data_sg;
+		out_num++;
+	}
+
+	/* Add return status */
+	sg_init_one(&stat, va_status, sizeof(*va_status));
+	sgs[out_num + in_num] = &stat;
+	in_num++;
+
+	if (cmd->result_sg) {
+		sgs[out_num + in_num] = cmd->result_sg;
+		in_num++;
+	}
+
+	mutex_lock(&vp_dev->admin_vq.cmd_lock);
+	ret = virtqueue_exec_admin_cmd(&vp_dev->admin_vq, sgs,
+				       out_num, in_num, sgs);
+	mutex_unlock(&vp_dev->admin_vq.cmd_lock);
+
+	if (ret) {
+		dev_err(&vdev->dev,
+			"Failed to execute command on admin vq: %d\n.", ret);
+		goto err_cmd_exec;
+	}
+
+	status = le16_to_cpu(va_status->status);
+	if (status != VIRTIO_ADMIN_STATUS_OK) {
+		dev_err(&vdev->dev,
+			"admin command error: status(%#x) qualifier(%#x)\n",
+			status, le16_to_cpu(va_status->status_qualifier));
+		ret = -status;
+	}
+
+err_cmd_exec:
+	kfree(va_hdr);
+err_alloc:
+	kfree(va_status);
+	return ret;
+}
+
+static void vp_modern_avq_activate(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_admin_vq *admin_vq = &vp_dev->admin_vq;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return;
+
+	__virtqueue_unbreak(admin_vq->info.vq);
+}
+
+static void vp_modern_avq_deactivate(struct virtio_device *vdev)
+{
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+	struct virtio_pci_admin_vq *admin_vq = &vp_dev->admin_vq;
+
+	if (!virtio_has_feature(vdev, VIRTIO_F_ADMIN_VQ))
+		return;
+
+	__virtqueue_break(admin_vq->info.vq);
+}
+
 static void vp_transport_features(struct virtio_device *vdev, u64 features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
@@ -213,6 +339,8 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
 	/* We should never be setting status to 0. */
 	BUG_ON(status == 0);
 	vp_modern_set_status(&vp_dev->mdev, status);
+	if (status & VIRTIO_CONFIG_S_DRIVER_OK)
+		vp_modern_avq_activate(vdev);
 }
 
 static void vp_reset(struct virtio_device *vdev)
@@ -229,6 +357,9 @@ static void vp_reset(struct virtio_device *vdev)
 	 */
 	while (vp_modern_get_status(mdev))
 		msleep(1);
+
+	vp_modern_avq_deactivate(vdev);
+
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 }
@@ -404,8 +535,11 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 		goto err;
 	}
 
-	if (is_avq)
+	if (is_avq) {
+		mutex_lock(&vp_dev->admin_vq.cmd_lock);
 		vp_dev->admin_vq.info.vq = vq;
+		mutex_unlock(&vp_dev->admin_vq.cmd_lock);
+	}
 
 	return vq;
 
@@ -442,8 +576,11 @@ static void del_vq(struct virtio_pci_vq_info *info)
 	struct virtio_pci_device *vp_dev = to_vp_device(vq->vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
 
-	if (vp_is_avq(&vp_dev->vdev, vq->index))
+	if (vp_is_avq(&vp_dev->vdev, vq->index)) {
+		mutex_lock(&vp_dev->admin_vq.cmd_lock);
 		vp_dev->admin_vq.info.vq = NULL;
+		mutex_unlock(&vp_dev->admin_vq.cmd_lock);
+	}
 
 	if (vp_dev->msix_enabled)
 		vp_modern_queue_vector(mdev, vq->index,
@@ -662,6 +799,7 @@ int virtio_pci_modern_probe(struct virtio_pci_device *vp_dev)
 	vp_dev->isr = mdev->isr;
 	vp_dev->vdev.id = mdev->id;
 
+	mutex_init(&vp_dev->admin_vq.cmd_lock);
 	return 0;
 }
 
@@ -669,5 +807,6 @@ void virtio_pci_modern_remove(struct virtio_pci_device *vp_dev)
 {
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
 
+	mutex_destroy(&vp_dev->admin_vq.cmd_lock);
 	vp_modern_remove(mdev);
 }
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 4cc614a38376..b0201747a263 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -103,6 +103,14 @@ int virtqueue_resize(struct virtqueue *vq, u32 num,
 int virtqueue_reset(struct virtqueue *vq,
 		    void (*recycle)(struct virtqueue *vq, void *buf));
 
+struct virtio_admin_cmd {
+	__le16 opcode;
+	__le16 group_type;
+	__le64 group_member_id;
+	struct scatterlist *data_sg;
+	struct scatterlist *result_sg;
+};
+
 /**
  * struct virtio_device - representation of a device using virtio
  * @index: unique position on the virtio bus
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 240ddeef7eae..187fd9e34a30 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -223,4 +223,26 @@ struct virtio_pci_cfg_cap {
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
+/* Admin command status. */
+#define VIRTIO_ADMIN_STATUS_OK		0
+
+struct __packed virtio_admin_cmd_hdr {
+	__le16 opcode;
+	/*
+	 * 1 - SR-IOV
+	 * 2-65535 - reserved
+	 */
+	__le16 group_type;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved1[12];
+	__le64 group_member_id;
+};
+
+struct __packed virtio_admin_cmd_status {
+	__le16 status;
+	__le16 status_qualifier;
+	/* Unused, reserved for future extensions. */
+	__u8 reserved2[4];
+};
+
 #endif
-- 
2.27.0


