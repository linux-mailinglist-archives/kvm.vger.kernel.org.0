Return-Path: <kvm+bounces-47840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A950AC5F9D
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 04:36:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DE124C2D9A
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 02:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C3F1DEFE0;
	Wed, 28 May 2025 02:32:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-m15578.qiye.163.com (mail-m15578.qiye.163.com [101.71.155.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5581C3BF7
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 02:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748399563; cv=none; b=stUIuFpRqxi1OmbAMKqJ6QbGJH3J0GO5eIaNGQEetI3j5A9oHDrPxFVc5JoTfxgnn6oOZN6s7gywdM/3VVmGTD6IBCN4HCVkif5yGV81i1VNUMtQKqjNEd9egBaMCGYdfs6774gLZuHC89QJymkRis4JyowqhSg+smXzk5biiWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748399563; c=relaxed/simple;
	bh=DYPgoNHt37hOoSsGkQKWs8cqaypQp0lBPVmaQTbU6H8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dIEYEXVcwCf2c8IChx8i9YuuXsSMMuX/oov9WKzEkcTAN9Q1oPN61CRbpEIlPkeiuFuOklHnDUUyB1JHYrHziKRexOsa+vNW8TYBdmhlmwQKLKGBn7K7oltKxfXWzfFf5U/QWnPllN1xFUyNhbMEAzcGfLB2C679QNh4lOAqDuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hj-micro.com; spf=pass smtp.mailfrom=hj-micro.com; arc=none smtp.client-ip=101.71.155.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hj-micro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hj-micro.com
Received: from localhost.localdomain (unknown [219.146.33.230])
	by smtp.qiye.163.com (Hmail) with ESMTP id 16a0d5c2b;
	Wed, 28 May 2025 09:57:05 +0800 (GMT+08:00)
From: JianChunfu <jansef.jian@hj-micro.com>
To: seanjc@google.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	kvm@vger.kernel.org,
	JianChunfu <jansef.jian@hj-micro.com>
Subject: [PATCH] KVM: VMX: Add braces for external interrupt information before vmcs_write
Date: Wed, 28 May 2025 09:56:02 +0800
Message-ID: <20250528015602.263066-1-jansef.jian@hj-micro.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTEoYVkNMSR4aHUJITx4fQ1YVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkJVSk9NVUhIVUlIS1lXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0
	tVSkJLS1kG
X-HM-Tid: 0a97149b841009d2kunm9f5ea5153aa3b3
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OBA6Nio4LTE5SUtDHzACPhce
	GkxPCk5VSlVKTE9DSEJMT0lNTENKVTMWGhIXVREaFQgeHVUREhoVOxMRVhYSGAkUVRgUFkVZV1kS
	C1lBWUlKQlVKT01VSEhVSUhLWVdZCAFZQUpJQ0g3Bg++

Single line branches also get braces if the previous branch required
braces.

Signed-off-by: JianChunfu <jansef.jian@hj-micro.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3b92f893b..8942cc217 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4976,8 +4976,9 @@ void vmx_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 		intr |= INTR_TYPE_SOFT_INTR;
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
 			     vmx->vcpu.arch.event_exit_inst_len);
-	} else
+	} else {
 		intr |= INTR_TYPE_EXT_INTR;
+	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr);
 
 	vmx_clear_hlt(vcpu);
-- 
2.47.1


