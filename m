Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270BF67FB30
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 22:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbjA1VnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 16:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjA1VnE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 16:43:04 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E643B20044;
        Sat, 28 Jan 2023 13:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674942181; x=1706478181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=PyhpbJ8qguYYZgn0dx69wiKvFWxrEB0n/lsLke30HeQ=;
  b=RLmAL9eYCpJrvdV+DJozQLYyZ6A+CxN/ObG8dlDg02YWxTwpbwch1NTI
   8tJYPvhphC8y7i+GDYDET6JJU+HJ9toQoYRgxUW6dk7cg+BiwIFZeJGRJ
   NxXTKxFmvmUVtg6rVL/MDdBnN/1ev6jKzbb3rt2jWcjGTCnpJ49g82vUX
   rpaeAkAYkjz2KwtOFfKDAtE7ycxZnjMro9cRUkjc42DkIy6AWo39q0UxT
   ANZOckKJLYaZDuZnCZ8lIn8Xyd+WPLULGa7bdZ9bRArK6ikvCWW7LCLto
   ZqMUVEiW6/11egH7lgldriNGtFlwafY8nQboEaVvkmnzSodeq/er0hcrF
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="326009587"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="326009587"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2023 13:43:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10604"; a="992446763"
X-IronPort-AV: E=Sophos;i="5.97,254,1669104000"; 
   d="scan'208";a="992446763"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 28 Jan 2023 13:42:59 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLsyL-00018e-2d;
        Sat, 28 Jan 2023 21:42:53 +0000
Date:   Sun, 29 Jan 2023 05:42:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Stevens <stevensd@chromium.org>,
        Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH 1/3] KVM: Support sharing gpc locks
Message-ID: <202301290541.8nmbLtFC-lkp@intel.com>
References: <20230127044500.680329-2-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230127044500.680329-2-stevensd@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on linus/master v6.2-rc5 next-20230127]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Stevens/KVM-Support-sharing-gpc-locks/20230128-161425
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230127044500.680329-2-stevensd%40google.com
patch subject: [PATCH 1/3] KVM: Support sharing gpc locks
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20230129/202301290541.8nmbLtFC-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/14d62b317199184bb71256cc5f652b04fb2f9107
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review David-Stevens/KVM-Support-sharing-gpc-locks/20230128-161425
        git checkout 14d62b317199184bb71256cc5f652b04fb2f9107
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 olddefconfig
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/ drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arch/x86/kvm/xen.c: In function 'kvm_xen_update_runstate_guest':
>> arch/x86/kvm/xen.c:319:45: error: 'gpc1->lock' is a pointer; did you mean to use '->'?
     319 |                 lock_set_subclass(gpc1->lock.dep_map, 1, _THIS_IP_);
         |                                             ^
         |                                             ->


vim +319 arch/x86/kvm/xen.c

   172	
   173	static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
   174	{
   175		struct kvm_vcpu_xen *vx = &v->arch.xen;
   176		struct gfn_to_pfn_cache *gpc1 = &vx->runstate_cache;
   177		struct gfn_to_pfn_cache *gpc2 = &vx->runstate2_cache;
   178		size_t user_len, user_len1, user_len2;
   179		struct vcpu_runstate_info rs;
   180		unsigned long flags;
   181		size_t times_ofs;
   182		uint8_t *update_bit = NULL;
   183		uint64_t entry_time;
   184		uint64_t *rs_times;
   185		int *rs_state;
   186	
   187		/*
   188		 * The only difference between 32-bit and 64-bit versions of the
   189		 * runstate struct is the alignment of uint64_t in 32-bit, which
   190		 * means that the 64-bit version has an additional 4 bytes of
   191		 * padding after the first field 'state'. Let's be really really
   192		 * paranoid about that, and matching it with our internal data
   193		 * structures that we memcpy into it...
   194		 */
   195		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) != 0);
   196		BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state) != 0);
   197		BUILD_BUG_ON(sizeof(struct compat_vcpu_runstate_info) != 0x2c);
   198	#ifdef CONFIG_X86_64
   199		/*
   200		 * The 64-bit structure has 4 bytes of padding before 'state_entry_time'
   201		 * so each subsequent field is shifted by 4, and it's 4 bytes longer.
   202		 */
   203		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
   204			     offsetof(struct compat_vcpu_runstate_info, state_entry_time) + 4);
   205		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, time) !=
   206			     offsetof(struct compat_vcpu_runstate_info, time) + 4);
   207		BUILD_BUG_ON(sizeof(struct vcpu_runstate_info) != 0x2c + 4);
   208	#endif
   209		/*
   210		 * The state field is in the same place at the start of both structs,
   211		 * and is the same size (int) as vx->current_runstate.
   212		 */
   213		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state) !=
   214			     offsetof(struct compat_vcpu_runstate_info, state));
   215		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state) !=
   216			     sizeof(vx->current_runstate));
   217		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state) !=
   218			     sizeof(vx->current_runstate));
   219	
   220		/*
   221		 * The state_entry_time field is 64 bits in both versions, and the
   222		 * XEN_RUNSTATE_UPDATE flag is in the top bit, which given that x86
   223		 * is little-endian means that it's in the last *byte* of the word.
   224		 * That detail is important later.
   225		 */
   226		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, state_entry_time) !=
   227			     sizeof(uint64_t));
   228		BUILD_BUG_ON(sizeof_field(struct compat_vcpu_runstate_info, state_entry_time) !=
   229			     sizeof(uint64_t));
   230		BUILD_BUG_ON((XEN_RUNSTATE_UPDATE >> 56) != 0x80);
   231	
   232		/*
   233		 * The time array is four 64-bit quantities in both versions, matching
   234		 * the vx->runstate_times and immediately following state_entry_time.
   235		 */
   236		BUILD_BUG_ON(offsetof(struct vcpu_runstate_info, state_entry_time) !=
   237			     offsetof(struct vcpu_runstate_info, time) - sizeof(uint64_t));
   238		BUILD_BUG_ON(offsetof(struct compat_vcpu_runstate_info, state_entry_time) !=
   239			     offsetof(struct compat_vcpu_runstate_info, time) - sizeof(uint64_t));
   240		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
   241			     sizeof_field(struct compat_vcpu_runstate_info, time));
   242		BUILD_BUG_ON(sizeof_field(struct vcpu_runstate_info, time) !=
   243			     sizeof(vx->runstate_times));
   244	
   245		if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
   246			user_len = sizeof(struct vcpu_runstate_info);
   247			times_ofs = offsetof(struct vcpu_runstate_info,
   248					     state_entry_time);
   249		} else {
   250			user_len = sizeof(struct compat_vcpu_runstate_info);
   251			times_ofs = offsetof(struct compat_vcpu_runstate_info,
   252					     state_entry_time);
   253		}
   254	
   255		/*
   256		 * There are basically no alignment constraints. The guest can set it
   257		 * up so it crosses from one page to the next, and at arbitrary byte
   258		 * alignment (and the 32-bit ABI doesn't align the 64-bit integers
   259		 * anyway, even if the overall struct had been 64-bit aligned).
   260		 */
   261		if ((gpc1->gpa & ~PAGE_MASK) + user_len >= PAGE_SIZE) {
   262			user_len1 = PAGE_SIZE - (gpc1->gpa & ~PAGE_MASK);
   263			user_len2 = user_len - user_len1;
   264		} else {
   265			user_len1 = user_len;
   266			user_len2 = 0;
   267		}
   268		BUG_ON(user_len1 + user_len2 != user_len);
   269	
   270	 retry:
   271		/*
   272		 * Attempt to obtain the GPC lock on *both* (if there are two)
   273		 * gfn_to_pfn caches that cover the region.
   274		 */
   275		if (atomic) {
   276			local_irq_save(flags);
   277			if (!read_trylock(gpc1->lock)) {
   278				local_irq_restore(flags);
   279				return;
   280			}
   281		} else {
   282			read_lock_irqsave(gpc1->lock, flags);
   283		}
   284		while (!kvm_gpc_check(gpc1, user_len1)) {
   285			read_unlock_irqrestore(gpc1->lock, flags);
   286	
   287			/* When invoked from kvm_sched_out() we cannot sleep */
   288			if (atomic)
   289				return;
   290	
   291			if (kvm_gpc_refresh(gpc1, user_len1))
   292				return;
   293	
   294			read_lock_irqsave(gpc1->lock, flags);
   295		}
   296	
   297		if (likely(!user_len2)) {
   298			/*
   299			 * Set up three pointers directly to the runstate_info
   300			 * struct in the guest (via the GPC).
   301			 *
   302			 *  • @rs_state   → state field
   303			 *  • @rs_times   → state_entry_time field.
   304			 *  • @update_bit → last byte of state_entry_time, which
   305			 *                  contains the XEN_RUNSTATE_UPDATE bit.
   306			 */
   307			rs_state = gpc1->khva;
   308			rs_times = gpc1->khva + times_ofs;
   309			if (v->kvm->arch.xen.runstate_update_flag)
   310				update_bit = ((void *)(&rs_times[1])) - 1;
   311		} else {
   312			/*
   313			 * The guest's runstate_info is split across two pages and we
   314			 * need to hold and validate both GPCs simultaneously. We can
   315			 * declare a lock ordering GPC1 > GPC2 because nothing else
   316			 * takes them more than one at a time. Set a subclass on the
   317			 * gpc1 lock to make lockdep shut up about it.
   318			 */
 > 319			lock_set_subclass(gpc1->lock.dep_map, 1, _THIS_IP_);
   320			if (atomic) {
   321				if (!read_trylock(gpc2->lock)) {
   322					read_unlock_irqrestore(gpc1->lock, flags);
   323					return;
   324				}
   325			} else {
   326				read_lock(gpc2->lock);
   327			}
   328	
   329			if (!kvm_gpc_check(gpc2, user_len2)) {
   330				read_unlock(gpc2->lock);
   331				read_unlock_irqrestore(gpc1->lock, flags);
   332	
   333				/* When invoked from kvm_sched_out() we cannot sleep */
   334				if (atomic)
   335					return;
   336	
   337				/*
   338				 * Use kvm_gpc_activate() here because if the runstate
   339				 * area was configured in 32-bit mode and only extends
   340				 * to the second page now because the guest changed to
   341				 * 64-bit mode, the second GPC won't have been set up.
   342				 */
   343				if (kvm_gpc_activate(gpc2, gpc1->gpa + user_len1,
   344						     user_len2))
   345					return;
   346	
   347				/*
   348				 * We dropped the lock on GPC1 so we have to go all the
   349				 * way back and revalidate that too.
   350				 */
   351				goto retry;
   352			}
   353	
   354			/*
   355			 * In this case, the runstate_info struct will be assembled on
   356			 * the kernel stack (compat or not as appropriate) and will
   357			 * be copied to GPC1/GPC2 with a dual memcpy. Set up the three
   358			 * rs pointers accordingly.
   359			 */
   360			rs_times = &rs.state_entry_time;
   361	
   362			/*
   363			 * The rs_state pointer points to the start of what we'll
   364			 * copy to the guest, which in the case of a compat guest
   365			 * is the 32-bit field that the compiler thinks is padding.
   366			 */
   367			rs_state = ((void *)rs_times) - times_ofs;
   368	
   369			/*
   370			 * The update_bit is still directly in the guest memory,
   371			 * via one GPC or the other.
   372			 */
   373			if (v->kvm->arch.xen.runstate_update_flag) {
   374				if (user_len1 >= times_ofs + sizeof(uint64_t))
   375					update_bit = gpc1->khva + times_ofs +
   376						sizeof(uint64_t) - 1;
   377				else
   378					update_bit = gpc2->khva + times_ofs +
   379						sizeof(uint64_t) - 1 - user_len1;
   380			}
   381	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
