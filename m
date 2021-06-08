Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5D039EB1F
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhFHA5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:57:54 -0400
Received: from mail-mw2nam10on2041.outbound.protection.outlook.com ([40.107.94.41]:6904
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231296AbhFHA5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:57:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRMl+Ej/mOfxiMDf62M3pePMgbhzlUzbGlABL8wWNFwAHLItQKh4G3FFtVBIt4MY2adn1Sa0UX82sZbRsC+DMNasF6z1h//cJAawaXdA3pkuZHlU3xB4aQH1kMEZHJGYRIazk52c3cnktJB6cH3XG1GKHjBuYZqjUdN8Hgya6exH+yrAasaminPqfRh40m0BgaqESaACOYG2Udy34R4E8v3fyvJvCXwfaVdJQ76+MIYjzJDzTbhWTmpTn11IAuiic0VzKR2lYp9BqUaZwGM4psO+Jy0SFD/q4fXrCejBX67K5DWaVtpn9GbDS1oNoKSPBL7uz1xHusOYIPDuYJu6uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NiwbjTB/rf9sR4ZC2VUsBPwx5YVyjuS3PbGxjNeKkA=;
 b=OJl72Zj8qILd68O55hZA2SxQI4VZFnNncoiD7fnSvebzRgPMmxDZ3+OWAC0fuRRNlgrMMJqc2CjZeZEBcHTkv4mabRAM74WOYTlnXYuFiznhvAAnkt+JeCzjUgJ37ZmX31fWgS+xVAjGKYzEJclRMXgc+kNh0Gjvwi7Hv5OM8OCKJXN1zSaP+Ciny4x/JswcEA/p4gXsXjckRMOyyjl/TDTvxKcaXkm+h+F3AccZobM4zeVpkEZK3Vn4I7lx4J1V6WcquYYtYMLOdnWPNp8HKCbzrLccpW18sIAEaRBk8aUEW5AWpkYgSdedbupqfHAk9IFdZvcmfnf3gC7k2RzCPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6NiwbjTB/rf9sR4ZC2VUsBPwx5YVyjuS3PbGxjNeKkA=;
 b=Vl7wi1C/m8C1FzrxJMEYnEMwoA6jVbtck4iArB8udXnWxOs87L1iA0gFj/FsbWFyIwEiyBMua6R6lq0+Jp0MRLm+9aNzXzfYQr+CFR7k4vCwTIVTjlq8rMvrHOVvRwczEP62e7DJdxZnc4AcFMhRs8JlmdtNndVdm4XijjKUaRFUvX7Amlj27Wzxbr9CKIFvVX7Om23LeHe2FCWVOiEs0EXaayZ0H3nMrcUdaLtv/yKBDXjcuPNA4DNT7xHVec7Ka7Doyy/fezj/cGqyH9zyHOXQcbTtgP+QTe74CybuKW+23lBghleCSaP0WPCGyc6BejwWErJLPOWP0NkHw+SuPA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5095.namprd12.prod.outlook.com (2603:10b6:208:31b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 00:55:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 00:55:56 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/10] vfio/mtty: Convert to use vfio_register_group_dev()
Date:   Mon,  7 Jun 2021 21:55:50 -0300
Message-Id: <8-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
In-Reply-To: <0-v1-324b2038f212+1041f1-vfio3a_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0254.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::19) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0254.namprd13.prod.outlook.com (2603:10b6:208:2ba::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Tue, 8 Jun 2021 00:55:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqQ24-003eKn-Ly; Mon, 07 Jun 2021 21:55:52 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bae6a26a-d497-4f19-000d-08d92a182b62
X-MS-TrafficTypeDiagnostic: BL1PR12MB5095:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5095B32C12A68F7A6FF1E28CC2379@BL1PR12MB5095.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLgTx+9BTgfyQGl/Usqu7VctYsWJFL5ETcC0YWQBr/vRAgSoHfuKQDaf66VuXCVrsZUMniNInEQIw0pLZCeXebgmZHzPFEBZxGsM1fyYOwwyRpGX+jqtQ3LEdk5ikONKUyaiReHWdNULDEpD20BNs6PwivtojOjHoDI2TEibR9uyyLJF97iqpxQHelwNNJURINIZlrhV6AkXaqF1AIsqjx1X/QRyJgcNLgiA+y31FPfYcGe050doXRtI1gSloEupVPWuuk+9NnPr5ZLro3Ds6HAuVjPOAN8XRJuKR9jNTkaEDeo0RIoXSMFDx9cfqDpNyDqz3JcygSCTSqx2LGI++P1teJXm2wzxC5KlLvZ+AHo5DBxqPADTuMLWPMkK4pDqZudAMkBjcfprwTEBz79VwsenKp4Iip+DrB2D+aNtxpeXP72RiN+a8GNrwhbieRKcQmTdmWcQrS4OB9gjYBWDFU6dwsI9iruSvRco9VGVkGfB3Cv3C8J76oHLLGd9zN+59L0nTnaQsXMQuMP9wu/kUOENq41d84GVK2EEy91CiXiviEJv5Xs4NfDDPXhmaOEDbootvYVeDW0KHjDx4nFG25kYD6kL/MgNrFVBUDFE1louZG46uhFt/pybaUXrx8jUI/4VaiWBkFVHtE8wPM1z4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(2616005)(86362001)(9746002)(6862004)(66556008)(2906002)(37006003)(30864003)(36756003)(186003)(9786002)(4326008)(478600001)(426003)(6636002)(66476007)(83380400001)(8936002)(8676002)(26005)(66946007)(5660300002)(316002)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r+Y5A/wrGfS9PMAt7LZOU14UXScpBOJThq0gWyE1v6nApNrQtJaQ32FAD+W2?=
 =?us-ascii?Q?lMD4MGbyy05LPH9fOtyPj+l4GPtA+C9kbR7sAZVRO4cWtWxHILQo3OHkfJJF?=
 =?us-ascii?Q?r8I+fIlJdEAd0b73k0PCug+fZ7M8bcS3nqzMPCCiVdgGvhb4R6bHmpxu/23S?=
 =?us-ascii?Q?C07LGuqW6WFZVDdo91gOXDsBFyn9M8FWIIByQL2HQu4o8Q0rxhCepQKza77I?=
 =?us-ascii?Q?YFDimpbmup0D2coL0Ad9ZmsUYuNOT511ScSOS52HUmEzoxrpgQgRQguDtq5O?=
 =?us-ascii?Q?uqUbKMgh95GBXgCtPN3WshqMJJw6QoSpKcSEgAx8j/n9U6EBp0lYirTSTMnm?=
 =?us-ascii?Q?gu+uLe+TnHfBzwRqXqHCiy4bq2ZkjTwInaoyMPkQG6x+T1pKH9QTmmAYaUby?=
 =?us-ascii?Q?PFe7yrhqrIzJNJ1y2sRX3+kokUaxegx67xcZ7hPf9k75oeymFF5QwLF1o7JV?=
 =?us-ascii?Q?QsvfUjiEo+12AsdCW4IOKH2nv6fkmokZgpCTwia3wOxwO+EsYVJ6BLbqqia4?=
 =?us-ascii?Q?BsqWkN0IoVSPKj6RS8dDMPXCylo+EIBwmrYQOEiYpVoNwUp4ZqEGCt1yd+9c?=
 =?us-ascii?Q?vzEHG5tJbbG5CTTQZ7HBmUBTDgQs3keDEPDLLMY/1YPGCFiArfgvKvvUfKMt?=
 =?us-ascii?Q?vdaZek2+AoHD0TMnHX/YD8VfonA5wF8mZ35LJEvA7fO61km2fzoavpZbm8nu?=
 =?us-ascii?Q?CreP+Or1stprsEwghCKFCQL7BynsUNvWH6PqiLJFefCewGJLKSdeoVR0GCe1?=
 =?us-ascii?Q?KJIjb2ho41BkZfOPw+UIMAJ9+6kJi8mWXUWX+ATk9uDZyILheC6kipw4A8fL?=
 =?us-ascii?Q?IE0BwHl90bxI+dFe/GNLfCQs4H677m6+HvTICS1q5iG9RNT2etYaLC3/yN0+?=
 =?us-ascii?Q?NuPkBGLs9IdwIp4aHyTY60vMuEbxeIbVuhOY2kv/zb+JODSMEY9XTC3mtUBS?=
 =?us-ascii?Q?G/oGyrdjSYQd2shIVtaHnhgW2MfpQBxm5dVhGnVug58t2Xtr4IxXCJd85I3E?=
 =?us-ascii?Q?CUsoJTnarhuCGeyj3s7keg/kikTN/DYR+QwQyMmXQxWuFBav7l3HNG5b3IQ9?=
 =?us-ascii?Q?uXDzgO4wRS0tpA3AZ2d3FlLOzggdpAnKixg8dbft0SUENIRUqghB9Mk3MixD?=
 =?us-ascii?Q?0NawtPFDgCcEcFcCL9y4Ryq5Aazd35KpHIbGuJdMCApACzCfr4RL52C5s3BK?=
 =?us-ascii?Q?W0BaRQLR3dC0tjx1zarrcIv/Vc0geOvUodCetChBbZ3yvTMRWNE93FqDkhkq?=
 =?us-ascii?Q?/YnaUU3819OHbXhUWuRBt9tVWA/W0EzKlcJfFXCsAgRDKz3MJKSc2Q125APY?=
 =?us-ascii?Q?/vMiQy334SJa59RbKWLeSZN0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae6a26a-d497-4f19-000d-08d92a182b62
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 00:55:54.7290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f8x7m7lry3X2upuCYe82N1zq2ta1B0SRVBcDtFq5wKqwJP7DAUD0vr9F65oIn+hY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is straightforward conversion, the mdev_state is actually serving as
the vfio_device and we can replace all the mdev_get_drvdata()'s and the
wonky dead code with a simple container_of()

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mtty.c | 185 ++++++++++++++++++---------------------
 1 file changed, 83 insertions(+), 102 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index b9b24be4abdab7..d2a168420b775d 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -127,6 +127,7 @@ struct serial_port {
 
 /* State of each mdev device */
 struct mdev_state {
+	struct vfio_device vdev;
 	int irq_fd;
 	struct eventfd_ctx *intx_evtfd;
 	struct eventfd_ctx *msi_evtfd;
@@ -150,6 +151,8 @@ static const struct file_operations vd_fops = {
 	.owner          = THIS_MODULE,
 };
 
+static const struct vfio_device_ops mtty_dev_ops;
+
 /* function prototypes */
 
 static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
@@ -631,22 +634,15 @@ static void mdev_read_base(struct mdev_state *mdev_state)
 	}
 }
 
-static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
+static ssize_t mdev_access(struct mdev_state *mdev_state, u8 *buf, size_t count,
 			   loff_t pos, bool is_write)
 {
-	struct mdev_state *mdev_state;
 	unsigned int index;
 	loff_t offset;
 	int ret = 0;
 
-	if (!mdev || !buf)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state) {
-		pr_err("%s mdev_state not found\n", __func__);
+	if (!buf)
 		return -EINVAL;
-	}
 
 	mutex_lock(&mdev_state->ops_lock);
 
@@ -708,15 +704,18 @@ static ssize_t mdev_access(struct mdev_device *mdev, u8 *buf, size_t count,
 	return ret;
 }
 
-static int mtty_create(struct mdev_device *mdev)
+static int mtty_probe(struct mdev_device *mdev)
 {
 	struct mdev_state *mdev_state;
 	int nr_ports = mdev_get_type_group_id(mdev) + 1;
+	int ret;
 
 	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
 	if (mdev_state == NULL)
 		return -ENOMEM;
 
+	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mtty_dev_ops);
+
 	mdev_state->nr_ports = nr_ports;
 	mdev_state->irq_index = -1;
 	mdev_state->s[0].max_fifo_size = MAX_FIFO_SIZE;
@@ -731,7 +730,6 @@ static int mtty_create(struct mdev_device *mdev)
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_set_drvdata(mdev, mdev_state);
 
 	mtty_create_config_space(mdev_state);
 
@@ -739,50 +737,40 @@ static int mtty_create(struct mdev_device *mdev)
 	list_add(&mdev_state->next, &mdev_devices_list);
 	mutex_unlock(&mdev_list_lock);
 
+	ret = vfio_register_group_dev(&mdev_state->vdev);
+	if (ret) {
+		kfree(mdev_state);
+		return ret;
+	}
+	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
 }
 
-static int mtty_remove(struct mdev_device *mdev)
+static void mtty_remove(struct mdev_device *mdev)
 {
-	struct mdev_state *mds, *tmp_mds;
-	struct mdev_state *mdev_state = mdev_get_drvdata(mdev);
-	int ret = -EINVAL;
+	struct mdev_state *mdev_state = dev_get_drvdata(&mdev->dev);
 
+	vfio_unregister_group_dev(&mdev_state->vdev);
 	mutex_lock(&mdev_list_lock);
-	list_for_each_entry_safe(mds, tmp_mds, &mdev_devices_list, next) {
-		if (mdev_state == mds) {
-			list_del(&mdev_state->next);
-			mdev_set_drvdata(mdev, NULL);
-			kfree(mdev_state->vconfig);
-			kfree(mdev_state);
-			ret = 0;
-			break;
-		}
-	}
+	list_del(&mdev_state->next);
 	mutex_unlock(&mdev_list_lock);
 
-	return ret;
+	kfree(mdev_state->vconfig);
+	kfree(mdev_state);
 }
 
-static int mtty_reset(struct mdev_device *mdev)
+static int mtty_reset(struct mdev_state *mdev_stte)
 {
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	pr_info("%s: called\n", __func__);
 
 	return 0;
 }
 
-static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
+static ssize_t mtty_read(struct vfio_device *vdev, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -792,7 +780,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		if (count >= 4 && !(*ppos % 4)) {
 			u32 val;
 
-			ret =  mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret =  mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					   *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -804,7 +792,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		} else if (count >= 2 && !(*ppos % 2)) {
 			u16 val;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -816,7 +804,7 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 		} else {
 			u8 val;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, false);
 			if (ret <= 0)
 				goto read_err;
@@ -839,9 +827,11 @@ static ssize_t mtty_read(struct mdev_device *mdev, char __user *buf,
 	return -EFAULT;
 }
 
-static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
+static ssize_t mtty_write(struct vfio_device *vdev, const char __user *buf,
 		   size_t count, loff_t *ppos)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	unsigned int done = 0;
 	int ret;
 
@@ -854,7 +844,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -866,7 +856,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -878,7 +868,7 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 			if (copy_from_user(&val, buf, sizeof(val)))
 				goto write_err;
 
-			ret = mdev_access(mdev, (u8 *)&val, sizeof(val),
+			ret = mdev_access(mdev_state, (u8 *)&val, sizeof(val),
 					  *ppos, true);
 			if (ret <= 0)
 				goto write_err;
@@ -896,19 +886,11 @@ static ssize_t mtty_write(struct mdev_device *mdev, const char __user *buf,
 	return -EFAULT;
 }
 
-static int mtty_set_irqs(struct mdev_device *mdev, uint32_t flags,
+static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 			 unsigned int index, unsigned int start,
 			 unsigned int count, void *data)
 {
 	int ret = 0;
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
 
 	mutex_lock(&mdev_state->ops_lock);
 	switch (index) {
@@ -1024,21 +1006,13 @@ static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
 	return ret;
 }
 
-static int mtty_get_region_info(struct mdev_device *mdev,
+static int mtty_get_region_info(struct mdev_state *mdev_state,
 			 struct vfio_region_info *region_info,
 			 u16 *cap_type_id, void **cap_type)
 {
 	unsigned int size = 0;
-	struct mdev_state *mdev_state;
 	u32 bar_index;
 
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -EINVAL;
-
 	bar_index = region_info->index;
 	if (bar_index >= VFIO_PCI_NUM_REGIONS)
 		return -EINVAL;
@@ -1073,8 +1047,7 @@ static int mtty_get_region_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mtty_get_irq_info(struct mdev_device *mdev,
-			     struct vfio_irq_info *irq_info)
+static int mtty_get_irq_info(struct vfio_irq_info *irq_info)
 {
 	switch (irq_info->index) {
 	case VFIO_PCI_INTX_IRQ_INDEX:
@@ -1098,8 +1071,7 @@ static int mtty_get_irq_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static int mtty_get_device_info(struct mdev_device *mdev,
-			 struct vfio_device_info *dev_info)
+static int mtty_get_device_info(struct vfio_device_info *dev_info)
 {
 	dev_info->flags = VFIO_DEVICE_FLAGS_PCI;
 	dev_info->num_regions = VFIO_PCI_NUM_REGIONS;
@@ -1108,19 +1080,13 @@ static int mtty_get_device_info(struct mdev_device *mdev,
 	return 0;
 }
 
-static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
+static long mtty_ioctl(struct vfio_device *vdev, unsigned int cmd,
 			unsigned long arg)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
 	int ret = 0;
 	unsigned long minsz;
-	struct mdev_state *mdev_state;
-
-	if (!mdev)
-		return -EINVAL;
-
-	mdev_state = mdev_get_drvdata(mdev);
-	if (!mdev_state)
-		return -ENODEV;
 
 	switch (cmd) {
 	case VFIO_DEVICE_GET_INFO:
@@ -1135,7 +1101,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mtty_get_device_info(mdev, &info);
+		ret = mtty_get_device_info(&info);
 		if (ret)
 			return ret;
 
@@ -1160,7 +1126,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
-		ret = mtty_get_region_info(mdev, &info, &cap_type_id,
+		ret = mtty_get_region_info(mdev_state, &info, &cap_type_id,
 					   &cap_type);
 		if (ret)
 			return ret;
@@ -1184,7 +1150,7 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 		    (info.index >= mdev_state->dev_info.num_irqs))
 			return -EINVAL;
 
-		ret = mtty_get_irq_info(mdev, &info);
+		ret = mtty_get_irq_info(&info);
 		if (ret)
 			return ret;
 
@@ -1218,25 +1184,25 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 				return PTR_ERR(data);
 		}
 
-		ret = mtty_set_irqs(mdev, hdr.flags, hdr.index, hdr.start,
+		ret = mtty_set_irqs(mdev_state, hdr.flags, hdr.index, hdr.start,
 				    hdr.count, data);
 
 		kfree(ptr);
 		return ret;
 	}
 	case VFIO_DEVICE_RESET:
-		return mtty_reset(mdev);
+		return mtty_reset(mdev_state);
 	}
 	return -ENOTTY;
 }
 
-static int mtty_open(struct mdev_device *mdev)
+static int mtty_open(struct vfio_device *vdev)
 {
 	pr_info("%s\n", __func__);
 	return 0;
 }
 
-static void mtty_close(struct mdev_device *mdev)
+static void mtty_close(struct vfio_device *mdev)
 {
 	pr_info("%s\n", __func__);
 }
@@ -1351,18 +1317,31 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static const struct vfio_device_ops mtty_dev_ops = {
+	.name = "vfio-mdev",
+	.open = mtty_open,
+	.release = mtty_close,
+	.read = mtty_read,
+	.write = mtty_write,
+	.ioctl = mtty_ioctl,
+};
+
+static struct mdev_driver mtty_driver = {
+	.driver = {
+		.name = "mtty",
+		.owner = THIS_MODULE,
+		.mod_name = KBUILD_MODNAME,
+		.dev_groups = mdev_dev_groups,
+	},
+	.probe = mtty_probe,
+	.remove	= mtty_remove,
+};
+
 static const struct mdev_parent_ops mdev_fops = {
 	.owner                  = THIS_MODULE,
+	.device_driver		= &mtty_driver,
 	.dev_attr_groups        = mtty_dev_groups,
-	.mdev_attr_groups       = mdev_dev_groups,
 	.supported_type_groups  = mdev_type_groups,
-	.create                 = mtty_create,
-	.remove			= mtty_remove,
-	.open                   = mtty_open,
-	.release                = mtty_close,
-	.read                   = mtty_read,
-	.write                  = mtty_write,
-	.ioctl		        = mtty_ioctl,
 };
 
 static void mtty_device_release(struct device *dev)
@@ -1393,12 +1372,16 @@ static int __init mtty_dev_init(void)
 
 	pr_info("major_number:%d\n", MAJOR(mtty_dev.vd_devt));
 
+	ret = mdev_register_driver(&mtty_driver);
+	if (ret)
+		goto err_cdev;
+
 	mtty_dev.vd_class = class_create(THIS_MODULE, MTTY_CLASS_NAME);
 
 	if (IS_ERR(mtty_dev.vd_class)) {
 		pr_err("Error: failed to register mtty_dev class\n");
 		ret = PTR_ERR(mtty_dev.vd_class);
-		goto failed1;
+		goto err_driver;
 	}
 
 	mtty_dev.dev.class = mtty_dev.vd_class;
@@ -1407,28 +1390,25 @@ static int __init mtty_dev_init(void)
 
 	ret = device_register(&mtty_dev.dev);
 	if (ret)
-		goto failed2;
+		goto err_class;
 
 	ret = mdev_register_device(&mtty_dev.dev, &mdev_fops);
 	if (ret)
-		goto failed3;
+		goto err_device;
 
 	mutex_init(&mdev_list_lock);
 	INIT_LIST_HEAD(&mdev_devices_list);
+	return 0;
 
-	goto all_done;
-
-failed3:
-
+err_device:
 	device_unregister(&mtty_dev.dev);
-failed2:
+err_class:
 	class_destroy(mtty_dev.vd_class);
-
-failed1:
+err_driver:
+	mdev_unregister_driver(&mtty_driver);
+err_cdev:
 	cdev_del(&mtty_dev.vd_cdev);
 	unregister_chrdev_region(mtty_dev.vd_devt, MINORMASK + 1);
-
-all_done:
 	return ret;
 }
 
@@ -1439,6 +1419,7 @@ static void __exit mtty_dev_exit(void)
 
 	device_unregister(&mtty_dev.dev);
 	idr_destroy(&mtty_dev.vd_idr);
+	mdev_unregister_driver(&mtty_driver);
 	cdev_del(&mtty_dev.vd_cdev);
 	unregister_chrdev_region(mtty_dev.vd_devt, MINORMASK + 1);
 	class_destroy(mtty_dev.vd_class);
-- 
2.31.1

