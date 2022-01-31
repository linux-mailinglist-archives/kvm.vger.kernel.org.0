Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE394A3E27
	for <lists+kvm@lfdr.de>; Mon, 31 Jan 2022 08:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348127AbiAaHZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jan 2022 02:25:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:60936 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbiAaHY7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jan 2022 02:24:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643613899; x=1675149899;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZWRVqMAOjb7kr/DvWnCXkqd3XvMMrAJqqITX2EmYdt4=;
  b=E4YJq/nBWiBxegS4vbN2hijJRFWo9RfEnR+QahWl4TqHDiRAmsxKEUPK
   IO+CxfjIhT+FY86Bq/hvlAoQVFZkpcsxeeRiLTU6OKooGqGwOmMCd10KX
   wXBwtSk7Ynr9OzgKQLhsiTT9EO9xwlJV+ISprtwo8NWPVfoFTR1pwlKlj
   IVVpPIkKIpuPWW53n9UX6aelyDpgz20cGKS6iinFNrlUT/cCQSwS6gliD
   fpATji8wct60DAWtnUqHhzaD9UsB3EuxvD1hHiRxvTaATZpOPLVgdZQFb
   Ex+R2U1NNDjO5Dc8OWq8Po7EIy/i1dTTsKZ1nhWtNGfGtP+UQ1z6CbC1i
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="247367019"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="247367019"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2022 23:24:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="768515147"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jan 2022 23:24:54 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH 0/5] perf/core: Address filter fixes / changes
Date:   Mon, 31 Jan 2022 09:24:48 +0200
Message-Id: <20220131072453.2839535-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi

Here are some Address Filter fixes and changes, primarily for Intel PT, but
Coresight could be affected also by "perf/core: Allow kernel address filter
when not filtering the kernel".

A resulting tidy-up ("x86: Share definition of __is_canonical_address()")
touches a few otherwise unrelated files in mm and kvm, but there are no
functional changes there.


Adrian Hunter (5):
      perf/x86/intel/pt: Relax address filter validation
      x86: Share definition of __is_canonical_address()
      perf/core: Fix address filter parser for multiple filters
      perf/x86/intel/pt: Fix address filter config for 32-bit kernel
      perf/core: Allow kernel address filter when not filtering the kernel

 arch/x86/events/intel/pt.c  | 55 +++++++++++++++++++++++++++++++++------------
 arch/x86/include/asm/page.h | 10 +++++++++
 arch/x86/kvm/emulate.c      |  4 ++--
 arch/x86/kvm/x86.c          |  2 +-
 arch/x86/kvm/x86.h          |  7 +-----
 arch/x86/mm/maccess.c       |  7 +-----
 kernel/events/core.c        |  5 +++--
 7 files changed, 59 insertions(+), 31 deletions(-)


Regards
Adrian
