Return-Path: <kvm+bounces-45686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE50AAD2C3
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:24:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98EE0986016
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16D531E1E1D;
	Wed,  7 May 2025 01:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T35X9xUB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731101BCA07;
	Wed,  7 May 2025 01:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580895; cv=none; b=SRiG9J/5v0YIpdqsootpIIUaMKfIZN/XFdj6p/JC+Fufs53WQwzYJTX45I6RSFpg9osfMjQYWrq7WNlSHIzC30qqrV189b+YZ3Rxh9v6qlS8vLK5xniw8mVahm/lVMMDAKlY8ecp+a8kmqwaHKpHWzl6IYjrkAhOdxXVeP3lpHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580895; c=relaxed/simple;
	bh=edU4z1uYW4G0oPnEqlkumseThNzJ3IpnbOl27q6GHKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hN3Yo59AbcOD5yhjRupt+XvIPx+sTJ12Lui7LKYPmn7CFf9k6g9tZa5j0AI22x2FOE7FmQwc5Y91Kb6yKLGj9yjHVZ1mPqogixzI49jB8E1TEPpfTvzW8xd4rpC7QGWGsUbzOqJVV7Kk822QlS5XU9y5WncNMuE3r2KLR1IE3j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T35X9xUB; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746580890; x=1778116890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=edU4z1uYW4G0oPnEqlkumseThNzJ3IpnbOl27q6GHKs=;
  b=T35X9xUBuDImWiN2OtOjbiLiPvWJ6LYeFyBBB0TuN7wZn1rmpowUpqxb
   s4ODwAXi+3I95zxJjugum5Yz0xQm1g5kgT/tU3Q7LAEjGm+gbHJ9iYyPV
   9J975fD7jjo9ClbFnwWYEbnBJqAH8ybsAJE4eX3nmZmqVgDHQXHRE5da7
   nyG+iPYxu0arLcag4svA0mDgXCpsiQCirnkGMLzzdAlkqX2PJ7wJIcjtF
   A7hj2Bh9Rd3GsTuE3ZftWTvua3n/yRuCd3b0q1ZIoT7rMeCG6VxVBIfgQ
   3WegPcVeaqByM9TbEWaqNlDR83Q5e576flPZQunLrG5kmW6duHVvOuknp
   w==;
X-CSE-ConnectionGUID: M6mWRWmpTReVCIqegAVVmw==
X-CSE-MsgGUID: gfNRS2GWRwGRCIZ8msuDkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="47384041"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="47384041"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 18:21:28 -0700
X-CSE-ConnectionGUID: WFLsTaPVS/SK+jJfVEQ7jQ==
X-CSE-MsgGUID: k2h7TXjyR7SIN+Jy8mIiKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="136808763"
Received: from sohilmeh.sc.intel.com ([172.25.103.65])
  by fmviesa009.fm.intel.com with ESMTP; 06 May 2025 18:21:28 -0700
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
Subject: [PATCH v5 9/9] x86/nmi: Include NMI-source information in tracepoint and debug prints
Date: Tue,  6 May 2025 18:21:45 -0700
Message-ID: <20250507012145.2998143-10-sohil.mehta@intel.com>
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

The NMI-source bitmap is the most critical information provided by the
NMI-source reporting feature. It can help identify issues when multiple
NMIs occur simultaneously or if certain NMI handlers consistently
misbehave. It is also very useful in debugging unknown NMIs since it can
pinpoint the exact source that caused the NMI.

Add the source bitmap to the nmi_handler() tracepoint. Also, print the
bitmap along with the "Unknown NMI" kernel log message.

Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
---
v5: New patch
---
 arch/x86/kernel/nmi.c      |  5 ++++-
 include/trace/events/nmi.h | 13 ++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index 183e3e717326..b9ece0b63ca7 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -202,7 +202,7 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
 		thishandled = a->handler(type, regs);
 		handled += thishandled;
 		delta = sched_clock() - delta;
-		trace_nmi_handler(a->handler, (int)delta, thishandled);
+		trace_nmi_handler(a->handler, (int)delta, thishandled, source_bitmap);
 
 		nmi_check_duration(a, delta);
 	}
@@ -387,6 +387,9 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
 	pr_emerg_ratelimited("Uhhuh. NMI received for unknown reason %02x on CPU %d.\n",
 			     reason, smp_processor_id());
 
+	if (cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
+		pr_emerg_ratelimited("NMI-source bitmap is 0x%lx\n", fred_event_data(regs));
+
 	if (unknown_nmi_panic || panic_on_unrecovered_nmi)
 		nmi_panic(regs, "NMI: Not continuing");
 
diff --git a/include/trace/events/nmi.h b/include/trace/events/nmi.h
index 18e0411398ba..6e4a1ff70a44 100644
--- a/include/trace/events/nmi.h
+++ b/include/trace/events/nmi.h
@@ -10,29 +10,32 @@
 
 TRACE_EVENT(nmi_handler,
 
-	TP_PROTO(void *handler, s64 delta_ns, int handled),
+	TP_PROTO(void *handler, s64 delta_ns, int handled, unsigned long source_bitmap),
 
-	TP_ARGS(handler, delta_ns, handled),
+	TP_ARGS(handler, delta_ns, handled, source_bitmap),
 
 	TP_STRUCT__entry(
 		__field(	void *,		handler	)
 		__field(	s64,		delta_ns)
 		__field(	int,		handled	)
+		__field(	unsigned long,	source_bitmap)
 	),
 
 	TP_fast_assign(
 		__entry->handler = handler;
 		__entry->delta_ns = delta_ns;
 		__entry->handled = handled;
+		__entry->source_bitmap = source_bitmap;
 	),
 
-	TP_printk("%ps() delta_ns: %lld handled: %d",
+	TP_printk("%ps() delta_ns: %lld handled: %d source_bitmap: 0x%lx",
 		__entry->handler,
 		__entry->delta_ns,
-		__entry->handled)
+		__entry->handled,
+		__entry->source_bitmap)
 );
 
 #endif /* _TRACE_NMI_H */
 
-/* This part ust be outside protection */
+/* This part must be outside protection */
 #include <trace/define_trace.h>
-- 
2.43.0


