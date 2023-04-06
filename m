Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FFD6DA0BE
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 21:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240448AbjDFTMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 15:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbjDFTMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 15:12:10 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDB883FF
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 12:12:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536a4eba107so402368857b3.19
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 12:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680808324;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cpsE6KgOhMVCFiOCT+c6VxdLOLlRj25yt0zZTwjoKGE=;
        b=G/p5wRC4+zaq69yJuw5Ew7kCkuzr1eOR3eOXXE0vVw3QzJylVPnV/knyu7xVvAp9PS
         CEVwos7mpF1E+6HKlcwjfwa/5ys8+Krm8xBMoFKno5xiSW3TFOhfLWv5mKfCazf+iXm7
         sGv5d87gLA1COLmom+bIainElIy2yV8F4SIew9xMzEPpYd2cEzWq1tf8QHTJlgu2rVHj
         mrgjtfNMkp0bTL1AHtzLupO1SRcPyzXhHGol5tM0RAbKfgNvbc4d+XQekKldtos27T+2
         cpLMMSqwLsdx8MwBH3lzA0fMIunILPJ6/2v346l7dqtR//c3LZb0bLE0y7xv+J6jqHtF
         9n4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680808324;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cpsE6KgOhMVCFiOCT+c6VxdLOLlRj25yt0zZTwjoKGE=;
        b=tFmLaMmz40aNesG8RC6FIqJD4sfm15ubyH/5WG8peq2IbV5VkgxGhUU7gvqv52tTuh
         BBN/kCEa4pgty9sA3CNUfNaeV3TAqPAAQzlpCWlLjpRs9gZvxEJDu2gFgiIA6vYQZRov
         tviNKJRIKmAy1qU3tG1pvjeGMxekcruzbpPqFUUB0pTJaEfUmhPlkLw+yAgwYwNlt1RV
         cyXUeMN9hh2Y7YsIaxFDBLsO6A9DAAkNEZzXxja0nFw1192Kl17TzMbhTl2SDNvInYcW
         3FUwxH4vuslV0nku86pIP6tjpnIAd3jbHwLU/HlC93UaklsjGAXdRq58kxOtIufP5jY4
         AycQ==
X-Gm-Message-State: AAQBX9edRaTC98a9/YbHAcpremzoNfKKbja/eC+vOOoKe3lRhwQNFjJm
        LeNfa+l6g4ECXSsu9FlNnZ/RXqtqD9U=
X-Google-Smtp-Source: AKy350YzWCmpi9L04Wj/8wziPCdl1iFrVOO5U0T2HprWLAGYcdFKPvj6V08tW6KRhGKuNvr6zRwPtaqX5mE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:430c:0:b0:54c:a67:90b with SMTP id
 q12-20020a81430c000000b0054c0a67090bmr2372621ywa.5.1680808324471; Thu, 06 Apr
 2023 12:12:04 -0700 (PDT)
Date:   Thu, 6 Apr 2023 12:12:03 -0700
In-Reply-To: <2cedc5ca5e1d126a0abf3b651c6fef1a8970fcfd.camel@intel.com>
Mime-Version: 1.0
References: <20230405005911.423699-1-seanjc@google.com> <20230405005911.423699-2-seanjc@google.com>
 <626179c54707297736158da89ee634705cd6d62f.camel@intel.com>
 <ZC4j37H2+2945xxb@google.com> <2cedc5ca5e1d126a0abf3b651c6fef1a8970fcfd.camel@intel.com>
Message-ID: <ZC8J2J9Js7Z99k6/@google.com>
Subject: Re: [PATCH 1/3] KVM: VMX: Don't rely _only_ on CPUID to enforce XCR0
 restrictions for ECREATE
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 06, 2023, Huang, Kai wrote:
> On Wed, 2023-04-05 at 18:44 -0700, Sean Christopherson wrote:
> > On Wed, Apr 05, 2023, Huang, Kai wrote:
> > > On Tue, 2023-04-04 at 17:59 -0700, Sean Christopherson wrote:
> > > > Explicitly check the vCPU's supported XCR0 when determining whether=
 or not
> > > > the XFRM for ECREATE is valid.  Checking CPUID works because KVM up=
dates
> > > > guest CPUID.0x12.1 to restrict the leaf to a subset of the guest's =
allowed
> > > > XCR0, but that is rather subtle and KVM should not modify guest CPU=
ID
> > > > except for modeling true runtime behavior (allowed XFRM is most def=
initely
> > > > not "runtime" behavior).
> > > >=20
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/sgx.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
> > > > index aa53c98034bf..362a31b19b0e 100644
> > > > --- a/arch/x86/kvm/vmx/sgx.c
> > > > +++ b/arch/x86/kvm/vmx/sgx.c
> > > > @@ -175,7 +175,8 @@ static int __handle_encls_ecreate(struct kvm_vc=
pu *vcpu,
> > > >  	    (u32)attributes & ~sgx_12_1->eax ||
> > > >  	    (u32)(attributes >> 32) & ~sgx_12_1->ebx ||
> > > >  	    (u32)xfrm & ~sgx_12_1->ecx ||
> > > > -	    (u32)(xfrm >> 32) & ~sgx_12_1->edx) {
> > > > +	    (u32)(xfrm >> 32) & ~sgx_12_1->edx ||
> > > > +	    xfrm & ~vcpu->arch.guest_supported_xcr0) {
> > >=20
> > > Perhaps this change is needed even without patch 2?
> > >=20
> > > This is because when CPUID 0xD doesn't exist, guest_supported_xcr0 is=
 0.  But
> > > when CPUID 0xD doesn't exist, IIUC currently KVM doesn't clear SGX in=
 CPUID, and
> > > sgx_12_1->ecx is always set to 0x3.
> >=20
> > Hrm, that's a bug in this patch.  Drat.  More below.
> >=20
> > > __handle_encls_ereate() doesn't check CPUID 0xD either, so w/o above =
explicit
> > > check xfrm against guest_supported_xcr0, it seems guest can successfu=
lly run
> > > ECREATE when it doesn't have CPUID 0xD?
> >=20
> > ECREATE doesn't have a strict dependency on CPUID 0xD or XSAVE.  This e=
xact scenario
> > is called out in the SDM:
> >=20
> >   Legal values for SECS.ATTRIBUTES.XFRM conform to these requirements:
> >     * XFRM[1:0] must be set to 0x3.
> >     * If the processor does support XSAVE, XFRM must contain a value th=
at would
> >       be legal if loaded into XCR0.
> >     * If the processor does not support XSAVE, or if the system softwar=
e has not
> >       enabled XSAVE, then XFRM[63:2] must be zero.
> >=20
> > So the above needs to be either
> >=20
> > 	xfrm & ~(vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FPSSE)
> >=20
> > or
> >=20
> > 	(xfrm & ~XFEATURE_MASK_FPSSE & ~vcpu->arch.guest_supported_xcr0)
> >=20
> >=20
> > I think I prefer the first one as I find it slightly more obvious that =
FP+SSE are
> > allowed in addition to the XCR0 bits.
>=20
> The above check doesn't verify xfrm is a super set of 0x3.  I think we ve=
rify
> that per SDM:

Oooh, right.  It's not that FP+SSE are always allowed, it's that FP+SSE mus=
t always
be _set_.  So this?

		xfrm & ~(vcpu->arch.guest_supported_xcr0 | XFEATURE_MASK_FPSSE) ||
		(xfrm & XFEATURE_MASK_FPSSE) !=3D XFEATURE_MASK_FPSSE

> 39.7.3 Processor Extended States and ENCLS[ECREATE]
>=20
> The ECREATE leaf function of the ENCLS instruction enforces a number of
> consistency checks described earlier. The execution of ENCLS[ECREATE] lea=
f
> function results in a #GP(0) in any of the following cases:
>   =E2=80=A2 SECS.ATTRIBUTES.XFRM[1:0] is not 3.
>   =E2=80=A2 The processor does not support XSAVE and any of the following=
 is true:
> 	=E2=80=94 SECS.ATTRIBUTES.XFRM[63:2] is not 0.
> 	=E2=80=94 SECS.SSAFRAMESIZE is 0.
>   =E2=80=A2 The processor supports XSAVE and any of the following is true=
:
> 	=E2=80=94 XSETBV would fault on an attempt to load XFRM into XCR0.
> 	=E2=80=94 XFRM[63]=3D1.
> 	=E2=80=94 The SSAFRAME is too small to hold required, enabled states ...
>=20
>=20
> And in the ECREATE pseudo code, the relevant parts seem to be:
>=20
> 	(* Check lower 2 bits of XFRM are set *)
> 	IF ( ( DS:TMP_SECS.ATTRIBUTES.XFRM BitwiseAND 03H) =E2=89=A0 03H)
> 		THEN #GP(0); FI;
>=20
> 	IF (XFRM is illegal)
> 		THEN #GP(0); FI;
>=20
> The first part is clear, but the second part is vague.=20
>=20
> I am not sure in hardware behaviour, whether XCR0 is actually checked in
> ECREATE.  It's more likely XCRO is actually checked in EENTER. =C2=A0
>=20
> But I think it's just fine to also check against XCR0 here.

ECREATE doesn't check XCR0, it checks that XFRM represents a legal XCR0 val=
ues
for the platform, which in KVM is tracked as guest_supported_xcr0.
