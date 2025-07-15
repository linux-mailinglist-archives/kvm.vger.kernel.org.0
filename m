Return-Path: <kvm+bounces-52497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59976B05EAB
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:55:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D4E91C220AD
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82022EAB76;
	Tue, 15 Jul 2025 13:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="FuSGLnLw"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA1B2E49BE;
	Tue, 15 Jul 2025 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586896; cv=none; b=SVNIWeq4AQp7l7y7AynCEwWelGuXtCYElk5FSWagvQRAG3InJDMUHmjylt3mbZNEudctDRcsIrJJj+vxvlQrOFA6GOFf8ISE5Hb2OQM1dpqPJAZt1Y0dBssPEb+3LZBOkE5PEe57flVojMqJUC47qKqD40uabE4eLiwafy74hhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586896; c=relaxed/simple;
	bh=7dSG76ruHEHqbRjXtpbZP2fQrkMNdrnwG4/ymtpfEKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IX+G7jgcTI0KHTFLTtXpYY03Z/5rDLHoL1OrtQGegQ72yO79oE0CRWWJiyyBH0JULHW4JR2qDutGRQDLMUn8Qxb7MaD2tiyv3hh/K44uE9zk/OOuqrH6brWZWtsf83MPeiez/kHEsOFtqUpzlu99PurkUbbVHlycrYNx5/HithY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=FuSGLnLw; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752586877;
	bh=DYh+6PDIK8SljIBmyMHrXvBMyc6UvyjoLxtRvLKcLYw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=FuSGLnLwCgAHTPyGVASWNIky64prQYBGC23iLTwJaxSXF2msqdPe5oYgoHClHMjNJ
	 5jf6pn/sdZvM2ROoK0aOG8bcnlxOzGOhJhgJVveAYgoF3H4us4KUN8Hiz2cHR4q8Yp
	 EkZeBNRjaS9QdvY/QRZfUBTVHqYWXKOCZC3PZvZ8=
X-QQ-mid: zesmtpip4t1752586865t2a0dea2e
X-QQ-Originating-IP: vd1RqZ1Qgxy/7VfOTmQ9xNBTBKWDttmC7/G/8c4FLA8=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:41:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13011556839216271353
EX-QQ-RecipientCnt: 63
From: WangYuli <wangyuli@uniontech.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	marcin.s.wojtas@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	arend.vanspriel@broadcom.com,
	ilpo.jarvinen@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	jgross@suse.com,
	sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	akpm@linux-foundation.org
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	wangyuli@uniontech.com,
	ming.li@zohomail.com,
	linux-cxl@vger.kernel.org,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org,
	kvalo@kernel.org,
	johannes.berg@intel.com,
	quic_ramess@quicinc.com,
	ragazenta@gmail.com,
	jeff.johnson@oss.qualcomm.com,
	mingo@kernel.org,
	j@jannau.net,
	linux@treblig.org,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-serial@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	shenlichuan@vivo.com,
	yujiaoliang@vivo.com,
	colin.i.king@gmail.com,
	cvam0000@gmail.com,
	zhanjun@uniontech.com,
	niecheng1@uniontech.com,
	guanwentao@uniontech.com
Subject: [PATCH v2 0/8] treewide: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:40:50 +0800
Message-ID: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NZr6/RNpGK5SfqfItW1gwmB4fdP/yaAI8BjxMzEyrAN/+7gEvhmt0TO5
	0K7ByGfAqClW9vCmLuSNyyUVSzzRwkYLG/gYQ4vO4byn0Lz1QU9CwoKglBUVQNqE2doodzZ
	cPNHxwX1XRPNLRftosOI9avSKMFhETTLTlehLeuZF0gQwFDDRVb3s5AK17VbCr1A+vXdwOJ
	tXLyt274inujbvmrXWU3et9c4dLGVFBBXLW1CuNhUsreL2lfIMMi0I/IhKuLvJFuxgzFABc
	d0Gnn9Fgn/EiwccYAONUb/umCyi18g4q3EbPwEzfy2Tn39oQTV5xE07jru4PxNZ7LG1gEu6
	9fR4p+gvPak5lDv9r+ScDPFUmNPhoyUe56DeifyJqXt/RoByUo09qho/Vq8uYOdqtnI2lWy
	CX5PYhUwBfFLRLyOWJCDn5f9O3gXhz8ctHjdA0nS73Hst7LXWkLRbCLMT7U3B9q7NJSIOzS
	JjGWgmXcKQVL0DczdrFak6soVaQxYIH/1Wc+eRYUZ7uQ+zbmwa5dti8MqLFxbHjyHSJrZa0
	Xo1zxLX3C5v1zlhJ17Nkpa682+ywYCRgysZs6Yu3vB2wkuynZb4AipDNdTT9hhQWpO4Sv8o
	Weti8SwnAMIxNg23BUz/FNK+JJFeAxB4cbrswbPGKE864TiK/cgxTKQdMH9enn76s5ptsXw
	N9PW1qLRph0GXAuxEoS8OqGgSuY6mXwG5G8mxnhmmUMBOEufNeS3RAcDrEf1QTTnpIzRUCM
	wcAAs6xYI71u9lGwRJcAVv6nWdUrC0GhEWx98p2Llz+brQ1f0WUavFhHQE6FN1nj3H7VzEK
	C3Hdq8YTEPaLZIvehVMmy6/rQfhq3VFR1Y0dHoVQke6M7MZmCYpe7N7N0MynrllAixMD7Wp
	3WcvwHn6POrNhAot8hBk3cM7hBh75FFtNN8QR3k/XrfUgR8JkPUrKsC0Fva5p36qiRU8TTf
	XSNyts4gCKapy/cBda9BqZRBsXLeRMcS6+e8GKgTeY/QcVGA5Vkp6a1+PuXWnW5p94EI1pp
	HcT22YEIYBamPJaVUlnWoI1r7jXunNCCyy9TRbHgGXlvbT2U5TiigQHnWQ9K3T11XB/lUEA
	LiACin1OKKECMA09cGsm/Q=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

There are some spelling mistakes of 'notifer' in comments which
should be 'notifier'.

Fix them and add it to scripts/spelling.txt.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/

WangYuli (8):
  KVM: x86: Fix typo "notifer"
  cxl: mce: Fix typo "notifer"
  drm/xe: Fix typo "notifer"
  net: mvneta: Fix typo "notifer"
  wifi: brcmfmac: Fix typo "notifer"
  serial: 8250_dw: Fix typo "notifer"
  xen/xenbus: Fix typo "notifer"
  scripts/spelling.txt: Add notifer||notifier to spelling.txt

 arch/x86/kvm/i8254.c                                        | 4 ++--
 drivers/cxl/core/mce.h                                      | 2 +-
 drivers/gpu/drm/xe/xe_vm_types.h                            | 2 +-
 drivers/net/ethernet/marvell/mvneta.c                       | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
 drivers/tty/serial/8250/8250_dw.c                           | 2 +-
 include/xen/xenbus.h                                        | 2 +-
 scripts/spelling.txt                                        | 1 +
 8 files changed, 9 insertions(+), 8 deletions(-)
---
Changelog:
 *v1->v2: Break patch v1 up into one-patch-per-subsystem.

-- 
2.50.0


