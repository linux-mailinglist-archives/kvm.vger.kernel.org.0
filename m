Return-Path: <kvm+bounces-54861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E39DB2951D
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 23:03:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 439014E5BFB
	for <lists+kvm@lfdr.de>; Sun, 17 Aug 2025 21:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDFFC242D82;
	Sun, 17 Aug 2025 21:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lNkEzsNH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02964221269;
	Sun, 17 Aug 2025 21:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755464607; cv=none; b=ZwllLWmyl3sx3BCQVjBBtsKyzwjur4J0VzU5/KakYoLrkdt9XKQoRx8c2Ul2WyX0nu6SVJ9hl4HjWPMpQdUjNobPxhe6WaN+o1jJFhgPSaDaBrevJOrm6gTAFNKdqHQKNbZK4pFvp/cWlFuqwvRm1DD2TpU3b6ObTw/TpOcz8FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755464607; c=relaxed/simple;
	bh=mXDm9pzQ2v2aMXQtgfLc6q6k54TIbxRQKNSFRAvlPm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WnN8ryROZdKIz3jlclLnxpMZ/4cGzzafIKEafmkgcuNVZsNJ7alqAUu3TfB1JH7Bv4Apgm1yw61/1djfNxZ9qzUKuyvqyE4XBqbcnCpGGu7T8sLP/7kpD8hTZgjVdyWxBYzI7FrKrcAJlI6g9U8Am8GAd0ce5q4DC66hnlmZ/vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lNkEzsNH; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755464605; x=1787000605;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mXDm9pzQ2v2aMXQtgfLc6q6k54TIbxRQKNSFRAvlPm8=;
  b=lNkEzsNHf2oqXRqd6K88ujvtv0biztLmLcJ85cssiuuattMY7pfwir+9
   ELTW84DmsB8gOZ6QEYWaPZLsNkr8+gfNAW5PDnxs5u7cEgg49nlnBKY/T
   bfoAnTteCsF2UXT9YmnE/Hqq4PPAJtfvUrG+CE7JPDYFlvi+tf3K69PXo
   0x0f7vS93HIMHeG0geIALF2tjLes6igaJkH6ZmhdUg6BHJpePbkWABCs9
   F6iV8eH2fJ4fIVu3R5X5PoQ3jdvxh9SLr5lyjHbPojc+4PzlXPz7xadkN
   TlGP3pCS7x3gySSGtt6yv8082gp2NlGILltAJcnxuIvXOkHEd6M9w54qh
   g==;
X-CSE-ConnectionGUID: tBKX3zB/QnKfbVObwNkVrA==
X-CSE-MsgGUID: otkUOeCcQmS8NdOwT0yCVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="69143667"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="69143667"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 14:03:25 -0700
X-CSE-ConnectionGUID: XDR8jl+CQ7mIMDSoIjuRUw==
X-CSE-MsgGUID: Itk0I8gxStyf6NnlXNz1YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="171644503"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 17 Aug 2025 14:03:21 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unkW4-000Dih-0l;
	Sun, 17 Aug 2025 21:02:41 +0000
Date: Mon, 18 Aug 2025 05:01:04 +0800
From: kernel test robot <lkp@intel.com>
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	guoren@linux.alibaba.com, guoren@kernel.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: Re: [PATCH] RISC-V: KVM: Write hgatp register with valid mode bits
Message-ID: <202508180228.aJykn9j0-lkp@intel.com>
References: <20250816073234.77646-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816073234.77646-1-fangyu.yu@linux.alibaba.com>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next mst-vhost/linux-next linus/master v6.17-rc1 next-20250815]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/fangyu-yu-linux-alibaba-com/RISC-V-KVM-Write-hgatp-register-with-valid-mode-bits/20250816-153513
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20250816073234.77646-1-fangyu.yu%40linux.alibaba.com
patch subject: [PATCH] RISC-V: KVM: Write hgatp register with valid mode bits
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20250818/202508180228.aJykn9j0-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250818/202508180228.aJykn9j0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508180228.aJykn9j0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/riscv/kvm/vmid.c:31:24: error: call to undeclared function 'kvm_riscv_gstage_mode'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
                                 ^
   arch/riscv/kvm/vmid.c:31:48: warning: shift count >= width of type [-Wshift-count-overflow]
           csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
                                                         ^  ~~~~~~~~~~~~~~~~
   arch/riscv/include/asm/csr.h:538:38: note: expanded from macro 'csr_write'
           unsigned long __v = (unsigned long)(val);               \
                                               ^~~
   1 warning and 1 error generated.


vim +/kvm_riscv_gstage_mode +31 arch/riscv/kvm/vmid.c

    24	
    25	void __init kvm_riscv_gstage_vmid_detect(void)
    26	{
    27		unsigned long old;
    28	
    29		/* Figure-out number of VMID bits in HW */
    30		old = csr_read(CSR_HGATP);
  > 31		csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
    32		vmid_bits = csr_read(CSR_HGATP);
    33		vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
    34		vmid_bits = fls_long(vmid_bits);
    35		csr_write(CSR_HGATP, old);
    36	
    37		/* We polluted local TLB so flush all guest TLB */
    38		kvm_riscv_local_hfence_gvma_all();
    39	
    40		/* We don't use VMID bits if they are not sufficient */
    41		if ((1UL << vmid_bits) < num_possible_cpus())
    42			vmid_bits = 0;
    43	}
    44	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

