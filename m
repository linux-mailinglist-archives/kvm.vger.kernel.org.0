Return-Path: <kvm+bounces-66520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E55C7CD72D4
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 22:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 643D53032707
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 21:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F96533A9C1;
	Mon, 22 Dec 2025 21:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kAcebSPj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DD3327208;
	Mon, 22 Dec 2025 21:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766437992; cv=none; b=FkRO9qshzM2GRDT1LgV0Koa5BmhIPE25YrtOawam+yU5EoVT7U8O/HQhmbZ0n16GbGaoNxgFBgZJS+4glI9bj5dRrLgGjZq6HeC8RVZiqr1dNQP1u7gZc2sk39XW5KXLZyg0KI8d9MLcHNNWYUopbgXDftLwg4cqAx+yD610FFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766437992; c=relaxed/simple;
	bh=FohYw9nz0fzNBe1jS2/16lLKKljrrVext2Apd0Bs5cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hu9xoZB6MOLmukXoPvecFtNRTGhXYmr7ZDA5IJkdAQlvqZuW7HygRv+VEoBQpvbFTRbiPvzlz4uJJPgqwbZdzOiLcAS8t5w+ZSPWZ0UvCDC1GKzd2xhGf0W+SwAQnjxvq/4Jb94KmWl6B31g7HZZbyfQXnlaNmfOBiD4qTqEbfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kAcebSPj; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766437990; x=1797973990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FohYw9nz0fzNBe1jS2/16lLKKljrrVext2Apd0Bs5cQ=;
  b=kAcebSPjkUoOX4131pPYe/XmqIdQWp+1Lqvm5Z+gT356XtMyYTLtwgYn
   +ihduhU0yS/Ow+8qEEsaloDiNW/8TarnAnryEUtO4eaRsYqS9TL9ZvpQU
   Z7WY7iUoYbrkT56VseeHKMy5IEA+55FcFWVSICoib6Jw7R2fIyzMnnfdx
   htIhV65SMsQKA+CU0d76pLKDDWvEiYJaI4ve1Z7Bft793DIk4950KxwF5
   +FJtCuY/2TeVsgOq847AqjKb7WI7G13dWL8EEXJ7aK2/7FtsL8UxQkDXy
   HnDuJrUNLMQO86g7dBp+kUFMWD002Y6aJOGpEdsMT4sPkbdCZgkeki+Pm
   A==;
X-CSE-ConnectionGUID: vJ8uHeoUSQ+q/j+xiH6CUA==
X-CSE-MsgGUID: xccOeLdESSmsLvWFiZgpqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="78611112"
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="78611112"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 13:13:10 -0800
X-CSE-ConnectionGUID: zckZnThfQfm24Lgr2elbaw==
X-CSE-MsgGUID: CPw7wIctQ0y2luUuhZl8Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="199608060"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 22 Dec 2025 13:13:06 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXnD8-0000000017T-0U9U;
	Mon, 22 Dec 2025 21:12:59 +0000
Date: Tue, 23 Dec 2025 05:12:38 +0800
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
Subject: Re: [PATCH v2 2/9] sched/fair: Add rate-limiting and validation
 helpers
Message-ID: <202512230415.0RatyaQF-lkp@intel.com>
References: <20251219035334.39790-3-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219035334.39790-3-kernellwp@gmail.com>

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
patch link:    https://lore.kernel.org/r/20251219035334.39790-3-kernellwp%40gmail.com
patch subject: [PATCH v2 2/9] sched/fair: Add rate-limiting and validation helpers
config: openrisc-randconfig-r122-20251221 (https://download.01.org/0day-ci/archive/20251223/202512230415.0RatyaQF-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512230415.0RatyaQF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512230415.0RatyaQF-lkp@intel.com/

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
   kernel/sched/fair.c:12991:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:12991:9: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/fair.c:12991:9: sparse:     got struct sched_domain [noderef] __rcu *parent
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
>> kernel/sched/fair.c:9089:20: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct task_struct *p_yielding @@     got struct task_struct [noderef] __rcu *donor @@
   kernel/sched/fair.c:9089:20: sparse:     expected struct task_struct *p_yielding
   kernel/sched/fair.c:9089:20: sparse:     got struct task_struct [noderef] __rcu *donor
   kernel/sched/fair.c:9110:38: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct task_struct *curr @@     got struct task_struct [noderef] __rcu *donor @@
   kernel/sched/fair.c:9110:38: sparse:     expected struct task_struct *curr
   kernel/sched/fair.c:9110:38: sparse:     got struct task_struct [noderef] __rcu *donor
   kernel/sched/fair.c:10146:40: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *child @@     got struct sched_domain [noderef] __rcu *child @@
   kernel/sched/fair.c:10146:40: sparse:     expected struct sched_domain *child
   kernel/sched/fair.c:10146:40: sparse:     got struct sched_domain [noderef] __rcu *child
   kernel/sched/fair.c:10774:22: sparse: sparse: incompatible types in comparison expression (different address spaces):
   kernel/sched/fair.c:10774:22: sparse:    struct task_struct [noderef] __rcu *
   kernel/sched/fair.c:10774:22: sparse:    struct task_struct *
   kernel/sched/fair.c:12246:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:12246:9: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/fair.c:12246:9: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:11884:44: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected struct sched_domain *sd_parent @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:11884:44: sparse:     expected struct sched_domain *sd_parent
   kernel/sched/fair.c:11884:44: sparse:     got struct sched_domain [noderef] __rcu *parent
   kernel/sched/fair.c:12359:9: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct sched_domain *[assigned] sd @@     got struct sched_domain [noderef] __rcu *parent @@
   kernel/sched/fair.c:12359:9: sparse:     expected struct sched_domain *[assigned] sd
   kernel/sched/fair.c:12359:9: sparse:     got struct sched_domain [noderef] __rcu *parent
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

vim +9089 kernel/sched/fair.c

  9064	
  9065	/*
  9066	 * Validate tasks for yield deboost operation.
  9067	 * Returns the yielding task on success, NULL on validation failure.
  9068	 *
  9069	 * Checks: feature enabled, valid target, same runqueue, target is fair class,
  9070	 * both on_rq. Called under rq->lock.
  9071	 *
  9072	 * Note: p_yielding (rq->donor) is guaranteed to be fair class by the caller
  9073	 * (yield_to_task_fair is only called when curr->sched_class == p->sched_class).
  9074	 */
  9075	static struct task_struct __maybe_unused *
  9076	yield_deboost_validate_tasks(struct rq *rq, struct task_struct *p_target)
  9077	{
  9078		struct task_struct *p_yielding;
  9079	
  9080		if (!sysctl_sched_vcpu_debooster_enabled)
  9081			return NULL;
  9082	
  9083		if (!p_target)
  9084			return NULL;
  9085	
  9086		if (yield_deboost_rate_limit(rq))
  9087			return NULL;
  9088	
> 9089		p_yielding = rq->donor;
  9090		if (!p_yielding || p_yielding == p_target)
  9091			return NULL;
  9092	
  9093		if (p_target->sched_class != &fair_sched_class)
  9094			return NULL;
  9095	
  9096		if (task_rq(p_target) != rq)
  9097			return NULL;
  9098	
  9099		if (!p_target->se.on_rq || !p_yielding->se.on_rq)
  9100			return NULL;
  9101	
  9102		return p_yielding;
  9103	}
  9104	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

