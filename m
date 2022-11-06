Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D312D61E50A
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 18:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbiKFRsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 12:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiKFRrr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 12:47:47 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5DA643F
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 09:47:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEqOysOCR0+Fal1NgdLiB59i7JCL4YajMSqrb2Ny/gyABTTb5Ua3J/U6sUMiI0HQzweyCTPLOM5gdjMZcI6mo/aoYjktgv6a4ZihdLQwv1cKxueG0LZDSk4+bWb91/Loi3Esw9o4nzUhjWV20OcfLEE+LmXlFq2X2PaazDcYG/yAs9ZoQBdMDXnWvv5TpN9MRoWH2MfV7yvsCQK8V0qveKP8bZKeKPPaAJ2j75GVdqzDU/5jDAKcGUABZb6wMdb3iUaMXnWhLk+ixwToctT35nin4dAN20axOYzF66LPxT5irFa6MU3YBtXKuuusarQ+58GphfITY/XYcSib3FYsbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJQc+mXFz/oqtDITqBEJvX3FM0Qz3Kx3G6cS6v7sx0Q=;
 b=kqLuSY4iCitz5m7Q8HNBO7rQ5QhryGw6IKg5WyJjA0xgLXzR0G9QXEXD5U5g9PWJc3AW4oy0BWmnvMlP8RHp1Vey7GjYKT0lykqQ6dk4Vr0HfeGxgQLF1L1aiazAAisklyjB/Pb+WXavF3verIi5xJwym5gSgcQ79jW5Bg4iKwsqituqtClrmNIQl9zqf/RlGlTAjwvD3xAwUiWl+PfJCQZLcrZ8dEpkzTNOcm+ksGpvZtmNE7vWzaqkDJcG8bA/SyvZL1GthEBawUy8g5Sa292CpM/BurS5+Vg0hV7E1AQz2G/qixbjI/aWYzvHMVcaazZxiEYqoZctgikc4/eIjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJQc+mXFz/oqtDITqBEJvX3FM0Qz3Kx3G6cS6v7sx0Q=;
 b=JcmH8ZFNHwMKJgN8hsnODegOzbG7fovkj9TtZFU95t2ADO6RBielOQH7dDdAo0FR+UXv9ynXRVBxqqHrYSRmlXmUOxKca9WozjshWeM5PgB+2eMAI/K0ZkbjKChNSn9Jq7hLox2IR+FbmjOOvu1tuqPEDkg4vZpZmq/PdlkED6hoYkSA4PCV/zCSY04hCTPXfTQUHdZAn0DP2EM6OBfo4GMII/K3jS1XbAxsxSNuT3fARP58PhhH3oGoUdfZeP9Bb3nUBfKK+EgxNyzQilCTVRwkBuIhb/2xIJ7wsUX5PTsj6DUg5p09zOSAsyYhwxAoFNgrwDfzAWqxFwlbdSqTuw==
Received: from DM6PR06CA0010.namprd06.prod.outlook.com (2603:10b6:5:120::23)
 by PH7PR12MB5710.namprd12.prod.outlook.com (2603:10b6:510:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 17:47:39 +0000
Received: from DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::13) by DM6PR06CA0010.outlook.office365.com
 (2603:10b6:5:120::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25 via Frontend
 Transport; Sun, 6 Nov 2022 17:47:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT111.mail.protection.outlook.com (10.13.173.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Sun, 6 Nov 2022 17:47:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 6 Nov 2022
 09:47:38 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Sun, 6 Nov 2022 09:47:38 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Sun, 6 Nov 2022 09:47:35 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH vfio 10/13] vfio/mlx5: Introduce SW headers for migration states
Date:   Sun, 6 Nov 2022 19:46:27 +0200
Message-ID: <20221106174630.25909-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221106174630.25909-1-yishaih@nvidia.com>
References: <20221106174630.25909-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT111:EE_|PH7PR12MB5710:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ba7ff8a-8aa4-4a4f-15e0-08dac01eff6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGJp1VzIKyKIPe6fskKtWUhkSkAmkkjgMlB3583LJgsbnZnhaoeGW8urlemGhLLGYnYnCDW/G/jV/JHktV6qZzzs8uyzEfCLxePHSjbanCQjywAzAgZf4xWxv136g5RiWi4Ajh/K/O4w6/PwlBYv7zBI+e+UqTUlLNHfOCW981frV4K76CzQFwVwu49BE9vjCzf8d35jSu9+bCxC+Trh0JwpAO7llTVXypna1jBBK6KFR+D92n92pV3Bj43Y6xegw/84XPJxhaaEKN4aqxCNxAVv3sJf3LIWME89le+C+16+Q6StKBOWFNPIzCnP9kU4FdAtQYhfKnWsKNUVl336yZTxPW3KrXFzYYXhJe9nUu9JwrD5ADHFHJm6+Qb7cMFdzq3bqQLb1BS78Egr+XQgmm/67MkrCFDBjVLtM6H45Mvj6V/2ilKV14wj2/0K4nJS41XSAB3ET7XPIFJgkkLQYx8OSRGnjD/93wPgKquTxTBB2K0GWTdpW4c/a2rOJ6+cAw8YZXr8xNLgaD53ikfL4+EPDB3J8kfKn8yqLp/ci2AAha4ICMsY2DLHm759Je7nFgUfn9JAMoCUMJyFytvhyjUhm44iaIdyhOyK6VmMXZLUTYgbKRaBqWFQVM0deIwclIXVu00L7jRdJUIkLPVYwmwGJS5J4FNZKSJkbqcF8hLV4Ae4PRgPrI0LgCaZ4b+nMD+aqSphP8fOZdLL9NY2IjNOu/qanR86QWfSeh9WeC/kpmTq4MHRETR2Qi7GwOEDD59WFPmWCfGAVnhftrmNuQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(40470700004)(46966006)(36840700001)(40480700001)(36756003)(86362001)(7636003)(356005)(6636002)(54906003)(316002)(36860700001)(82310400005)(478600001)(82740400003)(26005)(6666004)(70206006)(8676002)(4326008)(40460700003)(7696005)(110136005)(8936002)(5660300002)(70586007)(47076005)(1076003)(83380400001)(336012)(426003)(186003)(2616005)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 17:47:39.1675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ba7ff8a-8aa4-4a4f-15e0-08dac01eff6d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT111.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5710
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

As mentioned in the previous patches, mlx5 is transferring multiple
states when the PRE_COPY protocol is used. This states mechanism
requires the target VM to know the states' size in order to execute
multiple loads.
Therefore, add SW header, with the needed information, for each saved
state the source VM is transferring to the target VM.

This patch implements the source VM handling of the headers, following
patch will implement the target VM handling of the headers.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.h  |  7 +++++
 drivers/vfio/pci/mlx5/main.c | 50 +++++++++++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 07a2fc54c9d8..3b0411e4a74e 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -22,17 +22,24 @@ struct mlx5vf_async_data {
 	void *out;
 };
 
+struct mlx5_vf_migration_header {
+	u32 image_size;
+	u32 reserved;
+};
+
 struct mlx5_vf_migration_file {
 	struct file *filp;
 	struct mutex lock;
 	u8 disabled:1;
 	u8 is_err:1;
 	u8 save_cb_active:1;
+	u8 header_read:1;
 
 	struct sg_append_table table;
 	size_t table_start_pos;
 	size_t image_length;
 	size_t allocated_length;
+	size_t sw_headers_bytes_sent;
 	/*
 	 * The device can be moved to stop_copy before the previous state was
 	 * fully read. Another set of variables is needed to maintain it.
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 8a5714158e43..c0ee121bd5ea 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -121,6 +121,7 @@ static void mlx5vf_prep_next_table(struct mlx5_vf_migration_file *migf)
 	migf->image_length = 0;
 	migf->allocated_length = 0;
 	migf->last_offset_sg = NULL;
+	migf->header_read = false;
 }
 
 static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
@@ -155,7 +156,8 @@ static int mlx5vf_release_file(struct inode *inode, struct file *filp)
 }
 
 #define MIGF_TOTAL_DATA(migf) \
-	(migf->table_start_pos + migf->image_length + migf->final_length)
+	(migf->table_start_pos + migf->image_length + migf->final_length + \
+	 migf->sw_headers_bytes_sent)
 
 #define VFIO_MIG_STATE_PRE_COPY(mvdev) \
 	(mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY || \
@@ -175,7 +177,7 @@ mlx5vf_final_table_start_pos(struct mlx5_vf_migration_file *migf)
 
 static size_t mlx5vf_get_table_start_pos(struct mlx5_vf_migration_file *migf)
 {
-	return migf->table_start_pos;
+	return migf->table_start_pos + migf->sw_headers_bytes_sent;
 }
 
 static size_t mlx5vf_get_table_end_pos(struct mlx5_vf_migration_file *migf,
@@ -183,7 +185,40 @@ static size_t mlx5vf_get_table_end_pos(struct mlx5_vf_migration_file *migf,
 {
 	if (table == &migf->final_table)
 		return MIGF_TOTAL_DATA(migf);
-	return migf->table_start_pos + migf->image_length;
+	return migf->table_start_pos + migf->image_length +
+		migf->sw_headers_bytes_sent;
+}
+
+static void mlx5vf_send_sw_header(struct mlx5_vf_migration_file *migf,
+				  loff_t *pos, char __user **buf, size_t *len,
+				  ssize_t *done)
+{
+	struct mlx5_vf_migration_header header = {};
+	size_t header_size = sizeof(header);
+	void *header_buf = &header;
+	size_t size_to_transfer;
+
+	if (*pos >= mlx5vf_final_table_start_pos(migf))
+		header.image_size = migf->final_length;
+	else
+		header.image_size = migf->image_length;
+
+	size_to_transfer = header_size -
+			   (migf->sw_headers_bytes_sent % header_size);
+	size_to_transfer = min_t(size_t, size_to_transfer, *len);
+	header_buf += header_size - size_to_transfer;
+	if (copy_to_user(*buf, header_buf, size_to_transfer)) {
+		*done = -EFAULT;
+		return;
+	}
+
+	migf->sw_headers_bytes_sent += size_to_transfer;
+	migf->header_read = !(migf->sw_headers_bytes_sent % header_size);
+
+	*pos += size_to_transfer;
+	*len -= size_to_transfer;
+	*done += size_to_transfer;
+	*buf += size_to_transfer;
 }
 
 static struct sg_append_table *
@@ -233,6 +268,12 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		goto out_unlock;
 	}
 
+	if (VFIO_PRE_COPY_SUPP(migf->mvdev) && !migf->header_read) {
+		mlx5vf_send_sw_header(migf, pos, &buf, &len, &done);
+		if (done < 0)
+			goto out_unlock;
+	}
+
 	len = min_t(size_t, MIGF_TOTAL_DATA(migf) - *pos, len);
 	table = mlx5vf_get_table(migf, pos);
 	while (len) {
@@ -288,6 +329,9 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 			 */
 			if (tmp == table)
 				break;
+			mlx5vf_send_sw_header(migf, pos, &buf, &len, &done);
+			if (done < 0)
+				goto out_unlock;
 		}
 	}
 
-- 
2.18.1

