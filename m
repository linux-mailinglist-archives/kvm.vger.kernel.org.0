Return-Path: <kvm+bounces-5832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFFD48272DD
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70F54B23219
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 15:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 388D951024;
	Mon,  8 Jan 2024 15:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JChXfDO8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7F651008
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ecfd153ccfso28020827b3.2
        for <kvm@vger.kernel.org>; Mon, 08 Jan 2024 07:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704727171; x=1705331971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/vUnHussWkKobHYshjCQd6FGRfJjcjxiSjZ4DXHkh5Q=;
        b=JChXfDO8UvacZV5iagdfeNC8W4YxtDWoOmSQN+THAXl+YUuEnSEsMdlERdJVYNdnV9
         d4zT2itdjN2KGQuqmZ787Chznwg9DZdUa/ZapybWGxO+QUCqA7Z2cEUdjjLVmhZKPf3q
         BhC7M7N6W2/DvK3Iwu+7Pv4sAcbbdBe4Z9sdUL9ujmEkVm4cBAKGQaoMgDqBgF1O1anI
         SSTKyEaLwWbI7Nk5g3WHLMKPLzHh8sbiwF8wHHfFq7p3J7HrPDBNfddle/lSrnbvKXLT
         PUJjoLjlFqj+74kTNtC6ps8zJfn4YaczBdFAUz6HQYyjZnMnp6TGsmkSY9qefrGc+05J
         zV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704727171; x=1705331971;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/vUnHussWkKobHYshjCQd6FGRfJjcjxiSjZ4DXHkh5Q=;
        b=MdiP/WuwsNlPAfdRhvSsVQMWsjntkelsWcwW+2tiPqJwdGMfvfLxIQRvpmwyAUVdo+
         Qog2BiJvsAMoiBE8cWTOac+1TaDlFOXBqWwsTP01/Uur90p4ROXfbN3UG3c2J33O7qcH
         S96CHe04lUFqn+8+MpG5IpiDKwAJp9/TolWFuP7h5v9AducF+YF+W3iJIKFuqHme4Uvd
         gUiglWKrKhEAoonbISgAr0ynBu2N4rLqvXKo2qrQtGsCGuVUSgdEudCgkAus4vWH3YTd
         hpBikzHUg/qWoOgzx/mlBZGqpOPR81tc/L7ylesAsdWWga7Rpf+6ZQyL0XDwKTK0vWZN
         No5Q==
X-Gm-Message-State: AOJu0Yy5udCCO1QnI7P9E0jktxKVyCWEIJO8+NsXLwcMWMK5HpzR4Kad
	2bjwcEvE/DX/6l9U3YUr5m+46t8IUYoEHj6epA==
X-Google-Smtp-Source: AGHT+IGJT12OrBht9j1e3tgW0/CzUqjmcX7e7Aup9/+mBHSOs02JR3gURUqa1IwfXsQYA1BszKP1MePTyt8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:848b:0:b0:dbd:f0c7:8926 with SMTP id
 v11-20020a25848b000000b00dbdf0c78926mr1557370ybk.7.1704727170958; Mon, 08 Jan
 2024 07:19:30 -0800 (PST)
Date: Mon, 8 Jan 2024 07:19:29 -0800
In-Reply-To: <ZZv9ISKuJs66ZCbz@linux.bj.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-3-tao1.su@linux.intel.com> <CALMp9eT=s7eifhmJZ4uQNTABQi+r9-JyjjUVt-Rj-B=y0+mbPA@mail.gmail.com>
 <ZZv9ISKuJs66ZCbz@linux.bj.intel.com>
Message-ID: <ZZwRKwG4k3DC3X3K@google.com>
Subject: Re: [PATCH 2/2] x86: KVM: Emulate instruction when GPA can't be
 translated by EPT
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	eddie.dong@intel.com, chao.gao@intel.com, xiaoyao.li@intel.com, 
	yuan.yao@linux.intel.com, yi1.lai@intel.com, xudong.hao@intel.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 08, 2024, Tao Su wrote:
> On Wed, Dec 20, 2023 at 05:42:56AM -0800, Jim Mattson wrote:
> > On Mon, Dec 18, 2023 at 6:08=E2=80=AFAM Tao Su <tao1.su@linux.intel.com=
> wrote:
> > >
> > > With 4-level EPT, bits 51:48 of the guest physical address must all
> > > be zero; otherwise, an EPT violation always occurs, which is an unexp=
ected
> > > VM exit in KVM currently.
> > >
> > > Even though KVM advertises the max physical bits to guest, guest may
> > > ignore MAXPHYADDR in CPUID and set a bigger physical bits to KVM.
> > > Rejecting invalid guest physical bits on KVM side is a choice, but it=
 will
> > > break current KVM ABI, e.g., current QEMU ignores the physical bits
> > > advertised by KVM and uses host physical bits as guest physical bits =
by
> > > default when using '-cpu host', although we would like to send a patc=
h to
> > > QEMU, it will still cause backward compatibility issues.
> > >
> > > For GPA that can't be translated by EPT but within host.MAXPHYADDR,
> > > emulation should be the best choice since KVM will inject #PF for the
> > > invalid GPA in guest's perspective and try to emulate the instruction=
s
> > > which minimizes the impact on guests as much as possible.
> > >
> > > Signed-off-by: Tao Su <tao1.su@linux.intel.com>
> > > Tested-by: Yi Lai <yi1.lai@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index be20a60047b1..a8aa2cfa2f5d 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -5774,6 +5774,13 @@ static int handle_ept_violation(struct kvm_vcp=
u *vcpu)
> > >
> > >         vcpu->arch.exit_qualification =3D exit_qualification;
> > >
> > > +       /*
> > > +        * Emulate the instruction when accessing a GPA which is set =
any bits
> > > +        * beyond guest-physical bits that EPT can translate.
> > > +        */
> > > +       if (unlikely(gpa & rsvd_bits(kvm_mmu_tdp_maxphyaddr(), 63)))
> > > +               return kvm_emulate_instruction(vcpu, 0);
> > > +
> >=20
> > This doesn't really work, since the KVM instruction emulator is
> > woefully incomplete. To make this work, first you have to teach the
> > KVM instruction emulator how to emulate *all* memory-accessing
> > instructions.
>=20
> Please forget allow_smaller_maxphyaddr and #PF for a while.
>=20
> I agree KVM instruction emulator is incomplete. However, hardware can=E2=
=80=99t
> execute instructions with GPA>48-bit and exits to KVM, KVM just repeatedl=
y
> builds SPTE, I.e., current KVM is buggy.

Eh, hardware is just as much to blame as KVM.  Garbage in, garbage out.

> In this case, emulation may be a choice,

Yes, it can be a choice, but that choice needs to be made conciously by use=
rspace,
not silently by KVM. =20

