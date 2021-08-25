Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A563F766B
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241513AbhHYNxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:53:11 -0400
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:52449
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241482AbhHYNxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:53:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8/3w+jqAm/RM/luMAuYQ96WL+ZGtxrFhKPkMolfcdyyrOjEt9ke91F/Pms2GwsLKzw66uh7pdpL+LCdfvqPv+SE8JLMyKD2YY5ibHyfjOR8arrbBvOmywu8fR85fOGGbCTZftDmHawA6tgPnEttLH+661VRUpE6LzO+Gh5opsUCataN+VxAAZs8OjkjAu3pk5DqMdgvwyIZKA6yFc9INRysHah4bjxpRwMFL2XDo0AAmb41XAGJGhjZbyKHONuLxL7aABE1O0YFwCF2yt3FDarbHjjk/MXCOGSB3I+vsYnRxbd5Cn9sVKw6SHBabhnMIA+7ygMWLsSmUt/BiJSekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk6eiJRzhHqxXMmQf+G6er3GAE5IGBFw1AxsURvDILY=;
 b=WXdcTh6rtoUCMNYLx5Fn0028iUqfQA0ap3CzD6U2XPEw7SB29/knZpzlV8hqMJMdjLDFpVez6O5quUjSB6MJxmPUKWM6E0xr+Icl2ERHSzTZStuPi7l7mc+UjeYM5yDHuBMveaKpiAeWqh86CgmziNbuavD1OQeYI8zo1kcXp69PsZ3c/mLmdu7CaoSkaClYLS29a6I9kJUtZzjMa9S+0mFctETKSEed3xAsYmgmMqSHr5zJgNyZt1eSP7L9eTrdbOd8bwCuks/PvRsV1ac3xJgi3fk5t9IgEQiuwjcq+xYt8N8hCqHd9+O+IZaGsqmgjZxV4V4XpuyNCWaoPLKDAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk6eiJRzhHqxXMmQf+G6er3GAE5IGBFw1AxsURvDILY=;
 b=OskupZFQ/wszM2nBkZFCSacqVCkApzP02peteb3pKc+b8dyX3Mv6k6TkXurgQ7XTS+c8JxuWOQVTS5lrXY0W9tACVjUmQIRzzi33jYHJjXT9Hhm5zId5P9z5FhhxFZcwaXiYfYvxKile0HM6Uwz0i7OkB4kpWC96N2Z2s4vSmY0F3eGDmcPRYh4ZN2X9cIouPkouGdzaeSFrC4TQKKeXS0NvxAy+KLPzw46yx0thHYjxFRfiUA7ceoYF4NSNDEt9Li6at4X9Q547jMrMkyxDiQ3SF769s30tGkRdZHcuzac2MfBK97c+BGzeoH/gTasZUirJvrMb5c7LsWEFWXCXoQ==
Received: from CO1PR15CA0109.namprd15.prod.outlook.com (2603:10b6:101:21::29)
 by MWHPR12MB1407.namprd12.prod.outlook.com (2603:10b6:300:15::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Wed, 25 Aug
 2021 13:52:16 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:101:21:cafe::42) by CO1PR15CA0109.outlook.office365.com
 (2603:10b6:101:21::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Wed, 25 Aug 2021 13:52:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:52:15 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 06:52:14 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:10 -0700
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
Subject: [PATCH V4 04/13] vfio/pci: Rename ops functions to fit core namings
Date:   Wed, 25 Aug 2021 16:51:30 +0300
Message-ID: <20210825135139.79034-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 693e6453-8fcf-47fd-8406-08d967cf8c60
X-MS-TrafficTypeDiagnostic: MWHPR12MB1407:
X-Microsoft-Antispam-PRVS: <MWHPR12MB14076A982E6C5AC7BA1D1F25C3C69@MWHPR12MB1407.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eX+t6Cx0LYSFZVqhuerTVP2ieiHyvkTXu4659i5BjL78gZbAHHCoS6r9iKOce3uo2vgrkdp7L0Dxo+iBBfgLJL094N3uaeatu08xI9AvPIHu4VapONtD9K0JFzS3wZDh3pJjUPGRZ4wpwrXX2Ikr49J3r3nBmzkE/Q3S6wJ01UF0f3HkSvTUHi/nVJ9QbSpivJmZX8dRIDBzsu3O+gFsJfuVI6z885PhYHVqsmgtKW2Jh23pFEvKuT6c1A5e0a27LSiqIBIk5RRWZIha5s14uvkeaK3xXj+Qx4QLcvYiUrWKLwp59Se1tU58iCPjVWwKvaeH5pcgUSo7YSD+oEAF0uo3XPE29VvCyh/g2s2I6Ls5F366mn8HIUvd7x7YKLGmCnQBgmgsw/2jUAAzYa7Bq11kCD1F2OvQt+t0p6ybdH8iMG3njI2Kc8vC7DnwAneaoNGZKU/3mNIDhgxadtpuVdnU06X15AXPXnVMJ3CmhA0JlXr/BQXSIluVmatfOe8OjjWIX1l4TxZspmZ1KDIyRX71Uj6Db23F3vAMYqTMDlpaD3rrApzgvPYxpWHd4a/aRQlwQog8Cjg5AphHSCMGA632AOQ8G3Tcd+doncEKdlhwFrQFMwBGoFK55LD8GyGVueQfeiD8XTt+bBIbS8q3Mzfxylr71vldgW3Kc49R8cLAtuKolFKbidrxUnHsEf6sDQWOB5nHO3eG1Mii/JHzVG9+5orvu8i2tHpp04ak2CU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8676002)(1076003)(82310400003)(83380400001)(2906002)(4326008)(7636003)(186003)(8936002)(7696005)(508600001)(356005)(86362001)(70206006)(7416002)(426003)(54906003)(2616005)(107886003)(36756003)(70586007)(26005)(110136005)(6666004)(47076005)(36860700001)(316002)(336012)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:52:15.8533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 693e6453-8fcf-47fd-8406-08d967cf8c60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1407
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

