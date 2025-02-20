Return-Path: <kvm+bounces-38649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F20A3D2A0
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 08:49:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B38C178929
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 07:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F285D1E9916;
	Thu, 20 Feb 2025 07:49:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0DB1E379B
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 07:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740037777; cv=none; b=oH0YipAvRKYAJ3st86gsb6kWWFw9ba6ariDG4w5WzOoOn+0VADaebZ+EylQaRJZjIPrPJ5aHiIjNwQQCEY1mh50D7LeZ4TfrlSFuXCKijGf+R2+Pp7Z8d5JoKulLZeY9qd6dGGzBBLF38fmPX5A4ouIrGa/uZJIsDLo5Eci2UNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740037777; c=relaxed/simple;
	bh=lVF00DZJDyX0cMTYhtghBcj7x2iQzq35NrYNEqqOYKs=;
	h=From:To:Subject:Date:Message-Id; b=KJ4543PWmon+Ai5QyQJkII0DS3NeA/+1vLdwrCRsYjhOYaBDrE0USU+Aul8n9w5OcmoSxCAwK0nlJJcL5VDW2+K2O7Fd8bWoPlOFS+M0jn89e8qQCV7yIEJyzcPsgTK4oO5c5EV+6O+BgFOLlJ+AprLNgxILs5YS+TheSVDeAiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgDX+xFy3rZn0IYmAA--.28860S4;
	Thu, 20 Feb 2025 15:49:07 +0800 (CST)
From: Chao Du <duchao@eswincomputing.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [PATCH] RISC-V: KVM: Fix comments in kvm_riscv_vcpu_isa_disable_allowed
Date: Thu, 20 Feb 2025 07:49:05 +0000
Message-Id: <20250220074905.29014-1-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:TAJkCgDX+xFy3rZn0IYmAA--.28860S4
X-Coremail-Antispam: 1UD129KBjvdXoWrtr4rGry8tryUXr43ZF4fKrg_yoW3urb_Ga
	18XFsrWrWrXF4I9Fyag3yrCr1xG3yrKa93Kr4fWr4UKryFva13AayvqF15X34UXF43WFZr
	CrZ7Wr4fAa43KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYjsxI4VW3JwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
	6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
	8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0
	cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I
	8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
	Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l
	c2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWU
	twCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcT
	a0DUUUU
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The comments for EXT_SVADE are opposite with the codes. Fix it to avoid
confusion.

Signed-off-by: Chao Du <duchao@eswincomputing.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f6d27b59c641..6df41794e346 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -203,7 +203,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SVADE:
 		/*
 		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
-		 * Svade is not allowed to disable when the platform use Svade.
+		 * Svade is allowed to disable when the platform use Svade.
 		 */
 		return arch_has_hw_pte_young();
 	default:
-- 
2.34.1


