Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4EF6AE56A
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 16:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjCGPxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 10:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjCGPw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 10:52:57 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E94144A0
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 07:52:53 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id t39so11848943ybi.3
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 07:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678204372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4U2TIqa/wrw6vwrsJesBD9h6qroJJgS9Nfcm6zQUio=;
        b=DMZJyqykoC9nl1WZqzbAiMncfkOhciuTYyCp4xB7O8BErbbuJHcgIYuKtp9ugUhjlh
         bUJlSn1Q6vorS/b4RgkOIcMkdlQ8kKyHPv9aS6a1nm6R+ubgV1Wv3n9kTPHA+QZ8EprC
         8g4Urnn4aJIe8rl1SKFOm7CehpjUVPlp2DZo3L7ya34KnwRDjqoI8Pvq/0uwHzlEQLrf
         e+XD5QqYuPNVKQKTttamvg//+ECJUYxaWVsEjCuHG0cAU0iv9TRyx87tJpFANWHoWhTN
         T6EBXYwlJeSCSdVP3pINOBmrCcV5KDo19ctO8yvQQ6uuEP6zDKyppMWKUe/EGnUpO/+O
         Jwkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678204372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4U2TIqa/wrw6vwrsJesBD9h6qroJJgS9Nfcm6zQUio=;
        b=mjEfhhS5lG8YWZ/yAsH7sRolsNjl83dqgznhwyaywvqD3enOY8JIz6qq1lOkn8+sN/
         0oxMhLqZO/vJbcRdOWZ82m+UmMMi1P1mC6Rzc+ZJb/vqUTQtAqZmRFEYSFhSJSIgghKT
         E6/8iaSoTeyppPMv9R5/gSIPYAwdb7xdBX0i1rpRZIOwh3ElR6vKbkodgtKmXbdVZU07
         azrMUn7eai4nhforPzcrj/CvFSAdlTSk/93eL6TdxEKr6X6YOFzqgiQ0DKuIdfO7/I8h
         V0DvdqVjiVXOXeTWXGIf4DLOLzHMLALg8ebQAP6tP99KZrPj32MbofpEirhYeACkv/JX
         gFFQ==
X-Gm-Message-State: AO0yUKWxwcVjPW9wZT4P5KF5a2QHLCrOAGfrYcgHzQIoHUJgVlaV+ZT4
        SFSyfhKg6aSSsFlSJdyGRwZ8iHnmIbgwln/pjPKSlSJDPZoA5G7SwXU=
X-Google-Smtp-Source: AK7set+A6SYaBSjVzsWHMJfROMha4TcmQzsol1Rxh85F1s7j0ux4TlXRwarAC7FWY3qoWBHbYKVjfCLKEoOhR2fsowE=
X-Received: by 2002:a25:9105:0:b0:ac2:ffe:9cb8 with SMTP id
 v5-20020a259105000000b00ac20ffe9cb8mr7009351ybl.3.1678204372131; Tue, 07 Mar
 2023 07:52:52 -0800 (PST)
MIME-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
 <20230307141400.1486314-2-aaronlewis@google.com> <1c7a20c4-742c-9c42-970e-19626323e367@gmail.com>
In-Reply-To: <1c7a20c4-742c-9c42-970e-19626323e367@gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 7 Mar 2023 07:52:41 -0800
Message-ID: <CAAAPnDFuEhhv+3orZ0EGMq4kAm3_p335kRAMOf=ZcLi_pcnPKQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: x86/pmu: Prevent the PMU from counting
 disallowed events
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Mar 7, 2023 at 7:19=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> wr=
ote:
>
> On 2023/3/7 22:13, Aaron Lewis wrote:
>
> > When counting "Instructions Retired" (0xc0) in a guest, KVM will
> > occasionally increment the PMU counter regardless of if that event is
> > being filtered. This is because some PMU events are incremented via
> > kvm_pmu_trigger_event(), which doesn't know about the event filter. Add
> > the event filter to kvm_pmu_trigger_event(), so events that are
> > disallowed do not increment their counters.
> It would be nice to have:
>
>      Reported-by: Jinrong Liang <cloudliang@tencent.com>
>
> , since he also found the same issue.
>

Sure, I can add that.

> > Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions=
")
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>
> Reviewed-by: Like Xu <likexu@tencent.com>
>
> > ---
> >   arch/x86/kvm/pmu.c | 13 ++++++++-----
> >   1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index 612e6c70ce2e..9914a9027c60 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -400,6 +400,12 @@ static bool check_pmu_event_filter(struct kvm_pmc =
*pmc)
> >       return is_fixed_event_allowed(filter, pmc->idx);
> >   }
> >
> > +static bool event_is_allowed(struct kvm_pmc *pmc)
>
> Nit, an inline event_is_allowed() here might be better.

I purposely didn't inline this because Sean generally discourages its
use and has commented in several reviews to not use 'inline' and
instead leave it up to the compiler to decide, unless using
__always_inline.  I think the sentiment is either use the strong hint
or don't use it at all.  This seems like an example of where the
compiler can decide, and a strong hint isn't needed.

>
> > +{
> > +     return pmc_is_enabled(pmc) && pmc_speculative_in_use(pmc) &&
> > +            check_pmu_event_filter(pmc);
> > +}
> > +
> >   static void reprogram_counter(struct kvm_pmc *pmc)
> >   {
> >       struct kvm_pmu *pmu =3D pmc_to_pmu(pmc);
> > @@ -409,10 +415,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
> >
> >       pmc_pause_counter(pmc);
> >
> > -     if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
> > -             goto reprogram_complete;
> > -
> > -     if (!check_pmu_event_filter(pmc))
> > +     if (!event_is_allowed(pmc))
> >               goto reprogram_complete;
> >
> >       if (pmc->counter < pmc->prev_counter)
> > @@ -684,7 +687,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u=
64 perf_hw_id)
> >       for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
> >               pmc =3D static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
> >
> > -             if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_u=
se(pmc))
> > +             if (!pmc || !event_is_allowed(pmc))
> >                       continue;
> >
> >               /* Ignore checks for edge detect, pin control, invert and=
 CMASK bits */
