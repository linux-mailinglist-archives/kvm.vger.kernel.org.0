Return-Path: <kvm+bounces-34534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CECD6A00B97
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 16:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB2B47A192F
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 15:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3FA1FA8F2;
	Fri,  3 Jan 2025 15:39:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75092187848;
	Fri,  3 Jan 2025 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735918752; cv=none; b=HCE1mPZ+MGCoi4ZXOeKwbz7d/4sTS5WlnrRDCrYHhN68Sq12QcyHhYbcdZH6FcGtKrPyFwnRAiRCkeyOPpQTBLR2aHW0TcpXPOKaAmT+DqzF9MfjUzorEA7X6oVcFc7DDNz4kkliW6I3MOPPOpey0MkGPUuNigXEL4/s2XKZiZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735918752; c=relaxed/simple;
	bh=cHAis2gHAPYQgToalEpXaoKE2NLjHEgKS5Lju56hMvs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pfS8Bw9dsk34qnF1kZaINxr3C/hlZb5T/XntkriXpK+ByWa8pQDvz/kWtCeLxlXTBToKO37UtKF/eYg7eU4GcTccpfkYESkxNtB98BTjBauRlpsGnK/jb6jHlDTAa9H8u7eCjxpfkBiFYUuII7p2GOysgEXWttKPJmEJIXz77Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: Gao Shiyuan <gaoshiyuan@baidu.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gaoshiyuan@baidu.com>, <x86@kernel.org>
Subject: [PATCH 1/1] KVM: VMX: Fix comment of handle_vmx_instruction
Date: Fri, 3 Jan 2025 23:38:14 +0800
Message-ID: <20250103153814.73903-1-gaoshiyuan@baidu.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BJHW-Mail-Ex10.internal.baidu.com (10.127.64.33) To
 bjkjy-mail-ex26.internal.baidu.com (172.31.50.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-01-03 23:38:23:110
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 52:10:53:SYSTEM

There is no nested_vmx_setup function.

It should be nested_vmx_hardware_setup overwrite the VMX emulate handler
when nested=1.

Signed-off-by: Gao Shiyuan <gaoshiyuan@baidu.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 893366e53732..871670eb4994 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6049,7 +6049,7 @@ static int handle_preemption_timer(struct kvm_vcpu *vcpu)
 
 /*
  * When nested=0, all VMX instruction VM Exits filter here.  The handlers
- * are overwritten by nested_vmx_setup() when nested=1.
+ * are overwritten by nested_vmx_hardware_setup() when nested=1.
  */
 static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
 {
-- 
2.39.3 (Apple Git-146)


