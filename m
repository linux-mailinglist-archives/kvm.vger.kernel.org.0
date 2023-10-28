Return-Path: <kvm+bounces-9-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AE47DA599
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 09:58:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC0FA28275C
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 07:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0969179E0;
	Sat, 28 Oct 2023 07:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAD4611B
	for <kvm@vger.kernel.org>; Sat, 28 Oct 2023 07:57:53 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205CDF2;
	Sat, 28 Oct 2023 00:57:51 -0700 (PDT)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SHWxS2vJ7zMlDw;
	Sat, 28 Oct 2023 15:53:32 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemm000005.china.huawei.com
 (7.193.23.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 28 Oct
 2023 15:57:48 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <bcreeley@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v18 0/2] add debugfs to migration driver
Date: Sat, 28 Oct 2023 15:54:45 +0800
Message-ID: <20231028075447.41939-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.163.32]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected

Add a debugfs function to the migration driver in VFIO to provide
a step-by-step debugfs information for the migration driver.

Changes v17 -> v18
	Replace seq_printf() with seq_puts().

Changes v16 -> v17
	Add separate VFIO_DEBUGFS Kconfig entries.

Changes v15 -> v16
	Update the calling order of functions to maintain symmetry

Changes v14 -> v15
	Update the output status value of live migration.

Changes v13 -> v14
	Split the patchset and keep the vfio debugfs frame.

Changes v12 -> v13
	Solve the problem of open and close competition to debugfs.

Changes v11 -> v12
	Update loading conditions of vfio debugfs.

Changes v10 -> v11
	Delete the device restore function in debugfs.

Changes v9 -> v10
	Update the debugfs file of the live migration driver.

Changes v8 -> v9
	Update the debugfs directory structure of vfio.

Changes v7 -> v8
	Add support for platform devices.

Changes v6 -> v7
	Fix some code style issues.

Changes v5 -> v6
	Control the creation of debugfs through the CONFIG_DEBUG_FS.

Changes v4 -> v5
	Remove the newly added vfio_migration_ops and use seq_printf
	to optimize the implementation of debugfs.

Changes v3 -> v4
	Change the migration_debug_operate interface to debug_root file.

Changes v2 -> v3
	Extend the debugfs function from hisilicon device to vfio.

Changes v1 -> v2
	Change the registration method of root_debugfs to register
	with module initialization. 

Longfang Liu (2):
  vfio/migration: Add debugfs to live migration driver
  Documentation: add debugfs description for vfio

 Documentation/ABI/testing/debugfs-vfio | 25 +++++++
 MAINTAINERS                            |  1 +
 drivers/vfio/Kconfig                   | 10 +++
 drivers/vfio/Makefile                  |  1 +
 drivers/vfio/debugfs.c                 | 90 ++++++++++++++++++++++++++
 drivers/vfio/vfio.h                    | 14 ++++
 drivers/vfio/vfio_main.c               |  4 ++
 include/linux/vfio.h                   |  7 ++
 include/uapi/linux/vfio.h              |  1 +
 9 files changed, 153 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-vfio
 create mode 100644 drivers/vfio/debugfs.c

-- 
2.24.0


