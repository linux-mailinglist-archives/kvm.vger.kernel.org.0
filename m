Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3243176574F
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 17:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbjG0PUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 11:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbjG0PUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 11:20:43 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B669B2D70
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 08:20:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d063bd0bae8so1018599276.0
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 08:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690471240; x=1691076040;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DYLBFXhGSoasOuRGrdFg74gMOA4q3DP8VECqxwco5U=;
        b=WWXhuJSXagc5JhuCa+sI6LpKTWa9GhUZIx0JcgU5Ea2l9ljEknXtwfXbBIe6iHDBPz
         +6e0nKNOhLB54oBMpXnqDEFYVPowTVF+gFhm+gD8SypBTnCP01Ez/gqZ2y+hB9QL9VnN
         uKAlmS5bLEAcI7ddfkYfddBTySMNjkPyVDYI92xxnWSO8X/70dEf1Y8Ssf4qejb8hyDs
         dL4k1c9jRP5oMTeDtEsopNEeTDS2kL7TvMVM7m1PE/Q5R7R/ZFA5gctux7IMsnw+EakN
         IrCu0zVGZVlkb/gZtqiiiw39+WItBQlyPFwN0KHIwv2akOF0pm2VB3xH+NqgL5u8CJqN
         Pckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690471240; x=1691076040;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2DYLBFXhGSoasOuRGrdFg74gMOA4q3DP8VECqxwco5U=;
        b=a3/4S24X6k/LoBKUkLGuFefXSEGuoqthUcX4iSCOliUo5TXQLDwMkF9NCq+q10pRnj
         iDEiTshMlveEE4h+QJfd8DYH833M2MrU/iSryTmciYCysU609cJyHBQxKEfVdb4X+eT8
         AbmxOdlCx8Eq2QIu8WdGObFFEE/zx2KG5yu/iyhCxls1ve6FJmJ5kiKKOoI3kGNlwvP2
         3cQofnQtOTtfLYUYpCyONBwMFTEfcAZFxkwhQYyiDGXgX8pI5X3uqajMS7S7titfHNtA
         IFwTKeGNbvtHtJ4lagvv+UrSKFmCcZowvDyC7p0eCcK0noFjyoxhbE45zEMzN1RylJhX
         Tviw==
X-Gm-Message-State: ABy/qLbfndPEOpNNZ4WmMXmNHzAvGMl2kYVaoK8/bdSwkysydoHl2njB
        vP+KOCTZDFgoNn3U4quXXrbZUxJFYzk=
X-Google-Smtp-Source: APBJJlEOSknzSn5u5GJJBT5D8rh5yhnR61dC36cTTK10z26m7B5QSufIasZed1C/bw49aOqlg/RBdg3lI0g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:348e:0:b0:d07:f1ed:521a with SMTP id
 b136-20020a25348e000000b00d07f1ed521amr30462yba.4.1690471239857; Thu, 27 Jul
 2023 08:20:39 -0700 (PDT)
Date:   Thu, 27 Jul 2023 08:20:38 -0700
In-Reply-To: <2801b9d6-4f32-c4b2-ae93-c56ffc2b4621@intel.com>
Mime-Version: 1.0
References: <20230721030352.72414-1-weijiang.yang@intel.com>
 <20230721030352.72414-14-weijiang.yang@intel.com> <ZMDT/r4sEfMj5Bmu@chao-email>
 <3d5fdd07-563c-6841-a867-88369c4dbb36@intel.com> <ZMH9tIXfPk0dl7ye@chao-email>
 <2801b9d6-4f32-c4b2-ae93-c56ffc2b4621@intel.com>
Message-ID: <ZMKLRnjCTwqTr/MF@google.com>
Subject: Re: [PATCH v4 13/20] KVM:VMX: Emulate read and write to CET MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 27, 2023, Weijiang Yang wrote:
>=20
> On 7/27/2023 1:16 PM, Chao Gao wrote:
> > > > > @@ -2402,6 +2417,31 @@ static int vmx_set_msr(struct kvm_vcpu *vc=
pu, struct msr_data *msr_info)
> > > > > 		else
> > > > > 			vmx->pt_desc.guest.addr_a[index / 2] =3D data;
> > > > > 		break;
> > > > > +#define VMX_CET_CONTROL_MASK		(~GENMASK_ULL(9, 6))
> > > > bits9-6 are reserved for both intel and amd. Shouldn't this check b=
e
> > > > done in the common code?
> > > My thinking is, on AMD platform, bit 63:2 is anyway reserved since it=
 doesn't
> > > support IBT,
> > You can only say
> >=20
> > 	bits 5:2 and bits 63:10 are reserved since AMD doens't support IBT.
> >=20
> > bits 9:6 are reserved regardless of the support of IBT.
> >=20
> > > so the checks in common code for AMD is enough, when the execution fl=
ow comes
> > > here,
> > >=20
> > > it should be vmx, and need this additional check.
> > The checks against reserved bits are common for AMD and Intel:
> >=20
> > 1. if SHSTK is supported, bit1:0 are not reserved.
> > 2. if IBT is supported, bit5:2 and bit63:10 are not reserved
> > 3. bit9:6 are always reserved.
> >=20
> > There is nothing specific to Intel.

+1

> So you want the code to be:
>=20
> +#define CET_IBT_MASK_BITS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 (GENMASK_ULL(5, 2) | GENMASK_ULL(63,
> 10))
>=20
> +#define CET_CTRL_RESERVED_BITS GENMASK(9, 6)
>=20
> +#define CET_SHSTK_MASK_BITSGENMASK(1, 0)
>=20
> +if ((!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
>=20
> +(data & CET_SHSTK_MASK_BITS)) ||
>=20
> +(!guest_can_use(vcpu, X86_FEATURE_IBT) &&
>=20
> +(data & CET_IBT_MASK_BITS)) ||
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 (data & CET_CTRL_RESERVED_BITS) )
>=20
> ^^^^^^^^^^^^^^^^^^^^^^^^^

Yes, though I vote to separate each check, e.g.

	if (data & CET_CTRL_RESERVED_BITS)
		return 1;

	if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) && (data & CET_SHSTK_MASK_BITS=
))
		return 1;

	if (!guest_can_use(vcpu, X86_FEATURE_IBT) && (data & CET_IBT_MASK_BITS))
		return 1;

I would expect the code generation to be similar, if not outright identical=
, and
IMO it's easier to quickly understand the flow if each check is a separate =
if-statement.
