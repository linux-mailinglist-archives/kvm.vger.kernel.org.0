Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9071965E330
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjAEDAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 22:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjAEDAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 22:00:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5922A485AB
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 19:00:11 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 17so38119320pll.0
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 19:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bu6yuaCwskYNHXwEqcn9yeZ5SPgG6rLyg1H7QYQGX4Y=;
        b=HgswJJvy2Ss68DpGymvgLT2S5MWmEX6pIAzXCVl4As7J46jR7cQBfnlzki4qipoxgO
         W49ExsatZLCUlkltiVEb42URQDXPefBuGloLErK5SDc1D2hbeoGakC/Iqra5qqZzIHf2
         G3Tw+7UoSnEHVVJsbFxecMDB/SefrzBnNfecU2g6d7hx/ved1y85N/HBLhqrVTSNWM7O
         gE6R03OgWIehc0i1SpKAqqY/XLtNBs+r90q4X5iIVI4qGuSGAc5q45/eeBozeXPSSags
         /z+LqjpVXvzMZgzvzVUor1iM4hL2fjZgc4plf0p/J2tfhJWqNioymszGWTEQr3tDHCoI
         qEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bu6yuaCwskYNHXwEqcn9yeZ5SPgG6rLyg1H7QYQGX4Y=;
        b=svBFd/ryR0AKvjrU5aPKshBPUFV4oa7hVk73Xp4Aet7E+1DrNkyw8pxEH/KYI3Up4c
         fwmCwwx/veRxVKMiAvDLl25y/D1ukkf4es9ue8dlwwgeY61WiSe9cxG7jtlJd+eUWjsp
         zS2B3xxtvmYw9QVozIknaJji1TL/Oyuptqp+wsULdS89B96hLi7HJ0i6jGhKgNgbLqEx
         CMiqDab7mbsCI6IPV8KDc+YEGfQPF7H3KWwBPcSMay6u/MjuO90DKWhNbv892uW+m4yR
         s1K8CfPFG5bbQdihOun7XpsTmL5PEErX7+eImbDTLEBuMJDodx8+O94gTNHf8yNFs5P9
         X9rw==
X-Gm-Message-State: AFqh2kqm9r+FQAoj+ys4hUc3BACgqzKRoktDYJpy5kZ90DfItDUpngPN
        /4LWZocyrNZoGT/ihVjoWK/+Vz9E4cLjM1C1M/ULXk/oDMvu2+xFpY8=
X-Google-Smtp-Source: AMrXdXv7WnKXFndu0n03X9Zi+Ep0aPm3EPNqQPJF+S/hHnu9Lo5DKcOHN20h2Cyfap+CocmSz39Ue0lxJMXJJJUgzSk=
X-Received: by 2002:a17:902:f80c:b0:189:9a36:a5a1 with SMTP id
 ix12-20020a170902f80c00b001899a36a5a1mr4263932plb.154.1672887610625; Wed, 04
 Jan 2023 19:00:10 -0800 (PST)
MIME-Version: 1.0
References: <20221230035928.3423990-1-reijiw@google.com> <20230103124034.000027aa@Huawei.com>
 <86y1qj7pk9.wl-maz@kernel.org>
In-Reply-To: <86y1qj7pk9.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 4 Jan 2023 18:59:54 -0800
Message-ID: <CAAeT=FyuEuRZn7J5d3gdKGm7G1oEfh1C0heJp6HM7QhHoMid7g@mail.gmail.com>
Subject: Re: [PATCH 0/7] KVM: arm64: PMU: Allow userspace to limit the number
 of PMCs on vCPU
To:     Marc Zyngier <maz@kernel.org>
Cc:     Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
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

Hi Jonathan,

On Tue, Jan 3, 2023 at 4:47 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 03 Jan 2023 12:40:34 +0000,
> Jonathan Cameron <Jonathan.Cameron@Huawei.com> wrote:
> >
> > On Thu, 29 Dec 2022 19:59:21 -0800
> > Reiji Watanabe <reijiw@google.com> wrote:
> >
> > > The goal of this series is to allow userspace to limit the number
> > > of PMU event counters on the vCPU.
> >
> > Hi Rieji,
> >
> > Why do you want to do this?
> >
> > I can conjecture a bunch of possible reasons, but they may not
> > match up with your use case. It would be useful to have that information
> > in the cover letter.
>
> The most obvious use case is to support migration across systems that
> implement different numbers of counters. Similar reasoning could also
> apply to the debug infrastructure (watchpoints, breakpoints).

Exactly, this is to unblock migration support between systems
that implement different numbers of counters.
I will include this information in the cover letter when I update
the series for the v2.

Thanks,
Reiji



>
> In any case, being able to decouple the VM from the underlying HW
> within the extent that the architecture permits it seems like a
> valuable goal.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
