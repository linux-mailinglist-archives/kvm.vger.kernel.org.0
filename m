Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0E338806F
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351776AbhERTW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:22:59 -0400
Received: from mail-dm6nam10on2086.outbound.protection.outlook.com ([40.107.93.86]:37533
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237739AbhERTW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 15:22:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxgNjnliBfxYOisxHl6TTdXBVieY0t3Fm9fECVfdGjefEHnetgjAwD+c1u+pp6vwuHONF4WJIDWNfct9rnjsrY6YfPwpBFfIu973kAYzlcT3rrFzG66BSejEEsgUIpRu+y/TMl/MWERJTctjBQSxU2Y8yZaRfSd4/40xox+8+pHUqsHycSTznawuvVRWCg3RMfAhBMQBReS0Fo/aVRUIEZuTS+RrGHpqC2YdxzAKJ+ZvnOUzqpsEY449jwHkJ41+mR+e7nxETsF+Fv4chlksENZkJWVzht7xcLrEEJDqN3AToPEwZQjQ40Eb1V0klG9nzRgoGc41md78kc65+uQ9CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPvc4jkBAktBBlo93h8/ngO641pYp8KyDgeGu9dY7/0=;
 b=XSHjXU2skOENz3RWqVa+FDk1I+DZBDwrC2OI8849kuBwGkiGiRa2f895DtknsnEnZqofOV/CrFj9P/I+RStxeLJZuiDiNHOMBSgLZs5xoDOrLgCQCKAIyrTe+Q8+uDvWSHW9v24kFMVsBeFQZTOxVlQLTlFOGmPpM9ds4vAIGbrRMjmrWYfoHZ5JKJXM2N4O0YvkIQEWoYhoPVKtSaUK/uW79rJAtv07H1MrqeUKGzf9Os+3outb6O7FEpGzGUX/LfSK4hFZwfPnvM9r3jWK4TROFKnNGKAsJ9dOJRKh0mhSNnZaTfYY5rvSmz6DYgg8xri5IjQQJnuddh0d3heiBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPvc4jkBAktBBlo93h8/ngO641pYp8KyDgeGu9dY7/0=;
 b=XeF6k88oy3IH1MzIiUH+aCHG18R05Rpg9PmNy0oyufBkcwSkXGh8f4/KPXTcOKYUcr1TA0sszvNDoY1MkBbjs8kxG37JYQxLAJyClyDLWWpOYHh2RygK9dVoPR5z/j3QPvNgYapQ1G4AQVhhbZ9bvs5aMTIo/fm/pH4/T/rfaYM7jTzDbkjhpq/MTP23oXDAQW0tSrJin6t4PvPYlHloHno6kYy91mixbaIJzIkbVi67FpPprfkolOxtddPL5mHsYY3hKnonPtxmCGoZ5Y2rCon/JRX0GvQByy8pQGq5iZ0dRYm8NTwJnW063kzz3Eao+oOtomyAh3X/tdyhJkvkVQ==
Received: from BN1PR12CA0014.namprd12.prod.outlook.com (2603:10b6:408:e1::19)
 by MN2PR12MB3614.namprd12.prod.outlook.com (2603:10b6:208:c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Tue, 18 May
 2021 19:21:39 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::ed) by BN1PR12CA0014.outlook.office365.com
 (2603:10b6:408:e1::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Tue, 18 May 2021 19:21:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Tue, 18 May 2021 19:21:39 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 May
 2021 19:21:38 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 May
 2021 19:21:38 +0000
Received: from r-arch-stor02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 May 2021 19:21:36 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>
CC:     <oren@nvidia.com>, <eric.auger@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 2/3] vfio: centralize module refcount in subsystem layer
Date:   Tue, 18 May 2021 22:21:32 +0300
Message-ID: <20210518192133.59195-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210518192133.59195-1-mgurtovoy@nvidia.com>
References: <20210518192133.59195-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94d8c1f5-27b5-4a03-3427-08d91a322952
X-MS-TrafficTypeDiagnostic: MN2PR12MB3614:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3614F48C90EC40387F468969DE2C9@MN2PR12MB3614.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kAO+HgQECi/+b1qryczQ1ehz9rHjpji3y8YvCWY6twLs19xkaAhU3+9vsODRzzF1k3thqdcvFmiWuL6pmf3i0HUpVsEJyccadDbCMSn7dSOMP9Dect+/Gab2GZyVvyj4pfZm3ACBoVK/PqDyx0IqS6Xhpt9NsAyz2Y7cY5a6UCIKFOAXtRVJq03hSPX3Ioq/2Ij5dI6dPT8L0KN/tNjVEwyWX9YkCVg6uiem/YSc0f5nplzvNRjYd1RTVzdVeJkiS2HXGdnL6Fiy7hcwUgwly5dQ1wnGlKn65qxoGHYo4E74jU+65zEQA4mrlbuSxx+oqWQGLe0AdgSki7BaO9NGfdDr8c8TDt2rLKrplI7T8mrcHANHlXfBXy+1RxynRlQTdHtOD4jgsc4q547rgfeTbftoRcp3Ypxav2Mv1Z8lTsaCGCKH3iu4/ptta9fvvEDWocOe+2ai2gVSvncXjME0coTk7q6udXdYLHm6UodyWC5nsWcSsnUWSZUw1BmjwLTbAQRm5bY2RBddKwWqoE9qUxczKhexh3IVRHNODAfDQjW5FqzdSTF8uB2hYWGlqphbEwvYtuPmRy9o4uKfEA8p23Xi56YlaUXjcQplM7sbbncz+w3+zF5WtpfDrkpH3xTNTJRQhzONspUHIFRlIGqfb0G0AA2bd1BhAj6L1CESMr8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(46966006)(6666004)(4326008)(1076003)(83380400001)(2906002)(36756003)(82740400003)(86362001)(426003)(2616005)(47076005)(186003)(336012)(26005)(36906005)(316002)(110136005)(54906003)(356005)(107886003)(8676002)(70586007)(7636003)(70206006)(8936002)(478600001)(82310400003)(5660300002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2021 19:21:39.1876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d8c1f5-27b5-4a03-3427-08d91a322952
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3614
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove code duplication and move module refcounting to the subsystem
module.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 16 +++-------------
 drivers/vfio/mdev/vfio_mdev.c                | 13 +------------
 drivers/vfio/pci/vfio_pci.c                  |  7 -------
 drivers/vfio/platform/vfio_platform_common.c |  6 ------
 drivers/vfio/vfio.c                          | 10 ++++++++++
 5 files changed, 14 insertions(+), 38 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index 980e59551301..90cad109583b 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -140,26 +140,18 @@ static int vfio_fsl_mc_open(struct vfio_device *core_vdev)
 {
 	struct vfio_fsl_mc_device *vdev =
 		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
-	int ret;
-
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
+	int ret = 0;
 
 	mutex_lock(&vdev->reflck->lock);
 	if (!vdev->refcnt) {
 		ret = vfio_fsl_mc_regions_init(vdev);
 		if (ret)
-			goto err_reg_init;
+			goto out;
 	}
 	vdev->refcnt++;
-
+out:
 	mutex_unlock(&vdev->reflck->lock);
 
-	return 0;
-
-err_reg_init:
-	mutex_unlock(&vdev->reflck->lock);
-	module_put(THIS_MODULE);
 	return ret;
 }
 
@@ -196,8 +188,6 @@ static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
 	}
 
 	mutex_unlock(&vdev->reflck->lock);
-
-	module_put(THIS_MODULE);
 }
 
 static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 922729071c5a..5ef4815609ed 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -26,19 +26,10 @@ static int vfio_mdev_open(struct vfio_device *core_vdev)
 	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->type->parent;
 
-	int ret;
-
 	if (unlikely(!parent->ops->open))
 		return -EINVAL;
 
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
-	ret = parent->ops->open(mdev);
-	if (ret)
-		module_put(THIS_MODULE);
-
-	return ret;
+	return parent->ops->open(mdev);
 }
 
 static void vfio_mdev_release(struct vfio_device *core_vdev)
@@ -48,8 +39,6 @@ static void vfio_mdev_release(struct vfio_device *core_vdev)
 
 	if (likely(parent->ops->release))
 		parent->ops->release(mdev);
-
-	module_put(THIS_MODULE);
 }
 
 static long vfio_mdev_unlocked_ioctl(struct vfio_device *core_vdev,
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index bd7c482c948a..f6729baa1bf4 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -558,8 +558,6 @@ static void vfio_pci_release(struct vfio_device *core_vdev)
 	}
 
 	mutex_unlock(&vdev->reflck->lock);
-
-	module_put(THIS_MODULE);
 }
 
 static int vfio_pci_open(struct vfio_device *core_vdev)
@@ -568,9 +566,6 @@ static int vfio_pci_open(struct vfio_device *core_vdev)
 		container_of(core_vdev, struct vfio_pci_device, vdev);
 	int ret = 0;
 
-	if (!try_module_get(THIS_MODULE))
-		return -ENODEV;
-
 	mutex_lock(&vdev->reflck->lock);
 
 	if (!vdev->refcnt) {
@@ -584,8 +579,6 @@ static int vfio_pci_open(struct vfio_device *core_vdev)
 	vdev->refcnt++;
 error:
 	mutex_unlock(&vdev->reflck->lock);
-	if (ret)
-		module_put(THIS_MODULE);
 	return ret;
 }
 
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 470fcf7dac56..703164df7637 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -241,8 +241,6 @@ static void vfio_platform_release(struct vfio_device *core_vdev)
 	}
 
 	mutex_unlock(&driver_lock);
-
-	module_put(vdev->parent_module);
 }
 
 static int vfio_platform_open(struct vfio_device *core_vdev)
@@ -251,9 +249,6 @@ static int vfio_platform_open(struct vfio_device *core_vdev)
 		container_of(core_vdev, struct vfio_platform_device, vdev);
 	int ret;
 
-	if (!try_module_get(vdev->parent_module))
-		return -ENODEV;
-
 	mutex_lock(&driver_lock);
 
 	if (!vdev->refcnt) {
@@ -291,7 +286,6 @@ static int vfio_platform_open(struct vfio_device *core_vdev)
 	vfio_platform_regions_cleanup(vdev);
 err_reg:
 	mutex_unlock(&driver_lock);
-	module_put(vdev->parent_module);
 	return ret;
 }
 
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 5e631c359ef2..02cc51ce6891 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1369,8 +1369,14 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
+	if (!try_module_get(device->dev->driver->owner)) {
+		vfio_device_put(device);
+		return -ENODEV;
+	}
+
 	ret = device->ops->open(device);
 	if (ret) {
+		module_put(device->dev->driver->owner);
 		vfio_device_put(device);
 		return ret;
 	}
@@ -1382,6 +1388,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	ret = get_unused_fd_flags(O_CLOEXEC);
 	if (ret < 0) {
 		device->ops->release(device);
+		module_put(device->dev->driver->owner);
 		vfio_device_put(device);
 		return ret;
 	}
@@ -1392,6 +1399,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 		put_unused_fd(ret);
 		ret = PTR_ERR(filep);
 		device->ops->release(device);
+		module_put(device->dev->driver->owner);
 		vfio_device_put(device);
 		return ret;
 	}
@@ -1550,6 +1558,8 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	device->ops->release(device);
 
+	module_put(device->dev->driver->owner);
+
 	vfio_group_try_dissolve_container(device->group);
 
 	vfio_device_put(device);
-- 
2.18.1

