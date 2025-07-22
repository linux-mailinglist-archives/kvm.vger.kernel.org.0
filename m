Return-Path: <kvm+bounces-53093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02430B0D390
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:42:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6FEB3B51A5
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99332DE6EF;
	Tue, 22 Jul 2025 07:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="MJFkxAG3"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971292D3A7C;
	Tue, 22 Jul 2025 07:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169776; cv=none; b=ZcN0QAwGO7l8ZC9F24I9qDt9E3WwYw5EhHWc5T8XV1GE+3oC+S5wMTtiLvny930L1UUDGypziUKq/Ai8DwAgf4l3OM6gA9WGKA0Hb1/Yv+X8WECmzlQ/O6GuT3n3tmiSZGfgLlag0Jp7E9AaGS6aAWGktRzBPFIOZrdCLMIdF3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169776; c=relaxed/simple;
	bh=rywSG7/hojbAEstBjYEc9OoFmb1XPODVYxsk2EuootY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWAmfZG7vUMoc2yHV0awpMTSH59/lmFyqYGzzSB/jxL2qt7ljcyBPAi5P9vCYpcemPCdIUNXc2pPCOMjDCySAN9EzLcgCa+LazuJJ7mo3+GWcpswUbBMHJ9bEke5kvm7OVrfPb+0OCHe+BePNDJbAS/r9BBWrQb5XlMW1p/DrN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=MJFkxAG3; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753169768;
	bh=JwyCRpM1FWaTLNFe5LSvBKJz+ZtIxups+3c5ci7f0O0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=MJFkxAG3TnOaoyZ4tzb12gT1fPu5yyG16H1Jl1iJ/oYnB9Kts6izQRSiY9a7OPcm7
	 WZleUri6Ry182mEzkPtL2iDmtU3MLCXxT/Vu/l1qM1DNsBuz5jKinRM3iFv1jNlTlK
	 Fc9kOnytqsgB5JVJNE2AOdrQsN15jb66+sxQDTV4=
X-QQ-mid: zesmtpip2t1753169705t5d8d5b17
X-QQ-Originating-IP: sO//PwrBzanzWIpX43hUjMW25ZeVM74q8qXSuUHVttA=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:35:00 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13053412534972424115
EX-QQ-RecipientCnt: 65
From: WangYuli <wangyuli@uniontech.com>
To: wangyuli@uniontech.com
Cc: airlied@gmail.com,
	akpm@linux-foundation.org,
	alison.schofield@intel.com,
	andrew+netdev@lunn.ch,
	andriy.shevchenko@linux.intel.com,
	arend.vanspriel@broadcom.com,
	bp@alien8.de,
	brcm80211-dev-list.pdl@broadcom.com,
	brcm80211@lists.linux.dev,
	colin.i.king@gmail.com,
	cvam0000@gmail.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	dave.jiang@intel.com,
	dave@stgolabs.net,
	davem@davemloft.net,
	dri-devel@lists.freedesktop.org,
	edumazet@google.com,
	gregkh@linuxfoundation.org,
	guanwentao@uniontech.com,
	hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com,
	intel-xe@lists.freedesktop.org,
	ira.weiny@intel.com,
	j@jannau.net,
	jeff.johnson@oss.qualcomm.com,
	jgross@suse.com,
	jirislaby@kernel.org,
	johannes.berg@intel.com,
	jonathan.cameron@huawei.com,
	kuba@kernel.org,
	kvalo@kernel.org,
	kvm@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux@treblig.org,
	lucas.demarchi@intel.com,
	marcin.s.wojtas@gmail.com,
	ming.li@zohomail.com,
	mingo@kernel.org,
	mingo@redhat.com,
	netdev@vger.kernel.org,
	niecheng1@uniontech.com,
	oleksandr_tyshchenko@epam.com,
	pabeni@redhat.com,
	pbonzini@redhat.com,
	quic_ramess@quicinc.com,
	ragazenta@gmail.com,
	rodrigo.vivi@intel.com,
	seanjc@google.com,
	shenlichuan@vivo.com,
	simona@ffwll.ch,
	sstabellini@kernel.org,
	tglx@linutronix.de,
	thomas.hellstrom@linux.intel.com,
	vishal.l.verma@intel.com,
	wangyuli@deepin.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org,
	yujiaoliang@vivo.com,
	zhanjun@uniontech.com,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v3 4/8] net: mvneta: Fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:27 +0800
Message-ID: <0CB4300CB6F49007+20250722073431.21983-4-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <576F0D85F6853074+20250722072734.19367-1-wangyuli@uniontech.com>
References: <576F0D85F6853074+20250722072734.19367-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: OLsBWtCIHsg6qpyUVgLKJSgwSlAKGQTxXOnZVJNFFd4AQWPB2BjvZZt8
	2wgW4YXeCgyJCjYbAnzceUWlGLhA1te78istOv0Nk1hEiUUVDgV17BZ5q6Tdiyth7YZTfAR
	pepTKbRe/Bw/4jW2yVaCTNK5wF6QHSy8EBu9w9bHCVKKJi4v5FsdNACW3dBkY0y2fjpPp68
	AJt6+XmryWCnDmBOni4XzxxEgkRTAIVudwhv/2sxAsAYRpDHiE3RlbqG1LLzW6vi/q2qtRM
	0tdjKhUaazURm+S/exHXwWswXA/80tYYJe/um8gTx3oB5F/OjKNB+PSmBZj6pHQnpoOyTXa
	aRkrMK/NHUtsGm2KD6GE2b3BHm/LIPFuX0ka3ZVAzdhuIw1HdxIno/FG73WIqNJ2xWQC9lH
	sliMvciP6/NPcliBimaJhBBYRZDkkK+BDtPYP3df2QxGcEyJLj5NhkYL3/Um4M8DCvJe15J
	nvwByVEInbw+KtHNnPGqDe4joaIKcVLSpHXB4H6hi32mhCIOJyTyi/utkt3Jo+qFPgWuJrI
	hGt++YRsr1tdLgMiGZJZQXELfMXzYwAHDmYfZz17x3cATEzKMUKEmfoNEFnPPD1gZZWACl3
	EY2UpZnnf4Zouo6p0q/mU09CxsjQL898Kg3L/ruyEfsKBDDSMYtZxW/G79vhlMtshFGhvRv
	8FRYQSOQ85OW8q3LqQVU18BkfoRgxMoDHd7z/wFWENKZ63JPaQ/soUM+0TtI95phljixouL
	6CoT5iVYkVEzBPxbwJ5jg9eFJk7FQPkEs0yWTXjLwHH7POuGGy81+VC4Gp1TMu4Dy9JdFBf
	HILJqTFWMiQVws6sDYwntn8l4OC59MCJCXs+AKU6rw5t5MiwxAPD7BoKB2IZDxv6TiZAg+8
	4hSvE3LTxdwc9MYhFY7h8aRnPI2zMlssunpCHnePdmzWJIMW7QHJ1su0ypTUkYAd6ZrERvS
	AzYDkng4WfXu5+GKhizgRrJtIEJWmtxVvNvLvbYIQSrftXdLna2gYIWO2utj2/X0YnJg4LE
	Lz0kPewy8Jr0rB0DABZK5/5Hh4h/VSf+VBwwHCILiO4yOzGP2z7pwATgjwD0MURCnxEfQwE
	7szkTlAp+hjzGdFpMbHApv12IPDZa0+oQ==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 147571fdada3..ee4696600146 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4610,7 +4610,7 @@ static int mvneta_stop(struct net_device *dev)
 		/* Inform that we are stopping so we don't want to setup the
 		 * driver for new CPUs in the notifiers. The code of the
 		 * notifier for CPU online is protected by the same spinlock,
-		 * so when we get the lock, the notifer work is done.
+		 * so when we get the lock, the notifier work is done.
 		 */
 		spin_lock(&pp->lock);
 		pp->is_stopped = true;
-- 
2.50.0


