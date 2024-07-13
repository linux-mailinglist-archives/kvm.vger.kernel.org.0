Return-Path: <kvm+bounces-21603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 719809305A0
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 14:42:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1D971F21D25
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 12:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DF6113210A;
	Sat, 13 Jul 2024 12:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JOFDZF4o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA30B12E1D2;
	Sat, 13 Jul 2024 12:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720874547; cv=none; b=daKAJ/5aAhj/k1k7QgLJOx6SKAVjrZNTy/uyrRZe0TlubZNwpGv+h8IBI3niOfeclI+sr0lu66U/6rCe4hLjdn6IVd8rIiRYcdSmrqDNIZMblmCcGSm3mhlag59HXEz3Sphh0OBo8Y6Yu3Vls1iJnQ7AjmlFNg80+5lMlbwVOk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720874547; c=relaxed/simple;
	bh=RkZOnT6YMC5COcaGvMUt7vuwc+JGYeeX8BB4xirSbk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=unTvdPOBw+Op6I6whae8lLuv1jvbKh1YfPWchGfdHjXVDrKzCyEJ92HD7NFJVup0IB71wz01qUeQ77jHzuBp8lkn/rI52x35Xtu54MgI52Nu4YhvMoItZURPtC/3NcPXMPYV2VRYFXCuA17orYHuiZuXC6DgFzDnqgtnA1nHL+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JOFDZF4o; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720874546; x=1752410546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RkZOnT6YMC5COcaGvMUt7vuwc+JGYeeX8BB4xirSbk4=;
  b=JOFDZF4oz8HFymFV0UBveCHVKrSUYBQ+9pk5G5m490STmjZGiyahF20G
   gr3Qcbva3toRIg4gyzMMEAI7n8lV5u0Rh0sZkISyEbqKtdl00bajKfqmE
   47AGqzafCfN48Va9058CaF8vFip2bXLHkpgZ0/0ROa83UvXd/YlCzUhjO
   +iK2ZD2x79RvvHr/B3TPZytlnBcSxp8J+Dy9XcvCijAIfy7AsaNvcc4rZ
   tW7oGdGtsNy4fBK6ubFkSE1H2Vs20uliBlVrJRH2wdVJs5NOnuImian7m
   haH3CTxD15+qAwLsCmPWKnV9T2Bz7Mrj/U9Qh2VqtRsPiF5KVvphCo2nH
   A==;
X-CSE-ConnectionGUID: u96SDWmxRh6arrziYPd/OA==
X-CSE-MsgGUID: HMJfKbKiSS+oMCIoA8V2wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11131"; a="22126972"
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="22126972"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 05:42:25 -0700
X-CSE-ConnectionGUID: 91LwFNLZRPC3ilSOyFGWNQ==
X-CSE-MsgGUID: OnZ4kMcFTYePvsQ6hEWl0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="49046677"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 13 Jul 2024 05:42:19 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sSc4u-000c4T-2N;
	Sat, 13 Jul 2024 12:42:16 +0000
Date: Sat, 13 Jul 2024 20:41:29 +0800
From: kernel test robot <lkp@intel.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com
Cc: oe-kbuild-all@lists.linux.dev, ravi.bangoria@amd.com, hpa@zytor.com,
	rmk+kernel@armlinux.org.uk, peterz@infradead.org,
	james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
	j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
	michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	santosh.shukla@amd.com, ananth.narayan@amd.com,
	sandipan.das@amd.com, manali.shukla@amd.com, jmattson@google.com
Subject: Re: [PATCH v2 1/4] x86/split_lock: Move Split and Bus lock code to a
 dedicated file
Message-ID: <202407132059.uppmW6rR-lkp@intel.com>
References: <20240712093943.1288-2-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712093943.1288-2-ravi.bangoria@amd.com>

Hi Ravi,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/master]
[also build test ERROR on next-20240712]
[cannot apply to tip/x86/core kvm/queue linus/master tip/auto-latest kvm/linux-next v6.10-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ravi-Bangoria/x86-split_lock-Move-Split-and-Bus-lock-code-to-a-dedicated-file/20240712-175306
base:   tip/master
patch link:    https://lore.kernel.org/r/20240712093943.1288-2-ravi.bangoria%40amd.com
patch subject: [PATCH v2 1/4] x86/split_lock: Move Split and Bus lock code to a dedicated file
config: i386-randconfig-015-20240713 (https://download.01.org/0day-ci/archive/20240713/202407132059.uppmW6rR-lkp@intel.com/config)
compiler: gcc-11 (Ubuntu 11.4.0-4ubuntu1) 11.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240713/202407132059.uppmW6rR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407132059.uppmW6rR-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kernel/cpu/bus_lock.c: In function 'split_lock_warn':
>> arch/x86/kernel/cpu/bus_lock.c:219:21: error: 'struct task_struct' has no member named 'reported_split_lock'
     219 |         if (!current->reported_split_lock)
         |                     ^~
   arch/x86/kernel/cpu/bus_lock.c:222:16: error: 'struct task_struct' has no member named 'reported_split_lock'
     222 |         current->reported_split_lock = 1;
         |                ^~
   arch/x86/kernel/cpu/bus_lock.c: At top level:
   arch/x86/kernel/cpu/bus_lock.c:250:6: error: redefinition of 'handle_guest_split_lock'
     250 | bool handle_guest_split_lock(unsigned long ip)
         |      ^~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/x86/kernel/cpu/bus_lock.c:12:
   arch/x86/include/asm/cpu.h:42:20: note: previous definition of 'handle_guest_split_lock' with type 'bool(long unsigned int)' {aka '_Bool(long unsigned int)'}
      42 | static inline bool handle_guest_split_lock(unsigned long ip)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kernel/cpu/bus_lock.c:292:6: error: redefinition of 'handle_user_split_lock'
     292 | bool handle_user_split_lock(struct pt_regs *regs, long error_code)
         |      ^~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/x86/kernel/cpu/bus_lock.c:12:
   arch/x86/include/asm/cpu.h:37:20: note: previous definition of 'handle_user_split_lock' with type 'bool(struct pt_regs *, long int)' {aka '_Bool(struct pt_regs *, long int)'}
      37 | static inline bool handle_user_split_lock(struct pt_regs *regs, long error_code)
         |                    ^~~~~~~~~~~~~~~~~~~~~~
   arch/x86/kernel/cpu/bus_lock.c:300:6: error: redefinition of 'handle_bus_lock'
     300 | void handle_bus_lock(struct pt_regs *regs)
         |      ^~~~~~~~~~~~~~~
   In file included from arch/x86/kernel/cpu/bus_lock.c:12:
   arch/x86/include/asm/cpu.h:47:20: note: previous definition of 'handle_bus_lock' with type 'void(struct pt_regs *)'
      47 | static inline void handle_bus_lock(struct pt_regs *regs) {}
         |                    ^~~~~~~~~~~~~~~
   arch/x86/kernel/cpu/bus_lock.c:401:13: error: redefinition of 'sld_setup'
     401 | void __init sld_setup(struct cpuinfo_x86 *c)
         |             ^~~~~~~~~
   In file included from arch/x86/kernel/cpu/bus_lock.c:12:
   arch/x86/include/asm/cpu.h:36:27: note: previous definition of 'sld_setup' with type 'void(struct cpuinfo_x86 *)'
      36 | static inline void __init sld_setup(struct cpuinfo_x86 *c) {}
         |                           ^~~~~~~~~


vim +219 arch/x86/kernel/cpu/bus_lock.c

   213	
   214	static void split_lock_warn(unsigned long ip)
   215	{
   216		struct delayed_work *work;
   217		int cpu;
   218	
 > 219		if (!current->reported_split_lock)
   220			pr_warn_ratelimited("#AC: %s/%d took a split_lock trap at address: 0x%lx\n",
   221					    current->comm, current->pid, ip);
   222		current->reported_split_lock = 1;
   223	
   224		if (sysctl_sld_mitigate) {
   225			/*
   226			 * misery factor #1:
   227			 * sleep 10ms before trying to execute split lock.
   228			 */
   229			if (msleep_interruptible(10) > 0)
   230				return;
   231			/*
   232			 * Misery factor #2:
   233			 * only allow one buslocked disabled core at a time.
   234			 */
   235			if (down_interruptible(&buslock_sem) == -EINTR)
   236				return;
   237			work = &sl_reenable_unlock;
   238		} else {
   239			work = &sl_reenable;
   240		}
   241	
   242		cpu = get_cpu();
   243		schedule_delayed_work_on(cpu, work, 2);
   244	
   245		/* Disable split lock detection on this CPU to make progress */
   246		sld_update_msr(false);
   247		put_cpu();
   248	}
   249	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

