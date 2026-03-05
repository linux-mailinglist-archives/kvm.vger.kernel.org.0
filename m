Return-Path: <kvm+bounces-72824-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sFIXLMWgqWnGAwEAu9opvQ
	(envelope-from <kvm+bounces-72824-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:27:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE3B2147DA
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 16:27:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 24847306B78B
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 15:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C68B3C277B;
	Thu,  5 Mar 2026 15:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p1fFDBNS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766E83BED79
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772724123; cv=none; b=Wmi9oqi+ojiW1RYtn1xIDrq3+9S996b/MSZsv5Pphxrk4Ndzp9Md9LLNGAKmkesA0pMy5epYwMqIA8DOGLL49JXhKPArSmGOb2teRoW+u2OgTDTiOzbw5EyKpEmgYiTREBJBCauHSjrvIMyz956ZdUTqUlhAS6rWPGw1PVLTpBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772724123; c=relaxed/simple;
	bh=hVwWUyTaBA1X0Qtv3VS+VDzhq2Nom128L7vHpqlnT6Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JspefxXLMm7C2XHOuBOY9kYYHOIZ2Zlq+iAhhlyr5rCi9aTmRhNwkMpeBfHrtni91ooZlF7DVGW6OkmXGQNZz51VTopndhJyDVszc79JnO4X8XasUrFrp7iEJUyLr38kjitx8N1lgMdkSjVD9FBjhkWfc9dc1FHIDqAqxelZMcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p1fFDBNS; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3598733bec0so24337964a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 07:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772724121; x=1773328921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0L2qC3HnwuZHtn35QgRRL4tVQXqNGluOA+1BljQbEOw=;
        b=p1fFDBNSvRzFGBz37YQq5XBLg9u6JzIyvcAeK0vbP0w+7FpU+yBZzUb3MK8wb2W+27
         lc07v29E/YQbHqIRIKgwE2zP02L2qnBMPoE8JzBhAHpY2jZbAWXKxuaqbrHMLstUdfxV
         NnIp5tkCAg4S4s707/WwqqhbsVhcKdbejBn5u9J6s156D/K1jNuWuTM2Jh7olHngde21
         Pz2DuKNBLZr2NA9TPsNkoYDw3Jomit28pizECuMX23Xo/fVQLaFmOnXD/ny8ZMdmjNYd
         FoQQlp+f6EmkAWndn2mwKDQ/OOiQviSuMbf9Ahf0ww/kPQ/4rJ8/tV77QV0zxFIRvaeZ
         iUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772724121; x=1773328921;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0L2qC3HnwuZHtn35QgRRL4tVQXqNGluOA+1BljQbEOw=;
        b=ExxTGEXe+1VEEnhZR5R0jOz0GYO8Cg8eKdJ4oUAdt02MXJUJlBBSO+KRAc6MgcWaeh
         HQZIV6lAC5d0f1VvTG31Ja/Zif4i0w1UOCN2humOf4mjfDN4HWcuyCHop4HhFEZmy0CH
         k6dn8v3MU/B739dTvM5uf1Be7yXwmDgCtbzrtjAvZvfEQkXpe6beYIAN8zbSVZRmtXgl
         jLOJPaLgO5uD5r69W8qJikpc+pr/hYrfPQPSh1GhKYXhGlKBDdFASC/8bWlmqc1Ulo30
         TLBcgS9Xerc9pTL0OmWxRXXdjMgWHTn+3k06SGfr3gyIFkQeq5Boy+ZHkDKajNRUt+25
         7mQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoo5WNTVlV0Wvc3Ly7Sr4yxxf0bgSrTmoZoynvhS/xTC7ujUY3V+Aoxc58SKKwPt0XZqU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNEiAsetMEBGyvV4VhwY94XmcVoZEvwA8B14crOH07aIZPWYAT
	qfuHUcsjh4T+EubyTA9SsJduNXMIw5b9Wp2dUaNpZkb2tlTFm317SJE9HL2oALbCJ1lo3vDmSWo
	IDyt24Q==
X-Received: from pjbcu12.prod.google.com ([2002:a17:90a:fa8c:b0:359:9633:e147])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:390a:b0:356:1edc:b6e
 with SMTP id 98e67ed59e1d1-359a69c1bcamr5203409a91.8.1772724120543; Thu, 05
 Mar 2026 07:22:00 -0800 (PST)
Date: Thu, 5 Mar 2026 07:21:53 -0800
In-Reply-To: <99463361-58F3-42F9-9BCC-4BF0BF73D247@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251026201911.505204-1-xin@zytor.com> <20251026201911.505204-8-xin@zytor.com>
 <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com> <aahchI7oiFrjFAmb@google.com>
 <99463361-58F3-42F9-9BCC-4BF0BF73D247@zytor.com>
Message-ID: <aamfka09bDZV0iUO@google.com>
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, pbonzini@redhat.com, 
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com, 
	hch@infradead.org, sohil.mehta@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4CE3B2147DA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72824-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, Xin Li wrote:
>=20
>=20
> > On Mar 4, 2026, at 8:23=E2=80=AFAM, Sean Christopherson <seanjc@google.=
com> wrote:
> >=20
> > On Wed, Jan 21, 2026, Binbin Wu wrote:
> >> On 10/27/2025 4:18 AM, Xin Li (Intel) wrote:
> >>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >>> index fcfa99160018..c8b5359123bf 100644
> >>> --- a/arch/x86/kvm/vmx/vmx.c
> >>> +++ b/arch/x86/kvm/vmx/vmx.c
> >>> @@ -1459,6 +1459,15 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu,=
 int cpu)
> >>>    (unsigned long)(cpu_entry_stack(cpu) + 1));
> >>> }
> >>>=20
> >>> + /* Per-CPU FRED MSRs */
> >=20
> > Meh, this is pretty self-explanatory code.
>=20
> I want to remind that this is =E2=80=9CPer-CPU=E2=80=9D.
>=20
> On the other side, FRED_CONFIG and FRED_STKLVLS are typically the same on
> all CPUs, and they don=E2=80=99t need to be updated during vCPU migration=
.
>=20
> But anyway vCPU migration only cares per-CPU MSRs, so this is redundant.
>=20
> It often bothers me whether to explain the code a bit more or not, with a
> short brief comment or a lengthy one.

Oh, I'm all for comments,  But I generally dislike terse comments like the =
above,
as they're only useful for readers that *already* know many of the gory det=
ails,
and for everyone else, it's largely just noise.

E.g. in this case, what the subtlety of what you were trying to convey with
"Per-CPU" was completely lost on me.  It would have been a wee bit more hel=
pful
in earlier versions that used RDMSR, but even then it required the reader t=
o make
large leaps of intuition to understand the full context.

And the terse comment is also "wrong" in the sense that it lies by omission=
,
because this isn't *all* of the per-CPU MSRs.

E.g.

	/*
	 * Update the FRED RSP MSRs values that are restored on VM-Exit, as
	 * Linux uses dedicated per-CPU stacks for things like #DBs and NMIs.
	 * Note, RSP0 is _only_ used to load RSP on user=3D>kernel transitions,
	 * i.e. doesn't need to be loaded on VM-Exit and so doesn't have a VMCS
	 * field.  Note #2, the SSP MSRs will likely be per-CPU as well, but
	 * Linux doesn't yet support supervisor shadow stacks.
	 */=20

> >>> + if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> >>> +#ifdef CONFIG_X86_64
> >>=20
> >> Nit:
> >>=20
> >> Is this needed?
> >>=20
> >> FRED is initialized by X86_64_F(), if CONFIG_X86_64 is not enabled, th=
is
> >> path is not reachable.
> >> There should be no compilation issue without #ifdef CONFIG_X86_64 / #e=
ndif.
> >>=20
> >> There are several similar patterns in this patch, using  #ifdef CONFIG=
_X86_64 /=20
> >> #endif or not seems not consistent. E.g. __vmx_vcpu_reset() and init_v=
mcs()
> >> doesn't check the config, but here does.
> >>=20
> >>> + vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB))=
;
> >>> + vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI)=
);
> >>> + vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF))=
;
> >=20
> > IMO, this is flawed for other reasons.  KVM shouldn't be relying on ker=
nel
> > implementation details with respect to what FRED stack handles what eve=
nt.
> >=20
> > The simplest approach would be to read the actual MSR.  _If_ using a pe=
r-CPU read
> > provides meaningful performance benefits over RDMSR (or RDMSR w/ immedi=
ate?  I
> > don't see an API for that...), then have the kernel provide a dedicated=
 accessor.
>=20
> I think you asked for it:
>=20
> https://lore.kernel.org/kvm/ZmoWB_XtA0wR2K4Q@google.com/

Gah, so I did.  FWIW, comments like that aren't intended to be "you must do=
 it
this way", i.e. it's ok to push back (if there's justification to do so), b=
ut I
can totally see how it came across that way.

> I assume fetching through per-CPU cache is fast, but I might have misunde=
rstood
> your suggestion.

Oh, per-CPU cache is likely faster than RDMSR (though it would be nice to v=
erify).
The part I specifically don't like is referencing DB, NMI, and DF stacks.

> > Then the accessor can be a non-inlined functions, and this code can be =
e.g.:
> >=20
> > if (IS_ENABLED(CONFIG_X86_64) && kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> > vmcs_write64(HOST_IA32_FRED_RSP1, fred_rsp(MSR_IA32_FRED_RSP1));
> > vmcs_write64(HOST_IA32_FRED_RSP2, fred_rsp(MSR_IA32_FRED_RSP2));
> > vmcs_write64(HOST_IA32_FRED_RSP3, fred_rsp(MSR_IA32_FRED_RSP2));
                                                                ^
                                                                |
                                                                3 (guess wh=
o failed at copy+paste)
> > }
> >=20
> > where fred_rsp() is _declared_ unconditionally, but implemented only fo=
r 64-bit.
> > That way the compiler will be happy, and the actual usage will be dropp=
ed before
> > linking via dead-code elimination.
>=20
> If KVM can=E2=80=99t rely on kernel side implementation details, fred_rsp=
() has to read
> directly from the corresponding MSRs, right?

No.  If the kernel provides an API specifically for getting RSP values, the=
n KVM
isn't rely on implementation details, KVM is relying on an (exported?) API,=
 and
it's the _kernel's_ responsibility to ensure that API is updated as needed.

Yeah, yeah, KVM is also part of the kernel, but it's a _lot_ easier to forg=
et to
update code when the implementation details change when some of the usage i=
s "far"
away.

> > Actually, we can probably do one better?
> >=20
> > if (cpu_feature_enabled(X86_FEATURE_FRED) && kvm_cpu_cap_has(X86_FEATUR=
E_FRED)) {
>=20
> I think KVM now forces X86_FEATURE_FRED=3Dy, no?

32-bit doesn't :-D

But even for 64-bit, X86_FEATURE_FRED should be cleared when FRED isn't sup=
ported
by hardware, in which case cpu_feature_enabled() still patches out the text=
.

