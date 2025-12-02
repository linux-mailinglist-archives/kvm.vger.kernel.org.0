Return-Path: <kvm+bounces-65080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5CDC9A3A8
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:21:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C9E483428E7
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5443019A1;
	Tue,  2 Dec 2025 06:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iO9K3ufS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F392FF170;
	Tue,  2 Dec 2025 06:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656450; cv=none; b=UJcYs2zAnLl+tfv46su4LpxrqNTblhRpmpvQcTz2lGmGXTh08UHlmfkwVeP/eDXj0G1LDYY8exc6IdGd9eGgL1yt6NdJm0V4VWMrbNE/ySis8i1/Hz01hcl6I+pFNID/qohIuyoZElGnH/X80nsEpK+U1oHlySVnQ20BE1KplQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656450; c=relaxed/simple;
	bh=idDh8M13yray+EnvDUA87xzOocdhcSouom6DpZ4kJZk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JX4EdftvOx35natp1d1O6/obnpWloIVAI2exdoKxRJ/QK7u1ObLJ60NBLvBoqFjRdmUEAg44e5O2+9tszWSWz4lS1NyorSwQNwWN0bmWMG9wpQifL/X67aCuLfTY+uuubJYzhE5yKY68GkekmDtM4q6re+g4moh5tPraLH1Kdgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iO9K3ufS; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656449; x=1796192449;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=idDh8M13yray+EnvDUA87xzOocdhcSouom6DpZ4kJZk=;
  b=iO9K3ufS9QrH3MxfHhTJJn7VXlOUwCdBLlpEutO9xUYTQCb5amX7qJrx
   IcbcClHNcjyUF6l7lFZuVzHyGP8I9f2qm68zGX3QmJxTcnmYOCFnf1BV4
   xq6UamFkr2gpbCzBI+x701a3Av8y4SVbC59LYyu5C3r1uznAkLxrdH/O/
   fSDUc4FjxxqhdgVT4iPRQOEA1YJDNbW3iNS2pFLkF/hONe2JUjAbj1qfq
   HIMe34d/CSwhQFruskpGehVh2s4e7fSBnWFfnFG578bFUIxdIsevTIi6O
   hZbYoJbp05kUBlZD15D7AazRCnqZZnPuO25IWjftynuEys+JHBWim9ijS
   g==;
X-CSE-ConnectionGUID: jskggzXQRBSXTbF4iC0udA==
X-CSE-MsgGUID: On9gnAuaQfOBFUppCvVXRQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="65801211"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="65801211"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:47 -0800
X-CSE-ConnectionGUID: SabKAysGTbq9gspSoQ/pBw==
X-CSE-MsgGUID: BedyVFdOToOvxRxt9pw8vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="217624884"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:20:47 -0800
Date: Mon, 1 Dec 2025 22:20:46 -0800
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
Subject: [PATCH v6 8/9] x86/vmscape: Fix conflicting attack-vector controls
 with =force
Message-ID: <20251201-vmscape-bhb-v6-8-d610dd515714@linux.intel.com>
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

vmscape=force option currently defaults to AUTO mitigation. This is not
correct because attack-vector controls overrides a mitigation in AUTO mode.
This prevents a user from being able to force VMSCAPE mitigation when it
conflicts with attack-vector controls.

Kernel should deploy a forced mitigation irrespective of attack vectors.
Instead of AUTO, use VMSCAPE_MITIGATION_ON that wins over attack-vector
controls.

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kernel/cpu/bugs.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 61c3b4ae131f39fd716a54ba46d255844b1bb609..58cd26e4f4c385a10230912666c02dbb05e71cba 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3197,6 +3197,7 @@ static void __init srso_apply_mitigation(void)
 enum vmscape_mitigations {
 	VMSCAPE_MITIGATION_NONE,
 	VMSCAPE_MITIGATION_AUTO,
+	VMSCAPE_MITIGATION_ON,
 	VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER,
 	VMSCAPE_MITIGATION_IBPB_ON_VMEXIT,
 	VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER,
@@ -3205,6 +3206,7 @@ enum vmscape_mitigations {
 static const char * const vmscape_strings[] = {
 	[VMSCAPE_MITIGATION_NONE]			= "Vulnerable",
 	/* [VMSCAPE_MITIGATION_AUTO] */
+	/* [VMSCAPE_MITIGATION_ON] */
 	[VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER]		= "Mitigation: IBPB before exit to userspace",
 	[VMSCAPE_MITIGATION_IBPB_ON_VMEXIT]		= "Mitigation: IBPB on VMEXIT",
 	[VMSCAPE_MITIGATION_BHB_CLEAR_EXIT_TO_USER]	= "Mitigation: Clear BHB before exit to userspace",
@@ -3224,7 +3226,7 @@ static int __init vmscape_parse_cmdline(char *str)
 		vmscape_mitigation = VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER;
 	} else if (!strcmp(str, "force")) {
 		setup_force_cpu_bug(X86_BUG_VMSCAPE);
-		vmscape_mitigation = VMSCAPE_MITIGATION_AUTO;
+		vmscape_mitigation = VMSCAPE_MITIGATION_ON;
 	} else {
 		pr_err("Ignoring unknown vmscape=%s option.\n", str);
 	}
@@ -3254,6 +3256,7 @@ static void __init vmscape_select_mitigation(void)
 		break;
 
 	case VMSCAPE_MITIGATION_AUTO:
+	case VMSCAPE_MITIGATION_ON:
 		/*
 		 * CPUs with BHI_CTRL(ADL and newer) can avoid the IBPB and use BHB
 		 * clear sequence. These CPUs are only vulnerable to the BHI variant
@@ -3379,6 +3382,7 @@ void cpu_bugs_smt_update(void)
 	switch (vmscape_mitigation) {
 	case VMSCAPE_MITIGATION_NONE:
 	case VMSCAPE_MITIGATION_AUTO:
+	case VMSCAPE_MITIGATION_ON:
 		break;
 	case VMSCAPE_MITIGATION_IBPB_ON_VMEXIT:
 	case VMSCAPE_MITIGATION_IBPB_EXIT_TO_USER:

-- 
2.34.1



