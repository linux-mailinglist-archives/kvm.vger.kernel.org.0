Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815EA53F26A
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 01:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbiFFXMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 19:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235218AbiFFXMN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 19:12:13 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2E6641F
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 16:12:11 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id x187so733249ybe.2
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 16:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HMYa5NiY0+tNheCQvRZgs2PeYcK66AtT6y4yEJ8Q2nw=;
        b=BzuPtwICl92nn405IDpleNoejSlfHoVolX0QcMDyWh5sJPX3d2ognqXZ948C603TGR
         18+yTMN80wJCnRVdFlaIx41/ACFMaDvO4aaRBZZlSggDG+xOpSAMZRnObzQIMd5U7ul/
         CnHYQuXfD77FoNUP8YeQj9BL1+rUJ6g93heCL1rsIRx6Dm6amYZnLIPHQcD/TYRJtcMP
         Kh3tkD6JdPKzYSXc5v8/Ru7C2GNwZ9UkZO3ov57Mnq2iJzEtSCXMge2wfm4co1nObCrp
         U+bDtijg3kpaAjCETQOmISqQQwkWVXkCv574qIbjLU1yg1sw8KvksEuMXZdcjJVGgtrt
         Qwpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HMYa5NiY0+tNheCQvRZgs2PeYcK66AtT6y4yEJ8Q2nw=;
        b=VMLIuv5k2vhUHfAqsDuLKu8ro0FTwc/S9dSbA8I8xtiU+w+72mdUxWTztsrR5Dsdbh
         fI/8UY6fjdu3gLJ9sEJix8B6WYLwG1ykcO/ij38kr8FxbtC/kGGSMq7dvqnN6DCtM3p9
         78JlAczhkIU4k9PU5C3lNlyFvNDQ1FHp23s13SxVxlYliugNU30ipwD6k1T3iI30Ob87
         K3ICcxU+BV5rcDjvfWsU4h7stH/ER+jTnC/W4fxBJx4vNQrZ7l/MtNEV+aKugXQ6Vu76
         KhUsignmi283SElvS/MX5/y7/dIfmogvMgwnSM5HbtdujxuZRHyQCx2k3NtL5V4hdTnm
         cyJQ==
X-Gm-Message-State: AOAM531zxiJC5m9KUAQB6HOk018opP8cWktvrubJ3Q6gJUAVWPESHDpy
        owy1dKjO+/XSr6hAf4TrwOMXIEFWQXUJhGlu2Q2qdg==
X-Google-Smtp-Source: ABdhPJziHntydMGuvWAEEmCBfrEoMiMhqH7PezWbdG7coriy0aPuwam2rZ4s4QGNqK+63/KbrpLg6bkGO315ti5GYks=
X-Received: by 2002:a05:6902:124c:b0:663:9db4:671c with SMTP id
 t12-20020a056902124c00b006639db4671cmr7080234ybu.543.1654557130742; Mon, 06
 Jun 2022 16:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220525230904.1584480-1-bgardon@google.com> <a3ea7446-901f-1d33-47a9-35755b4d86d5@redhat.com>
 <Yo+O6AqNNBTg7BMY@xz-m1.local> <a1fbab86-ece9-82e3-64fe-0a19a125513b@redhat.com>
 <CANgfPd8VqKYwr7fprie6h0y0cQEPLrbS5euMrBCjz7osypgkNQ@mail.gmail.com>
In-Reply-To: <CANgfPd8VqKYwr7fprie6h0y0cQEPLrbS5euMrBCjz7osypgkNQ@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 6 Jun 2022 16:11:59 -0700
Message-ID: <CANgfPd-MTxBB8c_jOHccNsWONoqUSJsvWFuEiUv=nHpRg-WWHA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/MMU: Zap non-leaf SPTEs when disabling dirty logging
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 26, 2022 at 9:00 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Thu, May 26, 2022 at 8:52 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 5/26/22 16:30, Peter Xu wrote:
> > > On Thu, May 26, 2022 at 02:01:43PM +0200, Paolo Bonzini wrote:
> > >> On 5/26/22 01:09, Ben Gardon wrote:
> > >>> +           WARN_ON(max_mapping_level < iter.level);
> > >>> +
> > >>> +           /*
> > >>> +            * If this page is already mapped at the highest
> > >>> +            * viable level, there's nothing more to do.
> > >>> +            */
> > >>> +           if (max_mapping_level == iter.level)
> > >>> +                   continue;
> > >>> +
> > >>> +           /*
> > >>> +            * The page can be remapped at a higher level, so step
> > >>> +            * up to zap the parent SPTE.
> > >>> +            */
> > >>> +           while (max_mapping_level > iter.level)
> > >>> +                   tdp_iter_step_up(&iter);
> > >>> +
> > >>>             /* Note, a successful atomic zap also does a remote TLB flush. */
> > >>> -           if (tdp_mmu_zap_spte_atomic(kvm, &iter))
> > >>> -                   goto retry;
> > >>> +           tdp_mmu_zap_spte_atomic(kvm, &iter);
> > >>> +
> > >>
> > >> Can you make this a sparate function (for example
> > >> tdp_mmu_zap_collapsible_spte_atomic)?  Otherwise looks great!
> > >
> > > There could be a tiny downside of using a helper in that it'll hide the
> > > step-up of the iterator, which might not be as obvious as keeping it in the
> > > loop?
> >
> > That's true, my reasoning is that zapping at a higher level can only be
> > done by first moving the iterator up.  Maybe
> > tdp_mmu_zap_at_level_atomic() is a better Though, I can very well apply
> > this patch as is.
>
> I'd be inclined to apply the patch as-is for a couple reasons:
> 1. As Peter said, hiding the step up could be confusing.
> 2. If we want to try the in-place promotion, we'll have to dismantle
> that helper again anyway or else have a bunch of duplicate code.

Circling back on this, Paolo would you like me to send another version
of this patch, or do you think it's good to go?

>
> >
> > Paolo
> >
