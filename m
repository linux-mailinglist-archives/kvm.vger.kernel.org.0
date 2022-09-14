Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00A75B8F1B
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 21:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiINTAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 15:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiINTAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 15:00:41 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5C44332D
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:00:40 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-12b542cb1d3so33813478fac.13
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 12:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Nc5l1sVKFjqk11lytQCRJhzRiUhnI7GDRniUTji6oyM=;
        b=YT1anRDElkFxzoGf0wWXXpwA7P7pjfJPmZ4vzWvji+dUQ88U7fklCbBnt5w3UmFJal
         nbBvLPMLyo2vvzVyr6AiTTHrdxUtOjHMDHY9nvgUq9xWWqSKUSQagy/xXbyKR5ZRGkgE
         n/4IyQ5i2fWdcFcMILhoYxQzrfI0qEeDvk5dHGnGLi1NDLS1te162G+ByhXmBljr5k5o
         MqHLvND7sPP9C6xvfxbxPc5PjKljcDFqoFelzqa+mrewhgC+rcDixIi2G3l8XbKwTkSK
         THm9ybgB9p9SOBvLrqa8HI24dKzmRIJZ05XgSs5D1/sSgllVXTIUC/1XA6ZePoanRSa/
         5Erg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Nc5l1sVKFjqk11lytQCRJhzRiUhnI7GDRniUTji6oyM=;
        b=QNwxThqxZRzxX3KZSez5y+n11EYr5qYCGKIeiKm8j7Nn34MHPAazrbfvwsxM2cChs0
         MfxwVnFqaNy9GbGPuHd7fBSfifscHLNJMq6+v5cRHDAlVQgrrEvCClGWcus/IzWY7Ruu
         YXAG9u7OwbNRz5JWCZQpL0dfHShBqmpp1rJQgO6E2WiUVOymfqCO0u/TPFRFKtfemJLR
         70RThP6DAqsUJL++3itgDqevuzBzUuJxvJYpQmThOHlLk8zA/Bn+f7pmPx9yxPBHX5h7
         vlXjIdsxKo4c7PjtQLWRZSjyryzui3kiKlrzQo4X38jA0tyMlDOaKTPmWf3HGO/2cPn5
         4qNw==
X-Gm-Message-State: ACgBeo3v9nuE0FaVfqhwHONDPgnZ+E56QpT6By8PT4SFRg8l2AArR923
        G7vt4z8pdZyhskxCtxefXMPRt9L0ZUbYjm43PtYNlg==
X-Google-Smtp-Source: AA6agR4fFwaEPGLZSbrZaLigcSbTA2rkHAosqwZQJGF8PYrAgOCCGlw2sgnRAJ0IxYLKe9oZWwB9GDWB2DK77WzWHlk=
X-Received: by 2002:a05:6870:a78e:b0:12b:542b:e5b2 with SMTP id
 x14-20020a056870a78e00b0012b542be5b2mr3176948oao.112.1663182038826; Wed, 14
 Sep 2022 12:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com> <20220831162124.947028-7-aaronlewis@google.com>
In-Reply-To: <20220831162124.947028-7-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 12:00:28 -0700
Message-ID: <CALMp9eRHSD8NFkweTAT=9Tgm4UgdoKybGW4=BUwif=Hz38n1ug@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] selftests: kvm/x86: Add testing for KVM_SET_PMU_EVENT_FILTER
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

On Wed, Aug 31, 2022 at 9:21 AM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Test that masked events are not using invalid bits, and if they are,
> ensure the pmu event filter is not accepted by KVM_SET_PMU_EVENT_FILTER.
> The only valid bits that can be used for masked events are set when
> using KVM_PMU_EVENT_ENCODE_MASKED_EVENT() with one exception: If any
> of the high bits (11:8) of the event select are set when using Intel,
> the PMU event filter will fail.
>
> Also, because validation was not being done prior to the introduction
> of masked events, only expect validation to fail when masked events
> are used.  E.g. in the first test a filter event with all it's bits set

Nit: its

> is accepted by KVM_SET_PMU_EVENT_FILTER when flags = 0.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  .../kvm/x86_64/pmu_event_filter_test.c        | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index bd7054a53981..73a81262ca72 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -442,6 +442,39 @@ static bool use_amd_pmu(void)
>                  is_zen3(entry->eax));
>  }
>
> +static int run_filter_test(struct kvm_vcpu *vcpu, const uint64_t *events,
> +                          int nevents, uint32_t flags)
> +{
> +       struct kvm_pmu_event_filter *f;
> +       int r;
> +
> +       f = create_pmu_event_filter(events, nevents, KVM_PMU_EVENT_ALLOW, flags);
> +       r = __vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, f);
> +       free(f);
> +
> +       return r;
> +}
> +
> +static void test_filter_ioctl(struct kvm_vcpu *vcpu)
> +{
> +       uint64_t e = ~0ul;
> +       int r;
> +
> +       /*
> +        * Unfortunately having invalid bits set in event data is expected to
> +        * pass when flags == 0 (bits other than eventsel+umask).
> +        */
> +       r = run_filter_test(vcpu, &e, 1, 0);
> +       TEST_ASSERT(r == 0, "Valid PMU Event Filter is failing");
> +
> +       r = run_filter_test(vcpu, &e, 1, KVM_PMU_EVENT_FLAG_MASKED_EVENTS);

Before using KVM_PMU_EVENT_FLAG_MASKED_EVENTS, we need to test for
KVM_CAP_PMU_EVENT_MASKED_EVENTS.
