Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79122B509D
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 20:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgKPTPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 14:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgKPTPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 14:15:47 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733D8C0613CF
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 11:15:46 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id r12so18598058iot.4
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 11:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99NQEfWpebH0JZaPShV/ZqMQjroijwm6vQAuryLgtTY=;
        b=pUz0P3tVeQ1RUtxaQlmVb7n2wzh5gwNgAG6ufxYyL5uE4Nl8s3pqivW4DjCtE8gLyA
         zoY5brm2mBYemwf6Rl2FjcICOM1eTAbq1MZcPwUFrQyKDuLwAOp1VqwVxKmGoeTdg+m8
         ZG4D8jMOq3McrUDezA8IMEaTL4OTBluEg4CmunOW0/sZJll1jO/FyCBkQfKSaMhh83jl
         NWa6XfKs4dRFSG9Ybz/o11Xsua/MZEwJJtsJcyQSgSwEVZ8sQkHRyBe9jKUcgQHeNMSQ
         lRMiLKkhN7NtLYcMPHRMqi3907PYnn/7meP2Jgagx1nOcEnv1sGS5plhsILl3Q3J+1iK
         c5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99NQEfWpebH0JZaPShV/ZqMQjroijwm6vQAuryLgtTY=;
        b=fAcANcx5rfgKPOxtlmVM+aEmh5V9I9g4Q52faWqB48rjTH/BA83H4Jb1RQTyk/tq7A
         In/73EW92A7Jkj1WLSvE0aPsQE6G+KTCMCHiRVorwxQA0H6ZE2q1raJ7sHRtBMSowX3Q
         tyojaYy3BxGvDU6SyE588f5V1dEEJD0BXtnHvmjA6h1eb4QpnkDoZjKfTEF9frfptZmt
         h1qit9GhLYIT0HjZKSWPp9pP5128MO36l04T7n6bNMRobK3OqYZskYT6KfK/OYOV+X7f
         8uGu3ksUjGmKWBMuXFMHKzQiJcTQYFYzFvLig14IilA3hddq2jN+ubTI/b/9csrP1iw0
         2Z+g==
X-Gm-Message-State: AOAM531DXd7etqlNvY+UcWjewY4WWwZpQqOlaSsfZaal+CuNwHSpVCRV
        HVHnymeB0eV3WpzLp+0+4AFMnH6dajweJZ9+zqQdkQ==
X-Google-Smtp-Source: ABdhPJx/15tWi7ORQegPRDAQikpetJZdcJfF01Qlcy+OPS9EkZLyFeQeAqafT6ivv4CFc/4Air1TOe3iFPRl4jK2Ms4=
X-Received: by 2002:a05:6638:159:: with SMTP id y25mr889816jao.4.1605554145510;
 Mon, 16 Nov 2020 11:15:45 -0800 (PST)
MIME-Version: 1.0
References: <20201027175944.1183301-1-bgardon@google.com>
In-Reply-To: <20201027175944.1183301-1-bgardon@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 16 Nov 2020 11:15:34 -0800
Message-ID: <CANgfPd8FkNL-05P7us6sPq8pXPJ1jedXGMPkR2OrvTtg8+WSLg@mail.gmail.com>
Subject: Re: [PATCH 1/2] kvm: x86/mmu: Add existing trace points to TDP MMU
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 10:59 AM Ben Gardon <bgardon@google.com> wrote:
>
> The TDP MMU was initially implemented without some of the usual
> tracepoints found in mmu.c. Correct this discrepancy by adding the
> missing trace points to the TDP MMU.
>
> Tested: ran the demand paging selftest on an Intel Skylake machine with
>         all the trace points used by the TDP MMU enabled and observed
>         them firing with expected values.
>
> This patch can be viewed in Gerrit at:
> https://linux-review.googlesource.com/c/virt/kvm/kvm/+/3812
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 27e381c9da6c2..047e2d966abef 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -7,6 +7,8 @@
>  #include "tdp_mmu.h"
>  #include "spte.h"
>
> +#include <trace/events/kvm.h>
> +
>  #ifdef CONFIG_X86_64
>  static bool __read_mostly tdp_mmu_enabled = false;
>  module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
> @@ -101,6 +103,8 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>         sp->gfn = gfn;
>         sp->tdp_mmu_page = true;
>
> +       trace_kvm_mmu_get_page(sp, true);
> +
>         return sp;
>  }
>
> @@ -271,6 +275,8 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>                 pt = spte_to_child_pt(old_spte, level);
>                 sp = sptep_to_sp(pt);
>
> +               trace_kvm_mmu_prepare_zap_page(sp);
> +
>                 list_del(&sp->link);
>
>                 if (sp->lpage_disallowed)
> @@ -473,11 +479,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>         if (unlikely(is_noslot_pfn(pfn))) {
>                 new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>                 trace_mark_mmio_spte(iter->sptep, iter->gfn, new_spte);
> -       } else
> +       } else {
>                 make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
>                                          pfn, iter->old_spte, prefault, true,
>                                          map_writable, !shadow_accessed_mask,
>                                          &new_spte);
> +               trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
> +       }
>
>         if (new_spte == iter->old_spte)
>                 ret = RET_PF_SPURIOUS;
> @@ -691,6 +699,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
>
>                 tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
>                 young = 1;
> +
> +               trace_kvm_age_page(iter.gfn, iter.level, slot, young);
>         }
>
>         return young;
> --
> 2.29.0.rc2.309.g374f81d7ae-goog
>

If anyone has time to review this short series, I'd appreciate it. I
don't want these to get lost in the shuffle.
Thanks!
