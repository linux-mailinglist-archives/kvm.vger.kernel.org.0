Return-Path: <kvm+bounces-53094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 602C0B0D393
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FF7E3BEC96
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84DB2E0901;
	Tue, 22 Jul 2025 07:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="hh9mf8Mc"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D942B2DEA7C;
	Tue, 22 Jul 2025 07:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169779; cv=none; b=Yz081MWPOKNYkdlTlChSLlk/zKEZ4olXT+yMyMmuWrwC05Bt0Itz/B/4jDufmO3H2SxdsrlNZws6owRmTywd514mmkPRUB62g6xs9Nru+As9CM1v2n3WD0UTmKzdptviVUzrDvcvQ7HFdn16sStLm4UT03jHzGdAsRjW+SJS2oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169779; c=relaxed/simple;
	bh=TJadM9LJS2tCelUETqRvuerhKGeMiYlqvJ5GxFuV5tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKYwwH2nMdC+qhWIHch2fJKxv/2VykiPBcTCX+hvFbqcumCS/OzZIWdyPbuniPrIT5FGQ19WLELy0A1KetyjmoXiGza8OsHyMtbDkQ6Ym+WGmqYb+Cqwo7yIKLz0t1VGO8pbRcMnTtV8p7ULNWKsr3zzgSRTqiilsKXcvO2aLNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=hh9mf8Mc; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753169773;
	bh=+qa2f3QEhHEuh4QOwcxSpKUWx1Ey8PdHAyuKdLKK9Qg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=hh9mf8Mc39i+ypXzkOsf4eXv2b0nYXHjypO6K51HtClWMOgoe8WiUCUOKgNrC7lSO
	 kswBdHwDqCHODQZxZ6qIfnz8LZ4/eguAmnzJfkAWwhxgggEZRer794/zfwygBOEXsy
	 Bh700+3qb0A6kf23H6xbSevPD5NtzbaKY2SbGXGs=
X-QQ-mid: zesmtpip2t1753169713ta05aff85
X-QQ-Originating-IP: 65xfAki0jxPR9TUF1QvLcfebtVmeg84+TUXILAN6dYc=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:35:09 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13454134674662907572
EX-QQ-RecipientCnt: 64
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
	zhanjun@uniontech.com
Subject: [PATCH v3 5/8] wifi: brcmfmac: Fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:28 +0800
Message-ID: <6CA31F0821E6687F+20250722073431.21983-5-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: MJnJNoxLBk7A2HMrHuuKH+rRcPC405DqtcU2K5vfR4QGZ52lIxtQTGus
	R1OfguzqO6j8eW6EgHQBtVRMDnBndffm1B2VZntnMzJ/AJxsh5qTEqcV6L6iYgFSc9JKeQJ
	a4CNkQHXAfEEUNUZED+vps9lrRIVjCjiHpaKaD3f2cKO+/9FkbbQDIP76RjI3gmgU+HXLP6
	YR0/zGacVvnZwqwZF419wMfYn3Gthya82YtOTjOjOa7MxGzMb6XCsRK471tcNA9+YAzaWR7
	KNhHKV0i2NNXKHok9UE4/Q0p0f7AoEsP/csc0uWDynAc94ADGzbEy7lyVQCD84TmF9wgrCw
	0c/qlvVB3i8EwNHNI1hODKysRYek2qdeBxiUsQFtk3EVvVAb7XjBTTJ9anmdnlC81ip+qp6
	K+eBvBj2646lPxwyM0kEC58rQntElHndCZWEPKxYKWYZoD1PWN2qRP3OwaaSG6LCjhWpWPa
	PPp0KZs+YKnosNxR9Mrltchkz69sa3V2Qp9ngxWJlYZLIm1oHfxA2onkCORDS4d2V/akgLe
	iixtZMhCzDsWqjQ8d+tjDK37XC8UXQ8TgtdKnYuCdWgXHaGlD39260aNqY29qVaSG0Rdovp
	P7CgAjXpxyAYBiZLOeIYBxUnGOd2SlVTEXefTU/oP3sBcyl05pwJYmqhv/XQjRM6txvxj0r
	a9XItHiB7Vx2LOWaYMp6FbKNyEI+GMfC6b6o78jceW6caEpl+g6qp9Fi/DWxZGo9LqIwHSq
	KmVUE+7LTVTqRQu8ePPB45EBR4zobDFsuMctiluZr8jMzm2ZBDLL34YAGB9WNAc0grvJrtj
	W8VLZnS661Y1eZjDCUjF+IiYNKrP2v5MXcm/eGw2syLUVos8tK4hdZXaS9PTh7JHTJ0LVFQ
	fNTZPYtxf/tLgpHI44jJ3XcLXK5oow2D1dXMfgj3mXJbe1qVGHWJaQcV/SeVdFQ1sfzhDoi
	UG9DIhfstVFZr9e8+VC8jYHZnKF6msvYsD5fnG9iE6fTy69bwplamNPBVtTdKA5D/hXakh6
	BzAW9iyPacJzi7+Ie7WL9iEEBxvBnsJmgBJeUEyGo+hg1ByYLiMWo7Orje0URLc/eaAzUvO
	Bjcd4h9pKlRAExMMj2vRYglwRl90jL9UEymH6n07+ecpZ+QbRFB1tM=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
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


