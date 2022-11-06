Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7704261E509
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiKFRsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiKFRrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:45 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01523657D
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUMhRKj0aYe+XkUoKbJ2NB8ZdQWs2fLS62kCIvxms8z2FokCMbOrrpHChauVPRscfAeemVbbrcHpS0HuDd4DSljVFXRKJjcibUN117aBj4oFuzV6lh8mb4ytW61rf3P/o3vs7zmH3+FNBo78Vv0A7J4pM8RLjD743Iz+QRhogFz3ei34REjpE0YwBy5GGsLQ+yuj8P8KBMfdsPAOndYE+R/M0GgiN+8m6KFHtqOrb33gnCsMdkngGRcIFZhY4QqpQytTjDbBUwaUolV13eRgIbZWvokFGM7J1PatW3X+Q+3lYP1Z1fVwNjQEP90nRFupK3zNhZVZF/JNax5ndXWTKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCZMaXfF/czc2VaRVZLUMNEQLdeNsGTaq65WXvaUMW4=;
 b=M9wfT8Eq/0AjhAsAD8ITwugUWMQWDnWQ9FMRqH/ZaPfV2Pl3yiVAu7ej65tJKaAokkf93RFnZJcY+WO8+tfZdYpeT31ao8Lv8NDH8U0mc62eYZ1Pt0TexuiGSN1mHbimWbC8+wcNdklmtSfOKcz4OEIPg0co4GFpMmSJznS4IRwRT92C5lULjcjolcJIVFUD3HukL1LD5paVtcDXwihxjfhT+EvJeH3ti/i2YXBfUEFN4jIeSpodZrQSQTlZPPzPdjyTRkME5zpHWTZoY9Op/9Jdwb4rc7+Vwfzy1sz7wvPYARvPZ5rIYrCwznE1pZaLojQwTHV4MMDUMrRyxh1VQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCZMaXfF/czc2VaRVZLUMNEQLdeNsGTaq65WXvaUMW4=;
 b=X+WhRrVzov+qhkKYpkB8A7kXBW0EKUMgz6LKbL8i5JClZpQFXyw7Ul3nzlb/9dY1thtFeTpa9SedlxOM9QOIuLEtqk5ub55DNkYFoH8rDHAvKE0DJwAU0T0sgGp+UNvHa1n/ZXx4yNpAaCAgK+aeYq5MlnzYzadd+cWohJdUzl8cO8uDeB49oyQ02SBfAqRxenmhTYasRGvoR+lt6/yZJR1RZA8l7KngNeSXcf5txDOZ9jFBjqUz7yHRopD2olpMJ6d/D0iRAv5NppyvlV9taNJ2wlq2+gSFBqmXLTAA5OuJqNH8OgnoaK24QAySJelLid3IZU6N+rTLFT51UhX/ZQ==
Received: from DM6PR08CA0059.namprd08.prod.outlook.com (2603:10b6:5:1e0::33)
 by CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:36 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::d) by DM6PR08CA0059.outlook.office365.com
 (2603:10b6:5:1e0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:36 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:35 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:35 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:32 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 09/13] vfio/mlx5: Manage read() of multiple state saves
Date:   Sun, 6 Nov 2022 19:46:26 +0200
Message-ID: <20221106174630.25909-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT058:EE_|CH0PR12MB5330:EE_
X-MS-Office365-Filtering-Correlation-Id: e1fe64c0-438b-443e-e889-08dac01efdac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vDmoFIRSQDlJseQs0mwtg7v6soPVfVUDVCPgxYZ+HR0HSqSzOJ3ddEYetiLjKh09QGEvjmmQjRHBE+bvFoJ2S2/X+gQ4pmr1uxNpBDqAXvT4W53zjLWPJlr3iwUTwQpzgHQVzcpHR6NRIF9cU//uCIURG7A5Z1CEVXcuISN1BmYNjYqZe2EzDqQTN9wYgANMOMNCiS66GxjcvDcLoAUjeFQSzQ+yIL92+nAmQZQgqUoSmJPPG/zpAW/6E+R+0VcLAZheAPmq5j8Lm8/5cp84o6SLabccFcERfvDCiquzjehILnEb3dL91E7MzZgS53bFySGav5JChOamnX2ZgdsAtDzvtvoKbBstUjs2CVTveGrg3C77EbDNmVEyWElo9WelQqqQg9Ut1jGqSD6YMPr6dtoIRlZfx3HAR5FI45k03LwcdMg1Yt3D1I3pvG/AOZ5hHB8Ek9ZRPWX+criqMnNPlXRk3LObvNA1cR/n7xn36G1Z8nbVowDZBoarzdGoErr77Q1EYVmtGRCFE5I7TH3TuF5dta5nslqrzhVVVDY3i1CTELpCwonrfwkNkdVCCzW82rUZvfCvDs9gVPXNrEbt404Tzkh45N+mc5YHHIqu9MrKQif2iVVcpNUH7wU6/5hDHhPCTnhuJ8/ug7/5skbKMWwOUXGKBUliCShx1zdoZIeKIK4tV6RjgdRVEw/kHYks5Oiqej2amSWg+7htl+rufhsNNzCM1dZaT/xrDMmAfqnD9E347ya/BuAfSq5kxx8i9dSgxorf8ult7pR4cWzAcA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199015)(40470700004)(36840700001)(46966006)(478600001)(2616005)(110136005)(6636002)(5660300002)(8936002)(36756003)(6666004)(47076005)(26005)(36860700001)(186003)(316002)(1076003)(336012)(86362001)(7696005)(426003)(40480700001)(4326008)(8676002)(70586007)(54906003)(70206006)(82740400003)(41300700001)(40460700003)(2906002)(82310400005)(356005)(83380400001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:36.2459
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1fe64c0-438b-443e-e889-08dac01efdac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5330
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Since all the states that were mentioned in previous patches are
transferred over the same FD, on one hand, and mlx5 keeps one data
structure per state, on the other hand, mlx5 needs to manage the delta
between FD position and the current state (data structure) transferred.

Also, as mentioned in previous patch, user can switch VFIO device to
STOP_COPY without transferring any data in PRE_COPY state. Hence, the
delta management of the final state has a dedicated data structure.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 115 ++++++++++++++++++++++++++++++-----
 1 file changed, 100 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 266626066fed..8a5714158e43 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -34,7 +34,7 @@ static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
 
 static struct page *
 mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
-			  unsigned long offset)
+			  unsigned long offset, struct sg_append_table *table)
 {
 	unsigned long cur_offset = 0;
 	struct scatterlist *sg;
@@ -43,14 +43,14 @@ mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
 	/* All accesses are sequential */
 	if (offset < migf->last_offset || !migf->last_offset_sg) {
 		migf->last_offset = 0;
-		migf->last_offset_sg = migf->table.sgt.sgl;
+		migf->last_offset_sg = table->sgt.sgl;
 		migf->sg_last_entry = 0;
 	}
 
 	cur_offset = migf->last_offset;
 
 	for_each_sg(migf->last_offset_sg, sg,
-			migf->table.sgt.orig_nents - migf->sg_last_entry, i) {
+			table->sgt.orig_nents - migf->sg_last_entry, i) {
 		if (offset < sg->length + cur_offset) {
 			migf->last_offset_sg = sg;
 			migf->sg_last_entry += i;
@@ -161,10 +161,45 @@ static int mlx5vf_release_file(struct inode *inode, struct file *filp)
 	(mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY || \
 	 mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY_P2P)
 
+#define VFIO_PRE_COPY_SUPP(mvdev) \
+	(mvdev->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
+
+#define MIGF_HAS_DATA(migf) \
+	(READ_ONCE(migf->image_length) || READ_ONCE(migf->final_length))
+
+static size_t
+mlx5vf_final_table_start_pos(struct mlx5_vf_migration_file *migf)
+{
+	return MIGF_TOTAL_DATA(migf) - migf->final_length;
+}
+
+static size_t mlx5vf_get_table_start_pos(struct mlx5_vf_migration_file *migf)
+{
+	return migf->table_start_pos;
+}
+
+static size_t mlx5vf_get_table_end_pos(struct mlx5_vf_migration_file *migf,
+				       struct sg_append_table *table)
+{
+	if (table == &migf->final_table)
+		return MIGF_TOTAL_DATA(migf);
+	return migf->table_start_pos + migf->image_length;
+}
+
+static struct sg_append_table *
+mlx5vf_get_table(struct mlx5_vf_migration_file *migf, loff_t *pos)
+{
+	if (migf->final_length &&
+	    *pos >= mlx5vf_final_table_start_pos(migf))
+		return &migf->final_table;
+	return &migf->table;
+}
+
 static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 			       loff_t *pos)
 {
 	struct mlx5_vf_migration_file *migf = filp->private_data;
+	struct sg_append_table *table;
 	ssize_t done = 0;
 
 	if (pos)
@@ -173,16 +208,16 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 
 	if (!(filp->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(migf->poll_wait,
-			     READ_ONCE(migf->image_length) || migf->is_err))
+			     (MIGF_HAS_DATA(migf) || migf->is_err)))
 			return -ERESTARTSYS;
 	}
 
 	mutex_lock(&migf->lock);
-	if ((filp->f_flags & O_NONBLOCK) && !READ_ONCE(migf->image_length)) {
+	if ((filp->f_flags & O_NONBLOCK) && !MIGF_HAS_DATA(migf)) {
 		done = -EAGAIN;
 		goto out_unlock;
 	}
-	if (*pos > migf->image_length) {
+	if (*pos > MIGF_TOTAL_DATA(migf)) {
 		done = -EINVAL;
 		goto out_unlock;
 	}
@@ -191,16 +226,28 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		goto out_unlock;
 	}
 
-	len = min_t(size_t, migf->image_length - *pos, len);
+	/* If we reach the end of the PRE_COPY size */
+	if (MIGF_TOTAL_DATA(migf) == *pos &&
+	    VFIO_MIG_STATE_PRE_COPY(migf->mvdev)) {
+		done = -ENOMSG;
+		goto out_unlock;
+	}
+
+	len = min_t(size_t, MIGF_TOTAL_DATA(migf) - *pos, len);
+	table = mlx5vf_get_table(migf, pos);
 	while (len) {
+		struct sg_append_table *tmp = table;
+		unsigned long offset;
 		size_t page_offset;
 		struct page *page;
 		size_t page_len;
 		u8 *from_buff;
 		int ret;
 
-		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(migf, *pos - page_offset);
+		offset = *pos - mlx5vf_get_table_start_pos(migf);
+		page_offset = offset % PAGE_SIZE;
+		offset -= page_offset;
+		page = mlx5vf_get_migration_page(migf, offset, table);
 		if (!page) {
 			if (done == 0)
 				done = -EINVAL;
@@ -208,6 +255,12 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		}
 
 		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		/*
+		 * In case an image is ended in the middle of the page, read
+		 * until the end of the image and manage it.
+		 */
+		page_len = min_t(size_t, page_len,
+				 mlx5vf_get_table_end_pos(migf, table) - *pos);
 		from_buff = kmap_local_page(page);
 		ret = copy_to_user(buf, from_buff + page_offset, page_len);
 		kunmap_local(from_buff);
@@ -219,6 +272,23 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		len -= page_len;
 		done += page_len;
 		buf += page_len;
+		/*
+		 * In case we moved from PRE_COPY to STOP_COPY we need to prepare
+		 * migf for final state when current state was fully transferred.
+		 * Otherwise we might miss the final table and caller may get EOF
+		 * by next read().
+		 */
+		if (migf->final_table.sgt.sgl &&
+		    *pos == mlx5vf_final_table_start_pos(migf)) {
+			mlx5vf_prep_next_table(migf);
+			table = mlx5vf_get_table(migf, pos);
+			/*
+			 * Check whether the SAVE command has finished and we
+			 * have some extra data.
+			 */
+			if (tmp == table)
+				break;
+		}
 	}
 
 out_unlock:
@@ -237,7 +307,7 @@ static __poll_t mlx5vf_save_poll(struct file *filp,
 	mutex_lock(&migf->lock);
 	if (migf->disabled || migf->is_err)
 		pollflags = EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
-	else if (READ_ONCE(migf->image_length))
+	else if (MIGF_HAS_DATA(migf))
 		pollflags = EPOLLIN | EPOLLRDNORM;
 	mutex_unlock(&migf->lock);
 
@@ -380,20 +450,34 @@ static int mlx5vf_pci_save_device_inc_data(struct mlx5vf_pci_core_device *mvdev)
 	if (ret)
 		return ret;
 
-	if (migf->is_err)
-		return -ENODEV;
-
+	mutex_lock(&migf->lock);
+	if (migf->is_err) {
+		ret = -ENODEV;
+		goto err;
+	}
+	/*
+	 * We finished transferring the current state, prepare migf for final
+	 * table. Otherwise we might miss the final table and caller may get
+	 * EOF by next read().
+	 */
+	if (migf->filp->f_pos == MIGF_TOTAL_DATA(migf))
+		mlx5vf_prep_next_table(migf);
 	ret = mlx5vf_add_migration_pages(
 		migf, DIV_ROUND_UP_ULL(length, PAGE_SIZE), &migf->final_table);
 	if (ret) {
 		mlx5vf_mark_err(migf);
-		return ret;
+		goto err;
 	}
 
+	mutex_unlock(&migf->lock);
 	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, true, false);
 	if (ret)
 		mlx5vf_mark_err(migf);
 	return ret;
+
+err:
+	mutex_unlock(&migf->lock);
+	return ret;
 }
 
 static struct mlx5_vf_migration_file *
@@ -482,7 +566,8 @@ static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
 		int ret;
 
 		page_offset = (*pos) % PAGE_SIZE;
-		page = mlx5vf_get_migration_page(migf, *pos - page_offset);
+		page = mlx5vf_get_migration_page(migf, *pos - page_offset,
+						 &migf->table);
 		if (!page) {
 			if (done == 0)
 				done = -EINVAL;
-- 
2.18.1

