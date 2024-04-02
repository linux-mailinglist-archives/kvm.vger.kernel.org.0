Return-Path: <kvm+bounces-13325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F73894A03
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:31:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C75E81C22EDA
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CCD1754B;
	Tue,  2 Apr 2024 03:31:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D3315E96;
	Tue,  2 Apr 2024 03:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712028686; cv=none; b=DJjoCCDBx5Txfh8RyQTNGesurp/palOlud5ruO4ciekCC4Kyxrxwtr79sQ+ss14zBniJdz71E6KA5AK1/KMdBeKpkmKqFD68Xe+IJ/cCdDlrZ40UqqRb9DXEmUy1NiG7+d9su0199cUoCdrkPyq9PLVZ0vqE95sVTYXPXsBQsMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712028686; c=relaxed/simple;
	bh=KcYFY0/J5LOE7gAjhMCVRdrkwkV0VBKNTOFoF6PhQ9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FZMP+ZPI7IecU948cRqM4cSyDkeuvvr/NeyGT2mauomicckHt7b0XBgVUJJsB8wqNp+xpswR/mXFPWSU7IUPICaAvdliY9JPj0BuKmjbRtnaVVTHHNc9HmyZFoX9vrkBDQcek6+qWj2b7Gx0OcK7qFFqeIfcMC80fhxvBug5cTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4V7tdK4xZ5z1h5BL;
	Tue,  2 Apr 2024 11:28:37 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 131DC1A0172;
	Tue,  2 Apr 2024 11:31:22 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 2 Apr
 2024 11:31:21 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 4/4] Documentation: add debugfs description for hisi migration
Date: Tue, 2 Apr 2024 11:24:32 +0800
Message-ID: <20240402032432.41004-5-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240402032432.41004-1-liulongfang@huawei.com>
References: <20240402032432.41004-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

Add a debugfs document description file to help users understand
how to use the hisilicon accelerator live migration driver's
debugfs.

Update the file paths that need to be maintained in MAINTAINERS

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../ABI/testing/debugfs-hisi-migration        | 34 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 35 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
new file mode 100644
index 000000000000..3d7339276e6f
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-migration
@@ -0,0 +1,34 @@
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/data
+Date:		Apr 2024
+KernelVersion:  6.9
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the live migration data of the vfio device.
+		These data include device status data, queue configuration
+		data and some task configuration data.
+		The output format of the data is defined by the live
+		migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/attr
+Date:		Apr 2024
+KernelVersion:  6.9
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the live migration attributes of the vfio device.
+		it include device status attributes and data length attributes
+		The output format of the attributes is defined by the live
+		migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
+Date:		Apr 2024
+KernelVersion:  6.9
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Used to obtain the device command sending and receiving
+		channel status. If successful, returns the command value.
+		If failed, return error log.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/save
+Date:		Apr 2024
+KernelVersion:  6.9
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Trigger the Hisilicon accelerator device to perform
+		the state saving operation of live migration through the read
+		operation, and output the operation log results.
diff --git a/MAINTAINERS b/MAINTAINERS
index 7625911ec2f1..8c2d13b13273 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -23072,6 +23072,7 @@ M:	Longfang Liu <liulongfang@huawei.com>
 M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/debugfs-hisi-migration
 F:	drivers/vfio/pci/hisilicon/
 
 VFIO MEDIATED DEVICE DRIVERS
-- 
2.24.0


