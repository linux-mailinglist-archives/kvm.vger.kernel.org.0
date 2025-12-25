Return-Path: <kvm+bounces-66679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF3AACDD58E
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 07:04:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D90103008796
	for <lists+kvm@lfdr.de>; Thu, 25 Dec 2025 06:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A9E23D28C;
	Thu, 25 Dec 2025 06:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpUEj/gx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5FC2AD32
	for <kvm@vger.kernel.org>; Thu, 25 Dec 2025 06:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766642689; cv=none; b=bHPW7btYQu6LwZsKeORJTkvwZ3TYOEDDu661lF1zZsMylECb7p7Pta6quzWFExox1go/YaEykGiEg7e2Vj2IYAuJwI2t/4LE8js7JH18fEu97rfqARUWAt2uebtL9Czo1B5Pje/8TaPCmc6lrDBBK8nPnfnfgH9b0pGtM2dHNr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766642689; c=relaxed/simple;
	bh=OwoQ8LLuJ0L0BO2q3wFDVu0UQmtLzj2aPGVWbwQB6qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pvIaO4Ibh9Zi7j/owXSOFIUYubrbWeQgyj9WbH/bBgOZ4NvLPaHyyaHIP2wKRPDRWvvdvoa1J+ckogf3yXnd0X4xCkaNQPOmCOolzGiB1EyjyJ8ZqnRKdsZIXcuvVUObCatMS0qcj17TPCCWjn4JDpUKFXzx22Mm4FOoAclMkU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BpUEj/gx; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766642688; x=1798178688;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OwoQ8LLuJ0L0BO2q3wFDVu0UQmtLzj2aPGVWbwQB6qU=;
  b=BpUEj/gxcUaGh4Irxgqk0o+J0RaQuEFjWshWUodZAvZVKSDReQNUFGEu
   nYrAaiWkm95WNXWSK43mJB2ZKvhIoHBSPQwE5C7pYjTxlB+dkMzOeOSpx
   KFDvk13GqCCJmuTehbVNAhC2J8r9RFxKdl5o1nilwdEBqn6SMOELitlP6
   z5TvPwB9Jn9ivc4NbF/U1eOUBZhbW0bn+YBB86E5Q8Z3ble4dOdG16aHR
   NxnT3e0LduHT5tLYeS4INGqwHdDzTFzsq0sKvOIAqqyGHq3pMPh7B4Ws5
   xcgMDNIzyiFhtyL5KZuWZnwoI4Ie2nYXqXFfGfjiU+nDFeuSKDkegV6Sp
   w==;
X-CSE-ConnectionGUID: J86GGbVAToOze9e837vAdg==
X-CSE-MsgGUID: f7qnNgi8QLqV63c0K0DuNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11652"; a="68438980"
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="68438980"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2025 22:04:48 -0800
X-CSE-ConnectionGUID: OD2JONPuQUiPnMfdWSJ4gQ==
X-CSE-MsgGUID: jwVrFT5VTH6Ppypzi1Icyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,175,1763452800"; 
   d="scan'208";a="200466995"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 24 Dec 2025 22:04:45 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vYeSo-000000003nt-2txd;
	Thu, 25 Dec 2025 06:04:42 +0000
Date: Thu, 25 Dec 2025 14:04:27 +0800
From: kernel test robot <lkp@intel.com>
To: Yanfei Xu <yanfei.xu@bytedance.com>, pbonzini@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, caixiangfeng@bytedance.com,
	fangying.tommy@bytedance.com, yanfei.xu@bytedance.com
Subject: Re: [PATCH] KVM: irqchip: KVM: Reduce allocation overhead in
 kvm_set_irq_routing()
Message-ID: <202512251312.VbcflZDz-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251225/202512251312.VbcflZDz-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251225/202512251312.VbcflZDz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512251312.VbcflZDz-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/../../../virt/kvm/irqchip.c:190:6: warning: variable 'r' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     190 |         if (!e)
         |             ^~
   arch/x86/kvm/../../../virt/kvm/irqchip.c:233:9: note: uninitialized use occurs here
     233 |         return r;
         |                ^
   arch/x86/kvm/../../../virt/kvm/irqchip.c:190:2: note: remove the 'if' if its condition is always false
     190 |         if (!e)
         |         ^~~~~~~
     191 |                 goto out;
         |                 ~~~~~~~~
   arch/x86/kvm/../../../virt/kvm/irqchip.c:176:7: note: initialize the variable 'r' to silence this warning
     176 |         int r;
         |              ^
         |               = 0
   1 warning generated.


vim +190 arch/x86/kvm/../../../virt/kvm/irqchip.c

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

