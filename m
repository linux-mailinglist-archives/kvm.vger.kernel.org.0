Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD6B509A64
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 10:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386494AbiDUING (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 04:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386514AbiDUIMu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 04:12:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402552DC0
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 01:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650528601; x=1682064601;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kdvzNgfFaJ6e3qws8oZEdN8Fk3IXl0aTY5ba4Fqi55Y=;
  b=HV/t8Z7iMpz2OrC/P+6U70lNEF7l9yPi81ploScC9tlhD5dq2OQ7hN0r
   5RwhdxpEkYlfF51hzPHAvojS0ZrQtjaqOjR9ApdqPH4zx6RyeA0b7ZbXI
   Sl9Idt/5TTsIJFM+Kescs4iiFMI5iqHcfksYgSa+OVUU8NtDdq+le2ptc
   mA06LFIDjzj06z5N5Woi7fLuTNQqbL8tky6xjr0IDd9x9fdlYfovjORJI
   YrtYTE9UnwPawU9ESWUPXCPV7dKvYCEGyBW43tQjc+/spAmWNTZKsafu/
   KnW8EBX1NkEKXDKxESk4oZrYMGELPneVN+AvoDbxX27TdAqeWNLcaGoFc
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289387930"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="289387930"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 01:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="530171715"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 21 Apr 2022 01:09:58 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhRt0-00086d-4d;
        Thu, 21 Apr 2022 08:09:58 +0000
Date:   Thu, 21 Apr 2022 16:09:51 +0800
From:   kernel test robot <lkp@intel.com>
To:     Anton Romanov <romanton@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     kbuild-all@lists.01.org, seanjc@google.com, vkuznets@redhat.com,
        Anton Romanov <romanton@google.com>
Subject: Re: [PATCH v2] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <202204211558.rjkmRfSe-lkp@intel.com>
References: <20220421005645.56801-1-romanton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421005645.56801-1-romanton@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Anton,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on kvm/master]
[also build test WARNING on mst-vhost/linux-next v5.18-rc3 next-20220420]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Anton-Romanov/KVM-x86-Use-current-rather-than-snapshotted-TSC-frequency-if-it-is-constant/20220421-090221
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20220421/202204211558.rjkmRfSe-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c60b3070bd6e7e804de118dac10002e4f5f714a6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anton-Romanov/KVM-x86-Use-current-rather-than-snapshotted-TSC-frequency-if-it-is-constant/20220421-090221
        git checkout c60b3070bd6e7e804de118dac10002e4f5f714a6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function '__get_kvmclock':
   arch/x86/kvm/x86.c:2936:17: error: expected expression before 'struct'
    2936 |                 struct timespec64 ts;
         |                 ^~~~~~
>> arch/x86/kvm/x86.c:2933:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    2933 |         if (ka->use_master_clock &&
         |         ^~
   arch/x86/kvm/x86.c:2938:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    2938 |                 if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
         |                 ^~
   arch/x86/kvm/x86.c:2938:53: error: 'ts' undeclared (first use in this function); did you mean 'tms'?
    2938 |                 if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
         |                                                     ^~
         |                                                     tms
   arch/x86/kvm/x86.c:2938:53: note: each undeclared identifier is reported only once for each function it appears in
   arch/x86/kvm/x86.c: At top level:
   arch/x86/kvm/x86.c:2952:11: error: expected identifier or '(' before 'else'
    2952 |         } else {
         |           ^~~~
   In file included from include/linux/percpu.h:6,
                    from include/linux/context_tracking_state.h:5,
                    from include/linux/hardirq.h:5,
                    from include/linux/kvm_host.h:7,
                    from arch/x86/kvm/x86.c:19:
   include/linux/preempt.h:219:1: error: expected identifier or '(' before 'do'
     219 | do { \
         | ^~
   include/linux/smp.h:268:33: note: in expansion of macro 'preempt_enable'
     268 | #define put_cpu()               preempt_enable()
         |                                 ^~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:2956:9: note: in expansion of macro 'put_cpu'
    2956 |         put_cpu();
         |         ^~~~~~~
   include/linux/preempt.h:223:3: error: expected identifier or '(' before 'while'
     223 | } while (0)
         |   ^~~~~
   include/linux/smp.h:268:33: note: in expansion of macro 'preempt_enable'
     268 | #define put_cpu()               preempt_enable()
         |                                 ^~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:2956:9: note: in expansion of macro 'put_cpu'
    2956 |         put_cpu();
         |         ^~~~~~~
   arch/x86/kvm/x86.c:2957:1: error: expected identifier or '(' before '}' token
    2957 | }
         | ^


vim +/if +2933 arch/x86/kvm/x86.c

  2922	
  2923	/* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
  2924	static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
  2925	{
  2926		struct kvm_arch *ka = &kvm->arch;
  2927		struct pvclock_vcpu_time_info hv_clock;
  2928	
  2929		/* both __this_cpu_read() and rdtsc() should be on the same cpu */
  2930		get_cpu();
  2931	
  2932		data->flags = 0;
> 2933		if (ka->use_master_clock &&
  2934			(static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))
  2935	#ifdef CONFIG_X86_64
  2936			struct timespec64 ts;
  2937	
  2938			if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
  2939				data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
  2940				data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
  2941			} else
  2942	#endif
  2943			data->host_tsc = rdtsc();
  2944	
  2945			data->flags |= KVM_CLOCK_TSC_STABLE;
  2946			hv_clock.tsc_timestamp = ka->master_cycle_now;
  2947			hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
  2948			kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
  2949					   &hv_clock.tsc_shift,
  2950					   &hv_clock.tsc_to_system_mul);
  2951			data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
  2952		} else {
  2953			data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
  2954		}
  2955	
  2956		put_cpu();
  2957	}
  2958	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
