Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890EE3F769C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 15:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbhHYNyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 09:54:22 -0400
Received: from mail-bn7nam10on2072.outbound.protection.outlook.com ([40.107.92.72]:36196
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241238AbhHYNyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 09:54:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXOirWqB8/Qwie/9DMumHeohUN6s9adXGucda3XQoNxY+B1HBk5wnehkzSLZH/e4hWcrXWFaMfZ+U18KJ736wfu0hhVFI2jK+rWQSUCjSJfxaKX+2t71SQBXtzDc8ejINU6aXogNndokSsmF55J/ZbvmMa4BxbFIPW4Bb/S6RMuaMxLLaB/igXL02cd0OIjg378qfaWhJLIJ0TQdy3Y0glTcxDdBm9p8bHp+Y46ALXn8tSYZeEgj3IlKhcxxjUwYTVRo4Y+4kYaUF+0gKbpQZF3bGMrNoBSIrNIHfLB4T+DckusLaQmdj5VuNH7tn4gpKiHMLnbqSiTWQPTm2wh3+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DatpDBmFPtOp7btyGUUOB0LDoqTeUHQqApMGXwDBhAk=;
 b=JpKR1h8AsyCiELSIdKbHFSDZ90k/FB/GA7lDwJSPx/wIlPMZwaeLXpISlWTme/OnxcNqMqy6rpVrHiZmhw6tnwNDP/3ijAG+bZ8omPAFUWHiP4MEPZZO/gHhJHGKt4acNka94TmvDl+3IQOKOJwaUXjy6DqmHL9U6LRBhVFIE+sx/miyb19VpiLkbzamoWH36lWCgApTS5+yQupZNZHPWG2+oy6xJ9I02quWtiaIrnF0E8jgiGBzIdclEMwg8Xzm4PqlccToDEf9G1DPAUAGd1+dvFMYjFM1MEQ0MUWS9Z3Bjwu1PpTkphWMJbEjfeNsLv7AmkvRQaLMKVI9TiPAgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DatpDBmFPtOp7btyGUUOB0LDoqTeUHQqApMGXwDBhAk=;
 b=IZtRLf8QMDtPOmRy1C8trDXYDVCP2A5SpnylyGgqj8hofXB40xBClz0Jwg7slsmYSReDWhmQ2lHaSK26CYEM7Yo+cd9XqDhlFhiWKbqYT/AnJH3Is5ZU0S92KdrZcRdHkxLt/ei+Sc0ajefY+WnAm1BxWkMXgd4gIatREr2Jfw9M4CK3P3ssmKx8PgL+7JVG1RQODa7aVFvEp1db5qp3/rWG/lALlt7LpdXAxkvuhKW0ZBETWOlH50ol1JzPcjUjuYRPhqzqgq/x91lWMqSHTbBt5NjJ9I+r5ygcyN252Zdad+gWHgo7Nvqxvqbv10xYnysr5BiL8sl+D6vZZNSK5w==
Received: from MWHPR18CA0026.namprd18.prod.outlook.com (2603:10b6:320:31::12)
 by DM6PR12MB3881.namprd12.prod.outlook.com (2603:10b6:5:148::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 13:53:14 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::35) by MWHPR18CA0026.outlook.office365.com
 (2603:10b6:320:31::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Wed, 25 Aug 2021 13:53:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 13:53:13 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Aug
 2021 13:52:27 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Aug 2021 06:52:23 -0700
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
Subject: [PATCH V4 07/13] vfio/pci: Move igd initialization to vfio_pci.c
Date:   Wed, 25 Aug 2021 16:51:33 +0300
Message-ID: <20210825135139.79034-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210825135139.79034-1-yishaih@nvidia.com>
References: <20210825135139.79034-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ef15838-64cf-484a-bc5a-08d967cfaee2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3881:
X-Microsoft-Antispam-PRVS: <DM6PR12MB38817DA8E1493B858E95A2E9C3C69@DM6PR12MB3881.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnStzsk0SaLhP1qLGipe+4hHtVTqtvFsfdDZeU/FvTHMuwmPA2+tu8WqgM1ii2i/UdFNt3f29q5sTIcPwWYr2960ogEy1rOQOKsjtURlEXrhXy1jcmD69UzxPYKgh5/2fQbqoAXwQjC/qWHfkowPTYo3rt9pRG97h2WQa2vmj/I+dvLyHt7URG4/GnIfVZR9wmyVvtqGz1mYeToS2/6mBPFe1DPLNsS79yw/Knt9wWLt6/3xE+Sm59XrgTaf7kS0/V02ooy98U04rqYw1epOJOKJTtrmxUjaPTPKU/UdBMNPf4NiODNkVhZH8MvSgW/c+HLrUoxp7/4UfdqbBfrmF+zQRe8EweIwhuVCQbSkpmvGJoRSJlQYrsFPnOnl6pXZDrkRazyYbET1wcA4NtxEhlgfjPPd/xqNzlWs2rfoenpgUZ+Qzt+J7nRa0FQKOQwlemRAeMT4XzOBOcnigu8Oo2zTaAjzWs4+kjcmCYSiZkaZdScFc6TrnTSMJMC7bkulry/YXNLqebYqoOaK+fHxGo5+XzmmeK6LgxEVj9vojoLYAiqqUFD4ZWBkbShX7+3s7n3XxyXbkx0vKsa2cM43AdmjxigdrjAi3PXnMxxTgmreuL+6TCcgBqgT/+/kvCQ/xFi8j6tOSUbj+LIEhcauwJu3h35awNokwaGM9x+Z0XTC/4rFZgeq6K1Xc7nmliAmVJK8wmVFXRg19p65pZaXFiWHcFYgbbGBWvxxEOSmfa4=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36906005)(316002)(54906003)(2616005)(2906002)(110136005)(70206006)(7416002)(6666004)(8676002)(26005)(356005)(8936002)(82310400003)(426003)(1076003)(107886003)(508600001)(86362001)(83380400001)(70586007)(47076005)(336012)(36860700001)(7696005)(4326008)(186003)(7636003)(36756003)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 13:53:13.8492
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ef15838-64cf-484a-bc5a-08d967cfaee2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3881
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

igd is related to the vfio_pci pci_driver implementation, move it out of
vfio_pci_core.c.

This is preparation for splitting vfio_pci.ko into 2 drivers.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 29 +++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c | 39 ++++----------------------------
 drivers/vfio/pci/vfio_pci_core.h |  9 +++++++-
 3 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 4e31bd3001ad..2729b777a56d 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -82,9 +82,36 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
 	return true;
 }
 
+static int vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (vfio_pci_is_vga(pdev) &&
+	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+		ret = vfio_pci_igd_init(vdev);
+		if (ret && ret != -ENODEV) {
+			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
+			vfio_pci_core_disable(vdev);
+			return ret;
+		}
+	}
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
+}
+
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
-	.open_device	= vfio_pci_core_open_device,
+	.open_device	= vfio_pci_open_device,
 	.close_device	= vfio_pci_core_close_device,
 	.ioctl		= vfio_pci_core_ioctl,
 	.read		= vfio_pci_core_read,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index c0d71f72d4f1..3b3bf7445367 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -91,11 +91,6 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 	return decodes;
 }
 
-static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
-{
-	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-}
-
 static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 {
 	struct resource *res;
@@ -166,7 +161,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 struct vfio_pci_group_info;
 static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -252,7 +246,7 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -321,26 +315,11 @@ static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-	if (vfio_pci_is_vga(pdev) &&
-	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
-		ret = vfio_pci_igd_init(vdev);
-		if (ret && ret != -ENODEV) {
-			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-			goto disable_exit;
-		}
-	}
-
-	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
-
-disable_exit:
-	vfio_pci_disable(vdev);
-	return ret;
 }
 
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
@@ -479,7 +458,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 
 	vfio_pci_vf_token_user_add(vdev, -1);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
-	vfio_pci_disable(vdev);
+	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
 	if (vdev->err_trigger) {
@@ -493,19 +472,11 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-int vfio_pci_core_open_device(struct vfio_device *core_vdev)
+void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(core_vdev, struct vfio_pci_core_device, vdev);
-	int ret = 0;
-
-	ret = vfio_pci_enable(vdev);
-	if (ret)
-		return ret;
-
+	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
-	return 0;
 }
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 7dbdd4dda5c0..ffaf544f35db 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -210,7 +210,6 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 void vfio_pci_core_cleanup(void);
 int vfio_pci_core_init(void);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
-int vfio_pci_core_open_device(struct vfio_device *core_vdev);
 void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 			       struct pci_dev *pdev,
 			       const struct vfio_device_ops *vfio_pci_ops);
@@ -228,5 +227,13 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+
+static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
+{
+	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
+}
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.18.1

