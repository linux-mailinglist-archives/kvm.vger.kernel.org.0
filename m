Return-Path: <kvm+bounces-53089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C5F78B0D300
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16A2A1883527
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC2032D23AE;
	Tue, 22 Jul 2025 07:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="SEf5Ikf3"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E3F28B7CC;
	Tue, 22 Jul 2025 07:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169338; cv=none; b=XT5EyAesTKGCuGznTF+IKYZCYhOrBWbqpBIG/yQfgcgOlEitN3reiVfaylOQJiWUGjf8g8pOXY+j8V52wOiYjmjsM/N2lhoQAWBHISdKYiETf6B319zruRdjKjab/XKPCycFTvrWevra1XdRX5CVQCRFTkMk/W3rqo2R9oH1lDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169338; c=relaxed/simple;
	bh=BZK13xTTjt/5UmV5jMd6YK/1RBHQ5TbhsdLSTIR7ksA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qhK2u72/iTh72sIebQRIUoge0WjcvJULc6DQvJw/RUU4NlgOwTZlxgBRAqULScnMZqrLIa/3tEiSAh9e0IoWo8sZauI/7jjveVYdervQaMTUIXVi9QZv5mWeOcLzJFgdofeHN7ZyQb0nJH/CtpnYkOv57e9nQIoj5SFov0lYPko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=SEf5Ikf3; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753169325;
	bh=x+S0lLyonKMBOYVe3hwfq+3jtrctPFlVfJ/rovDXpoI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=SEf5Ikf32A4aGlE+OAr8Dh5+t8GSbdDKQOuxCFSVVn+Imhs2GtfwEQtewvKAiGXoo
	 jA4sdSxpoTl97KN1ufZfz5feDxSF9BxvlQWAyOJE2njO1wLW+TZ1gM8x+HU964jofx
	 ddqJk/k0JVtDK5Thug2vwxKesIwQD6GF3lEbivto=
X-QQ-mid: zesmtpip3t1753169263t53df68e6
X-QQ-Originating-IP: rTOvj0yplF8v1TzV+LE7s5Wipo1URwqutr9CN7Z1bPc=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:27:37 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4379188185935626122
EX-QQ-RecipientCnt: 64
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
	guanwentao@uniontech.com,
	wangyuli@deepin.org
Subject: [PATCH v3 0/8] treewide: Fix typo "notifer"
Date: Tue, 22 Jul 2025 15:27:34 +0800
Message-ID: <576F0D85F6853074+20250722072734.19367-1-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: MDWLyYWhrZ/VSgDYBpGTTfaWvBcvfP8fpLHi2v8+x+sw9UQkcllGdlmP
	56uh4oGiAPJj/aMzs0e/cAqJ924/hfFMCSwJUNxRH4zkOuX0t9oj41+1nF75vaW5B65J973
	V47FfialPScBVysbe4ZS4p3/zYGyES424NQck5GvbU3Ty0KCF46yGh6dPYY1YAjDtb+MDzz
	a8EeF37kwGAjn9LdwgpO8zZeQIdrlbLPXD9oWXORt3ViHBL9W/qGJQw7TmYRXdTAZ+P0Kfm
	2uLk7z4hrS8Df1MNm31/bh0x9tOg83p5cYcjgNsG7n+PH7KrDWNV9FGU5ejaOl1kGqipq74
	lCyrBOUd4Jt1KUS2XJdxlGsnrLBECEQYLOB6vc3cdDdLr92D4kAt7SudKQ19nZA3fOaJnuQ
	pOhGxyCw/FXF3+jpc6GPxaVTiAQ/DgBTu94rczoLx80/fMK1p/kFJjapEMhc++e0qv33TkS
	CS2xwKmW1K3aymPLigfg3PBRQhfFkzf/i7i8XO1pbknRZgnvAx7im7QQ0y7sjpVkPba7RPl
	Zit3Rn5swvh9d/KqcWDe7Ki0oF59j5EPOMDbUKm7vom/qyXYLuEr37Cu1akWPp5UrXDC+ol
	4a5aQwZ2qE6pZ1eyMRPK7pZRyLLs5uhNAglL2Q8rDY7tDfX23dicoLn8TrSLNcmkJMMkg7Q
	shPWfiuA6aDTmJr00ua9WIQKZ7z6Mfmqpz120cWVMGY2Vl+zH4ZrD/cwss8kqaAYBfnNzjZ
	BoS2/yQ+75A6VMaM1yTHzrpx1qnylqHQsi/NW4aidb5RLA/FJpxECWTUWxnXqRlBfaDBxRE
	9g2Bw5Vt7AGlhfHrx3KP/t7IhUsAhml00WWpM23ILcfKE+dhu06D4FvlzIlKX/RW+bTkLRV
	as8vbxKDlbmEPsPgj+HW5ITAq/1SX5G5C0Xk0b+8/y5JhcGxG83WzG6I1s3kCsMU9ebkZyY
	3X6fnVq9YWMb6l3/9fbK+CxzYNZW74mXPHzOhbx2a2tnTVnJQhWhqHvBFUAjZnF5g+oydr0
	Q5jJ4NrpXlKa49L8006wPSquXqBTDz8ZJQjBtxHikovmWuNpC/ZuyibdcLmW97IwdgJMN9t
	+KWEFH7n6a7cVJtco3BlVsMeOi2ol3YUQ==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

There are some spelling mistakes of 'notifer' in comments which
should be 'notifier'.

Fix them and add it to scripts/spelling.txt.

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
  v2->v3: Remove links to my patch v1 and add some "Reviewed-by" tags.

-- 
2.50.0


