Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0D96AA45E
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 23:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbjCCWbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 17:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjCCWa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 17:30:57 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2459D709BD
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 14:25:26 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-536be69eadfso68815097b3.1
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 14:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677882227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SSd3HapqEJU8QO31tyJGkiInNCdsYJiH0H3WaNOYEDY=;
        b=lRoI7ySXj9rdgBcI73NtueCFnA4+2khYJdgHdhaT13JYuFg/vxIvdmSjvN9R+lVTFH
         neNpNwk/WD4zc61n+zR4NpfG3HR/Rng8YgoD/uSqkYVEH1VRfHGsa3G0Su0/o9gvD0vd
         4vodX0NU0xoIPa62kCKYScSTRhK94EuaVTI2FFfkZ84i8j2qSNW8Th5osd5Ig3aVZxPn
         /7M00Yzh3XfAHBYV1J8J20X+bqZU6AIxG3PlkET7qzcL3Q/K33F0MNFj1RqIPBivmS0T
         EzLWdw2ntbjaRcAeJgJEQruxS3920JerJZoihFpt3rkUS8XTGEeC+6FdosjniIXyPi6k
         OX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677882227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SSd3HapqEJU8QO31tyJGkiInNCdsYJiH0H3WaNOYEDY=;
        b=DuSMgR1m52y/68iioAvoOBMLhXOfiLUBTlDzM4RfAxIZ1l/OZHTPKFyXG+cJ6G8D/T
         3NvAWynO6G46/XUoAJkdMxmCctNuo5if+gq2GtDcP6sADgzUiRpD4HmSqq7AcsFTkjrP
         cVh2tr5cCjrDrrNuNFkwfGw/6jmlsKHPMaYjn5gY4PrvE9upsCck1a97G93fnV46NUVx
         mnPZYPNYbum9c+85To/MD/JPdMjl5WgK8PoRolGMae9iBzBmXr+6d5CHrn24XdkWtkSE
         9eTgDOcwXL7rgE0AgngoUkdv5Y31zn0+Jed6CZikPU/Lz4cAoeGsF5O/O3hiWOOYunT6
         c62A==
X-Gm-Message-State: AO0yUKX0zSBusNSBoY0MsPQ4VWdNdO2GvY6xENr42tx/FWJ6ezH1CKYe
        UtRlFG2oEoQOzvT/r0Z8wApVFw4ch6gbPdVD1/8ddWhbJiz5zlDJfiRHJA==
X-Google-Smtp-Source: AK7set+ZkTeFAaII5zPlmuhXGFfFkKiwYhvtqBLNIhXSuEh/ThxcP+oP8dl502tVh6GgJf0NArmZf6KDoWLkeIUqZQo=
X-Received: by 2002:a81:b717:0:b0:52f:45a:5b00 with SMTP id
 v23-20020a81b717000000b0052f045a5b00mr2025635ywh.2.1677882227080; Fri, 03 Mar
 2023 14:23:47 -0800 (PST)
MIME-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-3-aaronlewis@google.com> <ZAJlTCWx8fpNp0Wi@google.com>
In-Reply-To: <ZAJlTCWx8fpNp0Wi@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Fri, 3 Mar 2023 22:23:35 +0000
Message-ID: <CAAAPnDFSFzNbCpMx5oG8wRiqyBRst+X1OPK4PWi9ZftTq-2fqg@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Mingwei Zhang <mizhang@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 3, 2023 at 9:23=E2=80=AFPM Mingwei Zhang <mizhang@google.com> w=
rote:
>
> On Fri, Feb 24, 2023, Aaron Lewis wrote:
> > Be a good citizen and don't allow any of the supported MPX xfeatures[1]
> > to be set if they can't all be set.  That way userspace or a guest
> > doesn't fail if it attempts to set them in XCR0.
> >
> > [1] CPUID.(EAX=3D0DH,ECX=3D0):EAX.BNDREGS[bit-3]
> >     CPUID.(EAX=3D0DH,ECX=3D0):EAX.BNDCSR[bit-4]
> >
> > Suggested-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index e1165c196970..b2e7407cd114 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -60,9 +60,22 @@ u32 xstate_required_size(u64 xstate_bv, bool compact=
ed)
> >       return ret;
> >  }
> >
> > +static u64 sanitize_xcr0(u64 xcr0)
> > +{
> > +     u64 mask;
> > +
> > +     mask =3D XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR;
> > +     if ((xcr0 & mask) !=3D mask)
> > +             xcr0 &=3D ~mask;
> > +
> > +     return xcr0;
> > +}
>
> Is it better to put sanitize_xcr0() into the previous patch? If we do
> that, this one will be just adding purely the MPX related logic and thus
> cleaner I think.

I don't mind doing that.  I considered putting in its own commit
actually.  The only reason I didn't is I wasn't sure it was
appropriate to have a commit that only added an empty function.  If
that's okay I think I'd lean more towards doing it that way.

> > +
> >  u64 kvm_permitted_xcr0(void)
> >  {
> > -     return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> > +     u64 permitted_xcr0 =3D kvm_caps.supported_xcr0 & xstate_get_guest=
_group_perm();
> > +
> > +     return sanitize_xcr0(permitted_xcr0);
> >  }
> >
> >  /*
> > --
> > 2.39.2.637.g21b0678d19-goog
> >
