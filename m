Return-Path: <kvm+bounces-72102-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YK5XCEfUoGmrnAQAu9opvQ
	(envelope-from <kvm+bounces-72102-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:16:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B49E41B0D50
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 00:16:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FA1E30DB7D4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3002C47A0AC;
	Thu, 26 Feb 2026 23:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gwt3xwHs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8E746AEF4;
	Thu, 26 Feb 2026 23:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772147680; cv=none; b=A5l8iFh30jOisHzHsBVksN1jS8FU7masPr+3CmB8JQO+m1EkLpj1XlDJIkGp0pHuM3KjhDJoB/JujjtQ/S62Gny1p0CmUaXaMq5gqhxWmEmL5iHb/T5QVDY8+CMIIhkmCf55uRoDioeBvIvDxi4fkO+ixQxUg6LRTGSm+ZOECzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772147680; c=relaxed/simple;
	bh=MiRghoPV1Dq12qbFZz8h7AIuw2yz4TxuXi3Y0woQ8vA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LWZeckalV4CGYSdKbjwqDHl1Z5rsjraeoilvQW+2ywVEC91/T6I7bcdChwNXA/flWtBpx87+FCF5OrJEGJzNI6MdsYk5JPr70A6DONAAi/FrV1FS0Xi052kVQDCblr2EVlgCsx3r02MAUTBUNlzp9z723OQK10vyQdFDYRwFueo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gwt3xwHs; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772147679; x=1803683679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MiRghoPV1Dq12qbFZz8h7AIuw2yz4TxuXi3Y0woQ8vA=;
  b=gwt3xwHszvSbI84fPPT2mrTvqHM4BmScT8vPM1RxRYwA4l/BONl1FDF8
   j7cFV+JOGRY78OW4E0j+Q4Hkw4JBcywgvqlnolfGLEaRhIazuAORJgi6R
   mWMmUE+niyBLOCqPyQ4UZjqmpKBtR1R7K325326jpmXUdJXWUBu6GpUbF
   N/cuok38VjPxMuqVHvOhKRYuDnEIKvanoKePFeAb9Yqrphbcel9XYR0Zj
   TOmZ4qqeeoj9I+z78jTIRaYE1BFuAKs5D3XYN7xCfsfyC83z8Foh49OQM
   nQ9jXl18vxr3dhaD1acyZf/ob5uWGLp55ARj9qDu6eNdRqigHJY3ie9tm
   Q==;
X-CSE-ConnectionGUID: NyfbOqpyT7GWmLJOJmVEOg==
X-CSE-MsgGUID: 3dS/+bZXTKaNlWujtnEwkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="72928305"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="72928305"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:14:38 -0800
X-CSE-ConnectionGUID: 1xeiGgwRQ3mzI8WjlLyB5Q==
X-CSE-MsgGUID: hIsC1d2oSuqrVu7Ba4ajbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="221340133"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:14:38 -0800
From: Zide Chen <zide.chen@intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Falcon Thomas <thomas.falcon@intel.com>,
	Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH 0/3] KVM: x86/pmu: Add hardware Topdown metrics support
Date: Thu, 26 Feb 2026 15:06:03 -0800
Message-ID: <20260226230606.146532-1-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72102-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B49E41B0D50
X-Rspamd-Action: no action

The Top-Down Microarchitecture Analysis (TMA) method is a structured
approach for identifying performance bottlenecks in out-of-order
processors.

Currently, guests support the TMA method by collecting Topdown events
using GP counters, which may trigger multiplexing.  To free up scarce
GP counters, eliminate multiplexing-induced skew, and obtain coherent
Topdown metric ratios, it is desirable to expose fixed counter 3 and
the IA32_PERF_METRICS MSR to guests.

Several failed attempts have been made to virtualize this under the
legacy vPMU model: [1], [2], [3].  With the new mediated vPMU, enabling
TMA support in guests becomes much simpler.  It avoids invasive changes
to the perf core, eliminates CPU pinning and fixed-counter affinity
issues, and reduces the overhead of trapping and emulating MSR accesses.

[1] https://lore.kernel.org/kvm/20231031090613.2872700-1-dapeng1.mi@linux.intel.com/
[2] https://lore.kernel.org/all/20230927033124.1226509-1-dapeng1.mi@linux.intel.com/T/
[3] https://lwn.net/ml/linux-kernel/20221212125844.41157-1-likexu@tencent.com/

Tested on an SPR.  Without this series, only raw topdown.*_slots events
work in the guest, and metric events (e.g. cpu/topdown-bad-spec/) are
not available.

With this series, metric events are visible in the guest.  Run this
command on both host and guest:

$ perf stat --topdown --no-metric-only -- taskset -c 2 perf bench sched messaging

Host results:

# Running 'sched/messaging' benchmark:
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 1.500 [sec]

 Performance counter stats for 'taskset -c 2 perf bench sched messaging':

     4,266,060,558      TOPDOWN.SLOTS:u              #     32.0 %  tma_frontend_bound
                                                     #      5.2 %  tma_bad_speculation
       588,397,905      topdown-retiring:u           #     13.8 %  tma_retiring
                                                     #     49.0 %  tma_backend_bound
     1,376,283,990      topdown-fe-bound:u
     2,096,827,304      topdown-be-bound:u
       217,425,841      topdown-bad-spec:u
         5,050,520      INT_MISC.UOP_DROPPING:u

       1.755503765 seconds time elapsed

       0.235965000 seconds user
       1.500508000 seconds sys

Guest results:

# Running 'sched/messaging' benchmark:
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 1.558 [sec]

 Performance counter stats for 'taskset -c 2 perf bench sched messaging':

     5,148,818,712      TOPDOWN.SLOTS:u              #     34.0 %  tma_frontend_bound
                                                     #      4.6 %  tma_bad_speculation
       602,862,499      topdown-retiring:u           #     11.7 %  tma_retiring
                                                     #     49.7 %  tma_backend_bound
     1,759,698,259      topdown-fe-bound:u
     2,565,571,672      topdown-be-bound:u
       230,277,308      topdown-bad-spec:u
         4,966,279      INT_MISC.UOP_DROPPING:u

       1.783366587 seconds time elapsed

       0.313692000 seconds user
       1.446377000 seconds sys

Dapeng Mi (2):
  KVM: x86/pmu: Support Intel fixed counter 3 on mediated vPMU
  KVM: x86/pmu: Support PERF_METRICS MSR in mediated vPMU

Zide Chen (1):
  KVM: x86/pmu: Do not map fixed counters >= 3 to generic perf events

 arch/x86/include/asm/kvm_host.h   |  3 +-
 arch/x86/include/asm/msr-index.h  |  1 +
 arch/x86/include/asm/perf_event.h |  1 +
 arch/x86/kvm/pmu.c                |  4 +++
 arch/x86/kvm/vmx/pmu_intel.c      | 57 ++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/pmu_intel.h      |  5 +++
 arch/x86/kvm/vmx/vmx.c            |  6 ++++
 arch/x86/kvm/x86.c                | 10 ++++--
 8 files changed, 71 insertions(+), 16 deletions(-)

-- 
2.53.0


