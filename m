Return-Path: <kvm+bounces-48373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6C2DACD829
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 08:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BE611894187
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 06:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A89230BD2;
	Wed,  4 Jun 2025 06:56:08 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDB01FCFF1;
	Wed,  4 Jun 2025 06:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749020167; cv=none; b=cUWxDcXWd6VpH8p3dBpkKCNDRuc6eOp0cTbZ9gkHbCDONZAuafP2T89zjBGyMvrOuEdeb7pHBj2BNReyxgJPsDnpLqhgR2h6wCn93fUdwPPWZqXlNAuch6/6xR1Mvz8UPLX1zFpwWza/Hdf0L6yt0+HFS9UUEzwudtzrN2th8nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749020167; c=relaxed/simple;
	bh=NmoUD4o1/acS/X92p+/3dD2O+lx5anNx9KqfLXTVtsw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OIFLp0SrTfcYTL2RVr7xWhydsjdVHnuopAEN3MzrpC8KPeG2qoq71LsuA3dZHdvR4BpWh3t+HNKfygAfFCmW/aR2t5qHLk052k697IaGx0ZF8H76djHerRW+sKVdnhLkSVtymfpA8dm7DCcTENvQ77PGs6wlzfypSEFFfQanQTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f4b41e86411011f0b29709d653e92f7d-20250604
X-CTIC-Tags:
	HR_CC_AS_FROM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI, AMN_C_BU
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:11c5b19d-2e59-44ff-9c3e-2bb34db830f2,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-INFO: VERSION:1.1.45,REQID:11c5b19d-2e59-44ff-9c3e-2bb34db830f2,IP:0,URL
	:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:20
X-CID-META: VersionHash:6493067,CLOUDID:c275b237e792ae232df6132bdbb1a343,BulkI
	D:250604145555B1X420DL,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102,TC:n
	il,Content:0|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: f4b41e86411011f0b29709d653e92f7d-20250604
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1197149827; Wed, 04 Jun 2025 14:55:52 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: mst@redhat.com,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>
Subject: [PATCH] vhost:  Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))
Date: Wed,  4 Jun 2025 14:55:48 +0800
Message-Id: <1a8499a5da53e4f72cf21aca044ae4b26db8b2ad.1749020055.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cocci warning:
./kernel/vhost_task.c:148:9-16: WARNING: ERR_CAST can be used with tsk

Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...)).

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 kernel/vhost_task.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 2f844c279a3e..8c4a82c0bdbe 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL_GPL(vhost_task_stop);
  * @arg: data to be passed to fn and handled_kill
  * @name: the thread's name
  *
- * This returns a specialized task for use by the vhost layer or ERR_PTR() on
+ * This returns a specialized task for use by the vhost layer or ERR_CAST() on
  * failure. The returned task is inactive, and the caller must fire it up
  * through vhost_task_start().
  */
@@ -145,7 +145,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 	tsk = copy_process(NULL, 0, NUMA_NO_NODE, &args);
 	if (IS_ERR(tsk)) {
 		kfree(vtsk);
-		return ERR_PTR(PTR_ERR(tsk));
+		return ERR_CAST(tsk);
 	}
 
 	vtsk->task = tsk;
-- 
2.25.1


