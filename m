Return-Path: <kvm+bounces-38843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D975A3F26D
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 11:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 26AA87A8E58
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 10:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FC20205AD9;
	Fri, 21 Feb 2025 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b="dDO50Faz"
X-Original-To: kvm@vger.kernel.org
Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB41B21BD
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 10:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134817; cv=none; b=e9PRZFQaVVj0wZkbRbR3k5fvHBY/9g0KkgGPwz0cEu4q8skzNuxE1PgtJ/eJx+PZUotxoSnY+9Xr+7hbp88pkZxhBFnvqCTkZLpFnOFoJIAXh797gtGhHRNgGRy5R9YX3xv/bq1i/2Xo6iFvDq69m6jfVTGvYZgHYYxD5J90AiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134817; c=relaxed/simple;
	bh=mfUddx4Y1kgBISgJXugRWgH6RyaUxQe2mxi5eDX4zrU=;
	h=From:Message-Id:To:Content-Type:Subject:Date:Mime-Version:Cc; b=uwH5vKTYoKXmfNFrzEGPJU13tKQtwyJxl7sA54PXc0BrUtm8QscQb9c5uew0L14sE3QgqOb3QpHkAkEzCam/NBY2oTYWpan1rdyNtfVlG2JQFFSLtp5quWNzZZNhQTtEDTlFEjoOlYLOIlF9LRFJuEjtBB1ifXpFTkcB2heQ49s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com; spf=pass smtp.mailfrom=lanxincomputing.com; dkim=pass (2048-bit key) header.d=lanxincomputing-com.20200927.dkim.feishu.cn header.i=@lanxincomputing-com.20200927.dkim.feishu.cn header.b=dDO50Faz; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lanxincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lanxincomputing.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=lanxincomputing-com.20200927.dkim.feishu.cn; t=1740134801;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vHH1MiexyCpVMoStYJqjt/YqpBbbofWY30poFqJKr2w=;
 b=dDO50Faz4LNVssaZu9LoBhfIUHKix2gGvKa1mfTtYWxCfhXWmZvfqMOgrOBuDgpCOzxfPl
 OGEuq+ePtkiA8wDAj506bYcIX6Jo5RtEHNx46KlDTO2B3uIVJzA9daIduRHoFXUIRtUdKr
 I2TamSH/rFQmwQvxP79uHrxb/wvbdAbZzVCzriQDRk/2VjIJuAMupWr9GLwmJxHHeut9yF
 o1pDXbXWdH3ZM/ugNi5eNci2BXprvVstSxioqbRN5LJptRaguAvK6FFquahFPa+uASp2ci
 a5Q1x9khu1/zN5nuarrEHFvB8BVOFT5alXmXisNqlZGjY6d04Tt5yhuIO/WqBA==
From: "BillXiang" <xiangwencheng@lanxincomputing.com>
Message-Id: <20250221104538.2147-1-xiangwencheng@lanxincomputing.com>
X-Mailer: git-send-email 2.46.2.windows.1
To: <anup@brainfault.org>
X-Lms-Return-Path: <lba+267b85990+f2c85c+vger.kernel.org+xiangwencheng@lanxincomputing.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: BillXiang <xiangwencheng@lanxincomputing.com>
Subject: [PATCH v2] riscv: KVM: Remove unnecessary vcpu kick
Date: Fri, 21 Feb 2025 18:45:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([222.128.9.250]) by smtp.feishu.cn with ESMTP; Fri, 21 Feb 2025 18:46:39 +0800
Cc: <ajones@ventanamicro.com>, <xiangwencheng@lanxincomputing.com>, 
	<kvm-riscv@lists.infradead.org>, <kvm@vger.kernel.org>, 
	<linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>, 
	<atishp@atishpatra.org>, <paul.walmsley@sifive.com>, 
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, 
	<rkrcmar@ventanamicro.com>

Remove the unnecessary kick to the vCPU after writing to the vs_file
of IMSIC in kvm_riscv_vcpu_aia_imsic_inject.

For vCPUs that are running, writing to the vs_file directly forwards
the interrupt as an MSI to them and does not need an extra kick.

For vCPUs that are descheduled after emulating WFI, KVM will enable
the guest external interrupt for that vCPU in
kvm_riscv_aia_wakeon_hgei. This means that writing to the vs_file
will cause a guest external interrupt, which will cause KVM to wake
up the vCPU in hgei_interrupt to handle the interrupt properly.

Signed-off-by: BillXiang <xiangwencheng@lanxincomputing.com>
---
v2: Revise the commit message to ensure it meets the required 
    standards for acceptance

 arch/riscv/kvm/aia_imsic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index a8085cd8215e..29ef9c2133a9 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -974,7 +974,6 @@ int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
 
 	if (imsic->vsfile_cpu >= 0) {
 		writel(iid, imsic->vsfile_va + IMSIC_MMIO_SETIPNUM_LE);
-		kvm_vcpu_kick(vcpu);
 	} else {
 		eix = &imsic->swfile->eix[iid / BITS_PER_TYPE(u64)];
 		set_bit(iid & (BITS_PER_TYPE(u64) - 1), eix->eip);
-- 
2.46.2

