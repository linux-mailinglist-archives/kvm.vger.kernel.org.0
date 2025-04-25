Return-Path: <kvm+bounces-44332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DDC1A9CD7C
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 17:46:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AEEC4C85B0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 15:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7248429009A;
	Fri, 25 Apr 2025 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dRNB0hzB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2CE13633F;
	Fri, 25 Apr 2025 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745595937; cv=none; b=G7x8Ax74kaDgySNTz5Jlsoih9DAeesVDV66WKndj0XUSO+RllSNntMUVYDSLa5i68Tbb4T8uuyDJoHabqy8efQq5m4AeMzLe+mc3Dl+hLeb15HsD4Um3tI0O5/FlygD8jPpITqN8RsR+EUCtw3dVl0Oh16WLh9W21VH+Elda+Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745595937; c=relaxed/simple;
	bh=NDEMzXyKMQaX/1P4v8LWPCUwLdyUYFm0Z5j9i1NuUNc=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oURIrzB+ARE3FVQLxz8dnOYU14uCYJjSvVX3nqn4tRxl4sqIg0d9GcdrQHWP+8ijFC1LA/zQonMzi39gEDovU/vlRJprrAMSpCqMIjZbdqwKMDMh4/q7CcalYhhgFQ/04fC+JnOFHmm7ZJ6T/QR933JkOJ7LdY0XGkJrf978+fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dRNB0hzB; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745595936; x=1777131936;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=NDEMzXyKMQaX/1P4v8LWPCUwLdyUYFm0Z5j9i1NuUNc=;
  b=dRNB0hzB9VSEVZTN6uSQdKcHqikDg35+hrmD9RswM0sJg7VLq7vXflvN
   L1reVIaspl2ar5jsCDPfpN7akAbFhLGghWw+pCn19pxVTEbDg12AsoN6N
   O6iyX/zUQKQvZtktFX2jk7eJYafaN86bT+ROFbbafcHQha1t0OhXLKs5p
   W4k/Hcovc41OunM9OT7Hr9Q1XDHwhBS6NIRM9c6ZZzzY4mdcLEvIudGeo
   UYRwmAL+8O3spijxoiIPhcZNqx2AO5dl0pJegz89Q+YcbAn4diomQZ1Jc
   hAlzIA8q1wKOcSE2RV7O6gnp0NSBmt5HQG7wN/HZr61mIeUmmbAlXpmwn
   w==;
X-CSE-ConnectionGUID: 7bCgJpPqRiefXyfn2jXtMQ==
X-CSE-MsgGUID: bMKMOgZ8RAGO3vxuOpGwsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11414"; a="50928849"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="50928849"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 08:45:35 -0700
X-CSE-ConnectionGUID: zVyTiGS+Tp27oRIuRu3o/Q==
X-CSE-MsgGUID: FTR+bshYRAKz5gvHmp9NIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="133870388"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.154])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 08:45:22 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Fri, 25 Apr 2025 18:45:18 +0300 (EEST)
To: "Xin Li (Intel)" <xin@zytor.com>
cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
    linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
    virtualization@lists.linux.dev, linux-pm@vger.kernel.org, 
    linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org, 
    linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
    Netdev <netdev@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com, 
    peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com, 
    alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
    adrian.hunter@intel.com, kan.liang@linux.intel.com, wei.liu@kernel.org, 
    ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com, 
    tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com, 
    seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com, 
    kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com, 
    dapeng1.mi@linux.intel.com
Subject: Re: [PATCH v3 01/14] x86/msr: Move rdtsc{,_ordered}() to
 <asm/tsc.h>
In-Reply-To: <20250425083442.2390017-2-xin@zytor.com>
Message-ID: <42dc90e1-df2a-2324-d28c-d75fb525e4a2@linux.intel.com>
References: <20250425083442.2390017-1-xin@zytor.com> <20250425083442.2390017-2-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 25 Apr 2025, Xin Li (Intel) wrote:

> For some reason, there are some TSC-related functions in the MSR
> header even though there is a tsc.h header.
> 
> Relocate rdtsc{,_ordered}() from <asm/msr.h> to <asm/tsc.h>, and
> subsequently remove the inclusion of <asm/msr.h> in <asm/tsc.h>.
> Consequently, <asm/msr.h> must be included in several source files
> that previously did not require it.
>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
> Change in v3:
> * Add a problem statement to the changelog (Dave Hansen).
> ---

>  drivers/platform/x86/intel/pmc/cnp.c          |  1 +
>  .../intel/speed_select_if/isst_if_common.c    |  1 +
>  drivers/platform/x86/intel/turbo_max_3.c      |  1 +

Hi,

To me this looks really a random set of source files, maybe it helped some 
build success but it's hard for me to review this because there are still 
cases that depend on indirect include chains.

Could you just look into solving all missing msr.h includes instead 
as clearly some are still missing after 3 pre-existing ones and you adding 
it into 3 files:

$ git grep -e rdmsr -e wrmsr -l drivers/platform/x86/
drivers/platform/x86/intel/ifs/core.c
drivers/platform/x86/intel/ifs/load.c
drivers/platform/x86/intel/ifs/runtest.c
drivers/platform/x86/intel/pmc/cnp.c
drivers/platform/x86/intel/pmc/core.c
drivers/platform/x86/intel/speed_select_if/isst_if_common.c
drivers/platform/x86/intel/speed_select_if/isst_if_mbox_msr.c
drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
drivers/platform/x86/intel/tpmi_power_domains.c
drivers/platform/x86/intel/turbo_max_3.c
drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
drivers/platform/x86/intel_ips.c

$ git grep -e 'msr.h' -l drivers/platform/x86/
drivers/platform/x86/intel/pmc/core.c
drivers/platform/x86/intel/tpmi_power_domains.c
drivers/platform/x86/intel_ips.c

I'd also prefer the patch(es) adding missing includes be in a different 
patch.

-- 
 i.


