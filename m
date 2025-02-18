Return-Path: <kvm+bounces-38399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6428CA39475
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 09:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5E30188901E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 08:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B417622AE48;
	Tue, 18 Feb 2025 08:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="0B9LBpPO"
X-Original-To: kvm@vger.kernel.org
Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D481714C0
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 08:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739865780; cv=none; b=q9+NL5WNA/R5fiAjBUjsR6ntMcj/LQNbAq5TSOSy5Dq5CGbCt9oKlMngdWCBZyq3vgTkRPoGyTFnf3gH3miKtYuG+YDak03ZmcboHmKL6pzpRWpzzJIvtj7XA+CFVOViCxz04fIQe2lztU7k2lqutb7sggKj/6lSfnZcwndHFQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739865780; c=relaxed/simple;
	bh=MMO+Pgdg8WUeZitp0y2WePnN5QHq5BURFZjY8A/MeFs=;
	h=Content-Type:Date:Mime-Version:Subject:From:Message-Id:To:Cc; b=qI3SVAPE85RXGEgkVgbIDRLItPv+qc94NC6hCfKzjeiNQy8NsypWWvnOiTK/DzkEJD9W0GgrNX6q6bq3M63+XCcf+/T9lOEJWGSNI/l2LS9hbK43gwb0bjYJ5N8B6N3QJB0JByRi+7uymjOYEWcX9KdEWR5okYzGgx7BovV8oLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=0B9LBpPO; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1739865626;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MMO+Pgdg8WUeZitp0y2WePnN5QHq5BURFZjY8A/MeFs=;
 b=0B9LBpPOmtfsDFkY0UGD+h9v6gZt3x4JiLJi9zjeISa0QX4tsQ4gS66UH4SRdcIyd54WDE
 LlLMeyunCaxohiPyF0IB1bcjaXBZGdLWBQ1dJfRsOgW4cMSfJTgiArasu3sPVcA6I0FGF0
 i1o3Ev8POtsifF3+bT5Qa0cZG/YeVYjjJh+7mWPg6wgZ3unjPHiwll1oQorfctH4l4gwn1
 wrHQilzIRgKzEKE3p2nbNDwyttraipumJLiEOFDlPdz/EQyStp3pSAVSr73W13H4OuQbqo
 OHeje+Pb4AU+VSeCs24d0xVCkg/lcc+A9kGriiu8kElZdn7qB5PNgNuaNYR8mg==
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Feb 2025 16:00:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+167b43e19+1b8d4d+vger.kernel.org+xiangwencheng@lanxincomputing.com>
Subject: [PATCH] riscv: KVM: Remove unnecessary vcpu kick
From: =?utf-8?q?=E9=A1=B9=E6=96=87=E6=88=90?= <xiangwencheng@lanxincomputing.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <38cc241c40a8ef2775e304d366bcd07df733ecf0.1d66512d.85e4.41a5.8cf7.4c1fdb05d775@feishu.cn>
To: "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>
Cc: "anup@brainfault.org" <anup@brainfault.org>, 
	"atishp@atishpatra.org" <atishp@atishpatra.org>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, 
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

From 30dd00f6886119ecc5c39b6b88f8617a57e598fc Mon Sep 17 00:00:00 2001
From: BillXiang <xiangwencheng@lanxincomputing.com>
Date: Tue, 18 Feb 2025 15:45:52 +0800
Subject: [PATCH] riscv: KVM: Remove unnecessary vcpu kick

Hello everyone,
I'm wondering whether it's necessary to kick the virtual hart
after writing to the vsfile of IMSIC.
From my understanding, writing to the vsfile should directly
forward the interrupt as MSI to the virtual hart. This means that
an additional kick should not be necessary, as it would cause the
vCPU to exit unnecessarily and potentially degrade performance.
I've tested this behavior in QEMU, and it seems to work perfectly
fine without the extra kick.
Would appreciate any insights or confirmation on this!
Best regards.

Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>
---
=C2=A0arch/riscv/kvm/aia_imsic.c | 1 -
=C2=A01 file changed, 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index a8085cd8215e..29ef9c2133a9 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -974,7 +974,6 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vc=
pu,

=C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0 if (imsic->vsfile_cpu >=3D 0) {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 writel(iid, im=
sic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
- =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kvm_vcpu_kick(vcpu);
=C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0 } else {
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 eix =3D &imsic=
->swfile->eix[iid / BITS_PER_TYPE(u64)];
=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 set_bit(iid & =
(BITS_PER_TYPE(u64) - 1), eix->eip);
--
2.46.2

