Return-Path: <kvm+bounces-42450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2F4A78769
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 06:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F15493AEF41
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 04:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88384230BE5;
	Wed,  2 Apr 2025 04:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LyCORa9z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018862629F
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 04:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743569447; cv=none; b=qnbP/W7nEzrZyRrqR4RtYI/FNTG6e9m9C/SlfZmqiIJCUfTBsFdyTy9gf6329PQCifS55CADX2G9mQlT564XQyDpiXvkSg3TwcH7ECtbl132KbiYzkVgRkm8i4H0hFvVMcq6Uqm04yBoO4i3y19XyTQOX/JpZsjJ2+E5S4cZlMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743569447; c=relaxed/simple;
	bh=AdStfRI/7w1N48Sb8+2mWETLSWysBQ+Mw32djqVWfh0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fXj5qBDWV8MHrQq/BQSiLNiQQpT15Irv6Y720hrQyrnmtUOhIuA2ekSBco+FP+F2yr0CLi5Ld00tQop/CPkIwfmgX3RwMTebcgkq5nHaJ9ayc8XoaD26YpbIgjUPVlr7wqgFjhuUXl9vTFcuWp6RQCEXKbH/xS76LW2Dn1mjxF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LyCORa9z; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743569446; x=1775105446;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=AdStfRI/7w1N48Sb8+2mWETLSWysBQ+Mw32djqVWfh0=;
  b=LyCORa9zDL18IyVQlz+unoU7YjOKAWeecpcGohJ4KaeqvMAudNRAegZ5
   8UKQ4aL9OJyFowfth1C4MML7F+Q0fnPf+iLo7vaW045oWPna1xOrVrgR8
   g5oeJmu9jnaPkv41O20tDJmQUmqPc4L4o/4zVYwk2Ntb/YKASFtU/4oXB
   buyy59RmExqvCNadCfVaDx2Vdn+fUD2cuqtXVJaStId9/mih82DjkZKbk
   dmJFUWLxXMqbDZcJWGTwVkhzCCuCnSue28zA2qf4Vhc7D28QgeD9c3K5Q
   GHx3Gq29oGjtkZhyuRf3aya/YcPtK4YaadyZ9gHb2CiCYk/Vlfp31DY5M
   Q==;
X-CSE-ConnectionGUID: E6nPyhTQQLyJH9Gitu/xBA==
X-CSE-MsgGUID: 4N8V3LhhQvuq9rrWzMwpsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="44799436"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="44799436"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 21:50:46 -0700
X-CSE-ConnectionGUID: 7+yPPRYQTaGVtTvGAu6g/A==
X-CSE-MsgGUID: U07Hu7waTdGhCv+dwkQSag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="131306722"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 01 Apr 2025 21:50:44 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tzq3m-000ATo-01;
	Wed, 02 Apr 2025 04:50:42 +0000
Date: Wed, 2 Apr 2025 12:50:04 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>
Subject: [kvm:planes-20250401 58/62] arch/x86/kvm/lapic.c:1327:44: error:
 passing argument 2 of 'test_and_set_bit' from incompatible pointer type
Message-ID: <202504021204.ViYQdiHr-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git planes-20250401
head:   73685d9c23b7122b44f07d59244416f8b56ed48e
commit: 08db55297a7b060909a0121cb4ce6abbc3e6b2ea [58/62] KVM: x86: handle interrupt priorities for planes
config: i386-buildonly-randconfig-001-20250402 (https://download.01.org/0day-ci/archive/20250402/202504021204.ViYQdiHr-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250402/202504021204.ViYQdiHr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504021204.ViYQdiHr-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/lapic.c: In function 'kvm_lapic_deliver_interrupt':
>> arch/x86/kvm/lapic.c:1327:44: error: passing argument 2 of 'test_and_set_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    1327 |         if (!test_and_set_bit(vcpu->plane, &plane0_vcpu->arch.irr_pending_planes)) {
         |                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                            |
         |                                            atomic_t *
   In file included from arch/x86/include/asm/bitops.h:432,
                    from include/linux/bitops.h:68,
                    from include/linux/kernel.h:23,
                    from include/linux/cpumask.h:11,
                    from include/linux/alloc_tag.h:13,
                    from include/linux/percpu.h:5,
                    from include/linux/context_tracking_state.h:5,
                    from include/linux/hardirq.h:5,
                    from include/linux/kvm_host.h:7,
                    from arch/x86/kvm/lapic.c:20:
   include/asm-generic/bitops/instrumented-atomic.h:68:79: note: expected 'volatile long unsigned int *' but argument is of type 'atomic_t *'
      68 | static __always_inline bool test_and_set_bit(long nr, volatile unsigned long *addr)
         |                                                       ~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   cc1: some warnings being treated as errors
--
   arch/x86/kvm/x86.c: In function 'kvm_arch_vcpu_ioctl_run':
>> arch/x86/kvm/x86.c:11745:37: error: passing argument 2 of 'clear_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
   11745 |                 clear_bit(plane_id, &plane0_vcpu->arch.irr_pending_planes);
         |                                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                     |
         |                                     atomic_t *
   In file included from arch/x86/include/asm/bitops.h:432,
                    from include/linux/bitops.h:68,
                    from include/linux/kernel.h:23,
                    from include/linux/cpumask.h:11,
                    from include/linux/alloc_tag.h:13,
                    from include/linux/percpu.h:5,
                    from include/linux/context_tracking_state.h:5,
                    from include/linux/hardirq.h:5,
                    from include/linux/kvm_host.h:7,
                    from arch/x86/kvm/x86.c:20:
   include/asm-generic/bitops/instrumented-atomic.h:39:72: note: expected 'volatile long unsigned int *' but argument is of type 'atomic_t *'
      39 | static __always_inline void clear_bit(long nr, volatile unsigned long *addr)
         |                                                ~~~~~~~~~~~~~~~~~~~~~~~~^~~~
   cc1: some warnings being treated as errors


vim +/test_and_set_bit +1327 arch/x86/kvm/lapic.c

  1313	
  1314	static void kvm_lapic_deliver_interrupt(struct kvm_vcpu *vcpu, struct kvm_lapic *apic,
  1315						int delivery_mode, int trig_mode, int vector)
  1316	{
  1317		struct kvm_vcpu *plane0_vcpu = vcpu->plane0;
  1318		struct kvm_plane *running_plane;
  1319		u16 req_exit_planes;
  1320	
  1321		kvm_x86_call(deliver_interrupt)(apic, delivery_mode, trig_mode, vector);
  1322	
  1323		/*
  1324		 * test_and_set_bit implies a memory barrier, so IRR is written before
  1325		 * reading irr_pending_planes below...
  1326		 */
> 1327		if (!test_and_set_bit(vcpu->plane, &plane0_vcpu->arch.irr_pending_planes)) {
  1328			/*
  1329			 * ... and also running_plane and req_exit_planes are read after writing
  1330			 * irr_pending_planes.  Both barriers pair with kvm_arch_vcpu_ioctl_run().
  1331			 */
  1332			smp_mb__after_atomic();
  1333	
  1334			running_plane = READ_ONCE(plane0_vcpu->running_plane);
  1335			if (!running_plane)
  1336				return;
  1337	
  1338			req_exit_planes = READ_ONCE(plane0_vcpu->req_exit_planes);
  1339			if (!(req_exit_planes & BIT(vcpu->plane)))
  1340				return;
  1341	
  1342			kvm_make_request(KVM_REQ_PLANE_INTERRUPT,
  1343					 kvm_get_plane_vcpu(running_plane, vcpu->vcpu_id));
  1344		}
  1345	}
  1346	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

