Return-Path: <kvm+bounces-73068-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GF2kHTXgqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73068-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:09:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE8082225A2
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D284031001CF
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74B1F3B3C00;
	Fri,  6 Mar 2026 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CyxmnXmE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF533AA1B0
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805770; cv=none; b=EwaUNc6vzHkvw1s0/VXOwK30gtRqwzUOH6tsr75os1P/TGkZljbDjoMXNzVrSrVzMqDTijVVo5krLxPHiYJ50ha73DzZk/T92+nKa6CqSBiodRf40QSoZWKfqqxyIz9bqdMbQu5FTWtMrW13xigWGRIHXJ5dD+tAsX5KujS01fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805770; c=relaxed/simple;
	bh=+Ldh0+/D/HHrWGmCO9GX6+5phztxSLCN39mSxeUJJmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gf3NOeXix1RaCXBQvjY4CMceUvuC1WhyU4f6rEgsCVq+v/W+nbSzKY9Qfg8oO4lUF04UiV3L4Im96Vuz0Tj1C4sIRS68cGnHDlobSdKvk3vc3A4KGQu5kMbYzNQ1qlrt1GGh0uqvsXYKbWjzEXGg2X25r5BIUHbfpzgKoEqoa0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CyxmnXmE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837b7903f3so123841875e9.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805766; x=1773410566; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B+HYtjlbkRRsULmqIMWL6+36I9njVaiGl+dbXdeyjSs=;
        b=CyxmnXmEysjIH5gpomXGxcy0GY6bsMEIULKPLCTzzXHkx5ExITQ9wcRsV3WZJTyOYO
         bPMKYi54mq+6B3X1EWT7dwJlLBElhLpZG8OtX53+AkSP+D5E/g+jQ/7iazzjPUSJnGmP
         JBzVSM3ciqZlUULs8mS9cDmrkE3VgCtZemt/isenZGNU3OwFcJX/GkJ9sOnkN+V9eFBH
         LMRDmM7Ab/EhJZT7uFUhg7q9u+xehXPrlAvLT2fuZ0IihPJ8RiKGcDvl9Z97CkGWHa+7
         g0fL+mgoCyCau83Jpfc+fumKzb9HgFfinrEl/UiyyKSj4aSTYsVnDgKg/nLhKBszoyzJ
         qdUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805766; x=1773410566;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+HYtjlbkRRsULmqIMWL6+36I9njVaiGl+dbXdeyjSs=;
        b=FtAdRi5tYY/Xcz4TkK0IeVoYyqtKTSBmpozJXHteZwHvDfJTfIBp20epzgmNi66lWi
         HHwfgzsIsPpNQjFm8gh4ZyklJM+8oxYKFxb2UUKOZ5p7Ip1NwQEmzrsm5GcjJlR1UaG1
         4C47Eb+DUQmR3lTii/jHiEA/ObY5lbJl7TLyiZKXVds4RocNCWqWiD+KqxYZwl+pmTMl
         Dve6mbVgu6tjdgSy/6ZzcS7i9HSurDeUlKKBjrk7Z/qTn3UDvO8dKC8k0Tw9GceMP+yo
         oftU/v6oTZab0IcUnxBzsdczNtqKex0vdcI3EGJ3bMF7vEls+wRGSpahRC4b/JdV2V0U
         RRog==
X-Gm-Message-State: AOJu0YzbEjebeapEsMTSQTheDQJ0shlQbT0mHj77QNDQxW+/5HdALliF
	BWjgem7FKwjWPjtCVi5OLKWBSD+IMwRxm04dO3EtHwGzRXC3ikNGz6gD/yY7567WMe2VfSVpl2v
	t3JnIO25CMP+seeSOUKzF4e2V7HKzSmOXS6cmqXxmLituKcVmx3apFmPnFH7GOVY+ZBsl0VF7xH
	jjHUbJqSeKkRs2KLj/lun/vXZR5jI=
X-Received: from wmgb17.prod.google.com ([2002:a05:600c:1511:b0:480:6b05:6b98])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45d1:b0:477:7c7d:d9b2
 with SMTP id 5b1f17b1804b1-4852697844emr35672325e9.32.1772805766479; Fri, 06
 Mar 2026 06:02:46 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:29 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-11-tabba@google.com>
Subject: [PATCH v1 10/13] KVM: arm64: Initialize struct kvm_s2_fault
 completely at declaration
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: CE8082225A2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73068-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,fault.page:url]
X-Rspamd-Action: no action

Simplify the initialization of struct kvm_s2_fault in user_mem_abort().

Instead of partially initializing the struct via designated initializers
and then sequentially assigning the remaining fields (like write_fault
and topup_memcache) further down the function, evaluate those
dependencies upfront.

This allows the entire struct to be fully initialized at declaration. It
also eliminates the need for the intermediate fault_data variable and
its associated fault pointer, reducing boilerplate.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 35bcacba5800..2d6e749c1756 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1962,8 +1962,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  bool fault_is_perm)
 {
-	int ret = 0;
-	struct kvm_s2_fault fault_data = {
+	bool write_fault = kvm_is_write_fault(vcpu);
+	bool logging_active = memslot_is_logging(memslot);
+	struct kvm_s2_fault fault = {
 		.vcpu = vcpu,
 		.fault_ipa = fault_ipa,
 		.nested = nested,
@@ -1971,19 +1972,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		.hva = hva,
 		.fault_is_perm = fault_is_perm,
 		.ipa = fault_ipa,
-		.logging_active = memslot_is_logging(memslot),
-		.force_pte = memslot_is_logging(memslot),
-		.s2_force_noncacheable = false,
+		.logging_active = logging_active,
+		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
+		.fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
+		.write_fault = write_fault,
+		.exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
+		.topup_memcache = !fault_is_perm || (logging_active && write_fault),
 	};
-	struct kvm_s2_fault *fault = &fault_data;
 	void *memcache;
+	int ret;
 
-	if (fault->fault_is_perm)
-		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
-	fault->write_fault = kvm_is_write_fault(fault->vcpu);
-	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
-	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
+	VM_WARN_ON_ONCE(fault.write_fault && fault.exec_fault);
 
 	/*
 	 * Permission faults just need to update the existing leaf entry,
@@ -1991,9 +1991,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * only exception to this is when dirty logging is enabled at runtime
 	 * and a write fault needs to collapse a block entry into a table.
 	 */
-	fault->topup_memcache = !fault->fault_is_perm ||
-				(fault->logging_active && fault->write_fault);
-	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
+	ret = prepare_mmu_memcache(vcpu, fault.topup_memcache, &memcache);
 	if (ret)
 		return ret;
 
@@ -2001,17 +1999,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
 	 */
-	ret = kvm_s2_fault_pin_pfn(fault);
+	ret = kvm_s2_fault_pin_pfn(&fault);
 	if (ret != 1)
 		return ret;
 
-	ret = kvm_s2_fault_compute_prot(fault);
+	ret = kvm_s2_fault_compute_prot(&fault);
 	if (ret) {
-		kvm_release_page_unused(fault->page);
+		kvm_release_page_unused(fault.page);
 		return ret;
 	}
 
-	return kvm_s2_fault_map(fault, memcache);
+	return kvm_s2_fault_map(&fault, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.53.0.473.g4a7958ca14-goog


