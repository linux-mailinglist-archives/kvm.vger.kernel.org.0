Return-Path: <kvm+bounces-65075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 477D7C9A385
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 999713A558E
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048963002DB;
	Tue,  2 Dec 2025 06:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OsA1c+JX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA6C2F6189;
	Tue,  2 Dec 2025 06:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656372; cv=none; b=XW8zmswN9Z9FwAnYcXIhU81wH4LLrPgI+qwv5QniBdijO8qwdPb7qUZvFgI8pIQJ5N5VX3XEjS7Zt0utgfhUnZFQgP+i4epEqpVpiDJQWaEqGIENScJ+VC1e4OdUJaflwa/XIu34DJip5lEveJCTvh1kTX0OEXEkb4iDccVdMZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656372; c=relaxed/simple;
	bh=2kDP/h5XKk2d311MudSRurGHQf2qIocU+MeMeTbQRcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SEi027yEBwCqpniW96YMFDVpt/EHBO1n6JCsVFRiCgp+95FALc0K3SaotS3kxAXw/P6oDUSV+VPl0odRWcNbMzIz5b+I7ht+tr/jL85TwN3AOTraJEfeFbjZ0bSZFAzoXnIoUMot9btt2ujeRxaGnoudujiyeujHIRxgUxKsiHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OsA1c+JX; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656371; x=1796192371;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2kDP/h5XKk2d311MudSRurGHQf2qIocU+MeMeTbQRcE=;
  b=OsA1c+JXB85/wuOSqDzjf4T5grVmLYoGLqYUSNChEh49fxM1b1w3n9s8
   7T8vlZmamsKazNCbiQbNvVbVTR5O1wsY94zuzyxKdKiOsc4kgITgNQf6v
   g+vYuluau3y+QEN4TzuObJI12GUE/pbQfyzzJuLYtJhNWZsFiDYgRv+Ax
   rjVWXLz+krmlhu0dzl3SRjV5cqI2uIxtTWIZDYDmdfSebVd6n/tzy/a2y
   TJQGOdhLPqLvSuCRe9nfQjpAsyn5NEBNn27LXFPdWGdiK/SfKk51JvwC5
   R8lWonih6D5ZHZrG11wWbio/pTu4AFMGB9d/WdWTb64tniWxXO65uZZgU
   w==;
X-CSE-ConnectionGUID: uoA2GqmQTkGLVRyKDQUHZQ==
X-CSE-MsgGUID: DMp3jjcnT/ChniXC7//YFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66499111"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="66499111"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:30 -0800
X-CSE-ConnectionGUID: mwJ23ZXBRp2MHPGVBEvkXA==
X-CSE-MsgGUID: 4kivsGHuT5+2u4tw0Ixxzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="194276824"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:30 -0800
Date: Mon, 1 Dec 2025 22:19:29 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v6 3/9] x86/vmscape: Rename x86_ibpb_exit_to_user to
 x86_predictor_flush_exit_to_user
Message-ID: <20251201-vmscape-bhb-v6-3-d610dd515714@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>

With the upcoming changes x86_ibpb_exit_to_user will also be used when BHB
clearing sequence is used. Rename it cover both the cases.

No functional change.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/entry-common.h  | 6 +++---
 arch/x86/include/asm/nospec-branch.h | 2 +-
 arch/x86/kernel/cpu/bugs.c           | 4 ++--
 arch/x86/kvm/x86.c                   | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce3eb6d5fdf9f2dba59b7bad24afbfafc8c36918..c45858db16c92fc1364fb818185fba7657840991 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -94,11 +94,11 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 	 */
 	choose_random_kstack_offset(rdtsc());
 
-	/* Avoid unnecessary reads of 'x86_ibpb_exit_to_user' */
+	/* Avoid unnecessary reads of 'x86_predictor_flush_exit_to_user' */
 	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER) &&
-	    this_cpu_read(x86_ibpb_exit_to_user)) {
+	    this_cpu_read(x86_predictor_flush_exit_to_user)) {
 		indirect_branch_prediction_barrier();
-		this_cpu_write(x86_ibpb_exit_to_user, false);
+		this_cpu_write(x86_predictor_flush_exit_to_user, false);
 	}
 }
 #define arch_exit_to_user_mode_prepare arch_exit_to_user_mode_prepare
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index ec5ebf96dbb9e240f402f39efc6929ae45ec8f0b..df60f9cf51b84e5b75e5db70713188d2e6ad0f5d 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -531,7 +531,7 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
 		: "memory");
 }
 
-DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
+DECLARE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
 
 static inline void indirect_branch_prediction_barrier(void)
 {
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d7fa03bf51b4517c12cc68e7c441f7589a4983d1..1e9b11198db0fe2483bd17b1327bcfd44a2c1dbf 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -113,8 +113,8 @@ EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
  * be needed to before running userspace. That IBPB will flush the branch
  * predictor content.
  */
-DEFINE_PER_CPU(bool, x86_ibpb_exit_to_user);
-EXPORT_PER_CPU_SYMBOL_GPL(x86_ibpb_exit_to_user);
+DEFINE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
+EXPORT_PER_CPU_SYMBOL_GPL(x86_predictor_flush_exit_to_user);
 
 u64 x86_pred_cmd __ro_after_init = PRED_CMD_IBPB;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9c2aa6f4705e1ae257bf94572967a5724a940a7..60123568fba85c8a445f9220d3f4a1d11fd0eb77 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11397,7 +11397,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * may migrate to.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_IBPB_EXIT_TO_USER))
-		this_cpu_write(x86_ibpb_exit_to_user, true);
+		this_cpu_write(x86_predictor_flush_exit_to_user, true);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of

-- 
2.34.1



