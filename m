Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE476F060
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 19:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbjHCRLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 13:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjHCRLk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 13:11:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23313A99
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 10:11:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5844e92ee6bso12835337b3.3
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 10:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691082694; x=1691687494;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bB+uo4pmpYuhJSsuHlI8fVx3xMR4wswoDF+uVuY4qBw=;
        b=XnbrxVGZCnNedha0d34E1G8PbplRWHAHNXln+LHEUk53JRJ/78vcMMS/pOMPXUZcA5
         Up96SlHHB+U4N49EdML0rZj/cE3l1W5bGUgqY2sNo0TkdQ1RwTLzAQeIpd52TPYHHsym
         TiCDt1KeZaKlr0NK9i/s5CjX7gydHaZPWvjM1fBbQ6vcuxkJfLU1S+8+VyCDfDHAw6jo
         QXtpu+Z25wn9/1yMzs58dae0qTRPqRBNkXxOxMsCVKVWm7rLlJbwgl3pjJkgKfFZlBeN
         kv5r12pgNmBz3rbu2nGwI95FPAfhmuHsq82S/hpAjbkYBrMy20wkl1Bt6PFxXGu70MWu
         lt4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691082694; x=1691687494;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bB+uo4pmpYuhJSsuHlI8fVx3xMR4wswoDF+uVuY4qBw=;
        b=e0H3ydIgs60ssECpDqfK6pGwYkcHo/lSBrO8xLcd23bUg32VbQT15aYbe1we/nzj+2
         wY/5GdGvNicRpLdY1ez3ogCECbC6vEELfkeFnC2QYckL4O2EgJ3B0ao7Z/035E4QdI/f
         d4nmv4LhrqpLuj3Qft7jD/4BehrTtCNa2LwGyi/VArRlYt2yTY5iu2jqae24hcChOmwg
         5m2Q14g+R6+5S4B68R0MGmad/wL1q1APosFpK06CJW3PkjXme3rj88QTAS+X2U9Gv6aZ
         Q2Rj2O/4eLOSp/QU2B1JGpIgp7lgBW8jGH5XJGqCU+j0k2Kbcp10JSn92e8ea9tK4bcd
         61bA==
X-Gm-Message-State: ABy/qLYyCsEWxfEnFe0tlpP4rZAuPoG1o3cI4aemmtw44dandZ7l/aNn
        HbadXMUlSnJgJZ8vJr+vUuw+scSwtk4=
X-Google-Smtp-Source: APBJJlEKZCxpPhzO4yNIjB0KJlIp873xXjnfMJ0NfYf22ESUNzp87q2D3FR2Ov5JeUqtMyJkrvlBcs0vCeg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad4b:0:b0:55d:d5b1:c2bd with SMTP id
 l11-20020a81ad4b000000b0055dd5b1c2bdmr182288ywk.8.1691082694135; Thu, 03 Aug
 2023 10:11:34 -0700 (PDT)
Date:   Thu, 3 Aug 2023 10:11:32 -0700
In-Reply-To: <a5bc09c4-cc24-1e70-b70f-dbbce4251717@intel.com>
Mime-Version: 1.0
References: <20230720115810.104890-1-weijiang.yang@intel.com>
 <ZMqxxH5mggWYDhEx@google.com> <a5bc09c4-cc24-1e70-b70f-dbbce4251717@intel.com>
Message-ID: <ZMvfxFgHlWMyrvbq@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86:VMX: Fixup for VMX test failures
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023, Weijiang Yang wrote:
> On 8/3/2023 3:43 AM, Sean Christopherson wrote:
> > > diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> > > index 7952ccb..b6d4982 100644
> > > --- a/x86/vmx_tests.c
> > > +++ b/x86/vmx_tests.c
> > > @@ -4173,7 +4173,10 @@ static void test_invalid_event_injection(void)
> > >   			    ent_intr_info);
> > >   	vmcs_write(GUEST_CR0, guest_cr0_save & ~X86_CR0_PE & ~X86_CR0_PG);
> > >   	vmcs_write(ENT_INTR_INFO, ent_intr_info);
> > > -	test_vmx_invalid_controls();
> > > +	if (basic.errcode)
> > > +		test_vmx_valid_controls();
> > > +	else
> > > +		test_vmx_invalid_controls();
> > This is wrong, no?  The consistency check is only skipped for PM, the a=
bove CR0.PE
> > modification means the target is RM.
> I think this case is executed with !CPU_URG, so RM is "converted" to PM b=
ecause we
> have below in KVM:
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 bool urg =3D nested_cpu_has2(vmcs12,
> SECONDARY_EXEC_UNRESTRICTED_GUEST);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 bool prot_mode =3D !urg || vmcs12->guest_cr0 & X86_CR0_P=
E;
> ...
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (!prot_mode || intr_type !=3D INTR_TYPE_HARD_EXCEPTIO=
N ||
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !nested_cpu_has_no_hw_errcode(vc=
pu)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* VM-en=
try interruption-info field: deliver error code */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 should_h=
ave_error_code =3D
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 intr_type =3D=3D INTR_TYPE_HARD_EXC=
EPTION &&
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 prot_mode &&
> x86_exception_has_error_code(vector);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (CC(h=
as_error_code !=3D should_have_error_code))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
>=20
> so on platform with basic.errcode =3D=3D 1, this case passes.

Huh.  I get the logic, but IMO based on the SDM, that's a ucode bug that go=
t
propagated into KVM (or an SDM bug, which is my bet for how this gets treat=
ed).

I verified HSW at least does indeed generate VM-Fail and not VM-Exit(INVALI=
D_STATE),
so it doesn't appear that KVM is making stuff (for once).  Either that or I=
'm
misreading the SDM (definite possibility), but the only relevant condition =
I see is:

  bit 0 (corresponding to CR0.PE) is set in the CR0 field in the guest-stat=
e area

I don't see anything in the SDM that states the CR0.PE is assumed to be '1'=
 for
consistency checks when unrestricted guest is disabled.

Can you bug a VMX architect again to get clarification, e.g. to get an SDM =
update?
Or just point out where I missed something in the SDM, again...
