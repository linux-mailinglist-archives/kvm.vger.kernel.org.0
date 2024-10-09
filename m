Return-Path: <kvm+bounces-28173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC93996044
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7713D1C2382F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 07:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F81417BB24;
	Wed,  9 Oct 2024 07:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nK3O7ZJQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9B8154BEE;
	Wed,  9 Oct 2024 07:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728457423; cv=none; b=uUoaLR1fezrHlwTxgr95pYmZv4lQ6BqxO54eAJ/M6Uuq528Xcrvwx5E2e/2Ige+7+kVfD3HywFpW/tZe1leSx2MLspkhwt9HE7d/oUCC824BxBxQu7N/i56A88R0SHMF+qZLieA22ilmgQ/l57NegMWhXIZhOUxzpOFvWN/pTkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728457423; c=relaxed/simple;
	bh=GGBUpEj3Aa8bQVhLa2+tJ/yY3cOwqwI3rmuFtWCWhtw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ri/gbgY+bDrjm5R0ljpPw2TQChmOjnjISYI0gKgC47QbeSUxRbczUdkRgOm12ZCI64Jx7Vubdn55gO46rgFyzoTyUqya+gycFvAti8TSOIOLz56Yi+bmsuSa8wYOEJznhx2sZAW6etcv6iMq/ftqXWzmsglf0qlmQD+m/rZX2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nK3O7ZJQ; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728457422; x=1759993422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GGBUpEj3Aa8bQVhLa2+tJ/yY3cOwqwI3rmuFtWCWhtw=;
  b=nK3O7ZJQ1tsQJH7va2ih5EjdQ4sYuVMpMyN++Xgru8V/UY3NTrFqvoUt
   l94OUiGjUGL0m9j17/4nf26CSkPjlgEWEZIud+MYxVPrhDDRSZme1CC3a
   EGI1fn1zgW4w+a4PQEdyiyaqUX8rn2sitk6yBxoLAfwRPaOzBczrAMdiS
   +TlYBS6YMxVEL6hVQPXIntfdtJ8F9k824TJcD1C/SLHqe7MqbWXAefIag
   XvLfUiPkhR8djByJYGqAU0at3GDQ7xTG01DXW4Jtv/MyLGXSHegX7O6yr
   fZJHVSRYdAlXVowOZIhLot7oI6wzO0iblGLNw7/MDqmQpG9vluQ3ucN6M
   A==;
X-CSE-ConnectionGUID: g1FugVu4SmC0P51oMkoh3A==
X-CSE-MsgGUID: qBUaaW2YSH+BdPPTNkkM8g==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="45256854"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="45256854"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 00:03:41 -0700
X-CSE-ConnectionGUID: 04Hw06M3S3qS49BFtFIKVQ==
X-CSE-MsgGUID: 8YkUtXahSKW0YFOZWstskA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="106911467"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 09 Oct 2024 00:03:36 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1syQjN-0008u4-2o;
	Wed, 09 Oct 2024 07:03:33 +0000
Date: Wed, 9 Oct 2024 15:03:27 +0800
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v5 42/43] arm64: kvm: Expose support for private memory
Message-ID: <202410091403.EUd787Qt-lkp@intel.com>
References: <20241004152804.72508-43-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004152804.72508-43-steven.price@arm.com>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on linus/master v6.12-rc2 next-20241008]
[cannot apply to kvmarm/next kvm/queue kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/KVM-Prepare-for-handling-only-shared-mappings-in-mmu_notifier-events/20241005-000420
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20241004152804.72508-43-steven.price%40arm.com
patch subject: [PATCH v5 42/43] arm64: kvm: Expose support for private memory
config: arm64-randconfig-r121-20241008 (https://download.01.org/0day-ci/archive/20241009/202410091403.EUd787Qt-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce: (https://download.01.org/0day-ci/archive/20241009/202410091403.EUd787Qt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410091403.EUd787Qt-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:563:18: sparse: sparse: incompatible types in comparison expression (different address spaces):
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:563:18: sparse:    struct file *
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:563:18: sparse:    struct file [noderef] __rcu *
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:130:17: sparse: sparse: context imbalance in 'kvm_gmem_invalidate_begin' - different lock contexts for basic block
>> arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct file **f @@     got struct file [noderef] __rcu ** @@
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse:     expected struct file **f
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse:     got struct file [noderef] __rcu **
>> arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct file **f @@     got struct file [noderef] __rcu ** @@
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse:     expected struct file **f
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse:     got struct file [noderef] __rcu **
>> arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct file **f @@     got struct file [noderef] __rcu ** @@
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse:     expected struct file **f
   arch/arm64/kvm/../../../virt/kvm/guest_memfd.c:302:33: sparse:     got struct file [noderef] __rcu **

vim +563 arch/arm64/kvm/../../../virt/kvm/guest_memfd.c

a7800aa80ea4d5 Sean Christopherson 2023-11-13  552  
78c4293372fe1f Paolo Bonzini       2024-07-11  553  /* Returns a locked folio on success.  */
d0d87226f53596 Paolo Bonzini       2024-07-11  554  static struct folio *
d0d87226f53596 Paolo Bonzini       2024-07-11  555  __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
66a644c09fbed0 Paolo Bonzini       2024-07-26  556  		   gfn_t gfn, kvm_pfn_t *pfn, bool *is_prepared,
66a644c09fbed0 Paolo Bonzini       2024-07-26  557  		   int *max_order)
a7800aa80ea4d5 Sean Christopherson 2023-11-13  558  {
a7800aa80ea4d5 Sean Christopherson 2023-11-13  559  	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
17573fd971f9e3 Paolo Bonzini       2024-04-04  560  	struct kvm_gmem *gmem = file->private_data;
a7800aa80ea4d5 Sean Christopherson 2023-11-13  561  	struct folio *folio;
a7800aa80ea4d5 Sean Christopherson 2023-11-13  562  
17573fd971f9e3 Paolo Bonzini       2024-04-04 @563  	if (file != slot->gmem.file) {
17573fd971f9e3 Paolo Bonzini       2024-04-04  564  		WARN_ON_ONCE(slot->gmem.file);
d0d87226f53596 Paolo Bonzini       2024-07-11  565  		return ERR_PTR(-EFAULT);
17573fd971f9e3 Paolo Bonzini       2024-04-04  566  	}
a7800aa80ea4d5 Sean Christopherson 2023-11-13  567  
a7800aa80ea4d5 Sean Christopherson 2023-11-13  568  	gmem = file->private_data;
fa30b0dc91c815 Paolo Bonzini       2024-04-04  569  	if (xa_load(&gmem->bindings, index) != slot) {
fa30b0dc91c815 Paolo Bonzini       2024-04-04  570  		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
d0d87226f53596 Paolo Bonzini       2024-07-11  571  		return ERR_PTR(-EIO);
a7800aa80ea4d5 Sean Christopherson 2023-11-13  572  	}
a7800aa80ea4d5 Sean Christopherson 2023-11-13  573  
b85524314a3db6 Paolo Bonzini       2024-07-11  574  	folio = kvm_gmem_get_folio(file_inode(file), index);
17573fd971f9e3 Paolo Bonzini       2024-04-04  575  	if (IS_ERR(folio))
d0d87226f53596 Paolo Bonzini       2024-07-11  576  		return folio;
a7800aa80ea4d5 Sean Christopherson 2023-11-13  577  
a7800aa80ea4d5 Sean Christopherson 2023-11-13  578  	if (folio_test_hwpoison(folio)) {
c31745d2c50879 Paolo Bonzini       2024-06-11  579  		folio_unlock(folio);
c31745d2c50879 Paolo Bonzini       2024-06-11  580  		folio_put(folio);
d0d87226f53596 Paolo Bonzini       2024-07-11  581  		return ERR_PTR(-EHWPOISON);
a7800aa80ea4d5 Sean Christopherson 2023-11-13  582  	}
a7800aa80ea4d5 Sean Christopherson 2023-11-13  583  
7fbdda31b0a14f Paolo Bonzini       2024-07-11  584  	*pfn = folio_file_pfn(folio, index);
a7800aa80ea4d5 Sean Christopherson 2023-11-13  585  	if (max_order)
a7800aa80ea4d5 Sean Christopherson 2023-11-13  586  		*max_order = 0;
a7800aa80ea4d5 Sean Christopherson 2023-11-13  587  
66a644c09fbed0 Paolo Bonzini       2024-07-26  588  	*is_prepared = folio_test_uptodate(folio);
d0d87226f53596 Paolo Bonzini       2024-07-11  589  	return folio;
a7800aa80ea4d5 Sean Christopherson 2023-11-13  590  }
17573fd971f9e3 Paolo Bonzini       2024-04-04  591  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

