Return-Path: <kvm+bounces-7950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5AC6848C56
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 10:02:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B7161F2217E
	for <lists+kvm@lfdr.de>; Sun,  4 Feb 2024 09:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166B616428;
	Sun,  4 Feb 2024 09:02:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BDB14A94;
	Sun,  4 Feb 2024 09:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707037322; cv=none; b=sp5MppVlqy96/xQe5/HXg+gLMhAqLLhS3oJQw+PivX38iXE31X5WKpns+cnY/HXTbcVYsl8KXXpIRm+5JsAghiD5+EdmdVE2gIzWRdW8nxJnjV3tolSA8EtecE4wdz4C51EEMQAEoSauBrC3O3wUvtBnpPYZbxIOOzTyrgeRL1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707037322; c=relaxed/simple;
	bh=7i/3l2q/ER2Vx7o8iiC5bIHWO1gqyt9jkv3nWOLEEVE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oOtuHgFL+U6JDCQ3sUzOBD+tXFtsYEPMIBYC0kaHejvN7Sp7NpwdqPLSTgIw2oGtDnYwrfJaSc/dri8+nohEjB2pMnxktsRDGkHsNDN8Y1R7K/WW6apbNC+YK/0rHTpslYQoIjcG2GJFFrDTxcv1S5GUunY6nh8l5kxfYwBa+zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4TSNlL0pDvzNljy;
	Sun,  4 Feb 2024 17:00:46 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id B8A54140258;
	Sun,  4 Feb 2024 17:01:50 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 4 Feb
 2024 17:01:50 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v2 3/3] Documentation: add debugfs description for hisi migration
Date: Sun, 4 Feb 2024 16:56:10 +0800
Message-ID: <20240204085610.17720-4-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240204085610.17720-1-liulongfang@huawei.com>
References: <20240204085610.17720-1-liulongfang@huawei.com>
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
index 000000000000..d61255c3bcd9
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-migration
@@ -0,0 +1,34 @@
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/data
+Date:		Feb 2024
+KernelVersion:  6.8
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the live migration data of the vfio device.
+		These data include device status data, queue configuration
+		data and some task configuration data.
+		The output format of the data is defined by the live
+		migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/attr
+Date:		Feb 2024
+KernelVersion:  6.8
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the live migration attributes of the vfio device.
+		it include device status attributes and data length attributes
+		The output format of the attributes is defined by the live
+		migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
+Date:		Feb 2024
+KernelVersion:  6.8
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Used to obtain the device command sending and receiving
+		channel status. If successful, returns the command value.
+		If failed, return error log.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/save
+Date:		Feb 2024
+KernelVersion:  6.8
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Trigger the Hisilicon accelerator device to perform
+		the state saving operation of live migration through the read
+		operation, and output the operation log results.
diff --git a/MAINTAINERS b/MAINTAINERS
index 20f8e9872deb..115d43d307e8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22856,6 +22856,7 @@ M:	Longfang Liu <liulongfang@huawei.com>
 M:	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
 L:	kvm@vger.kernel.org
 S:	Maintained
+F:	Documentation/ABI/testing/debugfs-hisi-migration
 F:	drivers/vfio/pci/hisilicon/
 
 VFIO MEDIATED DEVICE DRIVERS
-- 
2.24.0


