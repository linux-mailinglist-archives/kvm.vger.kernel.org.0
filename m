Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CAD637E7B
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 18:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiKXRlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 12:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiKXRlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 12:41:03 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622181400FE
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 09:41:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMdcNGxuAi43OTlplhbBNHH/O+lyRqsYTOiyfLH7p5Vf4tLVEOTPHAjV2PtXHb6SSHBCTNN+ncRYw7eFz8VDBy/oXSPiL4JBZq86LdsH3CF+I3gIfUtcn89bdINwPBVPI6QQHxbl7qCmRVHc6rWWTYkaCHh/7b5w50Twi0tOr9Wdzx8BQbuVhH/pwc1/uBd0966+C7nzPUJ0xWC0YELT7nP1Pntcd9FhY/w1bIWbw8i/hiSa+nJ4R3KqtE3RRcx97cEBugBiSkKY2xPnmj1hnOk9KwlElppBkn9Tdvd1sHVP+i1QWs613XDp2bssoN7vVrK7f2Uzua+1wrFoag2bqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFsl8zQWBTBRYZpbJFn4Kr4bmkk/+xbam/cg+HXCJgI=;
 b=FDqkbh4QPk2r7kzpGSpq4IPlmgWxHgoXoTbvLlwPQOg2GdDq7IpGUArurpTP8CabVI7FLII1uApqY6VaQSVotQhZzcQJPCIegE4b6WLzRt2OsqSDDAEvqg4g+CrC5XTAnjWnlcSrlEpvz5irVpkOxixzpOPqIL+k1c5V0Kq8hiXX1B001oNhRjLitIT18RDIHHFIalJLIvre2MSqWONlZXBu3TVEP9LiuIeHAh4DP5itGaBNgOxruzOSCwW3ChBFPgpm7QUqR1WJ8LTXnWxek82anb7+lfYtfYq8X4C1MP6O49VVApynJNaARDk10W2zMxNbFR8n5N2gNHlUXnR0Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFsl8zQWBTBRYZpbJFn4Kr4bmkk/+xbam/cg+HXCJgI=;
 b=BvGLp/MMQ5hcCP3JZI6SpAyT0vbhSw7zuRkQEv47AzNkfVvbvE72LSJLxA0qogkkqiJWThK0dRbZ2hyT+FITHbvMunTqdR5tyBm10RcUFHPEd0pb1uMcdg5IG1YGRExlHxjlz512k7voQy39roDOGf8GPh9NBRWp/O27S4u3JFBf/fAzIcBO7/G0xRWs5ONOOEdFl9q7S4BgFWi852bksgFlnVOdW25N96r3m7+M0nKORIgWD9qSZdxc5bVGC6HtkxY/1QDDTA799YUy/OOMS4sRg8bjJnYa6xAP+MkRH6Ih4AMX3ed43xgsQP/kROGBGw/6XZd3gmON7wtdM9DTWA==
Received: from MW4PR04CA0260.namprd04.prod.outlook.com (2603:10b6:303:88::25)
 by PH0PR12MB5678.namprd12.prod.outlook.com (2603:10b6:510:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 17:40:59 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::ba) by MW4PR04CA0260.outlook.office365.com
 (2603:10b6:303:88::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Thu, 24 Nov 2022 17:40:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 17:40:58 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 24 Nov
 2022 09:40:53 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 24 Nov 2022 09:40:52 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Thu, 24 Nov 2022 09:40:49 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <shayd@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <avihaih@nvidia.com>, <cohuck@redhat.com>
Subject: [PATCH V1 vfio 10/14] vfio/mlx5: Introduce vfio precopy ioctl implementation
Date:   Thu, 24 Nov 2022 19:39:28 +0200
Message-ID: <20221124173932.194654-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221124173932.194654-1-yishaih@nvidia.com>
References: <20221124173932.194654-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT058:EE_|PH0PR12MB5678:EE_
X-MS-Office365-Filtering-Correlation-Id: a9ac534b-f287-4e73-f3b4-08dace430c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62Kh9toXOhaqEHZL18oCOSuZy/5+AG9oC6rizHM5nb57+Vs2HGypMuE99kgHD5yNYuWcErJcSFZVlNfgQtVNJ3gXMU3JSRoiDhypos/RyeJfXRgDtQ4iZGQnxtM80ulbOLBWh0gGbrlob48JuUjmtZh+bw23oLiw8TEAzBl6AKLqNDgy150chnLvajgAcVdNLUbKpgcs6ZK0i/DnnEG+us0/ExTnbPsBk5tNYcaevFfBXJ219TFz1M2flvQafQ/bg4yD1/qfZ+9xKFKlMfZvV9PS0JtksjKpfSWR7AjNVk8y7jkgv5O4cA1YoknznMDCHYlN7eytfvJvKXu05tHfEnqQL+mKfeBMC1ILcIIL+ExukHTpdOAm36vh0SC5zOW15ab8DatfkB3K+uysu+oiDgxIgbb5n9OZYDqf/MgZgYoLoqfedBDoz4KdfmwZtyGoCNgljgMTTTiAxtsqXHjlas2IF724hh2XDYcppxqY62LESA1OAlRqNFqy4J+N3W2z2LvjON1Xidg8GYawrTGTuN1qofDXU2NRYN1lW4wzW0rhmptfz/drdiLBITP8qZ89n1u34tvXk3gjGYQJQNAYjWPY6CYU8ZGBU+ENdMJLJ2VeNefdE6cZJC9LQib0Qr5k/Rpw3v8zJV3rqxHNPhWmiiASCJMzRwuWx91ODbaDL2HsijtjpROG15AQJm0d30hRBsDy6SPos0jLwcyMI7KWAQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(70586007)(40460700003)(70206006)(36756003)(8676002)(86362001)(6666004)(5660300002)(36860700001)(41300700001)(4326008)(7696005)(26005)(8936002)(1076003)(54906003)(83380400001)(47076005)(336012)(2616005)(186003)(426003)(7636003)(316002)(356005)(6636002)(110136005)(478600001)(82310400005)(40480700001)(82740400003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 17:40:58.9843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ac534b-f287-4e73-f3b4-08dace430c4b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5678
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio precopy ioctl returns an estimation of data available for
transferring from the device.

Whenever a user is using VFIO_MIG_GET_PRECOPY_INFO, track the current
state of the device, and if needed, append the dirty data to the
transfer FD data. This is done by saving a middle state.

As mlx5 runs the SAVE command asynchronously, make sure to query for
incremental data only once there is no active save command.
Running both in parallel, might end-up with a failure in the incremental
query command on un-tracked vhca.

Also, a middle state will be saved only after the previous state has
finished its SAVE command and has been fully transferred, this prevents
endless use resources.

Co-developed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/mlx5/cmd.c  |  16 +++++
 drivers/vfio/pci/mlx5/main.c | 111 +++++++++++++++++++++++++++++++++++
 2 files changed, 127 insertions(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 0af1205e6363..65764ca1b31a 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -67,12 +67,25 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 {
 	u32 out[MLX5_ST_SZ_DW(query_vhca_migration_state_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_vhca_migration_state_in)] = {};
+	bool inc = query_flags & MLX5VF_QUERY_INC;
 	int ret;
 
 	lockdep_assert_held(&mvdev->state_mutex);
 	if (mvdev->mdev_detach)
 		return -ENOTCONN;
 
+	/*
+	 * In case PRE_COPY is used, saving_migf is exposed while device is
+	 * running. Make sure to run only once there is no active save command.
+	 * Running both in parallel, might end-up with a failure in the
+	 * incremental query command on un-tracked vhca.
+	 */
+	if (inc) {
+		ret = wait_for_completion_interruptible(&mvdev->saving_migf->save_comp);
+		if (ret)
+			return ret;
+	}
+
 	MLX5_SET(query_vhca_migration_state_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE);
 	MLX5_SET(query_vhca_migration_state_in, in, vhca_id, mvdev->vhca_id);
@@ -82,6 +95,9 @@ int mlx5vf_cmd_query_vhca_migration_state(struct mlx5vf_pci_core_device *mvdev,
 
 	ret = mlx5_cmd_exec_inout(mvdev->mdev, query_vhca_migration_state, in,
 				  out);
+	if (inc)
+		complete(&mvdev->saving_migf->save_comp);
+
 	if (ret)
 		return ret;
 
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index ec52c8c4533a..2f5f83f2b2a4 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -294,10 +294,121 @@ static void mlx5vf_mark_err(struct mlx5_vf_migration_file *migf)
 	wake_up_interruptible(&migf->poll_wait);
 }
 
+static ssize_t mlx5vf_precopy_ioctl(struct file *filp, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct mlx5_vf_migration_file *migf = filp->private_data;
+	struct mlx5vf_pci_core_device *mvdev = migf->mvdev;
+	struct mlx5_vhca_data_buffer *buf;
+	struct vfio_precopy_info info = {};
+	loff_t *pos = &filp->f_pos;
+	unsigned long minsz;
+	size_t inc_length = 0;
+	bool end_of_data;
+	int ret;
+
+	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
+		return -ENOTTY;
+
+	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	mutex_lock(&mvdev->state_mutex);
+	if (mvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
+	    mvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
+		ret = -EINVAL;
+		goto err_state_unlock;
+	}
+
+	/*
+	 * We can't issue a SAVE command when the device is suspended, so as
+	 * part of VFIO_DEVICE_STATE_PRE_COPY_P2P no reason to query for extra
+	 * bytes that can't be read.
+	 */
+	if (mvdev->mig_state == VFIO_DEVICE_STATE_PRE_COPY) {
+		/*
+		 * Once the query returns it's guaranteed that there is no
+		 * active SAVE command.
+		 * As so, the other code below is safe with the proper locks.
+		 */
+		ret = mlx5vf_cmd_query_vhca_migration_state(mvdev, &inc_length,
+							    MLX5VF_QUERY_INC);
+		if (ret)
+			goto err_state_unlock;
+	}
+
+	mutex_lock(&migf->lock);
+	if (migf->state == MLX5_MIGF_STATE_ERROR) {
+		ret = -ENODEV;
+		goto err_migf_unlock;
+	}
+
+	buf = mlx5vf_get_data_buff_from_pos(migf, *pos, &end_of_data);
+	if (buf) {
+		if (buf->start_pos == 0) {
+			info.initial_bytes = buf->header_image_size - *pos;
+		} else if (buf->start_pos ==
+				sizeof(struct mlx5_vf_migration_header)) {
+			/* First data buffer following the header */
+			info.initial_bytes = buf->start_pos +
+						buf->length - *pos;
+		} else {
+			info.dirty_bytes = buf->start_pos + buf->length - *pos;
+		}
+	} else {
+		if (!end_of_data) {
+			ret = -EINVAL;
+			goto err_migf_unlock;
+		}
+
+		info.dirty_bytes = inc_length;
+	}
+
+	if (!end_of_data || !inc_length) {
+		mutex_unlock(&migf->lock);
+		goto done;
+	}
+
+	mutex_unlock(&migf->lock);
+	/*
+	 * We finished transferring the current state and the device has a
+	 * dirty state, save a new state to be ready for.
+	 */
+	buf = mlx5vf_get_data_buffer(migf, inc_length, DMA_FROM_DEVICE);
+	if (IS_ERR(buf)) {
+		ret = PTR_ERR(buf);
+		mlx5vf_mark_err(migf);
+		goto err_state_unlock;
+	}
+
+	ret = mlx5vf_cmd_save_vhca_state(mvdev, migf, buf, true, true);
+	if (ret) {
+		mlx5vf_mark_err(migf);
+		mlx5vf_put_data_buffer(buf);
+		goto err_state_unlock;
+	}
+
+done:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return copy_to_user((void __user *)arg, &info, minsz);
+err_migf_unlock:
+	mutex_unlock(&migf->lock);
+err_state_unlock:
+	mlx5vf_state_mutex_unlock(mvdev);
+	return ret;
+}
+
 static const struct file_operations mlx5vf_save_fops = {
 	.owner = THIS_MODULE,
 	.read = mlx5vf_save_read,
 	.poll = mlx5vf_save_poll,
+	.unlocked_ioctl = mlx5vf_precopy_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.release = mlx5vf_release_file,
 	.llseek = no_llseek,
 };
-- 
2.18.1

