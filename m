Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C7E724BCC
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 20:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbjFFSwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 14:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbjFFSwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 14:52:14 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1470A10F2
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 11:52:13 -0700 (PDT)
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com [209.85.128.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 935DD3F14D
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686077529;
        bh=l02b/K0jUgIPi6g5Wa0vTnmy9T9JMjknsh7zg5jIDAI=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=MmORCD3LpbC8TsJAWIfMmAROPrjriL1GDrbdA7q98SKjNKDnZW0QcxesiBEf/Rct4
         i/5R0bNTpJFTS0mC2j6RoVDoX1IpIp0u3e7RJyksohK62tzVQnEvQ3yVm+5Fl77aS+
         RnLBLQuKg5QaMuhD9JezuSKK/jRwN5iHV+yuEWqxkp9a2s95McAcBxn6nrSEY2wkUh
         AtyuxB6O680O9wOCVDu6E/ThjDA+5ZQkdnaFoRiPHiZPC/u1+x/Qiiyds6WcCmTiQG
         OguRaJov7KZpFfw/a2Opzi1MF/yX60TkbtZlwJzVbayDbkATOJgBCE30tsjBN1AJfr
         LbV3f0sL+c9Mw==
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-5659c7dad06so107691387b3.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 11:52:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686077528; x=1688669528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l02b/K0jUgIPi6g5Wa0vTnmy9T9JMjknsh7zg5jIDAI=;
        b=EKyXHB54ysUFSGTf92YcnFCsp3+LqI5ABqnjUSAZV9Go85UiCzrTSo6C3zyYbvuejL
         D+/DnNtCDSlN14TrCeJb77Pn/xqxqiRtpEkhMARBUI8jTxwKSsiHyyAY4+MtvZrbg5y9
         QuaSv9L87Lnwji0az+CLBNHDMMIw2WvtEQ4IrdkUUcdRSODt6/frO58KWRfdKL2zqXBm
         d/fTipDy0vg+8AxJKsL8Es4urxK1MJmQi9jRpUzB4FapXlezl76kCHXjR0nGsfYhZz8L
         csdCpVx3DmPm01z+gHMt1NyFHEsaJSCIMB6fUtJkQEzGkDob3iCWxw3QhiuyZhxUBMdz
         o9+g==
X-Gm-Message-State: AC+VfDzga0SAURRA9i5WYwfWQTSB13WTSu1NuPFEj5oGbPasYY83asdQ
        Z1dHQ8rNnGo42QkgUlaWJQbXkqD+9ZxuHy3D6wsgV0NW6Gw7d7nWkpB52JS/IAqYGKaHK9gvCU1
        pLnx6pToPq0qSJV1OCvHyDq63jGHBP5w1Fi0dlwACANSNyw==
X-Received: by 2002:a81:68c4:0:b0:565:c21d:8ec6 with SMTP id d187-20020a8168c4000000b00565c21d8ec6mr3714050ywc.6.1686077528642;
        Tue, 06 Jun 2023 11:52:08 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ551akgQAun7LuYmmNEuzJ+1pWtGmk3YsHejyb95gPBlmh2dY+4j/7/GoZOJLU9Cs+XvARvqdsAV/LeByyEM5Q=
X-Received: by 2002:a81:68c4:0:b0:565:c21d:8ec6 with SMTP id
 d187-20020a8168c4000000b00565c21d8ec6mr3714025ywc.6.1686077528421; Tue, 06
 Jun 2023 11:52:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com>
 <20230522161249.800829-2-aleksandr.mikhalitsyn@canonical.com> <ZH9+ufGL9SGfmmnc@google.com>
In-Reply-To: <ZH9+ufGL9SGfmmnc@google.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Tue, 6 Jun 2023 20:51:57 +0200
Message-ID: <CAEivzxdjd-zp-jYQTPNeQ_fV5ySoSV7kNLBtzaC9jBxoOKOwSA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: SVM: free sev_*asid_bitmap init if SEV init fails
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 6, 2023 at 8:45=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, May 22, 2023, Alexander Mikhalitsyn wrote:
> > If misc_cg_set_capacity() fails for some reason then we have
> > a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
> > not a case right now, because misc_cg_set_capacity() just can't
> > fail and check inside it is always successful.
> >
> > But let's fix that for code consistency.
> >
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: St=C3=AF=C2=BF=C2=BDphane Graber <stgraber@ubuntu.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> >  arch/x86/kvm/svm/sev.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 69ae5e1b3120..cc832a8d1bca 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2216,8 +2216,13 @@ void __init sev_hardware_setup(void)
> >       }
> >
> >       sev_asid_count =3D max_sev_asid - min_sev_asid + 1;
> > -     if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
> > +     if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count)) {
> > +             bitmap_free(sev_reclaim_asid_bitmap);
> > +             sev_reclaim_asid_bitmap =3D NULL;
> > +             bitmap_free(sev_asid_bitmap);
> > +             sev_asid_bitmap =3D NULL;
> >               goto out;
> > +     }
>
> Blech, didn't look close enough at v1.  I think I'd rather yell and conti=
nue on.
> If misc_cg_set_capacity() were to fail, debugging would be unnecessarily =
painful,
> and at least as things stand today, there's nothing userspace can do to r=
emedy
> the problem except by manually disabling SEV and/or SEV-ES.

Hi Sean,

I agree with your point. Let's go this way!

Kind regards,
Alex

>
> ---
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 6 Jun 2023 11:34:28 -0700
> Subject: [PATCH] KVM: SVM: WARN, but continue, if misc_cg_set_capacity() =
fails
>
> WARN and continue if misc_cg_set_capacity() fails, as the only scenario
> in which it can fail is if the specified resource is invalid, which shoul=
d
> never happen when CONFIG_KVM_AMD_SEV=3Dy.  Deliberately not bailing "fixe=
s"
> a theoretical bug where KVM would leak the ASID bitmaps on failure, which
> again can't happen.
>
> If the impossible should happen, the end result is effectively the same
> with respect to SEV and SEV-ES (they are unusable), while continuing on
> has the advantage of letting KVM load, i.e. userspace can still run
> non-SEV guests.
>
> Reported-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index d65578d8784d..07756b7348ae 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2216,9 +2216,7 @@ void __init sev_hardware_setup(void)
>         }
>
>         sev_asid_count =3D max_sev_asid - min_sev_asid + 1;
> -       if (misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count))
> -               goto out;
> -
> +       WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV, sev_asid_count=
));
>         sev_supported =3D true;
>
>         /* SEV-ES support requested? */
> @@ -2243,9 +2241,7 @@ void __init sev_hardware_setup(void)
>                 goto out;
>
>         sev_es_asid_count =3D min_sev_asid - 1;
> -       if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
> -               goto out;
> -
> +       WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid=
_count));
>         sev_es_supported =3D true;
>
>  out:
>
> base-commit: 6d1bc9754b04075d938b47cf7f7800814b8911a7
> --
>
