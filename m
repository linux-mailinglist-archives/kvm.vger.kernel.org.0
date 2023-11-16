Return-Path: <kvm+bounces-1891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A80667EE94A
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 23:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6286D2810D9
	for <lists+kvm@lfdr.de>; Thu, 16 Nov 2023 22:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CCD381CA;
	Thu, 16 Nov 2023 22:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WDBqCypK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158CED67
	for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 14:29:05 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5c5c760fc98so6967157b3.3
        for <kvm@vger.kernel.org>; Thu, 16 Nov 2023 14:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1700173744; x=1700778544; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EGIwhjjvgrhlrw+QQSLX3tkHhBU1bs3NPucIP+8y40A=;
        b=WDBqCypKRfmdqyIZbx4YX1B8VtiZ6pA6Hww0p0FklcH6xr/6IvVVKfHibct+QfoTPo
         hWkOGx0zD3MMwvLDaivC+dNoBgaK266d8xWj2j9Ey9IE05bSUx+G6KOh0eqyZdlDB8hJ
         +h4yE7R+sJjvIYHBLq52s9oVLMWbEGNMOObLaC7fqNk8l9yAoTfZicJGf7q3+Bbj7v1d
         Q0X9BR7h3XkncZ9A3RQcLumiYYfl+ahBstWmeSpFjn0Pul7vtA0NNjNJUM+XkNJ2gGKX
         wol4BoRq8m4nESwhkbB0xlI+YAimQKd1/WNsWFeACQJpPBDGeDmEP4VEfHQbjzxNTYY1
         ROcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700173744; x=1700778544;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EGIwhjjvgrhlrw+QQSLX3tkHhBU1bs3NPucIP+8y40A=;
        b=YewwTjcKm19woxyzCQvcVSdKah/J7Pmsvo/2C7XK9zjkMxGD+v1kfQby2Q7rD+gA50
         wpAuJL4O89O9U6sgsRkY8mcit2y3G2CtzE1DAa4yEux5p1Kvw2q/C/bCZmMSsySoUnUM
         QnYZkM4eyUqhsKLoSI5gdt6qIBo4zkJIVMpxcmu4pr/r5XHnEHwuRHRJe8TnaXSj5wY1
         zhL/ZfoIw1c6Zmd+8PDtV5Oy+xxfm4lOYxOl1HXyNHoJdKpnp0SRA7npSds4E4X4Vgtm
         9D2MdPEFDaji1iOfAJYoMOxS5eaOY5oyBLBYzOo04yX4CftABJA+1y5L05HzHORloNW/
         Hd7Q==
X-Gm-Message-State: AOJu0YyKPJVkI/GTnerTb6ieDgfQ6qcUmcKpcNfV21B/k//e2a9K9uRt
	WwA5aTDNaHpZ0OZBluIeBJxRZ/y9dK4=
X-Google-Smtp-Source: AGHT+IHmkM33E4jFA0/MUtJrzYod4Ks3z+LGFmRASfpJFYhl5YrBscD5jElQXrez+uXiBB14AafIAhwWLKc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:890a:0:b0:d9a:bce6:acf3 with SMTP id
 e10-20020a25890a000000b00d9abce6acf3mr520661ybl.0.1700173744305; Thu, 16 Nov
 2023 14:29:04 -0800 (PST)
Date: Thu, 16 Nov 2023 14:29:02 -0800
In-Reply-To: <c9f65fc1-ab55-4959-a8ec-390aee51ee3a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com> <20231110235528.1561679-4-seanjc@google.com>
 <c9f65fc1-ab55-4959-a8ec-390aee51ee3a@intel.com>
Message-ID: <ZVaXroTZQi1IcTvm@google.com>
Subject: Re: [PATCH 3/9] KVM: x86: Initialize guest cpu_caps based on guest CPUID
From: Sean Christopherson <seanjc@google.com>
To: Weijiang Yang <weijiang.yang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 16, 2023, Weijiang Yang wrote:
> On 11/11/2023 7:55 AM, Sean Christopherson wrote:
>=20
> [...]
>=20
> > -static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcp=
u *vcpu,
> > -							unsigned int x86_feature)
> > +static __always_inline void guest_cpu_cap_clear(struct kvm_vcpu *vcpu,
> > +						unsigned int x86_feature)
> >   {
> > -	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature=
))
> > +	unsigned int x86_leaf =3D __feature_leaf(x86_feature);
> > +
> > +	reverse_cpuid_check(x86_leaf);
> > +	vcpu->arch.cpu_caps[x86_leaf] &=3D ~__feature_bit(x86_feature);
> > +}
> > +
> > +static __always_inline void guest_cpu_cap_change(struct kvm_vcpu *vcpu=
,
> > +						 unsigned int x86_feature,
> > +						 bool guest_has_cap)
> > +{
> > +	if (guest_has_cap)
> >   		guest_cpu_cap_set(vcpu, x86_feature);
> > +	else
> > +		guest_cpu_cap_clear(vcpu, x86_feature);
> > +}
>=20
> I don't see any necessity to add 3 functions, i.e., guest_cpu_cap_{set, c=
lear, change}, for

I want to have equivalents to the cpuid_entry_*() APIs so that we don't end=
 up
with two different sets of names.  And the clear() API already has a second=
 user.

> guest_cpu_cap update. IMHO one function is enough, e.g,:

Hrm, I open coded the OR/AND logic in cpuid_entry_change() to try to force =
CMOV
instead of Jcc.  That honestly seems like a pointless optimization.  I woul=
d
rather use the helpers, which is less code.

> static __always_inline void guest_cpu_cap_update(struct kvm_vcpu *vcpu,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned=
 int x86_feature,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool gue=
st_has_cap)
> {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int x86_leaf =3D __fe=
ature_leaf(x86_feature);
>=20
> reverse_cpuid_check(x86_leaf);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (guest_has_cap)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 vcpu->arch.cpu_caps[x86_leaf] |=3D __feature_bit(x86_fea=
ture);
> else
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 vcpu->arch.cpu_caps[x86_leaf] &=3D ~__feature_bit(x86_fe=
ature);
> }
>=20
> > +
> > +static __always_inline void guest_cpu_cap_restrict(struct kvm_vcpu *vc=
pu,
> > +						   unsigned int x86_feature)
> > +{
> > +	if (!kvm_cpu_cap_has(x86_feature))
> > +		guest_cpu_cap_clear(vcpu, x86_feature);
> >   }
>=20
> _restrict is not clear to me for what the function actually does -- it
> conditionally clears guest cap depending on KVM support of the feature.
>=20
> How about renaming it to guest_cpu_cap_sync()?

"sync" isn't correct because it's not synchronizing with KVM's capabilitiy,=
 e.g.
the guest capability will remaing unset if the guest CPUID bit is clear but=
 the
KVM capability is available.

How about constrain()?

