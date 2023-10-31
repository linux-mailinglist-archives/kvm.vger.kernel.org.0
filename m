Return-Path: <kvm+bounces-254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 720B57DD8AD
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BFC52813E9
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 22:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E782744E;
	Tue, 31 Oct 2023 22:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WFQynxQp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743EA62F
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 22:58:52 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BB4107
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:58:50 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5afa86b8d66so55555107b3.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698793130; x=1699397930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RLwCVeVI5oZii5Igm5sOUutwRdu695KSX9ADahcPJtY=;
        b=WFQynxQp05hnL8XhFBi04tOgCx9RA7LAFkrakJ3PFi3/AwIjeva4YGFEgByIOpI78Z
         fbYay+aozrIbb2KAczvvO0cnIpEBpKoeC5k59g96KYyqwN26HsYtszjACaY0d1Van4Qn
         h4tZlSQ76UApybTIGQ05hXrTMut+/WD/mzigRu/irUDfQjoGnlCW22BYRB1EEsogDlmb
         4wcVIXwVSYoh4RKNqtkZOYcp+zqz1qJRyiMOgaxoNgRBCq0bKyUbpp30whDtdu1wZn5Z
         sSWZEfNNN1Nmck3cJ6DGgFepKuwfYNPlYrB7yhN++eQmOzFT5KaBcNVYUGAv9YwCh7JY
         w2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698793130; x=1699397930;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RLwCVeVI5oZii5Igm5sOUutwRdu695KSX9ADahcPJtY=;
        b=kAK4zIk4hSA2/IlclkLng9bJ3y3TQInvoml/m/j/oYEy3Lkezz6RcrUtHU/sBLGYlP
         KCYHyhLRV7klf6gagAXgQHtNprVtv5ap76YBGnQvflxjM780tt/22CtM7TSsBbrUPOC2
         VGHRQFEGZ2xVmjRdX+5zkEGXBbbs90F8u1+ADcEeulMR48vNDZLHS9BqE/EHtnp4jF1a
         4BRBZZ8utFNiv4KQ2qv5Qj2L1DkagetJUT5VJfQ2Ezh4KSfdQW9cF4U+mQ7OT2ch7rOQ
         0dfg0iUFTNrfEBL4n32vdf7Nc+weaKT9DvlWI3QQgjPVCDP/iXj8kAQoz4XwfiXWizPV
         xDqw==
X-Gm-Message-State: AOJu0Yzf4vfBxLxwr+0sTs/GTapjeT000GWprA8lFwbd66sI3MwgF4zK
	fzOS39CkWxIrCQWjGR+6njbbsym/W6Q=
X-Google-Smtp-Source: AGHT+IGY1W7FwMjtaRYDRWhynFOfQZS+XHB+5i2UhMrEl2n6QjMSYZJDwmzzrnHxUM5lbBdRFIG+tKXAowY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:df82:0:b0:57a:e0b:f63 with SMTP id
 i124-20020a0ddf82000000b0057a0e0b0f63mr291812ywe.7.1698793130060; Tue, 31 Oct
 2023 15:58:50 -0700 (PDT)
Date: Tue, 31 Oct 2023 22:58:48 +0000
In-Reply-To: <028f629d16377f9a7e9fd87ef9564846b0ab4ed9.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231031115748.622578-1-paul@xen.org> <ZUGCPQegUeTutsrb@google.com>
 <028f629d16377f9a7e9fd87ef9564846b0ab4ed9.camel@infradead.org>
Message-ID: <ZUGGqOCU7TAU6c6p@google.com>
Subject: Re: [PATCH v2] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023, David Woodhouse wrote:
> On Tue, 2023-10-31 at 15:39 -0700, Sean Christopherson wrote:
> > On Tue, Oct 31, 2023, Paul Durrant wrote:
> > Any reason not to make this a generic "capability" instead of a Xen spe=
cific flag?
> > E.g. I assume these problematic guests would mishandle PVCLOCK_TSC_STAB=
LE_BIT if
> > it showed up in kvmclock, but they don't use kvmclock so it's not a pro=
blem in
> > practice.
>=20
> No, those guests are just fine with kvmclock. It's the *Xen* page they
> forgot to map to userspace for the vDSO to use. And it's Xen (true Xen)
> which made you jump through hoops to use the TSC that way, such that it
> would actually expose the PVCLOCK_TSC_STABLE_BIT. We don't expect, and
> have never seen, such issues with native KVM guests.

Hmm, and I suppose theoretically the guest kernel could choose to ignore th=
e Xen
interface for whatever reason.  Mostly out of curiosity, is this flag somet=
hing
that'd be set anytime Xen is advertised to the guest?

> > I doubt there's a real need or use case, but it'd require less churn an=
d IMO is
> > simpler overall, e.g.
> >=20
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index e3eb608b6692..731b201bfd5a 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3225,7 +3225,7 @@ static int kvm_guest_time_update(struct kvm_vcpu =
*v)
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* If the host uses TSC cloc=
ksource, then it is stable */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pvclock_flags =3D 0;
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (use_master_clock)
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (use_master_clock && !vcpu->kv=
m.force_tsc_unstable)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 pvclock_flags |=3D PVCLOCK_TSC_STABLE_BIT;
> > =C2=A0
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vcpu->hv_clock.flags =3D pvc=
lock_flags;
> >=20
> > I also assume this is a "set and forget" thing?=C2=A0 I.e. KVM can requ=
ire the flag
> > to be set before any vCPUs are created.
>=20
> Hrm, not sure we have previously required that the KVM_XEN_HVM_CONFIG
> setup be done before any vCPUs were created.

Oh, I was asking in the context of adding a generic capability.

> I tend to prefer *not* to push ordering requirements onto userspace.

For per-VM flags that are consumed by vCPUs, it makes reasoning about corre=
ctness
and what is/isn't allowed much, much easier.

> Does it need to be a per-vcpu thing?=20

Huh?  No, I was only asking (again, for a generic capability) if we could d=
o

		mutex_lock(&kvm->lock);
		if (!kvm->created_vcpus) {
			kvm->arch.force_tsc_unstable =3D true;
			r =3D 0;
		}
		mutex_unlock(&kvm->lock);

So that it would be blatantly obvious that there's no race with checking a =
per-VM
flag without any lock/RCU protections.

