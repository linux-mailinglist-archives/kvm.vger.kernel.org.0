Return-Path: <kvm+bounces-63238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C456C5E724
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD9523BE7D1
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8756D3385AA;
	Fri, 14 Nov 2025 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iA7qrkb+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F672DC345;
	Fri, 14 Nov 2025 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763140026; cv=none; b=asxd2kSPRH+4cIUQdfXxEWQpiKTmlu29lkfMfKzfUchXh2WQAFrG5rtZq9NdDK8ILgFVsCCtMXaYSis2bvM+TLceZgVS+xQ7tzir85NlnnwreNvI29NZntNWIQypjvMkWC/pvwUHp9EjJH+IrYpZ9kMjaTh6npXLYEsZQSvatvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763140026; c=relaxed/simple;
	bh=dvmEoRCW0EDK8YgTunKSG7UFVtCEFJ6JhWmUpWvB9Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKHamrIBXt+0PY/HQPJFw+qJFlbZ1wIr/z70VI1+qExe2LnlfwmhIT70UPBOGdJTnFLIS+fV1rQUJC5OkXBFgX87+OA7V4BHD266+272vOAoWbPfEU8MS0TyVonCwCGikfdZ82bPS+jiJn8n2nucilm1ZDe4FGbsz488wuiicDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iA7qrkb+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763140024; x=1794676024;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dvmEoRCW0EDK8YgTunKSG7UFVtCEFJ6JhWmUpWvB9Ag=;
  b=iA7qrkb+n35PaNmZLj4w7PCEDJQNyXI1S4OUi7MLAFUsCfu65EApWpAH
   9o34htd7JU+ku6faN2jxFW47mMXBQEFBjw5eACDqbqSr/3MeuIeG4AFCu
   fpE/tbpTXXMur/gsXDcls6Fa68UVcv9TD8uWP3JhYQnCWqNQoSgIl6OtJ
   o3HxMlZ3sllzR+wAKIm1R0j6TDxEJ7zvev2E51Ad9DSX/kA6EpWCpAqxc
   D6pDwiCZ9fL4lQkT0Np68gfnbMh5NtGk6uFDn3V7t951IDXqY+b9zCOzJ
   j2UwGlRgrqTl29AjzIF8v6RNajkeH9AuOoJOJH2toi5QHhF2mFPGlHEOy
   g==;
X-CSE-ConnectionGUID: kirf/mB6SAWxtMOEGUevrA==
X-CSE-MsgGUID: 4qszv9n9Sr+WyL+Vo7zFhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65169418"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65169418"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 09:07:03 -0800
X-CSE-ConnectionGUID: A6XOc/ZYRIGJdn9NSAIE5w==
X-CSE-MsgGUID: nWsnSUWUSAaXA1vZaAtPWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="189111665"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 14 Nov 2025 09:07:01 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJxGE-0006pj-30;
	Fri, 14 Nov 2025 17:06:58 +0000
Date: Sat, 15 Nov 2025 01:06:24 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: Re: [PATCH 07/10] KVM: emulate: add AVX support to register fetch
 and writeback
Message-ID: <202511150016.KszKz14N-lkp@intel.com>
References: <20251114003633.60689-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114003633.60689-8-pbonzini@redhat.com>

Hi Paolo,

kernel test robot noticed the following build errors:

[auto build test ERROR on v6.18-rc5]
[also build test ERROR on linus/master next-20251114]
[cannot apply to kvm/queue kvm/next mst-vhost/linux-next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-emulate-add-MOVNTDQA/20251114-084216
base:   v6.18-rc5
patch link:    https://lore.kernel.org/r/20251114003633.60689-8-pbonzini%40redhat.com
patch subject: [PATCH 07/10] KVM: emulate: add AVX support to register fetch and writeback
config: i386-buildonly-randconfig-002-20251114 (https://download.01.org/0day-ci/archive/20251115/202511150016.KszKz14N-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251115/202511150016.KszKz14N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511150016.KszKz14N-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:60:15: error: register %ymm14 is only available in 64-bit mode
      60 |         case 14: asm("vmovdqa %0, %%ymm14" : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm14
         |                           ^~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:57:15: error: register %ymm11 is only available in 64-bit mode
      57 |         case 11: asm("vmovdqa %0, %%ymm11" : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm11
         |                           ^~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:58:15: error: register %ymm12 is only available in 64-bit mode
      58 |         case 12: asm("vmovdqa %0, %%ymm12" : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm12
         |                           ^~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:55:15: error: register %ymm9 is only available in 64-bit mode
      55 |         case 9:  asm("vmovdqa %0, %%ymm9"  : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm9
         |                           ^~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:61:15: error: register %ymm15 is only available in 64-bit mode
      61 |         case 15: asm("vmovdqa %0, %%ymm15" : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm15
         |                           ^~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:59:15: error: register %ymm13 is only available in 64-bit mode
      59 |         case 13: asm("vmovdqa %0, %%ymm13" : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm13
         |                           ^~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:56:15: error: register %ymm10 is only available in 64-bit mode
      56 |         case 10: asm("vmovdqa %0, %%ymm10" : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm10
         |                           ^~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
>> arch/x86/kvm/fpu.h:54:15: error: register %ymm8 is only available in 64-bit mode
      54 |         case 8:  asm("vmovdqa %0, %%ymm8"  : : "m"(*data)); break;
         |                      ^
   <inline asm>:1:20: note: instantiated into assembly here
       1 |         vmovdqa 32(%esi), %ymm8
         |                           ^~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:37:15: error: register %ymm14 is only available in 64-bit mode
      37 |         case 14: asm("vmovdqa %%ymm14, %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm14, 32(%esi)
         |                 ^~~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:34:15: error: register %ymm11 is only available in 64-bit mode
      34 |         case 11: asm("vmovdqa %%ymm11, %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm11, 32(%esi)
         |                 ^~~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:35:15: error: register %ymm12 is only available in 64-bit mode
      35 |         case 12: asm("vmovdqa %%ymm12, %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm12, 32(%esi)
         |                 ^~~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:32:15: error: register %ymm9 is only available in 64-bit mode
      32 |         case 9:  asm("vmovdqa %%ymm9,  %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm9,  32(%esi)
         |                 ^~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:38:15: error: register %ymm15 is only available in 64-bit mode
      38 |         case 15: asm("vmovdqa %%ymm15, %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm15, 32(%esi)
         |                 ^~~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:36:15: error: register %ymm13 is only available in 64-bit mode
      36 |         case 13: asm("vmovdqa %%ymm13, %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm13, 32(%esi)
         |                 ^~~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:33:15: error: register %ymm10 is only available in 64-bit mode
      33 |         case 10: asm("vmovdqa %%ymm10, %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm10, 32(%esi)
         |                 ^~~~~~~
   In file included from arch/x86/kvm/emulate.c:24:
   In file included from arch/x86/kvm/kvm_emulate.h:16:
   arch/x86/kvm/fpu.h:31:15: error: register %ymm8 is only available in 64-bit mode
      31 |         case 8:  asm("vmovdqa %%ymm8,  %0" : "=m"(*data)); break;
         |                      ^
   <inline asm>:1:10: note: instantiated into assembly here
       1 |         vmovdqa %ymm8,  32(%esi)
         |                 ^~~~~~
   16 errors generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for I2C_K1
   Depends on [n]: I2C [=y] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && OF [=n]
   Selected by [m]:
   - MFD_SPACEMIT_P1 [=m] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && I2C [=y]


vim +60 arch/x86/kvm/fpu.h

    42	
    43	static inline void _kvm_write_avx_reg(int reg, const avx256_t *data)
    44	{
    45		switch (reg) {
    46		case 0:  asm("vmovdqa %0, %%ymm0"  : : "m"(*data)); break;
    47		case 1:  asm("vmovdqa %0, %%ymm1"  : : "m"(*data)); break;
    48		case 2:  asm("vmovdqa %0, %%ymm2"  : : "m"(*data)); break;
    49		case 3:  asm("vmovdqa %0, %%ymm3"  : : "m"(*data)); break;
    50		case 4:  asm("vmovdqa %0, %%ymm4"  : : "m"(*data)); break;
    51		case 5:  asm("vmovdqa %0, %%ymm5"  : : "m"(*data)); break;
    52		case 6:  asm("vmovdqa %0, %%ymm6"  : : "m"(*data)); break;
    53		case 7:  asm("vmovdqa %0, %%ymm7"  : : "m"(*data)); break;
  > 54		case 8:  asm("vmovdqa %0, %%ymm8"  : : "m"(*data)); break;
  > 55		case 9:  asm("vmovdqa %0, %%ymm9"  : : "m"(*data)); break;
  > 56		case 10: asm("vmovdqa %0, %%ymm10" : : "m"(*data)); break;
  > 57		case 11: asm("vmovdqa %0, %%ymm11" : : "m"(*data)); break;
  > 58		case 12: asm("vmovdqa %0, %%ymm12" : : "m"(*data)); break;
  > 59		case 13: asm("vmovdqa %0, %%ymm13" : : "m"(*data)); break;
  > 60		case 14: asm("vmovdqa %0, %%ymm14" : : "m"(*data)); break;
  > 61		case 15: asm("vmovdqa %0, %%ymm15" : : "m"(*data)); break;
    62		default: BUG();
    63		}
    64	}
    65	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

