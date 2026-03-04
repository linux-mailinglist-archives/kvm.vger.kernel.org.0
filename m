Return-Path: <kvm+bounces-72710-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ETuJLVtqGkkugAAu9opvQ
	(envelope-from <kvm+bounces-72710-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:36:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 135D82053A7
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E5DEA30C8D1B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A4EF3B7B62;
	Wed,  4 Mar 2026 17:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rHJTBIB5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEE03B3C13
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772645429; cv=none; b=WSSd1XtY9ecRXBmhC2xZYdJ5CgFNYk2yOxIP0Dto2LG16BG9TrwyA3ohWYwhVro1v6/Y0gatEibB1hzJm858/HciwoxNC2+wgXnQFMmo0UzoM1iXxiylKnWl6eOlSVr6vQJgdulaDsYxjR677/2yu/rYreJPZv2T1NqHoqP1MPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772645429; c=relaxed/simple;
	bh=E19dz6IyKrAhGlsm+z4pNcuuYzyoxTIskPGH6vh2pGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JWx58/e9EFwD8ErbX1ObqceuTdHZZBTcuSW8Xf7MD4ory/fUdtL59ZUBgeY2jMVX6CKjkoyyk5MQU4H0z2h78s1AEPGCdauNn8jQuZI3pcYdOgbhCA4mOfkPLm91Do7/Fe2cCoWRo6dZRIktmbh/YPspZPGWFR+qFm8UwzDeoBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rHJTBIB5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC65C4AF0B
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772645429;
	bh=E19dz6IyKrAhGlsm+z4pNcuuYzyoxTIskPGH6vh2pGg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rHJTBIB5y+KOwvRPQ0QrcTSDk34ANytPv1ub4NzISefGFwTaScvfTsaPPH5fy7Nc6
	 RwUCSxqgmkLrriScd8o/Z9tcBgQefYeGqSsiu6yPzLbj3Bv6Hu8dvzZAv+UMzmqRo0
	 1J1HqT2m7zDzV1DudUq1jLhqcxxH1R9WgdhSeBFAxEr9jmxCbXRkmMicaTaYnFR5za
	 8t+j0yT38xQ7vxKqY7KiId+uplWoq4/QqeoAuJGXWUEPWvHCZBEnC1ir1ca1jJzjmr
	 27GaoRUea6uMBauQRAhys9/3Wy89HWhHk2KVGv6brIuCBzslM96IqisE5vJ2aszmKS
	 Pwu/D9XRvgwnA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b8fb6ad3243so1051001966b.1
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 09:30:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXZLc+Dw3IeDXtc733aMVgczkD07k3Hvws+zh2xiKo4o+HXQsmTdnEoQeZ2dQxSIT38lsA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz75/BT9i2ZtROcZRBKaeE/9tcJb/q8CM27tjANJ1wUKbA/TgnK
	hfWjy0aydNcBGha45vs44qEuUD5JsuJA246zXSDjozBa4CWK2+S4qvc/6yiwnbJceeZZUftIGMZ
	oSECrdSqAW59gicuJmFtgruf7fjFthM8=
X-Received: by 2002:a17:907:6091:b0:b93:6bb6:cb3d with SMTP id
 a640c23a62f3a-b93f155b84dmr187353066b.58.1772645428036; Wed, 04 Mar 2026
 09:30:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225005950.3739782-1-yosry@kernel.org> <20260225005950.3739782-6-yosry@kernel.org>
In-Reply-To: <20260225005950.3739782-6-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 09:30:16 -0800
X-Gmail-Original-Message-ID: <CAO9r8zN21twRarvzvq8euUOHRtVrO+q8jMaiip7NPtGgZ2dWGw@mail.gmail.com>
X-Gm-Features: AaiRm53K2arnc6Pe_pJ28hs-U_pizlA8PwX10feZ4tjIz-S3BnJ0zfjh6f0NmoQ
Message-ID: <CAO9r8zN21twRarvzvq8euUOHRtVrO+q8jMaiip7NPtGgZ2dWGw@mail.gmail.com>
Subject: Re: [PATCH v3 5/8] KVM: nSVM: Always use NextRIP as vmcb02's NextRIP
 after first L2 VMRUN
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 135D82053A7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72710-lists,kvm=lfdr.de];
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

On Tue, Feb 24, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> For guests with NRIPS disabled, L1 does not provide NextRIP when running
> an L2 with an injected soft interrupt, instead it advances the current RI=
P
> before running it. KVM uses the current RIP as the NextRIP in vmcb02 to
> emulate a CPU without NRIPS.
>
> However, after L2 runs the first time, NextRIP will be updated by the
> CPU and/or KVM, and the current RIP is no longer the correct value to
> use in vmcb02.  Hence, after save/restore, use the current RIP if and
> only if a nested run is pending, otherwise use NextRIP.
>
> Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_S=
ET_NESTED_STATE")
> CC: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> ---
>  arch/x86/kvm/svm/nested.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 9909ff237e5ca..f3ed1bdbe76c9 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -845,17 +845,24 @@ static void nested_vmcb02_prepare_control(struct vc=
pu_svm *svm,
>         vmcb02->control.event_inj_err       =3D svm->nested.ctl.event_inj=
_err;
>
>         /*
> -        * next_rip is consumed on VMRUN as the return address pushed on =
the
> +        * NextRIP is consumed on VMRUN as the return address pushed on t=
he
>          * stack for injected soft exceptions/interrupts.  If nrips is ex=
posed
> -        * to L1, take it verbatim from vmcb12.  If nrips is supported in
> -        * hardware but not exposed to L1, stuff the actual L2 RIP to emu=
late
> -        * what a nrips=3D0 CPU would do (L1 is responsible for advancing=
 RIP
> -        * prior to injecting the event).
> +        * to L1, take it verbatim from vmcb12.
> +        *
> +        * If nrips is supported in hardware but not exposed to L1, stuff=
 the
> +        * actual L2 RIP to emulate what a nrips=3D0 CPU would do (L1 is
> +        * responsible for advancing RIP prior to injecting the event). T=
his is
> +        * only the case for the first L2 run after VMRUN. After that (e.=
g.
> +        * during save/restore), NextRIP is updated by the CPU and/or KVM=
, and
> +        * the value of the L2 RIP from vmcb12 should not be used.
>          */
> -       if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> -               vmcb02->control.next_rip    =3D svm->nested.ctl.next_rip;
> -       else if (boot_cpu_has(X86_FEATURE_NRIPS))
> -               vmcb02->control.next_rip    =3D vmcb12_rip;
> +       if (boot_cpu_has(X86_FEATURE_NRIPS)) {
> +               if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
> +                   !svm->nested.nested_run_pending)
> +                       vmcb02->control.next_rip    =3D svm->nested.ctl.n=
ext_rip;
> +               else
> +                       vmcb02->control.next_rip    =3D vmcb12_rip;
> +       }

This should probably also apply to soft_int_next_rip below the context
lines. Otherwise after  patch 7 we keep it uninitialized if the guest
doesn't have NRIPs and !nested_run_pending.

>
>         svm->nmi_l1_to_l2 =3D is_evtinj_nmi(vmcb02->control.event_inj);
>         if (is_evtinj_soft(vmcb02->control.event_inj)) {
> --
> 2.53.0.414.gf7e9f6c205-goog
>

