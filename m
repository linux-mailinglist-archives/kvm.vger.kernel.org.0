Return-Path: <kvm+bounces-19846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F3A90C684
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 12:22:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EC76283D04
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 10:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CBC018EFE2;
	Tue, 18 Jun 2024 07:53:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E496218EFCF
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 07:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718697195; cv=none; b=M1eHHVwzkyOoorCcWjYz9DOSCUePkMiWzjGTU0q5XKXKXdKByoA9VmBzwqR6HNiPpK42mnSrK9R8PtmD5sbdexIYtyJe4MSHGv7GdyZlwMgSVXOD4mdWKn7lRWG6ZkInkw3M0gMlFfWVKE92ttEM2qsSkNVjo82WZFAGK8dKcWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718697195; c=relaxed/simple;
	bh=S1kzxHZ17jNmy+Ksp7BMor6vAnSaeQZyC0L1agh37Dg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ve/7mIjdT7NrSFCQLc32J/nMJ5z3zp8+JewDL605ON9grpwqFPvy4N7uqyrRnF3XeNay1srB9D6H5WyPO3g3hflaUKiI2RPCwqkZDgOxP6sVLdjOcm1zSVz3Ghw0YFwIey4he9fF9uNCswuEh0R8pzF+gk82zSUuStk7Vc/+G+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ca9897042d4711ef9305a59a3cc225df-20240618
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:7a2923d3-522d-4f6b-be64-aba65ef99615,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:35
X-CID-INFO: VERSION:1.1.38,REQID:7a2923d3-522d-4f6b-be64-aba65ef99615,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:35
X-CID-META: VersionHash:82c5f88,CLOUDID:ee85f8fd985444f86933bca692dde8af,BulkI
	D:2406181553051H2NSX16,BulkQuantity:0,Recheck:0,SF:66|23|72|19|43|74|102,T
	C:nil,Content:0,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_UNTRUSTED, SA_UNFAMILIAR, SN_UNTRUSTED, SN_UNFAMILIAR
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-UUID: ca9897042d4711ef9305a59a3cc225df-20240618
X-User: leixiang@kylinos.cn
Received: from ninol.. [(111.48.58.13)] by mailgw.kylinos.cn
	(envelope-from <leixiang@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1042011050; Tue, 18 Jun 2024 15:53:03 +0800
From: leixiang <leixiang@kylinos.cn>
To: kvm@vger.kernel.org
Cc: xieming@kylinos.cn,
	leixiang <leixiang@kylinos.cn>
Subject: [PATCH] kvm tools:Fix memory leakage in open all disks
Date: Tue, 18 Jun 2024 15:52:47 +0800
Message-Id: <20240618075247.1394144-1-leixiang@kylinos.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix memory leakage in disk/core disk_image__open_all when malloc disk failed,
should free the disks that already malloced.

Signed-off-by: Lei Xiang <leixiang@kylinos.cn>
Suggested-by: Xie Ming <xieming@kylinos.cn>
---
 disk/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/disk/core.c b/disk/core.c
index dd2f258..affeece 100644
--- a/disk/core.c
+++ b/disk/core.c
@@ -195,8 +195,10 @@ static struct disk_image **disk_image__open_all(struct kvm *kvm)
 
 		if (wwpn) {
 			disks[i] = malloc(sizeof(struct disk_image));
-			if (!disks[i])
-				return ERR_PTR(-ENOMEM);
+			if (!disks[i]) {
+				err = ERR_PTR(-ENOMEM);
+				goto error;
+			}
 			disks[i]->wwpn = wwpn;
 			disks[i]->tpgt = tpgt;
 			continue;
-- 
2.34.1


