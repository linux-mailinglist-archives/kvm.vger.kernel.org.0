Return-Path: <kvm+bounces-37126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7598A2585B
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 12:42:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AD28166522
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 11:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EEF92036F6;
	Mon,  3 Feb 2025 11:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h6U7cxqj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A7B200127;
	Mon,  3 Feb 2025 11:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738582937; cv=none; b=H6SrnvFTWEmI7KVRCxbf87DnC2rNWgbwsYGcEpi4vm8SoUzA0JdOd+arSIqXNZfokyCr2aaUNxNzDIHPDQkdyvxIN1f8EbaR9Ad3XqWzDr7WBAYHFyxaWAFM7+QZBAvwJwqliUjBlOo9HURQUv2av/wH7AC6fl3YA4l+Jaj12Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738582937; c=relaxed/simple;
	bh=O4xzQ9IjFRVAgQLUcMMUOoppwfChKnIvpNkhNYdnaIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YK3Lf8P4exzSPbEd2XcCzJEOwK4T5jS9NEN/hsz3E1RTvQD6ieiXf5datKWzU9UAxPfw1/kUlWWOw7/EbbEDxNraw8tqziShdo4ksAdlrANCN8tggBTqaBuaP51qcWjq1WE8dBpTf8h6W5L7GqKS/80FL2WQxfiOPmaQ3sLsgMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h6U7cxqj; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738582936; x=1770118936;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O4xzQ9IjFRVAgQLUcMMUOoppwfChKnIvpNkhNYdnaIk=;
  b=h6U7cxqjOpBN/twQ6Hd8dkZ1jSP78SnYnhde1rNUIYruMNG2bP4ormUJ
   mzE2L/x3hyXOXkcai4ueEJERXmeosN5lRDUXXM9krH38GpI3+xt3petNO
   PP3jRdS0h+b+YhVD9KWh/5TAKEnhfUh3H+awuZaZCUr+bY6alMHsXcTGU
   x6e7FjXZmlp9XgngrqeBSMVZVyygqE3V8xzON7qgAGqdDGq/NYwHHNjLs
   gYr+SuivR1OR8HvbuT0LDYbcyIIpcfjpUOc86QoQDpwEH9W5NiftExP83
   u9d13VASdWnmqIeC6Rzmk26HQyM6lmlrmc1+xKatKM25T0Rt1EMxQKJii
   g==;
X-CSE-ConnectionGUID: QxgFyXTDSMC1i/AkJXBkng==
X-CSE-MsgGUID: Tn+3lylERTySncL63zz1rA==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="39172843"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="39172843"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2025 03:42:15 -0800
X-CSE-ConnectionGUID: z2G+Hd7zQTOIawsMzqBzaw==
X-CSE-MsgGUID: vJ754Xd5SZOyrE0cNy8LsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,255,1732608000"; 
   d="scan'208";a="110020376"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 03 Feb 2025 03:42:14 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1teuqA-000qqx-2K;
	Mon, 03 Feb 2025 11:42:10 +0000
Date: Mon, 3 Feb 2025 19:41:15 +0800
From: kernel test robot <lkp@intel.com>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v2 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
Message-ID: <202502031922.dBj76pSx-lkp@intel.com>
References: <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>

Hi Naveen,

kernel test robot noticed the following build errors:

[auto build test ERROR on eb723766b1030a23c38adf2348b7c3d1409d11f0]

url:    https://github.com/intel-lab-lkp/linux/commits/Naveen-N-Rao-AMD/KVM-SVM-Increase-X2AVIC-limit-to-4096-vcpus/20250203-144127
base:   eb723766b1030a23c38adf2348b7c3d1409d11f0
patch link:    https://lore.kernel.org/r/b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen%40kernel.org
patch subject: [PATCH v2 2/2] KVM: SVM: Limit AVIC physical max index based on configured max_vcpu_ids
config: x86_64-buildonly-randconfig-003-20250203 (https://download.01.org/0day-ci/archive/20250203/202502031922.dBj76pSx-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250203/202502031922.dBj76pSx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502031922.dBj76pSx-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/include/asm/kvm_host.h:31,
                    from include/linux/kvm_host.h:45,
                    from arch/x86/kvm/svm/avic.c:20:
>> arch/x86/include/asm/apic.h:258:34: error: expected ')' before numeric constant
     258 | #define x2apic_mode             (0)
         |                                  ^
   arch/x86/kvm/svm/avic.c:88:66: note: in expansion of macro 'x2apic_mode'
      88 | static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool x2apic_mode)
         |                                                                  ^~~~~~~~~~~
   arch/x86/kvm/svm/avic.c: In function 'avic_activate_vmcb':
>> arch/x86/kvm/svm/avic.c:117:51: error: implicit declaration of function 'avic_get_max_physical_id' [-Werror=implicit-function-declaration]
     117 |                 vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/avic_get_max_physical_id +117 arch/x86/kvm/svm/avic.c

    98	
    99	static void avic_activate_vmcb(struct vcpu_svm *svm)
   100	{
   101		struct vmcb *vmcb = svm->vmcb01.ptr;
   102	
   103		vmcb->control.int_ctl &= ~(AVIC_ENABLE_MASK | X2APIC_MODE_MASK);
   104		vmcb->control.avic_physical_id &= ~avic_physical_max_index_mask;
   105	
   106		vmcb->control.int_ctl |= AVIC_ENABLE_MASK;
   107	
   108		/*
   109		 * Note: KVM supports hybrid-AVIC mode, where KVM emulates x2APIC MSR
   110		 * accesses, while interrupt injection to a running vCPU can be
   111		 * achieved using AVIC doorbell.  KVM disables the APIC access page
   112		 * (deletes the memslot) if any vCPU has x2APIC enabled, thus enabling
   113		 * AVIC in hybrid mode activates only the doorbell mechanism.
   114		 */
   115		if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
   116			vmcb->control.int_ctl |= X2APIC_MODE_MASK;
 > 117			vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
   118			/* Disabling MSR intercept for x2APIC registers */
   119			svm_set_x2apic_msr_interception(svm, false);
   120		} else {
   121			/*
   122			 * Flush the TLB, the guest may have inserted a non-APIC
   123			 * mapping into the TLB while AVIC was disabled.
   124			 */
   125			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
   126	
   127			/* For xAVIC and hybrid-xAVIC modes */
   128			vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, false);
   129			/* Enabling MSR intercept for x2APIC registers */
   130			svm_set_x2apic_msr_interception(svm, true);
   131		}
   132	}
   133	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

