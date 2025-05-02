Return-Path: <kvm+bounces-45224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0297AA72F2
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:10:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35FC94C818D
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E948F255F55;
	Fri,  2 May 2025 13:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VX3hW1dt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E5C255F35;
	Fri,  2 May 2025 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191327; cv=none; b=McEU6O55S6xbwtmQUpSpvO4zWBxD/8SRBp6qJaHgWqLYituNU5jEksu1rMc+sd7M5GHMawh/GxxB+6tkpT6fe3NyP/QpCALqmN121E73oRvM2S1S+5TqizT/Wu/ICPjY9MjuypRAFMqnMRQwFYOlveQaqBuqgCb/0Eep3vdK08s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191327; c=relaxed/simple;
	bh=I6qbJYYYEbsv9ghw69w99htbaZsoBJusuXa9G8q9fEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXaWDe7wK1Q/lb2PopcpIBYXZTA5wsAJTWScyiLh65JPd9SJeJxChnCmfybS4NpeUhOHNc/wmFcbWUhKFO4Pum1WO3CaGLVxt7baSCV2xWG2xCuiOGJ65ZHBHTq+F75LXQqa/sCSCnRCxUk4LVDnCII2RfOCuYViD4De5MMr5jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VX3hW1dt; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191325; x=1777727325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I6qbJYYYEbsv9ghw69w99htbaZsoBJusuXa9G8q9fEE=;
  b=VX3hW1dtyYS2XViTen4Ki/lODtaQLTz24n3LiEFcbvjPio/0EJ4/abVV
   S+THQnYYyhw66B9PaXtAGLjJQ3NP09C2bh/FnaddRS/B4hbE4pBkWNmo3
   UmoeNnmiWAvE634I0OkI0RiA0cT8JpOhM3XK5F1AZq+icAlIMkAl8eZ6j
   8kOuZBPDQR57wLYsIr121LUGLtU8ssoIsqxxf2qFIrlwCyZhfOrCZaNHs
   yHjJjgPC33ygwBthsxmwUlQ++YZv86YvwxBYqmK9auOIwHY26Et/4Woge
   /EBRGiyriq5zE8M5b+ZqcRm9SppXA+qBUcC+1VmOBpkWLH36Az3HzatfI
   Q==;
X-CSE-ConnectionGUID: nBitgRh1TUCYEiPHVytP9w==
X-CSE-MsgGUID: pp1tPVEfQ9WZYLIwxbnKhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="48012987"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="48012987"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:45 -0700
X-CSE-ConnectionGUID: IIAkqwwPTfGrRroE/gPC2A==
X-CSE-MsgGUID: tzKiF+OjR1SUi0GIX1ZPUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="157871091"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 02 May 2025 06:08:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 7A599366; Fri, 02 May 2025 16:08:36 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH 09/12] KVM: TDX: Preallocate PAMT pages to be used in page fault path
Date: Fri,  2 May 2025 16:08:25 +0300
Message-ID: <20250502130828.4071412-10-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preallocate a page to be used in the link_external_spt() and
set_external_spte() paths.

In the worst-case scenario, handling a page fault might require a
tdx_nr_pamt_pages() pages for each page table level.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 91958c55f918..a5661499a176 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -849,6 +849,8 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
+	struct kvm_mmu_memory_cache pamt_page_cache;
+
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
 	 * In vcpu_run, we switch between the user and guest FPU contexts.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a284dce227a0..7bfa0dc50440 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -616,6 +616,15 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 		if (r)
 			return r;
 	}
+
+	if (vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM) {
+		int nr = tdx_nr_pamt_pages(tdx_get_sysinfo());
+		r = kvm_mmu_topup_memory_cache(&vcpu->arch.pamt_page_cache,
+					       nr * PT64_ROOT_MAX_LEVEL);
+		if (r)
+			return r;
+	}
+
 	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
 					  PT64_ROOT_MAX_LEVEL);
 }
@@ -626,6 +635,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.pamt_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-- 
2.47.2


