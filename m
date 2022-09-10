Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40E15B4439
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 07:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiIJFXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 01:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIJFXM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 01:23:12 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EA66D9F5
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 22:23:11 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id m66so3711353vsm.12
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 22:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=m3/TehbQGopN0M9TyC9OJc2nnGFxBuSLpVkEhsafx4k=;
        b=BupYcGJg9AgPWkfyysBwwMLg4S4djndS4b8GNGkuCLJJ18z25OJ2w+frXS7k4fBl4G
         aPvUrfbdQ6VdMEmPhE/0agab9DcDmlHIis6nZJ71sNgWyPfG7fPrgtxEa5j0D2aRaVP1
         yhzoRbYAdFEJQ13hQZ6Hg3kKiSNzhVsSyLr9YTM0iqwivIOMftowbZCozbMEy0Pqh6tj
         yJZLL47OgGmE0h2sK+SC+l6HgviJ0nFjlChUQSN45auJlO9t51yheC917e4yFRFCkh98
         U8iOUdEaLjhbWckM0UdWSzSBn57oIaVaTuVWq2kUBf3wL88j+1CdehSP+/ya1uhAkfkZ
         Hj4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=m3/TehbQGopN0M9TyC9OJc2nnGFxBuSLpVkEhsafx4k=;
        b=JESKDvl6VSXeCYhv5Vi+FYG89aTv/dOXPW5TUZ0yVvj+0dbx7qIwQHcO2f7JHANNGn
         bJ3x3ZgNOKBxhHsp4JubX1tJkHkp0EbVb13/9szNGxzxOC3P2UiFiV9DU1flloZGMKmQ
         4RfQ3xrNjiF6N+nhueEZmQXmxzdiM/v3r0zbsy3rZ3z8oDRTFqoqkE6e40eRSJm0IMM5
         nKvgtdJxkqPyhTDQR9YOVrTShT38hxNpOq4qz7fZeElYyblhO5lRHUzEpXmUT1iJn57a
         BNh1OHzJEgjsrN5AYYG30UTHwlIJBvj/upKVs3zX3aVhss8XUnDR26Zw9rhPeTL0FvkJ
         7DHg==
X-Gm-Message-State: ACgBeo2SDIQMyz6Yjto4i32Sw5chU2989qL195nNal6PBTRuvboS+pVx
        0GX6g2oiOlRJLHcykCNJ5bmy2odQcdlaxyLiipomTw==
X-Google-Smtp-Source: AA6agR4DtbZYwWcmEOuomvY/UVjB1Qrj8H1jJ1/4wFImXOy8qch167gdgjlubbth+u7yjOIg+R1jIwbAIfws9wKDpNg=
X-Received: by 2002:a05:6102:3fa0:b0:392:b32a:2a99 with SMTP id
 o32-20020a0561023fa000b00392b32a2a99mr6404945vsv.63.1662787390687; Fri, 09
 Sep 2022 22:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220825050846.3418868-1-reijiw@google.com> <20220825050846.3418868-8-reijiw@google.com>
 <CAAeT=FxJLykbrgKSC6DNFr+hWr-=TOq60ODFZ7r+jGOV3a=KWg@mail.gmail.com>
 <YxuflDM6utJbdZa1@google.com> <YxuhkvMh5cAtONKe@google.com>
In-Reply-To: <YxuhkvMh5cAtONKe@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 9 Sep 2022 22:22:54 -0700
Message-ID: <CAAeT=Fw774cEEPwQ7Brb0x2jhMxn625ms_814cNaGoXY29A9hw@mail.gmail.com>
Subject: Re: [PATCH 7/9] KVM: arm64: selftests: Add a test case for a linked breakpoint
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

> > > > -static void guest_code(uint8_t bpn, uint8_t wpn)
> > > > +static void guest_code(uint8_t bpn, uint8_t wpn, uint8_t ctx_bpn)
> > > >  {
> > > > +       uint64_t ctx = 0x1;     /* a random context number */
> > > > +
> > > >         GUEST_SYNC(0);
> > > >
> > > >         /* Software-breakpoint */
> > > > @@ -281,6 +310,19 @@ static void guest_code(uint8_t bpn, uint8_t wpn)
> > > >                      : : : "x0");
> > > >         GUEST_ASSERT_EQ(ss_addr[0], 0);
> > > >
> > >
> > > I've just noticed that I should add GUEST_SYNC(10) here, use
> > > GUEST_SYNC(11) for the following test case, and update the
> > > stage limit value in the loop in userspace code.
> > >
> > > Or I might consider removing the stage management code itself.
> > > It doesn't appear to be very useful to me, and I would think
> > > we could easily forget to update it :-)
> > >
> > > Thank you,
> > > Reiji
> > >
> >
> > Yes, it's better to remove it. The intention was to make sure the guest
> > generates the expected sequence of exits. In this case for example,
> > "1, .., 11, DONE" would be correct, but "1, .., 11, 12, DONE" would not.
>
> Sorry, the correct sequence should be "1, .., 10, DONE". And also, what
> I meant to say is that *original* intention was to check that, which
> wasn't actually completed as the incorrect sequence would also succeed.

Thank you for the comments and explaining the original intention.
I will remove that.

Thank you,
Reiji
