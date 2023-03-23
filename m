Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61EC6C7255
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 22:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCWV3e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 17:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCWV3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 17:29:31 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5611E10AAC
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:29:20 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id j18-20020a170902da9200b001a055243657so45581plx.19
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 14:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679606960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4ktFGcSiHt+jLdAPoQ6LmqnUHuRqTjS55asz27iAOcw=;
        b=iK+aEL2C9Njh1WitU3wqrpF2LQHakK9r0Rxm8Zo387756xZ8TrO9C5jd1GeS1X7LIq
         xfWWamQHO8+dKWS4VRWjo4HZ0h8XtkN5MGE7eBbBPD3vhzNLpVE9FbU9atj1LwSBIoGK
         ZSAUN+tpOF5Wk2XBOME9Eg/dKAEWIKj17egB4k70kbzZT+vtX60uNkOjU7uB3OAyYxAq
         Sr7kZeARY8K254rghxLKxf5GghDzZNdrSEdkbG9QmBvp5Hz9mUWDz/9OYVVv9LCw7hq4
         zMZi87cv7hexzuVY01wZQNUqyMKqJU/iEfXY36m1m4wjcLfAySKZIJyPVGi9wzBEu3p/
         J1ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679606960;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ktFGcSiHt+jLdAPoQ6LmqnUHuRqTjS55asz27iAOcw=;
        b=NsQpwl11ucSDFvq2BCP1Wk/jUVNPIHfHYVkxHL02uopnZ9uVCWsPVO9IvEkXzfaMIy
         NqumhiMHuf7gDlxRl1mGscXMaNS5BCUM3Xxtq9MPvRZ5MQIkazA8k5TK+sazCYGdYLgf
         kcyAdwJCaWz63nUytuFBPdwfX1DDgDS7SuQLEjzTT4IjEhuFEdpCt/d139IeiCxO36Hp
         AcYKkn4I9Wc7lZEPS5+qXbfw6mcxHCKuBQUvWj42qsmNPOvTLcXEJk2RDcQXKWfhP4qD
         f0rboCOrl4eWlPbV9ZrDXvtQfpksLpnKJMKmUh5Ze2TwSsFodNqBFMvlQrNKtPHJLSza
         ZBoQ==
X-Gm-Message-State: AO0yUKUfsrfishVZfoavWj1KiYv2UfJuBjHrZ22daOZGqYbQAVgQzLT3
        BbgehfzqYg6F+6W2dAqvEEisI8qztZI=
X-Google-Smtp-Source: AK7set9CtWinGv+eIeH2M+yGV2RfwUTysQoHidUub1I4ioPXUYri8JKVpMZ3Bbgt9UTHZhYsjRdBdyjPIIo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:638d:0:b0:4eb:1c07:e5d7 with SMTP id
 h13-20020a65638d000000b004eb1c07e5d7mr2374165pgv.6.1679606959860; Thu, 23 Mar
 2023 14:29:19 -0700 (PDT)
Date:   Thu, 23 Mar 2023 14:29:18 -0700
In-Reply-To: <CAL715WKX6FXugfCYLqyoT4UKCYha7g_izvy2Djvg5zPkxa7JwQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-3-aaronlewis@google.com> <ZBy2tcQzERBpsoxz@google.com>
 <CAL715WKX6FXugfCYLqyoT4UKCYha7g_izvy2Djvg5zPkxa7JwQ@mail.gmail.com>
Message-ID: <ZBzErkhkXQ7j+zKS@google.com>
Subject: Re: [PATCH v3 2/8] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 23, 2023, Mingwei Zhang wrote:
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -3,6 +3,7 @@
> >  #define ARCH_X86_KVM_X86_H
> >
> >  #include <linux/kvm_host.h>
> > +#include <asm/fpu/xstate.h>
> >  #include <asm/mce.h>
> >  #include <asm/pvclock.h>
> >  #include "kvm_cache_regs.h"
> > @@ -325,7 +326,22 @@ extern bool enable_pmu;
> >   */
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

Doh, yes.
