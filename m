Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941646DCA1D
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 19:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjDJRkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 13:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjDJRkX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 13:40:23 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79000F2
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 10:40:21 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a2104d8b00so339795ad.1
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 10:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681148421; x=1683740421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmS3g7a9fA+IzlthKOru22XUKTZ8ieK1g9PJz+KuvzU=;
        b=X7NovNLqlnVzsEYlVLQjIKU0SdWNeJrMv3EsVB3BZ/ZeCNUKoGM6h9eTLlEUcCYtRO
         kPnrOc32ByUnaSbtiIJVrehZuvOpp4HASi5EDJqlugnGkM/hbxvH70YstORCFy6DbSqC
         kwhzABb95hTiC/Jz2RTDxrW2yEhKtpa8JNx4yK/gIBEuGRsU8RzULC38flPWlk/0Ycq6
         N6g+KXxFoF817e/H6fWPj3enXg/EmkfF74bwsH0+p2ZulCiWLFIb/f65QOxoNx+TNN/u
         ZanpsNz4fHtTfWCRFCa57hJR9+1+IF0PMzzZUPXgRcBAFZ0nnJQL4gLKPeT0ga3V99WD
         KHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681148421; x=1683740421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmS3g7a9fA+IzlthKOru22XUKTZ8ieK1g9PJz+KuvzU=;
        b=1JUfcMDzre3DE0yhMnNQ1jihbPQr7hndrgs+2xD/llJUpoMnpzry95JhFI/o8vljmV
         sQf/Y5Le8R8j2At6YAeXIWK6iGJfUfar8ojbjQrz0q6HQhoehx47BLMF65Xkqf4cafqc
         yUEov06GvE2C6y/4/CWgkO0Nt6zIiaiVoy8uED4BZQtgXk4m/VhR6uvBPSmVb/v/Ud4V
         Jh38wR+/ZOea8r0E5n5/h8v3SCeyhiy4eNeyUMToEaUw5zUhIwUuvXaUTOv+kIJ4VcWj
         dlg90Jl2rfBm4GjMBykPQsMmum/4SZ0z/55hCA4ocsyoSFjR//L70ZgmihBhkzIlfkTI
         +fWg==
X-Gm-Message-State: AAQBX9elvvfExjOi14hzt1w4/Bw3YSwJSdiiMr6v3vyRgivNoRE8GZv8
        4XWBil2B2LqzG02xG0UDRW/b4A==
X-Google-Smtp-Source: AKy350bveW6How+9YYxTFmPlbhU9btR1uHIB4KV+Sar+uR+fI43+QRhezAgEI0cdxchXrF3bptj6gA==
X-Received: by 2002:a17:902:9b83:b0:19b:c61:2867 with SMTP id y3-20020a1709029b8300b0019b0c612867mr489338plp.15.1681148420705;
        Mon, 10 Apr 2023 10:40:20 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id x9-20020a1709028ec900b0019a773419a6sm8063433plo.170.2023.04.10.10.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 10:40:20 -0700 (PDT)
Date:   Mon, 10 Apr 2023 10:40:16 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     kernel test robot <lkp@intel.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com,
        oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v7 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
Message-ID: <ZDRKAIKQsOdIQlPn@google.com>
References: <20230409063000.3559991-6-ricarkol@google.com>
 <202304091707.ALABRVCG-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202304091707.ALABRVCG-lkp@intel.com>
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 09, 2023 at 05:36:02PM +0800, kernel test robot wrote:
> Hi Ricardo,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on kvm/queue]
> [also build test ERROR on mst-vhost/linux-next linus/master v6.3-rc5 next-20230406]
> [cannot apply to kvmarm/next kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Ricardo-Koller/KVM-arm64-Rename-free_removed-to-free_unlinked/20230409-143229
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> patch link:    https://lore.kernel.org/r/20230409063000.3559991-6-ricarkol%40google.com
> patch subject: [PATCH v7 04/12] KVM: arm64: Add kvm_pgtable_stage2_split()
> config: arm64-defconfig (https://download.01.org/0day-ci/archive/20230409/202304091707.ALABRVCG-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/c94328e3e8b2d2d873503360ea730c87f4a03301
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Ricardo-Koller/KVM-arm64-Rename-free_removed-to-free_unlinked/20230409-143229
>         git checkout c94328e3e8b2d2d873503360ea730c87f4a03301
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash arch/arm64/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202304091707.ALABRVCG-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/bitfield.h:10,
>                     from arch/arm64/kvm/hyp/pgtable.c:10:
>    arch/arm64/kvm/hyp/pgtable.c: In function 'stage2_split_walker':
> >> include/linux/container_of.h:20:54: error: 'struct kvm_s2_mmu' has no member named 'split_page_cache'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |                                                      ^~
>    include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
>       78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>          |                                                        ^~~~
>    include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |         ^~~~~~~~~~~~~
>    include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |                       ^~~~~~~~~~~
>    arch/arm64/kvm/hyp/pgtable.c:1340:15: note: in expansion of macro 'container_of'
>     1340 |         mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
>          |               ^~~~~~~~~~~~
>    include/linux/compiler_types.h:338:27: error: expression in static assertion is not an integer
>      338 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
>          |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
>       78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>          |                                                        ^~~~
>    include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |         ^~~~~~~~~~~~~
>    include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |                       ^~~~~~~~~~~
>    arch/arm64/kvm/hyp/pgtable.c:1340:15: note: in expansion of macro 'container_of'
>     1340 |         mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
>          |               ^~~~~~~~~~~~
>    In file included from include/uapi/linux/posix_types.h:5,
>                     from include/uapi/linux/types.h:14,
>                     from include/linux/types.h:6,
>                     from include/linux/kasan-checks.h:5,
>                     from include/asm-generic/rwonce.h:26,
>                     from arch/arm64/include/asm/rwonce.h:71,
>                     from include/linux/compiler.h:247,
>                     from include/linux/build_bug.h:5:
> >> include/linux/stddef.h:16:33: error: 'struct kvm_s2_mmu' has no member named 'split_page_cache'
>       16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
>          |                                 ^~~~~~~~~~~~~~~~~~
>    include/linux/container_of.h:23:28: note: in expansion of macro 'offsetof'
>       23 |         ((type *)(__mptr - offsetof(type, member))); })
>          |                            ^~~~~~~~
>    arch/arm64/kvm/hyp/pgtable.c:1340:15: note: in expansion of macro 'container_of'
>     1340 |         mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
>          |               ^~~~~~~~~~~~
> --
>    In file included from include/linux/bitfield.h:10,
>                     from arch/arm64/kvm/hyp/nvhe/../pgtable.c:10:
>    arch/arm64/kvm/hyp/nvhe/../pgtable.c: In function 'stage2_split_walker':
> >> include/linux/container_of.h:20:54: error: 'struct kvm_s2_mmu' has no member named 'split_page_cache'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |                                                      ^~
>    include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
>       78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>          |                                                        ^~~~
>    include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |         ^~~~~~~~~~~~~
>    include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |                       ^~~~~~~~~~~
>    arch/arm64/kvm/hyp/nvhe/../pgtable.c:1340:15: note: in expansion of macro 'container_of'
>     1340 |         mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
>          |               ^~~~~~~~~~~~
>    include/linux/compiler_types.h:338:27: error: expression in static assertion is not an integer
>      338 | #define __same_type(a, b) __builtin_types_compatible_p(typeof(a), typeof(b))
>          |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/build_bug.h:78:56: note: in definition of macro '__static_assert'
>       78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
>          |                                                        ^~~~
>    include/linux/container_of.h:20:9: note: in expansion of macro 'static_assert'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |         ^~~~~~~~~~~~~
>    include/linux/container_of.h:20:23: note: in expansion of macro '__same_type'
>       20 |         static_assert(__same_type(*(ptr), ((type *)0)->member) ||       \
>          |                       ^~~~~~~~~~~
>    arch/arm64/kvm/hyp/nvhe/../pgtable.c:1340:15: note: in expansion of macro 'container_of'
>     1340 |         mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
>          |               ^~~~~~~~~~~~
>    In file included from include/uapi/linux/posix_types.h:5,
>                     from include/uapi/linux/types.h:14,
>                     from include/linux/types.h:6,
>                     from include/linux/kasan-checks.h:5,
>                     from include/asm-generic/rwonce.h:26,
>                     from arch/arm64/include/asm/rwonce.h:71,
>                     from include/linux/compiler.h:247,
>                     from include/linux/build_bug.h:5:
> >> include/linux/stddef.h:16:33: error: 'struct kvm_s2_mmu' has no member named 'split_page_cache'
>       16 | #define offsetof(TYPE, MEMBER)  __builtin_offsetof(TYPE, MEMBER)
>          |                                 ^~~~~~~~~~~~~~~~~~
>    include/linux/container_of.h:23:28: note: in expansion of macro 'offsetof'
>       23 |         ((type *)(__mptr - offsetof(type, member))); })
>          |                            ^~~~~~~~
>    arch/arm64/kvm/hyp/nvhe/../pgtable.c:1340:15: note: in expansion of macro 'container_of'
>     1340 |         mmu = container_of(mc, struct kvm_s2_mmu, split_page_cache);
>          |               ^~~~~~~~~~~~
> 
> 
> vim +20 include/linux/container_of.h
> 
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08   9  
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  10  /**
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  11   * container_of - cast a member of a structure out to the containing structure
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  12   * @ptr:	the pointer to the member.
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  13   * @type:	the type of the container struct this is embedded in.
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  14   * @member:	the name of the member within the struct.
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  15   *
> 7376e561fd2e01 Sakari Ailus     2022-10-24  16   * WARNING: any const qualifier of @ptr is lost.
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  17   */
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  18  #define container_of(ptr, type, member) ({				\
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  19  	void *__mptr = (void *)(ptr);					\
> e1edc277e6f6df Rasmus Villemoes 2021-11-08 @20  	static_assert(__same_type(*(ptr), ((type *)0)->member) ||	\
> e1edc277e6f6df Rasmus Villemoes 2021-11-08  21  		      __same_type(*(ptr), void),			\
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  22  		      "pointer type mismatch in container_of()");	\
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  23  	((type *)(__mptr - offsetof(type, member))); })
> d2a8ebbf8192b8 Andy Shevchenko  2021-11-08  24  
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests
> 

Hi,

The fix is to move the commit introducing KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
right before this one, like this:

	KVM: arm64: Rename free_removed to free_unlinked
	KVM: arm64: Add KVM_PGTABLE_WALK flags for skipping CMOs and BBM TLBIs
	KVM: arm64: Add helper for creating unlinked stage2 subtrees
KVM: arm64: Export kvm_are_all_memslots_empty()
KVM: arm64: Add KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
	KVM: arm64: Add kvm_pgtable_stage2_split()
	KVM: arm64: Refactor kvm_arch_commit_memory_region()
	KVM: arm64: Add kvm_uninit_stage2_mmu()
	KVM: arm64: Split huge pages when dirty logging is enabled
	KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
	KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
	KVM: arm64: Use local TLBI on permission relaxation

Thanks,
Ricardo
