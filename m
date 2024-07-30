Return-Path: <kvm+bounces-22665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 793BC9411B4
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 14:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 305D51F23DE9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 12:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D84FB19EEA2;
	Tue, 30 Jul 2024 12:20:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCE51957F0;
	Tue, 30 Jul 2024 12:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722342053; cv=none; b=bVRJUVw64eVCUGcfEKMRsAiB9vKD13QCd5mKM65LvS99GrBI2kBKAMqSoNMjSsk6la/bHOQ+BfTkPUx9AM/4xzoE9f9YgLQAQ3mLu+VwApEpYbD48Qr7sX66YCWoSY+0cflVRuqqiMBiM4GswDogTBpcTR17mNnyEgKixHVQtd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722342053; c=relaxed/simple;
	bh=MFpgjuZt+KC9o1pgyJcjr4gTDU/RS6sOdeTZNHd97WE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HoUdLNhiogtu+lScaNCj6t6YDLDl8TRjipo51nYU0UIINLpLxx2j0IHX0eKsBD76XOXu27DKU8deLhnLXSlR8KYxp+UGQht9nZsxUU13759siY2krAeE/RGx82hR84K+lRmeoi3YyQMGmU7EXFeEWMSP9XG5bOmlKwMVMlMxCBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WYDj6575tz1S6qF;
	Tue, 30 Jul 2024 20:16:10 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id C719E14037E;
	Tue, 30 Jul 2024 20:20:43 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 30 Jul
 2024 20:20:43 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v7 0/4] debugfs to hisilicon migration driver
Date: Tue, 30 Jul 2024 20:14:34 +0800
Message-ID: <20240730121438.58455-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600005.china.huawei.com (7.193.23.191)

Add a debugfs function to the hisilicon migration driver in VFIO to
provide intermediate state values and data during device migration.

When the execution of live migration fails, the user can view the
status and data during the migration process separately from the
source and the destination, which is convenient for users to analyze
and locate problems.

Changes v6 -> v7
	Remove redundant kernel error log printing and
	remove unrelated bugfix code

Changes v5 -> v6
	Modify log output calling error

Changes v4 -> v5
	Adjust the descriptioniptionbugfs file directory

Changes v3 -> v4
	Rebased on kernel6.9

Changes 2 -> v3
	Solve debugfs serialization problem.

Changes v1 -> v2
	Solve the racy problem of io_base.


Longfang Liu (4):
  hisi_acc_vfio_pci: extract public functions for container_of
  hisi_acc_vfio_pci: create subfunction for data reading
  hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
  Documentation: add debugfs description for hisi migration

 .../ABI/testing/debugfs-hisi-migration        |  25 ++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 295 ++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   6 +
 3 files changed, 295 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

-- 
2.24.0


