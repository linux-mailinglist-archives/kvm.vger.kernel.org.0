Return-Path: <kvm+bounces-66852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C08FCCEA345
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 17:43:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A105303ADEE
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 16:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1706320CC9;
	Tue, 30 Dec 2025 16:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="JqqWeh8d"
X-Original-To: kvm@vger.kernel.org
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E3B26056D;
	Tue, 30 Dec 2025 16:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767112884; cv=none; b=S0oUFgFbFH61eqh1+HzqEF0ZlHNQZvqOvr4yxdhJelq+Z+7GD+x8s3m5ydZJvH0TRiFtRWdcMc2VfA6vJpHWu+ynrkcJOSiakOccHcHdNbC8Va98sftYgT/93qaMG25E9Mgr5gSjW3ZiX6RKOvoMM8Kfd4NWv+bUIwKfPH5MUrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767112884; c=relaxed/simple;
	bh=CkFNzqnUqLm4u4nDY43UZvfl4PvkWLZ+twJgP1k3McU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jwf5Hfd/t7m4x5PVwrW7cx7xPzCiA5NpfXGYgAkvHMtT68hq4Q2ELEsoFrhx5nDJiaiUzmsLcyeLD4zxueBx4zZVCtMRSPg+vZubF/puGxcDn9+dIqR/7MJtIcpHCfBKjnnYsMVQR/xeT4Xdn/tLg0elG6KJEbP4tXtivCBL8wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=JqqWeh8d; arc=none smtp.client-ip=192.134.164.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Xov2xNBxH10xSFZZ4skQN/78SgqXsoFILU84HQBtO5w=;
  b=JqqWeh8dLfC270WgK/hlF1Y3ic2sZJNsZLud/PZhyP6WL+7UYTUn3oBP
   /ffl1tz3zfIJAiLRYPMzBIlYiqG37bpLnYPIstU8wi4Es7mY01xEOjFMk
   s2+h9kwVMnbhQfG3TvJH/t/Cuj4PEyAIdvm3gZJu2vjPjuE/iFeCRtra6
   I=;
X-CSE-ConnectionGUID: Ue+aKRAPQiChGNdXMqvPgw==
X-CSE-MsgGUID: auc/EMGsRPmX+dn1TIErLg==
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.21,189,1763420400"; 
   d="scan'208";a="256362544"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.102.196])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2025 17:41:18 +0100
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Kirti Wankhede <kwankhede@nvidia.com>
Cc: yunbolyu@smu.edu.sg,
	kexinsun@smail.nju.edu.cn,
	ratnadiraw@smu.edu.sg,
	xutong.ma@inria.fr,
	Alex Williamson <alex@shazbot.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/mdev: update outdated comment
Date: Tue, 30 Dec 2025 17:41:13 +0100
Message-Id: <20251230164113.102604-1-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function add_mdev_supported_type() was renamed mdev_type_add() in
commit da44c340c4fe ("vfio/mdev: simplify mdev_type handling").
Update the comment accordingly.

Note that just as mdev_type_release() now states that its put pairs
with the get in mdev_type_add(), mdev_type_add() already stated that
its get pairs with the put in mdev_type_release().

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/vfio/mdev/mdev_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
index e44bb44c581e..b2596020e62f 100644
--- a/drivers/vfio/mdev/mdev_sysfs.c
+++ b/drivers/vfio/mdev/mdev_sysfs.c
@@ -156,7 +156,7 @@ static void mdev_type_release(struct kobject *kobj)
 	struct mdev_type *type = to_mdev_type(kobj);
 
 	pr_debug("Releasing group %s\n", kobj->name);
-	/* Pairs with the get in add_mdev_supported_type() */
+	/* Pairs with the get in mdev_type_add() */
 	put_device(type->parent->dev);
 }
 


