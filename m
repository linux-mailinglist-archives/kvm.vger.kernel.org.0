Return-Path: <kvm+bounces-71076-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mMZ8H1a0j2l8SwEAu9opvQ
	(envelope-from <kvm+bounces-71076-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:31:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9238139FF4
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 00:31:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 30B4C301DC05
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 23:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39F7233CE9D;
	Fri, 13 Feb 2026 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lMnucXBH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A34426A1C4
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771025490; cv=pass; b=Ylj4UhN2qDBUy8WSIkTl4NKgLdv39ZgoExoi3/WvGvrM5PjNiu4wNOctH13xqmqk0RsRgDJcraV/rMnjh1IpRHPzOTaoGVNXMgtNdwdvXBBxGqC/rfsyKzrhUxtLGpIfZkZrLtbyT/ev1jSFlC9frMmg3VTe8msPCYqBsNKK0Bo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771025490; c=relaxed/simple;
	bh=j7413bRwBOf97LMXeMJ+51aV4XcmAmSqRqIQ7niCkkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SllbsFB+BTJmAxj+UkboPL6Gqp+nyiT6EvEkTvYhDAoFnnlCspOjyv8HXb/4NHuZ0PBJ+VBoECf6vjYTxT0jE3dsRGAofzn305QsEQrPx3Cl6aCtTCABdzopH/IZ5082yj9ybp1ZbRHaaELJB0mBi8IKsIo59PUweeFb/jTcJt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lMnucXBH; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65821afe680so1430a12.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:31:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771025488; cv=none;
        d=google.com; s=arc-20240605;
        b=R+tL80FvYCfHxOjn1rO9J4iE4KxUTEqG0l437SNKI29aJFGY7lMOdY2ZIdir7phPJh
         BF5K50jVCx70wCKWkLaivUl/7V4KsgaAopzbgaynKoI3jq9oNORFTZyBBm2crtlquIBi
         CDyfJ0TyOlXpGVgGYt58KngT/5Zgkn5guU31phlTD47IAGEZN3RnVyEcJnPlkSfu6wy4
         hqBXY075GDm0Q7dgTq1N/9jUx1tdfKtPDjr0n0jtU10plvH9/KoYTZDYKDS9hRqhqcR5
         mxIYwWrMlHVYzi9vitgKloSGCoWKlG1KxtPyOJlNFK4axOrk8ax0MkAJpwtSYApmj9gc
         dzvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7st+ny0+WsScz+aFPKKNW8ny3dY5RaMJM5tFlYQQMR8=;
        fh=FBnF/EoQI9BFDqdjAbHR5unCi1Nb/+AZAoOFwcly/4Y=;
        b=P9cS8i0bLVuripUtyWsZha5b+QqxAHHfIN/Bs9K+MgFjQpnhh3pf9Xyaqm70qwKJIL
         Qv8PnBriPF6LCLy7F3C5CcDmZgOXoBJTy+Lc3HyeLg0Vo6bUdQzOzt9e1iqCAYOHH5zE
         yqt7RPesOfGHe+PWZptRR5+DzB23buFHlea2xffpYzklsERXb17v8PgVvVDtX21tnjFf
         O11rZS7cHtMnqw2QBQRE8C3pBjx+Aars4qd8oiGjXde9+GhOiRb5xfmUkr07jZDHf1cO
         Gu4hfQuMuZnDNsSGf3hSX9XTrTg5rflUpXpV8Zls2Do6pPjZd/4fNy5O6YNcqGFVpdO7
         HCEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771025488; x=1771630288; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7st+ny0+WsScz+aFPKKNW8ny3dY5RaMJM5tFlYQQMR8=;
        b=lMnucXBHR6KHDUrlZ4KXcm8p45k6mWpK4hmG1CyCFEKIYpn0js5M9gYLWAnuDrC/K4
         dUuVgM0HOBJ1RQK+gk5WSunauz3d3xyms/y1xPKnpA7MPM2o6iIS/QvZdeO5dSeHO+YZ
         CcsP08ilIQ5dv5UqC82tmrZC+Y4SsZJjewA9kIZAWJ19LqQLmPYQXxolWUgfGrt1dFEg
         kkrVUJlvJdnAbuOYT/5hv7TA8rv2kake4sHfPiBjKW/Dkso3LaY2tCmDpZjeJCk/PLuA
         rVnNbpCg8ZA2pq9ZnstVD3GcwnA+I2tYEkB2b2AZMTX7VG5zFP6044/mD/AhBqW99JjA
         62Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771025488; x=1771630288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7st+ny0+WsScz+aFPKKNW8ny3dY5RaMJM5tFlYQQMR8=;
        b=wm0Hed/8O1i5J79QIZqFbQrPiSjM38R4kJhtLuod2Vov5WPgZ1x19UpdJTXNaQbng9
         zbZYWFjmnVGPaCdnON4uFZWWQijieGuM4t2FzPOovTOiB3GwWWr5a9HYDfS2IZkj5fin
         P7y7hiT0R5obLZ1/NNiK3tT0M9DNHNMDCFummVMqypTrT/hWkyN5CuriOOe1UARsPegA
         WdJNfqBjdndH+odcGcp6y1Th/ItnvkzxICpOIhHenMWGnsDc1nopFepYvmxnUceI+TnI
         LT1xba+Zp2TvUDmMLpmqjZaXZZTInfYGXiwdd2Kb4Uu8rRESV2sqqB+6tMkaTZIIQPSa
         FT9g==
X-Forwarded-Encrypted: i=1; AJvYcCU6NuDaxlhnYsO9tQFLeWWbKK2WdktcWr9d3A0kRDJ0ykwkUxDnFyqz10S2oI88rJxOiTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFp8ol2IBW7aXD1sSUGX0XMSgDB9mP/hwnBdp5dwbCWzsfQr+v
	4YMun+cDUNd/7J684j9jul2od0DQ/YIBn5gtbQFnhrvd7K8V0BYe6TVmVZrQXh133CULx74kucZ
	lK6MQl6hoEYbgEMzpRZmZNqXIhb/+nNVRqQXKZaW8
X-Gm-Gg: AZuq6aI3ZUjnvdLugfJO0kPl3DOfZjxdfWS8Sr/3mM9mICZp4D7CdgR3osMueJNd28F
	wm5eMYOo3QId4kndaZokXXeAP3VK9eb74AU4tttnfdJG2olKY4pHs6GQVfREtZ3CvZsm6QbcHZT
	rXFWOg+zTcDPxMdIuX9f2TANBRBPh1yGuFqVmflpi2EG0ji41NnV8OZDLYrVFnJXDzimaa2ScgC
	AzjCcIF7xOEE3x0SLxJjb8qSySKnDFfpURmD+A7cQJUP8qFUXYdlBvXGUdj6WhJfA3MRwzF84TO
	GCptx6zY1z/Gh05G/A==
X-Received: by 2002:aa7:ce09:0:b0:659:477f:1b2e with SMTP id
 4fb4d7f45d1cf-65bcd818f8fmr2838a12.1.1771025487143; Fri, 13 Feb 2026 15:31:27
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-5-jmattson@google.com>
 <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw>
 <aY9BPKhzgxo4UuHB@google.com> <CALMp9eR4ayj_gwsDQVH8pQvzqgEYVB6ExWp3aFgJXRWikLEikw@mail.gmail.com>
 <aY-jViitsLQm9B83@google.com>
In-Reply-To: <aY-jViitsLQm9B83@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Feb 2026 15:31:15 -0800
X-Gm-Features: AZwV_QiHyVOxh9r0ypnXYUO82O-EfzXPfCouEz0SjFgSJMf4FMafJkFC8Oc2I48
Message-ID: <CALMp9eTnXW9=0=+RxQjeXfA++UP3MX0LzXo5qwUP-dCCQjOLVQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71076-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: E9238139FF4
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 2:19=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Feb 13, 2026, Jim Mattson wrote:
> > On Fri, Feb 13, 2026 at 7:20=E2=80=AFAM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > > > +static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
> > > > > +{
> > > > > +   svm->vcpu.arch.pat =3D data;
> > > > > +   if (npt_enabled) {
> > >
> > > Peeking at the future patches, if we make this:
> > >
> > >         if (!npt_enabled)
> > >                 return;
> > >
> > > then we can end up with this:
> > >
> > >         if (npt_enabled)
> > >                 return;
> > >
> > >         vmcb_set_gpat(svm->vmcb01.ptr, data);
> > >         if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
> > >                 vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> > >
> > >         if (svm->nested.legacy_gpat_semantics)
> > >                 svm_set_l2_pat(svm, data);
> > >
> > > Because legacy_gpat_semantics can only be true if npt_enabled is true=
.  Without
> > > that guard, KVM _looks_ buggy because it's setting gpat in the VMCB e=
ven when
> > > it shouldn't exist.
> > >
> > > Actually, calling svm_set_l2_pat() when !is_guest_mode() is wrong too=
, no?  E.g.
> > > shouldn't we end up with this?
> >
> > Sigh. legacy_gpat_semantics is supposed to be set only when
> > is_guest_mode() and nested_npt_enabled(). I forgot about back-to-back
> > invocations of KVM_SET_NESTED_STATE. Are there other ways of leaving
> > guest mode or disabling nested NPT before the next KVM_RUN?
>
> KVM_SET_VCPU_EVENTS will do it if userspace forces a change in SMM state:
>
>                 if (!!(vcpu->arch.hflags & HF_SMM_MASK) !=3D events->smi.=
smm) {
>                         kvm_leave_nested(vcpu);
>                         kvm_smm_changed(vcpu, events->smi.smm);
>                 }
>
> I honestly wasn't even thinking of anything in particular, it just looked=
 weird.

At the very least, then, kvm_leave_nested() has to clear
legacy_gpat_semantics. I will look for other paths.

> > > > > +           vmcb_set_gpat(svm->vmcb01.ptr, data);
> > > > > +           if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(=
svm))
> > > > > +                   vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> > > > > +   }
> > > > > +}
> > > >
> > > > Is it me, or is it a bit confusing that svm_set_gpat() sets L2's gP=
AT
> > > > not L1's, and svm_set_hpat() calls vmcb_set_gpat()?
> > >
> > > It's not just you.  I don't find it confusing per se, more that it's =
really
> > > subtle.
> > >
> > > > "gpat" means different things in the context of the VMCB or otherwi=
se,
> > > > which kinda makes sense but is also not super clear. Maybe
> > > > svm_set_l1_gpat() and svm_set_l2_gpat() is more clear?
> > >
> > > I think just svm_set_l1_pat() and svm_set_l2_pat(), because gpat stra=
ight up
> > > doesn't exist when NPT is disabled/unsupported.
> >
> > My intention was that "gpat" and "hpat" were from the perspective of th=
e vCPU.
> >
> > I dislike svm_set_l1_pat() and svm_set_l2_pat(). As you point out
> > above, there is no independent L2 PAT when nested NPT is disabled. I
> > think that's less obvious than the fact that there is no gPAT from the
> > vCPU's perspective. My preference is to follow the APM terminology
> > when possible. Making up our own terms just leads to confusion.
>
> How about svm_set_pat() and svm_get_gpat()?  Because hPAT doesn't exist w=
hen NPT
> is unsupported/disabled, but KVM still needs to set the vCPU's emulated P=
AT value.

What if we don't break it up this way at all? Instead of distributing
the logic between svm_[gs]set_msr() and a few helper functions, we
could just have svm_[gs]et_msr() call svm_[gs]et_pat(), and all of the
logic can go in these two functions.

