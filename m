Return-Path: <kvm+bounces-65081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACAFC9A3AB
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 958B73443D7
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B532FFFA9;
	Tue,  2 Dec 2025 06:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HhXwGEn0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BC92FFDF4;
	Tue,  2 Dec 2025 06:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656484; cv=none; b=LRWj+TtBenqu+Wp50rfS9DjHKRUNs/gzHOVezRzm3w7w91hCr9VN2RCdG9m1RgKv6g96sqsqClymDsA6ZoFvFB7dY2w6OCGuYtFRjXtnOjr7NsQJTH3306Cjmkcy3sP25N2fPGFJJ+GIGir7JHP9yeI2mfJi8UWQqRyVsIezLr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656484; c=relaxed/simple;
	bh=PrK+AMN/Tnlv4FHU76kjXMTZzreOCQkhyKRZczt3/0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=poE+cjmCceqlOsc/FN/QiOhJu5J5jM3SHPtcbNLE4W0BMiZ0hkxNcAPok8trAHDx9g2LEbNfcYlPG+BOiv/DNhzWp7Hc8QeV95l6GZ+EA+Cef1rTI6XOfk3HSBV2K+OgDnYCN9lvEbVn0Ypa0A75hvrNQrWMcwQ9gTLHVQJlLJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HhXwGEn0; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656483; x=1796192483;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PrK+AMN/Tnlv4FHU76kjXMTZzreOCQkhyKRZczt3/0w=;
  b=HhXwGEn07Z2xHqUFu0qjpaD5sYW7xzt5yG5m00eBjeMnZh9RjguHNcMX
   YsHUcuT2Pac/69vxuTwRMkmwsEgmG1E+dqa3s36ECqFY+95jVj10tNb4l
   6Y1zQnWe1yX5nT/h4qJMEfrkWSen332eeYh/Sd2xWqP8XZQAYhMO2ZjYE
   PTj6YZHnBbNamOH2bsd92yMgxG2jw56HpSLNlaN+nelQfsFLGKl5oy6tz
   +o0QfYz/wt9cfMhPTTuz9aRF8tUAyn8iuKdh+cyeQz7j++tonrOphhWQi
   gq0JHcA6vkuEUvfBTjtnHE58iVztOawscmBSKqy/vdjzyAFZPdY6wQ7j9
   g==;
X-CSE-ConnectionGUID: j3DStMtTQ3quCJO4YplsrA==
X-CSE-MsgGUID: YnIZxM++RNOeXtzkmdfy3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="65801241"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="65801241"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:21:21 -0800
X-CSE-ConnectionGUID: bahEhZniTSuwstCvo4+PBQ==
X-CSE-MsgGUID: 3MY/cSb8SW+32E5Fhplvkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="217625072"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:21:02 -0800
Date: Mon, 1 Dec 2025 22:21:02 -0800
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
Subject: [PATCH v6 9/9] x86/vmscape: Add cmdline vmscape=on to override
 attack vector controls
Message-ID: <20251201-vmscape-bhb-v6-9-d610dd515714@linux.intel.com>
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

In general, individual mitigation controls can be used to override the
attack vector controls. But, nothing exists to select BHB clearing
mitigation for VMSCAPE. The =force option comes close, but with a
side-effect of also forcibly setting the bug, hence deploying the
mitigation on unaffected parts too.

Add a new cmdline option vmscape=on to enable the mitigation based on the
VMSCAPE variant the CPU is affected by.

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 Documentation/admin-guide/hw-vuln/vmscape.rst   | 4 ++++
 Documentation/admin-guide/kernel-parameters.txt | 4 +++-
 arch/x86/kernel/cpu/bugs.c                      | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/hw-vuln/vmscape.rst b/Documentation/admin-guide/hw-vuln/vmscape.rst
index dc63a0bac03d43d1e295de0791dd6497d101f986..580f288ae8bfc601ff000d6d95d711bb9084459e 100644
--- a/Documentation/admin-guide/hw-vuln/vmscape.rst
+++ b/Documentation/admin-guide/hw-vuln/vmscape.rst
@@ -112,3 +112,7 @@ The mitigation can be controlled via the ``vmscape=`` command line parameter:
 
    Force vulnerability detection and mitigation even on processors that are
    not known to be affected.
+
+ * ``vmscape=on``:
+
+   Choose the mitigation based on the VMSCAPE variant the CPU is affected by.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e581b5192b66c6f25aba38d4f8ff8..d2ccec6e10f3ea094c01083d4c133b837c7fc7d7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -8104,9 +8104,11 @@
 
 			off		- disable the mitigation
 			ibpb		- use Indirect Branch Prediction Barrier
-					  (IBPB) mitigation (default)
+					  (IBPB) mitigation
 			force		- force vulnerability detection even on
 					  unaffected processors
+			on		- (default) selects IBPB or BHB clear
+					  mitigation based on CPU
 
 	vsyscall=	[X86-64,EARLY]
 			Controls the behavior of vsyscalls (i.e. calls to
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 58cd26e4f4c385a10230912666c02dbb05e71cba..5870bb67baf3bb54be80a7c193c26b6f6eb246d5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -3227,6 +3227,8 @@ static int __init vmscape_parse_cmdline(char *str)
 	} else if (!strcmp(str, "force")) {
 		setup_force_cpu_bug(X86_BUG_VMSCAPE);
 		vmscape_mitigation = VMSCAPE_MITIGATION_ON;
+	} else if (!strcmp(str, "on")) {
+		vmscape_mitigation = VMSCAPE_MITIGATION_ON;
 	} else {
 		pr_err("Ignoring unknown vmscape=%s option.\n", str);
 	}

-- 
2.34.1



