Return-Path: <kvm+bounces-8654-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D53278546F0
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 11:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7342A1F2250F
	for <lists+kvm@lfdr.de>; Wed, 14 Feb 2024 10:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A171759D;
	Wed, 14 Feb 2024 10:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="GlwHXq5K"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B6171AC;
	Wed, 14 Feb 2024 10:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707905776; cv=none; b=FIODYYogxAa11CEkW/fGtmx/kKMzXlz0nmGQ8wqsgrc04OO0eAjNW8TR3DwRdcbMj9u245URdGWhzCYHnJ6uE3gwgM/AmA3R2jjdni6RG2MzLgZVDEA1GtI35FqUVL3l6F/Ll1MmoZizonbGOAJ94gn1bET+Ml/YuQe7nIpppIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707905776; c=relaxed/simple;
	bh=eTiNyXEgBPCIo0Ta8sYgjRV8p1Xz0hDcVMygIqs3U3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5mwd8xgekWIEmHy+vF+v+ucle1Ufa2ZiCOtLm86cDh0gNHTttCFWe9V6N8fd82yIsaJo9lcyFREDdIqaio30wMzkjTrm9xQhirtYjEwxr5sJRAEUBCqP8s55BKeWuMj3q9yBH3mO5cBTfkDewuYUkki7LAIPGZsCeDGPm2PXYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=GlwHXq5K; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1707905769; bh=eTiNyXEgBPCIo0Ta8sYgjRV8p1Xz0hDcVMygIqs3U3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlwHXq5KtlJN3WjzDugZTkyJEy5LHE+ExYx073zzj48EYrqsL7zgxjG0jH/CXdUWu
	 lHC5BxTxuznnRWa29bxkSyDY9QBTn3MlyULKk31DvSXmHgOaImFsYVGo+Dmwyixr+h
	 HhHqPrIQO+kYbav4MpoP9qcNYRLyGihzdZ4frvdI=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:5531:eef6:1274:cebe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 9843160562;
	Wed, 14 Feb 2024 18:16:09 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH for-6.8 5/5] KVM: LoongArch: Clean up comments of _kvm_get_cpucfg_mask and kvm_check_cpucfg
Date: Wed, 14 Feb 2024 18:15:57 +0800
Message-ID: <20240214101557.2900512-6-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240214101557.2900512-1-kernel@xen0n.name>
References: <20240214101557.2900512-1-kernel@xen0n.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WANG Xuerui <git@xen0n.name>

Remove comments that are merely restatement of the code nearby, and
paraphrase the rest so they read more natural for English speakers (that
lack understanding of Chinese grammar). No functional changes.

Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 9e108ffaba30..ff51d6ba59aa 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -302,20 +302,14 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
 	switch (id) {
 	case 2:
-		/* Return CPUCFG2 features which have been supported by KVM */
+		/* CPUCFG2 features unconditionally supported by KVM */
 		*v = CPUCFG2_FP     | CPUCFG2_FPSP  | CPUCFG2_FPDP     |
 		     CPUCFG2_FPVERS | CPUCFG2_LLFTP | CPUCFG2_LLFTPREV |
 		     CPUCFG2_LAM;
-		/*
-		 * If LSX is supported by CPU, it is also supported by KVM,
-		 * as we implement it.
-		 */
+		/* If LSX is supported by the host, then it is also supported by KVM */
 		if (cpu_has_lsx)
 			*v |= CPUCFG2_LSX;
-		/*
-		 * if LASX is supported by CPU, it is also supported by KVM,
-		 * as we implement it.
-		 */
+		/* Same with LASX */
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
 
@@ -336,21 +330,23 @@ static int kvm_check_cpucfg(int id, u64 val)
 
 	switch (id) {
 	case 2:
-		/* CPUCFG2 features checking */
 		if (val & ~mask)
-			/* The unsupported features should not be set */
+			/* Unsupported features should not be set */
 			return -EINVAL;
 		if (!(val & CPUCFG2_LLFTP))
-			/* The LLFTP must be set, as guest must has a constant timer */
+			/* Guests must have a constant timer */
 			return -EINVAL;
 		if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
-			/* Single and double float point must both be set when enable FP */
+			/* Single and double float point must both be set when FP is enabled */
 			return -EINVAL;
 		if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
-			/* FP should be set when enable LSX */
+			/* LSX is architecturally defined to imply FP */
 			return -EINVAL;
 		if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
-			/* LSX, FP should be set when enable LASX, and FP has been checked before. */
+			/*
+			 * LASX is architecturally defined to imply LSX and FP
+			 * FP is checked just above
+			 */
 			return -EINVAL;
 		return 0;
 	default:
-- 
2.43.0


