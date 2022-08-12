Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF5591414
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 18:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbiHLQk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 12:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238127AbiHLQkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 12:40:20 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98095B4A
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:40:13 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id x2so735826ilp.10
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=fr7wSAaWZQzZE8YplyY79vZ1Pg9eKpAl7JVdOfxdkS4=;
        b=Znat7kNMG6U8e0YzasGOmTIajZteVmA258af0kj5DoK9ILXyUflOsA9HP+5tFwOT3H
         xPurFUQmfsjqEvcsmC1qfSZCfJ7Tjj9pw8UPIdF0iUdQGm7ijtmXl083eNuRTGJLXsON
         O8fdUHS1T2+SYi/ezCJ7jzOfgBxy8dnC+NJuZzkDBxAGNN8/10vnPNTsMC72/SiJi9+o
         CVCQe8YHExqAe3TtvbC/FJljA7wIlqlJYsiavZBoNnKwJuNb6PrgwCwFJ/wOB6/rbHTl
         vjsL13BJqapmv+JPYxrlFYjrLcBENMxJ+Nyo7O6NHo/zrcrrkvlWkAJDeQ353WoXa/EN
         ZGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fr7wSAaWZQzZE8YplyY79vZ1Pg9eKpAl7JVdOfxdkS4=;
        b=kRJDRT+QYe/NNjY8MU2L2dbLpvZlJ9WujZlvlPJHFkyWEGXFiDyKftaSZVK+xhGXWI
         fHBsdUuih9kOKMyAQI7OtLhvqqORY09elU2w2ka6Em3DalTeiZNy9+yigY1FKlwfmhNc
         +tl2ngwpjcxMNZgk5SfG6pXQGxqPVGMjRaWzBIac/JvWM1+7Hfh4i1FLp3dqrFrk/xTt
         u1n6pdHl5VJp6fRRoGYC9Ermarqg+rcHVXqMSaj8g01F8RKPAGCPrWiRZoWnhhZAgoyf
         VcHAB92pdvdaKR/ICVaXxK+IPcY9GCiVz0Gz5zNiuv8Ywx+SC6yWnzOv80Vv6Ym92Y6O
         gx6Q==
X-Gm-Message-State: ACgBeo3/Vgs2+w+2cNNtBhyww0tt2S5WM7UnXnAg2qKLaPkvRvgRGUWZ
        CQmrkBOcgPkFgp92jgwsqbyiKQ==
X-Google-Smtp-Source: AA6agR41hh6r2oB4Q7Zn0KWD52sj2BU2CVvtVJxMDqArS52pGreiNTpB2jLxmsGMWLVCPL2UxP2qqw==
X-Received: by 2002:a92:cd8e:0:b0:2df:3572:5b0 with SMTP id r14-20020a92cd8e000000b002df357205b0mr2270575ilb.226.1660322412491;
        Fri, 12 Aug 2022 09:40:12 -0700 (PDT)
Received: from google.com (30.64.135.34.bc.googleusercontent.com. [34.135.64.30])
        by smtp.gmail.com with ESMTPSA id a13-20020a92d58d000000b002dd6c2cf81dsm993224iln.36.2022.08.12.09.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 09:40:11 -0700 (PDT)
Date:   Fri, 12 Aug 2022 16:40:08 +0000
From:   Colton Lewis <coltonlewis@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Randomize page access order
Message-ID: <YvaCaKCVnmNmW8Uh@google.com>
References: <20220810175830.2175089-1-coltonlewis@google.com>
 <20220810175830.2175089-4-coltonlewis@google.com>
 <YvREA1VJA3ryF+io@google.com>
 <YvZ+rTKd8dmezzgu@google.com>
 <CALzav=d-_uiDBgcELbHCXT3aJ0jXu29p=HeYMaB+ngQQoHiVXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=d-_uiDBgcELbHCXT3aJ0jXu29p=HeYMaB+ngQQoHiVXw@mail.gmail.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 09:28:05AM -0700, David Matlack wrote:
> On Fri, Aug 12, 2022 at 9:24 AM Colton Lewis <coltonlewis@google.com> wrote:
> >
> > On Wed, Aug 10, 2022 at 04:49:23PM -0700, David Matlack wrote:
> > > On Wed, Aug 10, 2022 at 05:58:30PM +0000, Colton Lewis wrote:
> > > > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > > index 3c7b93349fef..9838d1ad9166 100644
> > > > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > > @@ -52,6 +52,9 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> > > >     struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_idx];
> > > >     uint64_t gva;
> > > >     uint64_t pages;
> > > > +   uint64_t addr;
> > > > +   bool random_access = pta->random_access;
> > > > +   bool populated = false;
> > > >     int i;
> > > >
> > > >     gva = vcpu_args->gva;
> > > > @@ -62,7 +65,11 @@ void perf_test_guest_code(uint32_t vcpu_idx)
> > > >
> > > >     while (true) {
> > > >             for (i = 0; i < pages; i++) {
> > > > -                   uint64_t addr = gva + (i * pta->guest_page_size);
> > > > +                   if (populated && random_access)
> > >
> > > Skipping the populate phase makes sense to ensure everything is
> > > populated I guess. What was your rational?
> >
> > That's it. Wanted to ensure everything was populated. Random
> > population won't hit every page, but those unpopulated pages might be
> > hit on subsequent iterations. I originally let population be random
> > too and suspect this was driving an odd behavior I noticed early in
> > testing where later iterations would be much faster than earlier ones.
> >
> > > Either way I think this policy should be driven by the test, rather than
> > > harde-coded in perf_test_guest_code(). i.e. Move the call
> > > perf_test_set_random_access() in dirty_log_perf_test.c to just after the
> > > population phase.
> >
> > That makes sense. Will do.
> 
> Ah but if you get rid of the table refill between iterations, each
> vCPU will access the same pages every iteration. At that point there's
> no reason to distinguish the populate phase from the other phases, so
> perhaps just drop the special case for the populate phase altogether?

You're right. Will do.
