Return-Path: <kvm+bounces-62486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B361FC44F93
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 06:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7874B188DDA2
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 05:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 825F72E88A7;
	Mon, 10 Nov 2025 05:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZpMBsTSr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B4B1B4F0A;
	Mon, 10 Nov 2025 05:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762751843; cv=none; b=CnB/BNid2rIZtiYHT5+e4IxA3BMT6fwC84rm9Cy+grCufCfu0MGez2GRDUak5Ir1DhUu1Q+tnW/OS7qoBcG5BcOn4dKMkW90EiThqhvy3lj7D1h6gyyuYj9U5wQeKgvVnZlJPKSiieNlYjrRhx/rVsYqwt6hhaadr9BvDcrM+90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762751843; c=relaxed/simple;
	bh=B8xGLtXLk7UM8HEMQcyCyv4NJfNe+kYjKelm970TQKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fCGVBg7WWUaq7f+X+gXac4gggWytZiGTo51YPSz0+RIzytuKjf6ejMos2F3oMtEMluiagZxI4wOGE1MsZkmQ6Ut5utpSFRfdApNTO1bm6SHPp4K7ybiFjLmSyGyYoWCWw+rCwLzZ/ZSmwSFci5m7WcYK+1cXgLWXvUlTZzNEl60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZpMBsTSr; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762751842; x=1794287842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=B8xGLtXLk7UM8HEMQcyCyv4NJfNe+kYjKelm970TQKg=;
  b=ZpMBsTSr7r9kYCA1StwL4AWn59vtAz8WXCgfs32hYHx3vgCZGapty0f6
   ShvNBKmf8nkI6MzEVKX4AZ7o6O7u1feQz2BCtCbAOZVYDJhJEfzzg4dmM
   3kDhN5WmPSgxj0f1z3mbjs8UbHTlhtD3qdW5j0bUaWoCnuqjOR0SK7/cA
   nWaeUlwPOZT/HVV+smII8KG65lwfb4yMvzX4IAv7d3lcfT9elZyNEK/li
   xhnrGoa8uqf/Ld4wcmsx+pLzTiIlA2/YfuhHlinWXPUEeWkn9S7aj/ZIv
   7RqWjCvOdnR8s371uI0k4doKVQ+55S9B4uxjnKKYRqZ2SPpxbhGXtsPQh
   Q==;
X-CSE-ConnectionGUID: xk+Kb4NTQa6+zpuG+wKPWg==
X-CSE-MsgGUID: mzdPvdFpT0GjvJrDmGeBjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="64834095"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="64834095"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 21:17:21 -0800
X-CSE-ConnectionGUID: 8HR3QZV9S1OSgKIsy81Iug==
X-CSE-MsgGUID: dGB8psDJRTite3V++mI7OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="188323433"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 09 Nov 2025 21:17:18 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIKHE-0002gL-0p;
	Mon, 10 Nov 2025 05:17:16 +0000
Date: Mon, 10 Nov 2025 13:16:39 +0800
From: kernel test robot <lkp@intel.com>
To: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Steven Rostedt <rostedt@goodmis.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 05/10] sched/fair: Wire up yield deboost in
 yield_to_task_fair()
Message-ID: <202511101338.8AICyae8-lkp@intel.com>
References: <20251110033232.12538-6-kernellwp@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110033232.12538-6-kernellwp@gmail.com>

Hi Wanpeng,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next tip/sched/core tip/master linus/master v6.18-rc5 next-20251107]
[cannot apply to kvm/linux-next tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Wanpeng-Li/sched-Add-vCPU-debooster-infrastructure/20251110-114219
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251110033232.12538-6-kernellwp%40gmail.com
patch subject: [PATCH 05/10] sched/fair: Wire up yield deboost in yield_to_task_fair()
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251110/202511101338.8AICyae8-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511101338.8AICyae8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511101338.8AICyae8-lkp@intel.com/

All errors (new ones prefixed by >>):

   m68k-linux-ld: kernel/sched/fair.o: in function `yield_deboost_calculate_penalty':
>> fair.c:(.text+0x1588): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

