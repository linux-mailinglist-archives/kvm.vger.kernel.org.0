Return-Path: <kvm+bounces-551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEF97E0C76
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 01:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C91A1C2110A
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D8533F5;
	Sat,  4 Nov 2023 00:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="byDXblP4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAB92917
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 00:02:50 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB208D62
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 17:02:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc391ca417so20680125ad.0
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 17:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699056168; x=1699660968; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qddZI5QlDYzkDDGMWXMNXP2vKdkDVMrPtOHGx6AbiEs=;
        b=byDXblP4cNIdEpE/d9r52ueFTlhR93MmVW7ZYBxtIjeNwlSRrs/pWCiS6ZL0gXgZeC
         3+WyIjyee77RjBGJ5ws1LLp5hjyUWc15DqrMbDOIa4RL04oCeUauUZy1Q3JdHzRVInca
         jSlOJoygzuKi1+49VvB9fCCGjAKag1Y36mOSJqkz7njdd7U2P870wDCklI6pbd4KUjDN
         gFTc7XvR5AhSJGEqIPzn/qrGpbl/ViKg+AQ2RGpQgApggXo//rtIm5UZQ+V3tX1RG0Hy
         rldEN/EWdeJIMPtt2dUvZk86tjo8RNfqauEYpbm+yNS9l/Hdhsq3bz2MAcI6RM4MleIw
         g8Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699056168; x=1699660968;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qddZI5QlDYzkDDGMWXMNXP2vKdkDVMrPtOHGx6AbiEs=;
        b=EcPC0kGzV+csjbiBxCopvV3ppmFtXsV8HpAoXkmATzzWgG82CiB1wzNwKgllgo/UPx
         dbchoLg/K/toKAgCSHnc4DiYQ76bmLnn5c8cep9eWKLc2SQR7JkQ+MDZaNRxOrsbgF5F
         lzpmzJXbT9OSngyIsjUPxt7fncE120PHR5FUwf5Ac3iMRjue6zoFuO+KztEjJRa9j2mi
         AVxeT/2WF78WG5mzTUMhls2827kYBvbZcN6JbfTKIUjYVYSBxJIDfi8CKa+99ZDxRKnU
         3OH+k7GfwzVyl59OgiAp1DwcNItDGVc9bX/8AYzAUQz1acHCwF30gwc5BmSqpEREGRE4
         3oEw==
X-Gm-Message-State: AOJu0YyzwRBzJMkDYk3PjZcI/XQ1t1tsulR/RJJ8R8KS2ss8iqql5fRl
	6pF89zijQLl7D2NhvDYk2KL97S9ideg=
X-Google-Smtp-Source: AGHT+IGx/PwxlYpOuRKdZYbE5Hej8a6OBTDWyR7ILfdU8v4Jzm6thIWMKr1A2kcm/hqxX7sahHWFkfGx6ug=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab84:b0:1c9:b045:5a8b with SMTP id
 f4-20020a170902ab8400b001c9b0455a8bmr372275plr.6.1699056168312; Fri, 03 Nov
 2023 17:02:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Nov 2023 17:02:22 -0700
In-Reply-To: <20231104000239.367005-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231104000239.367005-5-seanjc@google.com>
Subject: [PATCH v6 04/20] KVM: x86/pmu: Always treat Fixed counters as
 available when supported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that KVM hides fixed counters that can't be virtualized, treat fixed
counters as available when they are supported, i.e. don't silently ignore
an enabled fixed counter just because guest CPUID says the associated
general purpose architectural event is unavailable.

KVM originally treated fixed counters as always available, but that got
changed as part of a fix to avoid confusing REF_CPU_CYCLES, which does NOT
map to an architectural event, with the actual architectural event used
associated with bit 7, TOPDOWN_SLOTS.

The commit justified the change with:

    If the event is marked as unavailable in the Intel guest CPUID
    0AH.EBX leaf, we need to avoid any perf_event creation, whether
    it's a gp or fixed counter.

but that justification doesn't mesh with reality.  The Intel SDM uses
"architectural events" to refer to both general purpose events (the ones
with the reverse polarity mask in CPUID.0xA.EBX) and the events for fixed
counters, e.g. the SDM makes statements like:

  Each of the fixed-function PMC can count only one architectural
  performance event.

but the fact that fixed counter 2 (TSC reference cycles) doesn't have an
associated general purpose architectural makes trying to apply the mask
from CPUID.0xA.EBX impossible.  Furthermore, the SDM never explicitly
says that an architectural events that's marked unavailable in EBX affects
the fixed counters.

Note, at the time of the change, KVM didn't enforce hardware support, i.e.
didn't prevent userspace from enumerating support in guest CPUID.0xA.EBX
for architectural events that aren't supported in hardware.  I.e. silently
dropping the fixed counter didn't somehow protection against counting the
wrong event, it just enforced guest CPUID.

Arguably, userspace is creating a bogus vCPU model by advertising a fixed
counter but saying the associated general purpose architectural event is
unavailable.  But regardless of the validity of the vCPU model, letting
the guest enable a fixed counter and then not actually having it count
anything is completely nonsensical.  I.e. even if all of the above is
wrong and it's illegal for a fixed counter to exist when the architectural
event is unavailable, silently doing nothing is still the wrong behavior
and KVM should instead disallow enabling the fixed counter in the first
place.

Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8d545f84dc4a..b239e7dbdc9b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -147,11 +147,24 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	/*
+	 * Fixed counters are always available if KVM reaches this point.  If a
+	 * fixed counter is unsupported in hardware or guest CPUID, KVM doesn't
+	 * allow the counter's corresponding MSR to be written.  KVM does use
+	 * architectural events to program fixed counters, as the interface to
+	 * perf doesn't allow requesting a specific fixed counter, e.g. perf
+	 * may (sadly) back a guest fixed PMC with a general purposed counter.
+	 * But if _hardware_ doesn't support the associated event, KVM simply
+	 * doesn't enumerate support for the fixed counter.
+	 */
+	if (pmc_is_fixed(pmc))
+		return true;
+
 	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
 
 	/*
 	 * Disallow events reported as unavailable in guest CPUID.  Note, this
-	 * doesn't apply to pseudo-architectural events.
+	 * doesn't apply to pseudo-architectural events (see above).
 	 */
 	for (i = 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
 		if (intel_arch_events[i].eventsel != event_select ||
-- 
2.42.0.869.gea05f2083d-goog


