Return-Path: <kvm+bounces-65079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEA5C9A3B1
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 629094E3CFD
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CDC301472;
	Tue,  2 Dec 2025 06:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UtN2gUBz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7242FF170;
	Tue,  2 Dec 2025 06:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656434; cv=none; b=M9ecX7hkOAsRqLGfQw0MlCC+GHtBa/tqJ4VVcigy92xg4Ho1i+Xl2Dz71l7JnCnekoD1NQlPrTHv2ztwSXpF6wcvZNF7Qs1PdCE8t6T2xMzWGEew/e+x/TVenJqhQEtrN+21sgFHv42A/xOKfbUMvqrB9wAdMznxbdqVIlB9VT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656434; c=relaxed/simple;
	bh=ZQhMVnv9d/AX3bUhl3PykwO88qYd8dFN+pQByBWxHEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vu5j4uN5/3w+CivQLkBNHXnQGmcxvMBVIvrqnBcQEyo2ogxq5OCnTewzA25UqncaQ928yCrZYqheKcItQsf++Whc8fra4zueUwyFyrpUGLd7MfHuR1ftGZ2ISKzh84OdoLnRiCx8/9VScgdicPEiX35jnazbdpntIHBLhu+94O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UtN2gUBz; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656433; x=1796192433;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZQhMVnv9d/AX3bUhl3PykwO88qYd8dFN+pQByBWxHEk=;
  b=UtN2gUBz8dlodpiABn2Sv4l9VRnwqnlLyGqdHgQEzBkJFa4KJNkvNv/j
   AXcHdigr6CC7SHY83b/KX5ZmlQmJqJnHeqLVe3CkMqBMr3x/1Fsm/TK+6
   dI5FzmCBHMtJZLe/n6g+abg1JgiuKWefaFQQMlpUga7loOxoaLWtUl0et
   EbjV2I4zU/+ngAXAXY5HU5d2aPcOLMOh9xb0f10BbrZsY/Jml++v6LCzo
   DoffmdE/QqBzDKSVt80utakdSbo/iiuVWanxXjPSefj4TlxRu3CftGci5
   FpCij1Pypfj5kxeMYuhOomXjxz9TLwqxK0yponn4/bCZFwmm7/fcE1hah
   w==;
X-CSE-ConnectionGUID: /HdMkjJeSHiUkke3DM6A5A==
X-CSE-MsgGUID: 8TbRL7uOSpimhTiuGx5kqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66499230"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="66499230"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:32 -0800
X-CSE-ConnectionGUID: Tqhd3403R+2i+80+Ssj9Uw==
X-CSE-MsgGUID: /2P9Rov7QBWIdJVIgylFfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="193960166"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:31 -0800
Date: Mon, 1 Dec 2025 22:20:31 -0800
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
Subject: [PATCH v6 7/9] x86/vmscape: Deploy BHB clearing mitigation
Message-ID: <20251201-vmscape-bhb-v6-7-d610dd515714@linux.intel.com>
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

IBPB mitigation for VMSCAPE is an overkill on CPUs that are only affected
by the BHI variant of VMSCAPE. On such CPUs, eIBRS already provides
indirect branch isolation between guest and host userspace. However, branch
history from guest may also influence the indirect branches in host
userspace.

To mitigate the BHI aspect, use clear_bhb_loop().

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 Documentation/admin-guide/hw-vuln/vmscape.rst |  4 ++++
 arch/x86/include/asm/nospec-branch.h          |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 26 +++++++++++++++++++-------
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
index d9b9a2b6c114c05a7325e5f3c9d42129339b870b..dc63a0bac03d43d1e295de0791dd6497d101f986 100644
--- a/Documentation/admin-guide/hw-vuln/vmscape.rst
+++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
@@ -86,6 +86,10 @@ The possible values in this file are:
    run a potentially malicious guest and issues an IBPB before the first
    exit to userspace after VM-exit.
 
+ * 'Mitigation: Clear BHB before exit to userspace':
+
+   As above, conditional BHB clearing mitigation is enabled.
+
  * 'Mitigation: IBPB on VMEXIT':
 
    IBPB is issued on every VM-exit. This occurs when other mitigations like
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 15a2fa8f2f48a066e102263513eff9537ac1d25f..1e8c26c37dbed4256b35101fb41c0e1eb6ef9272 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -388,6 +388,8 @@ extern void write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
+#else
+static inline void clear_bhb_loop(void) {}
 #endif
 
 extern void (*x86_return_thunk)(void);
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 71a35a153c1eb852438d533fc8ad76eefaca3219..61c3b4ae131f39fd716a54ba46d255844b1bb609 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -109,9 +109,8 @@ DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_spec_ctrl_current);
 
 /*
- * Set when the CPU has run a potentially malicious guest. An IBPB will
- * be needed to before running userspace. That IBPB will flush the branch
- * predictor content.
+ * Set when the CPU has run a potentially malicious guest. Indicates that a
+ * branch predictor flush is needed before running userspace.
  */
 DEFINE_PER_CPU(bool, x86_predictor_flush_exit_to_user);
 EXPORT_PER_CPU_SYMBOL_GPL(x86_predictor_flush_exit_to_user);
@@ -3200,13 +3199,15 @@ enum vmscape_mitigations {
 	VMSCAPE_MITIGATION_AUTO,
 	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
 	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
+	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
 };
 
 static const char * const vmscape_strings[] = {
-	[VMSCAPE_MITIGATION_NONE]		= "Vulnerable",
+	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
 	/* [VMSCAPE_MITIGATION_AUTO] */
-	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]	= "Mitigation: IBPB before exit to userspace",
-	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
+	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
+	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
 };
 
 static enum vmscape_mitigations vmscape_mitigation __ro_after_init =
@@ -3253,7 +3254,15 @@ static void __init vmscape_select_mitigation(void)
 		break;
 
 	case VMSCAPE_MITIGATION_AUTO:
-		if (boot_cpu_has(X86_FEATURE_IBPB))
+		/*
+		 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
+		 * clear sequence. These CPUs are only vulnerable to the BHI variant
+		 * of the VMSCAPE attack and does not require an IBPB flush. In
+		 * 32-bit mode BHB clear sequence is not supported.
+		 */
+		if (boot_cpu_has(X86_FEATURE_BHI_CTRL) && IS_ENABLED(CONFIG_X86_64))
+			vmscape_mitigation = VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER;
+		else if (boot_cpu_has(X86_FEATURE_IBPB))
 			vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
 		else
 			vmscape_mitigation = VMSCAPE_MITIGATION_NONE;
@@ -3280,6 +3289,8 @@ static void __init vmscape_apply_mitigation(void)
 {
 	if (vmscape_mitigation == VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER)
 		static_call_update(vmscape_predictor_flush, write_ibpb);
+	else if (vmscape_mitigation == VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER)
+		static_call_update(vmscape_predictor_flush, clear_bhb_loop);
 }
 
 #undef pr_fmt
@@ -3371,6 +3382,7 @@ void cpu_bugs_smt_update(void)
 		break;
 	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
 	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:
+	case VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER:
 		/*
 		 * Hypervisors can be attacked across-threads, warn for SMT when
 		 * STIBP is not already enabled system-wide.

-- 
2.34.1



