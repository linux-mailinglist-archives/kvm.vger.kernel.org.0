Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 315116F50FA
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 09:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjECHQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 03:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjECHQF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 03:16:05 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B54035B0;
        Wed,  3 May 2023 00:16:02 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1928860f63eso984941fac.0;
        Wed, 03 May 2023 00:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683098161; x=1685690161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlNv/F2pCSwWbexWZ5JR+V38LaHDUWBt53s7CUexmGA=;
        b=ovKuIJlCtQLxpA1qPNder/rFAq3YErdm0kDt3aYHjNYsKAaO1onRL+QOyIWR6UuBzZ
         0/qng6/4ZsCXc2btT/2t3T//F9EK4ebxBNCoVbfYFq06+vwVZVjtIuRt6ciVc1YyK7oK
         lfChm+YSlHIsGL+T67udLNJhKsb+6u9rrrZP6k2xAWb9DRxRWRceUzUyKNiAGOhomV5p
         GFnXnq00I+FNCrPcKfF4nwyyNO/eN7puqGTNogJu7QE6/SdJJSgCQoEcf1RBu8yA8Snm
         IFEONcKddHEFUpovi2YGJy+p2YU2NqF18PEuLnZZcatNcn+Rv3+as3otSFF+HI3L/gUo
         Yahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683098161; x=1685690161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nlNv/F2pCSwWbexWZ5JR+V38LaHDUWBt53s7CUexmGA=;
        b=d2gbldjQFR6gBZAOVMMQrtJUGdgiXVCdzRb37d+Ffn8SfkE8xdDXwa706FAxzxDIdZ
         lnkivvl2W+7vpDfM/sPE/3UPUgqujapKx8UkmotLlfTpH/SZ5d6pL4npDmWVjsLxEAPD
         1MxsKXP3gu5dCtKMTnFoHpKA+RWy4qXMATQ/SeH0Y9HGW9pDyc13Lvd8UPRlgOl89K2p
         HOG1O/CGYJq5jSrShRX7qBOMGkquVwAXcEqzjKMRwRKYwnjwMMkvIlMx5YPoimyhCRqF
         2E/UmYR4TgHG67UtBiYzUAcVt0eBvgkrVff88RVOSjrHPN7KO2zetDd2tlhleAhhsuym
         nUvQ==
X-Gm-Message-State: AC+VfDy7egTsNZ6oqccl+pdfo/OlOxwaalb6W/5moJ6lleUlEsU0mxIL
        06n3JGY39UmMVF9725lUyTdq1medQslKub9rZfM=
X-Google-Smtp-Source: ACHHUZ5frZJz6/JDagRgAf6f8HQ7KkaW2AVcePOplDlQJ8kqBupFAFLwS1odqZCAvx1T4kZWKyl79GVw7YYUzvNeAGs=
X-Received: by 2002:a05:6870:9890:b0:18e:7c5e:b58c with SMTP id
 eg16-20020a056870989000b0018e7c5eb58cmr9395162oab.9.1683098161344; Wed, 03
 May 2023 00:16:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230502112502.14859-1-yanjiewtw@gmail.com> <ZFFEgptZg1P367F7@google.com>
In-Reply-To: <ZFFEgptZg1P367F7@google.com>
From:   Yan-Jie Wang <yanjiewtw@gmail.com>
Date:   Wed, 3 May 2023 15:15:50 +0800
Message-ID: <CAAM15DyHiCiA=hFHANi+Z0h5aqbs3Lb2tEg1+BA6=LiYgQ7Agw@mail.gmail.com>
Subject: Re: [PATCH] docs: clarify KVM related kernel parameters' descriptions
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Avi Kivity <avi@redhat.com>,
        Ching-Chun Huang <jserv@ccns.ncku.edu.tw>, trivial@kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you, Sean.

I will revise the patch accordingly and submit a new version as well
as update the description of kvm-intel.nested to reflect that it is
enabled by default.

On Wed, May 3, 2023 at 1:12=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, May 02, 2023, Yan-Jie Wang wrote:
> > The descriptions of certain KVM related kernel parameters can be
> > ambiguous and confusing. They state 'Disable ...,' which implies that
> > setting them to 1 would disable the associated features or options,
> > when in fact the opposite is true.
> >
> > This commit addresses this issue by revising the descriptions of these
> > parameters to make their intended behavior clear.
>
> Less wrong perhaps, but IMO the actual behavior is still not captured, an=
d from
> a certain perspective the existing "Disable" verbiage better reflects how=
/when
> most users would actually want to explicitly set a param.
>
> Rather than commit one way or the other, what about reworking the descrip=
tions
> using this as a template?  E.g. state that the param controls something, =
state
> the default and use that to communicate that 1=3D=3Denabled, and then, wh=
en appropriate,
> clarify that KVM disables (or in some cases ignores) params if hardware d=
oesn't
> support the related feature(s).
>
>         kvm-intel.ept=3D  [KVM,Intel] Control KVM's use of Extended Page =
Tables,
>                         a.k.a. Two-Dimensional Page Tables.  Default is 1
>                         (enabled).  Disabled by KVM if hardware lacks sup=
port
>                         for EPT.
>
> >
> > Signed-off-by: Yan-Jie Wang <yanjiewtw@gmail.com>
> > ---
> >  Documentation/admin-guide/kernel-parameters.txt | 16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Document=
ation/admin-guide/kernel-parameters.txt
> > index 9e5bab29685f..cc5abb3d54b9 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2552,10 +2552,10 @@
> >                       on the ratio, such that a page is zapped after 1 =
hour on average.
> >
> >       kvm-amd.nested=3D [KVM,AMD] Allow nested virtualization in KVM/SV=
M.
>
> Eh, I don't see any reason to have this one say "allow" instead of "enabl=
e/disable".
>
> > -                     Default is 1 (enabled)
> > +                     Default is 1 (allow)
> >
> > -     kvm-amd.npt=3D    [KVM,AMD] Disable nested paging (virtualized MM=
U)
> > -                     for all guests.
> > +     kvm-amd.npt=3D    [KVM,AMD] Enable nested paging (virtualized MMU=
)
> > +                     for all guests on capable AMD chips.
> >                       Default is 1 (enabled) if in 64-bit or 32-bit PAE=
 mode.
> >
> >       kvm-arm.mode=3D
> > @@ -2602,12 +2602,12 @@
> >                       Format: <integer>
> >                       Default: 5
> >
> > -     kvm-intel.ept=3D  [KVM,Intel] Disable extended page tables
> > +     kvm-intel.ept=3D  [KVM,Intel] Enable extended page tables
> >                       (virtualized MMU) support on capable Intel chips.
> >                       Default is 1 (enabled)
> >
> >       kvm-intel.emulate_invalid_guest_state=3D
> > -                     [KVM,Intel] Disable emulation of invalid guest st=
ate.
> > +                     [KVM,Intel] Enable emulation of invalid guest sta=
te.
> >                       Ignored if kvm-intel.enable_unrestricted_guest=3D=
1, as
> >                       guest state is never invalid for unrestricted gue=
sts.
> >                       This param doesn't apply to nested guests (L2), a=
s KVM
> > @@ -2615,7 +2615,7 @@
> >                       Default is 1 (enabled)
> >
> >       kvm-intel.flexpriority=3D
> > -                     [KVM,Intel] Disable FlexPriority feature (TPR sha=
dow).
> > +                     [KVM,Intel] Enable FlexPriority feature (TPR shad=
ow).
> >                       Default is 1 (enabled)
> >
> >       kvm-intel.nested=3D
> > @@ -2623,7 +2623,7 @@
> >                       Default is 0 (disabled)
>
> Heh, kvm-intel.nested has been enabled by default for quite some time.  C=
an you
> fix that up too?
>
> >
> >       kvm-intel.unrestricted_guest=3D
> > -                     [KVM,Intel] Disable unrestricted guest feature
> > +                     [KVM,Intel] Enable unrestricted guest feature
> >                       (virtualized real and unpaged mode) on capable
> >                       Intel chips. Default is 1 (enabled)
> >
> > @@ -2639,7 +2639,7 @@
> >
> >                       Default is cond (do L1 cache flush in specific in=
stances)
> >
> > -     kvm-intel.vpid=3D [KVM,Intel] Disable Virtual Processor Identific=
ation
> > +     kvm-intel.vpid=3D [KVM,Intel] Enable Virtual Processor Identifica=
tion
> >                       feature (tagged TLBs) on capable Intel chips.
> >                       Default is 1 (enabled)
> >
> >
> > base-commit: 865fdb08197e657c59e74a35fa32362b12397f58
> > --
> > 2.34.1
> >
