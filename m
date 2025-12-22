Return-Path: <kvm+bounces-66463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA599CD4D7A
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 08:07:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3E7D3011748
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 07:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA39930648C;
	Mon, 22 Dec 2025 07:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eb5B2t3e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3FBE5E;
	Mon, 22 Dec 2025 07:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766387238; cv=none; b=L92dcH80fSwcu/7OdDVNGsEwUzMAIje3fk123a6ygjw0VHubV2+DYcDyfbJkdZGDHkGA+TMzsXHT7gsCJY+QGcM2/Hpmo9AGG1jOtU6B6Ru6oxMvLZyR6ztW0Or51twgL2nbygouvx2r57BHJFuPlmNnS3o2OhIdo1w+Z8lvzAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766387238; c=relaxed/simple;
	bh=xquC/ZtLPEmL6feVlQbJymRtSyA+/fsIowL3msNYlxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2lZ2GJQBz+cLQR3nWRZg8noq7pchXHeMHgn9Txx9d9se+ppakehg0oK1clHgWsf9IdBtqdTWwlZvoWGghyEx5ZK/ZhkXKI0ACOpIl8bb8sEtVTK7mC6R9O7BGn+4dPu+yP62gdirBXgTTDJNTrWj89HbZ+h2s/xr/dw/rWfiA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eb5B2t3e; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766387237; x=1797923237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xquC/ZtLPEmL6feVlQbJymRtSyA+/fsIowL3msNYlxc=;
  b=eb5B2t3e29g168SoW8TVqM2xjIywVZnLjDCJQ+LXN0GQZrIJbiZFrO0v
   A9xVNrRi57SDYHaTNKvLA9pODdV4yUdg0XQrwWKCmlT5ZWx3MdjWg4iZi
   uQFrzqFGoaMDnxaUK3sa58h1L17fcEReovmIgvuubWxwHTbqRlJnu3pv4
   nsvDpu78XWAiXR/Xqha9PJUuVLrby2sz4LDy2PVLKGakE+u2gjCzRruRC
   EqvU2+anyZtccdP/qgnh0MgKkFK6fAMXVe1nKF0a9LW9ZijzcJbuXAHys
   z+2bUSbIg63aLxRi2f3MzgbC7NFQ98y7ZI1IlrBq266nZbSX5rpE6r6Vs
   g==;
X-CSE-ConnectionGUID: hf/nxm+iQPupGC0uneGCQg==
X-CSE-MsgGUID: ZPDDX0o8T6awNHO1m2zmqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="85824977"
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="85824977"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 23:07:17 -0800
X-CSE-ConnectionGUID: kENd7rnKRTWi/HU71dZVPg==
X-CSE-MsgGUID: HfGPHM63S0eQdZxYvFHHRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,167,1763452800"; 
   d="scan'208";a="199098955"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 21 Dec 2025 23:07:13 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXa0Y-000000000Bd-12qq;
	Mon, 22 Dec 2025 07:07:07 +0000
Date: Mon, 22 Dec 2025 15:06:11 +0800
From: kernel test robot <lkp@intel.com>
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v2 5/9] sched/fair: Wire up yield deboost in
 yield_to_task_fair()
Message-ID: <202512221456.139kcj5R-lkp@intel.com>
References: <20251219035334.39790-6-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219035334.39790-6-kernellwp@gmail.com>

Hi Wanpeng,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next tip/sched/core peterz-queue/sched/core tip/master linus/master v6.19-rc2 next-20251219]
[cannot apply to kvm/linux-next tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wanpeng-Li/sched-fair-Add-rate-limiting-and-validation-helpers/20251219-125353
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251219035334.39790-6-kernellwp%40gmail.com
patch subject: [PATCH v2 5/9] sched/fair: Wire up yield deboost in yield_to_task_fair()
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251222/202512221456.139kcj5R-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512221456.139kcj5R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512221456.139kcj5R-lkp@intel.com/

All errors (new ones prefixed by >>):

   m68k-linux-ld: kernel/sched/fair.o: in function `yield_deboost_calculate_penalty':
>> fair.c:(.text+0x278c): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

