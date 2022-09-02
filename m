Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DDD5AA613
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiIBCzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiIBCy7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:54:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA76B62FA;
        Thu,  1 Sep 2022 19:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662087294; x=1693623294;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9V5Af5NNhmEKlxmFRt2MBjjPZeFM+QzghrlRJN9oHkU=;
  b=YYyqsqfFSjDw7aLVvGd28oEE+qwe9w0vURr18g5iJKbYnwVMNHiXd2cp
   1JIwed+8I4bQRiy3NKe/YbeEZQeSCxgb068hnQc1kkY2w1EJeZPoLCIYR
   RFQW5HOc0j4vMhIwBBq7pYsO/7HgHVfUqG/YJa3bxmMqG4IHnCKKnEwCA
   VT9npGCJx/nL47JrL8dIHMGssUGyZ28+sEb8N4RVF4uzM17bAB2j+uU5Z
   LRvyW0qKLXCKG2e2HRzCKkyCljRwUwmUi8PdxaLISxvt+IfN5dzcWjB5T
   FwnRPx5DRcbcppCb3RmlvGmSZRTvHEtLC/crHV4svh6aWBYwSp93Sqm1F
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="382178262"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="382178262"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:54:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="589844411"
Received: from lkp-server02.sh.intel.com (HELO fccc941c3034) ([10.239.97.151])
  by orsmga006.jf.intel.com with ESMTP; 01 Sep 2022 19:54:49 -0700
Received: from kbuild by fccc941c3034 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oTwpU-00003L-1E;
        Fri, 02 Sep 2022 02:54:48 +0000
Date:   Fri, 2 Sep 2022 10:54:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH v4 1/5] perf/x86/core: Remove unnecessary stubs provided
 for KVM-only helpers
Message-ID: <202209021001.ubosxpCd-lkp@intel.com>
References: <20220901173258.925729-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901173258.925729-2-seanjc@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

I love your patch! Perhaps something to improve:

[auto build test WARNING on 372d07084593dc7a399bf9bee815711b1fb1bcf2]

url:    https://github.com/intel-lab-lkp/linux/commits/Sean-Christopherson/KVM-x86-Intel-LBR-related-perf-cleanups/20220902-013352
base:   372d07084593dc7a399bf9bee815711b1fb1bcf2
config: x86_64-randconfig-a001 (https://download.01.org/0day-ci/archive/20220902/202209021001.ubosxpCd-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b1f1d2f5eb44253f5d059757c03e7fd413b2e306
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Sean-Christopherson/KVM-x86-Intel-LBR-related-perf-cleanups/20220902-013352
        git checkout b1f1d2f5eb44253f5d059757c03e7fd413b2e306
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/events/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/events/core.c:696:31: warning: no previous prototype for function 'perf_guest_get_msrs' [-Wmissing-prototypes]
   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
                                 ^
   arch/x86/events/core.c:696:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
   ^
   static 
   1 warning generated.


vim +/perf_guest_get_msrs +696 arch/x86/events/core.c

f87ad35d37fa54 arch/x86/kernel/cpu/perf_counter.c Jaswinder Singh Rajput 2009-02-27  695  
39a4d779546a99 arch/x86/events/core.c             Like Xu                2022-04-11 @696  struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
abd562df94d19d arch/x86/events/core.c             Like Xu                2021-01-25  697  {
39a4d779546a99 arch/x86/events/core.c             Like Xu                2022-04-11  698  	return static_call(x86_pmu_guest_get_msrs)(nr, data);
abd562df94d19d arch/x86/events/core.c             Like Xu                2021-01-25  699  }
abd562df94d19d arch/x86/events/core.c             Like Xu                2021-01-25  700  EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
abd562df94d19d arch/x86/events/core.c             Like Xu                2021-01-25  701  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
