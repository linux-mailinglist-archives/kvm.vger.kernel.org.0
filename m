Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DBE7C815A
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 11:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjJMJHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 05:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjJMJHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 05:07:38 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2412795;
        Fri, 13 Oct 2023 02:07:34 -0700 (PDT)
Received: from kwepemm000005.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4S6LC80xHzz1kv9N;
        Fri, 13 Oct 2023 17:03:32 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemm000005.china.huawei.com
 (7.193.23.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Fri, 13 Oct
 2023 17:07:31 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>,
        <jonathan.cameron@huawei.com>
CC:     <bcreeley@amd.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        <liulongfang@huawei.com>
Subject: [PATCH v17 0/2] add debugfs to migration driver
Date:   Fri, 13 Oct 2023 17:04:39 +0800
Message-ID: <20231013090441.36417-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.50.163.32]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm000005.china.huawei.com (7.193.23.27)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a debugfs function to the migration driver in VFIO to provide
a step-by-step debugfs information for the migration driver.

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
 drivers/vfio/vfio_main.c               | 14 +++-
 include/linux/vfio.h                   |  7 ++
 include/uapi/linux/vfio.h              |  1 +
 9 files changed, 161 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-vfio
 create mode 100644 drivers/vfio/debugfs.c

-- 
2.24.0

