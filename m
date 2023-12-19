Return-Path: <kvm+bounces-4789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A55381848B
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 10:34:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C813C1F2670A
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E49BF14AB3;
	Tue, 19 Dec 2023 09:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hqd+NN/u"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408A81429C
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VSkWSML9jXzLFNzO+Zc5P2HMNjfawG9qv+gKsw1r8NmPRXr4cC3poCQgjwgo7ZG6K4qoMNWgZvlnIhujqeLh+8EVqgFMsr9mdX02+rplb96juPkXxpH5r17zvFOzmHmpLmqXGEdWYPBa47NKh4bQjHOrdWLqN4RFpTKIhUOzYcNZAqEuocBRVhH+8b9RlGgJm3k7AXkwIb5ZlNvBUaFr0SiI79YRCXVSwZQssal3QoiVOjm/uiIlBaevILyF/HYdWA9CHQ75SbuxT21+RjZM1rbvSj681FC3t0on2owNDnir+lxpvn0mk4/bS3Xc8HNT1y/wuoX6HlXxFxXUAkTA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYVLVjJoSr/q6lAbvGVzKUumBlsVi5abfibEFwyQljc=;
 b=kUItD1Xte0vorg0ja1yRNmGl++UqKVp7bmdxSOtoj+kMHfzbUy38WZ2ylTdm/nRDDVtmXbTnjb3buuhEpSehVnWaxO+DXHEIRZwSN2MYJOHbKJw9JpjWJPmKT45xbxpZtuj5l5eXp9bk7uuLuvTL/H+hEaEAMoy9xNXY9QjWanfUi1VKSu1AGzy/Nu/JRb5oQvMA52GBql8+g/poQfabVYsPLBKwtFnqe9e5TLd4EzcTcpJS2Qnqy0PTJlFNjfC7bBQayU83sGn4UMPEMI2xPITVMG0mDdAm/lWneLGKTeZLvpmPZgEOlj7VUTSYZMhQRHSDw7QMwvcOlQ9zuZVxUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYVLVjJoSr/q6lAbvGVzKUumBlsVi5abfibEFwyQljc=;
 b=hqd+NN/uSV0PBEgo4+cskiHSo9eQmMluHdRSBbE0xw8F7A4UwZdvKY/ucUCDdy6kYldnvdzzIR8zSbNsvzlSKacIb816bKZKSnMuL2N0lNu1mvtbBbc43SXWfBB/FQFwHksvffBSXkqULWhjqYAJJtX2KApMXDYVjHN9A1vxIFzeEK5oqWE/1ZOnrQe2aXmpJy9IsgHB5tzJgfFkhlGf4xlmRd9XVXNS3mVZgKhWdJ3yWd12SZzMqT0N9ph/8XR/XXsGuwDiT2JSvEzXOC9Q2PVJ6GXkZWvgfD1JTxaxLSu6uQ7kX+tyO5WmQKXinfe/Hmspyo5Blipq6y4YFWIrlQ==
Received: from CYZPR10CA0009.namprd10.prod.outlook.com (2603:10b6:930:8a::13)
 by CH3PR12MB7596.namprd12.prod.outlook.com (2603:10b6:610:14b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 09:34:00 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::ec) by CYZPR10CA0009.outlook.office365.com
 (2603:10b6:930:8a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Tue, 19 Dec 2023 09:34:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Tue, 19 Dec 2023 09:34:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 19 Dec
 2023 01:33:58 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Tue, 19 Dec 2023 01:33:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Tue, 19 Dec 2023 01:33:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V10 vfio 3/9] virtio-pci: Introduce admin command sending function
Date: Tue, 19 Dec 2023 11:32:41 +0200
Message-ID: <20231219093247.170936-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231219093247.170936-1-yishaih@nvidia.com>
References: <20231219093247.170936-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|CH3PR12MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: e8e559a7-34bb-4935-9681-08dc0075a1ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Cx4wwfkxX5AFPPebcDF2kWKO/A2QKiogDfigY1SAokrAgXr37P3Lj6gP86FFX0tpgHvHwe5s0oPsn0vTIlw49n8PcdsGC5Vh2Ka0aFyY5Fb8fvtt7unT0iDmA2W005LbKKz9NX0n7npOehy+ixnKRxYIlEm/HYauBy8vVuDpzIDp7dkTZLnHtnHmFW6H4XC30qbNvXug/6PPjIfBd+ORZljqPDhlgCROXowj79wb91WjmKjalpdxy+RPyEfjS3z9Uoixf4QDJtErtf7TYYecxl+wsPp4C3atMQf4/EvNBwLPs3Llysrz0sOceR6N3IlkWRvdiJ0yIAcv9XWPdbrQOL9gIvnYEIH2SmtMThTWPSeQ3+ZggMFFi6Qmzkr4Q2nPV3qpqj0gmuwtjWLnZ8lqUW6fjgzl9dg1xP4rUk94FUDGVDGyHBHpSLaGPF0ulXpne/h+yN4Gg3Z4Nn0FzhT20VZD+FmEhWX6MB9fuPVq+pSraO9pPwYj4beb6FG4TSOeiHoBQ60QZ6L/DJVkRouwNQ1t80TlcekK0SvpyFv12hO2Rzjw0r8AYs8ddXbgnbxONQKtzyquKopcLegWnH32j0l7XcoLZnPX0E50RJUrYMml7zTAU3leTU9100FAVTZd9fpKxuCO8ovnB5XVbPGOk6qcjiAU9TQV+PrAnYsuH71G4J8T1v1cY46h+FEUBF3tr1/g50wZsZWNBlWKITbk+8euvQNjCY81dLn+JgIW+kmXQEZjdlYJ3KXPh4Jy3zz4RvqkTZID/7OTPvjnhLUCDA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(39860400002)(376002)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(82310400011)(40470700004)(36840700001)(46966006)(40460700003)(2616005)(1076003)(107886003)(336012)(426003)(26005)(7696005)(6666004)(54906003)(36860700001)(5660300002)(83380400001)(41300700001)(2906002)(478600001)(6636002)(4326008)(8676002)(8936002)(70206006)(70586007)(316002)(110136005)(82740400003)(86362001)(356005)(7636003)(47076005)(36756003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 09:34:00.4674
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8e559a7-34bb-4935-9681-08dc0075a1ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7596

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
 drivers/virtio/virtio_pci_common.h |   6 ++
 drivers/virtio/virtio_pci_modern.c | 143 ++++++++++++++++++++++++++++-
 include/linux/virtio.h             |   8 ++
 include/uapi/linux/virtio_pci.h    |  22 +++++
 4 files changed, 177 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index 7306128e63e9..282d087a9266 100644
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
@@ -152,4 +155,7 @@ static inline void virtio_pci_legacy_remove(struct virtio_pci_device *vp_dev)
 int virtio_pci_modern_probe(struct virtio_pci_device *);
 void virtio_pci_modern_remove(struct virtio_pci_device *);
 
+int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+			     struct virtio_admin_cmd *cmd);
+
 #endif
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index ce915018b5b0..9bd66300a80a 100644
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
+int vp_modern_admin_cmd_exec(struct virtio_device *vdev,
+			     struct virtio_admin_cmd *cmd)
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


