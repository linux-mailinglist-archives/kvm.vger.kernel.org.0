Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881F16C7234
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbjCWVQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCWVQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:16:38 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957352596B
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:16:37 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-5447d217bc6so417243937b3.7
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679606197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2OEgiy8kRfn9zuyqPppaPRzdHmJoduFoYpk+kIh9eLE=;
        b=pRRWbAh48lfcNAvf99/RkKBaRqPXGNuhCoyCh9MxNbE09bKpUU53/MOjY6AwRAG08n
         RgsnRGBRLadaJxtgMNYAkf6TI31R+TKb8pAPR3BlKf+mic17xBnWGeC6qDpJOkZ4Rb6r
         32j1TnfLPsVgxFzlZoQI33DTLCzyZskZtqaqL0VOQgvrrkclD0WLizqUB0im/dioS1gF
         olNocaFbhcB+ldhtxGsWEEW79drUTwTjDXqdlTuYGDbS+k6Xov8GMen5ZP/PUYZo4b9n
         58X6lcnql3KjPZRK+m67aI6pkySQZpaXPS8OjF0gbBxj+4IqbzuCyhOEi4VomBZ0DY3r
         ZSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679606197;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2OEgiy8kRfn9zuyqPppaPRzdHmJoduFoYpk+kIh9eLE=;
        b=McKrOzh8oo6VD/p6ynpEB1rUQQTSxdyfXuI35LV3ttrsq2YJhTuJiZuyp6ZKfHeBig
         ljrxfthdyAOj99KLtFJKNFxgRUlMG1uV1M5WSWi8CBFiqYOglq9sXMCjV0R3yvnIfs7b
         ccJmxS4vtGBSwYjKJ/pHNXUCTqcCSElxuxaqoJ6IH7V/PjzbFRStuHYh/0d7KNzdGN0s
         F3eeuExxxlp8m/+1gopA8l/xNEbVH+FqxXgD/KxtXtH1lmAgMj4W4REHsFLEPHvQef4b
         iGgWQR+Jzbar6ROYgldLsxL58B5vsQnSP3GyTNqvrUnBqMkBNZNeGhL5xeQl/mpwExye
         2ZMw==
X-Gm-Message-State: AAQBX9fouSfxYrQ6q+2wMOgK97sO6NLQy36XR0tqGCUYrZKOEDi7hw6W
        /xAZien3EnQKHJs4ivNUrmGFJnYDy1Ey1eou4xAonw==
X-Google-Smtp-Source: AKy350ZBgREPgebImKJt+6LJ2pxEcfrzp3SNRy7qekrZDFUH8U7LUWrbwspkr3moLfHjElRkbQVFkrxjlXdWJgfboMM=
X-Received: by 2002:a81:b70a:0:b0:541:a0cc:2a09 with SMTP id
 v10-20020a81b70a000000b00541a0cc2a09mr2587469ywh.7.1679606196784; Thu, 23 Mar
 2023 14:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-3-aaronlewis@google.com> <ZBy2tcQzERBpsoxz@google.com>
 <CAL715WKX6FXugfCYLqyoT4UKCYha7g_izvy2Djvg5zPkxa7JwQ@mail.gmail.com>
In-Reply-To: <CAL715WKX6FXugfCYLqyoT4UKCYha7g_izvy2Djvg5zPkxa7JwQ@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Thu, 23 Mar 2023 14:16:00 -0700
Message-ID: <CAL715WKbwRnk6BPSxzzcDpeEhEnJd8sjZHc+9ruV1sQ7iDsyJw@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Sean Christopherson <seanjc@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> >  static inline u64 kvm_get_filtered_xcr0(void)
> >  {
> > -       return kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
> > +       u64 supported_xcr0 = kvm_caps.supported_xcr0;
> > +
> > +       BUILD_BUG_ON(XFEATURE_MASK_USER_DYNAMIC != XFEATURE_MASK_XTILE_DATA);
> > +
> > +       if (supported_xcr0 & XFEATURE_MASK_USER_DYNAMIC) {
> > +               supported_xcr0 &= xstate_get_guest_group_perm();
> > +
> > +               /*
> > +                * Treat XTILE_CFG as unsupported if the current process isn't
> > +                * allowed to use XTILE_DATA, as attempting to set XTILE_CFG in
> > +                * XCR0 without setting XTILE_DATA is architecturally illegal.
> > +                */
> > +               if (!(supported_xcr0 & XFEATURE_MASK_XTILE_DATA))
> > +                       supported_xcr0 &= XFEATURE_MASK_XTILE_CFG;
>
> should be this? supported_xcr0 &= ~XFEATURE_MASK_XTILE_CFG;
>
>
> > +       }
> > +       return supported_xcr0;
> >  }
Also, a minor opinion: shall we use permitted_xcr0 instead of
supported_xcr0 to be consistent with other places? This way,  it is
clear that supported_xcr0 is (almost) never changing.  permitted_xcr0,
as its name suggested, will be subject to permission change.
