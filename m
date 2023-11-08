Return-Path: <kvm+bounces-1269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 801527E5EB4
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 20:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3708228118A
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A6FF37156;
	Wed,  8 Nov 2023 19:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jUxY2Rhl"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E75168A8
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 19:35:07 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE5C2111
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 11:35:07 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a8d9dcdd2bso1145367b3.2
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 11:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699472106; x=1700076906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BeJqDywIA9SJQWdHjdlzV7j446J+Wll1DVQbRo0AN2o=;
        b=jUxY2Rhlsfh5uuNXZV3R+rfBxqaVjmkdCNqwZYkSKFZBJQWKOmFeGfQYDGzP74ES3i
         P2/+v0gMz6I3AN6lhaP8rTI5FHHpz3xWZMTkif1xdaKmdXbQunKDrUG2H7pb73+Ux3Lc
         XTNWLvrfipqpYJKwbAcXVfyzZAs6qlcwjdxh2maZgLy9O8By94Oo70lxbkzqLvvnLix8
         CB+amgoZsy5IEe/udFrJbkO8ggVBpNsxQpbQoVZ3RryuSxSp55ADUxvNyrzFKidJBR5M
         ricNZd/qo2IS7URXwaOPmd6iuShUNq7kHzEbYU63Opslgby+jc4h4tLza31BNqn/9uOq
         Z4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699472106; x=1700076906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BeJqDywIA9SJQWdHjdlzV7j446J+Wll1DVQbRo0AN2o=;
        b=Z+JLHrUXOKLaoQuHmafC8luJJTZMD32wkxqbwEL/Hv/gL1am0zBX1knENA5slc+U8g
         OLGdQV13SpYYTq5kCanQwAvoN3u7EJLPlP4vKa0N0JpWSKKBEq/8pH40QXd6nYiTXg51
         6AX0SAHc4K6S69RReByfkZ2GRjmumBTVXmgZgKs3KlFYbWBGh2Pxghx/qWWA4BMvDFXd
         RMqs5swHpw7c+Gk6tOasATkPbIoDp6QhO04ywMCx9rTunN53Kz679FRaXv6WmG+gmbKB
         UOOpPEIBHVP/jlz9gArkibYp1xAH/EayqopUKVimCPZL2+0+AvKq5TqrX35joyQmr7hJ
         7JjA==
X-Gm-Message-State: AOJu0Yxzznl7XDWC6eNKeU7Hbsvo5MvlzB58edexXcrYngwt01Mxth3R
	zZhc7zPqymxG7XRB98lVslQI8japJZw=
X-Google-Smtp-Source: AGHT+IGLmkrTaPP6S11ajreCCXZPcmYitlsfG2AuK9TV6sy3ukACu8QSNGsAvSLFv8j5p2OKSEkqV8vgDOs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4f8c:0:b0:5a7:bb7e:993e with SMTP id
 d134-20020a814f8c000000b005a7bb7e993emr53158ywb.9.1699472106512; Wed, 08 Nov
 2023 11:35:06 -0800 (PST)
Date: Wed, 8 Nov 2023 11:35:04 -0800
In-Reply-To: <4281eee7-6423-4ec8-bb18-c6aeee1faf2c@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com> <20231108003135.546002-4-seanjc@google.com>
 <4281eee7-6423-4ec8-bb18-c6aeee1faf2c@linux.intel.com>
Message-ID: <ZUvi6P7iKMtsS8wm@google.com>
Subject: Re: [PATCH v7 03/19] KVM: x86/pmu: Remove KVM's enumeration of
 Intel's architectural encodings
From: Sean Christopherson <seanjc@google.com>
To: Kan Liang <kan.liang@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Kan Liang wrote:
> On 2023-11-07 7:31 p.m., Sean Christopherson wrote:
> > @@ -442,8 +396,29 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Map fixed counter events to architectural general purpose event encodings.
> > + * Perf doesn't provide APIs to allow KVM to directly program a fixed counter,
> > + * and so KVM instead programs the architectural event to effectively request
> > + * the fixed counter.  Perf isn't guaranteed to use a fixed counter and may
> > + * instead program the encoding into a general purpose counter, e.g. if a
> > + * different perf_event is already utilizing the requested counter, but the end
> > + * result is the same (ignoring the fact that using a general purpose counter
> > + * will likely exacerbate counter contention).
> > + *
> > + * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
> > + * as there is no architectural general purpose encoding for reference cycles.
> 
> It's not the case for the latest Intel platforms anymore. Please see
> ffbe4ab0beda ("perf/x86/intel: Extend the ref-cycles event to GP counters").

Ugh, yeah.  But that and should actually be easier to do on top.

> Maybe perf should export .event_map to KVM somehow.

Oh for ***** sake, perf already does export this for KVM.  Untested, but the below
should do the trick.  If I need to spin another version of this series then I'll
fold it in, otherwise I'll post it as something on top.

There's also an optimization to be had for kvm_pmu_trigger_event(), which incurs
an indirect branch not only every invocation, but on every iteration.  I'll post
this one separately.

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5fc5a62af428..a02e13c2e5e6 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -405,25 +405,32 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  * different perf_event is already utilizing the requested counter, but the end
  * result is the same (ignoring the fact that using a general purpose counter
  * will likely exacerbate counter contention).
- *
- * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
- * as there is no architectural general purpose encoding for reference cycles.
  */
 static u64 intel_get_fixed_pmc_eventsel(int index)
 {
-       const struct {
-               u8 eventsel;
-               u8 unit_mask;
-       } fixed_pmc_events[] = {
-               [0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
-               [1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
-               [2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
+       enum perf_hw_id perf_id;
+       u64 eventsel;
+
+       BUILD_BUG_ON(KVM_PMC_MAX_FIXED != 3);
+
+       switch (index) {
+       case 0:
+               perf_id = PERF_COUNT_HW_INSTRUCTIONS;
+               break;
+       case 1:
+               perf_id = PERF_COUNT_HW_CPU_CYCLES;
+               break;
+       case 2:
+               perf_id = PERF_COUNT_HW_REF_CPU_CYCLES;
+               break;
+       default:
+               WARN_ON_ONCE(1);
+               return 0;
        };
 
-       BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
-
-       return (fixed_pmc_events[index].unit_mask << 8) |
-               fixed_pmc_events[index].eventsel;
+       eventsel = perf_get_hw_event_config(perf_id);
+       WARN_ON_ONCE(!eventsel && index < kvm_pmu_cap.num_counters_fixed);
+       return eventsel;
 }
 
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)

