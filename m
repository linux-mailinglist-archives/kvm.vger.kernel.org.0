Return-Path: <kvm+bounces-43128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58619A85247
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 05:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57ACF7AF726
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 03:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C96027CB2E;
	Fri, 11 Apr 2025 03:59:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E0B279338;
	Fri, 11 Apr 2025 03:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744343948; cv=none; b=RfGthRt8V0AgQ2yQ/4xkuzrKUFspdUMeONN9wub3yvtUvHTNCA9GiZJrQ3X2dRTQL839svwBscInDHpSjL9KJTZugaSWvHlDeH4sC9izfEr1/hXoBEtDD0NXWWyO6Mvsmj1zWq0uL1S8aN1vQOyMWZw44IQnea/Qy0S4pxvS1Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744343948; c=relaxed/simple;
	bh=K7XvdCgCL9CZRAK0hFIrOe6kSxfio5VxRYSIPVy2s0Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UacUBsjmEWzwKn0vsSZHYXPYifcAWhOLKXDw9mP3SSHb34t1IcZCE32GxXNdhFk/ALQyTYwtwdZLN6mlI4Ov8x6Bh9OlCBygA6AnKT8Cu4dVxQD211llZgPgGuueY7ekSXCTDFC9P2N5xejhP2LXNHEJ44kyhBWsElHhhn6WBsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZYjW63Q0NzvWyS;
	Fri, 11 Apr 2025 11:54:58 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 3A785180B44;
	Fri, 11 Apr 2025 11:59:02 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 11 Apr
 2025 11:59:01 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v7 0/6] bugfix some driver issues
Date: Fri, 11 Apr 2025 11:59:01 +0800
Message-ID: <20250411035907.57488-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500006.china.huawei.com (7.202.181.43)

As the test scenarios for the live migration function become
more and more extensive. Some previously undiscovered driver
issues were found.
Update and fix through this patchset.

Change v6 -> v7
	Update function return values.

Change v5 -> v6
	Remove redundant vf_qm_state status checks.

Change v4 -> v5
	Update version matching strategy

Change v3 -> v4
	Modify version matching scheme

Change v2 -> v3
	Modify the magic digital field segment

Change v1 -> v2
	Add fixes line for patch comment

Longfang Liu (6):
  hisi_acc_vfio_pci: fix XQE dma address error
  hisi_acc_vfio_pci: add eq and aeq interruption restore
  hisi_acc_vfio_pci: bugfix cache write-back issue
  hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
  hisi_acc_vfio_pci: bugfix live migration function without VF device
    driver
  hisi_acc_vfio_pci: update function return values.

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 108 +++++++++++++-----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  14 ++-
 2 files changed, 93 insertions(+), 29 deletions(-)

-- 
2.24.0


