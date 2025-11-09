Return-Path: <kvm+bounces-62423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 56500C443B2
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CDB9E34679B
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E53305E2B;
	Sun,  9 Nov 2025 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKKwGzh+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5240D3002A0;
	Sun,  9 Nov 2025 17:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708590; cv=none; b=nT8O0F1NDgjbvA/XtFV00zo1wPUXEB5BkPDuM5niFlgOfjwGavDeVn/gks+jzwvALNjZBr2YR8DIqV85fYMKBcUm7M9YpQ7Sy72502e0Yaivn6xZNAVR5B1b982SVWW5b93+BZceFaCWBK32hr9RHLT+LZuIAYfURVepMOhHXZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708590; c=relaxed/simple;
	bh=/GSt2XVw5TKgrkgRLW7hTqPErYsbM430CGm8iWI4aZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5CIhehRM5Kb7VQ0tlzH8FL8AZIi+lLEclh1EgTE2JLrS/ZhQRvPADxdSd3aMOALAswn6OC8gVfu279KPiIb/TP+9LrnM3IxgzF55jd68+mSkpWQTdvExwEg4z6E+ZyhYs3AYd3fH2oqsTxm3lJFcJgSsHjH9mZTBZxRH3ujWP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKKwGzh+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291ADC19421;
	Sun,  9 Nov 2025 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708590;
	bh=/GSt2XVw5TKgrkgRLW7hTqPErYsbM430CGm8iWI4aZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKKwGzh+C2ajzJvllUjpYtaJhqfIjPu5DJ7a5+9rRSVxbOHAWCAeR/yde88eCQQd2
	 L5qTo/Uu6/Y2Nk1iHGOgjrijMpmW+vnX3/NsZQJqP8JfHuC1YiE+5mUE4oVnw8hBk5
	 u4Tcg4nQuLaei+qeCC8A8LUJyjqax0Yc7hPLTYtGDT1kcKB4PYPatFbi065zqffjlr
	 FgfpeOUWPGKtSaP7eFoPwVbzvSqjj3BwNlEpo55zcVnEx66MKVAuxKdSEO6V1eY+so
	 DIyk/TmYLCaVi5EQJSfLxGVKrzB7QhHSt42r1XqFFDKQnaOMRnaXMEz2sMh52wxpIF
	 kBIcuNZVuerNg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91g-00000003exw-0Ipf;
	Sun, 09 Nov 2025 17:16:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 01/45] irqchip/gic: Add missing GICH_HCR control bits
Date: Sun,  9 Nov 2025 17:15:35 +0000
Message-ID: <20251109171619.1507205-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The GICH_HCR description is missing a bunch of additional control
bits for the maintenance interrupt. Add them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/irqchip/arm-gic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index 2223f95079ce8..d45fa19f9e470 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -86,7 +86,13 @@
 
 #define GICH_HCR_EN			(1 << 0)
 #define GICH_HCR_UIE			(1 << 1)
+#define GICH_HCR_LRENPIE		(1 << 2)
 #define GICH_HCR_NPIE			(1 << 3)
+#define GICH_HCR_VGrp0EIE		(1 << 4)
+#define GICH_HCR_VGrp0DIE		(1 << 5)
+#define GICH_HCR_VGrp1EIE		(1 << 6)
+#define GICH_HCR_VGrp1DIE		(1 << 7)
+#define GICH_HCR_EOICOUNT		GENMASK(31, 27)
 
 #define GICH_LR_VIRTUALID		(0x3ff << 0)
 #define GICH_LR_PHYSID_CPUID_SHIFT	(10)
-- 
2.47.3


