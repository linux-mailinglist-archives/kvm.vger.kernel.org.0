Return-Path: <kvm+bounces-31578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D219C4FB8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 378362812EF
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0163F20C009;
	Tue, 12 Nov 2024 07:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lttCRNkO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F420BB49;
	Tue, 12 Nov 2024 07:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397204; cv=none; b=qoQ30jafG40M0xfJ6y80GmG7ktzAPxIKL3VPOnLlHszfioHs8T2HXAvwepAhpyuZX12XkJH56YJVQjoZssXoN9CVtgoenYI7zxDfIXHV+XwKIkjjckMHlVH1I/RtgL08IEmDElNnWAXAFRjznFbmAR5GJnm03XJDPc/1fKXnfpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397204; c=relaxed/simple;
	bh=i6gBHuaj0gHh60VTayQdIjmV6bLsnXSbpoPy7aqQGH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=er22eXgWb4yX6UKJtuuBPvcDUo0mW1p2NLq9rDINOXYdAON6UNzp0fktaSXCUkaxpVnjRfrVr92UotoHZ/NWbgsRxYTut221H1wS8/mNyJxaKF9wR8tKTMjQSNlg9JcXzIaZv6RGiz28pz15AhkrtKKPcUpXNdS1lh+PIC9xYLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lttCRNkO; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397202; x=1762933202;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i6gBHuaj0gHh60VTayQdIjmV6bLsnXSbpoPy7aqQGH0=;
  b=lttCRNkOKJI48i/uVj25zzq4Oe45RNEx2xh1y11SBbUuv2VfMDwTqpbE
   cGBXykPC99SEGZ2sPEKrmcSzhDdstzsVzDjAXib3XZ3Dzim9KCgHxyRTn
   MuyReFGiLqxbBVZ9xGZ8U2v3lA5et+pMbCp2fd0o34nZr6AsbvTzwMHM2
   Vdp6jpeEdZ4RmYippIIP9fJJ8oYpnC5OfvSz3yR2zMf5TiRznxhiqKt+B
   mk4fso/LLzDsGI9HYM+9Ml463YAgWa7C6l0E5hG2zvWHjGbG+8eRuwTec
   acXJFZikzWlsLO/a4+nVm7GoiRqJsIakuYcqYFbvZ3DxyORJdpPesLO8t
   A==;
X-CSE-ConnectionGUID: jpXVPQQpQrqD2G9/tnCucg==
X-CSE-MsgGUID: rX0N0It4T72CFgeIAoXpZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31090602"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31090602"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:40:02 -0800
X-CSE-ConnectionGUID: SkO8oupuQfeCxZqUq5hV/A==
X-CSE-MsgGUID: CzCvCOZ/QB2wKLxcUc4EDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="88115312"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:58 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 15/24] KVM: x86/mmu: Add setter for shadow_mmio_value
Date: Tue, 12 Nov 2024 15:37:30 +0800
Message-ID: <20241112073730.22200-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Future changes will want to set shadow_mmio_value from TDX code. Add a
helper to setter with a name that makes more sense from that context.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[split into new patch]
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v2:
 - Added Paolo's rb

TDX MMU part 2 v1:
 - Split into new patch
---
 arch/x86/kvm/mmu.h      | 1 +
 arch/x86/kvm/mmu/spte.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 398b6b06ed73..a935e65a133d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -78,6 +78,7 @@ static inline gfn_t kvm_mmu_max_gfn(void)
 u8 kvm_mmu_get_max_tdp_level(void);
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index f1a50a78badb..a831e76f379a 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -422,6 +422,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
+void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
+{
+	kvm->arch.shadow_mmio_value = mmio_value;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_value);
+
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
 {
 	/* shadow_me_value must be a subset of shadow_me_mask */
-- 
2.43.2


