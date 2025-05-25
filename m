Return-Path: <kvm+bounces-47662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39B9DAC32C6
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 09:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03D021701D7
	for <lists+kvm@lfdr.de>; Sun, 25 May 2025 07:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC3C19CD16;
	Sun, 25 May 2025 07:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+ZXCe9B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A4A2DCBF7
	for <kvm@vger.kernel.org>; Sun, 25 May 2025 07:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748159382; cv=none; b=iZrdns6GlXfs/tzUgDIwJHZlLfazG6t1CscjmPUFkYjOElnyWv5Va2Vd4Jcw04zpUrMPVOe870T+BAVMI+UiT+E3DxU8dD+Vimw0ViLr3UFg/pFyxVARr/iLJ67/tOB6A44CmIahE7M1cWnXPh0DACzxCQ6n2l3scEX1i/guJhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748159382; c=relaxed/simple;
	bh=RR29guoYi/u4ZXoLMPjMoscoBTZis3uzfWmE3DlEO0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVdXCSGEPemOMrzJARZyRzvNKo9LCFiBcbJHa0aHKc9hMWBPsS9yHuUO6FRqWw7DSjkPUukQrHxqzoO33t+BT7Qqymu1U+GmYuYGEVpZWkbsqToD3DVlrhln5aIo24hINzwg24ornzl6v5dZveUZQ2pg/1BlNV59ca2bZCn0vHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+ZXCe9B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598CBC4CEEF;
	Sun, 25 May 2025 07:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748159380;
	bh=RR29guoYi/u4ZXoLMPjMoscoBTZis3uzfWmE3DlEO0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+ZXCe9BhoG3w8lZ2wMCFjD1n3z2gN3eL7dhQyQ4RFpbugb0+Mkrk11nLbzeqglij
	 u6dBLuIZUdaTQtfjjsVVXRB3sDoe1rMgHPzr2Q249lj9QLWbST29KXvtgUIWMqwKAH
	 ry/rkIEdCaX0TUBTx0uOlSjaKtw2ENZbBbYWsGKOZ58MUbzK6mJ1bu/nwLpuWvnp6H
	 Xn+YkqZDw1LI1gww0lhns4Oy2HnPhHN87Q9TilqQ/VIPhnXDC7hKkQ6qyGJqAQML5p
	 fvv7rLCXilEY9iw5wbP66AwT+3mQSEfe5+7JX8sbccKy6cRrSXrgExnQmd/kXrAGCB
	 gTDqk9ugAEjqQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [RFC PATCH kvmtool 02/10] vfio: Rename some functions
Date: Sun, 25 May 2025 13:19:08 +0530
Message-ID: <20250525074917.150332-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250525074917.150332-1-aneesh.kumar@kernel.org>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We will add iommufd support in later patches. Rename the old vfio
method as legacy vfio.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 vfio/core.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/vfio/core.c b/vfio/core.c
index c6b305c30cf7..424dc4ed3aef 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -282,7 +282,7 @@ void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
 	}
 }
 
-static int vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
+static int legacy_vfio_configure_device(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret;
 	struct vfio_group *group = vdev->group;
@@ -340,12 +340,12 @@ err_close_device:
 	return ret;
 }
 
-static int vfio_configure_devices(struct kvm *kvm)
+static int legacy_vfio_configure_devices(struct kvm *kvm)
 {
 	int i, ret;
 
 	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
-		ret = vfio_configure_device(kvm, &vfio_devices[i]);
+		ret = legacy_vfio_configure_device(kvm, &vfio_devices[i]);
 		if (ret)
 			return ret;
 	}
@@ -429,7 +429,7 @@ static int vfio_configure_reserved_regions(struct kvm *kvm,
 	return ret;
 }
 
-static int vfio_configure_groups(struct kvm *kvm)
+static int legacy_vfio_configure_groups(struct kvm *kvm)
 {
 	int ret;
 	struct vfio_group *group;
@@ -454,7 +454,7 @@ static int vfio_configure_groups(struct kvm *kvm)
 	return 0;
 }
 
-static struct vfio_group *vfio_group_create(struct kvm *kvm, unsigned long id)
+static struct vfio_group *legacy_vfio_group_create(struct kvm *kvm, unsigned long id)
 {
 	int ret;
 	struct vfio_group *group;
@@ -512,10 +512,11 @@ static void vfio_group_exit(struct kvm *kvm, struct vfio_group *group)
 	if (--group->refs != 0)
 		return;
 
-	ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER);
-
 	list_del(&group->list);
-	close(group->fd);
+	if (group->fd != -1) {
+		ioctl(group->fd, VFIO_GROUP_UNSET_CONTAINER);
+		close(group->fd);
+	}
 	free(group);
 }
 
@@ -559,14 +560,14 @@ vfio_group_get_for_dev(struct kvm *kvm, struct vfio_device *vdev)
 		}
 	}
 
-	group = vfio_group_create(kvm, group_id);
+	group = legacy_vfio_group_create(kvm, group_id);
 
 out_close:
 	close(dirfd);
 	return group;
 }
 
-static int vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
+static int legacy_vfio_device_init(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret;
 	char dev_path[PATH_MAX];
@@ -610,7 +611,7 @@ static void vfio_device_exit(struct kvm *kvm, struct vfio_device *vdev)
 	free(vdev->sysfs_path);
 }
 
-static int vfio_container_init(struct kvm *kvm)
+static int legacy_vfio_container_init(struct kvm *kvm)
 {
 	int api, i, ret, iommu_type;;
 
@@ -638,7 +639,7 @@ static int vfio_container_init(struct kvm *kvm)
 	for (i = 0; i < kvm->cfg.num_vfio_devices; ++i) {
 		vfio_devices[i].params = &kvm->cfg.vfio_devices[i];
 
-		ret = vfio_device_init(kvm, &vfio_devices[i]);
+		ret = legacy_vfio_device_init(kvm, &vfio_devices[i]);
 		if (ret)
 			return ret;
 	}
@@ -678,15 +679,15 @@ static int vfio__init(struct kvm *kvm)
 	}
 	kvm_vfio_device = device.fd;
 
-	ret = vfio_container_init(kvm);
+	ret = legacy_vfio_container_init(kvm);
 	if (ret)
 		return ret;
 
-	ret = vfio_configure_groups(kvm);
+	ret = legacy_vfio_configure_groups(kvm);
 	if (ret)
 		return ret;
 
-	ret = vfio_configure_devices(kvm);
+	ret = legacy_vfio_configure_devices(kvm);
 	if (ret)
 		return ret;
 
-- 
2.43.0


