Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF796DF904
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 16:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDLOwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 10:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjDLOwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 10:52:43 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013995BB8
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:52:38 -0700 (PDT)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 334D63F431
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681311156;
        bh=hvqL5OvNUsZFZ+sHFmNlvVzy0tXAUd/iqPbCE7rbU6Q=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=A/TfUhI3f/UPL84W3whA4eG0Wdx/lBn4TNfGEN0LKZDcUK/oGINKgfOLh1eAMNuba
         uuYLntYchwDKW7L7XNSdHHfVwG2CoKnRiH2PbZklQqTbzu3o2qRkoofzgaWfNrwGLa
         3GcRW+KmnPXrznnwrJuZw50iAiHA6GK7iWPpmuH+MpgdkaLK/Pz5Ii9GyQCcstwEAy
         CNO4u8yG2plPke5k6k3KUxiFUF5WIyZPvpkWSbYp2gXX65Nt6TBFX4Rz6yZHusS6+R
         8zmD+tUN46vcFshXz2DzkByO42nEbyWU4jT4OBLXIDsZ6VltT916GfHPuQsYKsf487
         V3IAVkTBbxtbQ==
Received: by mail-yb1-f197.google.com with SMTP id l141-20020a252593000000b00b8f2fd76d41so3846262ybl.9
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 07:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681311155; x=1683903155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvqL5OvNUsZFZ+sHFmNlvVzy0tXAUd/iqPbCE7rbU6Q=;
        b=ndtVVjUEOUoDIsDuhYP3bz8cJTzUeVi5tAbhWWZWyGjgq+xNtpB3hcsEz4PYRvk8l+
         PDqYCssR0gBsp0egjJROpbEilQYGIfWXWpNHNEdFObuVG9vW8IF//yk7aPC1Yo2GP1aj
         gO7v3X1ExnAJJY3wcMFzSuOifJVX3piSAdimCYtPpeH8UhJ4B7+wagUT75DfXiQpnznQ
         ehvBR4/FdQCFvv0f9E/5L8pds3xeAhWjdSMzfBs0apIXFLxPAqqnZgy43YJTGimsWWsi
         XkVXHY8CzWSi/T15dhGY4ckvhJxJZeisMFc7SyMVCH8yKuriPR4JIE9XPFWnNOJrb07J
         kaCQ==
X-Gm-Message-State: AAQBX9eqhIVFRrTgR4dKUhsxXvNmCGk5LWFSy/4ricB+e12B5SkjWhE0
        //kuF6hVC0f3DPPOOWGhIqWUYGV00JTVpaWpG/8tZ6RuaQnQSYCDYb+KscxglSqG4+72VWpRfyQ
        fqCPkX5nvVul1ab2ngmgERqi7tmHiwc/L5B9uG1wLN0s1Og==
X-Received: by 2002:a25:d884:0:b0:b8e:f1ef:a144 with SMTP id p126-20020a25d884000000b00b8ef1efa144mr2178693ybg.0.1681311155118;
        Wed, 12 Apr 2023 07:52:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350YCHx1IlZRvzchQUAJk2tjUBg0HPj0JYKDBVhf6geq3Hy3rc7/eGhsBMiMfc3b+M7sGcaUGyylOozZ3OjdEFZ8=
X-Received: by 2002:a25:d884:0:b0:b8e:f1ef:a144 with SMTP id
 p126-20020a25d884000000b00b8ef1efa144mr2178685ybg.0.1681311154914; Wed, 12
 Apr 2023 07:52:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230404122652.275005-1-aleksandr.mikhalitsyn@canonical.com>
 <20230404122652.275005-2-aleksandr.mikhalitsyn@canonical.com> <20230411224737.00001d67.zhi.wang.linux@gmail.com>
In-Reply-To: <20230411224737.00001d67.zhi.wang.linux@gmail.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 12 Apr 2023 16:52:23 +0200
Message-ID: <CAEivzxfxm9Kg-ap9QeceGgTeCd0du7FrH7Kmi2dRZH6gah-8HQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: SVM: free sev_*asid_bitmap init if SEV init fails
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 9:47=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com>=
 wrote:
>
> On Tue,  4 Apr 2023 14:26:51 +0200
> Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com> wrote:
>
> > If misc_cg_set_capacity() fails for some reason then we have
> > a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
> > not a case right now, because misc_cg_set_capacity() just can't
> > fail and check inside it is always successful.
> >
> > But let's fix that for code consistency.
> >
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: St=C3=A9phane Graber <stgraber@ubuntu.com>
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> >  arch/x86/kvm/svm/sev.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index c25aeb550cd9..a42536a0681a 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2213,8 +2213,13 @@ void __init sev_hardware_setup(void)
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
> >
> >       pr_info("SEV supported: %u ASIDs\n", sev_asid_count);
> >       sev_supported =3D true;
>
> It would be nice that another case can also be fixed:
>
>         sev_es_asid_count =3D min_sev_asid - 1;
>         if (misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count))
>                 goto out; /* <----HERE */

Nope.

There is no leak. Because when we are at this point then sev_supported
=3D true and everything is fine.

>
> Maybe it would be a good idea to factor out an common error handling path=
.
