Return-Path: <kvm+bounces-71568-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OeDGaX4nGmJMQQAu9opvQ
	(envelope-from <kvm+bounces-71568-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:02:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D36E618065A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 02:02:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A3C5030634EE
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D761123A9AD;
	Tue, 24 Feb 2026 01:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWgQcPu3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1993B1DFF0
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 01:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771894938; cv=none; b=A1cFcUYjkUqiit5HojrzGxIkr6L24uUpIuWf1FwhsH+KCYC0iFplyo7nRCg9oHlnQm8FL67xOnEtfAM35N2Zq5GMmkr0ymYd9UjSxyE1j5PtJX7IAmWgfbyNLpBhWPnD10r+Xn4oUQFr8bzR9I1ipmoO+YIYUjnel9/ub3jNQ1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771894938; c=relaxed/simple;
	bh=s8JIpnu8OntIfRHiECUY96A5mR3QpMa8WB+CmIPbyT4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E76NaxrrC8JrJ2pXETk7QYhRZrqOLZBRaLOeqXJkyv2Pe9rL+2JTvNjN/M0N3i4tFEiR8pCxrrupCPBak42ZcFEOgeQTPT5dorxzkcCLYUqAk3VING2dTYuWXD5OsYa5FNKuCvEy3WLIaoLK1hbNo5giw7A6nLjrTMWFUg9WP8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWgQcPu3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB70BC19421
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 01:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771894937;
	bh=s8JIpnu8OntIfRHiECUY96A5mR3QpMa8WB+CmIPbyT4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nWgQcPu3CY3n0gBLYFlq+odV9K/BwmJsMPVjKgq96elApybTk23RlaaTGfXQYKLpM
	 E4OrRw4JzuaQqQboCWPDB8bK0E7YAmi+pK8BYCGDLnuWZdJ66d7VLL/wpe0qr39H9b
	 Rd6PJmBQYc8MLTTH0Ko6w4SGh2y/rDCYwAHtskL6woLy6vaVjnyTxnVtbBBNbxQVnZ
	 5zGgDwIiqzMoPu54Gp9biwWq+jekq6LerKWZQwrrBFGrIS9TggRdqyg3rraGlmAJ5h
	 eauUD9vKZQH3LjL4k1MmhigcNZWaLE7ulWdXVI7wl4nSsEb686ItH9z1QvpL1jyHHB
	 IE342pJDg1fWQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-65a380b554bso9679501a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 17:02:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV7xmoSrEb6V9OKuO2qdeqqbzknnOrfRtBqsCJ+0NS7ZXsm/eFU40zA+0BakEyDWWnNcR0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGdaq2JMi/c44kiG5WRy9n4bJ2V6KvwVCY7YRDjhnZ2zeM3G22
	uagoSVqJv/nXQt/usfQGxKeYC6j03L+nJ3RYT5Qh0A2xeQNF/uxRmeYgo7epsdBk3k6z/JSd0bQ
	lhMolRsxgwP9Cw1uZ3U+ul2fQ172dp/Q=
X-Received: by 2002:a17:906:eec4:b0:b91:949a:721 with SMTP id
 a640c23a62f3a-b91949a077emr64726566b.50.1771894936615; Mon, 23 Feb 2026
 17:02:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
 <20260206190851.860662-26-yosry.ahmed@linux.dev> <aZzfhY1qigh71n2e@google.com>
In-Reply-To: <aZzfhY1qigh71n2e@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 23 Feb 2026 17:02:05 -0800
X-Gmail-Original-Message-ID: <CAO9r8zP1hwzgX3iXDu3TuYQAiqdKrSOw6yuLL+PQFwm=CH0Lug@mail.gmail.com>
X-Gm-Features: AaiRm51nu4nsH-U0iKHQ2hvIXzsAlCUD6RyD8qPwLpLX0_8SHlGNaHTyULP2gCc
Message-ID: <CAO9r8zP1hwzgX3iXDu3TuYQAiqdKrSOw6yuLL+PQFwm=CH0Lug@mail.gmail.com>
Subject: Re: [PATCH v5 25/26] KVM: nSVM: Sanitize control fields copied from VMCB12
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71568-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D36E618065A
X-Rspamd-Action: no action

[..]
> > For the remaining fields, make sure only defined bits are copied from
> > L1's VMCB12 into KVM'cache by defining appropriate masks where needed.
> > The only exception is tlb_ctl, which is unused, so remove it.
> >
> > Opportunistically cleanup ignoring the lower bits of {io/msr}pm_base_pa
> > in __nested_copy_vmcb_control_to_cache() by using PAGE_MASK. Also, move
> > the ASID copying ahead with other special cases, and expand the comment
> > about the ASID being copied only for consistency checks.
>
> Stop. Bundling. Changes.
>
> This is not a hypothetical situation, bundling small changes like this is quite
> literally making review take 3-4x longer than it should.
>
> The interrupt changes are trivial to review.
>
> The I/O and MSR bitmap changes are also easy enough, but I wanted to double that
> PAGE_MASK does indeed equal ~0x0fffULL (__PHYSICAL_MASK is the one that can be dynamic).
>
> I disagree the the tlb_ctl change.
>
> Moving the ASID handling is _completely_ superfluous.
>
> Combining any two of those is annoying to deal with.  Combining all of them wastes
> a non-trivial amount of time.  What should have taken me ~5 minutes to review is
> dragging into 20+ minutes, because I keep having to cross-reference the changelog
> with the code to understand WTF is going on.

Sigh, I kept it as-is because these changes have been together since
the first or second version. You did mention cleaning up the
definitions being split into a different patch (which I did, and then
we dropped it entirely), but I thought keeping the asid and tlb_ctl
changes here were fine.

[..]
> > @@ -499,32 +499,35 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
> >       if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NPT))
> >               to->misc_ctl &= ~SVM_MISC_ENABLE_NP;
> >
> > -     to->iopm_base_pa        = from->iopm_base_pa;
> > -     to->msrpm_base_pa       = from->msrpm_base_pa;
> > +     /*
> > +      * Copy the ASID here because nested_vmcb_check_controls() will check
> > +      * it.  The ASID could be invalid, or conflict with another VM's ASID ,
>
> Spurious space before the command.
>
> > +      * so it should never be used directly to run L2.
> > +      */
> > +     to->asid = from->asid;
> > +
> > +     /* Lower bits of IOPM_BASE_PA and MSRPM_BASE_PA are ignored */
> > +     to->iopm_base_pa        = from->iopm_base_pa & PAGE_MASK;
> > +     to->msrpm_base_pa       = from->msrpm_base_pa & PAGE_MASK;
> >>      to->tsc_offset          = from->tsc_offset;
> > -     to->tlb_ctl             = from->tlb_ctl;
>
> I don't think we should completely drop tlb_ctl.  KVM doesn't do anything with
> vmcb12's tlb_ctl only because we haven't addressed the TODO list in
> nested_svm_transition_tlb_flush().  I think I would rather update this code to
> sanitize the field now, as opposed to waiting until we address that TODO.
>
> KVM advertises X86_FEATURE_FLUSHBYASID, so I think we can do the right thing
> without having to speculate on what the future will bring.
>
> Alternatively, we could add a TODO here or update the one in
> nested_svm_transition_tlb_flush(), but that seems like more overall work than
> just hardening the code.

I will drop the ASID change.

I honestly don't know where to draw the line at this point. Should I
split sanitizing all different fields into different patches? Or just
split the tlb_ctl change? What about the I/O and MSR bitmap change?

