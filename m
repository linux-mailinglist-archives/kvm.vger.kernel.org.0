Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC97D4FFCDB
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 19:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbiDMRgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 13:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbiDMRf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 13:35:59 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFEE6C918
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:33:38 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ef5380669cso13607707b3.9
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 10:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EUnyNdRKdjadDVWbLbSBbs4tv5nFop0mFUm/kQpcegc=;
        b=JHg+qGW4VjvrvMYp74vPHEk3ocTrygLHiYLeXeHCXxO9Xw+NyQgbk/cFH5mf8tsXyJ
         k5lWMkz2OCxERXnXRnpPUkKnulMz22Wie1UCSvT+zfLgv5+lqejuWr7g+te0dsgkgA9o
         k2qWZ/6NmvWhV/k81jC1OLYDc7h9WXfxYnf3dSCTA6NOOAz3G0/KPZWDTtLGqdkEHh6z
         wSdrismoIzHhYNLsNQ8tfx7g9qKAJiZOWsAsd4MKvgjaH8rSXzDr8bkZEcNq0vFxJYQB
         dKpb3L9pEOn3QD+XA8HbXIQIrHH+SuYoJWyVZG3nqFm75OsjBPpTTteEGPxPQ5ikZQMX
         WFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EUnyNdRKdjadDVWbLbSBbs4tv5nFop0mFUm/kQpcegc=;
        b=N/Fl1XnEaBAjlaV3Ri5HKaIaPTaI0SnjU9uzv7R+HeaRd3o/Q81liBbXNDSXZxAqcR
         rspvAAAM+QftWK+ktTEz0oHKHbGeO/WJhUipkIophGuL2D2244+Kog7YYqE7fU8+4q4/
         k4JdiBcMgY6Qy+qwgB67G9Ctk0Phh4MIRr2T53WooDpsPoi80vlv5lm60DjM0wvZDvlH
         Bs7Wk7rSiEHo0nOSUednB5c9kxBI68TGZKydUmzq/Y6Px7YnHpMozIrLfLtz1rvKqrvF
         nmGOeNlvUS4ZJ0NdPTJGeZqVDGXV0aGE/sKcUHz3qaIyL2auLBVWfhGTjrgGhxaILtyi
         HBYQ==
X-Gm-Message-State: AOAM533y7V3LHnMY9Fcmz4WxycgdxB5RbyQ1T9Dug1UgX/Ml/WksBssh
        w1CD/y8zB26mcpNMGkKKeThDdIhDGblH1B52ld/Vdw==
X-Google-Smtp-Source: ABdhPJxMsdUTKsiAhyJ/g2oojWzrjB+GtmrzMkEpK7B//XBmgkCAjkrTP3zFdicJiWibleet6HYKAe1qZE//TEuxCso=
X-Received: by 2002:a81:6b02:0:b0:2ee:e2d:12f5 with SMTP id
 g2-20020a816b02000000b002ee0e2d12f5mr12242ywc.200.1649871217246; Wed, 13 Apr
 2022 10:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220407011605.1966778-1-rananta@google.com> <20220407011605.1966778-11-rananta@google.com>
 <b3cfe975-de18-ea21-f174-1124803f314d@redhat.com>
In-Reply-To: <b3cfe975-de18-ea21-f174-1124803f314d@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 13 Apr 2022 10:33:26 -0700
Message-ID: <CAJHc60w3KMGB5k7qG9bWtGGha5_fSqcGHubF8JsXigQDmfR76g@mail.gmail.com>
Subject: Re: [PATCH v5 10/10] selftests: KVM: aarch64: Add KVM_REG_ARM_FW_REG(3)
 to get-reg-list
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
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

On Wed, Apr 13, 2022 at 2:22 AM Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Raghavendra,
>
> On 4/7/22 9:16 AM, Raghavendra Rao Ananta wrote:
> > Add the register KVM_REG_ARM_FW_REG(3)
> > (KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3) to the base_regs[] of
> > get-reg-list.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   tools/testing/selftests/kvm/aarch64/get-reg-list.c | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > index 281c08b3fdd2..7049c31aa443 100644
> > --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> > @@ -691,6 +691,7 @@ static __u64 base_regs[] = {
> >       KVM_REG_ARM_FW_REG(0),
> >       KVM_REG_ARM_FW_REG(1),
> >       KVM_REG_ARM_FW_REG(2),
> > +     KVM_REG_ARM_FW_REG(3),
> >       KVM_REG_ARM_FW_FEAT_BMAP_REG(0),        /* KVM_REG_ARM_STD_BMAP */
> >       KVM_REG_ARM_FW_FEAT_BMAP_REG(1),        /* KVM_REG_ARM_STD_HYP_BMAP */
> >       KVM_REG_ARM_FW_FEAT_BMAP_REG(2),        /* KVM_REG_ARM_VENDOR_HYP_BMAP */
> >
>
> It seems the same fixup has been done in another patch.
>
> https://www.mail-archive.com/kvmarm@lists.cs.columbia.edu/msg38027.html
>
Yes, Andrew won the race :(
I'll drop this patch.

> Thanks,
> Gavin
>

Regards,
Raghavendra
