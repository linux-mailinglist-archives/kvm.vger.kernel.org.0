Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3694509FB5
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 14:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384837AbiDUMfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 08:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384802AbiDUMfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 08:35:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A39720BE3
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 05:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650544336; x=1682080336;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0gk0Yr6OYwc6wvYMz0DTXtavCaI219f0MHkJuR8UMJE=;
  b=jYBkkP3JlZy2nPxmzTCtV5M0HOxZyaWn1EJS/Bj5Fpnl7sPUpx3CYnW8
   hEkzq57S804ugjVRRGAstLibDk0GfgKY3H6KBZrFc6qZyxsGnlbIKabGE
   U3+wvvQ9K9xUj5FxGXrNe/DS+dYOC23Fm8zsDC74D5xypuftrIZzO34Hb
   RU3r5gE+3SH3G9Sbpx1snqk83SJoC7yUbbm6RVlRX0QzHzwknNuJ0Znl2
   BlWzgxrh/EMnVcmnJ1kj0kWYDk6bFaukIX7rAoohXGnMeKqcVFTQVQeA/
   EUHASLjmLPjXpYEkM+Dn/dr5xAAfEgjSIOfPacQ3/J0ujO1FuoBbuJoHu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="246231388"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="246231388"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 05:32:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="670632947"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 21 Apr 2022 05:32:02 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhVyb-0008OB-GC;
        Thu, 21 Apr 2022 12:32:01 +0000
Date:   Thu, 21 Apr 2022 20:31:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Anton Romanov <romanton@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     kbuild-all@lists.01.org, seanjc@google.com, vkuznets@redhat.com,
        Anton Romanov <romanton@google.com>
Subject: Re: [PATCH v2] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <202204212040.klu29ce8-lkp@intel.com>
References: <20220421005645.56801-1-romanton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421005645.56801-1-romanton@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Anton,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/master]
[also build test ERROR on mst-vhost/linux-next v5.18-rc3 next-20220421]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Anton-Romanov/KVM-x86-Use-current-rather-than-snapshotted-TSC-frequency-if-it-is-constant/20220421-090221
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git master
config: x86_64-randconfig-a015 (https://download.01.org/0day-ci/archive/20220421/202204212040.klu29ce8-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/c60b3070bd6e7e804de118dac10002e4f5f714a6
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Anton-Romanov/KVM-x86-Use-current-rather-than-snapshotted-TSC-frequency-if-it-is-constant/20220421-090221
        git checkout c60b3070bd6e7e804de118dac10002e4f5f714a6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function '__get_kvmclock':
>> arch/x86/kvm/x86.c:2936:17: error: expected expression before 'struct'
    2936 |                 struct timespec64 ts;
         |                 ^~~~~~
   arch/x86/kvm/x86.c:2933:9: warning: this 'if' clause does not guard... [-Wmisleading-indentation]
    2933 |         if (ka->use_master_clock &&
         |         ^~
   arch/x86/kvm/x86.c:2938:17: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
    2938 |                 if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
         |                 ^~
>> arch/x86/kvm/x86.c:2938:53: error: 'ts' undeclared (first use in this function); did you mean 'tms'?
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
   include/linux/preempt.h:240:1: error: expected identifier or '(' before 'do'
     240 | do { \
         | ^~
   include/linux/smp.h:268:33: note: in expansion of macro 'preempt_enable'
     268 | #define put_cpu()               preempt_enable()
         |                                 ^~~~~~~~~~~~~~
   arch/x86/kvm/x86.c:2956:9: note: in expansion of macro 'put_cpu'
    2956 |         put_cpu();
         |         ^~~~~~~
   include/linux/preempt.h:243:3: error: expected identifier or '(' before 'while'
     243 | } while (0)
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


vim +/struct +2936 arch/x86/kvm/x86.c

c60b3070bd6e7e Anton Romanov 2022-04-21  2922  
869b44211adc87 Paolo Bonzini 2021-09-16  2923  /* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
869b44211adc87 Paolo Bonzini 2021-09-16  2924  static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
108b249c453dd7 Paolo Bonzini 2016-09-01  2925  {
108b249c453dd7 Paolo Bonzini 2016-09-01  2926  	struct kvm_arch *ka = &kvm->arch;
8b953440645631 Paolo Bonzini 2016-11-16  2927  	struct pvclock_vcpu_time_info hv_clock;
8b953440645631 Paolo Bonzini 2016-11-16  2928  
e2c2206a18993b Wanpeng Li    2017-05-11  2929  	/* both __this_cpu_read() and rdtsc() should be on the same cpu */
e2c2206a18993b Wanpeng Li    2017-05-11  2930  	get_cpu();
e2c2206a18993b Wanpeng Li    2017-05-11  2931  
869b44211adc87 Paolo Bonzini 2021-09-16  2932  	data->flags = 0;
c60b3070bd6e7e Anton Romanov 2022-04-21  2933  	if (ka->use_master_clock &&
c60b3070bd6e7e Anton Romanov 2022-04-21  2934  		(static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))
c68dc1b577eabd Oliver Upton  2021-09-16  2935  #ifdef CONFIG_X86_64
c68dc1b577eabd Oliver Upton  2021-09-16 @2936  		struct timespec64 ts;
c68dc1b577eabd Oliver Upton  2021-09-16  2937  
c68dc1b577eabd Oliver Upton  2021-09-16 @2938  		if (kvm_get_walltime_and_clockread(&ts, &data->host_tsc)) {
c68dc1b577eabd Oliver Upton  2021-09-16  2939  			data->realtime = ts.tv_nsec + NSEC_PER_SEC * ts.tv_sec;
c68dc1b577eabd Oliver Upton  2021-09-16  2940  			data->flags |= KVM_CLOCK_REALTIME | KVM_CLOCK_HOST_TSC;
c68dc1b577eabd Oliver Upton  2021-09-16  2941  		} else
c68dc1b577eabd Oliver Upton  2021-09-16  2942  #endif
c68dc1b577eabd Oliver Upton  2021-09-16  2943  		data->host_tsc = rdtsc();
c68dc1b577eabd Oliver Upton  2021-09-16  2944  
869b44211adc87 Paolo Bonzini 2021-09-16  2945  		data->flags |= KVM_CLOCK_TSC_STABLE;
869b44211adc87 Paolo Bonzini 2021-09-16  2946  		hv_clock.tsc_timestamp = ka->master_cycle_now;
869b44211adc87 Paolo Bonzini 2021-09-16  2947  		hv_clock.system_time = ka->master_kernel_ns + ka->kvmclock_offset;
c60b3070bd6e7e Anton Romanov 2022-04-21  2948  		kvm_get_time_scale(NSEC_PER_SEC, get_cpu_tsc_khz() * 1000LL,
8b953440645631 Paolo Bonzini 2016-11-16  2949  				   &hv_clock.tsc_shift,
8b953440645631 Paolo Bonzini 2016-11-16  2950  				   &hv_clock.tsc_to_system_mul);
c68dc1b577eabd Oliver Upton  2021-09-16  2951  		data->clock = __pvclock_read_cycles(&hv_clock, data->host_tsc);
55c0cefbdbdaca Oliver Upton  2021-09-16  2952  	} else {
55c0cefbdbdaca Oliver Upton  2021-09-16  2953  		data->clock = get_kvmclock_base_ns() + ka->kvmclock_offset;
55c0cefbdbdaca Oliver Upton  2021-09-16  2954  	}
e2c2206a18993b Wanpeng Li    2017-05-11  2955  
e2c2206a18993b Wanpeng Li    2017-05-11  2956  	put_cpu();
55c0cefbdbdaca Oliver Upton  2021-09-16  2957  }
e2c2206a18993b Wanpeng Li    2017-05-11  2958  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
