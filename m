Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD2C4CF414
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 09:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiCGIzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 03:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiCGIzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 03:55:04 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34581BE9F;
        Mon,  7 Mar 2022 00:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646643243; x=1678179243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EvrV1aGzmlhAstG1jIOQ8TZBHfJtCCwC9riYSVrz9Fs=;
  b=NXh/IIwoIb+3PB+HwHJGIZEwtR+4UctgYSPzXQarhEzKs1J5iGPntVZl
   mPw9Jax58cFqPPQPXnF/E9U7vFoLdDNoVx1ETHC4g78H4a5fY1TlPpxY4
   wZtns56QypE24dcKah37ucd/TUvqaLUdzslXcrLw9v4sblUBSPvOkPTnv
   7Qz4ldpZMA7cJWSSVN/LtI69TtzqZVb5iH7w7dFH4HF1R/1FjseYbY/p8
   pH99Qh6ACv4N1FOP8QT4aqjIWqCWEwgbCJyiJ8KyqLDvdkWNHpDl3kta5
   m1oFgeC3Lk4VrozZCf+MEW9a09iVgjsFUy7n/jDfepdqiUye5c7e1NmOP
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10278"; a="279042729"
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="279042729"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 00:53:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,161,1643702400"; 
   d="scan'208";a="537033649"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.92])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2022 00:53:55 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, H Peter Anvin <hpa@zytor.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Leo Yan <leo.yan@linaro.org>
Subject: [PATCH V3 10/10] perf intel-pt: Add documentation for new clock IDs
Date:   Mon,  7 Mar 2022 10:53:12 +0200
Message-Id: <20220307085312.1814506-11-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220307085312.1814506-1-adrian.hunter@intel.com>
References: <20220307085312.1814506-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add brief documentation for new clock IDs CLOCK_PERF_HW_CLOCK and
CLOCK_PERF_HW_CLOCK_NS, as well as new config variables
intel-pt.max_nonturbo_ratio and intel-pt.tsc_art_ratio.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/Documentation/perf-intel-pt.txt | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index ff58bd4c381b..383126d05577 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -509,6 +509,29 @@ notnt		Disable TNT packets.  Without TNT packets, it is not possible to walk
 		"0" otherwise.
 
 
+perf event clock
+~~~~~~~~~~~~~~~~
+
+Newer kernel and tools support 2 special clocks: CLOCK_PERF_HW_CLOCK which is
+TSC and CLOCK_PERF_HW_CLOCK_NS which is TSC converted to nanoseconds.
+CLOCK_PERF_HW_CLOCK_NS is the same as the default perf event clock, but it is
+not subject to paravirtualization, so it still works with Intel PT in a VM
+guest.  Note however, TSC may not be being fully virtualized, so the results
+may be unexpected.
+
+	--clockid CLOCK_PERF_HW_CLOCK_NS
+
+To use TSC instead of nanoseconds, use the option:
+
+	--clockid CLOCK_PERF_HW_CLOCK
+
+Beware forgetting that the time stamp of events will show TSC ticks
+(divided by 1,000,000,000) not seconds.
+
+Other clocks are not supported for use with Intel PT because they cannot be
+converted to/from TSC.
+
+
 AUX area sampling option
 ~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -1398,6 +1421,28 @@ There were none.
           :17006 17006 [001] 11500.262869216:  ffffffff8220116e error_entry+0xe ([guest.kernel.kallsyms])               pushq  %rax
 
 
+Tracing within a Virtual Machine
+--------------------------------
+
+When supported, using Intel PT within a virtual machine does not support TSC
+because the perf event clock is subject to paravirtualization.  That is
+overcome by the new CLOCK_PERF_HW_CLOCK_NS clock - refer 'perf event clock'
+above.  In addition, in a VM, the following might be zero:
+
+	/sys/bus/event_source/devices/intel_pt/max_nonturbo_ratio
+	/sys/bus/event_source/devices/intel_pt/tsc_art_ratio
+
+The decoder needs this information to correctly interpret timing packets,
+so the values can be provided by config variables in that case. Note in
+the absence of VMCS TSC Scaling, this is probably the same as the host values.
+The config variables are:
+
+	intel-pt.max_nonturbo_ratio
+	intel-pt.tsc_art_ratio
+
+For more information about perf config variables, refer linkperf:perf-config[1]
+
+
 Event Trace
 -----------
 
-- 
2.25.1

