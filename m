Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F527BD034
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 23:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjJHVMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 17:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjJHVMY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 17:12:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E739D;
        Sun,  8 Oct 2023 14:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696799542; x=1728335542;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KTvYRiC5xnxvfy9uGT176OFxMaWQyvYItVYw9cKHphU=;
  b=SEUQdcRXpZNUR2EW3VVE0ACQUZUKj9nRuk+i9amGQ3SRsgbH6KPzSddw
   6UcgmjHbvGv7wpEyHfqX4gEiOwa8vAF+td2O8Beb/9daO/m6kexJmPjvH
   8E7S+b3LsP7EPMh5y0wWwrwQAD1+wDcmV9SNBAJ5kTqBhktl86ijSvXLG
   IFvwdPiV1MNLCW6ccInNVX3n3O7UcJIzHvtfV+RUVcuvrR4mER0FxyIhB
   e+pnZdbtpNjmFYHWadHI87IYQvsS/tnlqzwsx/hjFwAO/qcJKwBZKt6S9
   u24vXlkKL9XNDqec1rWqnlDes1sF5xupKMAwp4OViMLBtutB0QEpjRLS0
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="448228774"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="448228774"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2023 14:12:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10857"; a="756496413"
X-IronPort-AV: E=Sophos;i="6.03,207,1694761200"; 
   d="scan'208";a="756496413"
Received: from lkp-server01.sh.intel.com (HELO 8a3a91ad4240) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 08 Oct 2023 14:12:15 -0700
Received: from kbuild by 8a3a91ad4240 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qpb4R-0005lg-05;
        Sun, 08 Oct 2023 21:12:15 +0000
Date:   Mon, 9 Oct 2023 05:12:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tianyi Liu <i.pear@outlook.com>, seanjc@google.com,
        pbonzini@redhat.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     oe-kbuild-all@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, irogers@google.com, adrian.hunter@intel.com,
        Tianyi Liu <i.pear@outlook.com>
Subject: Re: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling
 guest callchains
Message-ID: <202310090448.ffbVfkHi-lkp@intel.com>
References: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY4P282MB10840154D4F09917D6528BC69DCFA@SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tianyi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Tianyi-Liu/KVM-Add-arch-specific-interfaces-for-sampling-guest-callchains/20231008-230042
base:   8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
patch link:    https://lore.kernel.org/r/SY4P282MB10840154D4F09917D6528BC69DCFA%40SY4P282MB1084.AUSP282.PROD.OUTLOOK.COM
patch subject: [PATCH v2 1/5] KVM: Add arch specific interfaces for sampling guest callchains
config: arm64-randconfig-003-20231009 (https://download.01.org/0day-ci/archive/20231009/202310090448.ffbVfkHi-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231009/202310090448.ffbVfkHi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310090448.ffbVfkHi-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from arch/arm64/include/asm/rwonce.h:71,
                    from include/linux/compiler.h:246,
                    from include/asm-generic/bug.h:5,
                    from arch/arm64/include/asm/bug.h:26,
                    from include/linux/bug.h:5,
                    from arch/arm64/kvm/arm.c:7:
   arch/arm64/kvm/arm.c: In function 'kvm_arch_vcpu_get_frame_pointer':
>> include/linux/stddef.h:8:14: warning: returning 'void *' from a function with return type 'long unsigned int' makes integer from pointer without a cast [-Wint-conversion]
       8 | #define NULL ((void *)0)
         |              ^
   arch/arm64/kvm/arm.c:578:16: note: in expansion of macro 'NULL'
     578 |         return NULL;
         |                ^~~~


vim +8 include/linux/stddef.h

^1da177e4c3f41 Linus Torvalds   2005-04-16  6  
^1da177e4c3f41 Linus Torvalds   2005-04-16  7  #undef NULL
^1da177e4c3f41 Linus Torvalds   2005-04-16 @8  #define NULL ((void *)0)
6e218287432472 Richard Knutsson 2006-09-30  9  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
