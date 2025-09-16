Return-Path: <kvm+bounces-57673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63DFCB58E3D
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:08:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED6001BC5584
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 06:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F48529BDA3;
	Tue, 16 Sep 2025 06:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="b2D1DWtN"
X-Original-To: kvm@vger.kernel.org
Received: from out198-21.us.a.mail.aliyun.com (out198-21.us.a.mail.aliyun.com [47.90.198.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD1C189;
	Tue, 16 Sep 2025 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758002883; cv=none; b=V5jnM+hGrWTR54IoZHFkZplIyNpuGoYYti0YIJ3QeWNi5oipYZPGJUc3dkyuLVMCxgBZVao3MlMzMJ8GbN8hGjchecQwqj21p7puH7hffvgjMisy4ktTdAYLWSXCpxQMJ1kFzq6gMgg4bqdwn5X7J0RUNFF7/1bA5aFObrQpeCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758002883; c=relaxed/simple;
	bh=xJDykpntbbVXiLGqjIDl56Dl3um1Fz1AbkEjFrb3hNE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RYGxn12N9ggtRVZzYJ2ahnieLWoPe0FX3t9vcVxOMswQnraVhiDdhj7GvEwNCzxldiJf8ACRaUytO00EMJvOlGgYOcCPopqPtYVU9h3d02Gk/9+F1WVQbesosvq8V1dRjXVPnzxY/oMkbSVzukboggniOpRcMfisdnwGIwN+Bf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=b2D1DWtN; arc=none smtp.client-ip=47.90.198.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1758002861; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=CUuL5HsQnlh6tyXbC5mppmtLavwtwsnAVV8BvQq8+XI=;
	b=b2D1DWtNj6YinIcsoU++qqrxux/DNyRj7mps98CmvZuWUylcBC6Mii2zQVboJaBTY9TS/E0UxXx4kMdgHulOH7gK2TtyoA8v94Uknv1EbtjEqIOIKBIJlq4TKtYuvsO4sKaKn5hAavG1JU92WMnMP9dxcjeP/PDONrrw8jHxv1I=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.eg0VmUu_1758002860 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 16 Sep 2025 14:07:41 +0800
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
Subject: [PATCH v3 2/2] KVM: x86: Change the outdated comments and code in kvm_on_user_return()
Date: Tue, 16 Sep 2025 14:07:36 +0800
Message-Id: <4d65465545b2ccebda3a0c3e601320578024ed3b.1758002303.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com>
References: <15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit a377ac1cd9d7b ("x86/entry: Move user return notifier out of
loop") moved fire_user_return_notifiers() into the section with IRQs
disabled, and it somewhat inadvertantly fixed the underlying issue that
was papered over by commit 1650b4ebc99d ("KVM: Disable irq while
unregistering user notifier").  Therefore, the comments and code are
outdated.  Aslo assert that IRQs are disabled in kvm_on_user_return(),
as both fire_user_return_notifiers() and
kvm_arch_disable_virtualization_cpu() are now in IRQs disabled state.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 33fba801b205..84fc30a99be1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -568,18 +568,18 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	struct kvm_user_return_msrs *msrs
 		= container_of(urn, struct kvm_user_return_msrs, urn);
 	struct kvm_user_return_msr_values *values;
-	unsigned long flags;
 
 	/*
-	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_disable_virtualization_cpu()
+	 * Assert that IRQs are disabled.  KVM disables virtualization via IPI
+	 * callback on reboot, and this code isn't safe for re-entrancy, e.g.
+	 * receiving the IRQ after checking "registered" would lead to double
+	 * deletion of KVM's notifier.
 	 */
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


