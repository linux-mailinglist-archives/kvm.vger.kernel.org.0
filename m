Return-Path: <kvm+bounces-5603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C253823998
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 01:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC83BB222C0
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 00:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861911878;
	Thu,  4 Jan 2024 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RFpA8CKw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580D81849
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 00:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbe02d0c945so13266276.3
        for <kvm@vger.kernel.org>; Wed, 03 Jan 2024 16:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704327848; x=1704932648; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YGoAdMkmn3Mnvumr2fIYY5+6zsbtkTCTOlb0bB43RH8=;
        b=RFpA8CKw0QT9basRBKCniJs1Un80M1ye9YVQbKW9qNaAM5wVvtrWsapA5Uqe7c2hIY
         +WJAv9XNkLwkOc3AJyWi7enOcEJFagrCc07G7pTmXxqnTJusTV6N/dsllcxXtAJqC+ys
         wkeSsMvRNYlCQfQixWCZ4+xYNC/KB+nMehXQwNDggsgBBMb8NK9zKA5oCNEtM97Ezju0
         3J6wTYq8+Gn/rvAqHPZk1PVgaCjIodkPx+ljVRGPiDoaFsCRypkTHfIRkAl07jQJRBv2
         Lu1lbzv/0wbhvgEC0uzHMqGxyDioE+QW2dmNfjIZdqWkWUz4OLTsnU7ZzSxDKDJ6/+1D
         WgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704327848; x=1704932648;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YGoAdMkmn3Mnvumr2fIYY5+6zsbtkTCTOlb0bB43RH8=;
        b=CYxPkz9xecLea0X4G4N2cWGjgNDArnXz+6Mg7z7LByxb6F7Qzns7/zF+JtFoJUOIQ1
         WAz8Evco6XlKjAfYa5TUkRYo2A/UBdGOkcsud4cXDCwa3D2eBFX6SkeV9W9shmtK/31N
         ioGVnIyeD1xTUDX/SVFbyG+F8DoyaoQPXfOPixvPYgzHSXEEiorf5pqDZxC9wKpX0nBo
         ++QYl5Hkr7iYZaBVepIn5fXXvI2/bsTTSKesNWoqniE3o4CNucoyGHeZEk/w3hnAok6Z
         BsjgObttWSSyhXOndzIVc1iMUTjFvSgN9zUXYqjmtGz/VDJsDnf7vBdQ8kdIxLjT23iQ
         Mupg==
X-Gm-Message-State: AOJu0Yy6iPTeKeh6bdzB2rP/bviLxFrEFY77DurRQn7q5XWxdFPb9Z5c
	1Bct0ZR6hl575wjCj5+NuFhscy0iLKgHAVmhsw==
X-Google-Smtp-Source: AGHT+IF/oqsWgNiKNR618wuHPNv+Itn11kkolYaxoEfHGsUr8PjiJ9wl2bqDgqhJc2D2uuI8GYNIM8pgnKo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8142:0:b0:d9c:801c:4230 with SMTP id
 j2-20020a258142000000b00d9c801c4230mr472209ybm.5.1704327848261; Wed, 03 Jan
 2024 16:24:08 -0800 (PST)
Date: Wed, 3 Jan 2024 16:24:06 -0800
In-Reply-To: <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <3d8f5987-e09c-4dd2-a9c0-8ba22c9e948a@paulmck-laptop> <88f49775-2b56-48cc-81b8-651a940b7d6b@paulmck-laptop>
Message-ID: <ZZX6pkHnZP777DVi@google.com>
Subject: Re: [BUG] Guest OSes die simultaneously (bisected)
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Like Xu <like.xu@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, 
	Kan Liang <kan.liang@linux.intel.com>, Luwei Kang <luwei.kang@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 03, 2024, Paul E. McKenney wrote:
> On Wed, Jan 03, 2024 at 02:22:23PM -0800, Paul E. McKenney wrote:
> > Hello!
> > 
> > Since some time between v5.19 and v6.4, long-running rcutorture tests
> > would (rarely but intolerably often) have all guests on a given host die
> > simultaneously with something like an instruction fault or a segmentation
> > violation.
> > 
> > Each bisection step required 20 hosts running 10 hours each, and
> > this eventually fingered commit c59a1f106f5c ("KVM: x86/pmu: Add
> > IA32_PEBS_ENABLE MSR emulation for extended PEBS").  Although this commit
> > is certainly messing with things that could possibly cause all manner
> > of mischief, I don't immediately see a smoking gun.  Except that the
> > commit prior to this one is rock solid.
> > Just to make things a bit more exciting, bisection in mainline proved
> > to be problematic due to bugs of various kinds that hid this one.  I was
> > therefore forced to bisect among the commits backported to the internal
> > v5.19-based kernel, which fingered the backported version of the patch
> > called out above.
> 
> Ah, and so why do I believe that this is a problem in mainline rather
> than just (say) a backporting mistake?
> 
> Because this issue was first located in v6.4, which already has this
> commit included.
> 
> 							Thanx, Paul
> 
> > Please note that this is not (yet) an emergency.  I will just continue
> > to run rcutorture on v5.19-based hypervisors in the meantime.
> > 
> > Any suggestions for debugging or fixing?

This looks suspect:

+       u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
+       int global_ctrl, pebs_enable;
 
-       arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
-       arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
-       arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-       arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
-       *nr = 1;
+       *nr = 0;
+       global_ctrl = (*nr)++;
+       arr[global_ctrl] = (struct perf_guest_switch_msr){
+               .msr = MSR_CORE_PERF_GLOBAL_CTRL,
+               .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
+               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+       };


IIUC (always a big if with this code), the intent is that the guest's version of
PERF_GLOBAL_CTRL gets bits that are (a) not exclusive to the host and (b) not
being used for PEBS.  (b) is necessary because PEBS generates records in memory
using virtual addresses, i.e. the CPU will write to memory using a virtual address
that is valid for the host but not the guest.  And so PMU counters that are
configured to generate PEBS records need to be disabled while running the guest.

Before that commit, the logic was:

  guest[PERF_GLOBAL_CTRL] = ctrl & ~host;
  guest[PERF_GLOBAL_CTRL] &= ~pebs;

But after, it's now:

  guest[PERF_GLOBAL_CTRL] = ctrl & (~host | ~pebs);

I.e. the kernel is enabled counters in the guest that are not host-only OR not
PEBS.  E.g. if only counter 0 is in use, it's using PEBS, but it's not exclusive
to the host, then the new code will yield (truncated to a single byte for sanity)

  1 = 1 & (0xf | 0xe)

and thus keep counter 0 enabled, whereas the old code would yield

  1 = 1 & 0xf
  0 = 1 & 0xe

A bit of a shot in the dark and completed untested, but I think this is the correct
fix?

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a08f794a0e79..92d5a3464cb2 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4056,7 +4056,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
        arr[global_ctrl] = (struct perf_guest_switch_msr){
                .msr = MSR_CORE_PERF_GLOBAL_CTRL,
                .host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
-               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+               .guest = intel_ctrl & ~(cpuc->intel_ctrl_host_mask | pebs_mask),
        };
 
        if (!x86_pmu.pebs)


