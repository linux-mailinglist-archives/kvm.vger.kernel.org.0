Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FA1364846
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhDSQdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhDSQdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:33:53 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784E5C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:33:23 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id v13so13602062ilj.8
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqLI60sjSsT5Okt3elXRCoAP14unLg0uiOTnUf56les=;
        b=XbFAw5Wb1z9NWcItuaUVZiUE20XR+pHQErtcmU0HMM1588xPaP3ic45eLKIBrwKx+t
         7yxeC5U++LQEgpM0nInY/4Dwz1FebEfDwEDObBn9Iv56ODCnWq4Ae/5rXocg2jnJ4hw8
         m61N+XXgweqX62OyYaC10u7lZRRxLJfc3aIxhGlVTROt/xby2Ld7FeSrHik2h1YtHIhB
         vO4C5GG6FgBRuZBikNWT05JJuf8SRBBEvSXNjy3I4ZO1fz5pwFDx1gdFbYI2UfBZu99p
         1AMkHS/EjBmSp5f9d3J0qOxBWVQdl+9SzWFoLgeMv2KxH2Amb5fQnpVLPZyqpmIYYvq3
         c1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TqLI60sjSsT5Okt3elXRCoAP14unLg0uiOTnUf56les=;
        b=Sy4EIvcPXzv6F3knf0+BN57uouSa9TM//WIt2+mJZUnG2OFdonmklrMErDqajoTKX5
         yKkMq2clVtmRB2HQ8UKZNEGhXSoTlDsEUDWHqY4WM4QvA6B7cMWVvOmaoc25i0I3Yn0d
         QbwxFKOFFB/tkE1MnReB3h07331idLFaXXYkFfuG/l5YNRQKB6uDsoUrxdKNKKNBwkNm
         BikWo/oUm7LI0I6NoD9UHLDbjeZenKWasjSyHSxbhVmBHl6SAc8O54bQIMQnWbot8Bon
         nLt0V3ZEdwD1ULks9lSPUFG3eeMZjRig1LugDZGrIy70WFP1VnHsAWHJOWFkWcAaQLbr
         9/Iw==
X-Gm-Message-State: AOAM530b2N5B1ag1N47E9YVFzQz6+l8ZPp5C/7+8LZt8laumhk7GG7vA
        0s+jpLATqewAVD/KbXcSfAXJ6gLwmW5nOAb3i4J8lK9EgKE=
X-Google-Smtp-Source: ABdhPJyqaZf7nqdPzo/Ysi8H6/297HxD5ZiDlvEiZvp2L7lblZbKdRkP8aCsU40eVXlZGL26w9MkjyvqJIz0CatRpbU=
X-Received: by 2002:a92:3f08:: with SMTP id m8mr5672265ila.154.1618850002798;
 Mon, 19 Apr 2021 09:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <202104172326.ZkdtgfKs-lkp@intel.com>
In-Reply-To: <202104172326.ZkdtgfKs-lkp@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 19 Apr 2021 09:33:11 -0700
Message-ID: <CANgfPd9WOLmQsDqQgtA5k4UHC+r6jPF4xFN5_gizg_fFa+LXjQ@mail.gmail.com>
Subject: Re: [kvm:queue 153/154] arch/x86/kvm/mmu/mmu.c:5443:39: error:
 'struct kvm_arch' has no member named 'tdp_mmu_roots'
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, kvm <kvm@vger.kernel.org>,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I must have failed to propagate some #define CONFIG_x86_64 tags
around. I can send out some patches to fix this and the other bug the
test robot found.

On Sat, Apr 17, 2021 at 8:40 AM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   3afb84581509b8d28979d15b5d727366efb3c8e5
> commit: 1336c692abad5a737dd6d18b30fae2e2183f73f7 [153/154] KVM: x86/mmu: Fast invalidation for TDP MMU
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=1336c692abad5a737dd6d18b30fae2e2183f73f7
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout 1336c692abad5a737dd6d18b30fae2e2183f73f7
>         # save the attached .config to linux build tree
>         make W=1 W=1 ARCH=i386
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/cpumask.h:10,
>                     from include/linux/mm_types_task.h:14,
>                     from include/linux/mm_types.h:5,
>                     from arch/x86/kvm/irq.h:13,
>                     from arch/x86/kvm/mmu/mmu.c:18:
>    arch/x86/kvm/mmu/mmu.c: In function 'kvm_mmu_zap_all_fast':
> >> arch/x86/kvm/mmu/mmu.c:5443:39: error: 'struct kvm_arch' has no member named 'tdp_mmu_roots'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |                                       ^
>    include/linux/kernel.h:708:26: note: in definition of macro 'container_of'
>      708 |  void *__mptr = (void *)(ptr);     \
>          |                          ^~~
>    include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
>      522 |  list_entry((ptr)->next, type, member)
>          |  ^~~~~~~~~~
>    include/linux/list.h:628:13: note: in expansion of macro 'list_first_entry'
>      628 |  for (pos = list_first_entry(head, typeof(*pos), member); \
>          |             ^~~~~~~~~~~~~~~~
>    arch/x86/kvm/mmu/mmu.c:5443:3: note: in expansion of macro 'list_for_each_entry'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |   ^~~~~~~~~~~~~~~~~~~
>    In file included from <command-line>:
> >> arch/x86/kvm/mmu/mmu.c:5443:39: error: 'struct kvm_arch' has no member named 'tdp_mmu_roots'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |                                       ^
>    include/linux/compiler_types.h:300:9: note: in definition of macro '__compiletime_assert'
>      300 |   if (!(condition))     \
>          |         ^~~~~~~~~
>    include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
>      320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |  ^~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>       39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>          |                                     ^~~~~~~~~~~~~~~~~~
>    include/linux/kernel.h:709:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>      709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>          |  ^~~~~~~~~~~~~~~~
>    include/linux/kernel.h:709:20: note: in expansion of macro '__same_type'
>      709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>          |                    ^~~~~~~~~~~
>    include/linux/list.h:511:2: note: in expansion of macro 'container_of'
>      511 |  container_of(ptr, type, member)
>          |  ^~~~~~~~~~~~
>    include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
>      522 |  list_entry((ptr)->next, type, member)
>          |  ^~~~~~~~~~
>    include/linux/list.h:628:13: note: in expansion of macro 'list_first_entry'
>      628 |  for (pos = list_first_entry(head, typeof(*pos), member); \
>          |             ^~~~~~~~~~~~~~~~
>    arch/x86/kvm/mmu/mmu.c:5443:3: note: in expansion of macro 'list_for_each_entry'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |   ^~~~~~~~~~~~~~~~~~~
> >> arch/x86/kvm/mmu/mmu.c:5443:39: error: 'struct kvm_arch' has no member named 'tdp_mmu_roots'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |                                       ^
>    include/linux/compiler_types.h:300:9: note: in definition of macro '__compiletime_assert'
>      300 |   if (!(condition))     \
>          |         ^~~~~~~~~
>    include/linux/compiler_types.h:320:2: note: in expansion of macro '_compiletime_assert'
>      320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |  ^~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
>       39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>          |                                     ^~~~~~~~~~~~~~~~~~
>    include/linux/kernel.h:709:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>      709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>          |  ^~~~~~~~~~~~~~~~
>    include/linux/kernel.h:710:6: note: in expansion of macro '__same_type'
>      710 |     !__same_type(*(ptr), void),   \
>          |      ^~~~~~~~~~~
>    include/linux/list.h:511:2: note: in expansion of macro 'container_of'
>      511 |  container_of(ptr, type, member)
>          |  ^~~~~~~~~~~~
>    include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
>      522 |  list_entry((ptr)->next, type, member)
>          |  ^~~~~~~~~~
>    include/linux/list.h:628:13: note: in expansion of macro 'list_first_entry'
>      628 |  for (pos = list_first_entry(head, typeof(*pos), member); \
>          |             ^~~~~~~~~~~~~~~~
>    arch/x86/kvm/mmu/mmu.c:5443:3: note: in expansion of macro 'list_for_each_entry'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |   ^~~~~~~~~~~~~~~~~~~
>    In file included from include/linux/mm_types.h:8,
>                     from arch/x86/kvm/irq.h:13,
>                     from arch/x86/kvm/mmu/mmu.c:18:
> >> arch/x86/kvm/mmu/mmu.c:5443:39: error: 'struct kvm_arch' has no member named 'tdp_mmu_roots'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |                                       ^
>    include/linux/list.h:619:20: note: in definition of macro 'list_entry_is_head'
>      619 |  (&pos->member == (head))
>          |                    ^~~~
>    arch/x86/kvm/mmu/mmu.c:5443:3: note: in expansion of macro 'list_for_each_entry'
>     5443 |   list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>          |   ^~~~~~~~~~~~~~~~~~~
>
>
> vim +5443 arch/x86/kvm/mmu/mmu.c
>
>   5398
>   5399  /*
>   5400   * Fast invalidate all shadow pages and use lock-break technique
>   5401   * to zap obsolete pages.
>   5402   *
>   5403   * It's required when memslot is being deleted or VM is being
>   5404   * destroyed, in these cases, we should ensure that KVM MMU does
>   5405   * not use any resource of the being-deleted slot or all slots
>   5406   * after calling the function.
>   5407   */
>   5408  static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>   5409  {
>   5410          struct kvm_mmu_page *root;
>   5411
>   5412          lockdep_assert_held(&kvm->slots_lock);
>   5413
>   5414          write_lock(&kvm->mmu_lock);
>   5415          trace_kvm_mmu_zap_all_fast(kvm);
>   5416
>   5417          /*
>   5418           * Toggle mmu_valid_gen between '0' and '1'.  Because slots_lock is
>   5419           * held for the entire duration of zapping obsolete pages, it's
>   5420           * impossible for there to be multiple invalid generations associated
>   5421           * with *valid* shadow pages at any given time, i.e. there is exactly
>   5422           * one valid generation and (at most) one invalid generation.
>   5423           */
>   5424          kvm->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen ? 0 : 1;
>   5425
>   5426
>   5427          if (is_tdp_mmu_enabled(kvm)) {
>   5428                  /*
>   5429                   * Mark each TDP MMU root as invalid so that other threads
>   5430                   * will drop their references and allow the root count to
>   5431                   * go to 0.
>   5432                   *
>   5433                   * This has essentially the same effect for the TDP MMU
>   5434                   * as updating mmu_valid_gen above does for the shadow
>   5435                   * MMU.
>   5436                   *
>   5437                   * In order to ensure all threads see this change when
>   5438                   * handling the MMU reload signal, this must happen in the
>   5439                   * same critical section as kvm_reload_remote_mmus, and
>   5440                   * before kvm_zap_obsolete_pages as kvm_zap_obsolete_pages
>   5441                   * could drop the MMU lock and yield.
>   5442                   */
> > 5443                  list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
>   5444                          root->role.invalid = true;
>   5445          }
>   5446
>   5447          /*
>   5448           * Notify all vcpus to reload its shadow page table and flush TLB.
>   5449           * Then all vcpus will switch to new shadow page table with the new
>   5450           * mmu_valid_gen.
>   5451           *
>   5452           * Note: we need to do this under the protection of mmu_lock,
>   5453           * otherwise, vcpu would purge shadow page but miss tlb flush.
>   5454           */
>   5455          kvm_reload_remote_mmus(kvm);
>   5456
>   5457          kvm_zap_obsolete_pages(kvm);
>   5458
>   5459          write_unlock(&kvm->mmu_lock);
>   5460  }
>   5461
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
