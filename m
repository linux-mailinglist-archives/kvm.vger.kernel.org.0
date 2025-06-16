Return-Path: <kvm+bounces-49577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CFDDADA98A
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 09:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 798C87A6B26
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 07:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C151DD877;
	Mon, 16 Jun 2025 07:35:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FCDC1FCFFB;
	Mon, 16 Jun 2025 07:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750059355; cv=none; b=lhDrwyNpjMvrKa18Kbl65wGcLgO8HGyaF74YP2okzzpPe/vDh3rHwmxDfBr/ScHzmX3u9GjY0i0vZY2CgCwsOZM1rno4UvlGehZWUClCGyuI8LAqwtFJJPqz0JMG3rguz63X2SrHiP+Ymbnik8BhXoa2S6IubT99i+fuY3Xy41Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750059355; c=relaxed/simple;
	bh=OXHyOQjPAclYNECK89o5OFOvELjQkjU9xXw6+X5XWRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A3m+yAaOWSUM05qIonDSTj7AS58la69O4myd7SZhyG/dnhHdUmA1rsrDNs4O/VcsjWQCyCBaxN2x31CQOWjNk9g0wiFkI+NMncwfYfGj0uwaDb58PNbboUrelL1X6axEBB14MAgTuoW4UAHml5pb3ekjXCYbHDp4KDv7fg9Ht+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxHHJUyU9oyI0XAQ--.54768S3;
	Mon, 16 Jun 2025 15:35:48 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxvhtLyU9okMEcAQ--.34084S3;
	Mon, 16 Jun 2025 15:35:41 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Xianglai Li <lixianglai@loongson.cn>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] LoongArch: KVM: INTC: Remove local variable device1
Date: Mon, 16 Jun 2025 15:35:38 +0800
Message-Id: <20250616073539.129365-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250616073539.129365-1-maobibo@loongson.cn>
References: <20250616073539.129365-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxvhtLyU9okMEcAQ--.34084S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Local variable device1 can be replaced with existing variable device,
it makes code concise.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/intc/eiointc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
index f39929d7bf8a..d9c4fe93405d 100644
--- a/arch/loongarch/kvm/intc/eiointc.c
+++ b/arch/loongarch/kvm/intc/eiointc.c
@@ -956,7 +956,7 @@ static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
 {
 	int ret;
 	struct loongarch_eiointc *s;
-	struct kvm_io_device *device, *device1;
+	struct kvm_io_device *device;
 	struct kvm *kvm = dev->kvm;
 
 	/* eiointc has been created */
@@ -984,10 +984,10 @@ static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
 		return ret;
 	}
 
-	device1 = &s->device_vext;
-	kvm_iodevice_init(device1, &kvm_eiointc_virt_ops);
+	device = &s->device_vext;
+	kvm_iodevice_init(device, &kvm_eiointc_virt_ops);
 	ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS,
-			EIOINTC_VIRT_BASE, EIOINTC_VIRT_SIZE, device1);
+			EIOINTC_VIRT_BASE, EIOINTC_VIRT_SIZE, device);
 	if (ret < 0) {
 		kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
 		kfree(s);
-- 
2.39.3


