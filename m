Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297F2518FBD
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 23:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242545AbiECVNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 17:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiECVNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 17:13:14 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB0E255A8
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 14:09:41 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id y2so33218068ybi.7
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 14:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4fiXOSargbkmqorI6WusV2qGhD3iqsqBH5PjRfunjuA=;
        b=YoNJVD72g3AVg+3aeTpK8KNgGmRrdH21U6jGrIF4yTt28emi7xJOvR/HVHHovuFaVi
         Rd+rn0a8n7qTEglfwFmqhABF0y3SYRRRrmknTwyamT3woWJY7QvpPos6aPXoaNRQJ2oV
         B2VptOYHCq2ctdiq3rOLXvB7cTCEBFxxlta1hd9rw1xOAdhwINOkLE7bA29UfIHpgFe1
         Hi91a1cNyIXPOEJMCLjMi/mGqk+JQ7EGfMXLspEaH/MUkinOK6Hl+zjrf4PxxZfQKJdc
         H7PHfoB0QvVbHEfxf1qjOczuwlVUt+tWhFVrhaqw0qsMVX2ApZ2DOZRrlXestDqBC8FU
         lZEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4fiXOSargbkmqorI6WusV2qGhD3iqsqBH5PjRfunjuA=;
        b=hF3C8869OZQS1nS5E2JCR7rIs5RTGZJ3B1Amf0aw54gTVKWvYP6Iy1vY12vhYgkoZ3
         lke2TJrL7TzLEKQRD3X+GkI2HywNwyAQi2vKX/m4YCtO26pzdCqJw4ing4QcIo/pD+4B
         Mslz1RmtHlH5kE7PIvAhsij1siVYrNeeIS0+q2twPnFhNKswSlODC3KyU+7XLDm9M4jQ
         lSuntZc1D+bwi5Rxr2OemWIxEM59Ygk6Sc8rFq3I4LRQ69/iwpVhLhWk514oRY/l9cxg
         ABydVSyiZ16d5OgBIHTm51SjZP2r9YdxFCAkJJkmoyyYHIHLSh5AcRU/LGnicsVxWSkG
         Vmtw==
X-Gm-Message-State: AOAM530ea34nCROr40trgvCsAymAiE6IzadeBpeiQMiZ2STBdCpTCXpX
        xqHChZllmRnDRruzEqR36jTbbFMxCTnFI901ZV+75w==
X-Google-Smtp-Source: ABdhPJwbHPh4pTxe5Aps2H2tu8JbsnM+d6wHpFw0d/yrdwjO15HqS7ozkDExBWLCf3hEz5mOJ+dkfiEmK/8p91Cr1A4=
X-Received: by 2002:a25:b095:0:b0:649:d59e:4c07 with SMTP id
 f21-20020a25b095000000b00649d59e4c07mr5306279ybj.627.1651612180307; Tue, 03
 May 2022 14:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com> <878rri8r78.wl-maz@kernel.org>
 <CAJHc60xp=UQT_CX0zoiSjAmkS8JSe+NB5Gr+F5mmybjJAWkUtQ@mail.gmail.com> <878rriicez.wl-maz@kernel.org>
In-Reply-To: <878rriicez.wl-maz@kernel.org>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 3 May 2022 14:09:29 -0700
Message-ID: <CAJHc60w1F7RAgJkv5PRuJtKjTw1gUaYmZk885AVhPLF2h6YbkQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/9] KVM: arm64: Add support for hypercall services selection
To:     Marc Zyngier <maz@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, May 3, 2022 at 1:33 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 03 May 2022 19:49:13 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Tue, May 3, 2022 at 10:24 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Tue, 03 May 2022 00:38:44 +0100,
> > > Raghavendra Rao Ananta <rananta@google.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > Continuing the discussion from [1], the series tries to add support
> > > > for the userspace to elect the hypercall services that it wishes
> > > > to expose to the guest, rather than the guest discovering them
> > > > unconditionally. The idea employed by the series was taken from
> > > > [1] as suggested by Marc Z.
> > >
> > > As it took some time to get there, and that there was still a bunch o=
f
> > > things to address, I've taken the liberty to apply my own fixes to th=
e
> > > series.
> > >
> > > Please have a look at [1], and let me know if you're OK with the
> > > result. If you are, I'll merge the series for 5.19.
> > >
> > > Thanks,
> > >
> > >         M.
> > >
> > Thank you for speeding up the process; appreciate it. However, the
> > series's selftest patches have a dependency on Oliver's
> > PSCI_SYSTEM_SUSPEND's selftest patches [1][2]. Can we pull them in
> > too?
>
> Urgh... I guess this is the time to set some ground rules:
>
> - Please don't introduce dependencies between series, that's
>   unmanageable. I really need to see each series independently, and if
>   there is a merge conflict, that's my job to fix (and I don't really
>   mind).
>
> - If there is a dependency between series, please post a version of
>   the required patches as a prefix to your series, assuming this
>   prefix is itself standalone. If it isn't, then something really is
>   wrong, and the series should be resplit.
>
> - You also should be basing your series on an *official* tag from
>   Linus' tree (preferably -rc1, -rc2 or -rc3), and not something
>   random like any odd commit from the KVM tree (I had conflicts while
>   applying this on -rc3, probably due to the non-advertised dependency
>   on Oliver's series).
>
Thanks for picking the dependency patches. I'll keep these mind the
next time I push changes.

> >
> > aarch64/hypercalls.c: In function =E2=80=98guest_test_hvc=E2=80=99:
> > aarch64/hypercalls.c:95:30: error: storage size of =E2=80=98res=E2=80=
=99 isn=E2=80=99t known
> >    95 |         struct arm_smccc_res res;
> >       |                              ^~~
> > aarch64/hypercalls.c:103:17: warning: implicit declaration of function
> > =E2=80=98smccc_hvc=E2=80=99 [-Wimplicit-function-declaration]
> >   103 |                 smccc_hvc(hc_info->func_id, hc_info->arg1, 0,
> > 0, 0, 0, 0, 0, &res);
> >       |                 ^~~~~~~~~
> >
>
> I've picked the two patches, which means they will most likely appear
> twice in the history. In the future, please reach out so that we can
> organise this better.
>
> > Also, just a couple of readability nits in the fixed version:
> >
> > 1. Patch-2/9, hypercall.c:kvm_hvc_call_default_allowed(), in the
> > 'default' case, do you think we should probably add a small comment
> > that mentions we are checking for func_id in the PSCI range?
>
> Dumped a one-liner there.
>
> > 2. Patch-2/9, arm_hypercall.h, clear all the macros in this patch
> > itself instead of doing it in increments (unless there's some reason
> > that I'm missing)?
>
> Ah, rebasing leftovers, now gone.
>
> I've pushed an updated branch again, please have a look.
>
Thanks for addressing these. The series looks good now.

Regards,
Raghavendra
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
