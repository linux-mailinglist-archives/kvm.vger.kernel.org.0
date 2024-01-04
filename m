Return-Path: <kvm+bounces-5607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5330823A5C
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 02:52:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6918D1F2625C
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 01:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D0D46B3;
	Thu,  4 Jan 2024 01:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fCF1RXVn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37901FA1;
	Thu,  4 Jan 2024 01:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704333139; x=1735869139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x87hXyg1vD9hfcAbz58oRkGr1NdcwNmNwpY5ZaL9VpU=;
  b=fCF1RXVnPwtk8vwrtIn9FjP3JzNuWOSZLYeCKDyTfdGYyjw83/J9wDk6
   l++vR7uhTTtCyLo3oTFRQEpFhR9hvcgiQvPUO6GhxPd/bDZkvaWkjcNjH
   +/qZd2VPDZivsRM87JVRn7tTFRLenwJ4cehCcoIbKdgq1EIOdfXQ8fR/I
   pdvdkgb0JoaRJmmH/os2mvov6Z/iLnXlry0m0O4pNy2MFDZz/EAbBmjr+
   2IkRZHIgaoTl5Bc9pxVNBteTYsIHS6TXKyaH8OCJZKkm1+jPelNVu4Z7I
   9IS8dBNjUepGJT7VQ+1Fc5zE4LIjjlIa13Bg1z0PtMUpAnIF1WLlLktPC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="4443211"
X-IronPort-AV: E=Sophos;i="6.04,329,1695711600"; 
   d="scan'208";a="4443211"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 17:52:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10942"; a="783692444"
X-IronPort-AV: E=Sophos;i="6.04,329,1695711600"; 
   d="scan'208";a="783692444"
Received: from lkp-server02.sh.intel.com (HELO b07ab15da5fe) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 03 Jan 2024 17:52:15 -0800
Received: from kbuild by b07ab15da5fe with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rLCu5-000MmM-0C;
	Thu, 04 Jan 2024 01:52:13 +0000
Date: Thu, 4 Jan 2024 09:51:30 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH 3/5] LoongArch/smp: Refine ipi ops on LoongArch platform
Message-ID: <202401040952.1JdPfC85-lkp@intel.com>
References: <20240103071615.3422264-4-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103071615.3422264-4-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 610a9b8f49fbcf1100716370d3b5f6f884a2835a]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-hypercall-instruction-emulation-support/20240103-151946
base:   610a9b8f49fbcf1100716370d3b5f6f884a2835a
patch link:    https://lore.kernel.org/r/20240103071615.3422264-4-maobibo%40loongson.cn
patch subject: [PATCH 3/5] LoongArch/smp: Refine ipi ops on LoongArch platform
config: loongarch-randconfig-r131-20240103 (https://download.01.org/0day-ci/archive/20240104/202401040952.1JdPfC85-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20240104/202401040952.1JdPfC85-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401040952.1JdPfC85-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/loongarch/kernel/smp.c:192:73: sparse: sparse: incorrect type in argument 4 (different address spaces) @@     expected void [noderef] __percpu *percpu_dev_id @@     got int * @@
   arch/loongarch/kernel/smp.c:192:73: sparse:     expected void [noderef] __percpu *percpu_dev_id
   arch/loongarch/kernel/smp.c:192:73: sparse:     got int *
   arch/loongarch/kernel/smp.c: note: in included file (through arch/loongarch/include/asm/loongarch.h, arch/loongarch/include/asm/cpu-info.h, ...):
   ../lib/gcc/loongarch64-linux/13.2.0/include/larchintrin.h:332:3: sparse: sparse: undefined identifier '__builtin_loongarch_iocsrwr_d'
   ../lib/gcc/loongarch64-linux/13.2.0/include/larchintrin.h:284:25: sparse: sparse: undefined identifier '__builtin_loongarch_iocsrrd_w'
   ../lib/gcc/loongarch64-linux/13.2.0/include/larchintrin.h:284:11: sparse: sparse: cast from unknown type
   ../lib/gcc/loongarch64-linux/13.2.0/include/larchintrin.h:322:3: sparse: sparse: undefined identifier '__builtin_loongarch_iocsrwr_w'
   arch/loongarch/kernel/smp.c: note: in included file (through arch/loongarch/include/asm/cpu-info.h, arch/loongarch/include/asm/processor.h, ...):
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: undefined identifier '__builtin_loongarch_csrrd_w'
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: cast from unknown type
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: undefined identifier '__builtin_loongarch_csrwr_w'
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: cast from unknown type
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: undefined identifier '__builtin_loongarch_csrrd_w'
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: cast from unknown type
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: undefined identifier '__builtin_loongarch_csrwr_w'
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: cast from unknown type
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: undefined identifier '__builtin_loongarch_csrrd_w'
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: cast from unknown type
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: undefined identifier '__builtin_loongarch_csrwr_w'
   arch/loongarch/include/asm/loongarch.h:1260:1: sparse: sparse: cast from unknown type
   arch/loongarch/kernel/smp.c: note: in included file (through arch/loongarch/include/asm/loongarch.h, arch/loongarch/include/asm/cpu-info.h, ...):
   ../lib/gcc/loongarch64-linux/13.2.0/include/larchintrin.h:294:30: sparse: sparse: undefined identifier '__builtin_loongarch_iocsrrd_d'
   ../lib/gcc/loongarch64-linux/13.2.0/include/larchintrin.h:294:11: sparse: sparse: cast from unknown type
   arch/loongarch/kernel/smp.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/mmzone.h, ...):
   arch/loongarch/include/asm/percpu.h:30:9: sparse: sparse: undefined identifier '__builtin_loongarch_csrwr_d'
   arch/loongarch/include/asm/percpu.h:30:9: sparse: sparse: cast from unknown type
   arch/loongarch/include/asm/percpu.h:30:9: sparse: sparse: cast from unknown type

vim +192 arch/loongarch/kernel/smp.c

   181	
   182	static void loongson_ipi_init(void)
   183	{
   184		int r, ipi_irq;
   185		static int ipi_dummy_dev;
   186	
   187		ipi_irq = get_percpu_irq(INT_IPI);
   188		if (ipi_irq < 0)
   189			panic("IPI IRQ mapping failed\n");
   190	
   191		irq_set_percpu_devid(ipi_irq);
 > 192		r = request_percpu_irq(ipi_irq, loongson_ipi_interrupt, "IPI", &ipi_dummy_dev);
   193		if (r < 0)
   194			panic("IPI IRQ request failed\n");
   195	}
   196	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

