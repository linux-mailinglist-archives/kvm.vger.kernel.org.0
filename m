Return-Path: <kvm+bounces-6714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ECF68381AE
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 03:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E9A41F24809
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 02:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF79C2C680;
	Tue, 23 Jan 2024 01:13:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492E3BE71;
	Tue, 23 Jan 2024 01:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972422; cv=none; b=gIAVwbxDTtHEjCMDvRbHp4Quh7m+pads84CKd/IIEY/2flMBeKrKWJHl30u0kEE6eujJ2Sgd1cwcyGiYimhVXUzYZmAC0rFbZzwnw0NseckWBbcZJCut66FMluHx76svvqkfcg8Lx8xzKC1h7X+EEgxUIcq+mqeRjuMWLO1+3Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972422; c=relaxed/simple;
	bh=eswOY/7LacnPItq2MBgGY1hsNbWUj9aRuO7FiWkWpZs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kZtWCilkPuXxosJTqPrGvCg+6Ozm7ytYS8lSOPCknsK0P66iD4VsQCIYdj0Xg2w1Jnn89QEvnjI/N0IojoFNGfvZEHf1quYVFy5rXlJx567lkfedFl39PVFf3uv72whZJ1tW0dxf8oxD7u+OGm0IoSiDM6EpSF7u5b7kdv+358U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 725ac9349c914a659c5fe5d0b26b1356-20240123
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:d72e2702-ade4-47e0-8027-c05a7342ce5f,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.35,REQID:d72e2702-ade4-47e0-8027-c05a7342ce5f,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:ee268a8e-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:240123091336YQ1JJ9EN,BulkQuantity:0,Recheck:0,SF:66|38|24|17|19|44|1
	02,TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 725ac9349c914a659c5fe5d0b26b1356-20240123
X-User: liucong2@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw
	(envelope-from <liucong2@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1484640778; Tue, 23 Jan 2024 09:13:33 +0800
From: Cong Liu <liucong2@kylinos.cn>
To: Brett Creeley <brett.creeley@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>
Cc: Cong Liu <liucong2@kylinos.cn>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] vfio/pds: Potential memory leak in pds_vfio_dirty_enable()
Date: Tue, 23 Jan 2024 09:13:19 +0800
Message-Id: <20240123011319.6954-1-liucong2@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

the patch releases the region_info memory if the interval_tree_iter_first()
function fails.

Signed-off-by: Cong Liu <liucong2@kylinos.cn>
---
 drivers/vfio/pci/pds/dirty.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 8ddf4346fcd5..67919b5db127 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -291,8 +291,11 @@ static int pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
 	len = num_ranges * sizeof(*region_info);
 
 	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
-	if (!node)
-		return -EINVAL;
+	if (!node) {
+		err = -EINVAL;
+		goto out_free_region_info;
+	}
+
 	for (int i = 0; i < num_ranges; i++) {
 		struct pds_lm_dirty_region_info *ri = &region_info[i];
 		u64 region_size = node->last - node->start + 1;
-- 
2.34.1


