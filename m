Return-Path: <kvm+bounces-65604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5204CB13E0
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 22:53:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5F4A314CF7A
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 21:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72B5830E85D;
	Tue,  9 Dec 2025 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ads6K1jj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8D230AABE
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313564; cv=none; b=aab39INdrpvOqJv2Qqkj8gJEVMMCShqtIFnEkXrGm7nkwz0115d3tuNxL3jy7E+CqAslYZqtsQJubj+4s3YhZnjozvKlf/pVcdDZRTF+34/7Mq+3YGPnwzTv1klnHvra75La4qhzj+LfdYlacuaKZnCc3QNWtPxiWpGJ7kDgkUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313564; c=relaxed/simple;
	bh=GwGbfZNMQrxTg0XvIeuMl4EOESaBksVkYIRF2UfMQpc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cnxJC3h0V6Q1PKZAhNvJCwS/LlCUY5T6y6wtXJmyD9WNfv+m2GxNAfKtt+oKriW1f7qneVWp/QM48z0oPXdEYDM1V4LY3mOSFBid/tRrZUJbfsP7kenFxCnYn1xtLST4mpBPjq7xuU+Dv/XT7o+14ZtEG/DZQ1+/EUMQjh+5jnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ads6K1jj; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-65997ee5622so5654369eaf.1
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313556; x=1765918356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XyMhuaQls3hUZ6GN0FBCXMwBUjXHqrFvzqVQVVR2z7A=;
        b=Ads6K1jjI9OZatCDJzkBSrS8txAqsPWKY4vRBWH1sZ3+KBXiQVLMW7eZtSJNgbJvOC
         an9n17zrBpmKu1hS1jzYeQkvCAbjxN/F9Vo4PBVS7xM0dRqLrCvw0XTE2rCYsG1mJ9PH
         HiKgkJhWzFIDokxA0RpnmIgqogOEk0WB3i5ne1yZv7Q+iIV49w8F51d59ODayKUk9gJI
         MERrP1OS3km6HxJg8lMxgtvkRpQYKVIDmEN7Uic+dgC0JLsJa7uyvEU+/Pf8KhPBzNat
         bak/AMaaKnve2gvCfc7y6dFb9aQ9PQqS0TZTXGogWF5clCIwbtgxntWURZxtDIZGGRut
         vO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313556; x=1765918356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XyMhuaQls3hUZ6GN0FBCXMwBUjXHqrFvzqVQVVR2z7A=;
        b=G7RVmA6qw2CqzaTHfzqvcX4nMwbuZyaFCFoxJ6wFzYKzLQ6m3yrcC+69X4zjnUMdKH
         5Hbzu8dJmj1xURBLitIoP2IpSQVYOrceoWecgtX4wfdT0vpeVLMScR0SWVLfcbw607Yl
         o2i6bSct+YEwrUxu+kFSFmxM3Jd9mXFkK6btdS+BbD+3AXQQfOXjKOSOkLDOSRWQWP0m
         PQPpCvqqG27ablnfYTBoBzVIEAn2kmKfu0Z+HYR51TREj3u0xdtvB818qrNSL4nb6az2
         JH90kvUPEmvMmnLSYFAntkTUiR3C/ZDw1MHQRmH80MTgdcPf0svBxuq09ItaNtxQL2QZ
         KSMw==
X-Gm-Message-State: AOJu0Yz46SNLK/7o2+iID3ndcMfcj+vYS1SQMQxgnN6Q2IiVwsV3xNak
	Ff6QoKWeTL5ii1UMkuCh76i9yMOrrv3AVis8Pt0SkoIo0gVyB/m9A3pT49wcFevUpATQ9RDvK3O
	aHdzGmukDmhQcNJUAyUeWuIK9vAVqQlsj/Frow73uVOert+1g56e1S0fkPLxWjHUVa6CormtI42
	yoLY29SJiQLIXcpbQnMSl1oHf2OX326JP5QGEY7PYxQyaxoGgYjt84Kkv9pi0=
X-Google-Smtp-Source: AGHT+IEL2YXntnNluNzyop1DJKdNOL9WpvG30YFGZ5q0MGpLQ+kw1q3/XcXCa4YnfEMsFjzbz6E8dm5ob96Qli2iIg==
X-Received: from ilbbs15.prod.google.com ([2002:a05:6e02:240f:b0:434:972f:bf91])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:81c1:b0:659:9a49:8ec0 with SMTP id 006d021491bc7-65b2ad8bbf7mr124430eaf.68.1765313556199;
 Tue, 09 Dec 2025 12:52:36 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:07 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-11-coltonlewis@google.com>
Subject: [PATCH v5 10/24] KVM: arm64: Set up FGT for Partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

In order to gain the best performance benefit from partitioning the
PMU, utilize fine grain traps (FEAT_FGT and FEAT_FGT2) to avoid
trapping common PMU register accesses by the guest to remove that
overhead.

Untrapped:
* PMCR_EL0
* PMUSERENR_EL0
* PMSELR_EL0
* PMCCNTR_EL0
* PMCNTEN_EL0
* PMINTEN_EL1
* PMEVCNTRn_EL0

These are safe to untrap because writing MDCR_EL2.HPMN as this series
will do limits the effect of writes to any of these registers to the
partition of counters 0..HPMN-1. Reads from these registers will not
leak information from between guests as all these registers are
context swapped by a later patch in this series. Reads from these
registers also do not leak any information about the host's hardware
beyond what is promised by PMUv3.

Trapped:
* PMOVS_EL0
* PMEVTYPERn_EL0
* PMCCFILTR_EL0
* PMICNTR_EL0
* PMICFILTR_EL0
* PMCEIDn_EL0
* PMMIR_EL1

PMOVS remains trapped so KVM can track overflow IRQs that will need to
be injected into the guest.

PMICNTR and PMIFILTR remain trapped because KVM is not handling them
yet.

PMEVTYPERn remains trapped so KVM can limit which events guests can
count, such as disallowing counting at EL2. PMCCFILTR and PMCIFILTR
are special cases of the same.

PMCEIDn and PMMIR remain trapped because they can leak information
specific to the host hardware implementation.

NOTE: This patch temporarily forces kvm_vcpu_pmu_is_partitioned() to
be false to prevent partial feature activation for easier debugging.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h | 33 ++++++++++++++++++++++
 arch/arm64/kvm/config.c          | 34 ++++++++++++++++++++--
 arch/arm64/kvm/pmu-direct.c      | 48 ++++++++++++++++++++++++++++++++
 3 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 8887f39c25e60..7297a697a4a62 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -96,6 +96,23 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+#if !defined(__KVM_NVHE_HYPERVISOR__)
+bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
+#else
+static inline bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+#endif
+u64 kvm_pmu_fgt_bits(void);
+u64 kvm_pmu_fgt2_bits(void);
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -135,6 +152,22 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 {
 	return 0;
 }
+static inline bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+static inline u64 kvm_pmu_fgt_bits(void)
+{
+	return 0;
+}
+static inline u64 kvm_pmu_fgt2_bits(void)
+{
+	return 0;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 24bb3f36e9d59..064dc6aa06f76 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -6,6 +6,7 @@
 
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_pmu.h>
 #include <asm/kvm_nested.h>
 #include <asm/sysreg.h>
 
@@ -1489,12 +1490,39 @@ static void __compute_hfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HFGWTR_EL2) |= HFGWTR_EL2_TCR_EL1;
 }
 
+static void __compute_hdfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGRTR_EL2);
+
+	if (kvm_vcpu_pmu_use_fgt(vcpu))
+		*vcpu_fgt(vcpu, HDFGRTR_EL2) |= kvm_pmu_fgt_bits();
+}
+
 static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 {
 	__compute_fgt(vcpu, HDFGWTR_EL2);
 
 	if (is_hyp_ctxt(vcpu))
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= HDFGWTR_EL2_MDSCR_EL1;
+
+	if (kvm_vcpu_pmu_use_fgt(vcpu))
+		*vcpu_fgt(vcpu, HDFGWTR_EL2) |= kvm_pmu_fgt_bits();
+}
+
+static void __compute_hdfgrtr2(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGRTR2_EL2);
+
+	if (kvm_vcpu_pmu_use_fgt(vcpu))
+		*vcpu_fgt(vcpu, HDFGRTR2_EL2) |= kvm_pmu_fgt2_bits();
+}
+
+static void __compute_hdfgwtr2(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, HDFGWTR2_EL2);
+
+	if (kvm_vcpu_pmu_use_fgt(vcpu))
+		*vcpu_fgt(vcpu, HDFGWTR2_EL2) |= kvm_pmu_fgt2_bits();
 }
 
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
@@ -1505,7 +1533,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HFGRTR_EL2);
 	__compute_hfgwtr(vcpu);
 	__compute_fgt(vcpu, HFGITR_EL2);
-	__compute_fgt(vcpu, HDFGRTR_EL2);
+	__compute_hdfgrtr(vcpu);
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
 
@@ -1515,6 +1543,6 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_fgt(vcpu, HFGRTR2_EL2);
 	__compute_fgt(vcpu, HFGWTR2_EL2);
 	__compute_fgt(vcpu, HFGITR2_EL2);
-	__compute_fgt(vcpu, HDFGRTR2_EL2);
-	__compute_fgt(vcpu, HDFGWTR2_EL2);
+	__compute_hdfgrtr2(vcpu);
+	__compute_hdfgwtr2(vcpu);
 }
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index d5de7fdd059f4..4dd160c878862 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -43,6 +43,54 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
 		pmu->hpmn_max <= *host_data_ptr(nr_event_counters);
 }
 
+/**
+ * kvm_vcpu_pmu_is_partitioned() - Determine if given VCPU has a partitioned PMU
+ * @vcpu: Pointer to kvm_vcpu struct
+ *
+ * Determine if given VCPU has a partitioned PMU by extracting that
+ * field and passing it to :c:func:`kvm_pmu_is_partitioned`
+ *
+ * Return: True if the VCPU PMU is partitioned, false otherwise
+ */
+bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu) &&
+		false;
+}
+
+/**
+ * kvm_vcpu_pmu_use_fgt() - Determine if we can use FGT
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Determine if we can use FGT for direct access to registers. We can
+ * if capabilities permit the number of guest counters requested.
+ *
+ * Return: True if we can use FGT, false otherwise
+ */
+bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	u8 hpmn = vcpu->kvm->arch.nr_pmu_counters;
+
+	return kvm_vcpu_pmu_is_partitioned(vcpu) &&
+		cpus_have_final_cap(ARM64_HAS_FGT) &&
+		(hpmn != 0 || cpus_have_final_cap(ARM64_HAS_HPMN0));
+}
+
+u64 kvm_pmu_fgt_bits(void)
+{
+	return HDFGRTR_EL2_PMOVS
+		| HDFGRTR_EL2_PMCCFILTR_EL0
+		| HDFGRTR_EL2_PMEVTYPERn_EL0
+		| HDFGRTR_EL2_PMCEIDn_EL0
+		| HDFGRTR_EL2_PMMIR_EL1;
+}
+
+u64 kvm_pmu_fgt2_bits(void)
+{
+	return HDFGRTR2_EL2_nPMICFILTR_EL0
+		| HDFGRTR2_EL2_nPMICNTR_EL0;
+}
+
 /**
  * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
  * @pmu: Pointer to arm_pmu struct
-- 
2.52.0.239.gd5f0c6e74e-goog


