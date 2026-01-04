Return-Path: <kvm+bounces-66978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDD5CF0B02
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 08:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 001B3301D66F
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 07:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14512E9ED6;
	Sun,  4 Jan 2026 07:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="EM/nWCCV"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE6C1EEA55;
	Sun,  4 Jan 2026 07:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767510439; cv=none; b=ocVp9DzlvVJP9iKseCJ2YJJTi9mYQgAJtNB7HPZIW8XEdaJkB2nfc3Nt9+qg15Rbt/PEKEnm6k1E1GStYEvvifa80lN/WxsT6V4cFHNAcfLi2K3advTWAO86BLS/Vy2brFB2cyYc211vMPRff9AaI5uTbvcMsOgnwcNwA9sqRa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767510439; c=relaxed/simple;
	bh=DwxRSrbpeGn1wLhuvbsuHXYHfELQbWZBvR6Hr/sqnnk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OH++lm1dLoOTyhlcnOs2SM06A72M+oJNvzd/NfTQfHxijDRZO046hZAsLRHrnSmjC611JJh9GuzAgsSidS1jWBzA/OSMlCGk0fexGux92pO2czRdVmOcQHdL6l3/4G6mJqRsnQ1IGajx36P+wmkiPGT1YbooukyS8nVJQVhZs5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=EM/nWCCV; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ljO4xynEIu5h/5VojD2Cz4CLpAmnl+PuQ/vX7P1dEvk=;
	b=EM/nWCCV9w250PyP6tYBUc84TLg2eB+VkFN6qK9KTUvxMGOuo3iVX566s9lBaG8DhLNGKcl2c
	Zsz0yLt1+1OBuSx0h/Q/xnkAYXS4otT1l8rZ83ogQo3sguAgaxJhOE2Ojw/2ntYjnzJvs2sqh5K
	l9VPwPxF6VdEdGWXrvJzyhI=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dkT1S1sybz1K97Q;
	Sun,  4 Jan 2026 15:03:56 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id BD37240538;
	Sun,  4 Jan 2026 15:07:07 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sun, 4 Jan
 2026 15:07:07 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 0/4] bugfix some issues under abnormal scenarios. 
Date: Sun, 4 Jan 2026 15:07:02 +0800
Message-ID: <20260104070706.4107994-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

In certain reset scenarios, repeated migration scenarios, and error injection
scenarios, it is essential to ensure that the device driver functions properly.
Issues arising in these scenarios need to be addressed and fixed

Longfang Liu (3):
  hisi_acc_vfio_pci: update status after RAS error
  hisi_acc_vfio_pci: resolve duplicate migration states
  hisi_acc_vfio_pci: fix the queue parameter anomaly issue

Weili Qian (1):
  hisi_acc_vfio_pci: fix VF reset timeout issue

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 40 +++++++++++++++----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 +
 2 files changed, 34 insertions(+), 8 deletions(-)

-- 
2.24.0


