Return-Path: <kvm+bounces-71578-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oAItJr0VnWkGMwQAu9opvQ
	(envelope-from <kvm+bounces-71578-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:06:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE701814B1
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33BFE30F95C7
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C6A28726A;
	Tue, 24 Feb 2026 03:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="JX8KmRgF"
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B52D225F988;
	Tue, 24 Feb 2026 03:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771902379; cv=none; b=ld3n2Y4rFhur1qJ2tNrXE9wVtosCOIlp/HmJYRIiKsJ/ZZjd3r01VhIvsxBBu8BtdvkwTSdtBgUNG7EDso98m1OORnJ15IXEPf7RUz9V55j5zHjp4Owpf06nsgFlQ6yZjOxERv8fP7xWXZWwVauJuXeRY8+NMhVL1ac5HT+tSbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771902379; c=relaxed/simple;
	bh=qssF05MfIm4PKdUmGfxwNYhwrYKsgr/FAsbcuWSiwV4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PcoRS1zCOn8XBZ6+w63BybbuSbMMY8jzM0iS5FSM+fQbhOFUxMQNv5FQ9V3Uv0MaBJpucI2GajSLUuojJqbRgnHVz6TP05MB2VV8SOiLSc07TDGMHQcqLpXHARlfx2AUaAf0NBcCnHhajONg8nIrd/Kn8qVRdMHyFpFdW5UDhlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=JX8KmRgF; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1771902301;
	bh=w7ScbXAlDg77dLFPD9/y+vNR4xu0fzduE0FT6qpaER0=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=JX8KmRgFZ8/RRz1yvtZdLPu6ewfXaOg7kEM5GPdT9HKwpZPfAmEXW+bfJSkl30Zr7
	 hbtEEUepOEmEZVQajIApOD3ZR0YVWaAfOnJ9z6mcHfJ1WMrklmRX8kB3OLzu2w3GyT
	 Z1muN7a4CT+0z1iVRNuhVh4SGnYr2VwfTYe+H370=
X-QQ-mid: zesmtpgz9t1771902299t335be9eb
X-QQ-Originating-IP: k9kXXmnjdlkQUeBx6U3J5mySxJB/gzlKmcje5uWhwNM=
Received: from localhost.localdomain ( [116.172.93.199])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Feb 2026 11:04:56 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3330235604714080646
EX-QQ-RecipientCnt: 14
From: kexinsun <kexinsun@smail.nju.edu.cn>
To: zhaotianrui@loongson.cn
Cc: maobibo@loongson.cn,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tsbogend@alpha.franken.de,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	julia.lawall@inria.fr,
	xutong.ma@inria.fr,
	yunbolyu@smu.edu.sg,
	ratnadiraw@smu.edu.sg,
	kexinsun@smail.nju.edu.cn
Subject: [PATCH] KVM: MIPS/LoongArch: Fix typo in pfn_to_pfn_prot comments
Date: Tue, 24 Feb 2026 11:04:53 +0800
Message-Id: <20260224030453.2311-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: Ng+Kv6QQ5H8idZXDU7uKnFG5tE30S++zH90fXU4RNb9dZPv/jslz+1mL
	nHyYSHDiSFcba3UJh+snSQJtdPJDMHcVsGldioS70KW7Rsrn/NR8DPlXrDpyOWRXdXcIVko
	3hPkW3RiL9q9M9bQHSg2YGkB5fwbUr4LJsSZk9B/yYS+p+fSbKRYUuoE4l0mL1TND1Jdx1O
	nu72svLCNstGTHKyM/G28fTgLN191+cEQZMHk+YvvVs4NsD+KtRPXtFK7tQw8dOwY0Or7Vu
	UPkLSplxLxhgMdhSTuJv6TwrLt9OuFDhAg6YjoljZN6cdW6jnyXHpBJAKQxUaduENhIhHHR
	INAu6VHZNVklKASwLwaHczwKiLj5YLz4lnoiRp1sZ++eAPXKQ9xBbTLxvs+TlZWQwKTqyO/
	yHuDUUQ4KTd6vF+v7i4Vs6/E20Nn5gucxCSmVSfIU/TLFZVaoVELbKL9+qti7ZVfWSlv42Z
	FVypRXTD+lpzXml+4VzcXNZVHLKPjxdKHLQbzgteDZDtvRSOaJeEfU3VpUm8uLeiv20sTu1
	ulabu2L8kshQeHkfXloH6UmlNfQ+1D55RKMZNKwi7XQM7S8Xs1IQkzgRTaugBaLdkOnnpji
	DlcsjBPe75dgXAp/39eR+C6pC6oFtwxFPBQ2nbJm2I9sFjgxNHPbQ/7+GQULNgZFLHJKwYk
	AvMQjz/1fHmBzg4HPKzOozrQiBRflRy0U5TL/vV8OsqpbNbubGk6YVA6V5SQh+ICFl+/5T0
	V1d1V1mD9mKiKlJBRjGKKGhpt3bdsL2wVtwzpphEEimSHrpfcBYWjyZ8twyiu2iW5PjhH8I
	DqN2cQli8anBgx5D/Au9GqufCoAn/+S29pAaNuICJIzEfW/FJLVV29HHVsW+MZ2I0us1YLb
	FUCdxLNGLsL0QeONtBjNQbq+cI4ejjCQbhDKgWuaHXSJQ0BqzORJWphSrRm1Y/x/AziatBw
	4gVnqRi4GQ4d3dip79uzEbTpG52PVfQBn5rx0rNQlDKPEAmExajnKyEQ8zHFoK3yZGI+Ra5
	dDewRIriivJRlg+bcgP7TyukP06n57vD2eqYppMTqvU2ddG3LvBcDJixG0FyP4gtvGAfg8d
	QR9MvEd67REWQd/cHLruHw7nCfduhNQHbrB41zzs+v2f25VxE5obobjak4Jm9Ad/g==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[smail.nju.edu.cn,reject];
	R_DKIM_ALLOW(-0.20)[smail.nju.edu.cn:s=iohv2404];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71578-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[smail.nju.edu.cn:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_NEQ_ENVFROM(0.00)[kexinsun@smail.nju.edu.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[smail.nju.edu.cn:mid,smail.nju.edu.cn:dkim,nju.edu.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EBE701814B1
X-Rspamd-Action: no action

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
Fixes: 752e2cd7b4fb ("LoongArch: KVM: Implement kvm mmu operations")

Signed-off-by: kexinsun <kexinsun@smail.nju.edu.cn>
---
 arch/loongarch/kvm/mmu.c | 2 +-
 arch/mips/kvm/mmu.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index a7fa458e3360..a3fb6ace4a98 100644
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


