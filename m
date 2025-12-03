Return-Path: <kvm+bounces-65195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 60310C9EC6B
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 11:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2060734B67E
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 10:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 797892F12B6;
	Wed,  3 Dec 2025 10:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tjbjn/qB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F3E2F1FF1;
	Wed,  3 Dec 2025 10:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764759218; cv=none; b=OahBzRVN7zcsbtY49BZVSsFF18oNvqaSymumXawQhEZb7YzQhTCqkiQXH6P1KnY9/W+U/PSRz8jznB0SD4WKEBInOxAZjPN3a5mR1OH5lPf3h5iykmTGXwzX2GwWAg8xByA9g/5KD26dkkzCgLmbkWuJQGuKYa7HDNGcmEsiwco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764759218; c=relaxed/simple;
	bh=/lMt6d6wt5EpklsqUXRg85Drw1rS3QE+lNt8vHdf2Do=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWqNKoQWzNRVmTr1bccwqrqbrMOQuZTRpFV/rclvb2ec44Ad7xnCxmINSpPma9EvPwhljlQdKM54xeqG4kd8ALQPD0DjBoK+oDoF5kMrfNcemNpMZllq0FSaWgJ5da+A+m+oNR74RQQlRytg+F0++VNVwNVlxScnFIxauOTTg84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tjbjn/qB; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764759216; x=1796295216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/lMt6d6wt5EpklsqUXRg85Drw1rS3QE+lNt8vHdf2Do=;
  b=Tjbjn/qB5OJK9aeow/T5m+oW4TXZ2L3ZAp5zjOfZwL8qDU197+4c1Wbx
   YfCechgTgOpy56g5l24FmiO9fME6YiOC+nbvR2hTb3Q7TMnhQZY2EKeOl
   3r1Yvzjpe3GRSGtl47pjkVFbH5GrMbE/eOdyrNrZUnbKhuWaecZEipUJ+
   9eYrYFT2hrFOa/JIQdJc+hKxcG9pqjAG/2a7CGAePfQF1jd0FOrHyRi0F
   xzNdx4eFeDor/gL3sNDPwonqtHOJFBIOIMSr7qZMkLGmwH3PHzWpTd8/X
   xz+cLbO+7/bN0KuoBvqp/0WIz2gaKKJL60aQHaYiENv4+wJsDTkLDyydN
   A==;
X-CSE-ConnectionGUID: cdGUb6DfQe2gp0O3mW2jmA==
X-CSE-MsgGUID: a9pKkTjBR/qGjITjMIZdgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="77428987"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="77428987"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 02:53:35 -0800
X-CSE-ConnectionGUID: m/uL1YpIQeaVmK5xAQXRYg==
X-CSE-MsgGUID: D0vFuoSVTtCTr+d7xR1F3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="231989776"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 03 Dec 2025 02:53:31 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQkUC-00000000AtZ-3diz;
	Wed, 03 Dec 2025 10:53:28 +0000
Date: Wed, 3 Dec 2025 18:52:48 +0800
From: kernel test robot <lkp@intel.com>
To: zhouquan@iscas.ac.cn, anup@brainfault.org, ajones@ventanamicro.com,
	atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, Quan Zhou <zhouquan@iscas.ac.cn>
Subject: Re: [PATCH 3/4] RISC-V: KVM: Add suuport for zicfiss/zicfilp/svadu
 FWFT features
Message-ID: <202512031835.rfeAWiCJ-lkp@intel.com>
References: <1793aa636969da0a09d27c9c12f6d5f8f0d1cd21.1764509485.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1793aa636969da0a09d27c9c12f6d5f8f0d1cd21.1764509485.git.zhouquan@iscas.ac.cn>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next linus/master v6.18 next-20251203]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/zhouquan-iscas-ac-cn/RISC-V-KVM-Allow-zicfiss-zicfilp-exts-for-Guest-VM/20251201-094857
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/1793aa636969da0a09d27c9c12f6d5f8f0d1cd21.1764509485.git.zhouquan%40iscas.ac.cn
patch subject: [PATCH 3/4] RISC-V: KVM: Add suuport for zicfiss/zicfilp/svadu FWFT features
config: riscv-randconfig-001-20251203 (https://download.01.org/0day-ci/archive/20251203/202512031835.rfeAWiCJ-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512031835.rfeAWiCJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512031835.rfeAWiCJ-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/riscv/kvm/vcpu_sbi_fwft.c:345:30: error: 'kvm_sbi_fwft_landing_pad_supported' undeclared here (not in a function)
     345 |                 .supported = kvm_sbi_fwft_landing_pad_supported,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:346:26: error: 'kvm_sbi_fwft_reset_landing_pad' undeclared here (not in a function)
     346 |                 .reset = kvm_sbi_fwft_reset_landing_pad,
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:347:24: error: 'kvm_sbi_fwft_set_landing_pad' undeclared here (not in a function)
     347 |                 .set = kvm_sbi_fwft_set_landing_pad,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:348:24: error: 'kvm_sbi_fwft_get_landing_pad' undeclared here (not in a function)
     348 |                 .get = kvm_sbi_fwft_get_landing_pad,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:354:30: error: 'kvm_sbi_fwft_shadow_stack_supported' undeclared here (not in a function)
     354 |                 .supported = kvm_sbi_fwft_shadow_stack_supported,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:355:26: error: 'kvm_sbi_fwft_reset_shadow_stack' undeclared here (not in a function)
     355 |                 .reset = kvm_sbi_fwft_reset_shadow_stack,
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:356:24: error: 'kvm_sbi_fwft_set_shadow_stack' undeclared here (not in a function)
     356 |                 .set = kvm_sbi_fwft_set_shadow_stack,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:357:24: error: 'kvm_sbi_fwft_get_shadow_stack' undeclared here (not in a function)
     357 |                 .get = kvm_sbi_fwft_get_shadow_stack,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:363:30: error: 'kvm_sbi_fwft_pte_ad_hw_updating_supported' undeclared here (not in a function)
     363 |                 .supported = kvm_sbi_fwft_pte_ad_hw_updating_supported,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:364:26: error: 'kvm_sbi_fwft_reset_pte_ad_hw_updating' undeclared here (not in a function)
     364 |                 .reset = kvm_sbi_fwft_reset_pte_ad_hw_updating,
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:365:24: error: 'kvm_sbi_fwft_set_pte_ad_hw_updating' undeclared here (not in a function)
     365 |                 .set = kvm_sbi_fwft_set_pte_ad_hw_updating,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> arch/riscv/kvm/vcpu_sbi_fwft.c:366:24: error: 'kvm_sbi_fwft_get_pte_ad_hw_updating' undeclared here (not in a function)
     366 |                 .get = kvm_sbi_fwft_get_pte_ad_hw_updating,
         |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/kvm_sbi_fwft_landing_pad_supported +345 arch/riscv/kvm/vcpu_sbi_fwft.c

   319	
   320	static const struct kvm_sbi_fwft_feature features[] = {
   321		{
   322			.id = SBI_FWFT_MISALIGNED_EXC_DELEG,
   323			.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, misaligned_deleg.enable) /
   324					 sizeof(unsigned long),
   325			.supported = kvm_sbi_fwft_misaligned_delegation_supported,
   326			.reset = kvm_sbi_fwft_reset_misaligned_delegation,
   327			.set = kvm_sbi_fwft_set_misaligned_delegation,
   328			.get = kvm_sbi_fwft_get_misaligned_delegation,
   329		},
   330	#ifndef CONFIG_32BIT
   331		{
   332			.id = SBI_FWFT_POINTER_MASKING_PMLEN,
   333			.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, pointer_masking.enable) /
   334					 sizeof(unsigned long),
   335			.supported = kvm_sbi_fwft_pointer_masking_pmlen_supported,
   336			.reset = kvm_sbi_fwft_reset_pointer_masking_pmlen,
   337			.set = kvm_sbi_fwft_set_pointer_masking_pmlen,
   338			.get = kvm_sbi_fwft_get_pointer_masking_pmlen,
   339		},
   340	#endif
   341		{
   342			.id = SBI_FWFT_LANDING_PAD,
   343			.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, landing_pad.enable) /
   344					 sizeof(unsigned long),
 > 345			.supported = kvm_sbi_fwft_landing_pad_supported,
 > 346			.reset = kvm_sbi_fwft_reset_landing_pad,
 > 347			.set = kvm_sbi_fwft_set_landing_pad,
 > 348			.get = kvm_sbi_fwft_get_landing_pad,
   349		},
   350		{
   351			.id = SBI_FWFT_SHADOW_STACK,
   352			.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, shadow_stack.enable) /
   353					 sizeof(unsigned long),
 > 354			.supported = kvm_sbi_fwft_shadow_stack_supported,
 > 355			.reset = kvm_sbi_fwft_reset_shadow_stack,
 > 356			.set = kvm_sbi_fwft_set_shadow_stack,
 > 357			.get = kvm_sbi_fwft_get_shadow_stack,
   358		},
   359		{
   360			.id = SBI_FWFT_PTE_AD_HW_UPDATING,
   361			.first_reg_num = offsetof(struct kvm_riscv_sbi_fwft, pte_ad_hw_updating.enable) /
   362					 sizeof(unsigned long),
 > 363			.supported = kvm_sbi_fwft_pte_ad_hw_updating_supported,
 > 364			.reset = kvm_sbi_fwft_reset_pte_ad_hw_updating,
 > 365			.set = kvm_sbi_fwft_set_pte_ad_hw_updating,
 > 366			.get = kvm_sbi_fwft_get_pte_ad_hw_updating,
   367		},
   368	};
   369	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

