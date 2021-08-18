Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7133F07C9
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239927AbhHRPRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:17:41 -0400
Received: from mail-sn1anam02on2070.outbound.protection.outlook.com ([40.107.96.70]:6613
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239906AbhHRPRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:17:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cO7BwkIUK6oE93FWoZATPzJkF9mMvratVfhf3NLPgaG8K5D+3b6NQKr1epCNWTkk2U0pJ4xISUclP8xw6jCQUmULhqUVUQ6fFL2b6eW0m3jqkOVVXyPrlF2Y6NoIcYkqUwFEV/isKGfi/TqdTtmFzHzIwYvkc2ZB2pnc0uXr6XXlHgt8vWVUdwW0G66NHXi6Ir1s87+0v55wsVoZTsrpsmrdZUksqPlvKKvVvTmp2caHNVk6GvzvNJi2uJq4EpICjp8WaQzjyxN3gdFjBAMu3XTpTBW0A1XpWHeHbXwMsb5KLpMeL/fXvY7dpWuSy8POxHeds8AbLnGtVLTACxXyog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk6eiJRzhHqxXMmQf+G6er3GAE5IGBFw1AxsURvDILY=;
 b=ZjNFiVVTgWT37/YtgCOip7aBpIIkjoSz3gzvIiE/p2DjIQyVaj1gsI760vQcIFJbM13KA3IW0fAEa0CVbG7zh+dlChKibjKibc9tQk7/fytbbiLTDB2oNfv6KqpB9o7r2I2wrsEXEBL0d5drNXRfaQEFVgx7nyrDW5Qb+jXoi3bhgpSeo0fBVXL7L2C45d+fGH7MSIz4CeFzsMmLZzIFWzKUzqXYb7nMyr3AB5EJ8znTnly6lvwCjvz1OFcSGKlKhUtS2fKZOylT1Mv+L5sxLfx+iTANTmw9HOOJVGfr5rsv4GuQXGJ0sSimxomxcEhVoxyji+zj6jXtw9vqqR0mqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk6eiJRzhHqxXMmQf+G6er3GAE5IGBFw1AxsURvDILY=;
 b=HP/Bo7YVsBe8zM6PtHTF3ZFiomszr6QfD4qv70qT/6Wc5atJTYYYmAEv1pHjNYSfhmKOSOmh5F6fclL0ehE5sdnxEinajV1nXEaihSfYXPU4BNEUDjiBJcWu5Xm5jOxGf0nlB7EOIu2hJQir6ZNj3MSHyM71aAbOCn/7dkcVs+EJ1tKWO0MEslNRHZ9159XsN3CTeKLaUhuXjmIeOirTzUyngQtdxK3v/ZKCcfDyJiEiV/JfNTlYe+wY/TnpsEIQ+gbKZwA3HcQmTYC8b6o48kFoL6F8bh3KqcF0NopLGj40dx7tF9ovUs0Jed30rW9zbHsg1NQRqf3yWSKXFgXKeA==
Received: from BN9PR03CA0253.namprd03.prod.outlook.com (2603:10b6:408:ff::18)
 by BN9PR12MB5067.namprd12.prod.outlook.com (2603:10b6:408:134::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 15:17:03 +0000
Received: from BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::5f) by BN9PR03CA0253.outlook.office365.com
 (2603:10b6:408:ff::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT062.mail.protection.outlook.com (10.13.177.34) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:03 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:17:02 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:58 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V2 04/12] vfio/pci: Rename ops functions to fit core namings
Date:   Wed, 18 Aug 2021 18:15:58 +0300
Message-ID: <20210818151606.202815-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86809f50-a8b8-4c80-fb79-08d9625b3bbd
X-MS-TrafficTypeDiagnostic: BN9PR12MB5067:
X-Microsoft-Antispam-PRVS: <BN9PR12MB50673857E6ADBD1BF97DE49EC3FF9@BN9PR12MB5067.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nxhpn6PgtbUBcgUY58iVY+Vvy6nKsMmJs/0wD7zssiLR7U/msdsltjmFPQKvLNOgL3IKBXw5XK6GJJClHTyWp43W5PMZYSn9DAnxDncpLIdBJDr7iKRX4xj/WY+1eaC3Qea6+UJeVJrJWtJURywBVdAb7uL4sNbZWLL/1cIAAfv2Tl8XOWIoonZs2NsO++HvyJxQuCee5KAmT3VEq090EYBeCWuZ+7ydUR/uB746ebzPEUNu+EMWtZXHDGfl+nz8L9dl6c9npzGsQg8N/wamVozgJ0yB5S1rzGb5uCVwgXZwrA+a+wJiD1W9FarxMK4un3bo37mHZgpwF0IMA1llEASW/7wh4v/yhz1jR2j5BB1XkKT/hoX0xfxJ9LkFj8aInqRVWWQ7tgUaeVhgAQDLoZzwHJGYYPyw5w3v4LsWQ/16eRRBcP3enI4ANT7uMeaUDmh9p9vBRUPnJJeDJj5O2tT+oss3SAC4nLqPn49MFGvFKDfpmifw2OG54dXuQFPOt7Ch7ZrqIxdUjAUwwX0olsSHDHuSBS8IJdtzFXCu9N/56nPWxT8gUAoPl51UDr7Ro2F5tZho8EdBzIJUTcH636a+PNdJwNZZmYdpxYrEARQYwPn/cTVUGGRntHD4JWwR18cih5LHGo9G4+mjtdlh2FRGxcPRgmVcsnbCWwfZMzoTmlX8O2uDgtWqAQDQCpMYwORntUCY48koRjfdLOyg14qXL1SDOfL+chNw5UnSnLw=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(83380400001)(508600001)(1076003)(82310400003)(316002)(8676002)(86362001)(2616005)(47076005)(8936002)(36860700001)(70206006)(70586007)(110136005)(54906003)(356005)(186003)(2906002)(7636003)(36756003)(7416002)(4326008)(336012)(426003)(107886003)(26005)(7696005)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:03.1889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86809f50-a8b8-4c80-fb79-08d9625b3bbd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is another preparation patch for separating the vfio_pci driver to
a subsystem driver and a generic pci driver. This patch doesn't change
any logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
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

