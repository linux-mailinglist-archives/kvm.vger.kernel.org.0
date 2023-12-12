Return-Path: <kvm+bounces-4200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDEC80F14F
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06C4028179D
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 15:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C137C7765A;
	Tue, 12 Dec 2023 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jgsCkjFV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522B0DB
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:39:31 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5e16d7537bcso18894657b3.3
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 07:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702395570; x=1703000370; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p54hpe335w06rR0ZHj0lKwXGwdjAp5UI+KSbZqm/9GM=;
        b=jgsCkjFVqbsbHCnXGh9IbrKmspOTx+9FeN06ZTRWhWczMQdewb7PtS0juKhjjLDn2Y
         0NzpSepbjmWKC6dTm+YuReARncZDhtPjImCDmS26zrNCkBg2PsToOMcE7HPb8H1qHsJh
         +HKvdcI10BQpy5/ohlm1R9ShoePrRJvR0QgM2fVSNbx7f9G8HRvEoeDudhQEDydgUB7i
         rtp91LDhKvgf0ZZIKsj26l5esHIydD5snGxepSp6mjMX66VvvU4RaTuYRVVfhZPaYWj+
         IpSutVlbqUf+/Xxxkd8WHQAndFARaPc9Uj4o1hXOTjntlzTREVLzX6WSzUwdjiWgoIeM
         Ih/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702395570; x=1703000370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p54hpe335w06rR0ZHj0lKwXGwdjAp5UI+KSbZqm/9GM=;
        b=FuAS+YqRjQLbLFkVuKB2RTCaPrBTv5C8yky7pNqXTP35JTM+yLgPinUlscs+sGgDCB
         MkvTVc1aiJ2fDmvYAov2M+nG+NwUb8ozXWV6WO5ql3T5pLe2eWwSa9mZrgc1paSj4WF/
         yNOCTo0zcHVPvzjSOwuD8j6nB9MqMih2857LReHTswx6dmpWNTg/CgnSZOCozzy3QONz
         1gev7Zvf/qGvM2a4I8X5qOISSAg8p227K2K7HeJT7lijfzJ0EIMCieX5G4bZ6PGLQaB2
         FnmoP1jJ/0pnpNhS+6TnRnFh8bBwGl8IMKatv3DdyFY36unWfDA3xRqwZFCclxj6fMUT
         8rMA==
X-Gm-Message-State: AOJu0YxSyaS1EStmxwS8d8qFJN4QeHrFLXOXYe1bmxAWty5Megf39mj1
	Bw8Vy+sqU9ZhUijMvoC1Q6XDyoCJZig=
X-Google-Smtp-Source: AGHT+IFKi0uRKRa7W+9Uw7FzkHJJ2V/r3TZFyxuh8FHz/g4bsH12mqF/muLdnvbE4DOmcwVLfCIoEGZHJ34=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:783:0:b0:db5:4766:e363 with SMTP id
 b3-20020a5b0783000000b00db54766e363mr45369ybq.6.1702395570470; Tue, 12 Dec
 2023 07:39:30 -0800 (PST)
Date: Tue, 12 Dec 2023 07:39:29 -0800
In-Reply-To: <SYBPR01MB687083237B0E5C03B63EDAB99D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <SYBPR01MB687069BFC9744585B4EEF8C49D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
 <SYBPR01MB687083237B0E5C03B63EDAB99D88A@SYBPR01MB6870.ausprd01.prod.outlook.com>
Message-ID: <ZXh-sRZQWvJYn0uJ@google.com>
Subject: Re: [PATCH v3 4/5] perf kvm: Support sampling guest callchains
From: Sean Christopherson <seanjc@google.com>
To: Tianyi Liu <i.pear@outlook.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mingo@redhat.com, 
	acme@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com, 
	mlevitsk@redhat.com, maz@kernel.org, alexander.shishkin@linux.intel.com, 
	jolsa@kernel.org, namhyung@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com
Content-Type: text/plain; charset="us-ascii"

On Sun, Dec 10, 2023, Tianyi Liu wrote:
> This patch provides support for sampling guests' callchains.
> 
> The signature of `get_perf_callchain` has been modified to explicitly
> specify whether it needs to sample the host or guest callchain. Based on
> the context, `get_perf_callchain` will distribute each sampling request
> to one of `perf_callchain_user`, `perf_callchain_kernel`,
> or `perf_callchain_guest`.
> 
> The reason for separately implementing `perf_callchain_user` and
> `perf_callchain_kernel` is that the kernel may utilize special unwinders
> like `ORC`. However, for the guest, we only support stackframe-based
> unwinding, so the implementation is generic and only needs to be
> separately implemented for 32-bit and 64-bit.
> 
> Signed-off-by: Tianyi Liu <i.pear@outlook.com>
> ---
>  arch/x86/events/core.c     | 63 ++++++++++++++++++++++++++++++++------
>  include/linux/perf_event.h |  3 +-
>  kernel/bpf/stackmap.c      |  8 ++---
>  kernel/events/callchain.c  | 27 +++++++++++++++-
>  kernel/events/core.c       |  7 ++++-
>  5 files changed, 91 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 40ad1425ffa2..4ff412225217 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -2758,11 +2758,6 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	struct unwind_state state;
>  	unsigned long addr;
>  
> -	if (perf_guest_state()) {
> -		/* TODO: We don't support guest os callchain now */
> -		return;
> -	}
> -
>  	if (perf_callchain_store(entry, regs->ip))
>  		return;
>  
> @@ -2778,6 +2773,59 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
>  	}
>  }
>  
> +static inline void
> +perf_callchain_guest32(struct perf_callchain_entry_ctx *entry,
> +		       const struct perf_kvm_guest_unwind_info *unwind_info)
> +{
> +	unsigned long ss_base, cs_base;
> +	struct stack_frame_ia32 frame;
> +	const struct stack_frame_ia32 *fp;
> +
> +	cs_base = unwind_info->segment_cs_base;
> +	ss_base = unwind_info->segment_ss_base;
> +
> +	fp = (void *)(ss_base + unwind_info->frame_pointer);
> +	while (fp && entry->nr < entry->max_stack) {
> +		if (!perf_guest_read_virt((unsigned long)&fp->next_frame,

This is extremely confusing and potentially dangerous.  ss_base and
unwind_info->frame_pointer are *guest* SS:RBP, i.e. this is referencing a guest
virtual address.  It works, but it _looks_ like the code is fully dereferencing
a guest virtual address in the hose kernel.  And I can only imagine what type of
speculative accesses this generates.

*If* we want to support guest callchains, I think it would make more sense to
have a single hook for KVM/virtualization to fill perf_callchain_entry_ctx.  Then
there's no need for "struct perf_kvm_guest_unwind_info", perf doesn't need a hook
to read guest memory, and KVM can decide/control what to do with respect to
mitigating speculatiion issues. 

> +					  &frame.next_frame, sizeof(frame.next_frame)))
> +			break;
> +		if (!perf_guest_read_virt((unsigned long)&fp->return_address,
> +					  &frame.return_address, sizeof(frame.return_address)))
> +			break;
> +		perf_callchain_store(entry, cs_base + frame.return_address);
> +		fp = (void *)(ss_base + frame.next_frame);
> +	}
> +}

