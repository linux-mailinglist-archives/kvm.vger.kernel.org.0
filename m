Return-Path: <kvm+bounces-66437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 836ECCD30B4
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 15:19:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2C1B3020CEC
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 14:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E2D28CF41;
	Sat, 20 Dec 2025 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mBwKGwAA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1782459DD;
	Sat, 20 Dec 2025 14:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766240328; cv=none; b=tDJg6WWpez0hj8qVD/XD5LP5NNi9TpcnxkHvWrzlrsJ8gTFgcNqEb4fqNfArtVUKZQGg7E/j84zcHvjaFe6tOWL1jvM/wDnYjM+PeKvyrGmW+vtSe4tUKT5S6xjuEIk/3x9hF4wUmdgrQ8HkbirE8MVS46ZkU/0S+PBzjKcY764=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766240328; c=relaxed/simple;
	bh=IlFgiyLO8O26Ptr6Yel73607DUKyQzNFhwrReyq53qY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sAorrcvCcwRqfDUFBARYyakoCQjqyBaA5IzUOcAHuuCuW27VrvAkdq03m7WVoGMZgBDTHlm5N/FqbLF5bXbi3tNWp/ygbjL7oY3gFlWhqe0cu5SZlnp4f8mLIubFVXUN1i1EovbUfZOYUEK5CIsOnRAOGCcfaz25ezB7PFKJj6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mBwKGwAA; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766240326; x=1797776326;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IlFgiyLO8O26Ptr6Yel73607DUKyQzNFhwrReyq53qY=;
  b=mBwKGwAArkvHl2kK7OarnhQHOg1BfsgtYl7i2bE7nmCVtdkLf7fdqvN+
   yFEGtIQiWl7E7BHrD6mPW6TQQvOWVt+mUAQBYi6awlsZcHt7r7gsr+lVm
   Vbv+8dS4wKYMUSSkY/9k1zwxVWfQWqjeGyCWaAriCyLe7Tc+AHsBBO22e
   9wFB9WMvItLBSIMEXWKdrmI+GlBpDZuNFN443gPQHOw9l/rFg/7yugXwt
   mYml95e1BRm/oT9y9gBBTqdaUK/NjmBqwaKku3zgtA8X3oVpb1mx5dA4M
   MSyf7uAb9Om1mXuYxlA+e9n8LLOeYJauJ58SUnkn3Vz4y5cYn5wN7LoL+
   w==;
X-CSE-ConnectionGUID: hme9aGDcTbih9qJI7X1riw==
X-CSE-MsgGUID: qkXbjtvJT9S0FliPJiEZgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="93649019"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="93649019"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2025 06:18:45 -0800
X-CSE-ConnectionGUID: WYX4smkkRf+9uiPCatM6Tg==
X-CSE-MsgGUID: GvLJtsJsTAGDc5ftWSQ93w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199022075"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 20 Dec 2025 06:18:41 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWxn4-000000004e4-2aKD;
	Sat, 20 Dec 2025 14:18:38 +0000
Date: Sat, 20 Dec 2025 15:18:35 +0100
From: kernel test robot <lkp@intel.com>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Steven Price <steven.price@arm.com>,
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
Message-ID: <202512201539.ZhAox5t9-lkp@intel.com>
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
[also build test ERROR on next-20251219]
[cannot apply to kvmarm/next kvm/queue kvm/next arm64/for-next/core kvm/linux-next v6.16-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/kvm-arm64-Include-kvm_emulate-h-in-kvm-arm_psci-h/20251217-224409
base:   linus/master
patch link:    https://lore.kernel.org/r/20251217101125.91098-20-steven.price%40arm.com
patch subject: [PATCH v12 19/46] KVM: arm64: Expose support for private memory
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20251220/202512201539.ZhAox5t9-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project ecaf673850beb241957352bd61e95ed34256635f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251220/202512201539.ZhAox5t9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512201539.ZhAox5t9-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:16:
>> ./include/linux/kvm_host.h:725:45: error: expected identifier or '('
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                                             ^
>> ./include/linux/kvm_host.h:725:45: error: expected ')'
   ./include/linux/kvm_host.h:725:20: note: to match this '('
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                    ^
   ./arch/arm64/include/asm/kvm_host.h:1465:40: note: expanded from macro 'kvm_arch_has_private_mem'
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                        ^
   In file included from arch/arm64/kernel/asm-offsets.c:16:
   ./include/linux/kvm_host.h:725:20: error: expected ')'
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                    ^
   ./arch/arm64/include/asm/kvm_host.h:1465:45: note: expanded from macro 'kvm_arch_has_private_mem'
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                             ^
   ./include/linux/kvm_host.h:725:20: note: to match this '('
   ./arch/arm64/include/asm/kvm_host.h:1465:39: note: expanded from macro 'kvm_arch_has_private_mem'
    1465 | #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.is_realm)
         |                                       ^
   3 errors generated.


vim +725 ./include/linux/kvm_host.h

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

