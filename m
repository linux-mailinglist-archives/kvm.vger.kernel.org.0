Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5C83F8586
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241582AbhHZKkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:40:46 -0400
Received: from mail-bn7nam10on2040.outbound.protection.outlook.com ([40.107.92.40]:60001
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241634AbhHZKko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:40:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLwwXxTdm8Z7GS8KYo5hcWXM7wKgHo06i0eJO5oNRapdTbG8FdtFi67/FJvlUdTnvm1NYs+3oWuLvD3kSGIyUe9EFpRFGrfkgvt+Wix6CusvJe0R+r4xnxKXvEK8nWlcbsz5ogYBYpsHvnlDDpcIiOVi5Aly3e6tBszO8YbklMZca1ms18vkkiI+kN6BcJoVIe0psBkjYD/JXAzqq55e1QWaxDbIgXEqkWePv+k+PXsW06Ltu9rnfbUuVISWvCnkZZVX3cc4SOBulzKgZEbSrw3LiX9nuNowOx0t4F2HJ6JgADlvEs7B+w2KMQzcHizRFfv6MBMCJcDGSRt3GPvdyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/J4SvQ87XPIq3mxn574viNNIKiNG/moRB/ISBmTwAk=;
 b=GOdywkYby7kPteKG7ENXCug6+vQmm2W5PJDSxWv5/6hXNRDpg6lBd7qaGg8fA8ZR9DVligUSeB+07PikieSlWAcS4Qq51A6BmA7IriWLBkbB/y0FY64yn9Va9besVkyhMVwX6KVxi9T3CdBIE0SO3BG8WOoqskmh/IN6YhrZJ2v9wpTsPIe+D7Q3MslA6sGN1DidcMn1WkJcEJxM5cHhtXIaJtHPE2/aBV1sObrQqolR+6BVJuFZeZUgqRPEvu8T20+8rx1NU3FQD7Kefkljasglk+YNkM3J46t4aGyjbPv1N39/eycaR79dNqJ4FhdBCu7nx2hxs/3ZtbBPx0kZvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/J4SvQ87XPIq3mxn574viNNIKiNG/moRB/ISBmTwAk=;
 b=D1pheo5M4+R5Qd2/UK9AuZvrq0A352gqmFUXepHEHpQPENZ9/EegEkpsya1prCFVuFjuDXpOUmuEQJDo/2Pep+nmE09hsEYE3REZJhij2v8jJTpEp8yz/dt06e2RvT2XmrJQWjXnosr3oRKz0eqcGsqAepbC7XgAVx7sU3LvEpYToYT6GSH22/+UIwT78vMP3fidEXAMtq50sqwmA8+EL8gqUHWGUcQb8ENIMPV4tvsxqOQOGTOyWPkXBvdcUBLlTB/a6uy/vLVk3DBTct5fenruhAhAHLlTBDQxuCumpLa16nbAPzlJ1EP+vziV/s3/2KYQmOH+hwIy2LtRIvTBUg==
Received: from MW4PR03CA0282.namprd03.prod.outlook.com (2603:10b6:303:b5::17)
 by BN6PR12MB1188.namprd12.prod.outlook.com (2603:10b6:404:19::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Thu, 26 Aug
 2021 10:39:55 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::67) by MW4PR03CA0282.outlook.office365.com
 (2603:10b6:303:b5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:39:55 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:39:54 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:50 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>, "Christoph Hellwig" <hch@lst.de>
Subject: [PATCH V5 04/13] vfio/pci: Rename ops functions to fit core namings
Date:   Thu, 26 Aug 2021 13:39:03 +0300
Message-ID: <20210826103912.128972-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a239eca8-7c7f-4f5a-a993-08d9687dd809
X-MS-TrafficTypeDiagnostic: BN6PR12MB1188:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1188C30F1C3DA115F27CBBADC3C79@BN6PR12MB1188.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgrKvWk8oPOk5TzGSbV+3fzcUYy3f4f3CfQNpw+lKJ3x3Z4FsPln8gux8RQmJXXiYz55ttvJtGrkKdBrKefuCWiXAsWkBXv3HukE8/OPWIGQGGLP3YrWPbuv4hL+zH8BV10TMDrw0y0vEUJa6gxqvo3fyIcJ09b8crLhgxYcFUdAtKFsRMAeLw6YRW53Ox5+bRw/Xb1mN72ImvHWwW3YB/vLzzyi93zfnrFWvtGhIW7JIDVNnGpuIyxXCKHnqKcFU5HI1OQBvgisnsgNrpsPYbFxkWRNqbAPNBYLWD+8FiXtDzQfutIHG9K0wAOSHQYWTexB53c2B1v7OM62fKsRyTVrUUF8Sf7dqHywdMSTcqX5oA9USar0+ELqJjGPoYb5rNarJ9aAKiPzCHa3OuYTI4kUjpIKlfM/21SK0SfcijMQqn9vUAzJmMca2+1Eqs6ULcYqJ1cQmffSFJ3RVVT7/3rnHtSMoPjfyx6WhjmhzuMPsDLTp3zBW7gcERs53frd4MTFfmfJuhQlNJrHMo1/Fyc+buey4X2H8oH6NE0r//ZcU33Xw17rS2SnGTVbSm+rcdPKFrR7MntjHTwkE7CH+m8sLDkThx0cs8b4U+RxgUiipqNdydi/BPk4XcX5FuICX3RHFXu+wK0QLbrOJ0r89CBgq8fYDbJLPHssvj79VB4Gtv6rIFfZLUCpx5Q2SH52xTsl1XXKK0mR96P0vRhu4bESEIA/ziA44Q3bW4jAyLw=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(36840700001)(46966006)(8676002)(7696005)(26005)(478600001)(5660300002)(82310400003)(1076003)(8936002)(186003)(4326008)(356005)(82740400003)(36756003)(36860700001)(70206006)(2616005)(7636003)(47076005)(336012)(6666004)(86362001)(426003)(316002)(7416002)(54906003)(110136005)(36906005)(2906002)(83380400001)(70586007)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:39:55.3329
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a239eca8-7c7f-4f5a-a993-08d9687dd809
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1188
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is another preparation patch for separating the vfio_pci driver to
a subsystem driver and a generic pci driver. This patch doesn't change
any logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2729479390a0..ee5c8fe2a324 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -533,7 +533,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int va
 	vfio_device_put(&pf_vdev->vdev);
 }
 
-static void vfio_pci_close_device(struct vfio_device *core_vdev)
+static void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -554,7 +554,7 @@ static void vfio_pci_close_device(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_open_device(struct vfio_device *core_vdev)
+static int vfio_pci_core_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -727,7 +727,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 	return 0;
 }
 
-static long vfio_pci_ioctl(struct vfio_device *core_vdev,
+static long vfio_pci_core_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1302,7 +1302,7 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
+static ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1314,7 +1314,7 @@ static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *buf,
+static ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
 	struct vfio_pci_core_device *vdev =
@@ -1533,7 +1533,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
+static int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1604,7 +1604,7 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 	return 0;
 }
 
-static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
+static void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1720,7 +1720,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
+static int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
@@ -1772,14 +1772,14 @@ static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
 
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
-	.open_device	= vfio_pci_open_device,
-	.close_device	= vfio_pci_close_device,
-	.ioctl		= vfio_pci_ioctl,
-	.read		= vfio_pci_read,
-	.write		= vfio_pci_write,
-	.mmap		= vfio_pci_mmap,
-	.request	= vfio_pci_request,
-	.match		= vfio_pci_match,
+	.open_device	= vfio_pci_core_open_device,
+	.close_device	= vfio_pci_core_close_device,
+	.ioctl		= vfio_pci_core_ioctl,
+	.read		= vfio_pci_core_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
 };
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
-- 
2.18.1

