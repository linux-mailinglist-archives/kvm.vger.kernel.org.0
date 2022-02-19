Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E144BC565
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 05:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241304AbiBSEvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 23:51:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiBSEvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 23:51:06 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449B150B22
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 20:50:49 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id w37so3148861pga.7
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 20:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9SuVj1fi5RP4o5bRwa6K8lcyqW640R9G+/Kdms/XR0=;
        b=X7S/AZ9fBPKIrVhySnCY+U7UWblLfCMaFM8lqCHiY9l7y6+mVO7sm3AZqiX46+RhS7
         GqTWzh9NBy6I5w+iswXplY/uyx2XLH/TqbxUAx5y3njh2VL8Snf4cLmnj6pNp7bFwvfZ
         YW1Fq8TUyi0cEgFTHA1ykNFD52tBgHmxgMaDIveXWKMrzgDVwZeIife1Mh6ivuPya6BH
         BiPFouxhuF51Wx0IjKNfAwnLdAF3OAghcyU6dM/lnDRX0hZO5I4wUSNcSJ4c57kabSt7
         3kc7cEtAqlG5BEJyhNtNKNGr1abUDhQf1WOg8PxtfoAeZ7TK/Myw48jFV/dcT0KXc9/A
         MZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9SuVj1fi5RP4o5bRwa6K8lcyqW640R9G+/Kdms/XR0=;
        b=5kmBrYBgu0WnRhjc/l722POfqwKwlPHWWTiueIbnjSvyVdN7v84zpTpXsUQJK+4lkz
         qnRivT297XzeSboDSWWCBY3bMpYzvskW9TwXPzt3UQxrXIDh2Va8Zg2/cD+ktAc7anTK
         lmqYXDRYUVUyqIIE6/a5t/1T3pq1zYylUV6qx+CQTnRRu7EWyt+bw/WlkAetUNGWMNia
         VHJL67XB6nODYqY+B/GcE8YFDRZvvBmPvIMat20u84AIDAE86GbmUhwH+e92GW0UM2H5
         oCsjPRFkoI1o32CCnNoS9t8UtI0zFnQaL10Sk5bvkj9XQZj0QxRYoGPQO0RgvfHnNJvQ
         Qh/Q==
X-Gm-Message-State: AOAM532pAGW2tQHX49NhvjzqCY9+9ZmtwX9crOhri1asJRu8rh6b9fMj
        ZcizNN50/HSQZtPWWuLhs7/D8oi5qLP8s8pu7fmjxw==
X-Google-Smtp-Source: ABdhPJzzTlaezoX5387HfzWh1w/HYes2SMd46QCY6Bv5pDQwuPKmNPS1FuUAtf8Yh5hmsZI8gAHEwFlZKh5Pna/qX3c=
X-Received: by 2002:a63:de46:0:b0:364:cad7:bf3b with SMTP id
 y6-20020a63de46000000b00364cad7bf3bmr8775132pgi.491.1645246248595; Fri, 18
 Feb 2022 20:50:48 -0800 (PST)
MIME-Version: 1.0
References: <20220217034947.180935-1-reijiw@google.com> <20220217034947.180935-2-reijiw@google.com>
 <Yg3Uer/K6n/h6oBz@google.com> <874k4x502u.wl-maz@kernel.org>
In-Reply-To: <874k4x502u.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 18 Feb 2022 20:50:32 -0800
Message-ID: <CAAeT=FxbbBq0sxUZAOSJW_wM+6M=xQe-p+=aeqpg=-y9VbpnnA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: Introduce get_set_regs_perf test
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oupton@google.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
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

Hi Marc,

On Thu, Feb 17, 2022 at 1:12 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 17 Feb 2022 04:52:10 +0000,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > First off, thanks for looking into this! Seems like a very useful thing
> > to test :-)
> >
> > On Wed, Feb 16, 2022 at 07:49:47PM -0800, Reiji Watanabe wrote:
> > > Introduce a simple performance test of KVM_GET_ONE_REG/KVM_SET_ONE_REG
> > > for registers that are returned by KVM_GET_REG_LIST. This is a pseudo
> > > process of saving/restoring registers during live migration, and this
> > > test quantifies the performance of the process.
> > >
> > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/.gitignore        |   1 +
> > >  tools/testing/selftests/kvm/Makefile          |   1 +
> > >  .../selftests/kvm/aarch64/get_set_regs_perf.c | 456 ++++++++++++++++++
> >
>
> [...]
>
> > Would it make sense to test some opt-in capabilities that expose
> > additional registers (PMU, SVE, etc.)?
>
> I think this is important. System registers are usually saved/restored

Yes, I will fix the test to include registers for opt-in features
when supported.

> in groups, and due to the way we walk the sysreg array, timings are
> unlikely to be uniform. Getting a grip on that could help restructure
> the walking if required (either per-group arrays, or maybe a tree
> structure).

The biggest system register table that I know is sys_reg_descs[],
and KVM_SET_ONE_REG/KVM_GET_ONE_REG/emulation code already uses
binary search to find the target entry.  So, the search itself
isn't that bad.  The difference between the min and the max
latency of KVM_GET_ONE_REG for the registers is always around
200nsec on Ampere Altra machine as far as I checked.


> Note that all of this could equally apply to the guest trapping (the
> walk is the same).
>
> And yes, there are a lot of commonalities with get-reg-list, so
> reusing some of the existing infrastructure would be a good thing.

I will look into that.

Thanks,
Reiji
