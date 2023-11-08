Return-Path: <kvm+bounces-1099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1647E4E07
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0A25B21007
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A69110E8;
	Wed,  8 Nov 2023 00:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f4fWGlDV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3A362D
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:31:42 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9434110F8
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:31:41 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da1aa98ec19so7588080276.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403501; x=1700008301; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nHi8MKAu3RoJG1H9OsREjBorzQIuSOD8CbIQ6CUD2qY=;
        b=f4fWGlDVtYmmChQc60xF6VR19CcCHcVPHR5PLZwK7MJ6RcfchihMbTASkjdedMY1B7
         Md8lzHjDvAl+46maS4QRm21capeQt5koUBJOyMCQKDS7CApT2dcEjmXen9IFIoDFkR44
         HBvUjCDPFGJ9i8jQYFLVq8n6vpaDzRXDjKosyUR+U9dty10KCRLxgb/xNQI0bztY1zY0
         kdVMfk0ZwY4wdCG9VY2ZR4Z5ZRr1hYcLhHs8jb+/b2jCsL3woY+xcotaYVYCJbRNmiqg
         SZNpJrG1K1YRa4DxcxdkA2uBFIe20zkJOTPX6mVxejDPCIYj8tQV78C4i6lq9XSRcsRg
         DOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403501; x=1700008301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nHi8MKAu3RoJG1H9OsREjBorzQIuSOD8CbIQ6CUD2qY=;
        b=b6EgGJZ8ratgCG7d6MXOkIX5qWrEuUQkdkHrgyFiURFbyHdQCX0SRK58iuBrlXctzk
         1GI/5sVA2OO/VJFrzl9rDh1opnxjGUqHzdA/ZygEUZ2WhHANbPQsq0vxLxsVX6OLR0se
         +iJ56fcutoH1P09H338iuCTpW2lRDXNp4xogjJSR+0LzozvhdpK2jP7mrxoW3bSCNhcn
         zFcWMVuRLNm0wxjaT8FJbHmKCiQi7uL+nr7CSYyif+fp5cLzJsTgeeDgpd3KxYc++Igy
         NdGe5Dxl7hw7zBEcPCVLwFzCfJdYJ+2DLmvuozzstyq2USRP3dQczlJ8Ji/MhTX3mG1J
         KuIA==
X-Gm-Message-State: AOJu0YzrM2AN8HTpnlVQdfpsguC0da3yEFfNDNZ4Ov0qBJLsCdU0Kh5P
	bmUMSoH8tVwg+4p+oSNu1Itt999X5l0=
X-Google-Smtp-Source: AGHT+IF88BI5QU2qEvqZ+FlrY+HznrQyYI4HqN3mo3vo+2MptQV3HA1TjE9vaOmcU47sTQSYpp0Rn9Lpx24=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e643:0:b0:d9a:c218:8177 with SMTP id
 d64-20020a25e643000000b00d9ac2188177mr5331ybh.8.1699403500794; Tue, 07 Nov
 2023 16:31:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:17 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-2-seanjc@google.com>
Subject: [PATCH v7 01/19] KVM: x86/pmu: Always treat Fixed counters as
 available when supported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Treat fixed counters as available when they are supported, i.e. don't
silently ignore an enabled fixed counter just because guest CPUID says the
associated general purpose architectural event is unavailable.

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
from CPUID.0xA.EBX impossible.

Furthermore, the lack of enumeration for an architectural event in CPUID
only means the CPU doesn't officially support the architectural encoding,
i.e. it doesn't mean using the architectural encoding _won't_ work, it
sipmly means there are no guarantees that it will work as expected.  E.g.
if KVM is running in a VM that advertises a fixed counters but not the
corresponding architectural event encoding, and perf decides to use a
general purpose counter instead of a fixed counter, odds are very good
that the underlying hardware actually does support the architectrual
encoding, and that programming the encoding will count the right thing.

In other words, asking perf to count the event will probably work, whereas
intentionally doing nothing is obviously guaranteed to fail.

Note, at the time of the change, KVM didn't enforce hardware support, i.e.
didn't prevent userspace from enumerating support in guest CPUID.0xA.EBX
for architectural events that aren't supported in hardware.  I.e. silently
dropping the fixed counter didn't somehow protection against counting the
wrong event, it just enforced guest CPUID.  And practically speaking, this
issue is almost certainly limited to running KVM on a funky virtual CPU
model.  No known real hardware has an asymmetric PMU where a fixed counter
is supported but the associated architectural event is not.

Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..c6e227edcf8e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -108,11 +108,24 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
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


