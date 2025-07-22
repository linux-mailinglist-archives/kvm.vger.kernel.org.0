Return-Path: <kvm+bounces-53095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A79DB0D395
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BA116C3FD6
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D00D2E11BC;
	Tue, 22 Jul 2025 07:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dqE2pLo1"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBBF2E093B;
	Tue, 22 Jul 2025 07:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169790; cv=none; b=SBegMCPuoIN0Pzw1SkUh76F/FTLeEGv1sQMJSWEQTJNHO2RRMfgCMqd/Sl655msdV2ha6f7NvKwE+F1QchvnEOIqGFQNI8BxqASrJHYQVzu/gKgXgUTRgD54j22McBRXxsOzhEj3ABE+RuBP3gVc7HbIu0fWsSKpGLWkQSTlDBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169790; c=relaxed/simple;
	bh=kbyo0H2bbsDviUujpmI40aEKink0Gsb1aIkKzjjCyK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXI/hLZnutJnTnKxwat9jr0HdZcLK39Zb8Z0JKw0F/1mpsn8bhnG0egT2KyMZc5TfXurqrTWEbji9WwcYDIKu4bnNWDkkR6D3P38EyalOZrBl90v00ZLOeEXnl7EHukD7G25JVCfDgm3kXIsLx/psrki888O84ODNmroh7PYDsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dqE2pLo1; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753169779;
	bh=m+UXxlrjT5dODP8ALqZgjPieqq+D0qMqbX8YRGfdS4A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=dqE2pLo1GjJWCEJVKOtBp5+snB2/ZS8R8Sxc51OZQU4O2G+sv2qQ2t6aQIq0vYtDe
	 /X/Y40fVAlCHWs7JudHESp5Xt4MV7HIMQsZZnpNzuv1qm455uN+11iNF7HxTYwByAx
	 HmkyKabJYG+Nb4XnRtKc7QxoZ2gO1cUrqduLW50s=
X-QQ-mid: zesmtpip2t1753169721t82d79e29
X-QQ-Originating-IP: VhBpf0Yvw5Lj6PbKLNVVhr1ZGW55NX9MRAkCLXPkiaM=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:35:17 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15702502862464076907
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
Subject: [PATCH v3 6/8] serial: 8250_dw: Fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:29 +0800
Message-ID: <BD4804BF4FBA1648+20250722073431.21983-6-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: NIAVQ+LVmp+4GbXPMPBhac1/AKss9GrAfTqJv05vEDwva/C7TY7ErJXS
	pXaOA/PWZeVpe9kHq+AxA0m9Hz7qVJ4iqmqNsXCB2a9bMh9BD0GL/sRFtJg1cR+ygWsin06
	vphBEDi9t4Aw4PfTKYUOTMxNXT/yD+L3zDiihd+YGWFkx1YAowzFbagU5GPMkL61iaVFvAO
	/yoDJHgL8mVe4B9HG2QRIi40kAv0CSzYXd5P7zeaPC86I3GNr7X0vIydf9YfEvGxRvsR7zr
	lnLGWxHUXvIO14/pEgWATxMKNg/RwHBzmjDWSd2KGyK6PrGopUfaATrEnOOpN3OLQ14b5jc
	tyEGztMF/iUT6c6GTLXYabY7RxOy8n4juo1P81YxoFTIH52SSTv3sTIPOLO/EcpMmKqWLjS
	wZA0B2vKuKM5r3mUItTS8xNguwm51WFARVmYQ8/HJpKu9hhFkP2xLci+rYftqbBxvJX5Olg
	FAyFNWkgps9dMPXohp1k3v/OnYP2yAWRzBRb+4Cf/Uovn7TzwfRvVukHNC7LfyI7HSVYnsm
	XBQCqlSSlOnHZd76Pi6plArvo1K5KT1nZqgsyeQRsxcVDcePoUuxyYLwPFWzRCyrut01KkV
	6gKcIFfsEfZTx6AVKeNpiJ/MirLV7tkrrhWYvrDUuv6K2YaBGDbCn/QEH/gIZGguc87km4a
	E/iurupAvojXyLtKYzbk8+PG4ZXSXH3tnNDL7+VOxy4DIi8eV2xvw1EkBgaljkWp+WKd5hc
	RSV+6QUnVghu97+UbelJk7ePy7r4Sm5xFQCZIq8W98qA0aQ5K9AnScicpwkGECtaMhMrIHa
	18uelfUBJegeoRPAZ36OvZx8FAbo8cv8/KHdlqAt164hYtFtXume8ZOJy+vBhtdj+kOUoB/
	oS6bMFyfk3wTDsHKm3w7pIMxViEoG9pbZ1lIih2tro8u3lBNfyyICHC1230nvQ+pFR3hUi4
	ZkZ+AVydzE3aO7tcx/mP9ziVb6+A+rq9B8EzpVJa5Xg67p6v55P9TqLOjpChuhOJGVGim4e
	KTvqVitmGq92Pyjg1/3hufkLMVw6th1iw02lzOHUcYpxNP8nXN1qXY3Ay51q2PLQa7uKxam
	fGmcFpBMpVp1ajoYUdhA6BnJPn5zanYTot+OFScByXzTWYuCFMaD8A=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 drivers/tty/serial/8250/8250_dw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 1902f29444a1..6d9af6417620 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -392,7 +392,7 @@ static void dw8250_set_termios(struct uart_port *p, struct ktermios *termios,
 	rate = clk_round_rate(d->clk, newrate);
 	if (rate > 0) {
 		/*
-		 * Note that any clock-notifer worker will block in
+		 * Note that any clock-notifier worker will block in
 		 * serial8250_update_uartclk() until we are done.
 		 */
 		ret = clk_set_rate(d->clk, newrate);
-- 
2.50.0


