Return-Path: <kvm+bounces-72714-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIYeNQ9wqGkkugAAu9opvQ
	(envelope-from <kvm+bounces-72714-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:46:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BF52205635
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ACC1230A00A4
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C74B241139;
	Wed,  4 Mar 2026 17:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eoNCiHvj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E613C3C17
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646099; cv=none; b=ZAnMWaASBfWVpLhbOrrR9tX+OHipLI9PYR5o36AoQ1MJSggTtzMMf1Hzy7K+QWmYsAJnCzDlFV/ApED7ElpneKdlKgy3aTqcw6+xsbeokzN75R7bZT0BOl2Sb3MOhZ/oUPJ+cfHmPvnxxl+N3Dw98HtmlruEE9uM0UDJgJTfmqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646099; c=relaxed/simple;
	bh=HsdWH3IQCug86yG4M8vreAU8pD+0O2+b9JS4N0ycLVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ic4wGTsyyDi5J1LFze5Q/b4Bmf+IWvWjwnt2aReIAcG6xLRKkaApeJh7qEARpEX8zw4GHed9q8vvX9ZhNkD4FJGplJ5i2ztGIKWwbaSBdy/inU3ICPoLY+SCpluXQjyvTOg9nEM5TscQ6XmTGHFF13abxrsoCJ3hANntxQq+1ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eoNCiHvj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FF8C2BCB0
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772646099;
	bh=HsdWH3IQCug86yG4M8vreAU8pD+0O2+b9JS4N0ycLVQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eoNCiHvjvdV5vWXRMOebPu9kvxRqSD7uu+3pMrNBK/clJiS9Qp8q/AMpLa9EXqIer
	 YdKasubK73eVSRPDvJzdb7nR7Ox3tYPLHbVso6TbmmabPw3PdnTCirNFOEV2dI/XK3
	 ml+ecCKYLYNWQOps+q7qGH0Au/orkLHufJEF2PZkoGO7KP4bLaidIbwKe7NkzSQ7oo
	 EkT4D7jvOBVgtUp2+f4vJdmcoljYTJnpJuIaxmrGi2UwJb57O+7i2d5LgubR2myGnT
	 rQDF2odHI50fGEzEwYHuaLBZulLC1kLuNpn7POxXCfiWli9FWwvIfN3QU81SwwL3oc
	 NaA4++mjg4d7A==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8fbb24a9a9so1210355866b.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 09:41:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUio4nEOgidfULgfqSmfGbQCsfA+jA2DJP8YPnus3g8dXFmh8yrXYP7+EjLi/PWWs3Fryk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQlz+rosnt0cDpRYjG+e+I6jwE6csumMr7P5bltAKzakvzsBr3
	F9OROEJz/FUUAUyUPlOKXCklCBMh2JuBoju1efOupUCSJzVUQeZn+fKdwgaDB5E40R5myfYAH4C
	7Mua9NGpwy6RDHOrRaW82WBVGwjbE9Gw=
X-Received: by 2002:a17:907:961e:b0:b8f:d2a0:c283 with SMTP id
 a640c23a62f3a-b93ef732f07mr182609666b.1.1772646097880; Wed, 04 Mar 2026
 09:41:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225005950.3739782-1-yosry@kernel.org> <20260225005950.3739782-6-yosry@kernel.org>
 <CAO9r8zN21twRarvzvq8euUOHRtVrO+q8jMaiip7NPtGgZ2dWGw@mail.gmail.com> <aahuZ4bg4aQKTZYj@google.com>
In-Reply-To: <aahuZ4bg4aQKTZYj@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 09:41:26 -0800
X-Gmail-Original-Message-ID: <CAO9r8zPf3wTBN+-SuvjojJuU1uO1xrpy9vMCA=PX9B5r=hJ9bQ@mail.gmail.com>
X-Gm-Features: AaiRm51a3nrzQvCHnyWSZ4AAx4pLxY4TELWbQCXVeLBTFZJS2_7c4lRrib3NE2s
Message-ID: <CAO9r8zPf3wTBN+-SuvjojJuU1uO1xrpy9vMCA=PX9B5r=hJ9bQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] KVM: nSVM: Always use NextRIP as vmcb02's NextRIP
 after first L2 VMRUN
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2BF52205635
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72714-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

[..]
> > > @@ -845,17 +845,24 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
> > >         vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
> > >
> > >         /*
> > > -        * next_rip is consumed on VMRUN as the return address pushed on the
> > > +        * NextRIP is consumed on VMRUN as the return address pushed on the
> > >          * stack for injected soft exceptions/interrupts.  If nrips is exposed
> > > -        * to L1, take it verbatim from vmcb12.  If nrips is supported in
> > > -        * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
> > > -        * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
> > > -        * prior to injecting the event).
> > > +        * to L1, take it verbatim from vmcb12.
> > > +        *
> > > +        * If nrips is supported in hardware but not exposed to L1, stuff the
> > > +        * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
> > > +        * responsible for advancing RIP prior to injecting the event). This is
> > > +        * only the case for the first L2 run after VMRUN. After that (e.g.
> > > +        * during save/restore), NextRIP is updated by the CPU and/or KVM, and
> > > +        * the value of the L2 RIP from vmcb12 should not be used.
> > >          */
> > > -       if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > > -               vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> > > -       else if (boot_cpu_has(X86_FEATURE_NRIPS))
> > > -               vmcb02->control.next_rip    = vmcb12_rip;
> > > +       if (boot_cpu_has(X86_FEATURE_NRIPS)) {
> > > +               if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
> > > +                   !svm->nested.nested_run_pending)
> > > +                       vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
> > > +               else
> > > +                       vmcb02->control.next_rip    = vmcb12_rip;
> > > +       }
> >
> > This should probably also apply to soft_int_next_rip below the context
> > lines. Otherwise after  patch 7 we keep it uninitialized if the guest
> > doesn't have NRIPs and !nested_run_pending.
>
> That's fine though, isn't it?  Because in that case, doesn't the soft int have to
> comein through svm_update_soft_interrupt_rip()?  Ugh, no because nSVM migrates
> control.event_inj.
>
> IIUC, we want to end up with this?

Yes.

>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 03b201fe9613..d12647080051 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -925,7 +925,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
>          */
>         if (is_evtinj_soft(vmcb02->control.event_inj)) {
>                 svm->soft_int_injected = true;
> -               if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> +               if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
> +                   !svm->nested.nested_run_pending)
>                         svm->soft_int_next_rip = vmcb12_ctrl->next_rip;
>         }

