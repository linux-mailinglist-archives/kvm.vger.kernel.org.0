Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F6C4BAE4E
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 01:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiBRAVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 19:21:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiBRAVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 19:21:38 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6366150;
        Thu, 17 Feb 2022 16:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645143683; x=1676679683;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N32BdLCCicYvF88PVJV2JjNN97uAJo3pxS97Q2b1+KM=;
  b=JebK25hjQclsv7jqSHiEE0DjhouD4qt1Hlweeh/N3JaaLPvOya/WDJl3
   c2PnjKG1mJU6qLzaGAmlHipha9jFsT95Yg/4DMrb/NXTXgaR110a6iTsC
   I8UBubYHZRc7skItWk8OucBwc0SYrc+cZxM1teB+tUxmS7XaEnnKjPz0R
   tiosmwmc/T2cXlMHRA7YINkMxoRrRF17Mds1pXK9dWUcBmY2zjn1AYr2H
   6llKIJQL8NOTTbuV7UzINeTx2ik026zG72tzcPOd1+4t7yyEP9JIFLQya
   RsAY4lSZ02S62N1y8PDSqYcW4/KuivP+Yahwn6QOn7gU6P+3w2LYXcKRi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="248595414"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="248595414"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 15:23:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="777665220"
Received: from lkp-server01.sh.intel.com (HELO 6f05bf9e3301) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 17 Feb 2022 15:23:06 -0800
Received: from kbuild by 6f05bf9e3301 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nKq78-0000jQ-2C; Thu, 17 Feb 2022 23:23:06 +0000
Date:   Fri, 18 Feb 2022 07:22:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        seanjc@google.com
Cc:     kbuild-all@lists.01.org, mkoutny@suse.com, tj@kernel.org,
        lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com,
        jiangshanlai@gmail.com, kvm@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v3] KVM: Move VM's worker kthreads back to the original
 cgroup before exiting.
Message-ID: <202202180730.AAgeOZkF-lkp@intel.com>
References: <20220217061616.3303271-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217061616.3303271-1-vipinsh@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on db6e7adf8de9b3b99a9856acb73870cc3a70e3ca]

url:    https://github.com/0day-ci/linux/commits/Vipin-Sharma/KVM-Move-VM-s-worker-kthreads-back-to-the-original-cgroup-before-exiting/20220217-141723
base:   db6e7adf8de9b3b99a9856acb73870cc3a70e3ca
config: x86_64-rhel-8.3-kselftests (https://download.01.org/0day-ci/archive/20220218/202202180730.AAgeOZkF-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/1abffef71ef85b6fb8f1296e6ef38febc4f2b007
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Vipin-Sharma/KVM-Move-VM-s-worker-kthreads-back-to-the-original-cgroup-before-exiting/20220217-141723
        git checkout 1abffef71ef85b6fb8f1296e6ef38febc4f2b007
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c: note: in included file:
   include/linux/kvm_host.h:1877:54: sparse: sparse: array of flexible structures
   include/linux/kvm_host.h:1879:56: sparse: sparse: array of flexible structures
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:5859:54: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct task_struct *from @@     got struct task_struct [noderef] __rcu *real_parent @@
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:5859:54: sparse:     expected struct task_struct *from
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:5859:54: sparse:     got struct task_struct [noderef] __rcu *real_parent
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_change_pte' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_invalidate_range_start' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_invalidate_range_end' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_clear_flush_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_clear_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:538:9: sparse: sparse: context imbalance in 'kvm_mmu_notifier_test_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2522:9: sparse: sparse: context imbalance in 'hva_to_pfn_remapped' - unexpected unlock

vim +5859 arch/x86/kvm/../../../virt/kvm/kvm_main.c

  5805	
  5806	static int kvm_vm_worker_thread(void *context)
  5807	{
  5808		/*
  5809		 * The init_context is allocated on the stack of the parent thread, so
  5810		 * we have to locally copy anything that is needed beyond initialization
  5811		 */
  5812		struct kvm_vm_worker_thread_context *init_context = context;
  5813		struct kvm *kvm = init_context->kvm;
  5814		kvm_vm_thread_fn_t thread_fn = init_context->thread_fn;
  5815		uintptr_t data = init_context->data;
  5816		int err, reattach_err;
  5817	
  5818		err = kthread_park(current);
  5819		/* kthread_park(current) is never supposed to return an error */
  5820		WARN_ON(err != 0);
  5821		if (err)
  5822			goto init_complete;
  5823	
  5824		err = cgroup_attach_task_all(init_context->parent, current);
  5825		if (err) {
  5826			kvm_err("%s: cgroup_attach_task_all failed with err %d\n",
  5827				__func__, err);
  5828			goto init_complete;
  5829		}
  5830	
  5831		set_user_nice(current, task_nice(init_context->parent));
  5832	
  5833	init_complete:
  5834		init_context->err = err;
  5835		complete(&init_context->init_done);
  5836		init_context = NULL;
  5837	
  5838		if (err)
  5839			goto out;
  5840	
  5841		/* Wait to be woken up by the spawner before proceeding. */
  5842		kthread_parkme();
  5843	
  5844		if (!kthread_should_stop())
  5845			err = thread_fn(kvm, data);
  5846	
  5847	out:
  5848		/*
  5849		 * Move kthread back to its original cgroup to prevent it lingering in
  5850		 * the cgroup of the VM process, after the latter finishes its
  5851		 * execution.
  5852		 *
  5853		 * kthread_stop() waits on the 'exited' completion condition which is
  5854		 * set in exit_mm(), via mm_release(), in do_exit(). However, the
  5855		 * kthread is removed from the cgroup in the cgroup_exit() which is
  5856		 * called after the exit_mm(). This causes the kthread_stop() to return
  5857		 * before the kthread actually quits the cgroup.
  5858		 */
> 5859		reattach_err = cgroup_attach_task_all(current->real_parent, current);
  5860		if (reattach_err) {
  5861			kvm_err("%s: cgroup_attach_task_all failed on reattach with err %d\n",
  5862				__func__, reattach_err);
  5863		}
  5864		return err;
  5865	}
  5866	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
