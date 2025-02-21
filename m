Return-Path: <kvm+bounces-38829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A036BA3EAF4
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 03:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91C867AAC3B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 02:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60FFB1D63F2;
	Fri, 21 Feb 2025 02:59:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929DB2F3B
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 02:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740106784; cv=none; b=RwR5kv8vOBSGSJhXVACtAA8EIrkKxmLvk4dHnJxBx5S0aznQMK3uHNEv53CMKyXSbEy4neQa5UhiSyB62ZieaeHKLYEhI5Vzd83xG7B9kVQlem8zPLgylwsWiCYogjjt3rKcJVEj3ypj97mzT6Aoo00ekkmb/05IiBjQgK2m9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740106784; c=relaxed/simple;
	bh=4NufrDG7xe1jL4NR/1E7bLhDsWM6GnOXyknQU3avmSc=;
	h=From:To:Subject:Date:Message-Id; b=YLWx+h0GAXeWBybyxDjdD6HxX0D0UTDyBG0H+buCCYFL364lm1bb/DFlxbQCI+EnqwdMmi/RuNAExoJQMGSwXpQYqnPvnfASzaUTr6bIXV3Jmh5FkZQ/VH+3iVBQ4EzLpJNyE1aZ6mdxsD2VRRD95R6BAbXujr+WJcF+VjOFkgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgDH6xER7LdnRwknAA--.31219S4;
	Fri, 21 Feb 2025 10:59:30 +0800 (CST)
From: Chao Du <duchao@eswincomputing.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Subject: [PATCH v2] RISC-V: KVM: Optimize comments in kvm_riscv_vcpu_isa_disable_allowed
Date: Fri, 21 Feb 2025 02:59:29 +0000
Message-Id: <20250221025929.31678-1-duchao@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID:TAJkCgDH6xER7LdnRwknAA--.31219S4
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr1rCFyxJF43ArWkXry7Wrg_yoW3ZrX_Ga
	18XanrWrWrJF1I9Fyagw4rCr1xu34Fga97Kr4fXr4UGryYvr45AayvqF45Zw1UWF43Xayx
	GrZrurn3Aa43KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxkYjsxI4VWkCwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
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
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8
	6uWPUUUUU==
X-CM-SenderInfo: xgxfxt3r6h245lqf0zpsxwx03jof0z/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The comments for EXT_SVADE are a bit confusing. Optimize it to make it
more clear.

Signed-off-by: Chao Du <duchao@eswincomputing.com>
---
 arch/riscv/kvm/vcpu_onereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index f6d27b59c641..43ee8e33ba23 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -203,7 +203,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_SVADE:
 		/*
 		 * The henvcfg.ADUE is read-only zero if menvcfg.ADUE is zero.
-		 * Svade is not allowed to disable when the platform use Svade.
+		 * Svade can't be disabled unless we support Svadu.
 		 */
 		return arch_has_hw_pte_young();
 	default:
-- 
2.34.1


