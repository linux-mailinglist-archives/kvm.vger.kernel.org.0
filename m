Return-Path: <kvm+bounces-73098-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECuMLt4Cq2nDZQEAu9opvQ
	(envelope-from <kvm+bounces-73098-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:37:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AF8C225389
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 359983034099
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 16:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5422B2472AA;
	Fri,  6 Mar 2026 16:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3FquQ64"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E03ACF0C
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772815059; cv=none; b=QcMghwm4XX92oXYk8y4aIsKQj1WDvjs3fC0l6IrpSAVJ7VWKI5Vxqdv1XDo3awm0/v/jIgpj9ymFLhpK3L0JHaleCZ1RbPnMKUpPqEnfDhObpGOiH6Om455xJ4i0etE/JZNP9egofjd8kQWyLODJ5VdkgDrL16igSr1eUAgg0jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772815059; c=relaxed/simple;
	bh=JUjEN0DYWM8Ioj0l3YYXoGiZDzEyXypebkZ9t9Bv0QQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WPsTsoPhvCPLLPdPjJEGCmr2uYh04QdCaouHyxDqaOG4jUCb7DFbX682STgQ6wR1JqbA7IbryyOBmR7et9x55Vw0ptI0/jeDWJQG+ZQfCHAUduhY5zb2R5iOmzN+sDBCsuB/q48oIKmTLV/2LJ9TkkwjKgNNiGAjiVcYmaZN8PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3FquQ64; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542A4C2BC9E
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772815059;
	bh=JUjEN0DYWM8Ioj0l3YYXoGiZDzEyXypebkZ9t9Bv0QQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=S3FquQ64E9O/Eo+2QBgah1c5/v8SLmlmrtJSbUUTm0+9PjPJAH0rnHegwvwRK1xvn
	 xOjBy/CrjTVczgF+SmQWWxtIUmrgaRlVc69P8eCd25zfmULVl5x0V5IMKSl/2zi6Dd
	 W9NWP6vP8cVxmkpdgAm6Ff7eQeHep9IA5eNh4rlSo/J5GHbt8Or41MLGsl+sRJT7gC
	 kYeJW43SNqMxG0UQ63fTDgtnJbMxPiwS406CdUPkQsGN5d56lQF/YoEzXpc6PE+fJJ
	 7YbVG5ZnaD2EgcSREu4McN7PswPFsYSBYrFCNQXPJaHhpEFK10CDT8FsFoxRsSKdks
	 OkDYwXgPUip1w==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b94358796a1so87561766b.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 08:37:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVRlCzCP408f1zA4f3O5nLe5aNS5EHQV344DSDdJ73INwEfRkp46ksWnCL44+Yr5oHTw8M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0Z0cA2WFQfxEDHpmyVEcijWmMS20ubeGApYeaK1o75cT2TAeA
	XPfnZHM59Ea3dyyA+aMF00p/Onrs0xtwC8H3hoG4ub0Zpxy3992qX5qbJ3HRkutyChEFI6Vbluk
	0ES2z8iIVH0N/VhWJEAUvo6pXdqu5vQY=
X-Received: by 2002:a17:907:948c:b0:b94:c55:81b3 with SMTP id
 a640c23a62f3a-b942df8f0d8mr176205266b.24.1772815057971; Fri, 06 Mar 2026
 08:37:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306002327.1225504-1-yosry@kernel.org> <aar-gDulqlXtVDhR@google.com>
In-Reply-To: <aar-gDulqlXtVDhR@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 6 Mar 2026 08:37:25 -0800
X-Gmail-Original-Message-ID: <CAO9r8zNb8Kvq=6e=pbCe6-T1wT5RcHRerDUAPq4yMvrMjRN8dw@mail.gmail.com>
X-Gm-Features: AaiRm50jpMs1YdRWG5Kvjkq2VOJRlD3EO-tONpUPVXNZxK5iSEa9J_HD5Ou2mKQ
Message-ID: <CAO9r8zNb8Kvq=6e=pbCe6-T1wT5RcHRerDUAPq4yMvrMjRN8dw@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: Propagate Translation Cache Extensions to the guest
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Venkatesh Srinivas <venkateshs@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5AF8C225389
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73098-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.946];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid,chromium.org:email]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 8:19=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Mar 06, 2026, Yosry Ahmed wrote:
> > From: Venkatesh Srinivas <venkateshs@chromium.org>
> >
> > TCE augments the behavior of TLB invalidating instructions (INVLPG,
> > INVLPGB, and INVPCID) to only invalidate translations for relevant
> > intermediate mappings to the address range, rather than ALL intermdiate
> > translations.
> >
> > The Linux kernel has been setting EFER.TCE if supported by the CPU sinc=
e
> > commit 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")=
,
> > as it may improve performance.
> >
> > KVM does not need to do anything to virtualize the feature,
>
> Please back this up with actual analysis.

Something like this?

If a TLB invalidating instruction is not intercepted, it will behave
according to the guest's setting of EFER.TCE as the value will be
loaded on VM-Enter. Otherwise, KVM's emulation may invalidate more TLB
entries, which is perfectly fine as the CPU is allowed to invalidate
more TLB entries that it strictly needs to.

>
> > only advertise it and allow setting EFER.TCE.  Passthrough X86_FEATURE_=
TCE to
>
> Advertise X86_FEATURE_TCE to userspace, not "passthrough xxx to the guest=
".
> Because that's all KVM
>
> > the guest, and allow the guest to set EFER.TCE if available.
> >
> > Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
>
> Your SoB should come last to capture that the chain of hanlding, i.e. thi=
s should
> be:

Ack.

>
>   Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
>   Co-developed-by: Yosry Ahmed <yosry@kernel.org>
>   Signed-off-by: Yosry Ahmed <yosry@kernel.org>
>
[..]
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 3407deac90bd6..fee1c8cd45973 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5580,6 +5580,9 @@ static __init int svm_hardware_setup(void)
> >       if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
> >               kvm_enable_efer_bits(EFER_AUTOIBRS);
> >
> > +     if (boot_cpu_has(X86_FEATURE_TCE))
> > +             kvm_enable_efer_bits(EFER_TCE);
>
> Hrm, I think we should handle all of the kvm_enable_efer_bits() calls tha=
t are
> conditioned only on CPU support in common code.  While it's highly unlike=
ly Intel
> CPUs will ever support more EFER-based features, if they do, then KVM wil=
l
> over-report support since kvm_initialize_cpu_caps() will effectively enab=
le the
> feature, but VMX won't enable the corresponding EFER bit.
>
> I can't think anything that will go sideways if we rely purely on KVM cap=
s, so
> get to something like this as prep work, and then land TCE in common x86?

Will do.

