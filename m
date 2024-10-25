Return-Path: <kvm+bounces-29702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D10D9AFDA0
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 11:06:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2591EB230F9
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 09:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32A031D54E2;
	Fri, 25 Oct 2024 09:04:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C96E1D222F;
	Fri, 25 Oct 2024 09:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729847057; cv=none; b=MCaqkYcLBk+ocxEn9CcGewN+PmdIcx4F2Z8DE3Kc0TtZaa70Q2hlTRPRIzxBcDrdF8DloJvkz9fpdCGvuu4p6WZMj4iT1wiLN8nhVh4DHltqwszhysjRToCP81XDJgrEL+3wkm3MvmpohXxxfgtM/peRsNiDySTGL2DyXQoucR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729847057; c=relaxed/simple;
	bh=UyohMo7jcmqSJ543BpeQ58/1w+KHTlZr9IKhyVxdzdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYhMC1wGSmKnHUX/FVoVHTcRW1VIUIBwhHMsocsxf3xWVsZ9mCuKKQNfZVLBoT0G3JCdmHP3Yw4ItEApG/wAQ2i0ItzrtHxdwV57gWfksuYcjJ0RLi7yAtgG0Q3lsOMbQ4oSkhQe6xvuTp/rJr9XV8fs0x7Lzx7W28M8NMYGefw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XZcHd69wjzyT16;
	Fri, 25 Oct 2024 17:02:37 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 722AE18006C;
	Fri, 25 Oct 2024 17:04:11 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 25 Oct
 2024 17:04:10 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v11 4/4] Documentation: add debugfs description for hisi migration
Date: Fri, 25 Oct 2024 17:01:43 +0800
Message-ID: <20241025090143.64472-5-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241025090143.64472-1-liulongfang@huawei.com>
References: <20241025090143.64472-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600005.china.huawei.com (7.193.23.191)

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
index 000000000000..89e4fde5ec6a
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-hisi-migration
@@ -0,0 +1,25 @@
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/dev_data
+Date:		Oct 2024
+KernelVersion:  6.12
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the configuration data and some status data
+		required for device live migration. These data include device
+		status data, queue configuration data, some task configuration
+		data and device attribute data. The output format of the data
+		is defined by the live migration driver.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/migf_data
+Date:		Oct 2024
+KernelVersion:  6.12
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Read the data from the last completed live migration.
+		This data includes the same device status data as in "dev_data".
+		The migf_data is the dev_data that is migrated.
+
+What:		/sys/kernel/debug/vfio/<device>/migration/hisi_acc/cmd_state
+Date:		Oct 2024
+KernelVersion:  6.12
+Contact:	Longfang Liu <liulongfang@huawei.com>
+Description:	Used to obtain the device command sending and receiving
+		channel status. Returns failure or success logs based on the
+		results.
-- 
2.24.0


