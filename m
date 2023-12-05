Return-Path: <kvm+bounces-3602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB32805AC1
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:07:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 839082824B8
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACBA868EAC;
	Tue,  5 Dec 2023 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m3NlnpL/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E376D1A4
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ad5bO8M6emaiPmRnocyVkuHqXIstU/ECCeFl+bjVLq0KTSGDvQ5AbS4TTD3pclfJf5Os0WPCrjjcE2DlCL0rl4EkPKbr8eethGmcNEMqT0NDa3NCZf4VwK3D89s1Sp0ysPtOWq87lMHDToN2miGLgk1Tk0CXjkE0KdPDnE3+4eU7nWUJl1Pf1KuYxrZlK4q+7Bzs7sAJ+4fZ+lRjm6VBU1wpN0sL57j7BPEPd1uAAjlk94G/cmR+5wLEzE6XzGpdEpgQwgVYwuDqAHle4x9ldmY05mD/pbZrFHjokkR1mwXp5S3ZzEwncUUh4gY+bUamtA49WP6KnuO4kBs3g5yFlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGmRdEdVELBxVAySevGFhr41Y8ddFDLr+9xH1qDUbvw=;
 b=KCeGosAjma8fDF6wH6/D2RkDu3Cw3TTKJ3qY27GGwRdFSbbfx0g4kgvYn4lJFSRfPkn1vNpJE0Slx372IcVisNtSlm3Z0zUNZ/xCccm4LMsS7OoqdGujIWqFZ3jy7lJNX0g5NiKwuGx41fA1iganXkY1GdJxEHrMJQd1hYWb2BcTGLawuPvbFaOT7OhJhB//sz5LapIj8c4Q7KSIsGp++EoL94VGXZdWbi9A5wKxOvH1Xze5hGpxM7xiktIx95sCFfCBdvIOYX6AnfKL5XrpSPrJkSE75Ec9VaBuUSyJxOciu+nbtU3M6CF6bUZ33VlCIcuvNSk4y5DdH8BZVn8XqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGmRdEdVELBxVAySevGFhr41Y8ddFDLr+9xH1qDUbvw=;
 b=m3NlnpL/X+Zad8vCRgc1Ws1HgTSroVGTxVwzgRQUpYnmXQg/vgavRHOEO13K4UXvNlL+XFdx3hL83+/o/BJ4ekP2tWoz7Rpk+btuRHT2eK4M4sqw1fKPvJhrWFG29/vkM3egQIY1yn6dSj1Gxr4g2L3GzxLMB9prbWYvT7dYqEqlobuEm+cxfK3GyqoVUol1vlJEiN97OQxpuQas8L/HqxhKl4wza5NGv7oh91ebJrrQqGY+evDLbE2+1VGrk+eU58ttoE3Vy7t9R9kKD2qMrwjP/nFZ12DtCPkeiZzt/hRvpRZb4EOf+cLoMtP/aXe1GbIgRvRg6Lo8nos6dREBEg==
Received: from MW4P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::19)
 by IA1PR12MB8588.namprd12.prod.outlook.com (2603:10b6:208:44f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:28 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:303:115:cafe::51) by MW4P220CA0014.outlook.office365.com
 (2603:10b6:303:115::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 17:07:28 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:07 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:07:06 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:07:03 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 3/9] virtio-pci: Introduce admin command sending function
Date: Tue, 5 Dec 2023 19:06:17 +0200
Message-ID: <20231205170623.197877-4-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|IA1PR12MB8588:EE_
X-MS-Office365-Filtering-Correlation-Id: b4ca3b0f-67bd-47ba-4090-08dbf5b4a940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6TnRQsCxoNdfXV7aEc9MNMHnSXPt/FQP/g0Cay9LGVfeRAQZSCqwffkjPUplFLhfUDKa2rPkA628muUMWQZIeGbKmSa6wBwMoas82QgbCJXa3OLC6rLg74RWzVSLpHhxnd+f13YjyHJKPt36KQNQZ5i+qw/hAv4dhLlpM+1334L9JHyg8At90KUaGTsPe3Ubw9jOYoCYl5j8qDqJVXg5Kp4wIj8SOrXRiL9YWnCInkqVglQ0EB8GCNPTPaoQP/NmyOoUwJfg6qDbT9EqQQu1vnrWCyH2VcafBc43uQ4VRRtg1wL9qbeD9MLRDhWAcvlWzBI37sVsLxkjHy70yB2U0GSKTA7Uoc3lkdgxZKRyg8iuCXM+9eYcReTCZsYYWnhL83yS0nb8D1eElwwHK6n8/3O3BgpYgInwqGZQ/hFsRc1Y0OIqz6TogQ9CRH6E3BlmlvKtRSUQQ46b5BAFDHhA3e0190zq54iRhucSEAIVpvKcCUmASEkAl285HylD0SNDpivASTc7I1sqHyx74kosKqplFoddNSo5jYH3RTJsjjddNu1DTnGdyqP7lx/9zS0ypujSpqfAb7rPZBxyNQmVxUwtiqoijrARInPycRFoJfJ8Whjucmcjsi/eAuzQsp94G6zJlByj7Tb+Xijm7BdoqVuhJhbI+lf6ujIUXAzPAKMImn+O05faqXMYp7Xdbp7UXEAfN52cB570vDjpA2EvYIsY3CcN0YPAyfUsHJ4NpGMzOCkGnUhOzWyBkUEW4P5So1vC3hqDe2kggq/4Fu8XAA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(451199024)(186009)(64100799003)(82310400011)(1800799012)(40470700004)(36840700001)(46966006)(82740400003)(40460700003)(5660300002)(36860700001)(2906002)(86362001)(41300700001)(36756003)(356005)(7636003)(107886003)(2616005)(1076003)(26005)(6666004)(7696005)(478600001)(8936002)(47076005)(4326008)(8676002)(70586007)(70206006)(110136005)(54906003)(336012)(83380400001)(316002)(6636002)(426003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:28.4129
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ca3b0f-67bd-47ba-4090-08dbf5b4a940
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8588

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


