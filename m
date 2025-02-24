Return-Path: <kvm+bounces-38985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E76C6A419CE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 10:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08DC8172BF2
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 09:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771492505B8;
	Mon, 24 Feb 2025 09:56:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8CE24A048;
	Mon, 24 Feb 2025 09:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740390985; cv=none; b=rT3hETUw6Vv/gcFN/VpHXfuqUoKBoG+EpA0Q8OmWBpWHDoBmu74t826Og0cowqwar6ypc24eMix/X2zNM/S6ASeyCc7rrBlIbeP9kMjfhfH0Gk7f/fspFEG821qZSQNLWpeSD1fINvY2fHXqybNWArhMse0RcYGUgAW9YI8Deos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740390985; c=relaxed/simple;
	bh=jr8k2chuEf4YyG2CznmAKtkBYn7Y+zMKBFySaDiAy6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=anUYPS2kSfahUtozlnBqm0ZYWGZ+fVu/Ilo0dVZhAtP/Ps1MernVPYMuQ56TXjaQBgrIkeCGSe8Mjhbk2z1xwCTkH27wRcdwVXTSTml6VQyW/DEs7SKyfVAiCSA4yOtDEL1MCwLoUcC9tX5PQjn8JLaNRGhlP9TJrd/WDufJUUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxGHFDQrxnJq+AAA--.24653S3;
	Mon, 24 Feb 2025 17:56:19 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxXsVCQrxnRBkmAA--.9703S3;
	Mon, 24 Feb 2025 17:56:19 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] LoongArch: KVM: Add stub for kvm_arch_vcpu_preempted_in_kernel
Date: Mon, 24 Feb 2025 17:56:16 +0800
Message-Id: <20250224095618.1436016-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250224095618.1436016-1-maobibo@loongson.cn>
References: <20250224095618.1436016-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxXsVCQrxnRBkmAA--.9703S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

Since Pause-Loop Exiting is not supported by LoongArch hardware, nor
pv spinlock feature is not supported, function kvm_vcpu_on_spin() is
not used. Function kvm_arch_vcpu_preempted_in_kernel() is defined as
stub function here since it is only called by unused function
kvm_vcpu_on_spin().

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 20f941af3e9e..3318a55a0699 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -364,6 +364,11 @@ bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 {
 	return VM_FAULT_SIGBUS;
-- 
2.39.3


