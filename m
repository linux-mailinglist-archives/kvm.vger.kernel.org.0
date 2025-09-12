Return-Path: <kvm+bounces-57387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E74B5486A
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 11:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19A7E7A55A2
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 09:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8113C286D66;
	Fri, 12 Sep 2025 09:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="M7FTX6A8"
X-Original-To: kvm@vger.kernel.org
Received: from out28-197.mail.aliyun.com (out28-197.mail.aliyun.com [115.124.28.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB9D27A92F;
	Fri, 12 Sep 2025 09:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757670872; cv=none; b=DNktGbhCpFcEoQDmE7UpJScprToZ4FIXDkjLPLcLGVlnk88wRIN0ZK92Yqum4qKCuLS9a3K1EXCzBjfp9dptweV160J4EC0TUN5oRPkutpU2pyzKJBjsoi6qt+VCUQlYOY1Qqe/yHSLwtHi7e0C9b6oyVXFQNWBz+umH8/jJDWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757670872; c=relaxed/simple;
	bh=4V0U4qif233ESxGwWLO4hlL1p9eN4quhFXeJETPVEJk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BoGBxOpKjFkTZEurYWXI9CqDTwzIJnSWE2wDW3MZzKQ7ANru9PieX9LwXewoavtvfwfqu9+sv4WRj9e3rhJlPvM3H3+sgomWOpK+88dC0wxrG8B47e6Kq47Ly8xZW41ipcUWz/WVtyj/2OHP3ZwQAgj955PKVuBEP+TbjWJb2YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=M7FTX6A8; arc=none smtp.client-ip=115.124.28.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757670859; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ow6IKVN5dx/X3ayoTQ9Lplkojet9rFdJLkZhqmqDk8g=;
	b=M7FTX6A8lRt34Q8D7AxQYXudhRNQO9n7421TRixdqBgNijDpq5KG39XvTI1p419l/Z1XW7vTSM+h9fc8EYWwam6E5d5rqe5xIcl9XMup/yMdF4n26VDhdp0IwlLbn1+JCciDmFHkwAraGwqjsr7QTjIIoF42B9qPDAWIplt80pI=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.eddTIgi_1757670859 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 17:54:19 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86: Remove outdated comments and code in kvm_on_user_return()
Date: Fri, 12 Sep 2025 17:54:14 +0800
Message-Id: <b98083ac5ae50cd14585edda4e989ff07bb6e66c.1757669971.git.houwenlong.hwl@antgroup.com>
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
 v1 -> v2: Remove the lockdep_assert_irqs_disabled() because the
           callback can be called by kvm_cpu_offline() with interrupts
	   enabled. Thanks to Chao Gao.

 arch/x86/kvm/x86.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33fba801b205..622a1c27d7f9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -568,18 +568,10 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
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
+	msrs->registered = false;
+	user_return_notifier_unregister(urn);
+
 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
 		values = &msrs->values[slot];
 		if (values->host != values->curr) {
--
2.31.1


