Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41457112F0
	for <lists+kvm@lfdr.de>; Thu, 25 May 2023 19:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239409AbjEYR4T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 May 2023 13:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbjEYR4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 May 2023 13:56:17 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E547189
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 10:56:15 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-25345cf3343so20429a91.0
        for <kvm@vger.kernel.org>; Thu, 25 May 2023 10:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685037375; x=1687629375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XbZfqBItcXzKLk1nfsDlp5Oogh2CcWLWMFdBRAuDk8A=;
        b=1Fu2PdpCfqH0lSpeQe9fNQSos+bXML3EY2SUDzAa3hOINxqpZBiwx+MKgAXVqSW3Mf
         MW7fpm4nqWSK2vXx3qvWinUTBWg7a9vccLx5zjdoUU4QTqUpXQq0Cx8SEyyWG85HYd/y
         5kl7Y7yefIzp6JZhL1XHcqCn/84W0wDSnSG7xOdPYS6bKI1jZQBfUCkWFKeCtb5Kmdr4
         8HY43RvH5ZpeqfR3AFXcThEpJ516hVdsT60gZ/C+0wXpjuO0XBywIqv8zs6gikrGO+VE
         VATFnSylOGmFtIWVBMuC8HB7mydZsgzQ0yFx5WAscXShL+wBFMj8nK1l28M7hlQG4HXl
         e99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685037375; x=1687629375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbZfqBItcXzKLk1nfsDlp5Oogh2CcWLWMFdBRAuDk8A=;
        b=j4PizpTqTqT9srhQKCel1wTwXtJm3JipjAlWgymBorLeR9Wu95m7F3I8VND0qUrhXz
         2kLXzFdc6ZNaXrchD2hQcAFzzripMYiNOgqqb3sXfUFGRJgZrU9zBq04cq3AhXtJb9AR
         CCiSyWv/Huckyrxkbn7iM7ZKoATcb1UouiVV//2VjZ+cj8o8h9D3x1LE8mYSgf4TIEi7
         ZTDHQxjhSwuvdpv5zovKPGIujlgcaWPBM/j8pZahA/tVR3pM1bOsQGzir66nAlmPZF21
         Y0CXoge1stW8z7f2YizWf59KT93h9LaLscMshe8xuF1j+i+vrVXL75wmuKwaow4eQI8W
         3dpQ==
X-Gm-Message-State: AC+VfDzZvpyjnVecZbuitmiYBAROq2zh/G925Xi3dxa2uw7ElrmD3EyU
        IQaQqyPOPWg0RvP/WWir3l1hOgDpx2c=
X-Google-Smtp-Source: ACHHUZ4JHey+mOcsGiVcMsGqCzw8ThMYj8C/n07M15B/TbYvFT//nOZBrO0Oqn5wlK0fWMOwcq0sWS2EXSo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:fc4:b0:24d:fb1d:106d with SMTP id
 gd4-20020a17090b0fc400b0024dfb1d106dmr537997pjb.2.1685037374878; Thu, 25 May
 2023 10:56:14 -0700 (PDT)
Date:   Thu, 25 May 2023 10:56:13 -0700
In-Reply-To: <20230420104622.12504-5-ljrcore@126.com>
Mime-Version: 1.0
References: <20230420104622.12504-1-ljrcore@126.com> <20230420104622.12504-5-ljrcore@126.com>
Message-ID: <ZG+hPaVxYcBq8S5o@google.com>
Subject: Re: [PATCH v2 4/7] KVM: x86/pmu: Add documentation for fixed ctr on
 PMU filter
From:   Sean Christopherson <seanjc@google.com>
To:     Jinrong Liang <ljr.kernel@gmail.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Jinrong Liang <cloudliang@tencent.com>,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20, 2023, Jinrong Liang wrote:
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> From: Jinrong Liang <cloudliang@tencent.com>
> 
> Update the documentation for the KVM_SET_PMU_EVENT_FILTER ioctl
> to include a detailed description of how fixed performance events
> are handled in the pmu filter. The action and fixed_counter_bitmap
> members of the pmu filter to determine whether fixed performance
> events can be programmed by the guest. This information is helpful
> for correctly configuring the fixed_counter_bitmap and action fields
> to filter fixed performance events.
> 
> Suggested-by: Like Xu <likexu@tencent.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304150850.rx4UDDsB-lkp@intel.com
> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> ---

Please post this separately from the selftests changes.

>  1 file changed, 21 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a69e91088d76..b5836767e0e7 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5122,6 +5122,27 @@ Valid values for 'action'::
>    #define KVM_PMU_EVENT_ALLOW 0
>    #define KVM_PMU_EVENT_DENY 1
>  
> +Via this API, KVM userspace can also control the behavior of the VM's fixed
> +counters (if any) by configuring the "action" and "fixed_counter_bitmap" fields.
> +
> +Specifically, KVM follows the following pseudo-code when determining whether to
> +allow the guest FixCtr[i] to count its pre-defined fixed event::
> +
> +  FixCtr[i]_is_allowed = (action == ALLOW) && (bitmap & BIT(i)) ||
> +    (action == DENY) && !(bitmap & BIT(i));
> +  FixCtr[i]_is_denied = !FixCtr[i]_is_allowed;
> +
> +Note once this API interface is called, the default zero value of the field

No, there is no "default" value.  Userspace provides the exact value.  The KVM
*selftest* clears fixed_counter_bitmap in all cases, but there is no default
anywhere.

> +"fixed_counter_bitmap" will implicitly affect all fixed counters, even if it's

There is no implicit behavior, userspace very explicitly provides fixed_counter_bitmap.

> +expected to be used only to control the events on generic counters.

I would rather phrase this as:

---
KVM always consumes fixed_counter_bitmap, it's userspace's responsibility to
ensure fixed_counter_bitmap is set correctly, e.g. if userspace wants to define
a filter that only affects general purpose counters.
---

> +In addition, pre-defined performance events on the fixed counters already have
> +event_select and unit_mask values defined, which means userspace can also
> +control fixed counters by configuring "action"+ "events" fields.
>
> +When there is a contradiction between these two polices, the fixed performance
> +counter will only follow the rule of the pseudo-code above.

This is unnecessary vague.  I think what you're saying is, with a slight reword
of the first paragraph too:

---
Note, the "events" field also applies to fixed counters' hardcoded event_select
and unit_mask values.  "fixed_counter_bitmap" has higher priority than "events"
if there is a contradiction between the two.
---
