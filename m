Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD5D5332ED
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 23:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbiEXVWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 17:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234771AbiEXVWX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 17:22:23 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F4E71A24
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 14:22:21 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id c19so19852405lfv.5
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 14:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DJvYQ4FFCPyuadXhZj4ygcZwDvHnL4qXPBlAqnAyUKA=;
        b=f9wZts0q2u5dn86EKSVttrU+UGGMKzIaWgeETwtCKatSsrt/hra+S8DVTDPxiiNFEC
         gqRrjOSQNWxZuI0LM16ijuyLylMuw2mrPkBaj0ynvuFH73/jQkKH4DL68lEq4jvBYt1a
         dfD3PBrkWwl9SWV9S/KZZAgNljG0iypVMLIh5SPd58uDYrlQm/nrkxAsIK9HYW2IQh0X
         BigNfwVafTYiunUivVZVFX3K4KoxtHqGyrw0yCz/iQTk6fmEZUCAo6rMzW5SlAvzsoYb
         X5nCImFh+iCyxzMdFdov68m+iBXyxUGcUNFKXZhfPze3Nn2iWTYpozXVLUd9g6AmCO88
         E7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DJvYQ4FFCPyuadXhZj4ygcZwDvHnL4qXPBlAqnAyUKA=;
        b=D2aJw7fjRLPUOdmhlj/ESqq9VpeqgUgWph2ZD380yPoSVBPP2lWF8rlvxCoLX5ducO
         /2U3e+wr08Qvl8pflEX6YvQW2Kl2p+uLvhvgzBCZslEQPnRk62Mcdh5/Ud169FJWvrKf
         Fur7Yl1r2pD4oyhEfp/4opQo+NamCs+/zCbjSzPUyKFLrrpOiyxD2xlSdIG+QhGu/OXH
         agosGfaiNUOfpqConlbN5AlMig7eGp0Cp1lSPds0wFkSyhXNJxHAgcJF5lKJ2Ah5SA75
         GDk91U2qgLIcE9yQvXTl56DoF3VSha1cC1Wl9O1HKi7VMNaT6CVmmxzkshIg198D4Q0c
         EhOw==
X-Gm-Message-State: AOAM533RCDx4j1zfKkoNNlVz2gn+6xKBAGk4mTEevpI9L9Z7wPYnAU4c
        F3iMYgimTsVTu2ndX5RbKnDLo6be6bfkMXDc6PIhIg==
X-Google-Smtp-Source: ABdhPJxbMHGpIBEJE4JcHDBGIb8ib80HAwEQcLkMEcjk7iJeSQySjA1/lUH7QaejWuxX+xbb2la20zAEohK+iCQAQvE=
X-Received: by 2002:a05:6512:1092:b0:478:689e:a8dc with SMTP id
 j18-20020a056512109200b00478689ea8dcmr10479585lfg.33.1653427339491; Tue, 24
 May 2022 14:22:19 -0700 (PDT)
MIME-Version: 1.0
References: <Yn2ErGvi4XKJuQjI@google.com> <20220513010740.8544-1-cross@oxidecomputer.com>
 <20220513010740.8544-3-cross@oxidecomputer.com> <Yn5skgiL8SenOHWy@google.com>
In-Reply-To: <Yn5skgiL8SenOHWy@google.com>
From:   Dan Cross <cross@oxidecomputer.com>
Date:   Tue, 24 May 2022 17:22:08 -0400
Message-ID: <CAA9fzEEjU9y7HdNOkWTjEtxPDNxTh_PDBWoREGKW2Y2aarZXbw@mail.gmail.com>
Subject: Re: [PATCH 2/2] kvm-unit-tests: configure changes for illumos.
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022 at 10:35 AM Sean Christopherson <seanjc@google.com> wrote:
> Adding the official KUT maintainers, they undoubtedly know more about the getopt
> stuff than me.

Thanks.

> On Fri, May 13, 2022, Dan Cross wrote:
> > This change modifies the `configure` script to run under illumos
>
> Nit, use imperative mood.  KUT follows the kernel's rules/guidelines for the most
> part.  From Linux's Documentation/process/submitting-patches.rst:
> [snip]

Done locally, but see below.

> > diff --git a/configure b/configure
> > index 86c3095..7193811 100755
> > --- a/configure
> > +++ b/configure
> > @@ -15,6 +15,7 @@ objdump=objdump
> >  ar=ar
> >  addr2line=addr2line
> >  arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
> > +os=$(uname -s)
> >  host=$arch
> >  cross_prefix=
> >  endian=""
> > @@ -317,9 +318,9 @@ EOF
> >    rm -f lib-test.{o,S}
> >  fi
> >
> > -# require enhanced getopt
> > +# require enhanced getopt everywhere except illumos
> >  getopt -T > /dev/null
> > -if [ $? -ne 4 ]; then
> > +if [ $? -ne 4 ] && [ "$os" != "SunOS" ]; then
>
> What does illumos return for `getopt -T`?

Sadly, it returns "0".  I was wrong in my earlier explorations
because I did not realize that `configure` does not use `getopt`
aside from that one check, which is repeated in `run_tests.sh`.

I would argue that the most straight-forward way to deal with
this is to just remove the check for "getopt" from "configure",
which doesn't otherwise use "getopt".  The only place it is
used is in `run_tests.sh`, which is unlikely to be used directly
for illumos, and repeats the check anyway.

> Unless it's a direct collision with
> the "old" getopt, why not check for illumos' return?

It collides with "legacy" getopt. :-(

> The SunOS check could be
> kept (or not).  E.g. IMO this is much more self-documenting (though does $? get
> clobbered by the check?  I'm terrible at shell scripts...).

I think it is more or less moot now, but "$?" does get clobbered
by the check.

> if [ $? -ne 4 ] && [ "$os" != "SunOS" || $? -ne 666 ]; then
>
>   Test if your getopt(1) is this enhanced version or an old version. This
>   generates no output, and sets the error status to 4. Other implementations of
>   getopt(1), and this version if the environment variable GETOPT_COMPATIBLE is
>   set, will return '--' and error status 0.

Sigh. That's precisely what the illumos version does. :-(

But it's perhaps worth pointing out that `getopt` isn't used
by `configure` aside from just that check. Does it, perhaps,
make more sense just to remove it from `configure` entirely?

        - Dan C.
