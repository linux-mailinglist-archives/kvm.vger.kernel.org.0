Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E9678F738
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 04:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348156AbjIACjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 22:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbjIACjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 22:39:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B32E72;
        Thu, 31 Aug 2023 19:39:40 -0700 (PDT)
Received: from kwepemm600005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RcMb44KZpztSJh;
        Fri,  1 Sep 2023 10:35:44 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 1 Sep
 2023 10:39:37 +0800
From:   liulongfang <liulongfang@huawei.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>
CC:     <bcreeley@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <liulongfang@huawei.com>
Subject: [PATCH v15 2/2] Documentation: add debugfs description for vfio
Date:   Fri, 1 Sep 2023 10:36:06 +0800
Message-ID: <20230901023606.47587-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20230901023606.47587-1-liulongfang@huawei.com>
References: <20230901023606.47587-1-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.50.163.32]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600005.china.huawei.com (7.193.23.191)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

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
index 000000000000..086a8c52df35
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-vfio
@@ -0,0 +1,25 @@
+What:		/sys/kernel/debug/vfio
+Date:		Aug 2023
+KernelVersion:  6.6
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	This debugfs file directory is used for debugging
+		of vfio devices, it's a common directory for all vfio devices.
+		Each device should create a device subdirectory under this
+		directory by referencing the public registration interface.
+
+What:		/sys/kernel/debug/vfio/<device>/migration
+Date:		Aug 2023
+KernelVersion:  6.6
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	This debugfs file directory is used for debugging
+		of vfio devices that support live migration.
+		The debugfs of each vfio device that supports live migration
+		could be created under this directory.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/state
+Date:		Aug 2023
+KernelVersion:  6.6
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the live migration status of the vfio device.
+		The status of these live migrations includes:
+		ERROR, RUNNING, STOP, STOP_COPY, RESUMING.
diff --git a/MAINTAINERS b/MAINTAINERS
index 7b1306615fc0..bd01ca674c60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22304,6 +22304,7 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 T:	git https://github.com/awilliam/linux-vfio.git
 F:	Documentation/ABI/testing/sysfs-devices-vfio-dev
+F:	Documentation/ABI/testing/debugfs-vfio
 F:	Documentation/driver-api/vfio.rst
 F:	drivers/vfio/
 F:	include/linux/vfio.h
-- 
2.24.0

