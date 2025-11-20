Return-Path: <kvm+bounces-63775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0728AC7253F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 37C1D4E75BB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9662F12CD;
	Thu, 20 Nov 2025 06:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F5FEP72l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36D0245008;
	Thu, 20 Nov 2025 06:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619532; cv=none; b=THoD3sU1Ph/5jU04o3vsR+NUqOF+vBIpxfVsSA0osRLhJLuKDYLEHlAf9sIau/gJkl1SvxDwQ0q5gQB84Pt2yOU/9QErgd6bh0GJ9InCwOgDQMkq6zIuUsV4699qlWQq6XWBnRytsylx1Og2IlpOrqzDjOu593YZX/nUgaCApPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619532; c=relaxed/simple;
	bh=2kDP/h5XKk2d311MudSRurGHQf2qIocU+MeMeTbQRcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KT3MCCu6vhp5kocpU3kqHMClx3MuMhePH9oyJbGhTTHeeereyfivyvBRRixoKFdEepaSXSvi0HkOsM7krFpa36aZuykfsM/yElVNDB1GWh57YuLyU8RmujAGZddCc21n27zW6m+6MIaTzUIN8JZe2sDTUxI9EUYYIRObnKCLlPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F5FEP72l; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619530; x=1795155530;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2kDP/h5XKk2d311MudSRurGHQf2qIocU+MeMeTbQRcE=;
  b=F5FEP72lQsEitc9gZ00uqwJmAd68vpkgxaTt0PWX8StNiQGgA8UdXaQT
   C+GR9/mcm1HShtkPRCXv4Z5fAIUqHiNqrsFs77HZFLywzY35djVvcLvD2
   +wvKJ5+sYx1aoVvgq7wz0tTSDm6zQV1P3BtiSY22wUdjgudih4UsG1mRI
   FccPXkSLRBbzmtP8W+NVy+laYN4KpzFDKpx0GiVF9Uf6Xp6awm4e1NL0Y
   D0EGcr8cPe5qT8dljmlp8WxzkuLWsSOLE/fTzgVAXgg8tvcGJi+YfwENa
   oTmRkaGj1f6pLwrS9MMEzqA9GiRvq7abnURsPDRgE77jzOri71IC0WS69
   Q==;
X-CSE-ConnectionGUID: mDZGSMuPQbuVtM7+y6I9dA==
X-CSE-MsgGUID: tOSetZHBShG0NapbN8mL3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="76354629"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="76354629"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:50 -0800
X-CSE-ConnectionGUID: 9FbUK+DwTNOMexSW/bdARw==
X-CSE-MsgGUID: 9B4PCwOaS0+sh3c938fvJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="191400585"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:18:50 -0800
Date: Wed, 19 Nov 2025 22:18:49 -0800
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
Subject: [PATCH v4 05/11] x86/vmscape: Rename x86_ibpb_exit_to_user to
 x86_predictor_flush_exit_to_user
Message-ID: <20251119-vmscape-bhb-v4-5-1adad4e69ddc@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>

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



