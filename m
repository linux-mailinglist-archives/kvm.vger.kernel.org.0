Return-Path: <kvm+bounces-23356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C53FB948F19
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:38:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81A522846FB
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131501C462A;
	Tue,  6 Aug 2024 12:37:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968D81BD507;
	Tue,  6 Aug 2024 12:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722947865; cv=none; b=e7zroD9WJVOPgG7PKicgKrMJlJtz7EMrWCH6UeNpXa0HpIZZam3cA+OuG+Yzk2wkdA9SiLUjcwL6W6o8R4A7GVoVC8usPTqXo2uvT9HfUxePHHerynLzhhzHiLbnX3zfv9kYTH+N8sMeyC23yQm2d8ZqrQMvuGlGrMLJxH/ymtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722947865; c=relaxed/simple;
	bh=f55jc9z6uEIp7Y9jmlkWELf5oT9//u8l2fy9Tf+LnrE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EXM3QimQfdv71TMzpnYJoUzQXar095LnNoXx8f4B9em+65PIgo73dfs4QxOpouAYmet9d1p2sDPINDt61RKUmZvoAmeaBLaC2fLozusjxK0eIlWeiEz91Mjx9ZySkeE94FLbmqut9I0UFHZ53vhyD8VfSyP5O6hHjxlH8/ZedLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WdXqP0fcTzpSv2;
	Tue,  6 Aug 2024 20:36:33 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id C29F114011B;
	Tue,  6 Aug 2024 20:37:41 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 6 Aug
 2024 20:37:41 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v8 4/4] Documentation: add debugfs description for hisi migration
Date: Tue, 6 Aug 2024 20:29:28 +0800
Message-ID: <20240806122928.46187-5-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240806122928.46187-1-liulongfang@huawei.com>
References: <20240806122928.46187-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
index 000000000000..ad6eb437cdcd
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-migration
@@ -0,0 +1,25 @@
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
+Date:		Aug 2024
+KernelVersion:  6.11
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the configuration data and some status data
+		required for device live migration. These data include device
+		status data, queue configuration data, some task configuration
+		data and device attribute data. The output format of the data
+		is defined by the live migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
+Date:		Aug 2024
+KernelVersion:  6.11
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the data from the last completed live migration.
+		This data includes the same device status data as in "dev_data".
+		The migf_data is the dev_data that is migrated.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
+Date:		Aug 2024
+KernelVersion:  6.11
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Used to obtain the device command sending and receiving
+		channel status. Returns failure or success logs based on the
+		results.
-- 
2.24.0


