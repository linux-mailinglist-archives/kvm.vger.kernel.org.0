Return-Path: <kvm+bounces-43951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5410EA99157
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBDBE9227C3
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BBCE294A0B;
	Wed, 23 Apr 2025 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JE3uJb4o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B37A28B4FA;
	Wed, 23 Apr 2025 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421316; cv=none; b=OretwWbROIsEM2CqQ6tmF6aTdtXFdW4V7sc9lIllHEQeDRR9EQvr/pm8UWjVOGRYJ/nOITNTBT3IjZ5aW+c9nLAy4eynA83jF5uefLS2lur7tOEUvnGpwRFFjICfuSLI2s3pHapHgaVrFigZiRGiG8Uj5c+N1ssCUZyf2KAIe8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421316; c=relaxed/simple;
	bh=3qbUHNjVeE1aIlxcMRPnT2/3KD3ydEWgG5AMl0skQMo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NSQUyPUBpHi/rL61B+EKoNPiAswctQYhQWv25vE0m5WwOAXVdGSQX4c4H86dfHaE5xu9xbYQWaKc8ypNClen1roiJIMWVGTw5k7jyHfPxPl4uRBvLe13ucWhKn2wJQKQmPHwHturkfh0m24zgUHH7yRrHsuaXvz7E0Lsu1Bq9CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JE3uJb4o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8ABC4CEEB;
	Wed, 23 Apr 2025 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421316;
	bh=3qbUHNjVeE1aIlxcMRPnT2/3KD3ydEWgG5AMl0skQMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JE3uJb4ovVaj6pOQNm3iEbeTT97Sui7io2Ku9gx4nMblhdKYTZITZ3eLiYwFoppyB
	 OYfMx1yFMQHRvEYMQDiD1DdzUTNbqr7Gqvie1THa/SyDlCLKG3o5uhBaNlzLNDXKX0
	 h6ujdSWBxVNUZk6bo0pjikgyGSyrj3FfjMDZW5/hYOMzkVY/tsO7Eg6ES3SG1ObCT9
	 uWQLpM8tm4FPcIcBoU67RRXmU9SO/8eBIyGtRIn0KwvUxF6YWjBuNH/a4q2X1P5fVL
	 0IYiR61Xq4IZ5ztY5zNycqwuCdFlujJliEhRFuD7OYeT9amgSLbFECHKU+Ecorc1Ch
	 ++kLYDhNfkAEQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7bog-0082xr-0j;
	Wed, 23 Apr 2025 16:15:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 04/17] KVM: arm64: nv: Snapshot S1 ASID tagging information during walk
Date: Wed, 23 Apr 2025 16:14:55 +0100
Message-Id: <20250423151508.2961768-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently completely ignore any sort of ASID tagging during a S1
walk, as AT doesn't care about it.

However, such information is required if we are going to create
anything that looks like a TLB from this walk.

Let's capture it both the nG and ASID information while walking
the page tables.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/at.c                 | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index c8a779b393c28..4ba3780cb7806 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -274,6 +274,8 @@ struct s1_walk_result {
 			u64	pa;
 			s8	level;
 			u8	APTable;
+			bool	nG;
+			u16	asid;
 			bool	UXNTable;
 			bool	PXNTable;
 			bool	uwxn;
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 71406908d4f44..da5359668b9c9 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -414,6 +414,33 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 	wr->pa = desc & GENMASK(47, va_bottom);
 	wr->pa |= va & GENMASK_ULL(va_bottom - 1, 0);
 
+	wr->nG = (wi->regime != TR_EL2) && (desc & PTE_NG);
+	if (wr->nG) {
+		u64 asid_ttbr, tcr;
+
+		switch (wi->regime) {
+		case TR_EL10:
+			tcr = vcpu_read_sys_reg(vcpu, TCR_EL1);
+			asid_ttbr = ((tcr & TCR_A1) ?
+				     vcpu_read_sys_reg(vcpu, TTBR1_EL1) :
+				     vcpu_read_sys_reg(vcpu, TTBR0_EL1));
+			break;
+		case TR_EL20:
+			tcr = vcpu_read_sys_reg(vcpu, TCR_EL2);
+			asid_ttbr = ((tcr & TCR_A1) ?
+				     vcpu_read_sys_reg(vcpu, TTBR1_EL2) :
+				     vcpu_read_sys_reg(vcpu, TTBR0_EL2));
+			break;
+		default:
+			BUG();
+		}
+
+		wr->asid = FIELD_GET(TTBR_ASID_MASK, asid_ttbr);
+		if (!kvm_has_feat_enum(vcpu->kvm, ID_AA64MMFR0_EL1, ASIDBITS, 16) ||
+		    !(tcr & TCR_ASID16))
+			wr->asid &= GENMASK(7, 0);
+	}
+
 	return 0;
 
 addrsz:
-- 
2.39.2


