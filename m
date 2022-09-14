Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540395B8F02
	for <lists+kvm@lfdr.de>; Wed, 14 Sep 2022 20:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiINSpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 14:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiINSpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 14:45:22 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118C44F6A8
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:45:22 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11eab59db71so43411576fac.11
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 11:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=rhTTxeoBCcZOVN49AL9ELns3yTeGCdemfpS/zC+WNn4=;
        b=gRg8T698+1P6rVecnrJl8PKsA6WGNaZVJ4lToeCR2A2K/isZtT1ErFWbfsmNKEiwar
         X0SypzaA18DlaGuJ1e+Qf60zF91chPZVO23Ma5OG3HXifPoEAQ56hmgxHSRNwiGuqWvz
         InXj47o61TCe608B+S8SwCKw++DSnnliJOTlC1cWYmFAbS1R5NnxfQlGFB4v/+RPJ+Z0
         hGCtNpQ+Loxsw18/Y5ZoV1FcQqSTTDaClJiV//BoSiqquJS+VWkvsKVxvVL6YcClGhDl
         6wtQRUwFIRFgAkBvrQ/2JUqUGud58GeeFi13FcNc38ZZDEVBnfelrfo1xhCYtJfEhO3S
         WagQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=rhTTxeoBCcZOVN49AL9ELns3yTeGCdemfpS/zC+WNn4=;
        b=Ixwm/ikgXROYwS2LYlz8E7jbsNUuNKVIv5RhT89Gjf2RG3qoqmRjdaiB4Z2N7IdRtT
         KCEWP7WVyl77l3aA2IYPcVjPrMDKaneETBuaiV1DuGwRE24oNtKOaI8gOo65VUEpVkeb
         YjBoPLA/Y5ENdZP0d+xTsvSbrIO7Egi/4hlKv87cnlBjWMkNj7rHR2kS+h/C/McdkuRn
         V3jgAuAdqEO6n2qe/4A/iz5OUf7O1FPIwbX0waMoW0gjH6u3R7bl8m4OWn5eVV3gn5Wj
         KkibrA0i6VSL/lbFnc2aQfQcp5tBfjoW9qyFjyhR2jSOS+5O5JS2aBgHAqS+aksuj+rm
         vi9g==
X-Gm-Message-State: ACgBeo1Jj2ytbpUKcjpqskz+3H0xwTwwfcVaHr+Ox2GmXdOJ8vshqV0e
        k9rFRR3tdYMnWzKnaHOz5iTklsuNQjjCRZAZgcs1Wg==
X-Google-Smtp-Source: AA6agR6bWk4oi9VA2pqhs5yEi2AiB17v7mBkQblFFrW7KupevHKe+C2RQLy6CGSwii9l7FdzvpW2zZjuOAIaSOIz41Y=
X-Received: by 2002:a05:6870:a78e:b0:12b:542b:e5b2 with SMTP id
 x14-20020a056870a78e00b0012b542be5b2mr3146641oao.112.1663181121218; Wed, 14
 Sep 2022 11:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com> <20220831162124.947028-5-aaronlewis@google.com>
In-Reply-To: <20220831162124.947028-5-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 14 Sep 2022 11:45:09 -0700
Message-ID: <CALMp9eRcPZ7PvsCbt=9xPJkgJcfK-e_NyPPmGXbhm8gd_8Dw4A@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] kvm: x86/pmu: Introduce masked events to the pmu
 event filter
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
> When building a list of filter events, it can sometimes be a challenge
> to fit all the events needed to adequately restrict the guest into the
> limited space available in the pmu event filter.  This stems from the
> fact that the pmu event filter requires each raw event (i.e. event
> select + unit mask) be listed, when the intention might be to restrict
> the event select all together, regardless of it's unit mask.  Instead
> of increasing the number of filter events in the pmu event filter, add
> a new encoding that is able to do a more generalized match on the unit
> mask.
>
> Introduce masked events as a new encoding that the pmu event filter
> understands in addition to raw events.  A masked event has the fields:
> mask, match, and exclude.  When filtering based on these events, the
> mask is applied to the guest's unit mask to see if it matches the match
> value (i.e. unit_mask & mask == match).  The exclude bit can then be
> used to exclude events from that match.  E.g. for a given event select,
> if it's easier to say which unit mask values shouldn't be filtered, a
> masked event can be set up to match all possible unit mask values, then
> another masked event can be set up to match the unit mask values that
> shouldn't be filtered.
>
> Userspace can query to see if this feature exists by looking for the
> capability, KVM_CAP_PMU_EVENT_MASKED_EVENTS.
>
> This feature is enabled by setting the flags field in the pmu event
> filter to KVM_PMU_EVENT_FLAG_MASKED_EVENTS.
>
> Events can be encoded by using KVM_PMU_EVENT_ENCODE_MASKED_ENTRY().
>
> It is an error to have a bit set outside the valid bits for a masked
> event, and calls to KVM_SET_PMU_EVENT_FILTER will return -EINVAL in
> such cases, including the high bits (11:8) of the event select if
> called on Intel.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  Documentation/virt/kvm/api.rst  |  81 ++++++++++++++++--
>  arch/x86/include/uapi/asm/kvm.h |  28 ++++++
>  arch/x86/kvm/pmu.c              | 145 +++++++++++++++++++++++++++-----
>  arch/x86/kvm/pmu.h              |  32 +++++--
>  arch/x86/kvm/x86.c              |   1 +
>  include/uapi/linux/kvm.h        |   1 +
>  6 files changed, 255 insertions(+), 33 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index abd7c32126ce..e7783e41c590 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5027,7 +5027,13 @@ using this ioctl.
>  :Architectures: x86
>  :Type: vm ioctl
>  :Parameters: struct kvm_pmu_event_filter (in)
> -:Returns: 0 on success, -1 on error
> +:Returns: 0 on success,
> +    -EFAULT args[0] cannot be accessed.
> +    -EINVAL args[0] contains invalid data in the filter or filter events.
> +                    Note: event validation is only done for modes where
> +                    the flags field is non-zero.
> +    -E2BIG nevents is too large.
> +    -ENOMEM not enough memory to allocate the filter.

I assume that the ioctl returns -1 on error, but that errno is set to
one of the errors listed above (in its positive form).

So...

:Returns: 0 on success, -1 on error

Errors:
====== ============================================
EFAULT args[0] cannot be accessed
EINVAL args[0] contains invalid data in the filter or filter events
E2BIG nevents is too large
EBUSY not enough memory to allocate the filter
====== ============================================

> @@ -647,7 +719,34 @@ static void convert_to_filter_events(struct kvm_pmu_event_filter *filter)
>         for (i = 0; i < filter->nevents; i++) {
>                 u64 e = filter->events[i];
>
> -               filter->events[i] = encode_filter_entry(e);
> +               filter->events[i] = encode_filter_entry(e, filter->flags);
> +       }
> +}
> +
> +/*
> + * Sort will order the list by exclude, then event select.  This function will
> + * then index the sublists of event selects such that when a search is done on
> + * the list, the head of the event select sublist is returned.  This simpilfies

Nit: simplifies

With the documentation changes,

Reviewed-by: Jim Mattson <jmattson@google.com>
