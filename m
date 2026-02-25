Return-Path: <kvm+bounces-71745-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eF/XFExUnmm3UgQAu9opvQ
	(envelope-from <kvm+bounces-71745-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:45:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EBDC518FC57
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:45:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2921A306A129
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:43:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688AA285066;
	Wed, 25 Feb 2026 01:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObPThA8y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA5B283CB5
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983745; cv=none; b=UDW4akPvk9aqx1Dm0VAeKVszGflIFncOWdiKWPRGToWjxc9Np/ijA0jU/TB3C1OdAsLHCHJNsAsykfPqJ8YDvoPnSlmUyTR1lIoIX2o/AJCHH2HpWWfuQBOoEjinrxBrjcaVLmWAsot+a5hmtxxbz7TmkL729yF+akXT/17uTHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983745; c=relaxed/simple;
	bh=R1GxnxBAq9BLjZ1c5K6TFLjX8vN3LYKcB1tpJ7YQdq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mF89h9KKvFY/5k4PG9g/90daOTpn0+qTE9OQ89dSQparPDdkMxCRwMYQQHJgHRJPM9mRDQTXEb9QMbkdEVM+ororAFSF6b0695y0pHR+Z2DVT0KvU6lZQUZ/8MOkYfC4gOWwj1EFFpB7OseHik32KHPlPOM50hVSAMFvpqWIrCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObPThA8y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7143CC2BCAF
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771983745;
	bh=R1GxnxBAq9BLjZ1c5K6TFLjX8vN3LYKcB1tpJ7YQdq8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ObPThA8y6QCn+jRFDSGLUouW9QoXW439TgnqkQbwHFyJaDiXGHITs5b24KlEu0Euj
	 9vY1SZuJpVqpXuxsFhuaDVocJQewQJwe+MN6NzEYLMEJsLaaHbb2DAz1BEWKtrzc2B
	 hXYGyffmkIQfoS8IZCho87tKNSb/WL5xiz9Eu/jElnU+n1SluI6fabY/jNGYCG4nW0
	 35S+ZY77aQiFMUu/1gLzQ1XoKEhN2wQK+wxbD4sGwiI9OXQasfnutlh8HAmZzLGEuN
	 kO8FG2qBviCIGCsMjiHWV9JAakAYPYHlWCM9Wm1AX71dimTf2VWA8hXB6XsN6OYI6E
	 div5tfY3eOtzA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8fbb24a9a9so59093666b.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:42:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX37sUeucg6fCAsFjdfax0p4/i7bVWrCyrds8XvtOLTmRirWjgGanM5VLco+hF9UXX1Dh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdhUtDnd67pYAOw1XQCz7GpfkvMp9q231IlqHeXrw0/8HPNZzZ
	YldQf6rmAOo7HGDiVljw7CMF41GkURTPYGkM6WM0ANYPDZndo33tbjdiM5UmNXFTt91G+M6ria2
	P0j0YjTS43NLqb8wxrWOionEZY2lNL/E=
X-Received: by 2002:a17:907:3c8f:b0:b76:d8cc:dfd9 with SMTP id
 a640c23a62f3a-b933cd85c52mr133517266b.18.1771983744284; Tue, 24 Feb 2026
 17:42:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223154636.116671-1-yosry@kernel.org> <20260223154636.116671-3-yosry@kernel.org>
 <CAO9r8zPsAMaiU794xoXDso3sdAM0_EN2PyE13vR4NqqEh9e2=g@mail.gmail.com>
 <aZ5ItfEUtIlVbzuQ@google.com> <CAO9r8zPbu1BsOsPU02YcCLDbRXZoDmVd8XiMHssSDnkjdDPC4g@mail.gmail.com>
 <aZ5MF8_RK56C8B9Q@google.com> <CAO9r8zO+Eej0AjzQt6dnELKLKHZ33DGLbDv=_sP1J1qLMVWpvw@mail.gmail.com>
 <aZ5Pnvb4OAVWWtuR@google.com>
In-Reply-To: <aZ5Pnvb4OAVWWtuR@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 17:42:12 -0800
X-Gmail-Original-Message-ID: <CAO9r8zO0tmJvddCknSM++jU8LBrRecByzzsSf3=J9LrGO2pmdQ@mail.gmail.com>
X-Gm-Features: AaiRm53duMnuTyyD9bUO3MnZl3Mm0qAcWFLxL-WcJ3_D86On5FISLdFuFwbGZfI
Message-ID: <CAO9r8zO0tmJvddCknSM++jU8LBrRecByzzsSf3=J9LrGO2pmdQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] KVM: nSVM: Delay stuffing L2's current RIP into
 NextRIP until vCPU run
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71745-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,cs.base:url,mail.gmail.com:mid]
X-Rspamd-Queue-Id: EBDC518FC57
X-Rspamd-Action: no action

> > We discussed a helper before and you didn't like it, but that was in a
> > different context (a helper that combined normal and special cases).
> > WDYT?
>
> A helper would work.  svm_fixup_nested_rips() is good, the only flaw is the CS.base
> chunk, but I'm not sure I care enough about 32-bit to reject the name just because
> of that :-)
>
> That would make it easier to reduce indentation, e.g.
>
> static void svm_fixup_nested_rips(struct kvm_vcpu *vcpu)
> {
>         struct vcpu_svm *svm = to_svm(vcpu);
>
>         /*
>          * If nrips is supported in hardware but not exposed to L1, stuff the
>          * actual L2 RIP to emulate what a nrips=0 CPU would do (L1 is
>          * responsible for advancing RIP prior to injecting the event). Once L2
>          * runs after L1 executes VMRUN, NextRIP is updated by the CPU and/or
>          * KVM, and this is no longer needed.
>          *
>          * This is done here (as opposed to when preparing vmcb02) to use the
>          * most up-to-date value of RIP regardless of the order of restoring
>          * registers and nested state in the vCPU save+restore path.
>          *
>          * Simiarly, initialize svm->soft_int_* fields here to use the most
>          * up-to-date values of RIP and CS base, regardless of restore order.
>          */
>         if (!is_guest_mode(vcpu) || !svm->nested.nested_run_pending)
>                 return;
>
>         if (boot_cpu_has(X86_FEATURE_NRIPS) &&
>             !guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>                 svm->vmcb->control.next_rip = kvm_rip_read(vcpu);
>
>         if (svm->soft_int_injected) {
>                 svm->soft_int_csbase = svm->vmcb->save.cs.base;
>                 svm->soft_int_old_rip = kvm_rip_read(vcpu);
>                 if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
>                         svm->soft_int_next_rip = kvm_rip_read(vcpu);
>         }
> }

Looks good, thanks Sean!

