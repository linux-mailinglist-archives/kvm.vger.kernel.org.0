Return-Path: <kvm+bounces-52503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C16CB05E6D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:53:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D9E67B7BE2
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 318BC2EE293;
	Tue, 15 Jul 2025 13:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dt/d39U/"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7972EE273;
	Tue, 15 Jul 2025 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587134; cv=none; b=ZADgdm3gBf0xuNxgFYpkr1m9abFV226AJRKeYpoicmTNXRDWgxK2+gRZmSzfqIjiZeF/3ITeXmWlveqsIOV9hYqtIRp4nwNIx5sWrjaQJVFLUZ0ziXx2n8gbrs5dKy/8Xe8J5EjKCoNTdjt6utnt2rkBvBySvAt4TED4OVzdNi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587134; c=relaxed/simple;
	bh=PESbSQ2riBmWnB3ifW6iRWmYUAMSpluf1ck6gekndAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGbokfkcew7gHk0RrzKhDEbF0dHucXD9TSOxe62ltsB3sH4FBZ/1yrk6tFFyZaWcABEv0a63ajYScfqHzyciX47K9tHlYK0HPw3AR9Fe4duiEbd7wV+vbh/9daYEoG6f8QsERgAnyLdhqHgy2THoxbRsVh1qNyCpmcd7Cj22IKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dt/d39U/; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587127;
	bh=DQOAtGRHzOhokt1byV1hDfgfMVfreeOvNYgUQQUEI+w=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=dt/d39U/JvCGRYvJywjrnl6l+GFiWSoghBEC8LTHxqR9Qje6oIFcAkRizOqLdSzXs
	 GMHBh5+6oynlPBWuLPdwN8DzoqGlX+xfe8PDbLUefu65zP9IgoIjFczk1dMH/QJHiX
	 Fa3X5qoKmbn21HWedq5TPEsnWWmhrHTAmkKDcYFU=
X-QQ-mid: zesmtpip2t1752587114t4242d337
X-QQ-Originating-IP: bUZPMnhKZ8NU12puD/0nV8FvyCDfWloR8Qvt76r6nV8=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:45:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17289734867236313614
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
Subject: [PATCH v2 6/8] serial: 8250_dw: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:44:05 +0800
Message-ID: <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: NsGGqG9YEWxp8csmZI23l1Ki+X9sxynR3N7bfFfThHvM/DTHwBdgfgTd
	t9npfMSJTVokze+9VPL9BDT7t6/xBcEeRUlrgni5YDBqPk75Z6CWBj13SjUdH8OZ+VVas0D
	HTy1VDFuNs1oJkprzrk3ry/rUbTamDrsylnPGeWRdBXHOyrH1HIpqarR2MIBI1E68A7zVqs
	FTMBw6yFqUnmHozmm6ursuDeI4c0qwIWRSEb2aWoKasa792ua4XJ/hfvz4VZkmBAi305XwT
	S2PYetZgVHtlMI5VCr9KzaLNyg8lVOL4JgXyiDOcBlz5MlvXgy5EdE+2EdtWcOxvSel4MNt
	mVCeoKQvpHDJ0s3ecoZE24k1nJE01JgXmt4CJq1F+PLf7dDjI8/DfB7G/25fvlIF5hn65Ow
	TUsnTtnOGyMaT1IeXGfq6scg+FVnzzZ8rP2KLwgbf0eEcIZlb5JUpwULiH1GpYSOxeQIuKd
	kZfV1jBK8rAJgkvhKkM9wy3x4ZgjeZ7wpLiFEWFkSET7Myh7tDzNG9Tq8nuXlUOZKrkEljX
	LeefhYNjqd/u3KqFqlJz8tUzLv1cLO4NooHiXD/nf0UI9akEOugKN1ywZhAAoJduGE5IUKW
	sNYT2iczKTMGywUn5v6keKrJYEQn8fD81XnJNcpeqAssrv9j8Lr2X/MTRORRGs/bxVZ7Vca
	Ht3AHvnh9nmjnmoUO4d8gr4bVHther9LdgrVfcIrHQDUTehNRAA7hk07uekcxc366LDLxDW
	G0GTVg5SgSOkvKEoAhD3ojVRftPxXjQTvnxA6HfTtNkxgpoM5eCst0DOtXmRa3jlJulyv2C
	+Z8+9+rVl3KrFdNX/jRjxlToEIaWrc9hgCzLz5bxHnAJpjJKgOsYZZVN76dmJD9gsnVPH3s
	tnbVd4NlGDubdRCJZ1uBUKr2Ib8UcpRYRTZBg7Wp51Hwa6rbLR2DagO3z9OeZLN0HOipvNZ
	QYQ7tshrHViQdLNzeCcigj/RgsSZQ8CYOs4emLzvN9h1u0vwMYYSg2/kwIVXZ38l3Q0U7wZ
	DMx/bmxrupGZwhUngXkojShgfhi302Hg2lPSvPvinMicsi2NWXlf539KfSDm78kZswfz2dQ
	lbN3/v1j/lCIgp1GkrxYcA=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
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


