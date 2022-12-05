Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80C78642AAC
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiLEOts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiLEOtl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:41 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42F61C424
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbhj2c3YefK3t3fi7aa9TNntizdmur5zpA3WIv3pFRSwGVQT182dZhhxHVu69Jx7FTGIi5IlYdlaaq2lnYc3y5uXKoQeh29ZHEkoBLhrO3ewIt+ZrODRc5znI8r4yG2LjwwiCy5lGXmXficZ5XbVz0NtwF6XafEJNpFE/7DkBQPm8tbBCiQAYhF5Y1/oqKJd/UsOpCFM0C1dHDItFCt53Y+L3k1L8UQG55ctmFS8eKwqKgCEdsSqQa+xv15ePHru/us/bqb9qxhXIiz/Q4LXmq0JQ8mU4Or+otjfs8AiWYxuOmbTE97lJhgzNMPwW56TMJsx1uOq8R5VNODwsxd0iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mknVYAkYjeaZmtPY2XBE735t1zrTG3dCOphbrPb2urM=;
 b=XvGoRNANEpOLpq++5sxlYtL3jDfGg/9oADQEsCLecXkO1d3OQegI7DC/m7gmN7+d0sr89pxRPnGq7Ph4wP1oCF8y/lZGaFIKWL0jV6LFqejDVAHTvFLSpD+FVSR8o6/x6Hl/qCHsfhk6nBa5/eC5K2Fh+BGFF/NCCiuF4le8lqXiWtUJBePEmhnuxRnAv0Wzsx6fO+xLmO1EMrPp+xsbC6IHx3ooVnLK97WsIi3GyZwKughEv6/ddPI+dH02mf6QujFLh+OFWL1X/Q8TFqVCnTyue5LF7ytpE/NUg17ietKV0TX8paaAVXoDFnA29ukpX9Lc1lj7hewCM2+iG0m8iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mknVYAkYjeaZmtPY2XBE735t1zrTG3dCOphbrPb2urM=;
 b=NOihQxbQ0/85T2AFj6FMEHBLMefO5LlOqZX6YoZTy/EASnSPwRyBDAKX3CD+Admg6imoXF/KqeP7LaehjOEPDjcyaTOfUb/X2gK42RtmaRE54ZR4dnS3quKzuPUkJpw0xwyc32HCYCWCooyeU0S6ofcdhxzOG8817Bo7irMx4CTltv+i24Ze6AyqrT16oOl3OgfTm2QZMvJrRRZSughvQE6WW2jXlGg3sKWS7N6nYeW24mJossv2UPIQi9vsWfJGur+vRIEdnvOpvOpcILsvJeM7KhzhczSTw1CwH8wZXd9/BkJmsvrFB470CNNMx7ZGk0cWDgE6HwbW0ccaD7jnIQ==
Received: from MW4PR04CA0100.namprd04.prod.outlook.com (2603:10b6:303:83::15)
 by DM6PR12MB4545.namprd12.prod.outlook.com (2603:10b6:5:2a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 14:49:38 +0000
Received: from CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::1f) by MW4PR04CA0100.outlook.office365.com
 (2603:10b6:303:83::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT101.mail.protection.outlook.com (10.13.175.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 14:49:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:30 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:29 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:26 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 07/14] vfio/mlx5: Refactor to use queue based data chunks
Date:   Mon, 5 Dec 2022 16:48:31 +0200
Message-ID: <20221205144838.245287-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT101:EE_|DM6PR12MB4545:EE_
X-MS-Office365-Filtering-Correlation-Id: 1afe0933-77d4-4e95-d3c9-08dad6cfeee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cjk2S+7JJL9TyrD4YR+3sr64jTvUJK8cSKTbk9HemDBdmsbdSs+9mRzlmFH5UOiL8wzQ2DdlqqISlQsLRg89rmuNXpmuToEUOhUG9gYC/IwqKIiOaQK70zttNBkOTcK2dH09TgVNfZB5I/ng2bt4cMjXaN4R8IZJ78QDMoFyAUl8yOdIQ1VJ1ADNTL+XqixO5uSzNRd6+hG2/U2kZBg/qrYjYkjiCNseGiq933kKjnAss+qO07llIKMu3bFj7FG1fCWHo09XrjzdyN/CF/cOcGFIj/aoXhHCLhV3vmDlAF5eMsVWa3BAFTcZTa/l+vJma/SNR47NczE4OYb6E5pf3w9yipWqn6lmpaFbNj5ISN3D8bz0nIOIhEGAQ8/Tg9rSmQaWcjFReOFQBxlElgtqb9rkGkGNrA6cemka9R7/tUQl4QDIvd50JIo4SoWVRpp/PjEaNsGk1vD6kqX0iJ4XJdceJ3tmfzUMxAaKj+wAHzCzbA7TeSW8Nzeh3rdCCIS4pgA1+FhCOVk2+nUcd7KNDVi9gfw4gWXyBsKCsN/ahMZebBWJgRL7rPs4vUM4KNXfcazlyKZG1d4Glb5p6NrZhI0G98ExsltMNTECCG6diA4cEmBqKj+o7MJ/BqiRbRJP0ikCvHKZ4oebDfcNazVTNHrpxQpTbm9xVja05YnmxMuv0bDIQgmaSlmSVlooMUux8Ejot2ktlNpAQSpnMLv6iQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(40480700001)(36756003)(86362001)(40460700003)(7636003)(7696005)(478600001)(70586007)(70206006)(4326008)(8936002)(41300700001)(5660300002)(6666004)(8676002)(54906003)(316002)(2906002)(110136005)(6636002)(36860700001)(82310400005)(82740400003)(356005)(336012)(26005)(2616005)(83380400001)(186003)(1076003)(426003)(47076005)(66899015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:37.9826
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1afe0933-77d4-4e95-d3c9-08dad6cfeee2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4545
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor to use queue based data chunks on the migration file.

The SAVE command adds a chunk to the tail of the queue while the read()
API finds the required chunk and returns its data.

In case the queue is empty but the state of the migration file is
MLX5_MIGF_STATE_COMPLETE, read() may not be blocked but will return 0 to
indicate end of file.

This is a step towards maintaining multiple images and their meta data
(i.e. headers) on the migration file as part of next patches from the
series.

Note:
At that point, we still use a single chunk on the migration file but
becomes ready to support multiple.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  24 +++++-
 drivers/vfio/pci/mlx5/cmd.h  |   5 ++
 drivers/vfio/pci/mlx5/main.c | 145 +++++++++++++++++++++++++++--------
 3 files changed, 136 insertions(+), 38 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index fcba12326185..0e36b4c8c816 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -351,6 +351,7 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
+		migf->buf = async_data->buf;
 		migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
@@ -368,9 +369,15 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 			struct mlx5_vf_migration_file, async_data);
 
 	if (!status) {
-		WRITE_ONCE(migf->buf->length,
-			   MLX5_GET(save_vhca_state_out, async_data->out,
-				    actual_image_size));
+		unsigned long flags;
+
+		async_data->buf->length =
+			MLX5_GET(save_vhca_state_out, async_data->out,
+				 actual_image_size);
+		spin_lock_irqsave(&migf->list_lock, flags);
+		list_add_tail(&async_data->buf->buf_elm, &migf->buf_list);
+		spin_unlock_irqrestore(&migf->list_lock, flags);
+		migf->state = MLX5_MIGF_STATE_COMPLETE;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
@@ -407,6 +414,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	MLX5_SET(save_vhca_state_in, in, size, buf->allocated_length);
 
 	async_data = &migf->async_data;
+	async_data->buf = buf;
 	async_data->out = kvzalloc(out_size, GFP_KERNEL);
 	if (!async_data->out) {
 		err = -ENOMEM;
@@ -479,14 +487,22 @@ void mlx5vf_cmd_dealloc_pd(struct mlx5_vf_migration_file *migf)
 
 void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 {
-	lockdep_assert_held(&migf->mvdev->state_mutex);
+	struct mlx5_vhca_data_buffer *entry;
 
+	lockdep_assert_held(&migf->mvdev->state_mutex);
 	WARN_ON(migf->mvdev->mdev_detach);
 
 	if (migf->buf) {
 		mlx5vf_free_data_buffer(migf->buf);
 		migf->buf = NULL;
 	}
+
+	while ((entry = list_first_entry_or_null(&migf->buf_list,
+				struct mlx5_vhca_data_buffer, buf_elm))) {
+		list_del(&entry->buf_elm);
+		mlx5vf_free_data_buffer(entry);
+	}
+
 	mlx5vf_cmd_dealloc_pd(migf);
 }
 
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 14403e654e4e..6e594689566e 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -14,6 +14,7 @@
 
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
+	MLX5_MIGF_STATE_COMPLETE,
 };
 
 struct mlx5_vhca_data_buffer {
@@ -24,6 +25,7 @@ struct mlx5_vhca_data_buffer {
 	u32 mkey;
 	enum dma_data_direction dma_dir;
 	u8 dmaed:1;
+	struct list_head buf_elm;
 	struct mlx5_vf_migration_file *migf;
 	/* Optimize mlx5vf_get_migration_page() for sequential access */
 	struct scatterlist *last_offset_sg;
@@ -34,6 +36,7 @@ struct mlx5_vhca_data_buffer {
 struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
+	struct mlx5_vhca_data_buffer *buf;
 	int status;
 	void *out;
 };
@@ -45,6 +48,8 @@ struct mlx5_vf_migration_file {
 
 	u32 pdn;
 	struct mlx5_vhca_data_buffer *buf;
+	spinlock_t list_lock;
+	struct list_head buf_list;
 	struct mlx5vf_pci_core_device *mvdev;
 	wait_queue_head_t poll_wait;
 	struct completion save_comp;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index d95646c2f010..ca16425811c4 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -124,11 +124,90 @@ static int mlx5vf_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static struct mlx5_vhca_data_buffer *
+mlx5vf_get_data_buff_from_pos(struct mlx5_vf_migration_file *migf, loff_t pos,
+			      bool *end_of_data)
+{
+	struct mlx5_vhca_data_buffer *buf;
+	bool found = false;
+
+	*end_of_data = false;
+	spin_lock_irq(&migf->list_lock);
+	if (list_empty(&migf->buf_list)) {
+		*end_of_data = true;
+		goto end;
+	}
+
+	buf = list_first_entry(&migf->buf_list, struct mlx5_vhca_data_buffer,
+			       buf_elm);
+	if (pos >= buf->start_pos &&
+	    pos < buf->start_pos + buf->length) {
+		found = true;
+		goto end;
+	}
+
+	/*
+	 * As we use a stream based FD we may expect having the data always
+	 * on first chunk
+	 */
+	migf->state = MLX5_MIGF_STATE_ERROR;
+
+end:
+	spin_unlock_irq(&migf->list_lock);
+	return found ? buf : NULL;
+}
+
+static ssize_t mlx5vf_buf_read(struct mlx5_vhca_data_buffer *vhca_buf,
+			       char __user **buf, size_t *len, loff_t *pos)
+{
+	unsigned long offset;
+	ssize_t done = 0;
+	size_t copy_len;
+
+	copy_len = min_t(size_t,
+			 vhca_buf->start_pos + vhca_buf->length - *pos, *len);
+	while (copy_len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *from_buff;
+		int ret;
+
+		offset = *pos - vhca_buf->start_pos;
+		page_offset = offset % PAGE_SIZE;
+		offset -= page_offset;
+		page = mlx5vf_get_migration_page(vhca_buf, offset);
+		if (!page)
+			return -EINVAL;
+		page_len = min_t(size_t, copy_len, PAGE_SIZE - page_offset);
+		from_buff = kmap_local_page(page);
+		ret = copy_to_user(*buf, from_buff + page_offset, page_len);
+		kunmap_local(from_buff);
+		if (ret)
+			return -EFAULT;
+		*pos += page_len;
+		*len -= page_len;
+		*buf += page_len;
+		done += page_len;
+		copy_len -= page_len;
+	}
+
+	if (*pos >= vhca_buf->start_pos + vhca_buf->length) {
+		spin_lock_irq(&vhca_buf->migf->list_lock);
+		list_del_init(&vhca_buf->buf_elm);
+		spin_unlock_irq(&vhca_buf->migf->list_lock);
+	}
+
+	return done;
+}
+
 static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 			       loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
-	struct mlx5_vhca_data_buffer *vhca_buf = migf->buf;
+	struct mlx5_vhca_data_buffer *vhca_buf;
+	bool first_loop_call = true;
+	bool end_of_data;
 	ssize_t done = 0;
 
 	if (pos)
@@ -137,53 +216,47 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     READ_ONCE(vhca_buf->length) ||
-			     migf->state == MLX5_MIGF_STATE_ERROR))
+				!list_empty(&migf->buf_list) ||
+				migf->state == MLX5_MIGF_STATE_ERROR ||
+				migf->state == MLX5_MIGF_STATE_COMPLETE))
 			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&migf->lock);
-	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(vhca_buf->length)) {
-		done = -EAGAIN;
-		goto out_unlock;
-	}
-	if (*pos > vhca_buf->length) {
-		done = -EINVAL;
-		goto out_unlock;
-	}
 	if (migf->state == MLX5_MIGF_STATE_ERROR) {
 		done = -ENODEV;
 		goto out_unlock;
 	}
 
-	len = min_t(size_t, vhca_buf->length - *pos, len);
 	while (len) {
-		size_t page_offset;
-		struct page *page;
-		size_t page_len;
-		u8 *from_buff;
-		int ret;
+		ssize_t count;
+
+		vhca_buf = mlx5vf_get_data_buff_from_pos(migf, *pos,
+							 &end_of_data);
+		if (first_loop_call) {
+			first_loop_call = false;
+			if (end_of_data && migf->state != MLX5_MIGF_STATE_COMPLETE) {
+				if (filp->f_flags & O_NONBLOCK) {
+					done = -EAGAIN;
+					goto out_unlock;
+				}
+			}
+		}
 
-		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(vhca_buf, *pos - page_offset);
-		if (!page) {
-			if (done == 0)
-				done = -EINVAL;
+		if (end_of_data)
+			goto out_unlock;
+
+		if (!vhca_buf) {
+			done = -EINVAL;
 			goto out_unlock;
 		}
 
-		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
-		from_buff = kmap_local_page(page);
-		ret = copy_to_user(buf, from_buff + page_offset, page_len);
-		kunmap_local(from_buff);
-		if (ret) {
-			done = -EFAULT;
+		count = mlx5vf_buf_read(vhca_buf, &buf, &len, pos);
+		if (count < 0) {
+			done = count;
 			goto out_unlock;
 		}
-		*pos += page_len;
-		len -= page_len;
-		done += page_len;
-		buf += page_len;
+		done += count;
 	}
 
 out_unlock:
@@ -202,7 +275,8 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	mutex_lock(&migf->lock);
 	if (migf->state == MLX5_MIGF_STATE_ERROR)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
-	else if (READ_ONCE(migf->buf->length))
+	else if (!list_empty(&migf->buf_list) ||
+		 migf->state == MLX5_MIGF_STATE_COMPLETE)
 		pollflags = EPOLLIN | EPOLLRDNORM;
 	mutex_unlock(&migf->lock);
 
@@ -253,6 +327,8 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	complete(&migf->save_comp);
 	mlx5_cmd_init_async_ctx(mvdev->mdev, &migf->async_ctx);
 	INIT_WORK(&migf->async_data.work, mlx5vf_mig_file_cleanup_cb);
+	INIT_LIST_HEAD(&migf->buf_list);
+	spin_lock_init(&migf->list_lock);
 	ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &length);
 	if (ret)
 		goto out_pd;
@@ -266,7 +342,6 @@ mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf);
 	if (ret)
 		goto out_save;
-	migf->buf = buf;
 	return migf;
 out_save:
 	mlx5vf_free_data_buffer(buf);
@@ -386,6 +461,8 @@ mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
 	migf->buf = buf;
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
+	INIT_LIST_HEAD(&migf->buf_list);
+	spin_lock_init(&migf->list_lock);
 	return migf;
 out_pd:
 	mlx5vf_cmd_dealloc_pd(migf);
-- 
2.18.1

