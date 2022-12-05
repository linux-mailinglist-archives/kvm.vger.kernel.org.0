Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1286642AB4
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 15:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiLEOuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 09:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiLEOuH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 09:50:07 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1041CFCD
        for <kvm@vger.kernel.org>; Mon,  5 Dec 2022 06:50:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrNHOhEcKCnrxZBTTc+zppOXikFYvLW7VLdTJPv7TQFdnR2kU8JBPkG871xnQQ+YOLLu+8a8389sj1A9yR1aAOjg1MAjyL9bXmUYV3accwqBESd+zXr6odmy0EalpONCj/7LR1IRtIMNa1cezyKlAqnfoA/mR8Qs+08FcjoAeA1vc/MMYKIi0FadLyrgeenIHuxeKWlkdMj2kMiCdDEDVS4I4yfatpbnkusWv6bb5l+TnWkXRS7gdVRel8UyMmcsHc61ETGGWnhG7tnmfJpBKptjCEvOhgN+ZUA3+5FoHx/61YQAm4x2FyDBp1e/K5TZAODT0hulI7Kos4jKuTq08g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEKHD2MLK+QyA7jR/5FGvpObfCTuRZmzts02R7sWvko=;
 b=e8eUQKviU5/qup63vWwYVSrITL86JqHqVSVLkRFk9AB1Edl+hxsvhuN16MrbgvhB/9/UxOQv7a6aoWbi3nK5RVAAsCFqSwisRfIlF+CdQ1VUgdqY+DrUgqeT6mrvl1FUVjAKWA/WtQ+FW6HilwzX22WBzBqRhLJcAw9FFgvtUGP6n+NtJYm8sqgf0lWTztCTHffivCnFY872xU/BBuSpbXePGpm8LLL7dEbeK/LoMYccdEeBIaM4Df8bYLL7Ne61wj//WLgFYJipBcHNbYcdjB9cfLe1xIm47edhhHXitCe6B/tjz/JrDFd6K5C1W290+o7oioxRcWtBmSYUfDWOZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEKHD2MLK+QyA7jR/5FGvpObfCTuRZmzts02R7sWvko=;
 b=mqp0RTHjF4HEem8aifQ8qC5f9l/kydA1NkfqYoTNLw3jlPmCPpJKzvlKduGSdK5sdEwwStDt29pVPQkuOkKT3vzFLsKMOVKG8oXM8JGg71VhLNIvluzC1qW6/VH0tXLNc0ckhDMtxDeOrsEsUyFglZ7VZ/nm3DWEsM7ZCNuqy5dY2CPKThWD1KquQXQYat3ag/ZlH86zNWkSPf14HKs/6491y5Fz78KKka77j49Dps4y4ZgA8+gGj23tNS949BLgjujMQRNTY0WJsCjRzbFtjn0YhZItzyKid7Z1HuGywyLXaNWW/JO6a4c757JTSP0XT64qNNyeQ9nic+Ni355KLg==
Received: from MW4PR04CA0056.namprd04.prod.outlook.com (2603:10b6:303:6a::31)
 by CY8PR12MB7537.namprd12.prod.outlook.com (2603:10b6:930:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 14:50:00 +0000
Received: from CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::5) by MW4PR04CA0056.outlook.office365.com
 (2603:10b6:303:6a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 14:50:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT092.mail.protection.outlook.com (10.13.175.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14 via Frontend Transport; Mon, 5 Dec 2022 14:50:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:45 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 5 Dec 2022
 06:49:45 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Mon, 5 Dec
 2022 06:49:41 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V3 vfio 11/14] vfio/mlx5: Consider temporary end of stream as part of PRE_COPY
Date:   Mon, 5 Dec 2022 16:48:35 +0200
Message-ID: <20221205144838.245287-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221205144838.245287-1-yishaih@nvidia.com>
References: <20221205144838.245287-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT092:EE_|CY8PR12MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: e583c320-8804-4529-7116-08dad6cffc31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2XbXko6kySSx+VWzbwDYzyUiQ5W3AQ0L0JbcsQDwnJBkcY/rQUKn9dYJIiqQTkQ+h4a0+yBxLuxJAg7EUfV2ixYeUY4f/Nfi1JKHaqbli6kwDcsqqAykEtPWF3qaLABikkr+KDeZ25cZoXrZ+fRZgcfhckOEs54N9rCSgF3RjYQZR5uN3HyCzDBJxntvhYHABv4e3VcRyB+EIsrHFfxNcByD1r3AmT6oyfA0Fl643wQtHjVmedbw7lM/PAZmO/kAByy5Xq+bKHYxxI6q6v+6MlNirDluPodgjjxLRzEuTeP0Ksbt4n78tgtLx55MAo4/+9FUDlnJ5Tm4WiaSi+RWFeTvmH5k0pLE3A03TRYbALyTx7s4mCwID3T2rR2/QU7s4MmQqe+6GuMt6Hvd6UnTkqCiKIyDbAgu54IofsvhLbe5gUPVgBsi6P/V7rXOkNffeFz3sDOsF1gKMIkSPnbhRrNVWXJL/OwPMY2hA7gQsoEe46XtWZlyVq7iD/VhU1qh7+Z2MKG3o5sybOOQkN9lD0ELsam+NAZy/RrsTBVAsYjLL94V0OIyy9fPbonNo4Xa5dMIE4v8qrtxdFow0MYBySJTDHmnq6Tga+8arHi7CIlKHgDnUopinx4DSNj/xxS/OXihUXdry1ei91Jy+xGSvNwLySfLPrsJ7MYUq3BsZrDiuAR4nfipL+gLcPqiCTxydGtuXJJxbSsiK4Kf6T4TQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(46966006)(40470700004)(36840700001)(82310400005)(40480700001)(36756003)(336012)(47076005)(186003)(110136005)(316002)(83380400001)(1076003)(6636002)(7696005)(6666004)(26005)(54906003)(426003)(2906002)(86362001)(70206006)(36860700001)(4326008)(8676002)(70586007)(7636003)(356005)(82740400003)(41300700001)(40460700003)(2616005)(478600001)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 14:50:00.3082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e583c320-8804-4529-7116-08dad6cffc31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7537
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During PRE_COPY the migration data FD may have a temporary "end of
stream" that is reached when the initial_bytes were read and no other
dirty data exists yet.

For instance, this may indicate that the device is idle and not
currently dirtying any internal state. When read() is done on this
temporary end of stream the kernel driver should return ENOMSG from
read(). Userspace can wait for more data or consider moving to
STOP_COPY.

To not block the user upon read() and let it get ENOMSG we add a new
state named MLX5_MIGF_STATE_PRE_COPY on the migration file.

In addition, we add the MLX5_MIGF_STATE_SAVE_LAST state to block the
read() once we call the last SAVE upon moving to STOP_COPY.

Any further error will be marked with MLX5_MIGF_STATE_ERROR and the user
won't be blocked.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  | 7 +++++--
 drivers/vfio/pci/mlx5/cmd.h  | 2 ++
 drivers/vfio/pci/mlx5/main.c | 7 +++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 12e74ecebe64..f6293da033cc 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -501,8 +501,8 @@ static void mlx5vf_save_callback(int status, struct mlx5_async_work *context)
 		spin_lock_irqsave(&migf->list_lock, flags);
 		list_add_tail(&async_data->buf->buf_elm, &migf->buf_list);
 		spin_unlock_irqrestore(&migf->list_lock, flags);
-		if (async_data->last_chunk)
-			migf->state = MLX5_MIGF_STATE_COMPLETE;
+		migf->state = async_data->last_chunk ?
+			MLX5_MIGF_STATE_COMPLETE : MLX5_MIGF_STATE_PRE_COPY;
 		wake_up_interruptible(&migf->poll_wait);
 	}
 
@@ -561,6 +561,9 @@ int mlx5vf_cmd_save_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 		}
 	}
 
+	if (async_data->last_chunk)
+		migf->state = MLX5_MIGF_STATE_SAVE_LAST;
+
 	async_data->header_buf = header_buf;
 	get_file(migf->filp);
 	err = mlx5_cmd_exec_cb(&migf->async_ctx, in, sizeof(in),
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 3e36ccca820a..d048f23977dd 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -17,6 +17,8 @@
 
 enum mlx5_vf_migf_state {
 	MLX5_MIGF_STATE_ERROR = 1,
+	MLX5_MIGF_STATE_PRE_COPY,
+	MLX5_MIGF_STATE_SAVE_LAST,
 	MLX5_MIGF_STATE_COMPLETE,
 };
 
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 08c7d96e92b7..d70d7a85d11c 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -219,6 +219,7 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 		if (wait_event_interruptible(migf->poll_wait,
 				!list_empty(&migf->buf_list) ||
 				migf->state == MLX5_MIGF_STATE_ERROR ||
+				migf->state == MLX5_MIGF_STATE_PRE_COPY ||
 				migf->state == MLX5_MIGF_STATE_COMPLETE))
 			return -ERESTARTSYS;
 	}
@@ -236,6 +237,12 @@ static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
 							 &end_of_data);
 		if (first_loop_call) {
 			first_loop_call = false;
+			/* Temporary end of file as part of PRE_COPY */
+			if (end_of_data && migf->state == MLX5_MIGF_STATE_PRE_COPY) {
+				done = -ENOMSG;
+				goto out_unlock;
+			}
+
 			if (end_of_data && migf->state != MLX5_MIGF_STATE_COMPLETE) {
 				if (filp->f_flags & O_NONBLOCK) {
 					done = -EAGAIN;
-- 
2.18.1

