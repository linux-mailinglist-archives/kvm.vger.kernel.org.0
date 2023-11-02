Return-Path: <kvm+bounces-358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 087B07DEB96
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:03:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39FED1C20E61
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB97F1FA5;
	Thu,  2 Nov 2023 04:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VXp5TMeR"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAD91878;
	Thu,  2 Nov 2023 04:03:31 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90D8128;
	Wed,  1 Nov 2023 21:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698897806; x=1730433806;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uiKjtjc1qeIjldPV5Boqk2rup5dIVAMxXp97CTrQPm0=;
  b=VXp5TMeRZEExFDVBPLBqV9JpRVRQqxGvurta76S+gEVcF1VE4zgh6XIB
   tZSk7N91THcafV3UyZo0Wk0b7wbSVUH4mD5dPGfm7LO+CTHqWdXJeO2Z1
   rjJPfVK1TM70bxQJryvPycP0pvGf6OSwFoXo/FP1ZZ6hveyGsgl+oGD5a
   bCY1TqQ/lN1OmcXbx4+zUV/KTir45FF/yfB5qnk1qrKuUefomyQ/sI2th
   LrTpr6hYnFpi8BCaWGCOSfubbArPIQ1Xm1CmZ6yzMbLbDO/IyND9V6SzW
   7y1bMKel3DHBwv5dx5NnFwlHCQInbf49NwW0J4moDCDzuFihoh1SHogwu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="388448245"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="388448245"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 21:03:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="851785060"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="851785060"
Received: from lkp-server01.sh.intel.com (HELO 17d9e85e5079) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Nov 2023 21:03:17 -0700
Received: from kbuild by 17d9e85e5079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qyOvK-000164-2Z;
	Thu, 02 Nov 2023 04:03:14 +0000
Date: Thu, 2 Nov 2023 12:03:07 +0800
From: kernel test robot <lkp@intel.com>
To: Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v4] KVM x86/xen: add an override for
 PVCLOCK_TSC_STABLE_BIT
Message-ID: <202311021159.ppYESBYx-lkp@intel.com>
References: <20231101183032.1498211-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101183032.1498211-1-paul@xen.org>

Hi Paul,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 35dcbd9e47035f98f3910ae420bf10892c9bdc99]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Durrant/KVM-x86-xen-add-an-override-for-PVCLOCK_TSC_STABLE_BIT/20231102-034122
base:   35dcbd9e47035f98f3910ae420bf10892c9bdc99
patch link:    https://lore.kernel.org/r/20231101183032.1498211-1-paul%40xen.org
patch subject: [PATCH v4] KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT
config: i386-randconfig-013-20231102 (https://download.01.org/0day-ci/archive/20231102/202311021159.ppYESBYx-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231102/202311021159.ppYESBYx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311021159.ppYESBYx-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/kvm/x86.c: In function 'kvm_guest_time_update':
>> arch/x86/kvm/x86.c:3176:14: warning: unused variable 'xen_pvclock_tsc_unstable' [-Wunused-variable]
    3176 |         bool xen_pvclock_tsc_unstable =
         |              ^~~~~~~~~~~~~~~~~~~~~~~~


vim +/xen_pvclock_tsc_unstable +3176 arch/x86/kvm/x86.c

  3158	
  3159	static int kvm_guest_time_update(struct kvm_vcpu *v)
  3160	{
  3161		unsigned long flags, tgt_tsc_khz;
  3162		unsigned seq;
  3163		struct kvm_vcpu_arch *vcpu = &v->arch;
  3164		struct kvm_arch *ka = &v->kvm->arch;
  3165		s64 kernel_ns;
  3166		u64 tsc_timestamp, host_tsc;
  3167		u8 pvclock_flags;
  3168		bool use_master_clock;
  3169	
  3170		/*
  3171		 * For Xen guests we may need to override PVCLOCK_TSC_STABLE_BIT as unless
  3172		 * explicitly told to use TSC as its clocksource Xen will not set this bit.
  3173		 * This default behaviour led to bugs in some guest kernels which cause
  3174		 * problems if they observe PVCLOCK_TSC_STABLE_BIT in the pvclock flags.
  3175		 */
> 3176		bool xen_pvclock_tsc_unstable =
  3177			ka->xen_hvm_config.flags & KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE;
  3178	
  3179		kernel_ns = 0;
  3180		host_tsc = 0;
  3181	
  3182		/*
  3183		 * If the host uses TSC clock, then passthrough TSC as stable
  3184		 * to the guest.
  3185		 */
  3186		do {
  3187			seq = read_seqcount_begin(&ka->pvclock_sc);
  3188			use_master_clock = ka->use_master_clock;
  3189			if (use_master_clock) {
  3190				host_tsc = ka->master_cycle_now;
  3191				kernel_ns = ka->master_kernel_ns;
  3192			}
  3193		} while (read_seqcount_retry(&ka->pvclock_sc, seq));
  3194	
  3195		/* Keep irq disabled to prevent changes to the clock */
  3196		local_irq_save(flags);
  3197		tgt_tsc_khz = get_cpu_tsc_khz();
  3198		if (unlikely(tgt_tsc_khz == 0)) {
  3199			local_irq_restore(flags);
  3200			kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
  3201			return 1;
  3202		}
  3203		if (!use_master_clock) {
  3204			host_tsc = rdtsc();
  3205			kernel_ns = get_kvmclock_base_ns();
  3206		}
  3207	
  3208		tsc_timestamp = kvm_read_l1_tsc(v, host_tsc);
  3209	
  3210		/*
  3211		 * We may have to catch up the TSC to match elapsed wall clock
  3212		 * time for two reasons, even if kvmclock is used.
  3213		 *   1) CPU could have been running below the maximum TSC rate
  3214		 *   2) Broken TSC compensation resets the base at each VCPU
  3215		 *      entry to avoid unknown leaps of TSC even when running
  3216		 *      again on the same CPU.  This may cause apparent elapsed
  3217		 *      time to disappear, and the guest to stand still or run
  3218		 *	very slowly.
  3219		 */
  3220		if (vcpu->tsc_catchup) {
  3221			u64 tsc = compute_guest_tsc(v, kernel_ns);
  3222			if (tsc > tsc_timestamp) {
  3223				adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
  3224				tsc_timestamp = tsc;
  3225			}
  3226		}
  3227	
  3228		local_irq_restore(flags);
  3229	
  3230		/* With all the info we got, fill in the values */
  3231	
  3232		if (kvm_caps.has_tsc_control)
  3233			tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
  3234						    v->arch.l1_tsc_scaling_ratio);
  3235	
  3236		if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
  3237			kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
  3238					   &vcpu->hv_clock.tsc_shift,
  3239					   &vcpu->hv_clock.tsc_to_system_mul);
  3240			vcpu->hw_tsc_khz = tgt_tsc_khz;
  3241			kvm_xen_update_tsc_info(v);
  3242		}
  3243	
  3244		vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
  3245		vcpu->hv_clock.system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
  3246		vcpu->last_guest_tsc = tsc_timestamp;
  3247	
  3248		/* If the host uses TSC clocksource, then it is stable */
  3249		pvclock_flags = 0;
  3250		if (use_master_clock)
  3251			pvclock_flags |= PVCLOCK_TSC_STABLE_BIT;
  3252	
  3253		vcpu->hv_clock.flags = pvclock_flags;
  3254	
  3255		if (vcpu->pv_time.active)
  3256			kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0, false);
  3257	#ifdef CONFIG_KVM_XEN
  3258		if (vcpu->xen.vcpu_info_cache.active)
  3259			kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
  3260						offsetof(struct compat_vcpu_info, time),
  3261						xen_pvclock_tsc_unstable);
  3262		if (vcpu->xen.vcpu_time_info_cache.active)
  3263			kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0,
  3264						xen_pvclock_tsc_unstable);
  3265	#endif
  3266		kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
  3267		return 0;
  3268	}
  3269	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

