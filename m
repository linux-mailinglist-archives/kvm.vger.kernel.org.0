Return-Path: <kvm+bounces-40208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAA7A5408C
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 03:18:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85C1C188209D
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 02:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B3CF9F8;
	Thu,  6 Mar 2025 02:18:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B24E218A93C;
	Thu,  6 Mar 2025 02:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741227526; cv=none; b=hC7z8VpBPB4gLQY0mUdNIGA8KzqOBUB9hv/Dt8cBjKQbgb6+ypmLUmSKBm25nh0K7mr9B7aL+KSCpdxqGzbBxwaCE3SAab4HO6r3bPF/9oi883tPTStqfHRbcW2UEiyH62chqfzZ5I+/xoiULSeaencqpinwJ3X23zIRm/9JpZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741227526; c=relaxed/simple;
	bh=bMdJ8AlLh9wn+pe/MILqOgP8VEhUckiGvJca8sKVwNk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WRLvZB6/qykuIa1G1hOBcB/IouWc2BW53BbAUwkFBaYhgYomoOvirNZBIaPWgtkOJDPdDDnD+Zvob2L8IaQxp6qtZ7/kDfzYamNNnWJ8XGD593gKbnX+o9MFSKSqBNiKZDrt2Xbg559mN0WoWLECgMm+IQUVaCrMqS/J9GjYBXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxCGoBBslnesqLAA--.42515S3;
	Thu, 06 Mar 2025 10:18:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMDxu8QABslnjKE4AA--.11561S2;
	Thu, 06 Mar 2025 10:18:41 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Xianglai Li <lixianglai@loongson.cn>
Subject: [PATCH v2 0/2] LoongArch: KVM: Small enhancements about KVM
Date: Thu,  6 Mar 2025 10:18:38 +0800
Message-Id: <20250306021840.2120016-1-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMDxu8QABslnjKE4AA--.11561S2
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

There are two small enhancements about LoongArch KVM, one is VM fails
to run after host resumes from S4, the other is AVEC interrupt status
fails to check in KVM. It is solved in these two patches.

Bibo Mao (2):
  LoongArch: KVM: Reload guest CSR registers after S4
  LoongArch: KVM: Add interrupt checking with Loongson AVEC

 arch/loongarch/kvm/main.c | 6 ++++++
 arch/loongarch/kvm/vcpu.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)


base-commit: 848e076317446f9c663771ddec142d7c2eb4cb43
-- 
2.39.3


