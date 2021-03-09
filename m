Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2606C3320BD
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 09:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhCIIew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 03:34:52 -0500
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:22241
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230391AbhCIIe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 03:34:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cWJTK6J/jBZWsQNOhcmEgVLoxJjN1S0tkucBd78r0WBloL9n6Duo5bvIO3M+k7lLGXBPA+YWmpkI1Gmvev+8rG9SfJFSxC2NBOrsCGN9+qphhv4lNVZzz+BLdgusCo9KrrvEhsn3+HALqWIj0wnEj2xWGcW8QYHR8fU8+Y9clP23EWlyo5VsTxgUKsf/vq/qWNJWh2vuq+IgAwMgPo/Zk4brKXRiGXiYbo+KnNVsSAtAkxGVjfJVsNxhKl8c/lexjh4sJrMTOZx+W9quaWWQbGuIk4ILf7AVD6LKJpg1kQ2+g0tcFIa1Yyja/iOZhVX4a1r/QUzKmxKfkKGoJ3ZG3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjWPBqmB7U6/noGHb2rlR42tWt1JsGf8FESaldVvzfM=;
 b=DaNuAM7gBMvfrYIpIO6rRzB4dsuTW/hoMiTludxir7aqqFrnlFd0xogSlo3qXdKVrKKPYukC4j8upg5Q+lmexvBCvGYleEmMk/B8a+dEwYjQU48VIHtSgo8/1J1qy8S11PtGu07u+0zNkgMTlW4BOvaJU7K9SDbywQSvx3MIQLXfLjY75HI2Ye/YvpJsTBEqEHDWuQTd+73RRdPDLsy1gYekrxB5CqHXJS6Noszk/ICSByBLvaq5Zx/OZICibGWo6xtWUw/kQGtO5PQGUQD+PJYSNtSeom0Cv03M55HAZYfxRl6boa43AHFUl6xNZgj+JFpgYDrJ5wsmo3LSK0eOSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjWPBqmB7U6/noGHb2rlR42tWt1JsGf8FESaldVvzfM=;
 b=AC7fUSop7m2+3O25xvgs/olqY0srjgSn8m411St9nhydapwT3giu1hMk1xlwCW+G9mTm5WrUvozl1yk/R7YCRpAnt/s3czpGCKp03aKA4sGKyFZd0N8cOmIYBy0txpXEyG+HslQTBRsx/jrmkZmpy33JttBoc25oczE3wmf5sUzyiif9veC7odVL+ENM5TJ2QCAI+e8Su6E32YrL6nLfhXQlwfC7cBv4iXOdPljizyrEAc+9M5QmqCc+Aaj2iMM7H4HhMLXsZ1Tlp1S9PnMDmPJ0TxatY1JSElGKZ1/hHgZcFJBuDngJgWC6nI3CX+StD3JqoPLnotwwl81xvmtWzg==
Received: from DM5PR12CA0018.namprd12.prod.outlook.com (2603:10b6:4:1::28) by
 BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.18; Tue, 9 Mar 2021 08:34:23 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:1:cafe::d3) by DM5PR12CA0018.outlook.office365.com
 (2603:10b6:4:1::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:34:22 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:34:21 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Mar 2021 08:34:16 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <jgg@nvidia.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <liranl@nvidia.com>, <oren@nvidia.com>, <tzahio@nvidia.com>,
        <leonro@nvidia.com>, <yarong@nvidia.com>, <aviadye@nvidia.com>,
        <shahafs@nvidia.com>, <artemp@nvidia.com>, <kwankhede@nvidia.com>,
        <ACurrid@nvidia.com>, <cjia@nvidia.com>, <yishaih@nvidia.com>,
        <mjrosato@linux.ibm.com>, <aik@ozlabs.ru>, <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 3/9] vfio-pci: rename vfio_pci_device to vfio_pci_core_device
Date:   Tue, 9 Mar 2021 08:33:51 +0000
Message-ID: <20210309083357.65467-4-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210309083357.65467-1-mgurtovoy@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd32584f-efeb-4161-23aa-08d8e2d62402
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:
X-Microsoft-Antispam-PRVS: <BL0PR12MB23706B8294147DEF9ADF5BF5DE929@BL0PR12MB2370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jOurUXdMFNMCqZaigNy21q4WD6N897L9rwYhcuAnh7aMv3V09e/TL/29Ii8xHDmOLtDvhJAvOV5LyIgZHCUj7seC9Fm5C99upIYOxV6qgUEQMmgn/kfAef/jnaFROsWayNqOy07JRhIkQR9itqJwQMTwXzgkZnqjAn35GdaNSHH4qDuUzAhIknTp7hhMhvf8TjRlw+cOWCEuhqbs9x/4S5eR661JjKvVWY5Ol6DG/thqYiO1+Kk/iMG6Z96dEADF8cCWLrYr2CcD/Ql6ViTx8nxGhu+/K52ek2ffcSmrHORJIuFKvj9YB6/9GUL/ra/metD4NWedZJjdGqBc688d5yWv906MQG52V+QfpquVDlWj5b1UQboF3kKuBSQW+vz1cR9MPQ9/7jhKXaziV7y8GJmZxgPctb6IWTMj4F+V+5OKxWDMNYcFF4V3QXutznXARUlisknd1ZkuF6eH3+STeWG7rciNz1SE08DAFzM9ZK94EaZBaV26RlAVcLMPMQV4JTLWjVtcRHDmSOJvfMxpMpil4R3wwW0O1VJav3Fgxz3tvVqpbw0xjVObdTYQUNFSUQBDq95wPsacRGh1+jfgkBnxVRkW9iLI2DVnoK9xHBGDLIO0UuUHa7dnivxkuL8UWkjFh+XFcflVA8GSCDbi7dHK2ZZIo4TxOlpcdtMW1sCNOPGdVcHNW25tATRkSfR
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(356005)(36860700001)(2616005)(6666004)(54906003)(82740400003)(26005)(2906002)(7636003)(316002)(186003)(478600001)(47076005)(426003)(82310400003)(34020700004)(70206006)(110136005)(107886003)(4326008)(1076003)(30864003)(336012)(5660300002)(36756003)(86362001)(8936002)(8676002)(70586007)(83380400001)(579004)(559001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:34:22.6424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd32584f-efeb-4161-23aa-08d8e2d62402
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2370
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change
any logic. The new vfio_pci_core_device structure will be the main
structure of the core driver and later on vfio_pci_device structure will
be the main structure of the generic vfio_pci driver.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c  | 68 +++++++++++-----------
 drivers/vfio/pci/vfio_pci_core.c    | 90 ++++++++++++++---------------
 drivers/vfio/pci/vfio_pci_core.h    | 76 ++++++++++++------------
 drivers/vfio/pci/vfio_pci_igd.c     | 14 ++---
 drivers/vfio/pci/vfio_pci_intrs.c   | 40 ++++++-------
 drivers/vfio/pci/vfio_pci_nvlink2.c | 20 +++----
 drivers/vfio/pci/vfio_pci_rdwr.c    | 16 ++---
 drivers/vfio/pci/vfio_pci_zdev.c    | 10 ++--
 8 files changed, 167 insertions(+), 167 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 5e9d24992207..122918d0f733 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -108,9 +108,9 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
 struct perm_bits {
 	u8	*virt;		/* read/write virtual data, not hw */
 	u8	*write;		/* writeable bits */
-	int	(*readfn)(struct vfio_pci_device *vdev, int pos, int count,
+	int	(*readfn)(struct vfio_pci_core_device *vdev, int pos, int count,
 			  struct perm_bits *perm, int offset, __le32 *val);
-	int	(*writefn)(struct vfio_pci_device *vdev, int pos, int count,
+	int	(*writefn)(struct vfio_pci_core_device *vdev, int pos, int count,
 			   struct perm_bits *perm, int offset, __le32 val);
 };
 
@@ -171,7 +171,7 @@ static int vfio_user_config_write(struct pci_dev *pdev, int offset,
 	return ret;
 }
 
-static int vfio_default_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_default_config_read(struct vfio_pci_core_device *vdev, int pos,
 				    int count, struct perm_bits *perm,
 				    int offset, __le32 *val)
 {
@@ -197,7 +197,7 @@ static int vfio_default_config_read(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-static int vfio_default_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_default_config_write(struct vfio_pci_core_device *vdev, int pos,
 				     int count, struct perm_bits *perm,
 				     int offset, __le32 val)
 {
@@ -244,7 +244,7 @@ static int vfio_default_config_write(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Allow direct read from hardware, except for capability next pointer */
-static int vfio_direct_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_direct_config_read(struct vfio_pci_core_device *vdev, int pos,
 				   int count, struct perm_bits *perm,
 				   int offset, __le32 *val)
 {
@@ -269,7 +269,7 @@ static int vfio_direct_config_read(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Raw access skips any kind of virtualization */
-static int vfio_raw_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_raw_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -282,7 +282,7 @@ static int vfio_raw_config_write(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-static int vfio_raw_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_raw_config_read(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 *val)
 {
@@ -296,7 +296,7 @@ static int vfio_raw_config_read(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Virt access uses only virtualization */
-static int vfio_virt_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_virt_config_write(struct vfio_pci_core_device *vdev, int pos,
 				  int count, struct perm_bits *perm,
 				  int offset, __le32 val)
 {
@@ -304,7 +304,7 @@ static int vfio_virt_config_write(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-static int vfio_virt_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 *val)
 {
@@ -396,7 +396,7 @@ static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
 }
 
 /* Caller should hold memory_lock semaphore */
-bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
+bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
@@ -413,7 +413,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
  * Restore the *real* BARs after we detect a FLR or backdoor reset.
  * (backdoor = some device specific technique that we didn't catch)
  */
-static void vfio_bar_restore(struct vfio_pci_device *vdev)
+static void vfio_bar_restore(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u32 *rbar = vdev->rbar;
@@ -460,7 +460,7 @@ static __le32 vfio_generate_bar_flags(struct pci_dev *pdev, int bar)
  * Pretend we're hardware and tweak the values of the *virtual* PCI BARs
  * to reflect the hardware capabilities.  This implements BAR sizing.
  */
-static void vfio_bar_fixup(struct vfio_pci_device *vdev)
+static void vfio_bar_fixup(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int i;
@@ -514,7 +514,7 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 	vdev->bardirty = false;
 }
 
-static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_basic_config_read(struct vfio_pci_core_device *vdev, int pos,
 				  int count, struct perm_bits *perm,
 				  int offset, __le32 *val)
 {
@@ -536,7 +536,7 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Test whether BARs match the value we think they should contain */
-static bool vfio_need_bar_restore(struct vfio_pci_device *vdev)
+static bool vfio_need_bar_restore(struct vfio_pci_core_device *vdev)
 {
 	int i = 0, pos = PCI_BASE_ADDRESS_0, ret;
 	u32 bar;
@@ -552,7 +552,7 @@ static bool vfio_need_bar_restore(struct vfio_pci_device *vdev)
 	return false;
 }
 
-static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 				   int count, struct perm_bits *perm,
 				   int offset, __le32 val)
 {
@@ -692,7 +692,7 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_pm_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
 {
@@ -747,7 +747,7 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_vpd_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_vpd_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -829,7 +829,7 @@ static int __init init_pci_cap_pcix_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_exp_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -913,7 +913,7 @@ static int __init init_pci_cap_exp_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_af_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
 {
@@ -1072,7 +1072,7 @@ int __init vfio_pci_init_perm_bits(void)
 	return ret;
 }
 
-static int vfio_find_cap_start(struct vfio_pci_device *vdev, int pos)
+static int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
 {
 	u8 cap;
 	int base = (pos >= PCI_CFG_SPACE_SIZE) ? PCI_CFG_SPACE_SIZE :
@@ -1089,7 +1089,7 @@ static int vfio_find_cap_start(struct vfio_pci_device *vdev, int pos)
 	return pos;
 }
 
-static int vfio_msi_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_msi_config_read(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 *val)
 {
@@ -1109,7 +1109,7 @@ static int vfio_msi_config_read(struct vfio_pci_device *vdev, int pos,
 	return vfio_default_config_read(vdev, pos, count, perm, offset, val);
 }
 
-static int vfio_msi_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_msi_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -1189,7 +1189,7 @@ static int init_pci_cap_msi_perm(struct perm_bits *perm, int len, u16 flags)
 }
 
 /* Determine MSI CAP field length; initialize msi_perms on 1st call per vdev */
-static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
+static int vfio_msi_cap_len(struct vfio_pci_core_device *vdev, u8 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int len, ret;
@@ -1222,7 +1222,7 @@ static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
 }
 
 /* Determine extended capability length for VC (2 & 9) and MFVC */
-static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
+static int vfio_vc_cap_len(struct vfio_pci_core_device *vdev, u16 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u32 tmp;
@@ -1263,7 +1263,7 @@ static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
 	return len;
 }
 
-static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
+static int vfio_cap_len(struct vfio_pci_core_device *vdev, u8 cap, u8 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u32 dword;
@@ -1338,7 +1338,7 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 	return 0;
 }
 
-static int vfio_ext_cap_len(struct vfio_pci_device *vdev, u16 ecap, u16 epos)
+static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 byte;
@@ -1412,7 +1412,7 @@ static int vfio_ext_cap_len(struct vfio_pci_device *vdev, u16 ecap, u16 epos)
 	return 0;
 }
 
-static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
+static int vfio_fill_vconfig_bytes(struct vfio_pci_core_device *vdev,
 				   int offset, int size)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -1459,7 +1459,7 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 	return ret;
 }
 
-static int vfio_cap_init(struct vfio_pci_device *vdev)
+static int vfio_cap_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 *map = vdev->pci_config_map;
@@ -1549,7 +1549,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-static int vfio_ecap_init(struct vfio_pci_device *vdev)
+static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 *map = vdev->pci_config_map;
@@ -1669,7 +1669,7 @@ static const struct pci_device_id known_bogus_vf_intx_pin[] = {
  * for each area requiring emulated bits, but the array of pointers
  * would be comparable in size (at least for standard config space).
  */
-int vfio_config_init(struct vfio_pci_device *vdev)
+int vfio_config_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 *map, *vconfig;
@@ -1773,7 +1773,7 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	return pcibios_err_to_errno(ret);
 }
 
-void vfio_config_free(struct vfio_pci_device *vdev)
+void vfio_config_free(struct vfio_pci_core_device *vdev)
 {
 	kfree(vdev->vconfig);
 	vdev->vconfig = NULL;
@@ -1790,7 +1790,7 @@ void vfio_config_free(struct vfio_pci_device *vdev)
  * Find the remaining number of bytes in a dword that match the given
  * position.  Stop at either the end of the capability or the dword boundary.
  */
-static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_device *vdev,
+static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_core_device *vdev,
 					   loff_t pos)
 {
 	u8 cap = vdev->pci_config_map[pos];
@@ -1802,7 +1802,7 @@ static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_device *vdev,
 	return i;
 }
 
-static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
+static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 				 size_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -1885,7 +1885,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return ret;
 }
 
-ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev, char __user *buf,
+ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	size_t done = 0;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index bd587db04625..557a03528dcd 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -121,7 +121,7 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
  */
 static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 {
-	struct vfio_pci_device *vdev = opaque;
+	struct vfio_pci_core_device *vdev = opaque;
 	struct pci_dev *tmp = NULL, *pdev = vdev->pdev;
 	unsigned char max_busnr;
 	unsigned int decodes;
@@ -155,7 +155,7 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
-static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
+static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 {
 	struct resource *res;
 	int i;
@@ -223,8 +223,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 	}
 }
 
-static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
-static void vfio_pci_disable(struct vfio_pci_device *vdev);
+static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev);
+static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
 static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data);
 
 /*
@@ -258,7 +258,7 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 	return false;
 }
 
-static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
+static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u16 pmcsr;
@@ -278,7 +278,7 @@ static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
  * by PM capability emulation and separately from pci_dev internal saved state
  * to avoid it being overwritten and consumed around other resets.
  */
-int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
+int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	bool needs_restore = false, needs_save = false;
@@ -309,7 +309,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_device *vdev)
+static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -416,7 +416,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static void vfio_pci_disable(struct vfio_pci_device *vdev)
+static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
@@ -517,7 +517,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 static struct pci_driver vfio_pci_driver;
 
-static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
+static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev,
 					   struct vfio_device **pf_dev)
 {
 	struct pci_dev *physfn = pci_physfn(vdev->pdev);
@@ -537,10 +537,10 @@ static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
 	return vfio_device_data(*pf_dev);
 }
 
-static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
+static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
 {
 	struct vfio_device *pf_dev;
-	struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
+	struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
 
 	if (!pf_vdev)
 		return;
@@ -555,7 +555,7 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
 
 static void vfio_pci_release(void *device_data)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_core_device *vdev = device_data;
 
 	mutex_lock(&vdev->reflck->lock);
 
@@ -583,7 +583,7 @@ static void vfio_pci_release(void *device_data)
 
 static int vfio_pci_open(void *device_data)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_core_device *vdev = device_data;
 	int ret = 0;
 
 	if (!try_module_get(THIS_MODULE))
@@ -607,7 +607,7 @@ static int vfio_pci_open(void *device_data)
 	return ret;
 }
 
-static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
+static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
 		u8 pin;
@@ -754,7 +754,7 @@ static int vfio_pci_for_each_slot_or_bus(struct pci_dev *pdev,
 	return walk.ret;
 }
 
-static int msix_mmappable_cap(struct vfio_pci_device *vdev,
+static int msix_mmappable_cap(struct vfio_pci_core_device *vdev,
 			      struct vfio_info_cap *caps)
 {
 	struct vfio_info_cap_header header = {
@@ -765,7 +765,7 @@ static int msix_mmappable_cap(struct vfio_pci_device *vdev,
 	return vfio_info_add_capability(caps, &header, sizeof(header));
 }
 
-int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
+int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 				 unsigned int type, unsigned int subtype,
 				 const struct vfio_pci_regops *ops,
 				 size_t size, u32 flags, void *data)
@@ -800,7 +800,7 @@ struct vfio_devices {
 static long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_core_device *vdev = device_data;
 	unsigned long minsz;
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
@@ -1280,7 +1280,7 @@ static long vfio_pci_ioctl(void *device_data,
 			goto hot_reset_release;
 
 		for (; mem_idx < devs.cur_index; mem_idx++) {
-			struct vfio_pci_device *tmp;
+			struct vfio_pci_core_device *tmp;
 
 			tmp = vfio_device_data(devs.devices[mem_idx]);
 
@@ -1298,7 +1298,7 @@ static long vfio_pci_ioctl(void *device_data,
 hot_reset_release:
 		for (i = 0; i < devs.cur_index; i++) {
 			struct vfio_device *device;
-			struct vfio_pci_device *tmp;
+			struct vfio_pci_core_device *tmp;
 
 			device = devs.devices[i];
 			tmp = vfio_device_data(device);
@@ -1406,7 +1406,7 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_core_device *vdev = device_data;
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
@@ -1453,7 +1453,7 @@ static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 }
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
-static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
+static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
 {
 	struct vfio_pci_mmap_vma *mmap_vma, *tmp;
 
@@ -1541,14 +1541,14 @@ static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
 	}
 }
 
-void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev)
+void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_zap_and_vma_lock(vdev, false);
 	down_write(&vdev->memory_lock);
 	mutex_unlock(&vdev->vma_lock);
 }
 
-u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev)
+u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev)
 {
 	u16 cmd;
 
@@ -1561,14 +1561,14 @@ u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev)
 	return cmd;
 }
 
-void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
+void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev, u16 cmd)
 {
 	pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
 	up_write(&vdev->memory_lock);
 }
 
 /* Caller holds vma_lock */
-static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
+static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
 			      struct vm_area_struct *vma)
 {
 	struct vfio_pci_mmap_vma *mmap_vma;
@@ -1594,7 +1594,7 @@ static void vfio_pci_mmap_open(struct vm_area_struct *vma)
 
 static void vfio_pci_mmap_close(struct vm_area_struct *vma)
 {
-	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	struct vfio_pci_mmap_vma *mmap_vma;
 
 	mutex_lock(&vdev->vma_lock);
@@ -1611,7 +1611,7 @@ static void vfio_pci_mmap_close(struct vm_area_struct *vma)
 static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
 
 	mutex_lock(&vdev->vma_lock);
@@ -1648,7 +1648,7 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 
 static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_core_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
@@ -1716,7 +1716,7 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 
 static void vfio_pci_request(void *device_data, unsigned int count)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_core_device *vdev = device_data;
 	struct pci_dev *pdev = vdev->pdev;
 
 	mutex_lock(&vdev->igate);
@@ -1735,7 +1735,7 @@ static void vfio_pci_request(void *device_data, unsigned int count)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
+static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 				      bool vf_token, uuid_t *uuid)
 {
 	/*
@@ -1768,7 +1768,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 
 	if (vdev->pdev->is_virtfn) {
 		struct vfio_device *pf_dev;
-		struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
+		struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev, &pf_dev);
 		bool match;
 
 		if (!pf_vdev) {
@@ -1832,7 +1832,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 
 static int vfio_pci_match(void *device_data, char *buf)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_core_device *vdev = device_data;
 	bool vf_token = false;
 	uuid_t uuid;
 	int ret;
@@ -1891,14 +1891,14 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.match		= vfio_pci_match,
 };
 
-static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
+static int vfio_pci_reflck_attach(struct vfio_pci_core_device *vdev);
 static void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck);
 
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
 {
-	struct vfio_pci_device *vdev = container_of(nb,
-						    struct vfio_pci_device, nb);
+	struct vfio_pci_core_device *vdev = container_of(nb,
+						    struct vfio_pci_core_device, nb);
 	struct device *dev = data;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pci_dev *physfn = pci_physfn(pdev);
@@ -1924,7 +1924,7 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 	struct iommu_group *group;
 	int ret;
 
@@ -2031,7 +2031,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 
 	pci_disable_sriov(pdev);
 
@@ -2071,7 +2071,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 
 	device = vfio_device_get_from_dev(&pdev->dev);
@@ -2098,7 +2098,7 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
@@ -2165,7 +2165,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 {
 	struct vfio_pci_reflck **preflck = data;
 	struct vfio_device *device;
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
@@ -2189,7 +2189,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	return 0;
 }
 
-static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
+static int vfio_pci_reflck_attach(struct vfio_pci_core_device *vdev)
 {
 	bool slot = !pci_probe_reset_slot(vdev->pdev->slot);
 
@@ -2224,7 +2224,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
 	struct vfio_device *device;
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 
 	if (devs->cur_index == devs->max_index)
 		return -ENOSPC;
@@ -2254,7 +2254,7 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
 {
 	struct vfio_devices *devs = data;
 	struct vfio_device *device;
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 
 	if (devs->cur_index == devs->max_index)
 		return -ENOSPC;
@@ -2299,12 +2299,12 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
  * to be bound to vfio_pci since that's the only way we can be sure they
  * stay put.
  */
-static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
+static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_devices devs = { .cur_index = 0 };
 	int i = 0, ret = -EINVAL;
 	bool slot = false;
-	struct vfio_pci_device *tmp;
+	struct vfio_pci_core_device *tmp;
 
 	if (!pci_probe_reset_slot(vdev->pdev->slot))
 		slot = true;
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index b9ac7132b84a..3964ca898984 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -32,15 +32,15 @@
 #define VFIO_PCI_IOEVENTFD_MAX		1000
 
 struct vfio_pci_ioeventfd {
-	struct list_head	next;
-	struct vfio_pci_device	*vdev;
-	struct virqfd		*virqfd;
-	void __iomem		*addr;
-	uint64_t		data;
-	loff_t			pos;
-	int			bar;
-	int			count;
-	bool			test_mem;
+	struct list_head		next;
+	struct vfio_pci_core_device	*vdev;
+	struct virqfd			*virqfd;
+	void __iomem			*addr;
+	uint64_t			data;
+	loff_t				pos;
+	int				bar;
+	int				count;
+	bool				test_mem;
 };
 
 struct vfio_pci_irq_ctx {
@@ -52,18 +52,18 @@ struct vfio_pci_irq_ctx {
 	struct irq_bypass_producer	producer;
 };
 
-struct vfio_pci_device;
+struct vfio_pci_core_device;
 struct vfio_pci_region;
 
 struct vfio_pci_regops {
-	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
+	size_t	(*rw)(struct vfio_pci_core_device *vdev, char __user *buf,
 		      size_t count, loff_t *ppos, bool iswrite);
-	void	(*release)(struct vfio_pci_device *vdev,
+	void	(*release)(struct vfio_pci_core_device *vdev,
 			   struct vfio_pci_region *region);
-	int	(*mmap)(struct vfio_pci_device *vdev,
+	int	(*mmap)(struct vfio_pci_core_device *vdev,
 			struct vfio_pci_region *region,
 			struct vm_area_struct *vma);
-	int	(*add_capability)(struct vfio_pci_device *vdev,
+	int	(*add_capability)(struct vfio_pci_core_device *vdev,
 				  struct vfio_pci_region *region,
 				  struct vfio_info_cap *caps);
 };
@@ -99,7 +99,7 @@ struct vfio_pci_mmap_vma {
 	struct list_head	vma_next;
 };
 
-struct vfio_pci_device {
+struct vfio_pci_core_device {
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
 	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
@@ -150,75 +150,75 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
-extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
+extern void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+extern void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
-extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
+extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
 				   uint32_t flags, unsigned index,
 				   unsigned start, unsigned count, void *data);
 
-extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
+extern ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
 				  char __user *buf, size_t count,
 				  loff_t *ppos, bool iswrite);
 
-extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+extern ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
-extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+extern ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
-extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
+extern long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);
 
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
-extern int vfio_config_init(struct vfio_pci_device *vdev);
-extern void vfio_config_free(struct vfio_pci_device *vdev);
+extern int vfio_config_init(struct vfio_pci_core_device *vdev);
+extern void vfio_config_free(struct vfio_pci_core_device *vdev);
 
-extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
+extern int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 					unsigned int type, unsigned int subtype,
 					const struct vfio_pci_regops *ops,
 					size_t size, u32 flags, void *data);
 
-extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
+extern int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 				    pci_power_t state);
 
-extern bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev);
-extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device
+extern bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
+extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device
 						    *vdev);
-extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev);
-extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev,
+extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
+extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
 					       u16 cmd);
 
 #ifdef CONFIG_VFIO_PCI_IGD
-extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
+extern int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
 #else
-static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
+static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
 }
 #endif
 #ifdef CONFIG_VFIO_PCI_NVLINK2
-extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev);
-extern int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev);
+extern int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_core_device *vdev);
+extern int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev);
 #else
-static inline int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
+static inline int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
 }
 
-static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
+static inline int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
 }
 #endif
 
 #ifdef CONFIG_S390
-extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
+extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
 #else
-static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
+static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
 {
 	return -ENODEV;
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 0c599cd33d01..2388c9722ed8 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -21,7 +21,7 @@
 #define OPREGION_SIZE		(8 * 1024)
 #define OPREGION_PCI_ADDR	0xfc
 
-static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
+static size_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			      size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
@@ -41,7 +41,7 @@ static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return count;
 }
 
-static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
+static void vfio_pci_igd_release(struct vfio_pci_core_device *vdev,
 				 struct vfio_pci_region *region)
 {
 	memunmap(region->data);
@@ -52,7 +52,7 @@ static const struct vfio_pci_regops vfio_pci_igd_regops = {
 	.release	= vfio_pci_igd_release,
 };
 
-static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
+static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
 {
 	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
 	u32 addr, size;
@@ -107,7 +107,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
+static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
 				  char __user *buf, size_t count, loff_t *ppos,
 				  bool iswrite)
 {
@@ -200,7 +200,7 @@ static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 	return count;
 }
 
-static void vfio_pci_igd_cfg_release(struct vfio_pci_device *vdev,
+static void vfio_pci_igd_cfg_release(struct vfio_pci_core_device *vdev,
 				     struct vfio_pci_region *region)
 {
 	struct pci_dev *pdev = region->data;
@@ -213,7 +213,7 @@ static const struct vfio_pci_regops vfio_pci_igd_cfg_regops = {
 	.release	= vfio_pci_igd_cfg_release,
 };
 
-static int vfio_pci_igd_cfg_init(struct vfio_pci_device *vdev)
+static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *host_bridge, *lpc_bridge;
 	int ret;
@@ -261,7 +261,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-int vfio_pci_igd_init(struct vfio_pci_device *vdev)
+int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 {
 	int ret;
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index df1e8c8c274c..945ddbdf4d11 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -27,13 +27,13 @@
  */
 static void vfio_send_intx_eventfd(void *opaque, void *unused)
 {
-	struct vfio_pci_device *vdev = opaque;
+	struct vfio_pci_core_device *vdev = opaque;
 
 	if (likely(is_intx(vdev) && !vdev->virq_disabled))
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
 
-void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
+void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
@@ -73,7 +73,7 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
  */
 static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 {
-	struct vfio_pci_device *vdev = opaque;
+	struct vfio_pci_core_device *vdev = opaque;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
 	int ret = 0;
@@ -107,7 +107,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	return ret;
 }
 
-void vfio_pci_intx_unmask(struct vfio_pci_device *vdev)
+void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 {
 	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
 		vfio_send_intx_eventfd(vdev, NULL);
@@ -115,7 +115,7 @@ void vfio_pci_intx_unmask(struct vfio_pci_device *vdev)
 
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
-	struct vfio_pci_device *vdev = dev_id;
+	struct vfio_pci_core_device *vdev = dev_id;
 	unsigned long flags;
 	int ret = IRQ_NONE;
 
@@ -139,7 +139,7 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	return ret;
 }
 
-static int vfio_intx_enable(struct vfio_pci_device *vdev)
+static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 {
 	if (!is_irq_none(vdev))
 		return -EINVAL;
@@ -168,7 +168,7 @@ static int vfio_intx_enable(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
+static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long irqflags = IRQF_SHARED;
@@ -223,7 +223,7 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 	return 0;
 }
 
-static void vfio_intx_disable(struct vfio_pci_device *vdev)
+static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 {
 	vfio_virqfd_disable(&vdev->ctx[0].unmask);
 	vfio_virqfd_disable(&vdev->ctx[0].mask);
@@ -244,7 +244,7 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
+static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
@@ -285,7 +285,7 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 	return 0;
 }
 
-static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
+static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      int vector, int fd, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -364,7 +364,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
+static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 			      unsigned count, int32_t *fds, bool msix)
 {
 	int i, j, ret = 0;
@@ -385,7 +385,7 @@ static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
 	return ret;
 }
 
-static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
+static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int i;
@@ -417,7 +417,7 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 /*
  * IOCTL support
  */
-static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
+static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -444,7 +444,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_mask(struct vfio_pci_device *vdev,
+static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 				  unsigned index, unsigned start,
 				  unsigned count, uint32_t flags, void *data)
 {
@@ -464,7 +464,7 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 				     unsigned index, unsigned start,
 				     unsigned count, uint32_t flags, void *data)
 {
@@ -507,7 +507,7 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -613,7 +613,7 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 	return -EINVAL;
 }
 
-static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -624,7 +624,7 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
 					       count, flags, data);
 }
 
-static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -635,11 +635,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
 					       count, flags, data);
 }
 
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
 {
-	int (*func)(struct vfio_pci_device *vdev, unsigned index,
+	int (*func)(struct vfio_pci_core_device *vdev, unsigned index,
 		    unsigned start, unsigned count, uint32_t flags,
 		    void *data) = NULL;
 
diff --git a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
index 326a704c4527..8ef2c62a9d27 100644
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -39,7 +39,7 @@ struct vfio_pci_nvgpu_data {
 	struct notifier_block group_notifier;
 };
 
-static size_t vfio_pci_nvgpu_rw(struct vfio_pci_device *vdev,
+static size_t vfio_pci_nvgpu_rw(struct vfio_pci_core_device *vdev,
 		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
@@ -89,7 +89,7 @@ static size_t vfio_pci_nvgpu_rw(struct vfio_pci_device *vdev,
 	return count;
 }
 
-static void vfio_pci_nvgpu_release(struct vfio_pci_device *vdev,
+static void vfio_pci_nvgpu_release(struct vfio_pci_core_device *vdev,
 		struct vfio_pci_region *region)
 {
 	struct vfio_pci_nvgpu_data *data = region->data;
@@ -136,7 +136,7 @@ static const struct vm_operations_struct vfio_pci_nvgpu_mmap_vmops = {
 	.fault = vfio_pci_nvgpu_mmap_fault,
 };
 
-static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *vdev,
+static int vfio_pci_nvgpu_mmap(struct vfio_pci_core_device *vdev,
 		struct vfio_pci_region *region, struct vm_area_struct *vma)
 {
 	int ret;
@@ -171,7 +171,7 @@ static int vfio_pci_nvgpu_mmap(struct vfio_pci_device *vdev,
 	return ret;
 }
 
-static int vfio_pci_nvgpu_add_capability(struct vfio_pci_device *vdev,
+static int vfio_pci_nvgpu_add_capability(struct vfio_pci_core_device *vdev,
 		struct vfio_pci_region *region, struct vfio_info_cap *caps)
 {
 	struct vfio_pci_nvgpu_data *data = region->data;
@@ -207,7 +207,7 @@ static int vfio_pci_nvgpu_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
-int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_device *vdev)
+int vfio_pci_nvdia_v100_nvlink2_init(struct vfio_pci_core_device *vdev)
 {
 	int ret;
 	u64 reg[2];
@@ -304,7 +304,7 @@ struct vfio_pci_npu2_data {
 	unsigned int link_speed; /* The link speed from DT's ibm,nvlink-speed */
 };
 
-static size_t vfio_pci_npu2_rw(struct vfio_pci_device *vdev,
+static size_t vfio_pci_npu2_rw(struct vfio_pci_core_device *vdev,
 		char __user *buf, size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
@@ -328,7 +328,7 @@ static size_t vfio_pci_npu2_rw(struct vfio_pci_device *vdev,
 	return count;
 }
 
-static int vfio_pci_npu2_mmap(struct vfio_pci_device *vdev,
+static int vfio_pci_npu2_mmap(struct vfio_pci_core_device *vdev,
 		struct vfio_pci_region *region, struct vm_area_struct *vma)
 {
 	int ret;
@@ -349,7 +349,7 @@ static int vfio_pci_npu2_mmap(struct vfio_pci_device *vdev,
 	return ret;
 }
 
-static void vfio_pci_npu2_release(struct vfio_pci_device *vdev,
+static void vfio_pci_npu2_release(struct vfio_pci_core_device *vdev,
 		struct vfio_pci_region *region)
 {
 	struct vfio_pci_npu2_data *data = region->data;
@@ -358,7 +358,7 @@ static void vfio_pci_npu2_release(struct vfio_pci_device *vdev,
 	kfree(data);
 }
 
-static int vfio_pci_npu2_add_capability(struct vfio_pci_device *vdev,
+static int vfio_pci_npu2_add_capability(struct vfio_pci_core_device *vdev,
 		struct vfio_pci_region *region, struct vfio_info_cap *caps)
 {
 	struct vfio_pci_npu2_data *data = region->data;
@@ -388,7 +388,7 @@ static const struct vfio_pci_regops vfio_pci_npu2_regops = {
 	.add_capability = vfio_pci_npu2_add_capability,
 };
 
-int vfio_pci_ibm_npu2_init(struct vfio_pci_device *vdev)
+int vfio_pci_ibm_npu2_init(struct vfio_pci_core_device *vdev)
 {
 	int ret;
 	struct vfio_pci_npu2_data *data;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 667e82726e75..8fff4689dd44 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -38,7 +38,7 @@
 #define vfio_iowrite8	iowrite8
 
 #define VFIO_IOWRITE(size) \
-static int vfio_pci_iowrite##size(struct vfio_pci_device *vdev,		\
+static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -65,7 +65,7 @@ VFIO_IOWRITE(64)
 #endif
 
 #define VFIO_IOREAD(size) \
-static int vfio_pci_ioread##size(struct vfio_pci_device *vdev,		\
+static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size *val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -94,7 +94,7 @@ VFIO_IOREAD(32)
  * reads with -1.  This is intended for handling MSI-X vector tables and
  * leftover space for ROM BARs.
  */
-static ssize_t do_io_rw(struct vfio_pci_device *vdev, bool test_mem,
+static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			void __iomem *io, char __user *buf,
 			loff_t off, size_t count, size_t x_start,
 			size_t x_end, bool iswrite)
@@ -200,7 +200,7 @@ static ssize_t do_io_rw(struct vfio_pci_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
+static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -224,7 +224,7 @@ static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 	return 0;
 }
 
-ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -288,7 +288,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return done;
 }
 
-ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)
 {
 	int ret;
@@ -384,7 +384,7 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_ioeventfd *ioeventfd = opaque;
-	struct vfio_pci_device *vdev = ioeventfd->vdev;
+	struct vfio_pci_core_device *vdev = ioeventfd->vdev;
 
 	if (ioeventfd->test_mem) {
 		if (!down_read_trylock(&vdev->memory_lock))
@@ -410,7 +410,7 @@ static void vfio_pci_ioeventfd_thread(void *opaque, void *unused)
 	vfio_pci_ioeventfd_do_write(ioeventfd, ioeventfd->test_mem);
 }
 
-long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
+long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 			uint64_t data, int count, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 3e91d49fa3f0..3216925c4d41 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -24,7 +24,7 @@
 /*
  * Add the Base PCI Function information to the device info region.
  */
-static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
+static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_pci_core_device *vdev,
 			 struct vfio_info_cap *caps)
 {
 	struct vfio_device_info_cap_zpci_base cap = {
@@ -45,7 +45,7 @@ static int zpci_base_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
 /*
  * Add the Base PCI Function Group information to the device info region.
  */
-static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
+static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_pci_core_device *vdev,
 			  struct vfio_info_cap *caps)
 {
 	struct vfio_device_info_cap_zpci_group cap = {
@@ -66,7 +66,7 @@ static int zpci_group_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
 /*
  * Add the device utility string to the device info region.
  */
-static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
+static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_pci_core_device *vdev,
 			 struct vfio_info_cap *caps)
 {
 	struct vfio_device_info_cap_zpci_util *cap;
@@ -90,7 +90,7 @@ static int zpci_util_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
 /*
  * Add the function path string to the device info region.
  */
-static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
+static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_pci_core_device *vdev,
 			 struct vfio_info_cap *caps)
 {
 	struct vfio_device_info_cap_zpci_pfip *cap;
@@ -114,7 +114,7 @@ static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_pci_device *vdev,
 /*
  * Add all supported capabilities to the VFIO_DEVICE_GET_INFO capability chain.
  */
-int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
+int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				struct vfio_info_cap *caps)
 {
 	struct zpci_dev *zdev = to_zpci(vdev->pdev);
-- 
2.25.4

