Return-Path: <kvm+bounces-62464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E71C44422
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 38A244E8A61
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8223126BD;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4nvcYCA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D953115B5;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708600; cv=none; b=jqUxXx2u8SV3HvAD73k6OAaJ0VaKJhThBo093IxLVwkA8nHDstdla/2PcH6WpJHGTZct8/whjXB+ApD7o3jsvaJgr7hqfsN/xbNSsiu8Nj4bhXYtkYHcVsTB+jr5EQe06Ulv0Q6OzQwkbIgc0GhrBcs1+UU1Xq93e7Zrs26vl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708600; c=relaxed/simple;
	bh=tjNmKU1meI4A1Tgmx3bRMLobb68RBVy0q+KixZuhdFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mv0K7EeT20acEPYswkqzJJeKKWEm1yOp/tmNQwEoKN2m3+XwdJdbjwfi5zZi5Z0w/IOeBGNp+lrqHp7mLCHNvD3gptDA03a1q9clYdxwMXKqxnoaRErzQTgsUFGivm0vbXY0Kon5mnN2IzoKHZinMD9IUgyqM1RW40OLxu9NjLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4nvcYCA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C7DC116B1;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708600;
	bh=tjNmKU1meI4A1Tgmx3bRMLobb68RBVy0q+KixZuhdFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4nvcYCABAOJdsJH918iVn1BdxxNr2lJVDMSFmVz5g8Pb1AYkfVEpDH9bbUc+kVHR
	 YuUm5TWN9ZP03N4MPmsa6ENSE+enE/fAo1OxpSrdNbyqn/OM7xRx8f2Qh8aPuHV96t
	 PU0Ibhk73F1ymaFhQYkmdd29zmRO8ZlUZgxI9nTCxjkpap6cboeh1kQM+4WQTO9xWO
	 a/7YXnnLiRWFpOagrCV/GZUSq2BCDXwFLzqoteV0uCBIGQYXil87BscfhGheibaUyN
	 agJa+OwwUgeLaujLOT4pHug7HuKie2muBjDNW/HmyLS8dSAYkNCkrTGxiKaqjBdemd
	 99cjeIXpxwEZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91q-00000003exw-1VnV;
	Sun, 09 Nov 2025 17:16:38 +0000
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
Subject: [PATCH v2 41/45] KVM: arm64: selftests: vgic_irq: Remove LR-bound limitation
Date: Sun,  9 Nov 2025 17:16:15 +0000
Message-ID: <20251109171619.1507205-42-maz@kernel.org>
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

Good news: our GIC emulation is not completely broken, and we can
activate as many interrupts as we want.

Bump the test to cover all the SGIs, all the allowed PPIs, and
31 SPIs. Yes, 31, because we have 31 available priorities, and the
test is not happy with having two interrupts with the same priority.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index b0415bdb89524..9d4761f1a3204 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -449,12 +449,6 @@ static void test_injection_failure(struct test_args *args,
 
 static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 {
-	/*
-	 * Test up to 4 levels of preemption. The reason is that KVM doesn't
-	 * currently implement the ability to have more than the number-of-LRs
-	 * number of concurrently active IRQs. The number of LRs implemented is
-	 * IMPLEMENTATION DEFINED, however, it seems that most implement 4.
-	 */
 	/* Timer PPIs cannot be injected from userspace */
 	static const unsigned long ppi_exclude = (BIT(27 - MIN_PPI) |
 						  BIT(30 - MIN_PPI) |
@@ -462,26 +456,25 @@ static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 						  BIT(26 - MIN_PPI));
 
 	if (f->sgi)
-		test_inject_preemption(args, MIN_SGI, 4, NULL, f->cmd);
+		test_inject_preemption(args, MIN_SGI, 16, NULL, f->cmd);
 
 	if (f->ppi)
-		test_inject_preemption(args, MIN_PPI, 4, &ppi_exclude, f->cmd);
+		test_inject_preemption(args, MIN_PPI, 16, &ppi_exclude, f->cmd);
 
 	if (f->spi)
-		test_inject_preemption(args, MIN_SPI, 4, NULL, f->cmd);
+		test_inject_preemption(args, MIN_SPI, 31, NULL, f->cmd);
 }
 
 static void test_restore_active(struct test_args *args, struct kvm_inject_desc *f)
 {
-	/* Test up to 4 active IRQs. Same reason as in test_preemption. */
 	if (f->sgi)
-		guest_restore_active(args, MIN_SGI, 4, f->cmd);
+		guest_restore_active(args, MIN_SGI, 16, f->cmd);
 
 	if (f->ppi)
-		guest_restore_active(args, MIN_PPI, 4, f->cmd);
+		guest_restore_active(args, MIN_PPI, 16, f->cmd);
 
 	if (f->spi)
-		guest_restore_active(args, MIN_SPI, 4, f->cmd);
+		guest_restore_active(args, MIN_SPI, 31, f->cmd);
 }
 
 static void guest_code(struct test_args *args)
-- 
2.47.3


