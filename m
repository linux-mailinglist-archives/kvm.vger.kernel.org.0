Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275D9642AB2
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiLEOt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:49:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiLEOtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:49:52 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193B71C106
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:49:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4td+VJc0kQlErxWZJB5Vz51ZDw9B7O+3ElU6GzFZ0GI2nFdLAHjbAd5Y3/7surTN+xfOM74UuuFDn5n0jTw74AYttVF+IuUXNWAUG28H+z5ArBUkYtsaMAL/nUHaMmLv1sba2YPBZjjM66DbiRJ52Pvgz8WVXSdTkdO6Vi1ATp7ZXv4kV8oHkVFSze6wexh3dHMs8WaYVAGTLGVn4bJSbTNsHho8XXt1qu4ltcisN0ojK+xUiG5/rHsq2i2R8f5at7ogXSC99unswYRV9eQCJ5603LYzwE2a9pVBUpf5X31snbMF8Kv7Pi8c1XxucSxu/wHExTfeJlrnEFugBkctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1u4bF40v8iAzGAsqQRRKbN9Z1DkuTsXc0vlB2H7J+Ho=;
 b=TbRgAwepitxjTG1CjrNbwDcO1X3AB0MnmluIjnxHcdYSWAJxzPG1eg7NGYicbhHAbXlHVyRPSayKWHRwanhXvA/JRs7PXr44FTmd1iMf3AfehIYSfySLBK7yGZcX/axVatuJhg6LwIYb+FzuIG5IPvzfwAWs38aCLEu1AerWQ411ZrGgleGAXmJdSPDQlZH+8UMfSIsva3NDLXFeSoa3ZV0xSRgbos0YsgyDH/A0Pgm8C27h32TBf0YkW8TIlar5htHhkWwkuco9PJeLo8xfusH9lb+G7h1mNV6Ppt7umvpEidblzMu6dm1jomK9mX8Zx5/cHvrFhM/nqXu/cROvnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1u4bF40v8iAzGAsqQRRKbN9Z1DkuTsXc0vlB2H7J+Ho=;
 b=kikRIJGN8mmtswADY346tfqiE88bomGs1fYT5xTuxgHksCGBjXY24l+/XTpnp/hzGHs+p1cjPFOlJerUwpcm5M2i8n/wh3F5aJNzVByGwT2MPFBRGIfcFurrJcp7CRqSjpDWYaXIwgvqPMH0sgIjL+x/MzNA3oss8dgM3TJFkYwIY3aHWXBiJHq1t2Hc5QpTDgPDlzPiocbnw+WWvk2oGax3DlUmB5c54p4SR+uWLJakHZepp3u609ADoApa8k8IqXHUH3moM2jv0j41o2d0W+YPL8uHJgl7tQdddwjDrGUo1xZDjZ5KbDjOna4NFm64jkYdZJKPTXao93ND/aGmIA==
Received: from MW4PR04CA0090.namprd04.prod.outlook.com (2603:10b6:303:6b::35)
 by LV2PR12MB6016.namprd12.prod.outlook.com (2603:10b6:408:14e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 14:49:47 +0000
Received: from CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::9b) by MW4PR04CA0090.outlook.office365.com
 (2603:10b6:303:6b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 14:49:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT061.mail.protection.outlook.com (10.13.175.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Mon, 5 Dec 2022 14:49:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:37 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:37 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:34 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 09/14] vfio/mlx5: Introduce SW headers for migration states
Date:   Mon, 5 Dec 2022 16:48:33 +0200
Message-ID: <20221205144838.245287-10-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT061:EE_|LV2PR12MB6016:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a46d2a0-87e2-415d-9817-08dad6cff44e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYXrhPrdWxAx15hv5EzZ3tw4xQuZ3SIog+Fver1HshmefIwdEI7D/s6nYDkvNrsV4UTZuOHo2qNjPjAx6rwo9x5H12cO1Hog2SdveBeCXPJJ12OB5HKeeO/VKkY+47vGKcw9mgzviDw/AyksAtcuxqSfQs7PcEYIy2qu5APzTHXPr3Q06IWvglcLHet9KIdm3TrvHsGLx7MPDqqNjKd9Hub6B+jOXGvP7uN6TlUT+Ej31xoilsUvC0+nrl2MtMapywM/OPhjk7Fion3OwXzeZbGb0RHcVGfH2BiGQ+WHhKj/GT7fiV4lYWw31H0iTGbABGhLStrWazUlaMxckESlj9NsEMFIG8ubT02R3GhhUIScnzW8dACn0QF19Tav7C+hMxl93UAqwoTHaSS7JD+z+VOZwkB4kZ5L8RgJYj4RGn1nBC6yZLPWlRooMod7H2nxtpoYMpD2pZmMaedeOXiwvanHka4VqC1hWZHrs72xdjSnB6KJKIVw/S6PgAcMXksIk9YQA4q7lOxxwBoY+32e/sQDoQcgc2VEqLXcAPnREz/KT0cjMYX9nMoffwR0NJgGLD9ikHYbS677vmvxFO+TL4HqhltKfmRr7wqyDcNN1VEgJcQGO1X65tNGQAS356I4S0+454cyOYK1TtjjLvdi5E/bh5e8xSuqdbhCe6XATGfiljtLge4EWZG7DQl1KanvI8OexB/tRdK9Fj1tj6sIGQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(40480700001)(36756003)(40460700003)(86362001)(7636003)(7696005)(478600001)(26005)(5660300002)(4326008)(8676002)(41300700001)(8936002)(6636002)(316002)(2906002)(110136005)(54906003)(70206006)(70586007)(82310400005)(36860700001)(356005)(82740400003)(2616005)(336012)(186003)(1076003)(83380400001)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:49:47.0774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a46d2a0-87e2-415d-9817-08dad6cff44e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB6016
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As mentioned in the previous patches, mlx5 is transferring multiple
states when the PRE_COPY protocol is used. This states mechanism
requires the target VM to know the states' size in order to execute
multiple loads.  Therefore, add SW header, with the needed information,
for each saved state the source VM is transferring to the target VM.

This patch implements the source VM handling of the headers, following
patch will implement the target VM handling of the headers.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 56 ++++++++++++++++++++++++++++++++++--
 drivers/vfio/pci/mlx5/cmd.h  | 13 +++++++++
 drivers/vfio/pci/mlx5/main.c |  2 +-
 3 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5fcece201d4c..160fa38fc78d 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -351,9 +351,11 @@ mlx5vf_alloc_data_buffer(struct mlx5_vf_migration_file *migf,
 		if (ret)
 			goto end;
 
-		ret = mlx5vf_dma_data_buffer(buf);
-		if (ret)
-			goto end;
+		if (dma_dir != DMA_NONE) {
+			ret = mlx5vf_dma_data_buffer(buf);
+			if (ret)
+				goto end;
+		}
 	}
 
 	return buf;
@@ -422,6 +424,8 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	mutex_lock(&migf->lock);
 	if (async_data->status) {
 		mlx5vf_put_data_buffer(async_data->buf);
+		if (async_data->header_buf)
+			mlx5vf_put_data_buffer(async_data->header_buf);
 		migf->state = MLX5_MIGF_STATE_ERROR;
 		wake_up_interruptible(&migf->poll_wait);
 	}
@@ -431,6 +435,32 @@ void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work)
 	fput(migf->filp);
 }
 
+static int add_buf_header(struct mlx5_vhca_data_buffer *header_buf,
+			  size_t image_size)
+{
+	struct mlx5_vf_migration_file *migf = header_buf->migf;
+	struct mlx5_vf_migration_header header = {};
+	unsigned long flags;
+	struct page *page;
+	u8 *to_buff;
+
+	header.image_size = cpu_to_le64(image_size);
+	page = mlx5vf_get_migration_page(header_buf, 0);
+	if (!page)
+		return -EINVAL;
+	to_buff = kmap_local_page(page);
+	memcpy(to_buff, &header, sizeof(header));
+	kunmap_local(to_buff);
+	header_buf->length = sizeof(header);
+	header_buf->header_image_size = image_size;
+	header_buf->start_pos = header_buf->migf->max_pos;
+	migf->max_pos += header_buf->length;
+	spin_lock_irqsave(&migf->list_lock, flags);
+	list_add_tail(&header_buf->buf_elm, &migf->buf_list);
+	spin_unlock_irqrestore(&migf->list_lock, flags);
+	return 0;
+}
+
 static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5vf_async_data *async_data = container_of(context,
@@ -444,6 +474,11 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 
 		image_size = MLX5_GET(save_vhca_state_out, async_data->out,
 				      actual_image_size);
+		if (async_data->header_buf) {
+			status = add_buf_header(async_data->header_buf, image_size);
+			if (status)
+				goto err;
+		}
 		async_data->buf->length = image_size;
 		async_data->buf->start_pos = migf->max_pos;
 		migf->max_pos += async_data->buf->length;
@@ -455,6 +490,7 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
+err:
 	/*
 	 * The error and the cleanup flows can't run from an
 	 * interrupt context
@@ -470,6 +506,7 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 {
 	u32 out_size = MLX5_ST_SZ_BYTES(save_vhca_state_out);
 	u32 in[MLX5_ST_SZ_DW(save_vhca_state_in)] = {};
+	struct mlx5_vhca_data_buffer *header_buf = NULL;
 	struct mlx5vf_async_data *async_data;
 	int err;
 
@@ -499,6 +536,16 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		goto err_out;
 	}
 
+	if (MLX5VF_PRE_COPY_SUPP(mvdev)) {
+		header_buf = mlx5vf_get_data_buffer(migf,
+			sizeof(struct mlx5_vf_migration_header), DMA_NONE);
+		if (IS_ERR(header_buf)) {
+			err = PTR_ERR(header_buf);
+			goto err_free;
+		}
+	}
+
+	async_data->header_buf = header_buf;
 	get_file(migf->filp);
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
 			       async_data->out,
@@ -510,7 +557,10 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	return 0;
 
 err_exec:
+	if (header_buf)
+		mlx5vf_put_data_buffer(header_buf);
 	fput(migf->filp);
+err_free:
 	kvfree(async_data->out);
 err_out:
 	complete(&migf->save_comp);
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 34e61c7aa23d..3e36ccca820a 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -12,16 +12,26 @@
 #include <linux/mlx5/cq.h>
 #include <linux/mlx5/qp.h>
 
+#define MLX5VF_PRE_COPY_SUPP(mvdev) \
+	((mvdev)->core_device.vdev.migration_flags & VFIO_MIGRATION_PRE_COPY)
+
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
+struct mlx5_vf_migration_header {
+	__le64 image_size;
+	/* For future use in case we may need to change the kernel protocol */
+	__le64 flags;
+};
+
 struct mlx5_vhca_data_buffer {
 	struct sg_append_table table;
 	loff_t start_pos;
 	u64 length;
 	u64 allocated_length;
+	u64 header_image_size;
 	u32 mkey;
 	enum dma_data_direction dma_dir;
 	u8 dmaed:1;
@@ -37,6 +47,7 @@ struct mlx5vf_async_data {
 	struct mlx5_async_work cb_work;
 	struct work_struct work;
 	struct mlx5_vhca_data_buffer *buf;
+	struct mlx5_vhca_data_buffer *header_buf;
 	int status;
 	u8 last_chunk:1;
 	void *out;
@@ -165,6 +176,8 @@ mlx5vf_get_data_buffer(struct mlx5_vf_migration_file *migf,
 void mlx5vf_put_data_buffer(struct mlx5_vhca_data_buffer *buf);
 int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 			       unsigned int npages);
+struct page *mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
+				       unsigned long offset);
 void mlx5vf_state_mutex_unlock(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev);
 void mlx5vf_mig_file_cleanup_cb(struct work_struct *_work);
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 9cabba456044..9a36e36ec33b 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -32,7 +32,7 @@ static struct mlx5vf_pci_core_device *mlx5vf_drvdata(struct pci_dev *pdev)
 			    core_device);
 }
 
-static struct page *
+struct page *
 mlx5vf_get_migration_page(struct mlx5_vhca_data_buffer *buf,
 			  unsigned long offset)
 {
-- 
2.18.1

