Return-Path: <kvm+bounces-26087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FB59708D5
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 18:57:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 786031C20CA2
	for <lists+kvm@lfdr.de>; Sun,  8 Sep 2024 16:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F57175D59;
	Sun,  8 Sep 2024 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUgEmSEz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DDB2535D8;
	Sun,  8 Sep 2024 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725814652; cv=none; b=bZbiaCaHlPFcrASVm+RY8m/9lYmSupCZfDEtVXFRlIa50VaEjX7ej+VgNG6OOinuWfWnXQYErPfIjSEqCQR4RLfx+IhsOzJUTY1togKFnK/saS6StknC5hBQCPyvvqO2NeAYaxq+V7667V8U3BoIUGhFx+LaksPEzGGb5OxJAV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725814652; c=relaxed/simple;
	bh=gFpZpGEkhVcZmvpYlYMlw1TLTYXTJ+SJ6Et27zpaRkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EnwjEeFg4742/6sxw5zNC7+oaZ/QPx5JOy+qulJVodvNjBoJtxjvzjHBYRQVGDgOmO4eifqr9FfevXHWBhYcf8TM0XHV74zgZko1HBZzxNoI9LEbBhcpmrXEmr+8BITAbWVAfuXmstTTpKjRaYpvj7EMe22yE4PCjIbq9vax+yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUgEmSEz; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725814650; x=1757350650;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gFpZpGEkhVcZmvpYlYMlw1TLTYXTJ+SJ6Et27zpaRkE=;
  b=aUgEmSEzJE4GXILroVxNErvHC+02J+WAcGLKHwNdVOWyoWvkEh4qCwza
   GRvWXgsQVZbJDt3rG7mq+1/Hq2A4XzfXqEH3BWXyLVBJVK1nousJZbY/2
   02zYcFNJn90FGMOyKg4mpepIjzG2HHExQ3JpZLdfdrsHCenyk4SSe4+D3
   GFQQMHBzpAyoZAMvaXRetaGzVmEc+C6bmhZA/6bGyVHykiK0rSkjj65Hm
   kTrQAJd8LTJcmy8vekeDobdlmFT1LtL30M9AFIc6F3DZwUVnJaz76IF69
   55Asqf3CEEgx2TwEh6vHWEKCx0L/+aEsxcVJ7Koqzc4ZfRZDpx/ZU2hM/
   w==;
X-CSE-ConnectionGUID: gBceiOG9SmWjic5eILwIVA==
X-CSE-MsgGUID: hqzjjl4xSx2Mj37XcBBL3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="24006791"
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="24006791"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 09:57:29 -0700
X-CSE-ConnectionGUID: /aVMb7qWTuSucpJIB32DwA==
X-CSE-MsgGUID: 0EMBbu5/TJGp7yLL1NeXfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,212,1719903600"; 
   d="scan'208";a="67173237"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 08 Sep 2024 09:57:26 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1snLE3-000Dk7-2l;
	Sun, 08 Sep 2024 16:57:23 +0000
Date: Mon, 9 Sep 2024 00:56:34 +0800
From: kernel test robot <lkp@intel.com>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: oe-kbuild-all@lists.linux.dev, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-mips@vger.kernel.org, kvm@vger.kernel.org,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 4/5] LoongArch: Extract IOCSR definitions to standalone
 header
Message-ID: <202409090054.D3vEaTqr-lkp@intel.com>
References: <20240907-iocsr-v1-4-0c99b3334444@flygoat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240907-iocsr-v1-4-0c99b3334444@flygoat.com>

Hi Jiaxun,

kernel test robot noticed the following build errors:

[auto build test ERROR on 9aaeb87ce1e966169a57f53a02ba05b30880ffb8]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiaxun-Yang/LoongArch-Rename-cpu_has_csr-as-cpu_has_iocsr/20240907-181959
base:   9aaeb87ce1e966169a57f53a02ba05b30880ffb8
patch link:    https://lore.kernel.org/r/20240907-iocsr-v1-4-0c99b3334444%40flygoat.com
patch subject: [PATCH 4/5] LoongArch: Extract IOCSR definitions to standalone header
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20240909/202409090054.D3vEaTqr-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240909/202409090054.D3vEaTqr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409090054.D3vEaTqr-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/loongarch/include/asm/cpu-info.h:11,
                    from arch/loongarch/include/asm/processor.h:13,
                    from arch/loongarch/include/asm/thread_info.h:15,
                    from include/linux/thread_info.h:60,
                    from include/asm-generic/current.h:6,
                    from ./arch/loongarch/include/generated/asm/current.h:1,
                    from include/linux/mutex.h:14,
                    from include/linux/notifier.h:14,
                    from include/linux/clk.h:14,
                    from include/linux/cpufreq.h:11,
                    from drivers/cpufreq/loongson3_cpufreq.c:10:
   drivers/cpufreq/loongson3_cpufreq.c: In function 'do_service_request':
>> drivers/cpufreq/loongson3_cpufreq.c:185:35: error: 'LOONGSON_IOCSR_SMCMBX' undeclared (first use in this function)
     185 |         last.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
         |                                   ^~~~~~~~~~~~~~~~~~~~~
   drivers/cpufreq/loongson3_cpufreq.c:185:22: note: in expansion of macro 'iocsr_read32'
     185 |         last.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
         |                      ^~~~~~~~~~~~
   drivers/cpufreq/loongson3_cpufreq.c:185:35: note: each undeclared identifier is reported only once for each function it appears in
     185 |         last.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
         |                                   ^~~~~~~~~~~~~~~~~~~~~
   drivers/cpufreq/loongson3_cpufreq.c:185:22: note: in expansion of macro 'iocsr_read32'
     185 |         last.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
         |                      ^~~~~~~~~~~~
>> drivers/cpufreq/loongson3_cpufreq.c:199:36: error: 'LOONGSON_IOCSR_MISC_FUNC' undeclared (first use in this function)
     199 |         iocsr_write32(iocsr_read32(LOONGSON_IOCSR_MISC_FUNC) | IOCSR_MISC_FUNC_SOFT_INT,
         |                                    ^~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/include/asm/loongarch.h:187:45: note: in definition of macro 'iocsr_write32'
     187 | #define iocsr_write32(val, reg) __iocsrwr_w(val, reg)
         |                                             ^~~
   drivers/cpufreq/loongson3_cpufreq.c:199:23: note: in expansion of macro 'iocsr_read32'
     199 |         iocsr_write32(iocsr_read32(LOONGSON_IOCSR_MISC_FUNC) | IOCSR_MISC_FUNC_SOFT_INT,
         |                       ^~~~~~~~~~~~
>> drivers/cpufreq/loongson3_cpufreq.c:199:64: error: 'IOCSR_MISC_FUNC_SOFT_INT' undeclared (first use in this function)
     199 |         iocsr_write32(iocsr_read32(LOONGSON_IOCSR_MISC_FUNC) | IOCSR_MISC_FUNC_SOFT_INT,
         |                                                                ^~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/include/asm/loongarch.h:187:45: note: in definition of macro 'iocsr_write32'
     187 | #define iocsr_write32(val, reg) __iocsrwr_w(val, reg)
         |                                             ^~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OMAP2PLUS_MBOX
   Depends on [n]: MAILBOX [=y] && (ARCH_OMAP2PLUS || ARCH_K3)
   Selected by [m]:
   - TI_K3_M4_REMOTEPROC [=m] && REMOTEPROC [=y] && (ARCH_K3 || COMPILE_TEST [=y])


vim +/LOONGSON_IOCSR_SMCMBX +185 drivers/cpufreq/loongson3_cpufreq.c

   175	
   176	static inline int do_service_request(u32 id, u32 info, u32 cmd, u32 val, u32 extra)
   177	{
   178		int retries;
   179		unsigned int cpu = raw_smp_processor_id();
   180		unsigned int package = cpu_data[cpu].package;
   181		union smc_message msg, last;
   182	
   183		mutex_lock(&cpufreq_mutex[package]);
   184	
 > 185		last.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
   186		if (!last.complete) {
   187			mutex_unlock(&cpufreq_mutex[package]);
   188			return -EPERM;
   189		}
   190	
   191		msg.id		= id;
   192		msg.info	= info;
   193		msg.cmd		= cmd;
   194		msg.val		= val;
   195		msg.extra	= extra;
   196		msg.complete	= 0;
   197	
   198		iocsr_write32(msg.value, LOONGSON_IOCSR_SMCMBX);
 > 199		iocsr_write32(iocsr_read32(LOONGSON_IOCSR_MISC_FUNC) | IOCSR_MISC_FUNC_SOFT_INT,
   200			      LOONGSON_IOCSR_MISC_FUNC);
   201	
   202		for (retries = 0; retries < 10000; retries++) {
   203			msg.value = iocsr_read32(LOONGSON_IOCSR_SMCMBX);
   204			if (msg.complete)
   205				break;
   206	
   207			usleep_range(8, 12);
   208		}
   209	
   210		if (!msg.complete || msg.cmd != CMD_OK) {
   211			mutex_unlock(&cpufreq_mutex[package]);
   212			return -EPERM;
   213		}
   214	
   215		mutex_unlock(&cpufreq_mutex[package]);
   216	
   217		return msg.val;
   218	}
   219	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

