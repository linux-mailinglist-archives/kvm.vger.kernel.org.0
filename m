Return-Path: <kvm+bounces-52501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9676B05E59
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:53:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3661A7A8116
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AEB2ED17C;
	Tue, 15 Jul 2025 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Wjts9OSm"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCC22E92DE;
	Tue, 15 Jul 2025 13:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587120; cv=none; b=QG3p+6TA7OHWd32liSB9PGgoNDa+AufcziKOkIJGs8FB5h/U7KarCXNBBSKAi0Lk6QdnWwoYyJScNUF4CT84J58YMN3IFchO/GxyNtd9rAr3CWXVwHwuDTc8TRkgrNS4TqhnI2chPRh5pTF5ueW9RG12I3LN8ZbIR+RLpLglMyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587120; c=relaxed/simple;
	bh=RKQYS8TcAZiYvGQDH+XpT4TCxWolbEbJ6rXdMaVirpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZ2yLdlllo7k0vqZauN/kpKQqES/M5ztWyw3V795+Tp5pIco52ZSuEXlwIpEyoC3ELcWs/jPq/biFMYpq73yzyHA5j1fbO8UFiMD5SLJG+gZ4qRwWkS5mKh+c9p216J5Jj2+uMiL5LVjaGF3Vbb8PSJVW5fN7YqkCUKgDirEbA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Wjts9OSm; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587112;
	bh=rQmC2fT7t1QerTXaC4lb+PTlBodpE334vwPD+1BbEVQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=Wjts9OSmF7J9zue7nrnsfbwPy4jBQa19CYFuWNOu+GAYLzB8oiQzzn/IQM1Th1ifL
	 MaTehwZqOKTa42CN3YCHmDt4/y2iccWutlqeNvrp/ieG/4Yb/A/55TQWqpiDmgzUfH
	 DD8EnZn98Es6TBnbwoF46gEDIljEHMmZArX4c3lo=
X-QQ-mid: zesmtpip2t1752587098tca5493a2
X-QQ-Originating-IP: bz3FlVgOsDFMU4yP789akKxa0PSTuDy5vUHH1rKzucE=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:44:54 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 17118280138594798834
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
Subject: [PATCH v2 4/8] net: mvneta: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:44:03 +0800
Message-ID: <41013AF60AF9B5BE+20250715134407.540483-4-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: N/oS8x6X9nHqMyCLlGbQiyxUk63ZoEalqHox6ZyzAtybc14XFfqWYanJ
	h2T6jA6dC+ZjdnzkTGgyTfCY6cfhD/7egYoZPVxZYpYGjKj2TT9koGty2rmi/3MFn3An3QU
	r2CvANAAgZyKX5+accYIsngdnHi2cU2OzP2LQlZxLAAsrnHrzp0NbjKNnN6UTDhBPgH2SWP
	Luce5VBZH0e7bcYIV6ZlZzrI0POX/nqUSSBUsaHtX/eKOH3YzmWe2/jwQxUhxcxqCwjQjn9
	oWelG3UpN7xQxJEXoZSr5jMGBCbGCR3g0L/mCRVmnh5vORaxZPahnWK1CXVfLqCyA8Z+mCU
	sl9MfwTJLT2/cVp688IKk8tTPFUfRUW9hHchRjf3sVZdkpat2cUuuICPBeSb68FOPdM+CWt
	K1T90H6XEtVQjzpGBiNfC/Pdk2SC0R52D9oCK0rBVeND/soVm/IFKp7GHzmrcClBd9ChnTg
	hOZnXwNHkPHaHYEKrNnEZ2pr94z5GLqxYjnlNibZMTadyfqnHr8iwjDydjzv8kF5wzR0AXI
	bEcE8iVM6wL6wvy70209gdTVZL7Rhf59WfJZwNfMg4HIRY3xGJikdGLhbcrDVwKZFuDFuzs
	lO7pwGRMLkbdAGhmty1O15GyyQ7P+pQtQUalqPDAa0C528psRfHTWPT72xeWuwKm5DOdEg3
	LxwVeVVSQKNuNV8T1lce7Szff+0n0Be+KvSIszqyG9omGFxnVbaFTgIC4t8Bm7C9Br0+VLO
	s2vUTPylfjCBBmKAzQa1meWZgoiDtL6KeATYcRD6HL7bL0ryKJr5V0tYfg999ZaBDfbw1xV
	LubXen2N2BVpCK++D4069YJlTaXFYpQDa6wesiXK4wvTZ7RPfvTXapC1UP28jcL5iW/0V+u
	loNU1Mwi31eJHHtLi6qhX3TFxQAuASPI1ysRc1EMjFiDofDGaFtX4U+i/RWBePsaU049wJC
	MOG0hMujuw5ABPe/rvB9RwvcH2hfQig8NJkJgW0ZwI1RKOijVh/osLwYboP/mGcZyOMJGMk
	VNUpXYgfu9Gccs1Rhfl19NASmRylyqqzd2LTE6wy4i+z8eu3qvwj8fCEa1zWRf2I0uVUAgF
	eMvZe+hq64XW2n11amE7DOeRNVbny4flvtlHLzBXfb4OEtYL3EquZM=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
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


