Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48AE3C7A43
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhGMXqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhGMXqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:46:06 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7882CC0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:43:15 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id b14so11808725ilf.7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 16:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e6qbOLEIzZSykUqhVj0VnJ+pjllpiCve6F2xddom2ck=;
        b=UjpF3WleRfQISHVQIk+qvC7939sfirKgSI8Pi5yswywYy2jVjD+aARPVoO1NVIpVLS
         FBUeSvO0ss0CJiiHQ6LfrpRovZZ7ClTs5EwZFFI/rKj32J91MU2KXjYLEydyHFfz+H2l
         vBDJxIzLlWe2SusifxDs7vI1JJiT9SqmKJwhmFOB9g6AdIIMN6AzHgpcpRyzU395TzHY
         3L7geOkftEChve45jpQ8muC+zEE1ZPSX8VjS/QmPgRh8xeIhzWSpQORY3wNisJAgVB+g
         yxHdh6cZu0G8Xk53J43o1HAr7AB+Jcjj9bDUd22QjTGxg/msM9g2Jza36OFPfdkpswlW
         RU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e6qbOLEIzZSykUqhVj0VnJ+pjllpiCve6F2xddom2ck=;
        b=ktlZKeUzpwBWM4ickvFBDu9+73bqBpL08LziLmYDygmAU7B+oRnmcguiVGuPjIZvT5
         EkIT3pbhIYxVJ+7K30xy4WXaLpJiudOgYj+AZ2Ct0PSdyTAAgzvM0NrPeo11ANV1FB0b
         8f8NcYLaOQKXAchVHjhMMErYFF1p6e/aJPIg+YgBAtHW4Npth4B2E6Bo5hc1o9VIZ7yU
         hePpUyakkAAou6uqSPi6IqbDV8nOSuhjdDrygrrKebB2GERNtFm0RIEwzhqg+KqTSsVa
         ujSgGxVcUxWmitRd4lTulL8Mat7Cdcnqzh6HtYDadnLlvSu8uMoaOzYlnu4FhygSPmtA
         v3fA==
X-Gm-Message-State: AOAM531l+gAyQnaHUrBLNJyeRC4PYdzisjXStHRuiD3oORt858vByVN3
        xCkGzi3ZGun34kWijC3npGTPxmazh1CUQuXh9Di07A==
X-Google-Smtp-Source: ABdhPJzVQ/OVOJRChjesm3NcVu4SajDoB1vbMDX1YFxXXEPRvp2hIGaD4N5+3tvrojd1oc1wHeRpkfHVJZJ25JRH68s=
X-Received: by 2002:a05:6e02:1c88:: with SMTP id w8mr4672460ill.154.1626219793056;
 Tue, 13 Jul 2021 16:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210713220957.3493520-1-dmatlack@google.com> <20210713220957.3493520-3-dmatlack@google.com>
In-Reply-To: <20210713220957.3493520-3-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 13 Jul 2021 16:43:02 -0700
Message-ID: <CANgfPd9QbH5QBG6PDCD_8ELGK2Pep=F-2h1rCB_LH530qh-v2g@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] KVM: x86/mmu: Fix use of enums in trace_fast_page_fault
To:     David Matlack <dmatlack@google.com>
Cc:     kvm <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 3:10 PM David Matlack <dmatlack@google.com> wrote:
>
> Enum values have to be exported to userspace since the formatting is not
> done in the kernel. Without doing this perf maps RET_PF_FIXED and
> RET_PF_SPURIOUS to 0, which results in incorrect output:
>
>   $ perf record -a -e kvmmmu:fast_page_fault --filter "ret==3" -- ./access_tracking_perf_test
>   $ perf script | head -1
>    [...] new 610006048d25877 spurious 0 fixed 0  <------ should be 1
>
> Fix this by exporting the enum values to userspace with TRACE_DEFINE_ENUM.
>
> Fixes: c4371c2a682e ("KVM: x86/mmu: Return unique RET_PF_* values if the fault was fixed")

Reviewed-by: Ben Gardon <bgardon@google.com>

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu_internal.h | 3 +++
>  arch/x86/kvm/mmu/mmutrace.h     | 6 ++++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 35567293c1fd..626cb848dab4 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -140,6 +140,9 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
>   * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
>   * RET_PF_FIXED: The faulting entry has been fixed.
>   * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
> + *
> + * Any names added to this enum should be exported to userspace for use in
> + * tracepoints via TRACE_DEFINE_ENUM() in mmutrace.h
>   */
>  enum {
>         RET_PF_RETRY = 0,
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index efbad33a0645..2924a4081a19 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -54,6 +54,12 @@
>         { PFERR_RSVD_MASK, "RSVD" },    \
>         { PFERR_FETCH_MASK, "F" }
>
> +TRACE_DEFINE_ENUM(RET_PF_RETRY);
> +TRACE_DEFINE_ENUM(RET_PF_EMULATE);
> +TRACE_DEFINE_ENUM(RET_PF_INVALID);
> +TRACE_DEFINE_ENUM(RET_PF_FIXED);
> +TRACE_DEFINE_ENUM(RET_PF_SPURIOUS);
> +
>  /*
>   * A pagetable walk has started
>   */
> --
> 2.32.0.93.g670b81a890-goog
>
