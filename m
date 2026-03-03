Return-Path: <kvm+bounces-72611-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2OrNAC5Xp2lsgwAAu9opvQ
	(envelope-from <kvm+bounces-72611-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:48:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 637CC1F7BC5
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:48:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 34A5830062FF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C313976A4;
	Tue,  3 Mar 2026 21:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SUTCW7qY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED41031F9B8
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 21:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772574505; cv=pass; b=rdJ3cKAUvkD7W9Co178Fge+peA06xSLCnPy0WIasDWz6ygpxRzUAN2fUsKQIBaj3Ut0Yt5uo8jdayy1qkG2KWFMV7JIKr5s6YKs05sArjDqORZV06bUxLAOBA4Rxe9EvwZQib2yt/lvC4Xu5d4QxXY6WYSlTbAP3HA1HZxnsQ3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772574505; c=relaxed/simple;
	bh=fubfkXGjIm1+PwdumDav7qNBAVV/Ntvo/7YShhJGJMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BPh7/R/mj6JUbzSSkMNwmE8Nw8ng9iexNeqX0N2d6CHeHbTVm3/SOH3QHdGofVqHkYoa/ZgiUhhjZvmgmcpGjInqRRaLiVLq3Y3q1qZvo4HdCXCiAORX1nbhyESLWxwtVIQRK5IvyWT0If43mzBj4OJK1egijmWrLOWWlmy1vK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SUTCW7qY; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899e85736e2so33958026d6.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 13:48:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772574502; cv=none;
        d=google.com; s=arc-20240605;
        b=UPpfakk8w+qwor5YUwY8wxIOGFRuKgMZYms8lVibbdRaO+FvfsyP9YyUrQ3DvR0UY9
         2zQ55LlYoa56PmQYyRy5XlgPngChvaIQWFARbz2x9bhxGmSN3LG6keJU8N1fmvbQv1Q8
         DTd3kmFuwHvl7WgmYV1D0vGiH7s0nvJWEbcu+xLOkD6j05ep4/Fw/BoZmZadmihXqtl6
         t0slU3QfvQI5OCxd8+RDUSZi+SLoFmbX2VnOp8cuW9BUyJuaDLuBjyfv6RYovQqSZjnR
         mByszXjX33w+wcmvIbqfko2TlR3mPRpv8Z6sDBM/VMiR5Vtpzybm82CnTzQMaCznQU2O
         dPJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f/lhq4j93MtO7K9QtzwSetXdDKCNDHz56PhnQ4j5c2U=;
        fh=fsFUtL3KZaf6nyDaNTmVDMwYz+GpWyHQicetfdHLlPs=;
        b=YQ5wCO0Bhkhgkc0mikQEV0JD81cdhd8A5n9GsqE/OyhqxOV7XgSdd+o5f+osAHqG3T
         KCKJAZD7d4aTD9xC6hLjRv1sDOUX8Kh+uSiukmC+RlGlC7pxJ9VwdYlMRrsmLuZzxHrU
         xEokifgURt57cQKt/J8Mravw4WrMCHxo7nRv9rbH61shauhITWBsMMHWlXzKikxT5oiY
         +vgLPaXvlSFny5Kams4zaR5mUegriJJylPYI/64ICPfYzdoiI0dXWm5h1fPwWY0g3FNY
         Gml9+RrF9avKrSkpP/lhdQgLXFCfyWcwhZLhwQElbJfDe+pwWNjsSStpUsj8PIoRD4AI
         N1sg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772574502; x=1773179302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/lhq4j93MtO7K9QtzwSetXdDKCNDHz56PhnQ4j5c2U=;
        b=SUTCW7qY53h/1OwjVeIgKf7ax65ABshZY+0tywD0GjtCjQGKlC4s9cul5nuPc9vyEs
         Eh7AjXfZjc5lnClTO9Mmlq2SD/34Nb1MhUgmLT/FqBT3G6guPK/LsHwi/Mt8ozpdxudV
         8FsROqZ3y6iKbqW1lQG8TYQT/k16hW5I1JUCTwO/CTNkhi/UVtIX6eZCHTczpI1wlc08
         wdvokJ7fXf/5jWPddk6EP+Z2alfKLwWnznYqhaySNLl1JBlDhX10sRWsTAv1vDNjbRK8
         OypvPFDr8O9hhHn5Lb0Zva84c6nj8+C/sdiVyqdbEUJSylmYerEoMTcZiS+VwUZRJerc
         uJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772574502; x=1773179302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f/lhq4j93MtO7K9QtzwSetXdDKCNDHz56PhnQ4j5c2U=;
        b=UsC/FrHb7zfe/BTs7tkkd4LmzaxLJQI6sKPCAUHKuE5JuBClvwuf/HK2okURD5etjP
         jKk6zbeOuipBziCLnyxPbXBY2C2vI09k6bHPo18Jj59vQ0oRDCMb4kTEFinehwdl00Kh
         Xh7+FADB2IbxAOjjt02e648S2xR8baFS11YVJmoXruLlL+FGj39dIetPlV+8RcaXt2wq
         F/j8OixmA66YWkpJf9BOr6QXSwXZFy9a9nOBwY6zKg5z3OaBfgah8igJ86zdEMZXInmz
         kdmKMD01WTR93eCpDe3LVlLa88kZ3MLQVEHsHxYgc1eUhy3fI+YvLfvF2GSr1gYiPzL+
         y17A==
X-Forwarded-Encrypted: i=1; AJvYcCWDnit6JDYK08i469ZwFEu3PXR79fLzSnn60uCFhYWvzU38bAp12wWlbcmeEYj1pVmyyio=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF6wKuxVe/2HQ0I+F6UH+6axZ25xrEVk2rLkSNMaXy3cSG+woF
	cmFL8Y4zb4kOssey0gBE32JLNeyMhQnWtLGsjs304lqvJSufHwxOZwQZSUnBHyHieneYI1lvkYr
	mATRz3VIdrtdPBYFeOJu8qZ4x0+mM50IJwUr1gZz0
X-Gm-Gg: ATEYQzxIW/1mR9G6x01NjT6400Jh+W4yDxin34tOg4hKje7hLlgapjWRgbjpGHMMz1W
	pVARX+qGKGCeLlXASYS120b5lu+6Kkf5T3HHOLV79wQzQfBmExWviqRBNNrD04tIIP4+iEI5wMC
	yyuxzKJEqF2VmUmFsYM+3O/KtG1qvcVYooD9iVinERssUazeBkD9HKUjgP8bGqhwy8aysNH1QEF
	oPszleQ9Om0mAp1xwCwveBRpFOhNAHwMinxjOlomOPPDDT0DEAXba5rKvkLa4vLp2EuCUUKuSZp
	SWXx22p7INqBH9Kbha1YGuOCgXhjQTwt0le4gfMfHZS1hlXwQDOI
X-Received: by 2002:a05:6214:27e2:b0:89a:78e:50ac with SMTP id
 6a1803df08f44-89a0a8907f4mr53892166d6.15.1772574501324; Tue, 03 Mar 2026
 13:48:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
In-Reply-To: <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
From: Kevin Cheng <chengkev@google.com>
Date: Tue, 3 Mar 2026 16:48:10 -0500
X-Gm-Features: AaiRm508xKZ9PlfYVni-fNYSNBkP_cBcL1bybbuo8kniTG_06ZIAzsHWIdGWmcE
Message-ID: <CAE6NW_Zj0SY8OtZ2_AszJ2DXn0Vv7b6eRyn0FDPKFZZR7uOiXA@mail.gmail.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
To: Yosry Ahmed <yosry@kernel.org>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 637CC1F7BC5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72611-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 2, 2026 at 11:21=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Feb 27, 2026 at 7:33=E2=80=AFPM Kevin Cheng <chengkev@google.com>=
 wrote:
> >
> > The APM lists the following behaviors
> >   - The VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and INVLPGA instructions
> >     can be used when the EFER.SVME is set to 1; otherwise, these
> >     instructions generate a #UD exception.
> >   - If VMMCALL instruction is not intercepted, the instruction raises a
> >     #UD exception.
> >
> > The patches in this series fix current SVM bugs that do not adhere to
> > the APM listed behaviors.
> >
> > v3 -> v4:
> >   - Dropped "KVM: SVM: Inject #UD for STGI if EFER.SVME=3D0 and SVM Loc=
k
> >     and DEV are not available" as per Sean
> >   - Added back STGI and CLGI intercept clearing in init_vmcb to maintai=
n
> >     previous behavior on intel guests. Previously intel guests always
> >     had STGI and CLGI intercepts cleared if vgif was enabled. In V3,
> >     because the clearing of the intercepts was moved from init_vmcb() t=
o
> >     the !guest_cpuid_is_intel_compatible() case in
> >     svm_recalc_instruction_intercepts(), the CLGI intercept would be
> >     indefinitely set on intel guests. I added back the clearing to
> >     init_vmcb() to retain intel guest behavior before this patch.
>
> I am a bit confused by this. v4 kept initializing the intercepts as
> cleared for all guests, but we still set the CLGI/STGI intercepts for
> Intel-compatible guests in svm_recalc_instruction_intercepts() patch
> 3. So what difference did this make?
>

Yes I was mistaken in that comment. Please ignore that comment as it
is incorrect.

> Also taking a step back, I am not really sure what's the right thing
> to do for Intel-compatible guests here. It also seems like even if we
> set the intercept, svm_set_gif() will clear the STGI intercept, even
> on Intel-compatible guests.
>
> Maybe we should leave that can of worms alone, go back to removing
> initializing the CLGI/STGI intercepts in init_vmcb(), and in
> svm_recalc_instruction_intercepts() set/clear these intercepts based
> on EFER.SVME alone, irrespective of Intel-compatibility?
>
>
>
> >   - In "Raise #UD if VMMCALL instruction is not intercepted" patch:
> >       - Exempt Hyper-V L2 TLB flush hypercalls from the #UD injection,
> >         as L0 intentionally intercepts these VMMCALLs on behalf of L1
> >         via the direct hypercall enlightenment.
> >       - Added nested_svm_is_l2_tlb_flush_hcall() which just returns tru=
e
> >         if the hypercall was a Hyper-V L2 TLB flush hypercall.
> >
> > v3: https://lore.kernel.org/kvm/20260122045755.205203-1-chengkev@google=
.com/
> >
> > v2 -> v3:
> >   - Elaborated on 'Move STGI and CLGI intercept handling' commit messag=
e
> >     as per Sean
> >   - Fixed bug due to interaction with svm_enable_nmi_window() and 'Move
> >     STGI and CLGI intercept handling' as pointed out by Yosry. Code
> >     changes suggested by Sean/Yosry.
> >   - Removed open-coded nested_svm_check_permissions() in STGI
> >     interception function as per Yosry
> >
> > v2: https://lore.kernel.org/all/20260112174535.3132800-1-chengkev@googl=
e.com/
> >
> > v1 -> v2:
> >   - Split up the series into smaller more logical changes as suggested
> >     by Sean
> >   - Added patch for injecting #UD for STGI under APM defined conditions
> >     as suggested by Sean
> >   - Combined EFER.SVME=3D0 conditional with intel CPU logic in
> >     svm_recalc_instruction_intercepts
> >
> > Kevin Cheng (4):
> >   KVM: SVM: Move STGI and CLGI intercept handling
> >   KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=3D0
> >   KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled
> >   KVM: SVM: Raise #UD if VMMCALL instruction is not intercepted
> >
> >  arch/x86/kvm/svm/hyperv.h | 11 ++++++++
> >  arch/x86/kvm/svm/nested.c |  4 +--
> >  arch/x86/kvm/svm/svm.c    | 59 +++++++++++++++++++++++++++++++++++----
> >  3 files changed, 65 insertions(+), 9 deletions(-)
> >
> > --
> > 2.53.0.473.g4a7958ca14-goog
> >

