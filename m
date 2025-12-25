Return-Path: <kvm+bounces-66686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F09C3CDD979
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 10:35:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0554301E93A
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 09:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2EF3090C9;
	Thu, 25 Dec 2025 09:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QZZYH/WH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3550A2D97A6
	for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 09:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766655345; cv=none; b=S6lt7d7y6Mktp3jyfTWR0Jat+7gbZQjtGW31Px7Zq0WPSajFP9ykdM59ikx3SF7jHRwWxKnCGt0DPLWsr9ETHprmMzg8DNu+bc3gzH9B3YSauz7k7NfTgvLahcxkl0gs3mzDptD31l62xp1O0eJ6WAjcthqZ+a5uSoICplM4qUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766655345; c=relaxed/simple;
	bh=TcCc2zIbX0Qe9C4Qf96J+EeN2S2w6bx5WWKs0C2meac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRxDCMeKkZac20r7Nll0lP2DIh6W4hMT5IrSYafRwnE21olnzyP0iE/+l2l8ctNRYXVlRAHmHIHznpY/769kvFA2DRFZ1Gxv1J4k+Fz98Oj5p/DgU47l5xF4zKPv8gI5zXIL0w2FBRESQzIzV5LmMG1YC5WG0yARN1RMUT6yEKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QZZYH/WH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766655343; x=1798191343;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TcCc2zIbX0Qe9C4Qf96J+EeN2S2w6bx5WWKs0C2meac=;
  b=QZZYH/WHjcWJDjDJxUhTlJcpIf7EswbqLu1ARWcXlKCdVc4RPOmcTv4J
   InZ0K4ZcfJEOHD+nRD3KsyOWurz62/yfHZu0RULy1n+GxLW9wRC+WldJO
   CCZrEg99WJhtZWrZuBjIWeZUR/WxojPkhGEzY1KrIPxhHwudaKSNbeo/x
   a73f6/vqRi8vvTCNs+4X0A0j8yHQb8hXLcy8xXYuMzO47mqMZzti3yNNJ
   HjpcZtXSh9S0xXWqW+2FY449ORoM5H2T/zzDeqE5zhRDrXVq1VoT32hyv
   DuvcLpoIuBt1Tgd+EK+8FvXdCsA2jLqHyoAB9irCHj7FInGy0+dDzmGqz
   Q==;
X-CSE-ConnectionGUID: 9DksUPsDSCyy/uQ74QZUiQ==
X-CSE-MsgGUID: HA/d7HDdSuOlNzcNcUEqcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="72317162"
X-IronPort-AV: E=Sophos;i="6.21,176,1763452800"; 
   d="scan'208";a="72317162"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Dec 2025 01:35:42 -0800
X-CSE-ConnectionGUID: Podu9RDwTZepowNu+9wXMg==
X-CSE-MsgGUID: T2D3D8GcROOzwu5fhhsoRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,176,1763452800"; 
   d="scan'208";a="200492621"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 25 Dec 2025 01:35:40 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vYhkp-000000003x3-0Mzd;
	Thu, 25 Dec 2025 09:35:33 +0000
Date: Thu, 25 Dec 2025 17:34:40 +0800
From: kernel test robot <lkp@intel.com>
To: Yanfei Xu <yanfei.xu@bytedance.com>, pbonzini@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, caixiangfeng@bytedance.com,
	fangying.tommy@bytedance.com, yanfei.xu@bytedance.com
Subject: Re: [PATCH] KVM: irqchip: KVM: Reduce allocation overhead in
 kvm_set_irq_routing()
Message-ID: <202512251741.UOsoJoam-lkp@intel.com>
References: <20251224023201.381586-1-yanfei.xu@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224023201.381586-1-yanfei.xu@bytedance.com>

Hi Yanfei,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next linus/master v6.19-rc2 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yanfei-Xu/KVM-irqchip-KVM-Reduce-allocation-overhead-in-kvm_set_irq_routing/20251224-103451
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251224023201.381586-1-yanfei.xu%40bytedance.com
patch subject: [PATCH] KVM: irqchip: KVM: Reduce allocation overhead in kvm_set_irq_routing()
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20251225/202512251741.UOsoJoam-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251225/202512251741.UOsoJoam-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512251741.UOsoJoam-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/loongarch/kvm/../../../virt/kvm/irqchip.c:190:6: warning: variable 'r' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     190 |         if (!e)
         |             ^~
   arch/loongarch/kvm/../../../virt/kvm/irqchip.c:233:9: note: uninitialized use occurs here
     233 |         return r;
         |                ^
   arch/loongarch/kvm/../../../virt/kvm/irqchip.c:190:2: note: remove the 'if' if its condition is always false
     190 |         if (!e)
         |         ^~~~~~~
     191 |                 goto out;
         |                 ~~~~~~~~
   arch/loongarch/kvm/../../../virt/kvm/irqchip.c:176:7: note: initialize the variable 'r' to silence this warning
     176 |         int r;
         |              ^
         |               = 0
   1 warning generated.


vim +190 arch/loongarch/kvm/../../../virt/kvm/irqchip.c

   167	
   168	int kvm_set_irq_routing(struct kvm *kvm,
   169				const struct kvm_irq_routing_entry *ue,
   170				unsigned nr,
   171				unsigned flags)
   172	{
   173		struct kvm_irq_routing_table *new, *old;
   174		struct kvm_kernel_irq_routing_entry *e;
   175		u32 i, j, nr_rt_entries = 0;
   176		int r;
   177	
   178		for (i = 0; i < nr; ++i) {
   179			if (ue[i].gsi >= KVM_MAX_IRQ_ROUTES)
   180				return -EINVAL;
   181			nr_rt_entries = max(nr_rt_entries, ue[i].gsi);
   182		}
   183	
   184		nr_rt_entries += 1;
   185	
   186		new = kzalloc(struct_size(new, map, nr_rt_entries), GFP_KERNEL_ACCOUNT);
   187		if (!new)
   188			return -ENOMEM;
   189		e = kcalloc(nr, sizeof(*e), GFP_KERNEL_ACCOUNT);
 > 190		if (!e)
   191			goto out;
   192		new->entries_addr = e;
   193	
   194		new->nr_rt_entries = nr_rt_entries;
   195		for (i = 0; i < KVM_NR_IRQCHIPS; i++)
   196			for (j = 0; j < KVM_IRQCHIP_NUM_PINS; j++)
   197				new->chip[i][j] = -1;
   198	
   199		for (i = 0; i < nr; ++i) {
   200			r = -EINVAL;
   201			switch (ue->type) {
   202			case KVM_IRQ_ROUTING_MSI:
   203				if (ue->flags & ~KVM_MSI_VALID_DEVID)
   204					goto out;
   205				break;
   206			default:
   207				if (ue->flags)
   208					goto out;
   209				break;
   210			}
   211			r = setup_routing_entry(kvm, new, e + i, ue);
   212			if (r)
   213				goto out;
   214			++ue;
   215		}
   216	
   217		mutex_lock(&kvm->irq_lock);
   218		old = rcu_dereference_protected(kvm->irq_routing, 1);
   219		rcu_assign_pointer(kvm->irq_routing, new);
   220		kvm_irq_routing_update(kvm);
   221		kvm_arch_irq_routing_update(kvm);
   222		mutex_unlock(&kvm->irq_lock);
   223	
   224		synchronize_srcu_expedited(&kvm->irq_srcu);
   225	
   226		new = old;
   227		r = 0;
   228		goto out;
   229	
   230	out:
   231		free_irq_routing_table(new);
   232	
   233		return r;
   234	}
   235	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

