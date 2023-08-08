Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F82774B31
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 22:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbjHHUmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 16:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbjHHUmi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 16:42:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772E214FCE;
        Tue,  8 Aug 2023 13:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691525870; x=1723061870;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Es2qusPBI+Upp+gjA6iZyfm+jjbTtNkyAFCBl7xskTc=;
  b=Rfxlzm9XeKKYL2yNMJEi7iizlRarU7HVJewbJ19rg+xMqHfomvnzTj0q
   whAcCU5d6PqNv9IBiqySsYlyYSOrFzARtnTVonzzvTbflXvgn5qoUK2Ec
   GixGjF8jO25LoNsrakTqU89Q9ruda3zGEa9fwnkCuHDiL8LZXF1FU763/
   E0KlnfZn/sl8mq3wkm2MIVCUds8TSw9h7XVGrMYcddi8KkD/3b5bIc8eX
   jJpmAbM3XyW7lgGnuR/WbDZdjIeIErkkN8EBW9CwzKbH0kRTFvV/HiyQ6
   efwFPI8wp/HEHYIJM6ImpM51iaPHtjlk2CaNTUZybzigL3f4UBYeBMls4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="355903484"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="355903484"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 13:17:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="708401073"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="708401073"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 08 Aug 2023 13:17:12 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qTT8g-0005aM-2e;
        Tue, 08 Aug 2023 20:17:10 +0000
Date:   Wed, 9 Aug 2023 04:16:51 +0800
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
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH RFV v2 08/13] perf/core: Add new function
 perf_event_topdown_metrics()
Message-ID: <202308090418.vTakFy6e-lkp@intel.com>
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
config: arm-randconfig-r046-20230808 (https://download.01.org/0day-ci/archive/20230809/202308090418.vTakFy6e-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce: (https://download.01.org/0day-ci/archive/20230809/202308090418.vTakFy6e-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308090418.vTakFy6e-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from kernel/sched/build_policy.c:34:
   In file included from kernel/sched/sched.h:61:
   In file included from include/linux/syscalls_api.h:1:
   In file included from include/linux/syscalls.h:90:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:10:
>> include/linux/perf_event.h:1793:18: warning: declaration of 'struct td_metrics' will not be visible outside of this function [-Wvisibility]
                                                struct td_metrics *value)
                                                       ^
   1 warning generated.
--
   In file included from kernel/sched/fair.c:56:
   In file included from kernel/sched/sched.h:61:
   In file included from include/linux/syscalls_api.h:1:
   In file included from include/linux/syscalls.h:90:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:10:
>> include/linux/perf_event.h:1793:18: warning: declaration of 'struct td_metrics' will not be visible outside of this function [-Wvisibility]
                                                struct td_metrics *value)
                                                       ^
   kernel/sched/fair.c:702:6: warning: no previous prototype for function 'update_entity_lag' [-Wmissing-prototypes]
   void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
        ^
   kernel/sched/fair.c:702:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
   ^
   static 
   kernel/sched/fair.c:12732:6: warning: no previous prototype for function 'free_fair_sched_group' [-Wmissing-prototypes]
   void free_fair_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/fair.c:12732:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void free_fair_sched_group(struct task_group *tg) { }
   ^
   static 
   kernel/sched/fair.c:12734:5: warning: no previous prototype for function 'alloc_fair_sched_group' [-Wmissing-prototypes]
   int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
       ^
   kernel/sched/fair.c:12734:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int alloc_fair_sched_group(struct task_group *tg, struct task_group *parent)
   ^
   static 
   kernel/sched/fair.c:12739:6: warning: no previous prototype for function 'online_fair_sched_group' [-Wmissing-prototypes]
   void online_fair_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/fair.c:12739:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void online_fair_sched_group(struct task_group *tg) { }
   ^
   static 
   kernel/sched/fair.c:12741:6: warning: no previous prototype for function 'unregister_fair_sched_group' [-Wmissing-prototypes]
   void unregister_fair_sched_group(struct task_group *tg) { }
        ^
   kernel/sched/fair.c:12741:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void unregister_fair_sched_group(struct task_group *tg) { }
   ^
   static 
   kernel/sched/fair.c:503:20: warning: unused function 'list_del_leaf_cfs_rq' [-Wunused-function]
   static inline void list_del_leaf_cfs_rq(struct cfs_rq *cfs_rq)
                      ^
   kernel/sched/fair.c:524:19: warning: unused function 'tg_is_idle' [-Wunused-function]
   static inline int tg_is_idle(struct task_group *tg)
                     ^
   kernel/sched/fair.c:548:19: warning: unused function 'max_vruntime' [-Wunused-function]
   static inline u64 max_vruntime(u64 max_vruntime, u64 vruntime)
                     ^
   kernel/sched/fair.c:1262:20: warning: unused function 'is_core_idle' [-Wunused-function]
   static inline bool is_core_idle(int cpu)
                      ^
   kernel/sched/fair.c:3452:20: warning: unused function 'account_numa_enqueue' [-Wunused-function]
   static inline void account_numa_enqueue(struct rq *rq, struct task_struct *p)
                      ^
   kernel/sched/fair.c:3456:20: warning: unused function 'account_numa_dequeue' [-Wunused-function]
   static inline void account_numa_dequeue(struct rq *rq, struct task_struct *p)
                      ^
   kernel/sched/fair.c:3460:20: warning: unused function 'update_scan_period' [-Wunused-function]
   static inline void update_scan_period(struct task_struct *p, int new_cpu)
                      ^
   kernel/sched/fair.c:4872:20: warning: unused function 'cfs_rq_is_decayed' [-Wunused-function]
   static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
                      ^
   kernel/sched/fair.c:4887:20: warning: unused function 'remove_entity_load_avg' [-Wunused-function]
   static inline void remove_entity_load_avg(struct sched_entity *se) {}
                      ^
   kernel/sched/fair.c:6259:20: warning: unused function 'cfs_bandwidth_used' [-Wunused-function]
   static inline bool cfs_bandwidth_used(void)
                      ^
   kernel/sched/fair.c:6267:20: warning: unused function 'sync_throttle' [-Wunused-function]
   static inline void sync_throttle(struct task_group *tg, int cpu) {}
                      ^
   kernel/sched/fair.c:6280:19: warning: unused function 'throttled_lb_pair' [-Wunused-function]
   static inline int throttled_lb_pair(struct task_group *tg,
                     ^
   kernel/sched/fair.c:6291:37: warning: unused function 'tg_cfs_bandwidth' [-Wunused-function]
   static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
                                       ^
   kernel/sched/fair.c:6295:20: warning: unused function 'destroy_cfs_bandwidth' [-Wunused-function]
   static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
                      ^
   kernel/sched/fair.c:6296:20: warning: unused function 'update_runtime_enabled' [-Wunused-function]
   static inline void update_runtime_enabled(struct rq *rq) {}
                      ^
   kernel/sched/fair.c:6297:20: warning: unused function 'unthrottle_offline_cfs_rqs' [-Wunused-function]
   static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
                      ^
   22 warnings generated.
--
   In file included from kernel/sched/core.c:13:
   In file included from include/linux/syscalls_api.h:1:
   In file included from include/linux/syscalls.h:90:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:10:
>> include/linux/perf_event.h:1793:18: warning: declaration of 'struct td_metrics' will not be visible outside of this function [-Wvisibility]
                                                struct td_metrics *value)
                                                       ^
   kernel/sched/core.c:3695:20: warning: unused function 'rq_has_pinned_tasks' [-Wunused-function]
   static inline bool rq_has_pinned_tasks(struct rq *rq)
                      ^
   kernel/sched/core.c:5822:20: warning: unused function 'sched_tick_start' [-Wunused-function]
   static inline void sched_tick_start(int cpu) { }
                      ^
   kernel/sched/core.c:5823:20: warning: unused function 'sched_tick_stop' [-Wunused-function]
   static inline void sched_tick_stop(int cpu) { }
                      ^
   kernel/sched/core.c:6523:20: warning: unused function 'sched_core_cpu_starting' [-Wunused-function]
   static inline void sched_core_cpu_starting(unsigned int cpu) {}
                      ^
   kernel/sched/core.c:6524:20: warning: unused function 'sched_core_cpu_deactivate' [-Wunused-function]
   static inline void sched_core_cpu_deactivate(unsigned int cpu) {}
                      ^
   kernel/sched/core.c:6525:20: warning: unused function 'sched_core_cpu_dying' [-Wunused-function]
   static inline void sched_core_cpu_dying(unsigned int cpu) {}
                      ^
   7 warnings generated.


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
