Return-Path: <kvm+bounces-30607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A67AD9BC422
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:55:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E795B220B7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC4618E030;
	Tue,  5 Nov 2024 03:55:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B17187347;
	Tue,  5 Nov 2024 03:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778934; cv=none; b=hgOkqHnLEgk2lEiD76TH83gIfxmqMyoP8xvPITG0C9DTsinELqFMaU1W+4QEEdOgml19gzegTJBbaOT66REytvYzn3KhfwWBvalcKIr6Tt+u7L8VmxVlaJ6kCdfM/QzMPR35aiVNDD4eFZtvlLK9ADvOgKQcRapmeOB76870QTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778934; c=relaxed/simple;
	bh=/p+aqP93T3K4PYoazZPh+X0mdSLojNh6PgukGvcdpIs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Izt5rH5wsdgZ5HlwaJ7iDnxjm6lSyLO/yNfV+tPNIX8gfJcprzFUZbscUw/mRKCAuAQCNAteZx54sjwz+yGyZxXFlDMSkzDn/xoJIzqds5LfKmvsKgVa20AyAGsHOtdrOm24yFA8zCSGrV1TeOz+2SHXOajjZ6BOyAhD1mVQHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XjDw84Wn7zyVK6;
	Tue,  5 Nov 2024 11:53:44 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id EB0E114022D;
	Tue,  5 Nov 2024 11:55:29 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 11:55:29 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Nov
 2024 11:55:29 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v12 4/4] Documentation: add debugfs description for hisi migration
Date: Tue, 5 Nov 2024 11:52:54 +0800
Message-ID: <20241105035254.24636-5-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241105035254.24636-1-liulongfang@huawei.com>
References: <20241105035254.24636-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemn100017.china.huawei.com (7.202.194.122)

Add a debugfs document description file to help users understand
how to use the hisilicon accelerator live migration driver's
debugfs.

Update the file paths that need to be maintained in MAINTAINERS

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../ABI/testing/debugfs-hisi-migration        | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

diff --git a/Documentation/ABI/testing/debugfs-hisi-migration b/Documentation/ABI/testing/debugfs-hisi-migration
new file mode 100644
index 000000000000..2c01b2d387dd
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-migration
@@ -0,0 +1,25 @@
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
+Date:		Jan 2025
+KernelVersion:  6.13
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the configuration data and some status data
+		required for device live migration. These data include device
+		status data, queue configuration data, some task configuration
+		data and device attribute data. The output format of the data
+		is defined by the live migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
+Date:		Jan 2025
+KernelVersion:  6.13
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the data from the last completed live migration.
+		This data includes the same device status data as in "dev_data".
+		The migf_data is the dev_data that is migrated.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
+Date:		Jan 2025
+KernelVersion:  6.13
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Used to obtain the device command sending and receiving
+		channel status. Returns failure or success logs based on the
+		results.
-- 
2.24.0


