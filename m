Return-Path: <kvm+bounces-62485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F41C44F8A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 06:17:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 331363A8987
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 05:17:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B53B2E7F1D;
	Mon, 10 Nov 2025 05:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ljIXziJw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CFA1A2C25;
	Mon, 10 Nov 2025 05:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762751843; cv=none; b=if4Sx1Ga0h2oc1T/10tLPc/l8R2H7MHUOv+ipB0PB4qTZmxlWTUbj3JIhRYIAOOSE9Uk/iEPETTR21tHmRr2TGOCaaW17f0ARuvjlc313LvjAi+XMPi8v9JqBMGJjpcny4PDR8rRTA16vToTj46nAGnEDqrpt1Fp88gFYlNGEE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762751843; c=relaxed/simple;
	bh=arMEVgo3EncNgwNhXraToER5I5/99hzkDqa6X/+wgao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWClIbwEgnX7sBeKieEJVXCSAYU1gL/MslJvvTdrAo0aLUr6QiQ9BVndaKgXHVdP2mZDsj/0YSJ4wD1pOhCGlblhe96co7t/RYVXp8KNekzCBYO5AHm4qQtxAxnpLaqumAIivCbM54L3/iEaV90HKnuszfqEGxFU9eZThtp7sfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ljIXziJw; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762751842; x=1794287842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=arMEVgo3EncNgwNhXraToER5I5/99hzkDqa6X/+wgao=;
  b=ljIXziJwU8o4XYbn7hYrisuNafSD4OCxHebScw791JR3wHo1DH1sC34p
   ZOpZDcwwsef0Q+nlc+OhQxxUP6eV3cJiyKqF/bColnquuK/ulehuDE47L
   3TtsH6j53ng6CJBDtOaRkYWUP/XrxPNIoi2FqmcCCgEDAlPv9I6MBBDqr
   8PLUCMUav+DqtR6Ru0OVrhkbZo80YPz/XQ9jwZFVwOH1J01wwM+viFtEi
   RdnND56Y2/eBeAV0LOjwo3z510deyYV3TXQZI/5icP/Bcz9o/mWTcILCy
   /bL2KoUYsp5x+TywY8LU/5/0Eij0Wx4QL5sWkmoPqRECQCbV6ArjCC7/B
   A==;
X-CSE-ConnectionGUID: 9ceLQA61QIWvK1zBKcU6ww==
X-CSE-MsgGUID: EAB68TD4Q6WaM6zaVLouTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="64498884"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="64498884"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 21:17:21 -0800
X-CSE-ConnectionGUID: qMO86JjpQ5ytB6igoohgxg==
X-CSE-MsgGUID: j4kEaJboTVOCVcb0E/J8dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="211983862"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Nov 2025 21:17:18 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIKHE-0002gJ-0j;
	Mon, 10 Nov 2025 05:17:16 +0000
Date: Mon, 10 Nov 2025 13:16:38 +0800
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
Message-ID: <202511101310.HuFb12n3-lkp@intel.com>
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
config: xtensa-allnoconfig (https://download.01.org/0day-ci/archive/20251110/202511101310.HuFb12n3-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511101310.HuFb12n3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511101310.HuFb12n3-lkp@intel.com/

All errors (new ones prefixed by >>):

   xtensa-linux-ld: kernel/sched/fair.o: in function `detach_entity_load_avg.constprop.0':
   fair.c:(.text+0xc84): undefined reference to `__udivdi3'
>> xtensa-linux-ld: fair.c:(.text+0xd06): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

