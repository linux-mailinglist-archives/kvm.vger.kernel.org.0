Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534DE3EDEDF
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 22:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233303AbhHPU5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 16:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhHPU5B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 16:57:01 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CA6C061764
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:56:29 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id j26so2880401vkn.4
        for <kvm@vger.kernel.org>; Mon, 16 Aug 2021 13:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PAjqAgz4SbwhR4C2g99BnpgC4FJpr+PKslvtcBCtV7g=;
        b=Z0LdAVsVOA5UHNfiWH6pgQcaDfOI9yO7Prph0FcJkli65iCPGkn28i57u0iz4+rr/k
         7vexRoGXmoPITr+5iwD1J66G3TX2bPkT/CXwyeVpXNo7GjzQ7AhRHto17gppMPSKbsWK
         RuJRGjnJZUEvu08KT6euDd9I6tm7GraORU6AK3mdU3PHuwzqhr90lo9viERzvg1NotTN
         SQEOnKw/W7fs/3/6pADSnP1TY1XrkH/jkzfAZhWNNJ5qAQpDVTkOjbT7l7Uy0t3/vrRN
         MMadQi9Wh82FRxI2kmi5Jl9OwXaKDExXlsgp1jDNN4pukiE+JblEQPerb0tNc5/nkAmI
         uLlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PAjqAgz4SbwhR4C2g99BnpgC4FJpr+PKslvtcBCtV7g=;
        b=kjFOayaV/j7E7PUa8tgm7wn8r5Sbaaq7Juh/bwAqMhQhMeBqhwMb12Dbt1vzoQ7Xgn
         z6W8L/bhq8XGKgAGCzN956lRfFWUWtVNKrBRMcBnvjmzONu57MLiNtbgNpI53HoQGe4F
         Q38S+KSv8rARTQ5xoT3X5bscaTDN0Bk33G2NSqm5GYmOjpiewWT1q/WbffYgfOOwxV15
         AxmIqK7rqntrgGcpctBMKGRD7JDXH4nAOEbrer2js2Jhn72r1WYKEmZUkd28wbriSNo/
         McFqVjGwut14A0LaTWJyZKtD0o8WhSY+0JHrpKY4FXGLptWc5mTb2g1KnUJvDJRSmMrN
         KygA==
X-Gm-Message-State: AOAM531N8zIb0ZXax3/nXZCRSmzYjxNlTZQItE7ub3USwDOB3F4rrWKv
        vUU74Bv0tOkoXkRTrI9fnf5C5tHgZnNP5qoTHjzQfg==
X-Google-Smtp-Source: ABdhPJwFYs1vFOV9d+q8kCyHbjok7b0AZnXTp2WBYai2NMcFXOwpP6G4PDTDMv1OQqhNCSOcya9L68gfllHl5OFFeZI=
X-Received: by 2002:a1f:bfc4:: with SMTP id p187mr407300vkf.17.1629147388071;
 Mon, 16 Aug 2021 13:56:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210813211211.2983293-1-rananta@google.com> <20210816121548.y5w624yhrql2trzt@gator.home>
In-Reply-To: <20210816121548.y5w624yhrql2trzt@gator.home>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Mon, 16 Aug 2021 13:56:17 -0700
Message-ID: <CAJHc60yqNcpmDCmSehVb6uDeu+FF--aPhwJ9ZBTAcJCPBVR=1Q@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: arm64: selftests: Introduce arch_timer selftest
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 5:15 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Aug 13, 2021 at 09:12:01PM +0000, Raghavendra Rao Ananta wrote:
> > Hello,
> >
> > The patch series adds a KVM selftest to validate the behavior of
> > ARM's generic timer (patch-10). The test programs the timer IRQs
> > periodically, and for each interrupt, it validates the behaviour
> > against the architecture specifications. The test further provides
> > a command-line interface to configure the number of vCPUs, the
> > period of the timer, and the number of iterations that the test
> > has to run for.
> >
> > Since the test heavily depends on interrupts, the patch series also
> > adds a basic support for ARM Generic Interrupt Controller v3 (GICv3)
> > to the KVM's aarch64 selftest framework (patch-9).
> >
> > Furthermore, additional processor utilities such as accessing the MMIO
> > (via readl/writel), read/write to assembler unsupported registers,
> > basic delay generation, enable/disable local IRQs, spinlock support,
> > and so on, are also introduced that the test/GICv3 takes advantage of.
> > These are presented in patches 1 through 8.
> >
> > The patch series, specifically the library support, is derived from the
> > kvm-unit-tests and the kernel itself.
> >
>
> Hi Raghavendra,
>
> I appreciate the new support being added to aarch64 kselftests in order to
> support new tests. I'm curious as to why the kvm-unit-tests timer test
> wasn't extended instead, though. Also, I'm curious if you've seen any
> room for improvements to the kvm-unit-tests code and, if so, if you plan
> to submit patches for those improvements.


Hi  Andrew,

Interesting question! It's more about ease and flexibility in
controlling the guest via the VMM-
Since arch_timer's interface is mostly per-CPU, we'd like to extend
this test case to be
more stressful, such as migrating the vCPUs across pCPUs rapidly, or
even affining
a large number of vCPUs to a single pCPU, and so on.

On the other hand, since the patch series brings-in a lot of aarch64
goodies with it,
such as interrupt support, it might encourage others to add more arch
specific tests
easily :) For example, we also plan to add tests that verifies KVM
interface for interrupts,
for which the GIC support in the series would come handy.

I'm still gaining understanding of kvm-unit-tests. However, I'm
curious to know your thoughts as
well in-support of kvm-unit-tests.

Unfortunately, I don't have any immediate plans to submit patches on
arch_timer for
kvm-unit-tests.

Thanks,
Raghavendra

>
>
> Thanks,
> drew
>
