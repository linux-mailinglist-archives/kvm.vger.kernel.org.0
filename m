Return-Path: <kvm+bounces-23843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 902FD94ECC6
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 14:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A5DC281F07
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 12:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10115179957;
	Mon, 12 Aug 2024 12:21:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57DF16D9C0
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 12:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723465275; cv=none; b=SCF4oo5kqCE/a8AoJYfLzslASouVYBnW+He4qatowN7A8Z9iyMEuxxfyXIGeLRk+BryDRZ5JxraK0y3rClUcX5B1TxEIa2zvVV6UqPA1wsB6sJfSx5kJSkGR8w1jAYGpbbVC+vZHeP71EV83mPFDw3Feob8+YW4uhyTnENEsPJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723465275; c=relaxed/simple;
	bh=jAHU3lzpEaY7EkJbQPpZeST9jPIaejEAYyvoLatgtdU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sVBo43pcSY4vWBkncYI6qwPDJOb8pEnL88ZhSbP9l3JyLvK5PWU3Kd90MpJoBJMSberx4WP8aFMm1YxIaJBN+qXx+XruwuaF8JWvwMGqobKgD37ecsDdCSAYVc7g3pkka43RGTtmTMt+FIWtAza6daWHWgUeijcjp5Ft2Cprr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WjDBL4gbYz1T77h;
	Mon, 12 Aug 2024 20:20:42 +0800 (CST)
Received: from kwepemf500003.china.huawei.com (unknown [7.202.181.241])
	by mail.maildlp.com (Postfix) with ESMTPS id CFC951800A0;
	Mon, 12 Aug 2024 20:21:09 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemf500003.china.huawei.com
 (7.202.181.241) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 12 Aug
 2024 20:21:09 +0800
From: Zhang Zekun <zhangzekun11@huawei.com>
To: <kwankhede@nvidia.com>, <alex.williamson@redhat.com>,
	<kvm@vger.kernel.org>
CC: <zhangzekun11@huawei.com>
Subject: [PATCH] vfio: mdev: Remove unused function declarations
Date: Mon, 12 Aug 2024 20:08:23 +0800
Message-ID: <20240812120823.10968-1-zhangzekun11@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemf500003.china.huawei.com (7.202.181.241)

The definition of mdev_bus_register() and mdev_bus_unregister() have been
removed since commit 6c7f98b334a3 ("vfio/mdev: Remove vfio_mdev.c"). So,
let's remove the unused declarations.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
---
 drivers/vfio/mdev/mdev_private.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index 63a1316b08b7..5f61acd0fe42 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -10,9 +10,6 @@
 #ifndef MDEV_PRIVATE_H
 #define MDEV_PRIVATE_H
 
-int  mdev_bus_register(void);
-void mdev_bus_unregister(void);
-
 extern const struct bus_type mdev_bus_type;
 extern const struct attribute_group *mdev_device_groups[];
 
-- 
2.17.1


