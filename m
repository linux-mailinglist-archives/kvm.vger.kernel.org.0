Return-Path: <kvm+bounces-61098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF59C0ABC7
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 16:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6BCED4E9EE5
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 15:04:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 041F92248A4;
	Sun, 26 Oct 2025 15:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="qmYZCnpt"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990C14A00;
	Sun, 26 Oct 2025 15:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761491056; cv=none; b=B+FOr01hTzFhFnGsUBCRHtZlcXcE5zJD5/6x7oSAwLp24MKgsovExjR/m2Y8M0NbntaL4umcO6bJH/LGYucvv1RQNRMHJHrOv680YaKk/u1etE+wdf307xApKxYosgUozh8+F2gkty96513/PSkl3vWLscLsATVG+KJlbvUL09E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761491056; c=relaxed/simple;
	bh=PUY8ufN7vstGylzvnbltRDJNllT5tt1XhKbAwVE5Z54=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DeeeDaW7GpWNa6Ivvqe6+PSNIK/664Ub86fMltB/Lde/xjRpqKRL+tkrMZZ6wl+a51adq1Xpp0jiGm2+PmdNfdZcRWCWLOndFtJ7vdMmyg/F4JECxALjIFWmij7tSJUm2/3XQa+xVgVc7VLneL951O6VEsMambMXd19BY1l52SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=qmYZCnpt; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1761490986;
	bh=+Z+j6fQorgO5+luTFqPZGzIYaMBkEtHiXYbxa9t/aKU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=qmYZCnptUP+6DU5xy/xiqp16b9ymOd5+W8thqCSSPb+hcYObYLJ68DlS8Wmckjeue
	 T45V97Nw2YVrCvVQd6L5X0vGVdwBIdD15N2gDEFHWFeCU4F6xa7w4NmIVhzXa9x4z2
	 lTegKfBqv2w2CrpCRb5dVDsukbI/6mZ4Az0LO/dQ=
X-QQ-mid: zesmtpsz8t1761490977t568d50cd
X-QQ-Originating-IP: NrAxf5G8PfEeh737gDU+xRgygti1s0gwHe4kjF8ywb0=
Received: from localhost.localdomain ( [1.27.207.188])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 26 Oct 2025 23:02:35 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 14413365355414812529
EX-QQ-RecipientCnt: 13
From: Kexin Sun <kexinsun@smail.nju.edu.cn>
To: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	WANG Xuerui <kernel@xen0n.name>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Yunbo Lyu <yunbolyu@smu.edu.sg>,
	ratnadiraw <ratnadiraw@smu.edu.sg>,
	Kexin Sun <kexinsun@smail.nju.edu.cn>
Subject: [PATCH] KVM: MIPS/LoongArch: Fix typo in pfn_to_pfn_prot comments
Date: Sun, 26 Oct 2025 23:02:19 +0800
Message-Id: <20251026150219.2711-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: NlrfLQhmr2s5c53fY0QiQxylX6NgeuqXb8Q6KRvQiWN52YrS8uLceJYs
	rrcBSGCpLyZGeRHrHRl1/gd5tbaPIjiHPNjfxN4pdMLu9SM2XEOcis/QzXhWS8wG1xZMrpr
	g/tupIJTKeDcl2fi8Zj3t8LtUo8CibKU+boBJExVAsXSImLuGJ0ZssIYkBSefHjkqTnMsvJ
	rXhVyICCImEJt8X1w+/pBd5JSrxR+LsQEDuOMY9N9PMC80v2lUlHBNoKlYKXTFFgZaYRzaB
	UfstE33LR0A1xVgUhVtyB6M381VHS35UsUl8w1di9Y10UPVudMjmtDV8e4JLbbU5eOI4G0H
	eM4jd4FcN5wCQ2kDBPvLGe578QqpPu18QwALHAdu015FjyBTWyxlcn/Hri7OL4M4dScoXOd
	RPsoWnEfJkiQGzcZ+NvIAsQwQqAdHMCqVG7klaCieuxaPsAZ44subTNz3fGWQv3y0DcWKtF
	0z6EA+YSefhYRNWSeuFOd0z4c9FiWQHLMebzI7A5IKBLpVZKpZbUo23iMfboG1BgdGo8CB9
	w8I3vs2FuB9JQsQnc5+KPfLpDISbjixNa9dmWnpUAJKOWrb/Bs3YqhB+AYxFentb299QQcd
	Q4X6UqaQ3IKGZN1DYYp5snflNmqOgLLQIFHk5bNtwxMkCtFhHKPuUk1vJMf68of/9dFwSSH
	vKTFji0gTuMiBmR1acLs2PqFNcKZzzxmA1c69Q0dwvTiVlUE7W+DbHD/EXk+aCDRFuVgEJs
	M5n0x3p4K5iYKOpQI2VLhtbhBQyixBZFfFF/RjkNDmIdxXHykv80qrJ2i3QOnBucuJmGXPk
	4pYaTGCPtMhMzFqemPVbvJgK10IyotZfATqmKoX4w0mePRWJk6+ujLzQZwrwqU+sEcA9StN
	7PLGvihrDHTRc5Fj/CPobFpJrTHYAQo2XJ9iEBosG3cogGVU81l7OyODXhgw2tFgTRwgwT9
	Duqq3dw8SiH3utXeoIR4WaOi+PzwkW8PL+EXRqaMy33ofPfEL6NJI9Z9T9XPyq7nNr5t5yh
	oY02cYmzkKWK++We0qpTDFCZxSYJyyuXmUJnhYj6w4kR/3mocczCLikEnOEXU2etZe2+V/X
	Zaxktp8U+Q8Na6jD+3P4b4=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

The comments in arch/{mips,loongarch}/kvm/mmu.c refer to a non-existent
function "pfn_to_pfn_prot". This is a historical typo.

In MIPS, it was introduced in commit 411740f5422a ("KVM: MIPS/MMU:
Implement KVM_CAP_SYNC_MMU") where the actual function being called was
`gfn_to_pfn_prot`.
(see `pfn = gfn_to_pfn_prot(kvm, gfn, write, &writeable);`).
This was later replaced by `kvm_faultin_pfn()` in commit 7e8f1aa59d0b
("KVM: MIPS: Use kvm_faultin_pfn() to map pfns into the guest").

The LoongArch code, likely copied from MIPS, inherited this typo upon
its introduction in commit 752e2cd7b4fb ("LoongArch: KVM: Implement
kvm mmu operations"). The actual function call was likewise updated to
`kvm_faultin_pfn()` in commit 14d02b7ff912 ("KVM: LoongArch: Use
kvm_faultin_pfn() to map pfns into the guest").

Update the comments in both files to correctly reference the current
function, `kvm_faultin_pfn`.

No functional change; comments only.

Fixes: 411740f5422a ("KVM: MIPS/MMU: Implement KVM_CAP_SYNC_MMU")
Fixes: 752e2cd7b4fb ("LoongArch: KVM: Implement kvm mmu operations").

Signed-off-by: Kexin Sun <kexinsun@smail.nju.edu.cn>
---
 arch/loongarch/kvm/mmu.c | 2 +-
 arch/mips/kvm/mmu.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 7c8143e79c12..1a9ed6f56a1b 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -803,7 +803,7 @@ static int kvm_map_page(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 retry:
 	/*
 	 * Used to check for invalidations in progress, of the pfn that is
-	 * returned by pfn_to_pfn_prot below.
+	 * returned by kvm_faultin_pfn() below.
 	 */
 	mmu_seq = kvm->mmu_invalidate_seq;
 	/*
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index d2c3b6b41f18..da51707a2366 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -574,7 +574,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
 retry:
 	/*
 	 * Used to check for invalidations in progress, of the pfn that is
-	 * returned by pfn_to_pfn_prot below.
+	 * returned by kvm_faultin_pfn() below.
 	 */
 	mmu_seq = kvm->mmu_invalidate_seq;
 	/*
-- 
2.25.1


