Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89244774B30
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjHHUmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbjHHUmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:42:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B1B92C9;
        Tue,  8 Aug 2023 13:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691525869; x=1723061869;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xESjQ6/u2lB6PM/C4hmJU1/s7F3OphDWt1XzFqnGAQM=;
  b=AuSv9MuEyJfu3qFJ//MeijVO1UHngly+ByuornEv0pIQ8AaoZKKt2+kO
   5kmp3XmXKMO9jEZuwvhQnh1kOJBjLPFufEHMjJ3C+f/TJ5rv5U2QhNDcP
   drbGdW9G3XPHvMu46SZYKg03wFunpKyxHcXkauF6P/i8mIocKV+OeC7JU
   /iYfwp26WVGj83SvrL8q4uIB+KP2EwxB1AJeM6ig3G2pGeaMH5qyGa3wQ
   QX1njsUmkC+HRJqfVW8RKN5o55hV6heV5/gXxw29Gctr3GbzbJ5u23qfP
   jzT2s1jlEiV+2ATHA5ezjhJX4VpHAJ2lLMI4lJKcH0n1uih9sHkC/frXs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="355903496"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="355903496"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 13:17:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="708401075"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="708401075"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 08 Aug 2023 13:17:12 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTT8g-0005aP-2i;
        Tue, 08 Aug 2023 20:17:10 +0000
Date:   Wed, 9 Aug 2023 04:16:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH RFV v2 08/13] perf/core: Add new function
 perf_event_topdown_metrics()
Message-ID: <202308090447.HY139um6-lkp@intel.com>
References: <20230808063111.1870070-9-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808063111.1870070-9-dapeng1.mi@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dapeng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20230808]
[cannot apply to kvm/queue acme/perf/core tip/perf/core kvm/linux-next v6.5-rc5 v6.5-rc4 v6.5-rc3 linus/master v6.5-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dapeng-Mi/KVM-x86-pmu-Support-PMU-fixed-counter-3/20230809-030457
base:   next-20230808
patch link:    https://lore.kernel.org/r/20230808063111.1870070-9-dapeng1.mi%40linux.intel.com
patch subject: [PATCH RFV v2 08/13] perf/core: Add new function perf_event_topdown_metrics()
config: loongarch-allnoconfig (https://download.01.org/0day-ci/archive/20230809/202308090447.HY139um6-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.3.0
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308090447.HY139um6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308090447.HY139um6-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/trace_events.h:10,
                    from include/trace/syscall.h:7,
                    from include/linux/syscalls.h:90,
                    from arch/loongarch/mm/cache.c:17:
>> include/linux/perf_event.h:1793:53: warning: 'struct td_metrics' declared inside parameter list will not be visible outside of this definition or declaration
    1793 |                                              struct td_metrics *value)
         |                                                     ^~~~~~~~~~
--
   In file included from include/linux/trace_events.h:10,
                    from include/trace/syscall.h:7,
                    from include/linux/syscalls.h:90,
                    from include/linux/entry-common.h:7,
                    from arch/loongarch/mm/fault.c:13:
>> include/linux/perf_event.h:1793:53: warning: 'struct td_metrics' declared inside parameter list will not be visible outside of this definition or declaration
    1793 |                                              struct td_metrics *value)
         |                                                     ^~~~~~~~~~
   arch/loongarch/mm/fault.c:256:27: warning: no previous prototype for 'do_page_fault' [-Wmissing-prototypes]
     256 | asmlinkage void __kprobes do_page_fault(struct pt_regs *regs,
         |                           ^~~~~~~~~~~~~


vim +1793 include/linux/perf_event.h

  1791	
  1792	static inline int perf_event_topdown_metrics(struct perf_event *event,
> 1793						     struct td_metrics *value)
  1794	{
  1795		return 0;
  1796	}
  1797	#endif
  1798	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
