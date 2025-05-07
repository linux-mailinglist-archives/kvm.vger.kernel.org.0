Return-Path: <kvm+bounces-45679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91450AAD2AB
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 462FD1C04743
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 877D918FC92;
	Wed,  7 May 2025 01:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aSVdkAPa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0EF142E7C;
	Wed,  7 May 2025 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580887; cv=none; b=YHQvRkeMwE4glQSnGujBJAiLdXPcnkFJKzQBH8USlhtPMVG+aiDPaHFy4iMpvhtNXx59WAgV/x+oCdou1LrvxN5Gb09t443wyrKpGE2pZOx4tVeHYUqrkUzXf+X4XZl10WeMfu3tydWbbpIS2i4EVEdzYnbC538VE4QHWY/i3Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580887; c=relaxed/simple;
	bh=ClkJrmbDwZGcM0dRrc8j/v6UEpk3k84qecCHW3uUxyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgUJXHMHI4DWKwrQXRQtkxExmxFG/ma563QS2sKCjKE8+RQ5D3ZlrIuGrJBecPcFCw4l4bCZ06w0wScWLY4mnZpXn7NqMCh2jbdIJFVxaPlA7I4QQSAEz/msdnpJ7VwKzp1/EjRyAXeNEa4Mouaf69YtW4A7alZDNwvE3qahdkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aSVdkAPa; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580886; x=1778116886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ClkJrmbDwZGcM0dRrc8j/v6UEpk3k84qecCHW3uUxyI=;
  b=aSVdkAPaikzQKL2x2N39ZvRa+n4Cm4u67k/ihSU4pjKcN3xGpGP6qoBW
   FcgnnBSjAteDO/JfRgym0mDspbuAPZHiN6ukrfSsc8RJeQphvb/qzMCss
   +tPjruJUTl+0abjqhma+BdViFozmYyEjvGRAFbyvTHWrVm3T81dpqvTP6
   pwGA9yNsJiBcx9x5PDzl7UhPHf+DJC3nuo7bjL92eRA2OPJTPryIQ9lYT
   9aetKjdzrT17S42Ae9mkBXEgeU0+FJWqp/AQsDY/iJU09Z6chzBwTpUrz
   nSfh8wIoRMGgBlQeRfLlIgPZQ3bs+5PCxyrRXAAi+xsn6sQGFuayTKRAl
   g==;
X-CSE-ConnectionGUID: V7PyAGOdTjeh0LygyeLzzA==
X-CSE-MsgGUID: phRmXDD7R/OwrlhH+GKZ3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47383917"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47383917"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:23 -0700
X-CSE-ConnectionGUID: fK6dZsLgTI2alcg/wAqgmg==
X-CSE-MsgGUID: q+qHKgAaRl+OXjONwj/uHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808742"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:22 -0700
From: Sohil Mehta <sohil.mehta@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sohil Mehta <sohil.mehta@intel.com>,
	Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-edac@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v5 2/9] x86/cpufeatures: Add the CPUID feature bit for NMI-source reporting
Date: Tue,  6 May 2025 18:21:38 -0700
Message-ID: <20250507012145.2998143-3-sohil.mehta@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250507012145.2998143-1-sohil.mehta@intel.com>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NMI-source reporting is introduced to report the sources of NMIs with
FRED event delivery based on vectors in NMI interrupt messages or the
local APIC. This enables the kernel to avoid the latency incurred by
going over the entire NMI handler list and reduces ambiguity about the
source of an NMI.

Enumerate NMI-source reporting in cpufeatures. Also, since NMI-source
reporting uses the FRED event dispatch framework, make it dependent on
FRED in the CPUID dependency table. This ensures that NMI-source
reporting gets disabled when FRED is disabled.

NMI-source reporting is intended as a kernel feature and does not need
userspace enumeration or configuration. There is no need to expose it to
userspace through /proc/cpuinfo.

Originally-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v5: Add NMI-source to the CPUID dependency table.
    Do not expose NMI-source feature through /proc/cpuinfo.
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6c2c152d8a67..2ced1bc64548 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -321,6 +321,7 @@
 #define X86_FEATURE_FRED		(12*32+17) /* "fred" Flexible Return and Event Delivery */
 #define X86_FEATURE_LKGS		(12*32+18) /* Load "kernel" (userspace) GS */
 #define X86_FEATURE_WRMSRNS		(12*32+19) /* Non-serializing WRMSR */
+#define X86_FEATURE_NMI_SOURCE		(12*32+20) /* NMI-Source reporting with FRED */
 #define X86_FEATURE_AMX_FP16		(12*32+21) /* AMX fp16 Support */
 #define X86_FEATURE_AVX_IFMA            (12*32+23) /* Support for VPMADD52[H,L]UQ */
 #define X86_FEATURE_LAM			(12*32+26) /* "lam" Linear Address Masking */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index a2fbea0be535..ed0fd35c9290 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -84,6 +84,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AMX_TILE,			X86_FEATURE_XFD       },
 	{ X86_FEATURE_SHSTK,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_FRED,			X86_FEATURE_LKGS      },
+	{ X86_FEATURE_NMI_SOURCE,		X86_FEATURE_FRED      },
 	{}
 };
 
-- 
2.43.0


