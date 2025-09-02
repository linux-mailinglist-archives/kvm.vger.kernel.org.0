Return-Path: <kvm+bounces-56527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20B46B3F240
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 04:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CDD23A57B1
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 02:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47DBC35948;
	Tue,  2 Sep 2025 02:25:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E071526E703;
	Tue,  2 Sep 2025 02:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756779911; cv=none; b=EQQzlKSPDlRELbubK1/49UbFIQgDhB8YBvg0zA2C4pQVnU+r36rXTWkK5GibEb5Ukao1Mn/1Ea8acK04KWXnnBVpegwVqzeCLp3M1QUff2pGovyfrgbkcVsGv8o2kf3Hh3RsqFswDUnjBV1eo5FXiytypCXksv25+fxcncKjbOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756779911; c=relaxed/simple;
	bh=h76a6riqzOeWCE+ZYBVdsPezrRbCFF88JDHA5tQP/gE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CVibsCrzDf1CrwdEc+nQCVCr2nqbdzcZosW3kq+UZl00Q6g4ulQw+hZIE+x3YIMzu+VZbxFk1Uf3NjsN5pMOye/q9Gg2OiMynTEEqSaMH/0h22RjZeVDlh8FJ/bNpj+u4p6F6Ao/DTfA9pvM66b6HafBuzSm9vhoeOh9gDty26c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cG8gt4zJpztTN6;
	Tue,  2 Sep 2025 10:24:10 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 39B02180495;
	Tue,  2 Sep 2025 10:25:07 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 2 Sep
 2025 10:25:06 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerkolothum@gmail.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v9 0/2] update live migration configuration region
Date: Tue, 2 Sep 2025 10:25:03 +0800
Message-ID: <20250902022505.2034408-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On the new hardware platform, the configuration register space
of the live migration function is set on the PF, while on the
old platform, this part is placed on the VF.

Change v8 -> v9
	Update the version name for driver matching

Change v7 -> v8
	Resolve hardware compatibility issues.

Change v6 -> v7
	Update the comment of the live migration configuration scheme.

Change v5 -> v6
	Update VF device properties

Change v4 -> v5
	Remove BAR length alignment

Change v3 -> v4
	Rebase on kernel 6.15

Change v2 -> v3
	Put the changes of Pre_Copy into another bugfix patchset.

Change v1 -> v2
	Delete the vf_qm_state read operation in Pre_Copy 

Longfang Liu (2):
  crypto: hisilicon - qm updates BAR configuration
  hisi_acc_vfio_pci: adapt to new migration configuration

 drivers/crypto/hisilicon/qm.c                 |  27 +++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  13 ++
 include/linux/hisi_acc_qm.h                   |   3 +
 4 files changed, 187 insertions(+), 61 deletions(-)

-- 
2.33.0


