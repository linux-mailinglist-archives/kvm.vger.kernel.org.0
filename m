Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC05726689
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 18:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjFGQzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 12:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjFGQzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 12:55:47 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2731FCF
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 09:55:44 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f7359a3b78so3425e9.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 09:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686156943; x=1688748943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BuB+J9OJiWjd9yxS5sNLGWohVKiQULf5pvFk8yLXcnM=;
        b=Q+dliuutUehMxCWXvzikb2CV2MUzmdXpORu8HYlGMa2zcl5poFh40i68ffBgrCJQUO
         K5jrA4jMj7pESJR0usiuhmDTmHh6iVRzf7b9xiNJYDrCWlZhLT2jtr1lnRQLsKn9/4On
         2FEODYY1Xzefbw5qS87qTNaBY6RKAESRhuo9kSRgXA2r/E7HaP7j7ufscWcTbmLXt3HM
         rdjpd2Wb6wsZA2jcKKT5CgRlO2xL+98g4yIQGiBnxBhe2GCMRk3ApLd6korKvQ7Gfpa9
         osXw4oOF4ds4DKUDAJnkgS4HPXZEXQKIczI3F2a/34eRWaF5lNCTXpXoXJRukNrfUC2p
         3ZMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156943; x=1688748943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BuB+J9OJiWjd9yxS5sNLGWohVKiQULf5pvFk8yLXcnM=;
        b=THAgJlxdXGE59u82I1qSOeU8z062rs9zcUDKt78DVrSN9p4PVjWVfr7/c3rH8gLcEv
         Kz2Nu8zFVbj22AURj6mhfYZJpwxu6l6cwsJ8Qwc2LfEK891MV0Poylf/0R9DJNkoXjv1
         sMxE/mMy09xr6QI9cEOAzAdRwG2TxakJNboUPZ5SmVESRZYxDt9gVMtRmFDhR+cjzfAB
         l8DP3hGbtRUIysy7IC3tD80XsKlK+Boa9unMLAbTaWRRO8WVpdpOsg12BuuC5a77qKZ/
         pFB7RDfvzGJSBI9c8+pKEk3CxXmI+8wOTaIKnstB+qLI5KoJN3Gd26c64ERX5P+OF8CR
         GkIw==
X-Gm-Message-State: AC+VfDxDPEDCeUQGXZ49cQztpnOCFV10kBOVcGsW2lwPpVPC8uZNGpHx
        g9/Ls4Di0MpOVcYLlyLHY2Z3HnkH3hTokANMQtHiHA==
X-Google-Smtp-Source: ACHHUZ4A/FaLH8B6Zzq/2xRNdio9OzR9h0M3+N9fYsYiZCJ2OWlJK2jJ2t8kWdWUt85AocDgXdHolRGCaY9iefbnrCQ=
X-Received: by 2002:a05:600c:19cd:b0:3f7:ba55:d03b with SMTP id
 u13-20020a05600c19cd00b003f7ba55d03bmr224848wmq.2.1686156943140; Wed, 07 Jun
 2023 09:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com>
 <20230424225854.4023978-6-aaronlewis@google.com> <ZH5kkIWHCfDQy3EI@google.com>
In-Reply-To: <ZH5kkIWHCfDQy3EI@google.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 7 Jun 2023 16:55:30 +0000
Message-ID: <CAAAPnDEV6TE0h4Xu65JX=8VJCpa3iBe7=zFHxKmGQFs-ofBShQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] KVM: selftests: Add ucall_fmt2()
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 5, 2023 at 10:41=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Apr 24, 2023, Aaron Lewis wrote:
> > Add a second ucall_fmt() function that takes two format strings instead
> > of one.  This provides more flexibility because the string format in
> > GUEST_ASSERT_FMT() is no linger limited to only using literals.
>
> ...
>
> > -#define __GUEST_ASSERT_FMT(_condition, _condstr, _fmt, _args...)      =
         \
> > -do {                                                                  =
         \
> > -     if (!(_condition))                                               =
         \
> > -             ucall_fmt(UCALL_ABORT,                                   =
         \
> > -                       "Failed guest assert: " _condstr " at %s:%ld\n =
 " _fmt, \
> > -                       , __FILE__, __LINE__, ##_args);                =
         \
> > +#define __GUEST_ASSERT_FMT(_condition, _condstr, _fmt, _args...)      =
    \
> > +do {                                                                  =
    \
> > +     if (!(_condition))                                               =
    \
> > +             ucall_fmt2(UCALL_ABORT,                                  =
    \
> > +                        "Failed guest assert: " _condstr " at %s:%ld\n=
  ",\
>
> I don't see any reason to add ucall_fmt2(), just do the string smushing i=
n
> __GUEST_ASSERT_FMT().  I doubt there will be many, if any, uses for this =
outside
> of GUEST_ASSERT_FMT().  Even your test example is contrived, e.g. it woul=
d be
> just as easy, and arguably more robusted, to #define the expected vs. act=
ual formats
> as it is to assign them to global variables.

The way the test was first set up I needed them to be globals, but as
it evolved I realized that requirement no longer held.  I kept them as
globals though to demonstrate they didn't have to be literals.  I
think that gives the API more flexibility and consistency.

>
> In other words, this
>
> #define __GUEST_ASSERT_FMT(_condition, _str, _fmt, _args...)             =
       \
> do {                                                                     =
       \
>         char fmt_buffer[512];                                            =
       \
>                                                                          =
       \
>         if (!(_condition)) {                                             =
       \
>                 kvm_snprintf(fmt_buffer, sizeof(fmt_buffer), "%s\n  %s", =
       \
>                              "Failed guest assert: " _str " at %s:%ld", _=
fmt);  \
>                 ucall_fmt(UCALL_ABORT, fmt_buffer, __FILE__, __LINE__, ##=
_args);\
>         }                                                                =
       \
> } while (0)
>
> is a preferable to copy+pasting an entirely new ucall_fmt2().  (Feel free=
 to use
> a different name for the on-stack array, e.g. just "fmt").
>
> > +                        _fmt, __FILE__, __LINE__, ##_args);           =
    \
> >  } while (0)
> >
> >  #define GUEST_ASSERT_FMT(_condition, _fmt, _args...) \
> > diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/tes=
ting/selftests/kvm/lib/ucall_common.c
> > index c09e57c8ef77..d0f1ad6c0c44 100644
> > --- a/tools/testing/selftests/kvm/lib/ucall_common.c
> > +++ b/tools/testing/selftests/kvm/lib/ucall_common.c
> > @@ -76,6 +76,30 @@ static void ucall_free(struct ucall *uc)
> >       clear_bit(uc - ucall_pool->ucalls, ucall_pool->in_use);
> >  }
> >
> > +void ucall_fmt2(uint64_t cmd, const char *fmt1, const char *fmt2, ...)
> > +{
> > +     const int fmt_len =3D 128;
> > +     char fmt[fmt_len];
>
> Just do
>
>         char fmt[128];
>
> (or whatever size is chosen)
>
> > +     struct ucall *uc;
> > +     va_list va;
> > +     int len;
> > +
> > +     len =3D kvm_snprintf(fmt, fmt_len, "%s%s", fmt1, fmt2);
>
> and then here do sizeof(fmt).  It's self-documenting, and makes it really=
, really
> hard to screw up and use the wrong format.
>
> Regarding the size, can you look into why using 1024 for the buffer fails=
?  This
> really should use the max allowed UCALL buffer size, but I'm seeing shutd=
owns when
> pushing above 512 bytes (I didn't try to precisely find the threshold).  =
Selftests
> are supposed to allocate 5 * 4KiB stacks, so the guest shouldn't be getti=
ng anywhere
> near a stack overflow.

D'oh! This is the result of a bad pattern used in the test.

vcpu_regs_get(vcpu, &regs);
regs.rip =3D (uintptr_t)guest_code;
vcpu_regs_set(vcpu, &regs);

I set the RIP, but not the RSP.  That makes the stack grow out of
control when called a lot like we do in this test.

It's also x86 specific and this test no longer lives in that directory.

For now I'll change the guest code to run in a loop to restart it, but
I've used this pattern before and it's useful at times.  Also, looping
forces me to sync a global for the guest, and I think I'd rather pass
the parameters directly into the guest code.  Maybe it would make
sense to implement proper support for this in the selftest library at
some point to allow us to use this pattern and have it be less error
prone.

With the fix we are able to set the size to the UCALL buffer size.



>
> > +     if (len > fmt_len)
>
> For KVM selftests use case, callers shouldn't need to sanity check, that =
should be
> something kvm_snprintf() itself handles.  I'll follow-up in that patch.
