Return-Path: <kvm+bounces-52498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15265B05EC3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 15:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB5F71711A4
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 13:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A63D42EB5A5;
	Tue, 15 Jul 2025 13:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="OZuPSAzw"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4682E6D2B;
	Tue, 15 Jul 2025 13:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587080; cv=none; b=Ubcat/P4+1Xq/LVUQQ5FdDvg1/dE+97Tg3i43X0aGNKpToEzTzEgOHmYY9zjoQgr43pH0oc3SdKqgCWMqNBDRxaXgQSMXL7EH4LMhNM/hKIGzcys7cErDc+tiB7Xj/uVUMxTJRE7KXnR81Wris6iMsQxmpHBoJkqK09c9p4uV10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587080; c=relaxed/simple;
	bh=TZJTn2E5BL5VAE49e7YaK4SCRoFGgemXPDOntw9si8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2uyRb6JBuHbLLZDFS94OqCVYpPRtBaYl2C827yiXhEtGlVotoo7RBni6Hi2Eyc249B2RTlndLJ8vV+NYfsh9e4Rwgo1ACx3R6kj/cb76U01wLipmdJwKXZ6/fFhmnL3u72QmfSa1/us3LdBl1gKV9JWKRh767/ARM6sR4LpbMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=OZuPSAzw; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1752587073;
	bh=IjnQY0kPhK20QaffYXVWEq0vHT5rpi7BYCx3cV6Q92A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=OZuPSAzw/znlblyI0bHmsoUFw9GT59ynhGDp3kiqGRyqyteMccLtaWi/wwp2jFIR5
	 m/P4hflxCxhj27DnNbJn7/ubi0zOoS9+uzS78H2Xeq90eLwEXyxKlBYGNU1fkvSXcF
	 BefoPOtGk8GZLHtZRLOp09AR5FKixg0KyATgNVjY=
X-QQ-mid: zesmtpip2t1752587060t139a5737
X-QQ-Originating-IP: /8D94xQN+8JOFpNiEQb4FTVnmmcArlmhUzeqfbRCotE=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 15 Jul 2025 21:44:14 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6857427455089537098
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
Subject: [PATCH v2 1/8] KVM: x86: Fix typo "notifer"
Date: Tue, 15 Jul 2025 21:44:00 +0800
Message-ID: <2EBE0C87C4CF3E11+20250715134407.540483-1-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: NqKKeJ6KDgGJk0Q/k5eew1Rcj/7GqYu29nqiw1KNaEt0P3kxYukP6kms
	ZdBiLJbwIe5UK/zNqfTOaeIjqeGbMNVl1IhvjNICqfNNFeuleAmqLJ0zi+E5Z3A834MPuFo
	o3/hAMFn6lpy5LA02nfq9jZkvvtZg/UwT9KjonRNZjYNx1sYrWbqZgQ5jzD4Bqq7u/zZgvL
	o4IYxiky2wiGW9WoPfZL4DM+YCbYKcRt+oJP3GrLuJpVAnlphfMwWvbRTuuPz84wLBIciq0
	fzr3LFjWeMBDa62aZHwCnU6fgTXxo2et1np+0l/5BuePHsxMYKjcKn/8qVPavjf2C86xYP6
	W7j6I24HPRciLLRwZrQwLji64KBf76umFALJgnRYleByQpvhoVNfHenQG+7uCQ5anT0cRsi
	NfRgB0z2yGLmf4z0e/CWc3BxMUaN5PxWaTacqR2Iy3VgIxt18f5jUTdlCrIYlvZZ9IQXUuO
	Sw/t0Xc+nnSdj1sHsH4ALe1cXygJIDSh8oVvu0oFRTzBdeRMLOw3V19qhHg6Fzp9q/74/8X
	M9D6mLIEEBtajIGnDRfpj9YQ7HsntEkxxcg0aNB+ugXGTTfgeNKQhLVmPpQgYpQnEnROZD/
	9tLAvy8hQcKMyr0hX/w9Day7veIVMiFYM4dXuT8wwRzLHI0aaN31T62rESaEgrdcKiGSibn
	SCaBtWxk5EnnRuH4RWrj0jieQjXkEjGgx0xeV6OuxNUJ4aYhksLXLR8vrGIn+m9G9J0rSlp
	eEKMX8dU494kaMKURExfmLJK2cS8JTGzmpHRMRc9jwHl4n4DpN2x78jy62FKiDY6BzL77oG
	GjdXpUOaFY91e+xmKjDbU8AdSkmG3fItQuchfKeviNcW/R1ufj0y/cNQKVwvWbaH97M2uHe
	KUhzQpHHs2NSJQAb4uPPSMqB6VvdPeNYOf398QVv9jJ6sJTbAl9I2afhpNvCSACF4bZscVG
	dsmhLnPnEf3B+7HENTENnA0ue5k7akqrNp3PK2wIKkPzwMGz+bC+bSAf/P3k4JgAyLwZb1m
	tJeZZbMHYQaMyuSn+PjQRUx2HVVGpFwaSkUScJwKkdb1IqXS/L3Lm9Yz+gjANX7d9ULLG4m
	slSQ5h88sBF
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
X-QQ-RECHKSPAM: 0

There are some spelling mistakes of 'notifer' which should be 'notifier'.

Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 arch/x86/kvm/i8254.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 739aa6c0d0c3..9ff55112900a 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -641,7 +641,7 @@ static void kvm_pit_reset(struct kvm_pit *pit)
 	kvm_pit_reset_reinject(pit);
 }
 
-static void pit_mask_notifer(struct kvm_irq_mask_notifier *kimn, bool mask)
+static void pit_mask_notifier(struct kvm_irq_mask_notifier *kimn, bool mask)
 {
 	struct kvm_pit *pit = container_of(kimn, struct kvm_pit, mask_notifier);
 
@@ -694,7 +694,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
 
 	pit_state->irq_ack_notifier.gsi = 0;
 	pit_state->irq_ack_notifier.irq_acked = kvm_pit_ack_irq;
-	pit->mask_notifier.func = pit_mask_notifer;
+	pit->mask_notifier.func = pit_mask_notifier;
 
 	kvm_pit_reset(pit);
 
-- 
2.50.0


