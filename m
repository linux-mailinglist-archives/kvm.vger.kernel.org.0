Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEDC67A984
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 05:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjAYEL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 23:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYEL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 23:11:27 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0643F297
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 20:11:25 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z31so9516948pfw.4
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 20:11:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CJabib5NbUBwMrm5oU+0ZoPWuUCQhccu6rUbctVZbq8=;
        b=MJ66DxyKI49VCwmPR+axwQH0y85wmlFVSq9TUPPAnHXRAV8vX851P4gtGWmxNHNDeq
         bS1amqDX26pXVTiqFrtxNIi6hdGKcq4/VehjRISxME7zSA4XdJ2dZH3n3SveQF1AQSw1
         nCFDJQxzVRihLQeUEuYWkPr/F3BM0PM9YKvOwAypAhcLPv1jzJ6WxjrHtlINRIbmcb49
         uJMegsDmsI04npoSPRMONp2QbUbn1cLrDxZH1LXLMpH21OvyfPCJ3B4h1h1Jzs7z/cCx
         wMVoW3whFO+aQY+/rJUtzcaMn4RV3qA0S9RObUkkkVf65euA2kBuCb8i/N9yg2a0B9NX
         z8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CJabib5NbUBwMrm5oU+0ZoPWuUCQhccu6rUbctVZbq8=;
        b=HYXuX3Jh3iE7CgVI60gmgY4Xbop3xjow1e9bq4TXVeD6Z85aY0w1Is4eBQzcXRd+pC
         phsCPgMmfuHfthlyouYVNSJuXiI/UfDfCs8gV/dlnkzjDyir6b4YKAUIiPrwSSbkhK+7
         niufZTebm5B03wtg054YeM/tpzNEnbDoT7xi3YDOZAiQwzcv0rHk9/pkYVXEEPgH2flm
         mWGL29UgvayD1J3+FyeRiRRK/bOj7HxADtwUgaBdoCG6izBZMuu5UmCc5eh7sVBcn8nU
         7hBEj7vzo5fvkC3bFzVr5Z/U8vfQLccB8Fxb1ok4fRT/iq1bLtMWbL5RPF+TKaOSIyY7
         jL/Q==
X-Gm-Message-State: AFqh2koKcIEzhXXsS9+MQjp/OzXT0zzumJgveIYaAftPIA0BbmAyfAuO
        KGxBwAhJBpMWxhmvmwdesvwzsQ6pk0Pp+25ymS0S5g==
X-Google-Smtp-Source: AMrXdXs3GPep6mt4hQqbDAb5KAIILk+feJKO4chYHRNTzVLCZFDczi5HHfp9XecXGhiiD5HVLbFbgqOWgKYeDjxV8f0=
X-Received: by 2002:a05:6a00:2992:b0:58d:b26a:6238 with SMTP id
 cj18-20020a056a00299200b0058db26a6238mr3885279pfb.84.1674619884776; Tue, 24
 Jan 2023 20:11:24 -0800 (PST)
MIME-Version: 1.0
References: <20230109211754.67144-1-ricarkol@google.com> <20230109211754.67144-4-ricarkol@google.com>
 <CAAeT=FxoS2-cmMe-3FeXPXcvE4wNosZeZy2RGPXz5xisq5fj7A@mail.gmail.com> <Y9CRxb2YvPtX340D@google.com>
In-Reply-To: <Y9CRxb2YvPtX340D@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 24 Jan 2023 20:11:08 -0800
Message-ID: <CAAeT=FyP0658CNXT6csZpvMvZ4n+X5igLw4W9z0jQTs12y3aCQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] arm: pmu: Add tests for 64-bit overflows
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oliver.upton@linux.dev
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

On Tue, Jan 24, 2023 at 6:19 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Jan 18, 2023 at 09:58:38PM -0800, Reiji Watanabe wrote:
> > Hi Ricardo,
> >
> > On Mon, Jan 9, 2023 at 1:18 PM Ricardo Koller <ricarkol@google.com> wrote:
> > > @@ -898,12 +913,12 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
> > >
> > >         pmu_reset_stats();
> >
> > This isn't directly related to the patch.
> > But, as bits of pmovsclr_el0 are already set (although interrupts
> > are disabled), I would think it's good to clear pmovsclr_el0 here.
> >
> > Thank you,
> > Reiji
> >
>
> There's no need in this case as there's this immediately before the
> pmu_reset_stats();
>
>         report(expect_interrupts(0), "no overflow interrupt after counting");
>
> so pmovsclr_el0 should be clear.

In my understanding, it means that no overflow *interrupt* was reported,
as the interrupt is not enabled yet (pmintenset_el1 is not set).
But, (as far as I checked the test case,) the both counters should be
overflowing here. So, pmovsclr_el0 must be 0x3.

Or am I misunderstanding something?

Thank you,
Reiji


>
> >
> > >
> > > -       write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> > > -       write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
> > > +       write_regn_el0(pmevcntr, 0, pre_overflow);
> > > +       write_regn_el0(pmevcntr, 1, pre_overflow);
> > >         write_sysreg(ALL_SET, pmintenset_el1);
> > >         isb();
> > >
>
