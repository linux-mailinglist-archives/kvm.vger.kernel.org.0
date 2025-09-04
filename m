Return-Path: <kvm+bounces-56739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7469DB43116
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 222CE4E364C
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27AB322AE65;
	Thu,  4 Sep 2025 04:26:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044E11BC58;
	Thu,  4 Sep 2025 04:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756960013; cv=none; b=QM3uZmLoguIMuU7QvwFbRtjk2t1tpbOLkqInTWLNnihWu7qTd/1p+R7VTMLiNdek9/mUWeAqV6CLqpTADW6l7vjUtF4CyfxbDY2CNMUzD099IbW8AM1I6s5TeejTx+6NfFUFgYbE88kou1xS8vMCyN/hRHs0c0rU0Z2FavXTCM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756960013; c=relaxed/simple;
	bh=FZ3hp9QC4qMTv8OfmfI7/9tLLAbqepHOg93t9NYVi6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OHko3iZ+znKqTRl310iluhZ9e36DH7RhAPN5YgWXfWLg55XF19NKla2T2dveio/ALyHxy0Pn3PwIGogmtarWVo2KR7lLDDvK63lXOT3jDG/jx/kjvXSoTGSp+GzCZV1FAqAHpx8gmz8seg2zm88Jd8J95vv3z3nQ1E84EFfr70o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5916e9de894711f0b29709d653e92f7d-20250904
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_UNTRUSTED, SA_LOWREP
	SA_EXISTED, SN_UNTRUSTED, SN_LOWREP, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:2d54f3e2-bec7-42bd-bbf8-e29200111e39,IP:15,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.1.45,REQID:2d54f3e2-bec7-42bd-bbf8-e29200111e39,IP:15,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:6493067,CLOUDID:18a91f417ddc5b29999841a85909ed68,BulkI
	D:250904122643NMZQD1AN,BulkQuantity:0,Recheck:0,SF:19|24|38|44|66|72|78|10
	2,TC:nil,Content:0|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,B
	EC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 5916e9de894711f0b29709d653e92f7d-20250904
X-User: cuitao@kylinos.cn
Received: from ctao-ubuntu.. [(39.156.73.13)] by mailgw.kylinos.cn
	(envelope-from <cuitao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2133732486; Thu, 04 Sep 2025 12:26:37 +0800
From: cuitao <cuitao@kylinos.cn>
To: zhaotianrui@loongson.cn,
	maobibo@loongson.cn,
	chenhuacai@kernel.org,
	loongarch@lists.linux.dev
Cc: kernel@xen0n.name,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cuitao <cuitao@kylinos.cn>
Subject: [PATCH] LoongArch: KVM: remove unused returns.
Date: Thu,  4 Sep 2025 12:26:22 +0800
Message-ID: <20250904042622.1291085-1-cuitao@kylinos.cn>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The default branch has already handled all undefined cases,
so the final return statement is redundant.

Signed-off-by: cuitao <cuitao@kylinos.cn>
---
 arch/loongarch/kvm/exit.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 2ce41f93b2a4..e501867740b1 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -778,9 +778,7 @@ static long kvm_save_notify(struct kvm_vcpu *vcpu)
 		return 0;
 	default:
 		return KVM_HCALL_INVALID_CODE;
-	};
-
-	return KVM_HCALL_INVALID_CODE;
+	}
 };
 
 /*
-- 
2.48.1


