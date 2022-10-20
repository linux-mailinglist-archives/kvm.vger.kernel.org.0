Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C1B606173
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 15:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiJTNWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 09:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiJTNWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 09:22:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FAC19635A
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 06:22:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KAd+2+RjzUBhcP4Ns3MhT1j78MgFTfKNFYpiAGfrHlFZnL7xc2YoBQo+okzicK/bmxlk4sp+Stp5ARJufw5wKCPXpdoQHOQUHYoq7Vg5gQF8EMDWWHEA/Lz9YQ1U7Shv04EIx7DkbhHJaxw3qbBq4qyLfygDmyV/5WtRsxalf7wqRrbcAOcYHzXXCpV5KXmIiS/d5sv9+++6A9JVsehtCGX0/v++aGj9oPjbAioQRFE51+PwN+TEbp4Qd/EEgLbDShwp8Erf102BGxJUU6wlHUKYz11lQ8T7vT/x3irJfNRJAg+3tNCr+qmVktG0lzv4GSnShhfAN5gd4ZwLYLXmIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/kFEa7RwDN/IAxXC6eTKiajN4pU6Z3jnQba6vJWmzg=;
 b=LGKkVUYhQzk4ydnHIvjDpa8wbzQ/QIiCc6wmwWeGoKqpKMC5r5IfbiO6Cc6IIrpa+0DVM/JgpWgN1aGqV8nf1VHep/lEHXWbDsuhgX+HKEZTqGzaAA7MwurVJm9o9zTNGi9QzqTWn+3GuHKXEqvexhF3dRDgx6ap5Dgb4UM6PHu9JRi02Ir9gvOckr5oPTBZ4Tne7v4bStQ4/GwwE8RY9CXTeairrPF9RPVUz1vGZkBuXtjEt2Ry+krXKwy+s6uVGfE4DDF/0K/p6WKWF0yGXYvNd08H7aVFSw/Fk34tf9g4bcC3uIKb77PrVu6WqFxHC+Uyh1DvX0tIDKwjQVyRgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/kFEa7RwDN/IAxXC6eTKiajN4pU6Z3jnQba6vJWmzg=;
 b=JJScmg9DxGzFzcZDM+DTkxkBUXsuxFERKwTVFdlseLZT8eG8LcuaP/RXZZ6RTyEjdP8XyXMGjilZkv6NqHecCc7E1S4LZo17kfxfUoYTF/+dPYnuP493SmtJyfSx3Kf60qUKNURcXkTdY/6pRVZwaNPhvc3qje2ooRcaxYXLJoAhPsic1Lo+16qvO3+a0T+fwQe7RfhfFh0g+7dayL5/tARME3OY7FJlQUk5qbGW5+hv8dT0e4dLJSlvL5HM1tryJYdU2W7Mwx8Pniv04nWGoZGrFxjd3XhvVa+y3+nu/c/RXQCnLkiXdTAzH0W4tf1HS2/U7pCuKXW1SI3NTVBrHw==
Received: from DS7PR03CA0360.namprd03.prod.outlook.com (2603:10b6:8:55::33) by
 MN0PR12MB5738.namprd12.prod.outlook.com (2603:10b6:208:371::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 20 Oct
 2022 13:21:56 +0000
Received: from DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::5c) by DS7PR03CA0360.outlook.office365.com
 (2603:10b6:8:55::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34 via Frontend
 Transport; Thu, 20 Oct 2022 13:21:56 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=nvidia.com;
Received-SPF: None (protection.outlook.com: nvidia.com does not designate
 permitted sender hosts)
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT082.mail.protection.outlook.com (10.13.173.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Thu, 20 Oct 2022 13:21:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 20 Oct
 2022 06:21:48 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 20 Oct
 2022 06:21:48 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 20 Oct
 2022 06:21:45 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <quintela@redhat.com>, <kvm@vger.kernel.org>,
        <liulongfang@huawei.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kuba@kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <yishaih@nvidia.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH] vfio: Add an option to get migration data size
Date:   Thu, 20 Oct 2022 16:21:09 +0300
Message-ID: <20221020132109.112708-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT082:EE_|MN0PR12MB5738:EE_
X-MS-Office365-Filtering-Correlation-Id: e79d68e1-21c4-4cea-4a13-08dab29e0fd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNX8zxiLOuwtcoFc2Ad6XITEzWhO5U2cUpgI69swe+Vgivd3VxQjHiH6YCIog+dgjr3upXFgJU3RycSm4mtFN2udUtXX5d+J0bN0WUMcMWuQMBczYgRdqucE+rK6SDHsKq+BSWsa9Lr/2TilYvJXPzrg1AsIYwlnSWeyHU9+FgRrZOzzYByL8YMM6j7eDXEIoE3Q1xtNecLJi5vnhCR6FULZNYU9F9EWDSPlsoTAzd6KIcP/CYxMIOlNm6aTFlV//pVWfMIt0nBArYkLL+OQmZ9kLSZ78fvzx9Gcy5JZxaVkchXGGrpdqT+5A72MhoP/nWV2Nfa4XvOvykqQI36caGLmeId87t20/X7/7Pf3Ar52sPHsCzrQR2tNMdZ8cPJhCpD5if9ARU68dITHi77eZc/6xwUjWsKhFjVfMRCtjPQgLOhe4oAFImoBZRt5HxCmG5+qjfJOR3Vu/CE8c0GlmKq817WiNx1weCan8/uI+sx+B7XMgFeN6RqbXHAeD92PRwElws7VNHevk/Z8q4a183gzSd5kM7jLO5cgD9n5m0aldQ+tA3d2WJkV2bDsPIh5/XH0/J5pSNFa2yFXQa1ww3i7DJsXYW2iigVYDqZGjNnY/WoMga0F+XthQ7oDWs1FE30hG9fp98lZ9+iZpAkr6zFY/HCLNMmOFAr8pcORSNrBpK+AgCmKvJLVXJJiTuo5JO3n/D6GUXh+dcr7cQBqsCic0rY/moTx2BPZNR+m08kmSn3FyJJzRcSD4FevHNj9mLRmUb8sxRhSkCbzU+/ZqQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(478600001)(40480700001)(7636003)(86362001)(83380400001)(426003)(82740400003)(47076005)(356005)(8676002)(70586007)(70206006)(5660300002)(82310400005)(8936002)(36860700001)(6636002)(7696005)(2616005)(2906002)(54906003)(40460700003)(41300700001)(6666004)(336012)(36756003)(4326008)(110136005)(1076003)(186003)(26005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 13:21:56.4578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e79d68e1-21c4-4cea-4a13-08dab29e0fd1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT082.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5738
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an option to get migration data size by introducing a new migration
feature named VFIO_DEVICE_FEATURE_MIG_DATA_SIZE.

Upon VFIO_DEVICE_FEATURE_GET the estimated data length that will be
required to complete STOP_COPY is returned.

This option may better enable user space to consider before moving to
STOP_COPY whether it can meet the downtime SLA based on the returned
data.

The patch also includes the implementation for mlx5 and hisi for this
new option to make it feature complete for the existing drivers in this
area.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  9 ++++++
 drivers/vfio/pci/mlx5/main.c                  | 18 +++++++++++
 drivers/vfio/vfio_main.c                      | 32 +++++++++++++++++++
 include/linux/vfio.h                          |  5 +++
 include/uapi/linux/vfio.h                     | 13 ++++++++
 5 files changed, 77 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 39eeca18a0f7..0c0c0c7f0521 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -957,6 +957,14 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
 	return res;
 }
 
+static int
+hisi_acc_vfio_pci_get_data_size(struct vfio_device *vdev,
+				unsigned long *stop_copy_length)
+{
+	*stop_copy_length = sizeof(struct acc_vf_data);
+	return 0;
+}
+
 static int
 hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 				   enum vfio_device_mig_state *curr_state)
@@ -1213,6 +1221,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
 	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
 	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
+	.migration_get_data_size = hisi_acc_vfio_pci_get_data_size,
 };
 
 static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fd6ccb8454a2..4c7a39ffd247 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -512,6 +512,23 @@ mlx5vf_pci_set_device_state(struct vfio_device *vdev,
 	return res;
 }
 
+static int mlx5vf_pci_get_data_size(struct vfio_device *vdev,
+				    unsigned long *stop_copy_length)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	size_t state_size;
+	int ret;
+
+	mutex_lock(&mvdev->state_mutex);
+	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev,
+						    &state_size);
+	if (!ret)
+		*stop_copy_length = state_size;
+	mlx5vf_state_mutex_unlock(mvdev);
+	return ret;
+}
+
 static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
 				       enum vfio_device_mig_state *curr_state)
 {
@@ -577,6 +594,7 @@ static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
 static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
 	.migration_set_state = mlx5vf_pci_set_device_state,
 	.migration_get_state = mlx5vf_pci_get_device_state,
+	.migration_get_data_size = mlx5vf_pci_get_data_size,
 };
 
 static const struct vfio_log_ops mlx5vf_pci_log_ops = {
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2d168793d4e1..b118e7b1bc59 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1256,6 +1256,34 @@ vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
 	return 0;
 }
 
+static int
+vfio_ioctl_device_feature_migration_data_size(struct vfio_device *device,
+					      u32 flags, void __user *arg,
+					      size_t argsz)
+{
+	struct vfio_device_feature_mig_data_size data_size = {};
+	unsigned long stop_copy_length;
+	int ret;
+
+	if (!device->mig_ops)
+		return -ENOTTY;
+
+	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
+				 sizeof(data_size));
+	if (ret != 1)
+		return ret;
+
+	ret = device->mig_ops->migration_get_data_size(device, &stop_copy_length);
+	if (ret)
+		return ret;
+
+	data_size.stop_copy_length = stop_copy_length;
+	if (copy_to_user(arg, &data_size, sizeof(data_size)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 					       u32 flags, void __user *arg,
 					       size_t argsz)
@@ -1483,6 +1511,10 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 		return vfio_ioctl_device_feature_logging_report(
 			device, feature.flags, arg->data,
 			feature.argsz - minsz);
+	case VFIO_DEVICE_FEATURE_MIG_DATA_SIZE:
+		return vfio_ioctl_device_feature_migration_data_size(
+			device, feature.flags, arg->data,
+			feature.argsz - minsz);
 	default:
 		if (unlikely(!device->ops->device_feature))
 			return -EINVAL;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e7cebeb875dd..5509451ae709 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -107,6 +107,9 @@ struct vfio_device_ops {
  * @migration_get_state: Optional callback to get the migration state for
  *         devices that support migration. It's mandatory for
  *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ * @migration_get_data_size: Optional callback to get the estimated data
+ *          length that will be required to complete stop copy. It's mandatory for
+ *          VFIO_DEVICE_FEATURE_MIGRATION migration support.
  */
 struct vfio_migration_ops {
 	struct file *(*migration_set_state)(
@@ -114,6 +117,8 @@ struct vfio_migration_ops {
 		enum vfio_device_mig_state new_state);
 	int (*migration_get_state)(struct vfio_device *device,
 				   enum vfio_device_mig_state *curr_state);
+	int (*migration_get_data_size)(struct vfio_device *device,
+				       unsigned long *stop_copy_length);
 };
 
 /**
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index d7d8e0922376..3e45dbaf190e 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1128,6 +1128,19 @@ struct vfio_device_feature_dma_logging_report {
 
 #define VFIO_DEVICE_FEATURE_DMA_LOGGING_REPORT 8
 
+/*
+ * Upon VFIO_DEVICE_FEATURE_GET read back the estimated data length that will
+ * be required to complete stop copy.
+ *
+ * Note: Can be called on each device state.
+ */
+
+struct vfio_device_feature_mig_data_size {
+	__aligned_u64 stop_copy_length;
+};
+
+#define VFIO_DEVICE_FEATURE_MIG_DATA_SIZE 9
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
-- 
2.18.1

