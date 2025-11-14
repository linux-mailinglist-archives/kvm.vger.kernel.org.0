Return-Path: <kvm+bounces-63250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B3EDC5F2F5
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 21:11:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 611EF35736E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C53034572F;
	Fri, 14 Nov 2025 20:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RpK0Oy81"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F7A328623;
	Fri, 14 Nov 2025 20:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763151090; cv=none; b=PzZ/jNuMQrxfHj/fFkQ7hszAGD7d3TpSxI8fHTEEF5cjCkw+dUDThfEIZ0TVDC7GvqcmKbv1ssgwXpvv0wSgd+4HOjDKPi4WNxdEZpOAxw0P1v23/dv7aWNGiy+OqpXW+7eyp+0y5Sb42uKAKyGOJ8oHoEN+APFqdRKD5eUZP1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763151090; c=relaxed/simple;
	bh=4kMylI9i1P9ilzO8r3dD+sJCeetsnNpzoFvT260uf2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbRhvsRqcPdOy5gjIXpnaVoln6CF4mvlck8yBaAJq3qwDqox5ihmb2Cm9V66hba6kRUb8rvIgD95obAwM1coUDQlagsjhVTOlNsaoxGxQCE7Q+msxmWNanU9u1Jy2ep5ipLomE8DQCEg+h8pheSRq4tFiszaH7dmHQc2nT22vfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RpK0Oy81; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763151086; x=1794687086;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4kMylI9i1P9ilzO8r3dD+sJCeetsnNpzoFvT260uf2A=;
  b=RpK0Oy81QPiyriqcmsRqGahJlPB6o1dNBXaYDJypqQXkI3SyaNK1VIHr
   ewpdk/Bs6TucBJuPT739rt7xcjWE1OBMv7NSfKP5tjnCA9QBty72gAn9A
   T7bQlwTJzJEOSIluiXM/suLdMV+UKQejt3RG86wWAlPnO4uaAIPdScKY9
   8/jc/ztf23NClioNzEm64nCgX1KfHCul7diPLg0D8dXZmnOyXR/GyGp5Y
   l8QYYsozwHFeqh8NrQjSdNy+fwcSv93uEa8Zki09qlYMMu8+7xb+h4tTu
   EnORQNz/6HKacmEUHeRfdAXrcZQLUEa2Dx61tqBsMi7q/Xs/wmXCM+v09
   Q==;
X-CSE-ConnectionGUID: cy8AH/1aSC+2OWRF+pueWQ==
X-CSE-MsgGUID: am1zKbgbQganvVwdAiC8KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11613"; a="65285347"
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="65285347"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 12:11:26 -0800
X-CSE-ConnectionGUID: R9YEZq5USZqBnxyeRgq+eQ==
X-CSE-MsgGUID: IcG1PywYQiid6VqFXnWt1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,305,1754982000"; 
   d="scan'208";a="220502824"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 14 Nov 2025 12:11:24 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vK08g-00078t-0Y;
	Fri, 14 Nov 2025 20:11:22 +0000
Date: Sat, 15 Nov 2025 04:10:44 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: Re: [PATCH 07/10] KVM: emulate: add AVX support to register fetch
 and writeback
Message-ID: <202511150213.HaLLVfkt-lkp@intel.com>
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
config: i386-buildonly-randconfig-006-20251114 (https://download.01.org/0day-ci/archive/20251115/202511150213.HaLLVfkt-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251115/202511150213.HaLLVfkt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511150213.HaLLVfkt-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/fpu.h: Assembler messages:
>> arch/x86/kvm/fpu.h:37: Error: bad register name `%ymm14'
>> arch/x86/kvm/fpu.h:36: Error: bad register name `%ymm13'
>> arch/x86/kvm/fpu.h:38: Error: bad register name `%ymm15'
>> arch/x86/kvm/fpu.h:35: Error: bad register name `%ymm12'
>> arch/x86/kvm/fpu.h:34: Error: bad register name `%ymm11'
>> arch/x86/kvm/fpu.h:33: Error: bad register name `%ymm10'
>> arch/x86/kvm/fpu.h:32: Error: bad register name `%ymm9'
>> arch/x86/kvm/fpu.h:31: Error: bad register name `%ymm8'
   arch/x86/kvm/fpu.h:58: Error: bad register name `%ymm12'
   arch/x86/kvm/fpu.h:59: Error: bad register name `%ymm13'
   arch/x86/kvm/fpu.h:54: Error: bad register name `%ymm8'
   arch/x86/kvm/fpu.h:55: Error: bad register name `%ymm9'
   arch/x86/kvm/fpu.h:56: Error: bad register name `%ymm10'
   arch/x86/kvm/fpu.h:57: Error: bad register name `%ymm11'
   arch/x86/kvm/fpu.h:61: Error: bad register name `%ymm15'
   arch/x86/kvm/fpu.h:60: Error: bad register name `%ymm14'

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for I2C_K1
   Depends on [n]: I2C [=y] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && OF [=n]
   Selected by [y]:
   - MFD_SPACEMIT_P1 [=y] && HAS_IOMEM [=y] && (ARCH_SPACEMIT || COMPILE_TEST [=y]) && I2C [=y]


vim +37 arch/x86/kvm/fpu.h

    19	
    20	static inline void _kvm_read_avx_reg(int reg, avx256_t *data)
    21	{
    22		switch (reg) {
    23		case 0:  asm("vmovdqa %%ymm0,  %0" : "=m"(*data)); break;
    24		case 1:  asm("vmovdqa %%ymm1,  %0" : "=m"(*data)); break;
    25		case 2:  asm("vmovdqa %%ymm2,  %0" : "=m"(*data)); break;
    26		case 3:  asm("vmovdqa %%ymm3,  %0" : "=m"(*data)); break;
    27		case 4:  asm("vmovdqa %%ymm4,  %0" : "=m"(*data)); break;
    28		case 5:  asm("vmovdqa %%ymm5,  %0" : "=m"(*data)); break;
    29		case 6:  asm("vmovdqa %%ymm6,  %0" : "=m"(*data)); break;
    30		case 7:  asm("vmovdqa %%ymm7,  %0" : "=m"(*data)); break;
  > 31		case 8:  asm("vmovdqa %%ymm8,  %0" : "=m"(*data)); break;
  > 32		case 9:  asm("vmovdqa %%ymm9,  %0" : "=m"(*data)); break;
  > 33		case 10: asm("vmovdqa %%ymm10, %0" : "=m"(*data)); break;
  > 34		case 11: asm("vmovdqa %%ymm11, %0" : "=m"(*data)); break;
  > 35		case 12: asm("vmovdqa %%ymm12, %0" : "=m"(*data)); break;
  > 36		case 13: asm("vmovdqa %%ymm13, %0" : "=m"(*data)); break;
  > 37		case 14: asm("vmovdqa %%ymm14, %0" : "=m"(*data)); break;
  > 38		case 15: asm("vmovdqa %%ymm15, %0" : "=m"(*data)); break;
    39		default: BUG();
    40		}
    41	}
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

