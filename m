Return-Path: <kvm+bounces-73302-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8PQ1EgLSrmlhJAIAu9opvQ
	(envelope-from <kvm+bounces-73302-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:58:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EFBFD23A2D4
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C605F3047BC8
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 13:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C523C199B;
	Mon,  9 Mar 2026 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBiW7HEh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7F63BA23D
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 13:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773064577; cv=none; b=sxeKxqh91GTPqLpFXeOaRZuNQdPjQ5m+pb5eKfHMHk5V8LM3TFOo3cvu8b+VEZRiFNtTcgzrS292ocu63Co04y7etr3FUPFWmvzh3weL3LdsERH43NLE5xc/BsRLbkTi9DeI9PqezF06iHwdqvqBVTGjau4zl557RUVPM4FpgAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773064577; c=relaxed/simple;
	bh=mNZzwruMVbaOMv5zeE09O/fIJCvLS3U6N9iHAXPyFPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jf1dApuMUO8ohVsUFlAtjArWoqJrmwBjvUQi7UG6+yX6EPonf32KovuByA+JINqOH1UZDENmfuTgE3mMLBMY2Yragm/LNL00+hoXk6vRe8T4Rv48YMBJ41TkcXD95LiKPdOqRYDBMtg7oIgc/Yovg+FqukktSdh6BRish0Fq2lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBiW7HEh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E10C2BC86
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773064576;
	bh=mNZzwruMVbaOMv5zeE09O/fIJCvLS3U6N9iHAXPyFPU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CBiW7HEh8ulOceeeCcNqF8Xi/a+tUpJV0EieBF1hfoYL3JinvzJjOcVJfGtBhoEpo
	 z/bMYuxlJTK6uTfI0aPIio8pCdMQ31PjPS2pK5gAcfa7w9bKnW6+E7TOV4NsKJrIwZ
	 qln7SPJ5kbkCq44HggAra+I6o6KSEZf16K/9Z7kg4sVkZthwwwXvEUDa4xj2Et0Gm5
	 SCfkPOZH7jaqSjd1BzzvatQdR0MCSS3MES8ax4DtDcGQ9h+GA8nwiZ0z6ktZ8SbdRO
	 JdnVeV6sR5jwPpe77ACmFydTXrtv3AMLTvuKp4HS1Ljs70TKn5/sOTcByNp+/vaoqn
	 lCOXQ+N1eulsQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b941d924534so408915766b.3
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 06:56:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWK+BkfPPJKQEwJ2SvL0MRfBmcbrGIhymPHKfBB3eXq070FrOHuanH9Io9HEVXRkfcNdNQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwlSPylcSt95eETjrKVi3eHOM/eJAuFVGFSDHxauINmrkfiqsC
	mc6kgA0lssyb5ghZ+XSBuDTPW1+ucFCvW4dIq1OyvQgMV2mvFrBJ0DduweGwCTRaOw/6Y4PULAE
	Rre20IiTPWQZ06lmsDjo8ZVR8Us5IkbQ=
X-Received: by 2002:a17:907:e0d8:b0:b96:df8c:42dc with SMTP id
 a640c23a62f3a-b96df8c48ccmr251443966b.41.1773064575298; Mon, 09 Mar 2026
 06:56:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-5-yosry@kernel.org>
 <CAO9r8zMJw-MGFTiuYbtVfoyA9guYCcA5B4siMttbV5Oka2cs6g@mail.gmail.com>
In-Reply-To: <CAO9r8zMJw-MGFTiuYbtVfoyA9guYCcA5B4siMttbV5Oka2cs6g@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 9 Mar 2026 06:56:03 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPkYAbPQ8os1G5WmTnEt+W3KNK03WajaKugCWEpP8rU1Q@mail.gmail.com>
X-Gm-Features: AaiRm53Kx_E5Ygo8hQOCcCgEt4qIYUKwcnLdtHqCaHJszWBTme-83wJP-PExj5E
Message-ID: <CAO9r8zPkYAbPQ8os1G5WmTnEt+W3KNK03WajaKugCWEpP8rU1Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: nSVM: Fail emulation of VMRUN/VMLOAD/VMSAVE
 if mapping vmcb12 fails
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EFBFD23A2D4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73302-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.952];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 5:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Fri, Mar 6, 2026 at 1:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > KVM currently injects a #GP if mapping vmcb12 fails when emulating
> > VMRUN/VMLOAD/VMSAVE. This is not architectural behavior, as #GP should
> > only be injected if the physical address is not supported or not aligne=
d
> > (which hardware will do before the VMRUN intercept is checked).
> >
> > Instead, handle it as an emulation failure, similar to how nVMX handles
> > failures to read/write guest memory in several emulation paths.
> >
> > When virtual VMLOAD/VMSAVE is enabled, if vmcb12's GPA is not mapped in
> > the NPTs a VMEXIT(#NPF) will be generated, and KVM will install an MMIO
> > SPTE and emulate the instruction if there is no corresponding memslot.
> > x86_emulate_insn() will return EMULATION_FAILED as VMLOAD/VMSAVE are no=
t
> > handled as part of the twobyte_insn cases.
> >
> > Even though this will also result in an emulation failure, it will only
> > result in a straight return to userspace if
> > KVM_CAP_EXIT_ON_EMULATION_FAILURE is set. Otherwise, it would inject #U=
D
> > and only exit to userspace if not in guest mode. So the behavior is
> > slightly different if virtual VMLOAD/VMSAVE is enabled.
> >
> > Fixes: 3d6368ef580a ("KVM: SVM: Add VMRUN handler")
> > Reported-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > ---
>
> Nice find from AI bot, we should probably update gp_interception() to
> make sure we reinject a #GP if the address exceeds MAXPHYADDR.
> Something like:

Actually we should probably add a helper (e.g. svm_instr_should_gp()
or svm_instr_check_rax()) to figure out if we need to #GP on RAX for
VMRUN/VMLOAD/VMSAVE, and use it in both gp_interception() and
check_svme_pa() -- the latter doesn't have the misaligned page check
(although I think in practice we might not need it).

