Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4430366A127
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 18:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjAMRun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 12:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjAMRuM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 12:50:12 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A38CB40C2C
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 09:43:37 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-4bf16baa865so294201837b3.13
        for <kvm@vger.kernel.org>; Fri, 13 Jan 2023 09:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K3cf7M2HST5gUl0uPAkYtSybv0fNWjrltQKA6GbBxJY=;
        b=Ygm//Z2g+onRKYbQS0vNoeC1nzhfRqSsW+gOqXbrk/h7Cz/H7xToX2ASSqoKSRJOH7
         Tep4FfwPic27k/r5ofzs7jQLzjjeVkpWixFYJdoMbjMhHu5MVZprtTq2iRFHJeUhrj9H
         vekjWlBoi5NemFAARjoa+oxoeHkOd63bjKGE25QQ7VY3gjFwhVOFj5L8l4K/o7Txg8j4
         FLAdcH1AaHSOJ/TI/rXG0yPwXJpkJiqNWC4qcxpkXy5SH6OUdfdGmjgUZ2lJVr+Aecep
         Gh/woY4yY7UL3snvcVoCQN8mhSya+Y+E1kRwwWpFLubWEM9UeZv4H4Wiqtsa+R6X/ZLK
         VkuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K3cf7M2HST5gUl0uPAkYtSybv0fNWjrltQKA6GbBxJY=;
        b=v1DfwHh+qppEWU/GLpFr1tL36/fRdkfihcfP8363V2OqmzrAjKEkdocGLISj/5YK9o
         ioFLOEU/HuKT40e875oqZsjrh/f+fHmNcX1G37OIQbthsXhZQz/BsjzOPWu/gF0AZctM
         MY8PlrbCKhUR0i20YjR5I7knNiQE2Iab0z2HvRlMdqPo3e9wz9JRXSjxS5A6Y5JRGzEw
         s8EYv52NDi5Xlwq4SiQVrtqAGLWqLZjSjyIL36RcwE7ZTa/fUiwmjSO+OkuY1obcgZlw
         UUvTfeXTG35/DcpEZBVCwqbAnLVM1ugxRcF9T9H01vE6R/CYcF/27RkkZS25RtePOkxd
         8IDw==
X-Gm-Message-State: AFqh2kr84nfNfQksqFmnNczoBxlcsekI126U6K7O8AkSJzIMUvUsmBfo
        cEnvhURZ14nNV/bAkJ8ILXTznuAkKSrVHqfz9TfLHg==
X-Google-Smtp-Source: AMrXdXtwZgUt8m4FJdjhH8D8XRQ44vyMb4OoabTVzwW/Pc9Pezodd/AXEt2qRiL0uIAr2ycw+M+D4Ml+ZscoW7PcvQk=
X-Received: by 2002:a81:6f42:0:b0:36f:f251:213b with SMTP id
 k63-20020a816f42000000b0036ff251213bmr2037205ywc.228.1673631816578; Fri, 13
 Jan 2023 09:43:36 -0800 (PST)
MIME-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com> <20221221222418.3307832-8-bgardon@google.com>
In-Reply-To: <20221221222418.3307832-8-bgardon@google.com>
From:   Vipin Sharma <vipinsh@google.com>
Date:   Fri, 13 Jan 2023 09:43:00 -0800
Message-ID: <CAHVum0cGYXyjzeoNs8jnS-oD8wz4QwX0VpD9a=U8d++xJNc62A@mail.gmail.com>
Subject: Re: [RFC 07/14] KVM: x86/MMU: Cleanup shrinker interface with Shadow MMU
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Nagareddy Reddy <nspreddy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 2:24 PM Ben Gardon <bgardon@google.com> wrote:
>
> The MMU shrinker currently only operates on the Shadow MMU, but having
> the entire implemenatation in shadow_mmu.c is awkward since much of the
> function isn't Shadow MMU specific. There has also been talk of changing the
> target of the shrinker to the MMU caches rather than already allocated page
> tables. As a result, it makes sense to move some of the implementation back
> to mmu.c.
>

My recommendation is to move the whole function back to mmu.c instead
of splitting. As all logic for shrinker will be contained in one place
instead of spreading it over two files. kvm_shadow_mmu_shrink_scan(),
the new function created in this patch, is not used anywhere else,
there are already some functions which are getting exposed from shadow
mmu in this patch, it will be cleaner to just expose the other
functions needed by shrink_scan() and keep the implementation of
shrink_scan same and at one place.
> No functional change intended.
>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c        | 43 ++++++++++++++++++++++++
>  arch/x86/kvm/mmu/shadow_mmu.c | 62 ++++++++---------------------------
>  arch/x86/kvm/mmu/shadow_mmu.h |  3 +-
>  3 files changed, 58 insertions(+), 50 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dd97e346c786..4c45a5b63356 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3147,6 +3147,49 @@ static unsigned long mmu_shrink_count(struct shrinker *shrink,
>         return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
>  }
>
> +unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +       struct kvm *kvm;
> +       int nr_to_scan = sc->nr_to_scan;
> +       unsigned long freed = 0;
> +
> +       mutex_lock(&kvm_lock);
> +
> +       list_for_each_entry(kvm, &vm_list, vm_list) {
> +               /*
> +                * Never scan more than sc->nr_to_scan VM instances.
> +                * Will not hit this condition practically since we do not try
> +                * to shrink more than one VM and it is very unlikely to see
> +                * !n_used_mmu_pages so many times.
> +                */
> +               if (!nr_to_scan--)
> +                       break;
> +
> +               /*
> +                * n_used_mmu_pages is accessed without holding kvm->mmu_lock
> +                * here. We may skip a VM instance errorneosly, but we do not
> +                * want to shrink a VM that only started to populate its MMU
> +                * anyway.
> +                */
> +               if (!kvm->arch.n_used_mmu_pages &&
> +                   !kvm_shadow_mmu_has_zapped_obsolete_pages(kvm))
> +                       continue;
> +
> +               freed = kvm_shadow_mmu_shrink_scan(kvm, sc->nr_to_scan);
> +
> +               /*
> +                * unfair on small ones
> +                * per-vm shrinkers cry out
> +                * sadness comes quickly
> +                */
> +               list_move_tail(&kvm->vm_list, &vm_list);
> +               break;
> +       }
> +
> +       mutex_unlock(&kvm_lock);
> +       return freed;
> +}
> +
>  static struct shrinker mmu_shrinker = {
>         .count_objects = mmu_shrink_count,
>         .scan_objects = mmu_shrink_scan,
> diff --git a/arch/x86/kvm/mmu/shadow_mmu.c b/arch/x86/kvm/mmu/shadow_mmu.c
> index 090b4788f7de..1259c4a3b140 100644
> --- a/arch/x86/kvm/mmu/shadow_mmu.c
> +++ b/arch/x86/kvm/mmu/shadow_mmu.c
> @@ -3147,7 +3147,7 @@ void kvm_zap_obsolete_pages(struct kvm *kvm)
>         kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
>  }
>
> -static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
> +bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm)
>  {
>         return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
>  }
> @@ -3416,60 +3416,24 @@ void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
>                 kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
>  }
>
> -unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> +unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free)
>  {
> -       struct kvm *kvm;
> -       int nr_to_scan = sc->nr_to_scan;
>         unsigned long freed = 0;
> +       int idx;
>
> -       mutex_lock(&kvm_lock);
> -
> -       list_for_each_entry(kvm, &vm_list, vm_list) {
> -               int idx;
> -               LIST_HEAD(invalid_list);
> -
> -               /*
> -                * Never scan more than sc->nr_to_scan VM instances.
> -                * Will not hit this condition practically since we do not try
> -                * to shrink more than one VM and it is very unlikely to see
> -                * !n_used_mmu_pages so many times.
> -                */
> -               if (!nr_to_scan--)
> -                       break;
> -               /*
> -                * n_used_mmu_pages is accessed without holding kvm->mmu_lock
> -                * here. We may skip a VM instance errorneosly, but we do not
> -                * want to shrink a VM that only started to populate its MMU
> -                * anyway.
> -                */
> -               if (!kvm->arch.n_used_mmu_pages &&
> -                   !kvm_has_zapped_obsolete_pages(kvm))
> -                       continue;
> -
> -               idx = srcu_read_lock(&kvm->srcu);
> -               write_lock(&kvm->mmu_lock);
> -
> -               if (kvm_has_zapped_obsolete_pages(kvm)) {
> -                       kvm_mmu_commit_zap_page(kvm,
> -                             &kvm->arch.zapped_obsolete_pages);
> -                       goto unlock;
> -               }
> +       idx = srcu_read_lock(&kvm->srcu);
> +       write_lock(&kvm->mmu_lock);
>
> -               freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
> +       if (kvm_shadow_mmu_has_zapped_obsolete_pages(kvm)) {
> +               kvm_mmu_commit_zap_page(kvm, &kvm->arch.zapped_obsolete_pages);
> +               goto out;
> +       }
>
> -unlock:
> -               write_unlock(&kvm->mmu_lock);
> -               srcu_read_unlock(&kvm->srcu, idx);
> +       freed = kvm_mmu_zap_oldest_mmu_pages(kvm, pages_to_free);
>
> -               /*
> -                * unfair on small ones
> -                * per-vm shrinkers cry out
> -                * sadness comes quickly
> -                */
> -               list_move_tail(&kvm->vm_list, &vm_list);
> -               break;
> -       }
> +out:
> +       write_unlock(&kvm->mmu_lock);
> +       srcu_read_unlock(&kvm->srcu, idx);
>
> -       mutex_unlock(&kvm_lock);
>         return freed;
>  }
> diff --git a/arch/x86/kvm/mmu/shadow_mmu.h b/arch/x86/kvm/mmu/shadow_mmu.h
> index 20c65a0ea52c..9952aa1e86cf 100644
> --- a/arch/x86/kvm/mmu/shadow_mmu.h
> +++ b/arch/x86/kvm/mmu/shadow_mmu.h
> @@ -99,7 +99,8 @@ void kvm_shadow_mmu_try_split_huge_pages(struct kvm *kvm,
>  void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
>                                     const struct kvm_memory_slot *slot);
>
> -unsigned long mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc);
> +bool kvm_shadow_mmu_has_zapped_obsolete_pages(struct kvm *kvm);
> +unsigned long kvm_shadow_mmu_shrink_scan(struct kvm *kvm, int pages_to_free);
>
>  /* Exports from paging_tmpl.h */
>  gpa_t paging32_gva_to_gpa(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> --
> 2.39.0.314.g84b9a713c41-goog
>
