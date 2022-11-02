Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411CC61702F
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiKBWDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiKBWDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:03:22 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B93FE6
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:03:21 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id o70so194483yba.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=53rtM2tOKUZC17mzsEdWurdRWDAbb+IFlx/I3QaJfho=;
        b=N1VphNwdxb/NhSkHMiJfGFqNvaKDulnWXGieR7FCQEci8+vuCMZly07jXuBfaWgIbt
         bWDKRNhBF2T61PoR6ygPtOpiR69ieu22Hbw02NDaW+UeACLWEpm4GVe+orHtMk1qaIwN
         ybVl7XhfTCW9vKNX4MMEpS+GQA3e0WubsPqcocViZJyZRTo79RpkbBTB1jQu7wiRB58/
         5m2pG5Oad7FHN6oEtQ/xSlqL5e1Awl9scBTWpTefTerEhiTW2zmlF5DviyxF/zRdRzt8
         1cAE2SegvCV2DRcgZX2s08V0A+rVPJ6xxRbuWnp2UQmUFOOKg3f+SDWotCcdR9x8eLjr
         SOHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=53rtM2tOKUZC17mzsEdWurdRWDAbb+IFlx/I3QaJfho=;
        b=guntXpPaouLk1uVCC1o85jSjyUEKAUvDebZHJgGIR/WXcN54q9UySBPC2yTAfczTWl
         +NyQdEVvml6KoMjJGuhF0B4HvltWW6upnCj8jDedu+Ejtv5U9t9jVY2m7smf51tBMrPZ
         ShfqgJiF9gVKESfZwVo3Y0CK2cck5h7NPZ2CYuo4Es2FCmTW71gc0SDXTuZGCDBIvq55
         WzovGjUFXLzYpAhOPbxPviyvWBZ7jzti0fEF2X1ioSmZbo1Sx8jEj8B2pYQYb23DdnkD
         vDYwuOmwzLk9eRDuRP6TRuM6tjlraU4+rC/4YVqcnthttcJLELTi13R483ditdL1VagL
         dNwQ==
X-Gm-Message-State: ACrzQf3ez4wQHhlr4CI4oDc+0I9DPxmqgT2E14mqj0TvV60aUcFWpKOp
        kdIsBUTNp7/rmgX1eDxMRCNb04l7zD+jKwrToC2/Jg==
X-Google-Smtp-Source: AMsMyM70buN6c220kX5KZZX2DLGDXHZ7CJ8iKWrl0ApYH+YpzwI2LQG2UTaHQPRkDlBY2acJUs+UljbKUW4io1WAHL8=
X-Received: by 2002:a05:6902:1244:b0:6ca:cbd8:9310 with SMTP id
 t4-20020a056902124400b006cacbd89310mr25934182ybu.0.1667426600406; Wed, 02 Nov
 2022 15:03:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com> <20221031180045.3581757-5-dmatlack@google.com>
 <Y2ATsTO8tqs4gtz/@google.com> <CALzav=eqiCbYaNUgSEsZrRGEA2pv3x5j=oUvbm=_Gho4t50H1g@mail.gmail.com>
 <Y2K/BvYwX06lsOH+@google.com>
In-Reply-To: <Y2K/BvYwX06lsOH+@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 2 Nov 2022 15:02:54 -0700
Message-ID: <CALzav=dy7QU6ZTEzkm8_0Lox3E7VS6vUjpb93AFXUBkwChRXdQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/10] KVM: selftests: Move flds instruction emulation
 failure handling to header
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

On Wed, Nov 2, 2022 at 12:03 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Nov 02, 2022, David Matlack wrote:
> > On Mon, Oct 31, 2022 at 11:28 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Oct 31, 2022, David Matlack wrote:
> > > > +
> > > > +static inline void assert_exit_for_flds_emulation_failure(struct kvm_vcpu *vcpu)
> > >
> > > I think it makes sense to keeping the bundling of the assert+skip.  As written,
> > > the last test doesn't need to skip, but that may not always hold true, e.g. if
> > > the test adds more stages to verify KVM handles page splits correctly, and even
> > > when a skip is required, it does no harm.  I can't think of a scenario where a
> > > test would want an FLDS emulation error but wouldn't want to skip the instruction,
> > > e.g. injecting a fault from userspace is largely an orthogonal test.
> > >
> > > Maybe this as a helper name?  I don't think it's necessary to include "assert"
> > > anywhere in the name, the idea being that "emulated" provides a hint that it's a
> > > non-trivial helper.
> > >
> > >   static inline void skip_emulated_flds(struct kvm_vcpu *vcpu)
> > >
> > > or skip_emulated_flds_instruction() if we're concerned that it might not be obvious
> > > "flds" is an instruction mnemonic.
> >
> > I kept them separate for readability,
>
> Ha, and of course I found assert_exit_for_flds_emulation_failure() hard to read :-)
>
> > but otherwise I have no argument against bundling. I find skip_emulated*()
> > somewhat misleading since flds is not actually emulated (successfully). I'm
> > trending toward something like handle_flds_emulation_failure_exit() for v4.
>
> How about "skip_flds_on_emulation_failure_exit()"?  "handle" is quite generic and
> doesn't provide any hints as to what the function actually does under the hood.

LGTM. Paolo can you apply the name change when queueing v4 (assuming
there are no other comments)? If not I'd be happy to send a v5.
