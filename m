Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487F1637E7C
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiKXRlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKXRlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:41:06 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A194134750
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:41:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qh0lTLQey7ddLyHxGlDL4z7dEZKOn/hT/KRVDrghgTxiMzGsrp2w/nRIDfUMG+SpAzqmzt2qbiNeZVNVsL2dSOMeeRDXxquj1iX4Nzfq8sv5CH1V9tC4fqImN+YrBLC/GNC1ViSXUaUFMzCjh6OZCdH/LrqrVcXZJKWoDF21/ksNf5WLgEOx+X7FSJ0VlrACi6lZWgFTXBqiP/ln9NVVL1a3OLkHN3vMexz9tZRwbu04OE0PlGtJFJoQqAL0pCyaWwvuvMQwHWXOUAuX7mXltRj59VIHHBsM5aSVIvj5VmPc3NOSx2ZBbALpiRyLyO/JTCrl7JTa3H33UfTF++UXqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQS+KQOxizDxGHkZ7U5cwX6aFNMTn9roIu/pBoI+w2M=;
 b=na7u8YGqCArXoWnPLJ3TOKvWMxX3uW9B82B4yRlo4AY3p/k7XdwxUij5xy2LxWzmhi6yH7pylEbOcOwjMmhPOujLiPPVEyQR200eX00/mQ3zRD7n870h4/9X5hGpSeyRIXzw2VlGn2C2usjwXI6KADU4rgKjfkSFtQnQxJ/7LmhThaTlUR60dJ0dy/07k5uemNFM6XxH/fqiq1lI2uA57bSZ4OvCU1AAZtA6KgOSx93drzwqK2iT0sbe+ik2WTRBgTDEtsV74geTv/P4ExkxqcRThdnESm4gAOPFDD/R5zLbEvCMBrA4AotXMs0dBJovE0gDvE+KKCHoSSO9bnfqUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQS+KQOxizDxGHkZ7U5cwX6aFNMTn9roIu/pBoI+w2M=;
 b=D5K6w8c3MCmPWn8DQmaU3BKnclfyU/MJ1zSaucib/pKA5P4OqmKrpQH3S8c2QwgkuZm4hAHY8vz2t4kOtKuUGw4xtd1eU+Ka3SsKsj6vZubR7OoPw/YLZuA+cEmMxQyJJC/m9qksOkGAYm5yqSXkQNRY0cK0d2OsYe0fYY7MjBLHXIc99K9WAZ801iduVDyIbAMnLQV9T6HoVZFsltqgNfuAoTj+3Mtjgs2QJNU40HHfQd/R0VqW2XdeSQUUacqw5kYbp+GahnpdivPTjizHH525KC2kaJxbrfOZDXFBPZDucrG2Ynz4NLUNsmrIiP6u9hQ4R954iVhFJnIlSEh6lA==
Received: from MW4PR04CA0252.namprd04.prod.outlook.com (2603:10b6:303:88::17)
 by SA0PR12MB4558.namprd12.prod.outlook.com (2603:10b6:806:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 17:41:01 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::91) by MW4PR04CA0252.outlook.office365.com
 (2603:10b6:303:88::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:41:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 17:41:01 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:59 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:59 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:56 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 12/14] vfio/mlx5: Introduce multiple loads
Date:   Thu, 24 Nov 2022 19:39:30 +0200
Message-ID: <20221124173932.194654-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|SA0PR12MB4558:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c050131-e1b2-401b-666a-08dace430daa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tRvcigfTKs0jz4DMtq/kHC2toAt+Yi8cNVQcx/PQNvMrxnRUqv2Mx1uYflcNnKgqgvwMdswEKaMgWDNrdpRQuCglREoyQ3KlZLW7lg2vcCzf4An32E5TCVAJGHLSlf7bfOAY4EmOP+pX1d3IMu4k55r4EmcpTOV2MsPSv38+/8B5r2/zoIPkskLnYyNoQQwEZLls8akDd9Z+CXVhJynN86MhXJ6yfIzVjyvcl1SZPIhrNeie90SxfZ68Z9NhwyzCSK0f7Kos2zIBuUhWrl3AbkN++EHWwzwNiR6Qc5A2i+wQCD9V4IIlmoNwUo1iiv+zs+ur0SyZiScdrrmEDO72P5Tu1+kmJf1cMIOZgdVG3dKirB8zw3Bk16Jlsp4kbZsu5Pkz6ZCMobCsfVdcwERG6M+/rEq9qaGm9o205TYNTcTarjrpzlDn5RSrW0OrJ4tvz2QCvXE8km4KtSv80qpmIe1WrCVaiJoSLf+f2vSEjVb+omvwz4kJ7tigVKdXDOIysk/ww8Loijmp3tOPn58Y9oUDHlraFzYE3Aj0JzpCLcIvmAP8gjpJYdw37GEYqgLkMdwOKahAhPwiIOWm55EDsh9VZOZAxfbP4UJ1bGQh0EAgPNSO47sP2MvC+VmlXQRoDkre1I6AlDNXL8infldwaFiFPU2bmLA2gZscfS1EpZG6WFDfPfOF6PhjPNnce+vixYw5gingmTFrFshiouiTgQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(426003)(2616005)(336012)(186003)(1076003)(47076005)(30864003)(36756003)(41300700001)(5660300002)(82310400005)(6666004)(26005)(8936002)(7696005)(86362001)(316002)(54906003)(110136005)(6636002)(8676002)(70206006)(40460700003)(4326008)(70586007)(478600001)(36860700001)(66899015)(82740400003)(2906002)(40480700001)(7636003)(356005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:41:01.2810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c050131-e1b2-401b-666a-08dace430daa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4558
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to support PRE_COPY, mlx5 driver transfers multiple states
(images) of the device. e.g.: the source VF can save and transfer
multiple states, and the target VF will load them by that order.

This patch implements the changes for the target VF to decompose the
header for each state and to write and load multiple states.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  13 +-
 drivers/vfio/pci/mlx5/cmd.h  |  10 ++
 drivers/vfio/pci/mlx5/main.c | 282 +++++++++++++++++++++++++++++------
 3 files changed, 260 insertions(+), 45 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 6ec71bc6be83..49a852a84283 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -598,9 +598,11 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
-	err = mlx5vf_dma_data_buffer(buf);
-	if (err)
-		return err;
+	if (!buf->dmaed) {
+		err = mlx5vf_dma_data_buffer(buf);
+		if (err)
+			return err;
+	}
 
 	MLX5_SET(load_vhca_state_in, in, opcode,
 		 MLX5_CMD_OP_LOAD_VHCA_STATE);
@@ -644,6 +646,11 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 		migf->buf = NULL;
 	}
 
+	if (migf->buf_header) {
+		mlx5vf_free_data_buffer(migf->buf_header);
+		migf->buf_header = NULL;
+	}
+
 	list_splice(&migf->avail_list, &migf->buf_list);
 
 	while ((entry = list_first_entry_or_null(&migf->buf_list,
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 67bc77605bc5..5ba094cabb2d 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -19,6 +19,14 @@ enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
+enum mlx5_vf_load_state {
+	MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER,
+	MLX5_VF_LOAD_STATE_READ_HEADER,
+	MLX5_VF_LOAD_STATE_PREP_IMAGE,
+	MLX5_VF_LOAD_STATE_READ_IMAGE,
+	MLX5_VF_LOAD_STATE_LOAD_IMAGE,
+};
+
 struct mlx5_vf_migration_header {
 	__le64 image_size;
 	/* For future use in case we may need to change the kernel protocol */
@@ -57,9 +65,11 @@ struct mlx5_vf_migration_file {
 	struct mutex lock;
 	enum mlx5_vf_migf_state state;
 
+	enum mlx5_vf_load_state load_state;
 	u32 pdn;
 	loff_t max_pos;
 	struct mlx5_vhca_data_buffer *buf;
+	struct mlx5_vhca_data_buffer *buf_header;
 	spinlock_t list_lock;
 	struct list_head buf_list;
 	struct list_head avail_list;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 28185085008f..0caaf4e8e1e9 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -202,6 +202,9 @@ static ssize_t mlx5vf_buf_read(struct mlx5_vhca_data_buffer *vhca_buf,
 	return done;
 }
 
+#define VFIO_PRE_COPY_SUPP(mvdev) \
+	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
+
 static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 			       loff_t *pos)
 {
@@ -513,13 +516,162 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev, bool track)
 	return ERR_PTR(ret);
 }
 
+static int
+mlx5vf_append_page_to_mig_buf(struct mlx5_vhca_data_buffer *vhca_buf,
+			      const char __user **buf, size_t *len,
+			      loff_t *pos, ssize_t *done)
+{
+	unsigned long offset;
+	size_t page_offset;
+	struct page *page;
+	size_t page_len;
+	u8 *to_buff;
+	int ret;
+
+	offset = *pos - vhca_buf->start_pos;
+	page_offset = offset % PAGE_SIZE;
+
+	page = mlx5vf_get_migration_page(vhca_buf, offset - page_offset);
+	if (!page)
+		return -EINVAL;
+	page_len = min_t(size_t, *len, PAGE_SIZE - page_offset);
+	to_buff = kmap_local_page(page);
+	ret = copy_from_user(to_buff + page_offset, *buf, page_len);
+	kunmap_local(to_buff);
+	if (ret)
+		return -EFAULT;
+
+	*pos += page_len;
+	*done += page_len;
+	*buf += page_len;
+	*len -= page_len;
+	vhca_buf->length += page_len;
+	return 0;
+}
+
+static int
+mlx5vf_resume_read_image_no_header(struct mlx5_vhca_data_buffer *vhca_buf,
+				   loff_t requested_length,
+				   const char __user **buf, size_t *len,
+				   loff_t *pos, ssize_t *done)
+{
+	int ret;
+
+	if (requested_length > MAX_MIGRATION_SIZE)
+		return -ENOMEM;
+
+	if (vhca_buf->allocated_length < requested_length) {
+		ret = mlx5vf_add_migration_pages(
+			vhca_buf,
+			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
+				     PAGE_SIZE));
+		if (ret)
+			return ret;
+	}
+
+	while (*len) {
+		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, len, pos,
+						    done);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static ssize_t
+mlx5vf_resume_read_image(struct mlx5_vf_migration_file *migf,
+			 struct mlx5_vhca_data_buffer *vhca_buf,
+			 size_t image_size, const char __user **buf,
+			 size_t *len, loff_t *pos, ssize_t *done,
+			 bool *has_work)
+{
+	size_t copy_len, to_copy;
+	int ret;
+
+	to_copy = min_t(size_t, *len, image_size - vhca_buf->length);
+	copy_len = to_copy;
+	while (to_copy) {
+		ret = mlx5vf_append_page_to_mig_buf(vhca_buf, buf, &to_copy, pos,
+						    done);
+		if (ret)
+			return ret;
+	}
+
+	*len -= copy_len;
+	if (vhca_buf->length == image_size) {
+		migf->load_state = MLX5_VF_LOAD_STATE_LOAD_IMAGE;
+		migf->max_pos += image_size;
+		*has_work = true;
+	}
+
+	return 0;
+}
+
+static int
+mlx5vf_resume_read_header(struct mlx5_vf_migration_file *migf,
+			  struct mlx5_vhca_data_buffer *vhca_buf,
+			  const char __user **buf,
+			  size_t *len, loff_t *pos,
+			  ssize_t *done, bool *has_work)
+{
+	struct page *page;
+	size_t copy_len;
+	u8 *to_buff;
+	int ret;
+
+	copy_len = min_t(size_t, *len,
+		sizeof(struct mlx5_vf_migration_header) - vhca_buf->length);
+	page = mlx5vf_get_migration_page(vhca_buf, 0);
+	if (!page)
+		return -EINVAL;
+	to_buff = kmap_local_page(page);
+	ret = copy_from_user(to_buff + vhca_buf->length, *buf, copy_len);
+	if (ret) {
+		ret = -EFAULT;
+		goto end;
+	}
+
+	*buf += copy_len;
+	*pos += copy_len;
+	*done += copy_len;
+	*len -= copy_len;
+	vhca_buf->length += copy_len;
+	if (vhca_buf->length == sizeof(struct mlx5_vf_migration_header)) {
+		u64 flags;
+
+		vhca_buf->header_image_size = le64_to_cpup((__le64 *)to_buff);
+		if (vhca_buf->header_image_size > MAX_MIGRATION_SIZE) {
+			ret = -ENOMEM;
+			goto end;
+		}
+
+		flags = le64_to_cpup((__le64 *)(to_buff +
+			    offsetof(struct mlx5_vf_migration_header, flags)));
+		if (flags) {
+			ret = -EOPNOTSUPP;
+			goto end;
+		}
+
+		migf->load_state = MLX5_VF_LOAD_STATE_PREP_IMAGE;
+		migf->max_pos += vhca_buf->length;
+		*has_work = true;
+	}
+end:
+	kunmap_local(to_buff);
+	return ret;
+}
+
 static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 				   size_t len, loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
 	struct mlx5_vhca_data_buffer *vhca_buf = migf->buf;
+	struct mlx5_vhca_data_buffer *vhca_buf_header = migf->buf_header;
 	loff_t requested_length;
+	bool has_work = false;
 	ssize_t done = 0;
+	int ret = 0;
 
 	if (pos)
 		return -ESPIPE;
@@ -529,56 +681,83 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 	    check_add_overflow((loff_t)len, *pos, &requested_length))
 		return -EINVAL;
 
-	if (requested_length > MAX_MIGRATION_SIZE)
-		return -ENOMEM;
-
+	mutex_lock(&migf->mvdev->state_mutex);
 	mutex_lock(&migf->lock);
 	if (migf->state == MLX5_MIGF_STATE_ERROR) {
-		done = -ENODEV;
+		ret = -ENODEV;
 		goto out_unlock;
 	}
 
-	if (vhca_buf->allocated_length < requested_length) {
-		done = mlx5vf_add_migration_pages(
-			vhca_buf,
-			DIV_ROUND_UP(requested_length - vhca_buf->allocated_length,
-				     PAGE_SIZE));
-		if (done)
-			goto out_unlock;
-	}
+	while (len || has_work) {
+		has_work = false;
+		switch (migf->load_state) {
+		case MLX5_VF_LOAD_STATE_READ_HEADER:
+			ret = mlx5vf_resume_read_header(migf, vhca_buf_header,
+							&buf, &len, pos,
+							&done, &has_work);
+			if (ret)
+				goto out_unlock;
+			break;
+		case MLX5_VF_LOAD_STATE_PREP_IMAGE:
+		{
+			u64 size = vhca_buf_header->header_image_size;
+
+			if (vhca_buf->allocated_length < size) {
+				mlx5vf_free_data_buffer(vhca_buf);
+
+				migf->buf = mlx5vf_alloc_data_buffer(migf,
+							size, DMA_TO_DEVICE);
+				if (IS_ERR(migf->buf)) {
+					ret = PTR_ERR(migf->buf);
+					migf->buf = NULL;
+					goto out_unlock;
+				}
 
-	while (len) {
-		size_t page_offset;
-		struct page *page;
-		size_t page_len;
-		u8 *to_buff;
-		int ret;
+				vhca_buf = migf->buf;
+			}
 
-		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(vhca_buf, *pos - page_offset);
-		if (!page) {
-			if (done == 0)
-				done = -EINVAL;
-			goto out_unlock;
+			vhca_buf->start_pos = migf->max_pos;
+			migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE;
+			break;
 		}
+		case MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER:
+			ret = mlx5vf_resume_read_image_no_header(vhca_buf,
+						requested_length,
+						&buf, &len, pos, &done);
+			if (ret)
+				goto out_unlock;
+			break;
+		case MLX5_VF_LOAD_STATE_READ_IMAGE:
+			ret = mlx5vf_resume_read_image(migf, vhca_buf,
+						vhca_buf_header->header_image_size,
+						&buf, &len, pos, &done, &has_work);
+			if (ret)
+				goto out_unlock;
+			break;
+		case MLX5_VF_LOAD_STATE_LOAD_IMAGE:
+			ret = mlx5vf_cmd_load_vhca_state(migf->mvdev, migf, vhca_buf);
+			if (ret)
+				goto out_unlock;
+			migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
 
-		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
-		to_buff = kmap_local_page(page);
-		ret = copy_from_user(to_buff + page_offset, buf, page_len);
-		kunmap_local(to_buff);
-		if (ret) {
-			done = -EFAULT;
-			goto out_unlock;
+			/* prep header buf for next image */
+			vhca_buf_header->length = 0;
+			vhca_buf_header->header_image_size = 0;
+			/* prep data buf for next image */
+			vhca_buf->length = 0;
+
+			break;
+		default:
+			break;
 		}
-		*pos += page_len;
-		len -= page_len;
-		done += page_len;
-		buf += page_len;
-		vhca_buf->length += page_len;
 	}
+
 out_unlock:
+	if (ret)
+		migf->state = MLX5_MIGF_STATE_ERROR;
 	mutex_unlock(&migf->lock);
-	return done;
+	mlx5vf_state_mutex_unlock(migf->mvdev);
+	return ret ? ret : done;
 }
 
 static const struct file_operations mlx5vf_resume_fops = {
@@ -618,12 +797,29 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	}
 
 	migf->buf = buf;
+	if (VFIO_PRE_COPY_SUPP(mvdev)) {
+		buf = mlx5vf_alloc_data_buffer(migf,
+			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto out_buf;
+		}
+
+		migf->buf_header = buf;
+		migf->load_state = MLX5_VF_LOAD_STATE_READ_HEADER;
+	} else {
+		/* Initial state will be to read the image */
+		migf->load_state = MLX5_VF_LOAD_STATE_READ_IMAGE_NO_HEADER;
+	}
+
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
 	INIT_LIST_HEAD(&migf->buf_list);
 	INIT_LIST_HEAD(&migf->avail_list);
 	spin_lock_init(&migf->list_lock);
 	return migf;
+out_buf:
+	mlx5vf_free_data_buffer(buf);
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
 out_free:
@@ -723,11 +919,13 @@ mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
 	}
 
 	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
-		ret = mlx5vf_cmd_load_vhca_state(mvdev,
-						 mvdev->resuming_migf,
-						 mvdev->resuming_migf->buf);
-		if (ret)
-			return ERR_PTR(ret);
+		if (!VFIO_PRE_COPY_SUPP(mvdev)) {
+			ret = mlx5vf_cmd_load_vhca_state(mvdev,
+							 mvdev->resuming_migf,
+							 mvdev->resuming_migf->buf);
+			if (ret)
+				return ERR_PTR(ret);
+		}
 		mlx5vf_disable_fds(mvdev);
 		return NULL;
 	}
-- 
2.18.1

