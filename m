Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F8D5BEF03
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiITVOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 17:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiITVOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 17:14:09 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935F95E314
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:14:08 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id j8so2984538qvt.13
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 14:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Agf0ydyH3lvfdIB0A3sOYiuarFajFABIezvH4rNxspw=;
        b=nfs/3LaY9JFRyJv5qfyjx3eu+pv6j+U6nqhzZPn9NP13XyaQIG3FKthVhDBarD0V/T
         Tl/1pNCe4SE7uXJuuMCr6hYwgxyGHhFmXceJzQKU0dtSOQY0b+i3owk5CaOieDuM1ABC
         qlaEAujk4SRhR48sreuvRpdZrQhzNvBgxz8BLJj/5r+h3RpJUw+nnD7yefhNZSUM+xTI
         KwWt5MhU7qkaBRtX3lbwpXEnosmN9yGkIoy90LXj8pu74FsgCwBfIFCSrwNTbfvE80vI
         oYFQkINtSDgT4abJVHTf3U0G3V6F+6jzoAd2aEDGv8XVXSiUHrgnywI2pmSdmS5WB2dK
         S81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Agf0ydyH3lvfdIB0A3sOYiuarFajFABIezvH4rNxspw=;
        b=Xa9j1DXczgE0IQmI0T0vkpcdBJPYyowEgM1uFsie4c5BWX1EpRVuZS03QZ2ELtgjLN
         tQxg03ADEEv5g36LAowSXXlWbjNz4k7CooSMREthgcxwWtIdBOy4nNH1hecn1reCT8O7
         fF0fo7e0GG0gAP072qr5uwmln7LBO01wvdJ8nboj2NHmjBrvAN0HxIY/Uajy9GIM9gzP
         7VLPkOLa+mPj2xpii+W8Z+TACsQO9wMQf/GFhuXgDYvV99w9F4Nq8Mf+ebqDh7GIeUys
         d/MB0c7ntMJo1bDm4SaixQskt5194svhP5oZrxz5yv72fBWmtGgidgczFx4qWeuWfaIE
         5bzQ==
X-Gm-Message-State: ACrzQf3Fy7eGo9246Lry9riEwOb26wnDBUFw+to3T7C874ahvIn1qzmd
        NfnuOXlrPU1Vc1ieoFRAsvMBBPFkF1+tXz0pqFTtOQ==
X-Google-Smtp-Source: AMsMyM7uu14oj20jLahAdNydD1hSZ3ysWxunpLi4lSgq62xGNddbpISWtSqGMFvVDgi/esVyEp5iujKN37ZfeWi4Ss0=
X-Received: by 2002:a05:6214:1d0c:b0:4ad:1627:363 with SMTP id
 e12-20020a0562141d0c00b004ad16270363mr18131218qvd.56.1663708447592; Tue, 20
 Sep 2022 14:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com> <20220826231227.4096391-2-dmatlack@google.com>
 <2433d3dba221ade6f3f42941692f9439429e0b6b.camel@intel.com>
 <CALzav=cgqJV+k5wAymUXFaTK5Q1h6UFSVSKjZZ30akq-q0FNOg@mail.gmail.com>
 <CALzav=cuwyFTn6zz+fJqjKNs6XYx2-N61sgMQ9K5C-Z=a4STZg@mail.gmail.com> <d39458f94d13e6498272bbad609b577fbb67a861.camel@intel.com>
In-Reply-To: <d39458f94d13e6498272bbad609b577fbb67a861.camel@intel.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 20 Sep 2022 14:13:41 -0700
Message-ID: <CALzav=ex14tAH94eSy38y02M6LG8iGFMcT2DQ4p_KkSpu7f29g@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only parameter
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Sep 20, 2022 at 2:01 PM Huang, Kai <kai.huang@intel.com> wrote:
>
> On Tue, 2022-09-20 at 09:57 -0700, David Matlack wrote:
> > On Thu, Sep 1, 2022 at 9:47 AM David Matlack <dmatlack@google.com> wrote:
> > > On Tue, Aug 30, 2022 at 3:12 AM Huang, Kai <kai.huang@intel.com> wrote:
> > > > On Fri, 2022-08-26 at 16:12 -0700, David Matlack wrote:
> > [...]
> > > > > +#else
> > > > > +/* TDP MMU is not supported on 32-bit KVM. */
> > > > > +const bool tdp_mmu_enabled;
> > > > > +#endif
> > > > > +
> > > >
> > > > I am not sure by using 'const bool' the compile will always omit the function
> > > > call?  I did some experiment on my 64-bit system and it seems if we don't use
> > > > any -O option then the generated code still does function call.
> > > >
> > > > How about just (if it works):
> > > >
> > > >         #define tdp_mmu_enabled false
> > >
> > > I can give it a try. By the way, I wonder if the existing code
> > > compiles without -O. The existing code relies on a static inline
> > > function returning false on 32-bit KVM, which doesn't seem like it
> > > would be any easier for the compiler to optimize out than a const
> > > bool. But who knows.
> >
> > Actually, how did you compile without -O and is that a supported use-case?
>
> I just wrote a very simple userspace application and built it w/o using the -O
> (mostly out of curiosity) .
>
> Sorry I didn't check whether currently KVM uses -O to build or not.
>
> If needed, I can try to test in real KVM build and report back, but I need to do
> that later :)

Gotcha. No need to test further, but thanks for offering. I am going
to use `#define tdp_mmu_enabled false` in v3 regardless, to be
consistent with enable_sgx (see Sean's reply).

>
> >
> > I tried both CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE (-O2) and
> > CONFIG_CC_OPTIMIZE_FOR_SIZE (-Os) and did not encounter any issues
> > building 32-bit KVM with this series.
>
> Yes both -O2 and -Os will optimize the 'const bool' out to omit the function
> call, if I recall correctly.  In fact in my experience -O1 can also omit the
> function call, if I recall correctly.
>
> --
> Thanks,
> -Kai
>
>
