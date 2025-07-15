Return-Path: <kvm+bounces-52502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34618B05F03
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24478503385
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0112ED872;
	Tue, 15 Jul 2025 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="cYNpNWbY"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFCE2E92DE;
	Tue, 15 Jul 2025 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587128; cv=none; b=Y/+GmA+0Q/mVCDqmLJGXn08P3QjqYSCHcCjLKCV1bZ6G/dmgUuX+XSvR2oHhE1rrxoylpivsgJrXvevcjAf7CgPHX76qLAGm6+zeX4qpBlLIBpsdc1zGbbF4vb1z97bPrvh8RJQGjhzT+Dgb6FWT1hhOjDGx5s1zzSwlpTGmvOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587128; c=relaxed/simple;
	bh=8dIVldAh6hyQxQjJbViplUyqI8Yi/pm1smKWNs7cITM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+/Nyt/eXDuQMn80QTvNlxzxTeEg4+9OT6s7xW3IvGaFMLyW67kn0CD71cbbLQq3APyJzMFNIAvrq6MJLeZbvlbyLvpkQ288PBV8SlgYLWAkd+28ilY13kAt0jbV1fmQt5RIsGgdxvtLLb6CKH1ZVEEvyeNAfJ+gJkDf9MTDFG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=cYNpNWbY; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587119;
	bh=VbDjsaSgaoEPlFZ9K3vL7MSzjcmGihKEVnrA99JNOYI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=cYNpNWbYqKgbtSDrgMMfjJ2xkHgZRACyt6gucq3evEQo11N5w57rJeRzQ7B2fzh9e
	 Wvr4qxNetJdS4xTKmYCMM2vK+tntv0eZYCh5l36LjGooQUOks3svE9xekEGP1XEEL2
	 zPbk/ivgtwq0VZZgsVVizuezciF49dM5Ni64086s=
X-QQ-mid: zesmtpip2t1752587106t97bb4b6a
X-QQ-Originating-IP: fr1CmoslNJ1j99md0Ifh9EAzvQnNvfGQS6SMdf3j/kc=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:45:01 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4765109323548060574
EX-QQ-RecipientCnt: 63
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
	x86@kernel.org,
	xen-devel@lists.xenproject.org,
	yujiaoliang@vivo.com,
	zhanjun@uniontech.com
Subject: [PATCH v2 5/8] wifi: brcmfmac: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:44:04 +0800
Message-ID: <F92035B0A9123150+20250715134407.540483-5-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: Oerpq93nJqLMzu2C91o49xzGzR2c31UAHfNwn3FibEcqTM80QrH1JOYl
	ABeqnTfuYrnHIaur47oMzRPeyYlwzlB5dX4cI25IArNna+wub0UvViAfQ6qP7+qROYfMBBT
	kyAMRUmLaMW1bwNm/efk6diTqhcjoPdorXvb4J4sGGJ7OKO/afBLmhcudFXmRf224knGdPx
	Fqzf5iKFRykLX7ES9/BVVboQ1wRnBvD0vv2V4dxuHT4zkEKJ848xqT+cux9LJaSjzlaGMJV
	2w9zwyYnOiXjQM7ePTRUy/bH0aUa0csdAoCjAC733ADG0KtpAq+D6xfomdQUpo4RvfB5YWD
	rnmy5b9hSaU7tk5uujpiCsihOQPFEFMmARC2eJS6dlOZR5wOvQAj5WSpGz2fnFZm59ugkAk
	mcUqCoM2BTMDFrxocgmDxT7BTMy76nUyMSzvx1InQz35SyX4XXOrL60vyD0SHJUqRJisCjB
	46ijxvPtK2TfOuMCriWPwQ8u7paWe4B1kspMdKbUpb2TCsBzamNPfKnw1YrO+Pxk395/Vfh
	Z+0NWP3LWdZMKq3zml8Eshdu9hOlm22uYaq6qjX1uKm+Jk5jjbQKLR43LxCiR21JWSVST9o
	scWjZyGkVJfePS3ONTaOayKwjs66yB+X7YIMF22s6O5omsO/wEH9C8aCaim0FECZd37+T2z
	3/izqaEDVUhBwrIlbVdrMPraOjuMV+9wkC74ih+/L0ZqNBAoeMu4Dh9DIPU4M8IMD8iPIiW
	cchOMAML1aXUR0alDVc9yAfTGaNIyxXr2IDrr0AoV0T9mC0VP/txIV9jVrYLHVngadhSedh
	qXK8h81CSjBrhUANJAZ05bLzBoevbDoT1gA8RvYFSfyfDpe8GlSupxAUgG25Jt9EvL0EVCC
	6xk/02kh1im86p8hr38Tcr7edkDcC8Omv/kKwfxFjJM3GUsLIKqO7ShMPGqGHkTQFrFg4Qd
	js/2UDptR5iYvH55R4NRiKwBblaZMlWMJQUiFGQHkHaLOjT8Q7eW8tAXzga8QqdteYiRECY
	LK2Y3QA5B0MT2yeEsWqUHyiLU2oTVpiyaD8JhUMH/hChAsQDJY/Krthw8vl7Pn97fflw37t
	Ot12njwtsygCg5WfJG/A2t9aISLrmMKgBX9zRPlYPY2qSrmoZNMf3oMsLLviP0qaA==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b94c3619526c..bcd56c7c4e42 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -8313,7 +8313,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	cfg->d11inf.io_type = (u8)io_type;
 	brcmu_d11_attach(&cfg->d11inf);
 
-	/* regulatory notifer below needs access to cfg so
+	/* regulatory notifier below needs access to cfg so
 	 * assign it now.
 	 */
 	drvr->config = cfg;
-- 
2.50.0


