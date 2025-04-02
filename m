Return-Path: <kvm+bounces-42441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A34A786DE
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 91AE516DD6F
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4130D22B8A6;
	Wed,  2 Apr 2025 03:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T7fMvxXq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E87318052
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 03:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743565543; cv=none; b=sSdd0/HqQ47viOBlrUXyWbHU74bzIseM4l0LQnctddJ6FS/oZXBs/cX29IuaexhF51BNsLNGga7oYKTURO30ynap72hnfsY3F7Rr5LN59oQEWEDxDBYmT931yakhwq2+abdiOY28TRnN3zwFiuHOhnpFtVjF2F38Zm7Sy6+pON0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743565543; c=relaxed/simple;
	bh=2zhVIWkat110d7g7O9J+eA6yuWB/+nKLJnBuuMDzt68=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rtvdyXKOKK1fyf29+/x5MXRMvjc6qdIEgVEc6j2nAuUGIorcUVr7YdKFNHVSrLKYf4VKathqRaW6eYzlfX3FnGBiO8qeWaoGBmd3+Dc5Q1lHkdJ2/f54ZUVLuNhXpDSv0l+EJ2xwuHRjFu8Iu/HzqFGbvpGA/kTRIjtPdQiLrDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T7fMvxXq; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743565540; x=1775101540;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2zhVIWkat110d7g7O9J+eA6yuWB/+nKLJnBuuMDzt68=;
  b=T7fMvxXqf6EleHayBQIg1hWP5gHdsBqtLtdxV9NALyvuqdriPnIHUxoj
   zsiUijJ7nJdE2+JJ2z2sNpK9LTi29ea42B95a92dO/w3DDibmBneyIn7U
   u0gcLK0zj3JQH5BL5p6qGsa3XqwPy7CvvIngo8MHLyBuP0yDQqnBDUFjK
   d1n6GojiZVImpw27ZXO+9b2JU+XVNA+is+741Jfvz6gjY7w6QvcS25i/O
   1PKsbIO6s90Rf+e12aVCSO73uX+/kwwVp4vQR8W99B0AL2EQbFJjNHK4s
   0zn2febNhZJsF2AZJQ27vrSWUKwp7Vja0cXZvJoFMODBHAAVps5NidcIR
   A==;
X-CSE-ConnectionGUID: BW9+Nf/cRuW3sjVm7RTYGA==
X-CSE-MsgGUID: 35DQp/1fQWydISCjEAo1hw==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="56277757"
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="56277757"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 20:45:40 -0700
X-CSE-ConnectionGUID: wXOS7kT2R7Krvn7J65KEPA==
X-CSE-MsgGUID: 5mi0Uy4FSEWHk9UPm1YfXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,295,1736841600"; 
   d="scan'208";a="126823265"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 01 Apr 2025 20:45:38 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tzp2m-000AS1-0l;
	Wed, 02 Apr 2025 03:45:36 +0000
Date: Wed, 2 Apr 2025 11:45:29 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>
Subject: [kvm:planes-20250401 51/62] arch/x86/kvm/svm/svm.c:3255:37: error:
 passing argument 1 of 'kvm_clear_apicv_inhibit' from incompatible pointer
 type
Message-ID: <202504021134.VxUA9YrF-lkp@intel.com>
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
commit: 94b5e48b64ab5ab55aac3636dfc9284b78b7b911 [51/62] KVM: x86: track APICv inhibits per plane
config: i386-buildonly-randconfig-001-20250402 (https://download.01.org/0day-ci/archive/20250402/202504021134.VxUA9YrF-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250402/202504021134.VxUA9YrF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202504021134.VxUA9YrF-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/svm/svm.c: In function 'interrupt_window_interception':
>> arch/x86/kvm/svm/svm.c:3255:37: error: passing argument 1 of 'kvm_clear_apicv_inhibit' from incompatible pointer type [-Werror=incompatible-pointer-types]
    3255 |         kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
         |                                 ~~~~^~~~~
         |                                     |
         |                                     struct kvm *
   In file included from include/linux/kvm_host.h:45,
                    from arch/x86/kvm/svm/svm.c:3:
   arch/x86/include/asm/kvm_host.h:2249:62: note: expected 'struct kvm_plane *' but argument is of type 'struct kvm *'
    2249 | static inline void kvm_clear_apicv_inhibit(struct kvm_plane *plane,
         |                                            ~~~~~~~~~~~~~~~~~~^~~~~
   cc1: some warnings being treated as errors


vim +/kvm_clear_apicv_inhibit +3255 arch/x86/kvm/svm/svm.c

6aa8b732ca01c3 drivers/kvm/svm.c      Avi Kivity            2006-12-10  3237  
63129754178c55 arch/x86/kvm/svm/svm.c Paolo Bonzini         2021-03-02  3238  static int interrupt_window_interception(struct kvm_vcpu *vcpu)
c1150d8cf9e9d2 drivers/kvm/svm.c      Dor Laor              2007-01-05  3239  {
63129754178c55 arch/x86/kvm/svm/svm.c Paolo Bonzini         2021-03-02  3240  	kvm_make_request(KVM_REQ_EVENT, vcpu);
63129754178c55 arch/x86/kvm/svm/svm.c Paolo Bonzini         2021-03-02  3241  	svm_clear_vintr(to_svm(vcpu));
f3515dc3bef81e arch/x86/kvm/svm.c     Suravee Suthikulpanit 2019-11-14  3242  
f3515dc3bef81e arch/x86/kvm/svm.c     Suravee Suthikulpanit 2019-11-14  3243  	/*
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3244  	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
f3515dc3bef81e arch/x86/kvm/svm.c     Suravee Suthikulpanit 2019-11-14  3245  	 * In this case AVIC was temporarily disabled for
f3515dc3bef81e arch/x86/kvm/svm.c     Suravee Suthikulpanit 2019-11-14  3246  	 * requesting the IRQ window and we have to re-enable it.
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3247  	 *
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3248  	 * If running nested, still remove the VM wide AVIC inhibit to
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3249  	 * support case in which the interrupt window was requested when the
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3250  	 * vCPU was not running nested.
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3251  
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3252  	 * All vCPUs which run still run nested, will remain to have their
f44509f849fe55 arch/x86/kvm/svm/svm.c Maxim Levitsky        2022-03-22  3253  	 * AVIC still inhibited due to per-cpu AVIC inhibition.
f3515dc3bef81e arch/x86/kvm/svm.c     Suravee Suthikulpanit 2019-11-14  3254  	 */
320af55a930f30 arch/x86/kvm/svm/svm.c Sean Christopherson   2022-03-11 @3255  	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
f3515dc3bef81e arch/x86/kvm/svm.c     Suravee Suthikulpanit 2019-11-14  3256  
6249af46321662 arch/x86/kvm/svm/svm.c Paolo Bonzini         2025-03-31  3257  	++vcpu->stat->irq_window_exits;
c1150d8cf9e9d2 drivers/kvm/svm.c      Dor Laor              2007-01-05  3258  	return 1;
c1150d8cf9e9d2 drivers/kvm/svm.c      Dor Laor              2007-01-05  3259  }
c1150d8cf9e9d2 drivers/kvm/svm.c      Dor Laor              2007-01-05  3260  

:::::: The code at line 3255 was first introduced by commit
:::::: 320af55a930f30ba49d7cd663280d46705e11383 KVM: x86: Add wrappers for setting/clearing APICv inhibits

:::::: TO: Sean Christopherson <seanjc@google.com>
:::::: CC: Paolo Bonzini <pbonzini@redhat.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

