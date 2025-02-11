Return-Path: <kvm+bounces-37772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95820A30140
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CBC43A30F2
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DFE91BD9C8;
	Tue, 11 Feb 2025 02:01:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2FAB14A629;
	Tue, 11 Feb 2025 02:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739239290; cv=none; b=MephMoivqMHXosxDrmHZCgEby3PwBMr+UkbGmtVp7a4ZWgzpOInEGjI5Rm9ms8Scb+llFc3i6ldRWN13WCKgmBo06GTVswqr+WQQKVu+Da8mbTrYkY7EHL2HovHDqVtb9laYFc2uqA6QPDDm6wdJPzbllEa6F27PiikG/rwsKdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739239290; c=relaxed/simple;
	bh=Blz7EHW5cCaDL+sdgoXm7KdhnUxuoljlTGlluE0hMuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n2MPVULB9ZaB91uaQEesKdBhWejh4SjgVoFY727XhfkVsncJZcFnVAzPJJ1ta6TiEFLGaNhFDgDhapQ8Wy++vATAfNsUNrPylWZ9KFR3rtn8kitTbMAdMsgiw4788Op90Y/cvbJVMTOjZSEb7vPmj0dlb2vIbQIovgrSMcjPCF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxDGtvr6pnqc5xAA--.1495S3;
	Tue, 11 Feb 2025 10:01:19 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMBxLsdur6pnLz8LAA--.44545S3;
	Tue, 11 Feb 2025 10:01:19 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] LoongArch: KVM: Fix typo issue about GCFG feature detection
Date: Tue, 11 Feb 2025 10:01:16 +0800
Message-Id: <20250211020118.3275874-2-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20250211020118.3275874-1-maobibo@loongson.cn>
References: <20250211020118.3275874-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxLsdur6pnLz8LAA--.44545S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

This is typo issue and misusage about GCFG feature macro. The
code is wrong, only that It does not cause obvious problem since
GCFG is set again on vCPU context switch.

Fixes: 0d0df3c99d4f ("LoongArch: KVM: Implement kvm hardware enable, disable interface")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/kvm/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index bf9268bf26d5..f6d3242b9234 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -303,9 +303,9 @@ int kvm_arch_enable_virtualization_cpu(void)
 	 * TOE=0:       Trap on Exception.
 	 * TIT=0:       Trap on Timer.
 	 */
-	if (env & CSR_GCFG_GCIP_ALL)
+	if (env & CSR_GCFG_GCIP_SECURE)
 		gcfg |= CSR_GCFG_GCI_SECURE;
-	if (env & CSR_GCFG_MATC_ROOT)
+	if (env & CSR_GCFG_MATP_ROOT)
 		gcfg |= CSR_GCFG_MATC_ROOT;
 
 	write_csr_gcfg(gcfg);
-- 
2.39.3


