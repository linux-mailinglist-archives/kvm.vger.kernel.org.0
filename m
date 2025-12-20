Return-Path: <kvm+bounces-66436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC24CD3076
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 15:01:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9730E302921E
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 14:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C20522A4CC;
	Sat, 20 Dec 2025 14:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lZ3FIy4U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901042EFDA1;
	Sat, 20 Dec 2025 14:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766239205; cv=none; b=UJ23aXg/7RkxhnNQoTiVF+uneiAIWLGRD2C3zeFTl1QCp9rvOtatubsNUl8FP7Yk0Dw4l6R+zTmoJpzcJVrysj/s2dF7ma8BvgTj/VYO3ABxbi4MJvUlXFpCU47a6Ra9mXQsp2t+nalTCwfhnEZ9zpuaiKqxgvBF+sUcUH6BT7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766239205; c=relaxed/simple;
	bh=+H/npnpo/aHP5YbM3+ZLB+6vTAQkvqdVC9uKXkV2xjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJ6MYG7EQQxXB0rBVMXMHx3yVpzOIfwyiVTPrqe9/EjoofsfiZt2fnp19pfM1pLi68LXkLpbky1Lzkmn71ooZz2eOS0D262bYDj3VldG/uiYuiTWSTK0XdEVIiH1ikS1cHR/3f8BNFavjE1vbnwB/UhffbRqlG0Hx4BGeaLp69k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lZ3FIy4U; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766239203; x=1797775203;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+H/npnpo/aHP5YbM3+ZLB+6vTAQkvqdVC9uKXkV2xjY=;
  b=lZ3FIy4UPHxD3QK4tMDXpXDXRqn+RVyW4HnRu0u2hLiN+g62aAbt0lfu
   1DsnBCZ3Ib6jC+j7vVyU6371VhdP7wEbDV5uEVEA+KUQAZAT+a59OtwVB
   ussylQGCEE6BDLxl5IG7ntkSAM9vcjmfjvieQnJLzs18TDz1BWH23im/I
   r09df/QmR3IoaP1zVxdVw9dKpUsOZO+s4e8UIINtrFphG2Eklig1gjAx3
   EF6eM0UYXNR1eaNOSJmSE6beV3XfUg5cmWc5R15nViKZmvGmA/ulTYstC
   SiqHGuFQF3KCLjLHN1eXZ2932kIX9pDWFhfi4TKTWbknENz+hFamzaxQd
   A==;
X-CSE-ConnectionGUID: PHiMsjlzSVaypg4zfLhLsQ==
X-CSE-MsgGUID: 4k+NyO4kRxmujqpTHq+lAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="71806573"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="71806573"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 06:00:02 -0800
X-CSE-ConnectionGUID: 8w7HrFL5RDqOfTYJHrs1RQ==
X-CSE-MsgGUID: t8l+VLJmR8aABKYJ508zcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="198256643"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 20 Dec 2025 05:59:57 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWxUv-000000004b5-3nWI;
	Sat, 20 Dec 2025 13:59:53 +0000
Date: Sat, 20 Dec 2025 21:59:51 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH v12 19/46] KVM: arm64: Expose support for private memory
Message-ID: <202512202152.gapj1OD5-lkp@intel.com>
References: <20251217101125.91098-20-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217101125.91098-20-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.19-rc1 next-20251219]
[cannot apply to kvmarm/next kvm/queue kvm/next arm64/for-next/core kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/kvm-arm64-Include-kvm_emulate-h-in-kvm-arm_psci-h/20251218-030351
base:   linus/master
patch link:    https://lore.kernel.org/r/20251217101125.91098-20-steven.price%40arm.com
patch subject: [PATCH v12 19/46] KVM: arm64: Expose support for private memory
config: arm64-randconfig-001-20251219 (https://download.01.org/0day-ci/archive/20251220/202512202152.gapj1OD5-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project b324c9f4fa112d61a553bf489b5f4f7ceea05ea8)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512202152.gapj1OD5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512202152.gapj1OD5-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:16:
>> include/linux/kvm_host.h:725:45: error: expected identifier or '('
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                                             ^
>> include/linux/kvm_host.h:725:45: error: expected ')'
   include/linux/kvm_host.h:725:20: note: to match this '('
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                    ^
   arch/arm64/include/asm/kvm_host.h:1465:40: note: expanded from macro 'kvm_arch_has_private_mem'
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                        ^
   In file included from arch/arm64/kernel/asm-offsets.c:16:
   include/linux/kvm_host.h:725:20: error: expected ')'
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                    ^
   arch/arm64/include/asm/kvm_host.h:1465:45: note: expanded from macro 'kvm_arch_has_private_mem'
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                             ^
   include/linux/kvm_host.h:725:20: note: to match this '('
   arch/arm64/include/asm/kvm_host.h:1465:39: note: expanded from macro 'kvm_arch_has_private_mem'
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                       ^
   3 errors generated.
   make[3]: *** [scripts/Makefile.build:182: arch/arm64/kernel/asm-offsets.s] Error 1 shuffle=1976660145
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1314: prepare0] Error 2 shuffle=1976660145
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2 shuffle=1976660145
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2 shuffle=1976660145
   make: Target 'prepare' not remade because of errors.


vim +725 include/linux/kvm_host.h

f481b069e67437 Paolo Bonzini       2015-05-17  723  
d1e54dd08f163a Fuad Tabba          2025-07-29  724  #ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
a7800aa80ea4d5 Sean Christopherson 2023-11-13 @725  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
a7800aa80ea4d5 Sean Christopherson 2023-11-13  726  {
a7800aa80ea4d5 Sean Christopherson 2023-11-13  727  	return false;
a7800aa80ea4d5 Sean Christopherson 2023-11-13  728  }
a7800aa80ea4d5 Sean Christopherson 2023-11-13  729  #endif
a7800aa80ea4d5 Sean Christopherson 2023-11-13  730  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

