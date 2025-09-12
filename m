Return-Path: <kvm+bounces-57366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00BDBB54430
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 09:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0D47480889
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 07:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79A82D375D;
	Fri, 12 Sep 2025 07:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="YGVLbFd+"
X-Original-To: kvm@vger.kernel.org
Received: from out28-147.mail.aliyun.com (out28-147.mail.aliyun.com [115.124.28.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6E82D29AA;
	Fri, 12 Sep 2025 07:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757663487; cv=none; b=gN24TU+7u05nEfWgQM+e/2FrjlH3YrC4bEZ+51Vl2qVhGMgp2ky2il1GfDAp4KBT21aB/OxEIaUIruvMjhzkaYtuLzZrLNeF/2jQaLBnUXxShJ9k8tgRIimIUcKKGGh0hyUvyR5zeg9/k71XY2vjYrSrrN+++hEoYI5tBH6qgos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757663487; c=relaxed/simple;
	bh=+7cuRViXLTexrEIEUZA2QAJ4I+5l6HYL3aEUlsCnhp4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UfWGrevKNtO+qHqnRB3CEZWss2dPeQSlqMhG/p5X6LAipMEtJ2k1Vwco0se8hH7KahIgBr6X2dX9/YM6dREdHjEz0/Afsx8VRTK2Tvjv2MUy/OBhPnnudi4yq7noFO0tQC7K3LpJVCFgKr7ssgw/8TR8cZzb04+7wD53jp7rllY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=YGVLbFd+; arc=none smtp.client-ip=115.124.28.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757663474; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=rgJcjAAgcEufnx4dvFsLoKLGeIBqnR126SH2k6vCfIE=;
	b=YGVLbFd+w9edfr1p8Z8P1B2DanOHlqV+q79NiQ/ezNst+NS+UicNb2jIoB3Z7Is5+ygBts4fGsqYoSAUkl1qqOL58IUdPd2JhvKdtgmE4MEKAwcfe3Z0ldhbEUHaIfQQbSFMgsJfnjDd4RVBos//NFbBYPdry06hJa3lxSmLZMQ=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.edPmhxg_1757662530 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 15:35:30 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Remove outdated comments and code in kvm_on_user_return()
Date: Fri, 12 Sep 2025 15:35:29 +0800
Message-Id: <c10fb477105231e62da28f12c94c5452fa1eff74.1757662000.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit a377ac1cd9d7b ("x86/entry: Move user return notifier out of
loop") moved fire_user_return_notifiers() into the section with
interrupts disabled, so the callback kvm_on_user_return() cannot be
interrupted by kvm_arch_disable_virtualization_cpu() now. Therefore,
remove the outdated comments and local_irq_save()/local_irq_restore()
code in kvm_on_user_return().

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33fba801b205..10afbacb1851 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -568,18 +568,12 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	struct kvm_user_return_msrs *msrs
 		= container_of(urn, struct kvm_user_return_msrs, urn);
 	struct kvm_user_return_msr_values *values;
-	unsigned long flags;

-	/*
-	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
-	 */
-	local_irq_save(flags);
-	if (msrs->registered) {
-		msrs->registered = false;
-		user_return_notifier_unregister(urn);
-	}
-	local_irq_restore(flags);
+	lockdep_assert_irqs_disabled();
+
+	msrs->registered = false;
+	user_return_notifier_unregister(urn);
+
 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
 		values = &msrs->values[slot];
 		if (values->host != values->curr) {
--
2.31.1


