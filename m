Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D64478715F
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 16:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241549AbjHXOXW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 10:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236682AbjHXOWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 10:22:53 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6065511F
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 07:22:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59285f1e267so10298887b3.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 07:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692886970; x=1693491770;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LUqkh+MsV5Vrt4MTvDlgnnSg6OPpYXOoL7cfHlTtb8M=;
        b=UWvBCdin9fzOcW//Ix69NYEO26eQR2dYIfmBO7ycAwvPBVNQzetffaZ9xtH1qn+6Wj
         SX7zr6smqNFsXI687Ckf/On8Uc2/qRwaEQycIbFakkEKjEAOAf3SsJ7DPYDKNawW+Tbs
         TuL71VlDi5BNXVpf6Nkqxtn1knirtV/yhYEU5lqSEhCdAgsXxsxiuuDyAU0cRfzmatd0
         pEQFFXCyBH64J6dnRDGZJW5zfzGY1TShoOCir92rQrhFmZLbKILQXSF2OqVCjrFYoxJv
         XdBNagJOV96y0wP+bNRDwE23pnd6xpZPFrYOewULejQ+4wdJdza9ZEHvpaC74Qk+TmGL
         AM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692886970; x=1693491770;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LUqkh+MsV5Vrt4MTvDlgnnSg6OPpYXOoL7cfHlTtb8M=;
        b=gMOGJerIVO+pzSexAnYmu6uMsR15Z7y+ylsSFL/EyC/aH5BEKGDcH0Vm50D3IQBft0
         k5TW3l6/+ZWKmGuGcDnk3Rz7gZXWF/xB41h6HD72toDOYaFdW6n01AeGBHe571zvP+7I
         +65uNjqQ8B+6X4nMtPvyHDKo1SV6GGiqV13o6BudlnMjr37ZMBFyVgXGx6WedbMhAHx0
         qzwJkU5PSI7oZxLGTTKYtUTFtoN2fvnWULEL4sJi7EKCH5p4HGkWUIqqZzFa0R8o/w/j
         lRelfRx7CfNQ74KPrfwNmII8ZE3B8WPpgbRb0C6Zj4+PxyakVZMKsaFnyOMIqC67Ydlf
         xb9g==
X-Gm-Message-State: AOJu0YySdMQr9DtRgXOprpP7Jo+88YdAE01N/xHfJtBr12CcEpyGoTQg
        luJJ4uoR3ef3Rn3FDtBiZulHKoe3Dio=
X-Google-Smtp-Source: AGHT+IEcl3qGP1JrvIn63TSnfzzvUSShyoMV4j6547DJrdRfSZAgVP7pWcLKEyUAru3TUAMu0cVhLEDsybQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:af24:0:b0:586:e2b5:f364 with SMTP id
 n36-20020a81af24000000b00586e2b5f364mr320156ywh.4.1692886970397; Thu, 24 Aug
 2023 07:22:50 -0700 (PDT)
Date:   Thu, 24 Aug 2023 14:22:48 +0000
In-Reply-To: <174aa0da-0b05-a2dc-7884-4f7b57abcc37@amd.com>
Mime-Version: 1.0
References: <67fba65c-ba2a-4681-a9bc-2a6e8f0bcb92.chenpeihong.cph@alibaba-inc.com>
 <ZOYfxgSy/SxCn0Wq@google.com> <174aa0da-0b05-a2dc-7884-4f7b57abcc37@amd.com>
Message-ID: <ZOdnuDZUd4mevCqe@google.com>
Subject: Re: Question about AMD SVM's virtual NMI support in Linux kernel mainline
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     "=?utf-8?B?6ZmI5Z+56bi/KOS5mOm4vyk=?=" 
        <chenpeihong.cph@alibaba-inc.com>, mlevitsk <mlevitsk@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+kvm and lkml, didn't realize they weren't Cc'd in the original mail.

On Thu, Aug 24, 2023, Santosh Shukla wrote:
> Hi Sean,
>=20
> On 8/23/2023 8:33 PM, Sean Christopherson wrote:
> > On Fri, Aug 18, 2023, =E9=99=88=E5=9F=B9=E9=B8=BF(=E4=B9=98=E9=B8=BF) w=
rote:
> >> According to the results, I found that in the case of concurrent NMIs,=
 some
> >> NMIs are still injected through eventinj instead of vNMI.
> >=20
> > Key word is "some", having two NMIs arrive "simultaneously" is uncommon=
.  In quotes
> > because if a vCPU is scheduled out or otherwise delayed, two NMIs can b=
e recognized
> > by KVM at the same time even if there was a sizeable delay between when=
 they were
> > sent.
> >=20
> >> Based on the above explanations, I summarize my questions as follows:
> >> 1. According to the specification of AMD SVM vNMI, with vNMI enabled, =
will
> >> some NMIs be injected through eventinj under the condition of concurre=
nt
> >> NMIs?
> >=20
> > Yes.
> >=20
> >> 2. If yes, what is the role of vNMI? Is it just an addition to eventin=
j? What
> >> benefits is it designed to expect? Is there any benchmark data support=
?
> >=20
> > Manually injecting NMIs isn't problematic from a performance perspectiv=
e.  KVM
> > takes control of the vCPU, i.e. forces a VM-Exit, to pend a virtual NMI=
, so there's
> > no extra VM-Exit.
> >=20
> > The value added by vNMI support is that KVM doesn't need to manually tr=
ack/detect
> > when NMIs become unblocked in the guest.  SVM doesn't provide a hardwar=
e-supported
> > NMI-window exiting, so KVM has to intercept _and_ single-step IRET, whi=
ch adds two
> > VM-Exits for _every_ NMI when vNMI isn't available (and it's a complete=
 mess for
> > things like SEV-ES).
> >=20
> >> 3. If not, does it mean that the current SVM's vNMI support scheme in =
the
> >> Linux mainline code is flawed? How should it be fixed?
> >=20
> > The approach as a whole isn't flawed, it's the best KVM can do given SV=
M's vNMI
> > architecture and KVM's ABI with respect to "concurrent" NMIs.
> >=20
> > Hrm, though there does appear to be a bug in the injecting path.  KVM d=
oesn't
> > manually set V_NMI_BLOCKING_MASK, and will unnecessarily enable IRET in=
terception
> > when manually injecting a vNMI.  Intercepting IRET should be unnecessar=
y because
> > hardware will automatically accept the pending vNMI when NMIs become un=
blocked.
> > And I don't see anything in the APM that suggests hardware will set V_N=
MI_BLOCKING_MASK
> > when software directly injects an NMI.
> >=20
> > So I think we need:
> >=20
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index d381ad424554..c956a9f500a2 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3476,6 +3476,11 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu=
)
> >         if (svm->nmi_l1_to_l2)
> >                 return;
> > =20
> > +       if (is_vnmi_enabled(svm)) {
> > +               svm->vmcb->control.int_ctl |=3D V_NMI_BLOCKING_MASK;
> > +               return;
> > +       }
> > +
> >         svm->nmi_masked =3D true;
> >         svm_set_iret_intercept(svm);
> >         ++vcpu->stat.nmi_injections;
> > --
> >=20
> > or if hardware does set V_NMI_BLOCKING_MASK in this case, just:
> >=20
>=20
> Yes, HW does set BLOCKING_MASK when HW takes the pending vNMI event.

I'm not asking about the pending vNMI case, which is clearly spelled out in=
 the
APM.  I'm asking about directly injecting an NMI via:

	svm->vmcb->control.event_inj =3D SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;

> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index d381ad424554..201a1a33ecd2 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3473,7 +3473,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> > =20
> >         svm->vmcb->control.event_inj =3D SVM_EVTINJ_VALID | SVM_EVTINJ_=
TYPE_NMI;
> > =20
> > -       if (svm->nmi_l1_to_l2)
> > +       if (svm->nmi_l1_to_l2 || is_vnmi_enabled(svm))
> >                 return;
> > =20
> >         svm->nmi_masked =3D true;
> > --
> >
>=20
> Above proposal make sense to me, I was reviewing source code flow
> for a scenarios when two consecutive need to me delivered to Guest.
> Example, process_nmi will pend the first NMI and then second NMI will
> be injected through EVTINJ, as because (kvm_x86_inject_nmi)
> will get called and that will set the _iret_intercept.=20
>=20
> With your proposal inject_nmi will be set the env_inj NMI w/o the IRET,
> I think we could check for "is_vnmi_enabled" before the programming
> the "evt_inj"?

No, because the whole point of this path is to directly inject an NMI when =
NMIs
are NOT blocked in the guest AND there is already a pending vNMI.
