Return-Path: <kvm+bounces-73088-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yLuRJpf2qmlaZAEAu9opvQ
	(envelope-from <kvm+bounces-73088-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:45:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FC8D2241EA
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:45:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 20231300B9C7
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C53D336A00D;
	Fri,  6 Mar 2026 15:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kCBVlRaw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E8B36C0C4
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772811924; cv=pass; b=Vu7SzTni5UicHnxPgYFaBrllxundEuVQr1jp81CMzyeS+TU/bc3M52mCqVW0vhcGP2+gw06JHpf4xoKIiPowGdIjhoTO9Qz7FZzngVvjdfE3SngtWmyPEvGiqmV4ry1PZUza4vUI66uhS9OvfOhNwbpgknf/hUlicyvx3vSuJgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772811924; c=relaxed/simple;
	bh=hsriqer5Wp7EhxGKavjbKgHNP6RubiuMiTVAUlMf2cc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B7u5YcRj8596eLVkqffPVtWw41lHv87liPDUSRzbAschMlhktIRT5MxL6ByEDdAHV0nEj3O272LyQUUw/Xk/TMqMUe6kcowA1JPWcMSc9RzqpnJCQtI9HXmCHSIRQIXtQGXL+wYa1CHSu8cdPolIRF1UEfDUy91tbaLAdf4Qx0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kCBVlRaw; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5069a785ed2so439431cf.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 07:45:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772811922; cv=none;
        d=google.com; s=arc-20240605;
        b=WZc/mO03c3znBJgCJS7LADxX03JcsjiqguXZ7Ttv6D5dnIUDATDSOiD5mrJgqx2dZ2
         iGS6HMVYCZ2jGpEZQsXGrK8xovCRCecdvj5sqs8GssZNXnoDA2aZTnjYwkHJfzJyLJVh
         H7h3DeNJndAHL0F+r+st66yS4rk51XptHgHBzqCeR3DBG4Wi030B6iGboXLyZtsxPW3A
         RQhm6CeNlZ0EsY6u5wQiyDmoi8yZuoB54fi5AMQsIcNiVEmuvPW6dUXfg0C/ztqYrwr8
         RNeH/uboz5UkztWIhcqAjRzsaoTasKCHixYIihSIQOnmb0asRk2+ZTlf5G/BPR8P7OqU
         OiJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=unhg1T2qCPKxpfY/PSePUJ4/CJHWOdFGonXXRJegCXU=;
        fh=QWVBvisWmT/GMkI1ShlIljKvRXGpif5WlgfA/1ly74k=;
        b=Q70EszkN4pW4FetbVz65LionJCRklJ22TwfJYRL6a0ADVQVhqHqF1IznMkDWD3KRdx
         AUVLHtJV7/Yh8fozqHO7J+2Mpge1jAZgrGGOqELIHbqrk3PYfqCGwpR9RzjhASneTpqX
         RPyzuGRumos/jM8+dfJxxtKkNDbVk14Sto/UAzZpiNwCjUH23L5/GWI/43BtLqXUMkO+
         5hjRFQPRxDtAT8S5jiyENxi3ceGzZvYV4IRvQK0cX/RW3dk572dVZ+YByeMtWz4dCKZU
         nmW8soVva8mXTODXWXwIFV5GgFTfSbDQr6N7f/y6Pl3JqGBeWcN/AxIOVLJzTvy05QmY
         PUxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772811921; x=1773416721; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=unhg1T2qCPKxpfY/PSePUJ4/CJHWOdFGonXXRJegCXU=;
        b=kCBVlRawRE/OLKyh9yKwUivtHD54kRflWhqD1WjK6naGwKHpuzjuD0iA+7UafFIl50
         GZMv8eJqV2fiR5fjBtrmNixIbtk8WMWC6OapqCfSrVPPLPpWwvB/w7CeJGWLwe+HrD0D
         jyNZ2K74c9lm2YKwwUc+3F5j9FzPgjqLofs3FcZ1sk4Tvvc2lTxBXbgpc4UhQ6SPQl0x
         eJKP1s0vOYXlVazXOUcoZfYGBtVJveaMWIi8KyGH9hLDLhyd2+Qw3Yz77N1PqkfOyxAi
         uxjCTqwjcUJATYgS+nVCe6FoKdybcHzW341ihSTW5jlRNe5rmCHLB7h/lQUNcrXKN8PC
         7ArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772811921; x=1773416721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=unhg1T2qCPKxpfY/PSePUJ4/CJHWOdFGonXXRJegCXU=;
        b=ZEx5LEwN8CJA9hCtkFWnVpQkVtBAJRqiF8Gq0b92Ai3g61k+pag/+sIH58kmdbLTq7
         /J0eAko3stzeZeNNupTtJAS3suqON5sZUroZDBlO1ch+giRI9QjD44fEJYvX2+5b4Nav
         30FOTwNqN3cEwh0rSKK7uu0hxt1Ugz0zZ4bIz9XY3AhfkTNELd7P4ri9qOYJjYKot+jJ
         SVLj+UlReQBJtBMU73M9UNB1oPHdZSjYMi7Kfqx9V3rxP46uxu8vaKOsVoVCA+C9hPFO
         KRew/x8+xjW1t0KI0m/62hl1wOVeUOtitIFexrV7SHUG7iiOB6x3J5oJtpZaD+W8HcGb
         6tKw==
X-Gm-Message-State: AOJu0YyQar1PgUQ8FfwVV/GMRmxMRv/74lG9R60FxP083/z69QGdhd9q
	gZWJoQY3VBUhLH6M8o0XGPwA44dz31e6p1yTOTWArdvk8G918unnoiNRi8FVhfQtW6Ltw0SJILI
	4AOWws/PkWVj7tRaNdktkd6fPZjN8cRGceWXnt/Tz
X-Gm-Gg: ATEYQzzJlt0qlL4KQcc52Lpm9kM6Z6bCKNJW6n+yFLxz/MUq59a8M1FH5G/pSBJgADG
	C2gIkm1Bak2aKPJynRim2fp3o1+rbNNxv+DonQ05zetG5eWveApYtQKFUIRDjGOTwzBCQvW8Lkm
	VoUhs9/O2EsVut8Z+AmwHC4tIVf+Eh2bB3+w14ylXpIlXx3950K3ml5s0qLkdEnj7IfL79ZYs4h
	ik62ociW24P30M7sdIWGBFtJKC0XU/28rB2XjhbZYpxlHFvfRX0hJ9IxR4MBKNC2CB3VtwUKiXL
	IvAqLGLy
X-Received: by 2002:a05:622a:1825:b0:501:5180:3c90 with SMTP id
 d75a77b69052e-508fa666c57mr3491241cf.15.1772811920943; Fri, 06 Mar 2026
 07:45:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com> <86ikb96kg8.wl-maz@kernel.org>
In-Reply-To: <86ikb96kg8.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 6 Mar 2026 15:44:44 +0000
X-Gm-Features: AaiRm52XLBmqNfW9v8Obow2Zg0ILvEXXBAF6YDgU2FBbzIjxzMdGtwXjVc2CnoU
Message-ID: <CA+EHjTzenq_xFwe8K_g1KFbETqndS3FnxPiwBRKrMvrxH4Z1qg@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: arm64: Refactor user_mem_abort() into a
 state-object model
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3FC8D2241EA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73088-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.950];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, 6 Mar 2026 at 15:34, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Fri, 06 Mar 2026 14:02:19 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > As promised in my recent patch series fixing a couple of urgent bugs in
> > user_mem_abort() [1], here is the actual refactoring to finally clean up this
> > monolith.
> >
> > If you look through the Fixes: history of user_mem_abort(), you will start to
> > see a very clear pattern of whack-a-mole caused by the sheer size and
> > complexity of the function. For example:
> > - We keep leaking struct page references on early error returns because the
> >   cleanup logic is hard to track (e.g., 5f9466b50c1b and the atomic fault leak
> >   I just fixed in the previous series).
> > - We have had uninitialized memcache pointers (157dbc4a321f) because the
> >   initialization flow jumps around unpredictably.
> > - We have had subtle TOCTOU and locking boundary bugs (like 13ec9308a857 and
> >   f587661f21eb) because we drop the mmap_read_lock midway through the function
> >   but leave the vma pointer and mmu_seq floating around in the same lexical
> >   scope, tempting people to use them.
> >
> > The bulk of the work is in the first 6 patches, which perform a strict,
> > no-logic-change structural refactoring of user_mem_abort() into a clean,
> > sequential dispatcher.
> >
> > We introduce a state object, struct kvm_s2_fault, which encapsulates
> > both the input parameters and the intermediate state. Then,
> > user_mem_abort() is broken down into focused, standalone helpers:
> > - kvm_s2_resolve_vma_size(): Determines the VMA shift and page size.
> > - kvm_s2_fault_pin_pfn(): Handles faulting in the physical page.
> >   - kvm_s2_fault_get_vma_info(): A tightly-scoped sub-helper that isolates the
> >     mmap_read_lock, VMA lookup, and metadata snapshotting.
> > - kvm_s2_fault_compute_prot(): Computes stage-2 protections and evaluates
> >   permission/execution constraints.
> > - kvm_s2_fault_map(): Manages the KVM MMU lock, mmu_seq retry loops, MTE, and
> >   the final stage-2 mapping.
> >
> > This structural change makes the "danger zone" foolproof. By isolating
> > the mmap_read_lock region inside a tightly-scoped sub-helper
> > (kvm_s2_fault_get_vma_info), the vma pointer is confined. It snapshots
> > the required metadata into the kvm_s2_fault structure before dropping
> > the lock. Because the pointers scope ends when the sub-helper returns,
> > accessing a stale VMA in the mapping phase is not possible by design.
> >
> > The remaining patches in are localized cleanup patches. With the logic
> > finally extracted into digestible helpers, these patches take the
> > opportunity to streamline struct initialization, drop redundant struct
> > variables, simplify nested math, and hoist validation checks (like MTE)
> > out of the lock-heavy mapping phase.
> >
> > I think that there are still more opportunities to tidy things up some
> > more, but I'll stop here to see what you think.
>
> Thanks a lot for going through this, this looks like a very valuable
> starting point. From a high-level perspective, the end result is even
> more shocking:
>
> <quote>
> static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_s2_trans *nested,
>                           struct kvm_memory_slot *memslot, unsigned long hva,
>                           bool fault_is_perm)
> {
>         bool write_fault = kvm_is_write_fault(vcpu);
>         bool logging_active = memslot_is_logging(memslot);
>         struct kvm_s2_fault fault = {
>                 .vcpu = vcpu,
>                 .fault_ipa = fault_ipa,
>                 .nested = nested,
>                 .memslot = memslot,
>                 .hva = hva,
>                 .fault_is_perm = fault_is_perm,
>                 .ipa = fault_ipa,
>                 .logging_active = logging_active,
>                 .force_pte = logging_active,
>                 .prot = KVM_PGTABLE_PROT_R,
>                 .fault_granule = fault_is_perm ? kvm_vcpu_trap_get_perm_fault_granule(vcpu) : 0,
>                 .write_fault = write_fault,
>                 .exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu),
>                 .topup_memcache = !fault_is_perm || (logging_active && write_fault),
>         };
> </quote>
>
> This kvm_s2_fault structure is a mess of architectural state (the
> fault itself), hypervisor context (logging_active, force_pte...), and
> implementation details (topup_memcache...). Effectively, that's the
> container for *everything* that was a variable in u_m_a() is now part
> of the structure that is passed around.
>
> The task at hand is now to completely nuke this monster. The
> architectural fault information should be further split, and directly
> passed as a parameter to user_mem_abort(). We have a lot of redundant
> state that is computed, recomputed, derived, and that should probably
> moved into the exact place where it matters.

Thanks Marc! Like I said, I stopped after 13 patches to see what you
think, and if this is the right approach. But yes, more can be done
here.

>
> I'll have a play with it,

Sounds good, and if you'd like me to tackle any particular part of
this, let me know.

I have to admit, breaking this down into pieces and seeing how much
tidier and easier to understand it became felt oddly satisfying.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

