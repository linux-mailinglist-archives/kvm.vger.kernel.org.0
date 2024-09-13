Return-Path: <kvm+bounces-26797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F4F977CDD
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 12:05:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F9661C2192E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 10:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F2F1D7E58;
	Fri, 13 Sep 2024 10:03:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22921BD4FF;
	Fri, 13 Sep 2024 10:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726221825; cv=none; b=MCvs3hRvpchlhMq7+A4wx+iPNQog7UJJK7Bv5UC9rsS3vjDloXLgGGhRiS+YBIP18qh0zFnIzaJQMNfF0aDeKcY060j0GOT2wcyx42XXbUJRLzqlIodGQ2KkYHMZTWcK3HyBjTpbMSWHuLs1Ds3/4ZXjM7pbzPHPDPU3Wm/8+I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726221825; c=relaxed/simple;
	bh=1Xhjv69bqo35M5MzL4O/HoEhLKUfqoSuwt7dVNbrRbQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrdN5MODhgCM5R8lJUX1TZxbRthJsyXhcomkNeMigd/nQ+sIzmtOMPEKh6kUI4LajsxKnCjLvqYr0U1RQjs7BzypmaGnauIPHbphL/ZAhnrUyOkSotPEeIY2UsjhDuuPgRxOz5mMRoyZ3SRaOfTFLEnpeyAz5RCxDB973StlseU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4X4qYJ1TMRz1HJ2p;
	Fri, 13 Sep 2024 18:00:04 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 7FFBA140134;
	Fri, 13 Sep 2024 18:03:41 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 13 Sep
 2024 18:03:40 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v9 4/4] Documentation: add debugfs description for hisi migration
Date: Fri, 13 Sep 2024 17:55:02 +0800
Message-ID: <20240913095502.22940-5-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240913095502.22940-1-liulongfang@huawei.com>
References: <20240913095502.22940-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600005.china.huawei.com (7.193.23.191)

Add a debugfs document description file to help users understand
how to use the hisilicon accelerator live migration driver's
debugfs.

Update the file paths that need to be maintained in MAINTAINERS

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../ABI/testing/debugfs-hisi-migration        | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
new file mode 100644
index 000000000000..f625b3ca230e
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-migration
@@ -0,0 +1,25 @@
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
+Date:		Sep 2024
+KernelVersion:  6.11
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the configuration data and some status data
+		required for device live migration. These data include device
+		status data, queue configuration data, some task configuration
+		data and device attribute data. The output format of the data
+		is defined by the live migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
+Date:		Sep 2024
+KernelVersion:  6.11
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the data from the last completed live migration.
+		This data includes the same device status data as in "dev_data".
+		The migf_data is the dev_data that is migrated.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
+Date:		Sep 2024
+KernelVersion:  6.11
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Used to obtain the device command sending and receiving
+		channel status. Returns failure or success logs based on the
+		results.
-- 
2.24.0


