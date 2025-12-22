Return-Path: <kvm+bounces-66528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 859D0CD7761
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 00:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C55BD3001BDF
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 23:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FC233064E;
	Mon, 22 Dec 2025 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OOPDF14V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F832EC55D;
	Mon, 22 Dec 2025 23:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766446673; cv=none; b=fB0Qlfl72FG4sbs9SU5zrBr/LXDo9EvA6Bjg94WLuQ7m7Q52vHW5HST6whTpGiZzIeaI3GzkihtugbPqiODn6Ofsnq//apxr0HeKzOQCl9J4wYDYW1I/HWvnqNJtilEFenCX2VPZ9OsXn0NMRmBgG30g+W2JYiFcvwtloPDWP8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766446673; c=relaxed/simple;
	bh=GTTxBXThMiBVh7rRCqGTTA5RCCI7spzskoPCS18amCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUzzjHZYaJbBaF5l5bEy1PGN67AXIKu2cHf8m0B5GdvMIywifjvBrKg1YS7h8T5aRfOmjM3yH/GCqwh1jimy0Xxs60osGRi5Kz6e6M9ItUuOxaQEd10mxgFa693lGoDhUtRuqtZn+EWNfmI7MC8pt6ifnrfdGD2y9m7DuiFKj6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OOPDF14V; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766446672; x=1797982672;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GTTxBXThMiBVh7rRCqGTTA5RCCI7spzskoPCS18amCc=;
  b=OOPDF14Vurc7xgIn/gTobc7xGBDqjWPrCZqhWGuwXSF8w76RKOqusOFH
   iPCF4OgTXazHasiUjf1h9Eg3XeKYzb4etgoR/iqJtrYKA4t4WiFvTG4iS
   I+gd0RmZpfnc9ApM9zSNImSTuw2XGbpUIQPGrHyiWYpJzMURGBpITIkzA
   aS6fGegubtScGJ4MXN50PfdYsPGwQr/M0NeCb8MDubUZUVHtrIghUkIb7
   RGhS70pb1jqgaBE/EtULR8dhNFZQGu0bO7HCO2F9NvLBd8iEvFVO0r4+2
   Bg6Uajji4clxsxDHgx4Cl+9MYN7o+p5yuQFn/6/bQlqRfjNzd6qKIUgY3
   A==;
X-CSE-ConnectionGUID: +o+7y1YAR3KDqR/8WiNwsA==
X-CSE-MsgGUID: P9q4jd92TZmxQai3peAWwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="68285664"
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="68285664"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 15:37:48 -0800
X-CSE-ConnectionGUID: POAPZcI2RCufB4ctO2x9QQ==
X-CSE-MsgGUID: Cike9Nj7R1aVw0ldq9KVzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="199945999"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 22 Dec 2025 15:37:44 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXpTC-000000001Dz-09Wj;
	Mon, 22 Dec 2025 23:37:42 +0000
Date: Tue, 23 Dec 2025 07:36:43 +0800
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
Subject: Re: [PATCH v2 4/9] sched/fair: Add penalty calculation and
 application logic
Message-ID: <202512230746.EpT2QbVU-lkp@intel.com>
References: <20251219035334.39790-5-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219035334.39790-5-kernellwp@gmail.com>

Hi Wanpeng,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next tip/sched/core peterz-queue/sched/core tip/master linus/master v6.19-rc2 next-20251219]
[cannot apply to kvm/linux-next tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wanpeng-Li/sched-fair-Add-rate-limiting-and-validation-helpers/20251219-125353
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251219035334.39790-5-kernellwp%40gmail.com
patch subject: [PATCH v2 4/9] sched/fair: Add penalty calculation and application logic
config: openrisc-randconfig-r122-20251221 (https://download.01.org/0day-ci/archive/20251223/202512230746.EpT2QbVU-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512230746.EpT2QbVU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512230746.EpT2QbVU-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   kernel/sched/fair.c:1158:49: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct task_struct *running @@     got struct task_struct [noderef] __rcu *curr @@
   kernel/sched/fair.c:1158:49: sparse:     expected struct task_struct *running
   kernel/sched/fair.c:1158:49: sparse:     got struct task_struct [noderef] __rcu *curr
   kernel/sched/fair.c:1194:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct sched_entity *se @@     got struct sched_entity [noderef] __rcu * @@
   kernel/sched/fair.c:1194:33: sparse:     expected struct sched_entity *se
   kernel/sched/fair.c:1194:33: sparse:     got struct sched_entity [noderef] __rcu *
   kernel/sched/fair.c:1250:34: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct sched_entity const *se @@     got struct sched_entity [noderef] __rcu * @@
   kernel/sched/fair.c:1250:34: sparse:     expected struct sched_entity const *se
   kernel/sched/fair.c:1250:34: sparse:     got struct sched_entity [noderef] __rcu *
   kernel/sched/fair.c:13176:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:13176:9: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/fair.c:13176:9: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:8354:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:8354:20: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/fair.c:8354:20: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:8558:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] tmp @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:8558:9: sparse:     expected struct sched_domain *[assigned] tmp
   kernel/sched/fair.c:8558:9: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:8757:39: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct task_struct *donor @@     got struct task_struct [noderef] __rcu *donor @@
   kernel/sched/fair.c:8757:39: sparse:     expected struct task_struct *donor
   kernel/sched/fair.c:8757:39: sparse:     got struct task_struct [noderef] __rcu *donor
   kernel/sched/fair.c:8784:37: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *tsk @@     got struct task_struct [noderef] __rcu *curr @@
   kernel/sched/fair.c:8784:37: sparse:     expected struct task_struct *tsk
   kernel/sched/fair.c:8784:37: sparse:     got struct task_struct [noderef] __rcu *curr
   kernel/sched/fair.c:9089:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct *p_yielding @@     got struct task_struct [noderef] __rcu *donor @@
   kernel/sched/fair.c:9089:20: sparse:     expected struct task_struct *p_yielding
   kernel/sched/fair.c:9089:20: sparse:     got struct task_struct [noderef] __rcu *donor
>> kernel/sched/fair.c:9150:44: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct task_struct *p_yielding @@     got struct task_struct [noderef] __rcu *donor @@
   kernel/sched/fair.c:9150:44: sparse:     expected struct task_struct *p_yielding
   kernel/sched/fair.c:9150:44: sparse:     got struct task_struct [noderef] __rcu *donor
   kernel/sched/fair.c:9295:38: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct task_struct *curr @@     got struct task_struct [noderef] __rcu *donor @@
   kernel/sched/fair.c:9295:38: sparse:     expected struct task_struct *curr
   kernel/sched/fair.c:9295:38: sparse:     got struct task_struct [noderef] __rcu *donor
   kernel/sched/fair.c:10331:40: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *child @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/fair.c:10331:40: sparse:     expected struct sched_domain *child
   kernel/sched/fair.c:10331:40: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/fair.c:10959:22: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/fair.c:10959:22: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/fair.c:10959:22: sparse:    struct task_struct *
   kernel/sched/fair.c:12431:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:12431:9: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/fair.c:12431:9: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:12069:44: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *sd_parent @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:12069:44: sparse:     expected struct sched_domain *sd_parent
   kernel/sched/fair.c:12069:44: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:12544:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:12544:9: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/fair.c:12544:9: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:6688:35: sparse: sparse: marked inline, but without a definition
   kernel/sched/fair.c: note: in included file:
   kernel/sched/sched.h:2647:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/sched.h:2647:9: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/sched.h:2647:9: sparse:    struct task_struct *
   kernel/sched/sched.h:2314:26: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct *
   kernel/sched/sched.h:2303:25: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/sched.h:2303:25: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/sched.h:2303:25: sparse:    struct task_struct *
   kernel/sched/sched.h:2314:26: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct *
   kernel/sched/sched.h:2314:26: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct *
   kernel/sched/sched.h:2314:26: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/sched.h:2314:26: sparse:    struct task_struct *

vim +9150 kernel/sched/fair.c

  9134	
  9135	/*
  9136	 * Apply debounce for reverse yield pairs to reduce ping-pong effects.
  9137	 * When A yields to B, then B yields back to A within ~600us, downscale
  9138	 * the penalty to prevent oscillation.
  9139	 *
  9140	 * The 600us threshold is chosen to be:
  9141	 * - Long enough to catch rapid back-and-forth yields
  9142	 * - Short enough to not affect legitimate sequential yields
  9143	 *
  9144	 * Returns the (possibly reduced) penalty value.
  9145	 */
  9146	static u64 yield_deboost_apply_debounce(struct rq *rq, struct task_struct *p_target,
  9147						u64 penalty, u64 need, u64 gran)
  9148	{
  9149		u64 now = rq_clock(rq);
> 9150		struct task_struct *p_yielding = rq->donor;
  9151		pid_t src_pid, dst_pid;
  9152		pid_t last_src, last_dst;
  9153		u64 last_ns;
  9154	
  9155		if (!p_yielding || !p_target)
  9156			return penalty;
  9157	
  9158		src_pid = p_yielding->pid;
  9159		dst_pid = p_target->pid;
  9160		last_src = rq->yield_deboost_last_src_pid;
  9161		last_dst = rq->yield_deboost_last_dst_pid;
  9162		last_ns = rq->yield_deboost_last_pair_time_ns;
  9163	
  9164		/* Detect reverse pair: previous was target->source */
  9165		if (last_src == dst_pid && last_dst == src_pid &&
  9166		    (now - last_ns) <= 600 * NSEC_PER_USEC) {
  9167			u64 alt = max(need, gran);
  9168	
  9169			if (penalty > alt)
  9170				penalty = alt;
  9171		}
  9172	
  9173		/* Update tracking state */
  9174		rq->yield_deboost_last_src_pid = src_pid;
  9175		rq->yield_deboost_last_dst_pid = dst_pid;
  9176		rq->yield_deboost_last_pair_time_ns = now;
  9177	
  9178		return penalty;
  9179	}
  9180	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

