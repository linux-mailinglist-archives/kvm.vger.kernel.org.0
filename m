Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1E64DCBDB
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 17:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbiCQQ6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 12:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236210AbiCQQ6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 12:58:20 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BE91D59E0
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 09:57:02 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id l20so9991041lfg.12
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 09:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZZ/ZyntFdWScxN0lJA199RTWytNkCmmcoJKmHk/hjk=;
        b=gbdQipZOFrTwzaoaQKXuF1cVYywNS5cx6uxjMvJK45dmeHcY0RTKHbhS1YUJ6eXtLA
         97q32bVRoxct754KWnKMkA0vDtBGYBSoS1qNdRor1SKiPrsL67V/qrNFzIgjkIDaz3Ev
         Q1vbLFU3eIFfjfn3AnfKotT/5jA7qDmpTLsOi0dfeBJ8W0Alb0Es/F+PanYf9dDWgzh+
         sE6Rz7L9NQTm5ihfAyrsejGL2w5YsWHQO/u8nw9/yPGVgOLmSqSR0bGJKsCmmn1QMD9D
         MySFq0BzkSUXZka1nyVk/TP8t1dCVhZWY+gEcZMmjV0eXQFn56rz7ZL1wugfB3x3pt8O
         2Oag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZZ/ZyntFdWScxN0lJA199RTWytNkCmmcoJKmHk/hjk=;
        b=g6E0sK6rq89v4eBvegxck0ws8MT31AkakYxr2wtF2XUsHLaIPk72PKA/E3mBkuoAAr
         ExDUIpQGAc6HfttUKRnez41JFUWSL7aaUiOVnx5Iq8+m41mD5Xpd9qcL9xi3+vpX0OKs
         ljSIr7tJAAHdoQkeLeHsxYvNY6Ppup/1nbMBw6p/5uIz5xRXqPmocE+HWlZmq5UtVA/I
         5aHf99/8m3g6oWT63SnWH/r9jnVopVDxFGi3qn8vSwGel59kCGwCJkbTzSPKETwwMdmp
         jbiC6YGmH/rRf8tL6A0HmwHPi7yAayz52uDZ1FZMzPHcvzBox88iZtVoy3jFySDpjvSm
         HJQQ==
X-Gm-Message-State: AOAM5322J6RygbWB/htyayl+y5Qnv8pAnz7x+EEFucw5zJ5OqAyApJN5
        50L06Elons3K+PUPxlnwsc1Dq9wcokiw388nO+2gOA==
X-Google-Smtp-Source: ABdhPJwsXGlU/FnpHan4++A1rSsngYWgp/BRajvKK2N0EEge5WE2sBFGiJk6DyI6iKDH0wVg7SYX3iAQQk+9//WuqoM=
X-Received: by 2002:a05:6512:3043:b0:447:b909:b868 with SMTP id
 b3-20020a056512304300b00447b909b868mr3565134lfb.286.1647536220930; Thu, 17
 Mar 2022 09:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220317045127.124602-1-ricarkol@google.com> <20220317045127.124602-3-ricarkol@google.com>
 <YjLY5y+KObV0AR9g@google.com> <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
In-Reply-To: <5fe2be916e1dcfe491fd3b40466d1932@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 17 Mar 2022 09:56:49 -0700
Message-ID: <CAOQ_Qsgnc=WkHfWiQ40HZDdXOtcRCb2-sRG3HCp7ua9VYJ3+DA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: add arch_timer_edge_cases
To:     Marc Zyngier <maz@kernel.org>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        pbonzini@redhat.com, Alexandru.Elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com
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

On Thu, Mar 17, 2022 at 1:52 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On 2022-03-17 06:44, Oliver Upton wrote:
> > On Wed, Mar 16, 2022 at 09:51:26PM -0700, Ricardo Koller wrote:
> >> Add an arch_timer edge-cases selftest. For now, just add some basic
> >> sanity checks, and some stress conditions (like waiting for the timers
> >> while re-scheduling the vcpu). The next commit will add the actual
> >> edge
> >> case tests.
> >>
> >> This test fails without a867e9d0cc1 "KVM: arm64: Don't miss pending
> >> interrupts for suspended vCPU".
> >>
> >> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >> Reviewed-by: Raghavendra Rao Ananta <rananta@google.com>
> >> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>
> [...]
>
> >> +            asm volatile("wfi\n"
> >> +                         "msr daifclr, #2\n"
> >> +                         /* handle IRQ */
> >
> > I believe an isb is owed here (DDI0487G.b D1.13.4). Annoyingly, I am
> > having a hard time finding the same language in the H.a revision of the
> > manual :-/
>
> D1.3.6 probably is what you are looking for.
>
> "Context synchronization event" is the key phrase to remember
> when grepping through the ARM ARM. And yes, the new layout is
> a nightmare (as if we really needed an additional 2800 pages...).

Thanks! I have yet to find a PDF viewer that can chew through such a
document for a search term at a decent clip. And all the extra pages
just made the problem even worse.

--
Thanks,
Oliver
