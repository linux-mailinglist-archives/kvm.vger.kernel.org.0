Return-Path: <kvm+bounces-11-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BC7E7DA5A0
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 09:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA80AB215DF
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 07:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4C88F63;
	Sat, 28 Oct 2023 07:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C96F8F48
	for <kvm@vger.kernel.org>; Sat, 28 Oct 2023 07:58:54 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD384F2;
	Sat, 28 Oct 2023 00:58:52 -0700 (PDT)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.54])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SHX0B567Jz1L9L1;
	Sat, 28 Oct 2023 15:55:54 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemm000005.china.huawei.com
 (7.193.23.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 28 Oct
 2023 15:58:50 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <bcreeley@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v18 2/2] Documentation: add debugfs description for vfio
Date: Sat, 28 Oct 2023 15:54:47 +0800
Message-ID: <20231028075447.41939-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20231028075447.41939-1-liulongfang@huawei.com>
References: <20231028075447.41939-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.163.32]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected

1.Add an debugfs document description file to help users understand
how to use the accelerator live migration driver's debugfs.
2.Update the file paths that need to be maintained in MAINTAINERS

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 Documentation/ABI/testing/debugfs-vfio | 25 +++++++++++++++++++++++++
 MAINTAINERS                            |  1 +
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-vfio

diff --git a/Documentation/ABI/testing/debugfs-vfio b/Documentation/ABI/testing/debugfs-vfio
new file mode 100644
index 000000000000..445e9f58f924
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-vfio
@@ -0,0 +1,25 @@
+What:		/sys/kernel/debug/vfio
+Date:		Oct 2023
+KernelVersion:  6.7
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	This debugfs file directory is used for debugging
+		of vfio devices, it's a common directory for all vfio devices.
+		Vfio core will create a device subdirectory under this
+		directory.
+
+What:		/sys/kernel/debug/vfio/<device>/migration
+Date:		Oct 2023
+KernelVersion:  6.7
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	This debugfs file directory is used for debugging
+		of vfio devices that support live migration.
+		The debugfs of each vfio device that supports live migration
+		could be created under this directory.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/state
+Date:		Oct 2023
+KernelVersion:  6.7
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the live migration status of the vfio device.
+		The contents of the state file reflects the migration state
+		relative to those defined in the vfio_device_mig_state enum
diff --git a/MAINTAINERS b/MAINTAINERS
index b19995690904..a6be3b4219c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22591,6 +22591,7 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git https://github.com/awilliam/linux-vfio.git
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
+F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
 F:	include/linux/vfio.h
-- 
2.24.0


