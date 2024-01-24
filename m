Return-Path: <kvm+bounces-6819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A0883A5BC
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 10:42:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07A131C22C78
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 09:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5315018030;
	Wed, 24 Jan 2024 09:42:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11661798C;
	Wed, 24 Jan 2024 09:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089351; cv=none; b=smEbk1HpXhlUNB2JARaLxaE8yLNCH2qQX9df1N7ksK0z5kNDUUddWUBcfzvOK/qe9B7SRFtdg/uX9thdT59qzXueGj/crtaSNGlvNe21+xqJ5MYtp6MV2PBKYCQhGwB4hLywNfP1mFIF6XyOE3123NrihOF0JRFjSMjk06X6Rvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089351; c=relaxed/simple;
	bh=JDrsz0CKwL+aPZhb85e2CY9gnCQafK8RTcFyutCW7mo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pDU1hX/gXyJxkw30d18vFzDCQKGqU9JPSr2entNeFO+WDBYWLY23yihBOCRpNHEvjpUHAdBkAVCO6zeaxrg3G4Dd3vEfuItSn3hY6VtCDlvN8/AlMzRGsT1rimKxCmIj+/NexHmM7p6d178dplgahveatSDu3lCpWbHFntOG6+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2a995f7cc3054f0c90ab071957e8d838-20240124
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:21e3d530-1a18-4978-816b-9179cc7e7ddc,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-INFO: VERSION:1.1.35,REQID:21e3d530-1a18-4978-816b-9179cc7e7ddc,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-META: VersionHash:5d391d7,CLOUDID:38e63383-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:2401241737004LUCFGAT,BulkQuantity:0,Recheck:0,SF:19|44|66|38|24|17|1
	02,TC:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 2a995f7cc3054f0c90ab071957e8d838-20240124
Received: from mail.kylinos.cn [(39.156.73.10)] by mailgw
	(envelope-from <chentao@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1046508456; Wed, 24 Jan 2024 17:36:57 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 98545E000EB9;
	Wed, 24 Jan 2024 17:36:57 +0800 (CST)
X-ns-mid: postfix-65B0DA39-4239131226
Received: from kernel.. (unknown [172.20.15.234])
	by mail.kylinos.cn (NSMail) with ESMTPA id 98C0EE000EB9;
	Wed, 24 Jan 2024 17:36:48 +0800 (CST)
From: Kunwu Chan <chentao@kylinos.cn>
To: mpe@ellerman.id.au,
	npiggin@gmail.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH] KVM: PPC: code cleanup for kvmppc_book3s_irqprio_deliver
Date: Wed, 24 Jan 2024 17:36:47 +0800
Message-Id: <20240124093647.479176-1-chentao@kylinos.cn>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This part was commented from commit 2f4cf5e42d13 ("Add book3s.c")
in about 14 years before.
If there are no plans to enable this part code in the future,
we can remove this dead code.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 arch/powerpc/kvm/book3s.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 8acec144120e..c2f50e04eec8 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -360,9 +360,6 @@ static int kvmppc_book3s_irqprio_deliver(struct kvm_v=
cpu *vcpu,
 		break;
 	}
=20
-#if 0
-	printk(KERN_INFO "Deliver interrupt 0x%x? %x\n", vec, deliver);
-#endif
=20
 	if (deliver)
 		kvmppc_inject_interrupt(vcpu, vec, 0);
--=20
2.39.2


