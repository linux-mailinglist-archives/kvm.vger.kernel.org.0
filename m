Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5DA364838
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhDSQbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbhDSQbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:31:01 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F68C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:30:31 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id l9so1182122ilh.10
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8L20ayb80fxI9Hn2qNn1WmMZAoqAnfSn5pbsfo2ewRk=;
        b=a+RibuCMe2zMBy+tcXlF+C9YCkRt93t2+AzoFUYsDe4aeWPgpYf5Qf687bppsDUwxI
         ZfF3epsbl17LZpW0EhNtCBFooQzg5Ix3kHiifqUgA2/xf9dzWcu05KVS0tZTrcfi78M1
         fK/FaqdxyQwKJSvDef0n66r1gn5cKEr3b9HOe+UrYnOv1nkGS3pOXlXVjPulHKz9LbhJ
         SCRaXdRjoEOYqcyr+y8udeTbOcWbUgsVg6LaG0vMlZW0PHyHw0qOb3YB8GWWGWCXqdDH
         vnfCaHrvlugeARgacVlBzUx1kH4VGnHPc7vaLS5WiYeei4xEHVfkCTNstyxcP/Efmqip
         Ruuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8L20ayb80fxI9Hn2qNn1WmMZAoqAnfSn5pbsfo2ewRk=;
        b=ZkArlWlp4SAAWuXNgzVuMlN4vvGTMu2cjE3W8fn/BevXAU0Gz7OMfNV5b43Vn9O1kQ
         jKkNeKrRqpXTl49gNnlwQQzS24a9H3FRw0SOlpKdXiNoANx6qkz7g/9wx04laKGxk+ri
         XdlxC6XtDnwb3XXEPlY0prsVV5LZg8RBDco1r/ox8zjCL88YD6fnfFDDZF3z2xjddGhO
         fqGJ+nNS3jCbls59rd3qedfLU4+X7kPgZRqtH11lJiEFZYO5x6h7hwesd7gjp1nVGV42
         FM4NNFJqQa2wgPRtqcfeQQaAIk+irG+1s5O9u16LWOzmBFpyEQbhOp8o0hmoc8WH4lZ/
         0A8w==
X-Gm-Message-State: AOAM531XkVnNbES7QlfaPRcaroRS2tR3usyUEucLywE0iyEjyi2IA99V
        SPBYlMI4VZ5+cewODo18xPHHwCi5AQG+/j76UbLsv1iKWlU=
X-Google-Smtp-Source: ABdhPJwr23Gkd8ETYOxfKqEye8xuvgrzCqu7L0G/Q+AT4FVkh4wx961ZSi/CWiDU8wh1cLCNuAxHu2Ln+rgG4tinsGo=
X-Received: by 2002:a92:3f08:: with SMTP id m8mr5661403ila.154.1618849830516;
 Mon, 19 Apr 2021 09:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <202104172304.sIDndFfW-lkp@intel.com>
In-Reply-To: <202104172304.sIDndFfW-lkp@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 19 Apr 2021 09:30:19 -0700
Message-ID: <CANgfPd8_1vikhFepkNVXCTjB8zcmq1-2kcOYXckUn3BNfSjH7g@mail.gmail.com>
Subject: Re: [kvm:queue 149/154] arch/x86/kvm/mmu/tdp_mmu.c:141:5: error:
 implicit declaration of function 'lockdep_is_help'; did you mean 'lockdep_is_held'?
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

Well that's embarrassing, I can't believe I didn't catch that in my
testing. I'm sure I built the kernel with lockdep enabled several
times.
Ah well, I can send a fix out for this and the other issue the test bot found.

On Sat, Apr 17, 2021 at 8:20 AM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> head:   3afb84581509b8d28979d15b5d727366efb3c8e5
> commit: 078d47ee71d6a53657b5917ce1478f10bc173fa5 [149/154] KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=078d47ee71d6a53657b5917ce1478f10bc173fa5
>         git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
>         git fetch --no-tags kvm queue
>         git checkout 078d47ee71d6a53657b5917ce1478f10bc173fa5
>         # save the attached .config to linux build tree
>         make W=1 W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    In file included from include/linux/rculist.h:11,
>                     from include/linux/pid.h:5,
>                     from include/linux/sched.h:14,
>                     from include/linux/kvm_host.h:12,
>                     from arch/x86/kvm/mmu.h:5,
>                     from arch/x86/kvm/mmu/tdp_mmu.c:3:
>    arch/x86/kvm/mmu/tdp_mmu.c: In function 'kvm_tdp_mmu_get_vcpu_root_hpa':
> >> arch/x86/kvm/mmu/tdp_mmu.c:141:5: error: implicit declaration of function 'lockdep_is_help'; did you mean 'lockdep_is_held'? [-Werror=implicit-function-declaration]
>      141 |     lockdep_is_help(&kvm->arch.tdp_mmu_pages_lock)) \
>          |     ^~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:318:52: note: in definition of macro 'RCU_LOCKDEP_WARN'
>      318 |   if (debug_lockdep_rcu_enabled() && !__warned && (c)) { \
>          |                                                    ^
>    include/linux/rculist.h:391:7: note: in expansion of macro '__list_check_rcu'
>      391 |  for (__list_check_rcu(dummy, ## cond, 0),   \
>          |       ^~~~~~~~~~~~~~~~
>    arch/x86/kvm/mmu/tdp_mmu.c:139:2: note: in expansion of macro 'list_for_each_entry_rcu'
>      139 |  list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,  \
>          |  ^~~~~~~~~~~~~~~~~~~~~~~
>    arch/x86/kvm/mmu/tdp_mmu.c:188:2: note: in expansion of macro 'for_each_tdp_mmu_root'
>      188 |  for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
>          |  ^~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
>
>
> vim +141 arch/x86/kvm/mmu/tdp_mmu.c
>
>    124
>    125  /*
>    126   * Note: this iterator gets and puts references to the roots it iterates over.
>    127   * This makes it safe to release the MMU lock and yield within the loop, but
>    128   * if exiting the loop early, the caller must drop the reference to the most
>    129   * recent root. (Unless keeping a live reference is desirable.)
>    130   */
>    131  #define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)   \
>    132          for (_root = tdp_mmu_next_root(_kvm, NULL);             \
>    133               _root;                                             \
>    134               _root = tdp_mmu_next_root(_kvm, _root))            \
>    135                  if (kvm_mmu_page_as_id(_root) != _as_id) {      \
>    136                  } else
>    137
>    138  #define for_each_tdp_mmu_root(_kvm, _root, _as_id)                              \
>    139          list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,         \
>    140                                  lockdep_is_held_type(&kvm->mmu_lock, 0) ||      \
>  > 141                                  lockdep_is_help(&kvm->arch.tdp_mmu_pages_lock)) \
>    142                  if (kvm_mmu_page_as_id(_root) != _as_id) {              \
>    143                  } else
>    144
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
