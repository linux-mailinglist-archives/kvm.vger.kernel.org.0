Return-Path: <kvm+bounces-53090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EB6B0D385
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42F853AFB0D
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2DC2D94A3;
	Tue, 22 Jul 2025 07:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="iSi/eWuq"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430AD223DCC;
	Tue, 22 Jul 2025 07:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753169759; cv=none; b=m0X68hVj1AYnzo8l+TJ0TenyRW2buM6SjQgXqzz/Mk3TWifQqZ/PHz/K2Ua1BFbHIppyHGGodw979vzTXQHKSOxK/M7SgM6euHnsu43DK/I7yaarZ+v2DOhioF3WuxGs+CKW+9YMjL8z2UO6UZ/QWkvcQ+HW8ejZDNAR3idBqp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753169759; c=relaxed/simple;
	bh=XoTSReRIWl23BljKqA2YUSyIT3NJWPVLgQNbiD9Lm4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzoUh3cDswTOOl+14XGKzj8cukIlXyqEeeX+7m/nyK/fNPN5XHO067vIZlLk2dn9JUegsw93/r970ttQeSaxAACSag+Nn1lyp8qXlRCKvgI73cnwS7zMpmDgy1yKjOgWl5jAbjhbrI50Zlk499x2SiNKyywgVlygerybeoQl1/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=iSi/eWuq; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1753169746;
	bh=1DFykB4IGMZc95pr0nP6WV8K6S5/SNh6P26mZWnTYNc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=iSi/eWuqri2aE/KeHOMA4MRHdoWkRYYQwalQht4ELhrq3ORP7LSlCPnBsE75bthE8
	 6mQKY+VT7g4mvlxYm4hhce2FAp01CCqw5r18ibyNvS4w3/Welf2dNvgSgMf8UUmREd
	 yEyyUmvLnhfSqLwqvoy7rZ5ha/vWIv8R9x34PEWQ=
X-QQ-mid: zesmtpip2t1753169680t1d8848d9
X-QQ-Originating-IP: /2Vqiv1DKGDiDTOeHrTcoDDvJdzpiY2SWG31K/OjoKo=
Received: from avenger-e500 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 22 Jul 2025 15:34:34 +0800 (CST)
X-QQ-SSF: 0002000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12305455310709652104
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
Subject: [PATCH v3 1/8] KVM: x86: Fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:24 +0800
Message-ID: <7F05778C3A1A9F8B+20250722073431.21983-1-wangyuli@uniontech.com>
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
X-QQ-XMAILINFO: N7ocEKovc9DwzuBR71YWzge4NLFCYxzX60byqgkLEWPhDeI5QVddI4L0
	jTv6Bb2L7WfRatPBUpfuuNwMsKJP56JzMDZASfqghMzNUK/MKBUUkirMDPE97MYJ7z3sW96
	waOI/Zuj49Bz0jXWXnoDlKYjODFt4Wh92I/O7H9aLDAFr4MPR9KGAhLrK39lIufrWFacOdo
	Sm2NoONk4kKT22Q10QOa1aKLr9PmQ18AbU1Uqh5djhAkuiMKEJFwwnDAHsuY1NVscJ/S0Ad
	8hl75cWWOQ1SwIFYdcDd/RR2vC7UJJYAAgIuQd8Fs8AcXb3ucZxkiw3zbKBBzvb5dxwymMt
	pNPkBpJc3IdWb2zU1TAEzMHPfhOWNKhRsL/qGcS2jb7ev5M7dl109GfP31yXcHZ0z19pqhZ
	Og7Q/tKjV7VZv0/VPIhKKVBKmr0oMtoXrQOjjMQt9vYiFh5VrkyhV4yW4y5950bJvEsCpV1
	O9q324dHic/e3hgpD+NvalwtVpFbKraaTHwM6D3UmWGoLeMFDwul5htuw12hW/cN7v//YID
	z90NhmdvW3FgRvMVaJSuNWulsoBcg2FT8qlA9aq0I5bacdHzH5170T9R8j9VKqGPUl7WV7o
	7u5jHGmWVrx0zdnb2I83dXjjGNYzwiLcS9AzM4GDat0K4KtA2TGfyZ6kvvhTIy4XfpwMtuQ
	0uEcgpUh/vYmWR14ZnjTbfXg4h0LYeO0Adb7u12C9XqSomVlA63NjHOD+hHH1xg11Z8BI7n
	r1ZcSvwWAsQurq76OELZamKwvpSTbcqkyLiXm8lOv0iIP8ANbkGeAkIx8bYeq1AzTn+XEXm
	hspzorKDzsfJSQXbpJMvsCub+WL8s6gr6PHHHxMXmF8+EkuDZrpx7tCUeJ9L9/Txb7gEoco
	O+ozoSvMASiYyqzJy3gJTSZcA/mHIG95j3qPyYGZxmD7eOAT99CBxFWlOPFMrdjgLuHaqPX
	migNYJ3y9ZMdmC1YMkzKwp/hbEm13YR9VmIciS0Bu2Mkj2eC1Hbb10m65IjXcXU0G7vqorY
	LoC7i3AHtQdIWPmiPk4S99SsftiT0UT7UXu8JkdIOLcsLZSpP3CmEWEC7EQ2oT6U38/v3mt
	OQYhD3Bzc5CXiIU5gHV/aQ=
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
X-QQ-RECHKSPAM: 0

There are some spelling mistakes of 'notifer' which should be 'notifier'.

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


