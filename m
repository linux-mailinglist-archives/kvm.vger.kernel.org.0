Return-Path: <kvm+bounces-25429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C19E596553E
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:29:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3743EB23E5C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F87612F59C;
	Fri, 30 Aug 2024 02:29:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B259D22619;
	Fri, 30 Aug 2024 02:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724984986; cv=none; b=uCkcN6xdaiuQrPk9aJgKpm3pfB4OAQKFGBq8mXFJvj0ShMafBXnX9vzAkdYxLgjDhC6oyS53eXiuFaJC2mZdAuDUtEmaG4WzKEsAQiJ6/uOk+N/9+TLM7ewbkeH/4Q6mdifk0/4XSqz1vmEcGtmemmn3j+rYrVMh00bL3fst+K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724984986; c=relaxed/simple;
	bh=VAJxpD3Cfof0zbdWuANipGDY5cuDchp+MQ9GKV6YAVU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YRtduWms/G/yD281GLgyI2RXYWu7GK42szIvHUKwe1wiB3PQhXGt+TTK3CXXYPKK8h1nDQv2ZhZCOFhtssCOW9BlnqE7iPDTfi+YdZTI3ST/ewKafcE1VnTYnVdBdbY3n2UEr+wirQVSXZc+PDliGwrlcmtBN3AQtMmx2OGBgEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Ww26V6NjVz20n3m;
	Fri, 30 Aug 2024 10:24:50 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 18DA11400F4;
	Fri, 30 Aug 2024 10:29:42 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 30 Aug
 2024 10:29:41 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] KVM: x86: Remove some unused declarations
Date: Fri, 30 Aug 2024 10:25:37 +0800
Message-ID: <20240830022537.2403873-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit 238adc77051a ("KVM: Cleanup LAPIC interface") removed
kvm_lapic_get_base() but leave declaration.

And other two declarations were never implenmented since introduction.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 arch/x86/kvm/lapic.h            | 1 -
 arch/x86/kvm/mmu.h              | 2 --
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 3 files changed, 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 7ef8ae73e82d..7c95eedd771e 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -96,7 +96,6 @@ u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
 void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
-u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
 void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 4341e0e28571..9dc5dd43ae7f 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -223,8 +223,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 bool kvm_mmu_may_ignore_guest_pat(void);
 
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
-
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..1469a1d9782d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -349,8 +349,6 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
-void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
-
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
-- 
2.34.1


