Return-Path: <kvm+bounces-72713-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EL8JHXtuqGkkugAAu9opvQ
	(envelope-from <kvm+bounces-72713-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:40:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E39020547A
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 18:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 395443035267
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 17:39:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321CC3C6A3A;
	Wed,  4 Mar 2026 17:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WFcDNOY1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5802E37D125
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772645995; cv=none; b=mct8O2Zzqn/uAlE12ZbVMBy+HkqCBv9RN7KM5bMKLdv4os5coZal6tkoRXtOH7m3a7+XQI30qDst7VbVAl0P+ioSGld5icXCEQDlkaM+bzJb8f7xQRDKEjLkIEG4i+rDnREj5+6GMKeYgEMzdSRUjgH9Dioes9w7eZ+uWKf0SqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772645995; c=relaxed/simple;
	bh=HicJF9SU8FYF4bszknF2PfGmVRZgsJHkAtpALLSPT0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XnCepe/HlmbfmNu9FgF05lzI3xyvBaeFIUK7S9NWWtGrOu9/mCyEcQ9vnzgziKGePxlpbqYrYrZ1gLTOLp5Zqcj2jFRqvfXxM6NEMD1ArY6zMcyN+yAIbRbMAl5CWXD/alNYhm9ntNiWfOnodxr4iRTka/aRu6F88fEL3IJ07Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WFcDNOY1; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae66ee7354so14833925ad.0
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 09:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772645994; x=1773250794; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YCxR0sncGqt5cTtxeCDvL5ukAbWj6/g0krozrw9t2zU=;
        b=WFcDNOY13QIco85fEIQ3W8+9mCUaxU7IAr04i891qhYXvySuyeRkLH7mWUT183m0pt
         x79j0ddD/eMTleWfoTpxB2C72PlxypBSrHEz58Y2P5IAxcrB0fzHlaz4pyJOLFz+ELY7
         wwEKtXWoZfozKBuolPpFHktDcjowQFprIGLvtb8PYDc3PHTWbrAztBXsk/Vf1oAX9ywV
         HtJFJrenqXQ7sQ09Ub+z3X8CcsNDacHoSnwARPeMIXOU+lUnxZH4OuDtsRLA/2OzAgm3
         8ID8N7UGtURG1MgPYzNE16EJ5MvhxIotwzSLD9y6wt9/Ou8fSsCt866+eQqL97iFWPcz
         nN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772645994; x=1773250794;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YCxR0sncGqt5cTtxeCDvL5ukAbWj6/g0krozrw9t2zU=;
        b=utRo9Gsbm9+9tidHlotChTS7t1kh0J8TGBzZDIEr+uWMF6mIfv9F4KaM1B38RQogbW
         dzpg3nJMjOuUtrvsOSiemdeyQkyrL480/OPQWWJ6qFmbtztp1C+AqoUD/pJEgYyEcLU3
         05Bz0vJGCDqJ4W5heTzhRuhzTmxLWuvUBlCz4KRRtqSvjldLTHkhD3t/cXZgZmAUFLIH
         41Jzto6lUA3T7QRTifqOCGuFRrr8Dk7hl5MM8jTPatuPKK/vul65XZQbWBFF85vyVhDv
         nQzs7nok5h0Lu4FiphqOaTgb0jYIS9Tptc5XZHQSK9a/C2GMJz2D5pmhga4q3n4KlLtx
         CzdA==
X-Forwarded-Encrypted: i=1; AJvYcCUFCyfgsioqku/zgrkegnZJaxctRpmocOgHrw0czo1gpAvGdR+KU67T+wKr6FM8WwXRXOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1BiP693pqKTjDWRQkGRGXYQzhj26ZJEEM790XxeGBqEUl76lM
	1ueFcs/wnGzmdUqoIxebeUyJjLzeKjQ5G3UvwWkRlo3bYKQhY5E1vu3G1gr5jStIIGSaL917O03
	RZTS/WA==
X-Received: from plbkh3.prod.google.com ([2002:a17:903:643:b0:2ae:4d78:4c8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e886:b0:2ae:698d:94a6
 with SMTP id d9443c01a7336-2ae6aa054b2mr30306185ad.2.1772645993537; Wed, 04
 Mar 2026 09:39:53 -0800 (PST)
Date: Wed, 4 Mar 2026 09:39:51 -0800
In-Reply-To: <CAO9r8zN21twRarvzvq8euUOHRtVrO+q8jMaiip7NPtGgZ2dWGw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260225005950.3739782-1-yosry@kernel.org> <20260225005950.3739782-6-yosry@kernel.org>
 <CAO9r8zN21twRarvzvq8euUOHRtVrO+q8jMaiip7NPtGgZ2dWGw@mail.gmail.com>
Message-ID: <aahuZ4bg4aQKTZYj@google.com>
Subject: Re: [PATCH v3 5/8] KVM: nSVM: Always use NextRIP as vmcb02's NextRIP
 after first L2 VMRUN
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1E39020547A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72713-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, Yosry Ahmed wrote:
> On Tue, Feb 24, 2026 at 5:00=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > For guests with NRIPS disabled, L1 does not provide NextRIP when runnin=
g
> > an L2 with an injected soft interrupt, instead it advances the current =
RIP
> > before running it. KVM uses the current RIP as the NextRIP in vmcb02 to
> > emulate a CPU without NRIPS.
> >
> > However, after L2 runs the first time, NextRIP will be updated by the
> > CPU and/or KVM, and the current RIP is no longer the correct value to
> > use in vmcb02.  Hence, after save/restore, use the current RIP if and
> > only if a nested run is pending, otherwise use NextRIP.
> >
> > Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM=
_SET_NESTED_STATE")
> > CC: stable@vger.kernel.org
> > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > ---
> >  arch/x86/kvm/svm/nested.c | 25 ++++++++++++++++---------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 9909ff237e5ca..f3ed1bdbe76c9 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -845,17 +845,24 @@ static void nested_vmcb02_prepare_control(struct =
vcpu_svm *svm,
> >         vmcb02->control.event_inj_err       =3D svm->nested.ctl.event_i=
nj_err;
> >
> >         /*
> > -        * next_rip is consumed on VMRUN as the return address pushed o=
n the
> > +        * NextRIP is consumed on VMRUN as the return address pushed on=
 the
> >          * stack for injected soft exceptions/interrupts.  If nrips is =
exposed
> > -        * to L1, take it verbatim from vmcb12.  If nrips is supported =
in
> > -        * hardware but not exposed to L1, stuff the actual L2 RIP to e=
mulate
> > -        * what a nrips=3D0 CPU would do (L1 is responsible for advanci=
ng RIP
> > -        * prior to injecting the event).
> > +        * to L1, take it verbatim from vmcb12.
> > +        *
> > +        * If nrips is supported in hardware but not exposed to L1, stu=
ff the
> > +        * actual L2 RIP to emulate what a nrips=3D0 CPU would do (L1 i=
s
> > +        * responsible for advancing RIP prior to injecting the event).=
 This is
> > +        * only the case for the first L2 run after VMRUN. After that (=
e.g.
> > +        * during save/restore), NextRIP is updated by the CPU and/or K=
VM, and
> > +        * the value of the L2 RIP from vmcb12 should not be used.
> >          */
> > -       if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
> > -               vmcb02->control.next_rip    =3D svm->nested.ctl.next_ri=
p;
> > -       else if (boot_cpu_has(X86_FEATURE_NRIPS))
> > -               vmcb02->control.next_rip    =3D vmcb12_rip;
> > +       if (boot_cpu_has(X86_FEATURE_NRIPS)) {
> > +               if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
> > +                   !svm->nested.nested_run_pending)
> > +                       vmcb02->control.next_rip    =3D svm->nested.ctl=
.next_rip;
> > +               else
> > +                       vmcb02->control.next_rip    =3D vmcb12_rip;
> > +       }
>=20
> This should probably also apply to soft_int_next_rip below the context
> lines. Otherwise after  patch 7 we keep it uninitialized if the guest
> doesn't have NRIPs and !nested_run_pending.

That's fine though, isn't it?  Because in that case, doesn't the soft int h=
ave to
comein through svm_update_soft_interrupt_rip()?  Ugh, no because nSVM migra=
tes
control.event_inj.

IIUC, we want to end up with this?

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 03b201fe9613..d12647080051 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -925,7 +925,8 @@ static void nested_vmcb02_prepare_control(struct vcpu_s=
vm *svm)
         */
        if (is_evtinj_soft(vmcb02->control.event_inj)) {
                svm->soft_int_injected =3D true;
-               if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
+               if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS) ||
+                   !svm->nested.nested_run_pending)
                        svm->soft_int_next_rip =3D vmcb12_ctrl->next_rip;
        }

