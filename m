Return-Path: <kvm+bounces-34126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 102C89F782D
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:19:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CDEC18903AF
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FAE221467;
	Thu, 19 Dec 2024 09:19:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2420433C0;
	Thu, 19 Dec 2024 09:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734599950; cv=none; b=LzPQnZJpVm5UNSm6ZJ9kyBbadVEyrI+1QZ6LK+0YGv/R5yFBLh/EUf5Hzg9AiN7YIWAmORxYm+UzNPnLJleeVMcfL2vYPbjp/nZvGIOcv9Qt1EtdP1oAi0xqyIuLitswF0S8F/pT/S+qSr1LWFpSpKu6U2lzUyXyShbkk2tAiZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734599950; c=relaxed/simple;
	bh=yTpGCSU7kiiUg8HFYnZGpCy/vyEkIhSmYv0sTIBVJM0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hzG0SyhDrev3HKsyr/JHVJVbsYoX/d/NVy/V+l2v5NV7tT4HVMEt4Eu4gFXYLiLPSh8yT2bQNTtnQrWvB5lBsW44kHF76yfE/D+UpiV5FuAq2DNYs6UsgGtv4aW3ggKFy9a7mcnlcWw28yM7dbwgcpMbC8Mf8wmU03x0xTNUeI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YDQ0G6JFCzhZPD;
	Thu, 19 Dec 2024 17:16:30 +0800 (CST)
Received: from dggemv703-chm.china.huawei.com (unknown [10.3.19.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B21B14010D;
	Thu, 19 Dec 2024 17:19:04 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 17:19:03 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Dec
 2024 17:19:03 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v2 0/5] bugfix some driver issues
Date: Thu, 19 Dec 2024 17:17:55 +0800
Message-ID: <20241219091800.41462-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
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

As the test scenarios for the live migration function become
more and more extensive. Some previously undiscovered driver
issues were found.
Update and fix through this patchset.

Longfang Liu (5):
  hisi_acc_vfio_pci: fix XQE dma address error
  hisi_acc_vfio_pci: add eq and aeq interruption restore
  hisi_acc_vfio_pci: bugfix cache write-back issue
  hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
  hisi_acc_vfio_pci: bugfix live migration function without VF device
    driver

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 83 ++++++++++++++++---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 +-
 2 files changed, 78 insertions(+), 14 deletions(-)

-- 
2.24.0


