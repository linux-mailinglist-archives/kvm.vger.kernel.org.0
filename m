Return-Path: <kvm+bounces-52499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E530EB05ED2
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 005C516C70A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 248AA2EBDE4;
	Tue, 15 Jul 2025 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="UkkdV/Vg"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A432C2E54DD;
	Tue, 15 Jul 2025 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587089; cv=none; b=oL/nW4b1Ca6xEB7ciXlHEACoqRejKKPAknoCODuiRAU7c+LWjvOb268oNL4/Cm4fknSf4nj/f+qhIOM6fBy56OMiup5x8L4M9jM4vZOFdufVcDPL7o4e75fRkR4826dRAiXzz9Yt9qjuUPgrvKtEkAE0kKwrpk55vhOXPtWM974=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587089; c=relaxed/simple;
	bh=D2pCaySHFq2pdMF2MaFrTGbBn8HmE7zZtjbdOo8bZ84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLdPusM9OzNZjiVESw6qqXxM2dx7ypseTCyEn0TltN3fAMS8kMyOmpXSWEZqKY4Q6W/NCfjUKrE/9Sfck4poOOF73rNeaqoANp6T46tz4VKkXVkPFf1S4SzKobC8qXe13h1YMiOsVrlOfBjwAQ6DhiM+3AASTZAx5jeWdoUOtq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=UkkdV/Vg; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587083;
	bh=qr7vnn7eeOCjc+CY7+06nVMi7mZA3SUUNFXvLriFWI8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=UkkdV/VgT9YKpmv2p5vCzhYaVpPNMkTX8GU0fdtGh183IOIzn9iWaPL4becCONlyR
	 s43uF9oXmg3YjsPvDlW779xjH/LG+PEAabjEnezN416RkwzZ4pju1PcysZQhGIv5FT
	 G0kyMpntx5Z3tdclegBhwT/HL+rWuCKp+/xojhh0=
X-QQ-mid: zesmtpip2t1752587071t6eb91e5d
X-QQ-Originating-IP: F1q5g6EsDf65gITeUTv/PWZUZ0Adu/pQEt6UQ7FSUXk=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:44:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5398797519423429951
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
Subject: [PATCH v2 2/8] cxl: mce: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:44:01 +0800
Message-ID: <65FC7B96ECBDB052+20250715134407.540483-2-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: NOt1V41YjURb+Hfv111xRCC8jOETUqC2JW5jYThDnIhuwSMTKIDlwBkn
	fYDUbKteYRz+mwgCci9yCMJebw84VgkijaeSb4mfW82dnN2U0f/oc9+fUC8Ft0NcStjdOF5
	R9y1M/yDFmiKiJkthtZXCBNwpvNmjauDf+0RDToLT/6wPPZShDD0umKu+chuWb5NgwJdC6/
	M59O6PolRhEHCEF4kLIVXzqweOdiCT3F/YcQTJTblTI4sBzNSLguYlIuaI2KnM8+WsH1bVq
	540Pd9SWnOl1bKu/xaCCOcm1OM6xjw+a9ZKyGnFiISBMUQYJayMzntSNwy7Kp0CJByyrEka
	1S4obGQiFX2FDMstwmZcbKjveSiQ/FriaP5WHyGjqUhv3xQuw/O9sxKjr0SI5+W45V4atDm
	L0kYQnncLTgMozxYy8raqj21tkSO6c8rsKB0V1q7X6pJVukVUmg3Cxn+FnOEKcF/XBj+3e9
	/nx0gcn/p3DWWH1HHOFVONffAV6EgVrAqCqSai0yeI5uiThQeRQFTp2ClfGI8E2stI4Owhe
	6Azdr2us/ecJRwAwA6dNgvm8EvBZPDP/mRC7h6ETfz+tL0Xjf8P6qpmuaeAnij949cH5UcV
	dDN2fe7CS61gnDDC2gRrVty/Ilhmn3rItOM9KKmyr378Ea1hr+5/qDUB++0gn8nMyeEBqTB
	BYeFKL6FRWuEDrlOBBDp8WZFxozjMeolrzPktjfV4/A+F4XDZNXAfsoCBkRM0G7jpHoYJK9
	5VisYY4ErIzk5Lftjng8bSTxhQLF2mNZ7lvMoUoWfUcLO344K7ToXoiV37d8Pr0tq4zd0WY
	kfbv7RxKj2m7+p7flwX+2MNAyjUe3WGMfHrXMvDM12Dku6O5IFQTmEKUJ2oKRrmmlBAqQSO
	pmM68ne8dXhSHp+D6ko2rXqdYWWBKhbzj/bA0xCyLSrdeLh3OCwI7ZpoNlnmNaao8Ovdh93
	RMckJeYKfO0a7VBZ/W8Q6BmQMNjZi1R8VVSso/tiFWniwYzjHCPdLW81CVYISK9i84//h3R
	Esf701XCZ585qC61AGhHXj0UJByPWIwkqd8cxcZsie3xfx2HyxM4W0Iqb66WLaJm8+FTxzc
	TGg0oB0LI/xVTswRX8jRFNQyJ4ThUD+QSfu3FpcbPdNloL6RHb+W8c=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

According to the context, "mce_notifer" should be "mce_notifier".

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
Fixes: 516e5bd0b6bf ("cxl: Add mce notifier to emit aliased address for extended linear cache")
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/cxl/core/mce.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/mce.h b/drivers/cxl/core/mce.h
index ace73424eeb6..ca272e8db6c7 100644
--- a/drivers/cxl/core/mce.h
+++ b/drivers/cxl/core/mce.h
@@ -7,7 +7,7 @@
 
 #ifdef CONFIG_CXL_MCE
 int devm_cxl_register_mce_notifier(struct device *dev,
-				   struct notifier_block *mce_notifer);
+				   struct notifier_block *mce_notifier);
 #else
 static inline int
 devm_cxl_register_mce_notifier(struct device *dev,
-- 
2.50.0


