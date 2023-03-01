Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087956A66EA
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 05:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjCAEML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 23:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjCAEMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 23:12:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14C737B66;
        Tue, 28 Feb 2023 20:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677643927; x=1709179927;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U7opX0au99yMs82xz7uZOj3lKz4+yd7MviPX3UKt0UM=;
  b=mFMMpRjBm8AFF/mWOZKJrY6NIYxRvHHctxhX+Ld2aCuFZBXKDlz8mGzH
   Esr2Rs0yGTE+Pkd60ASadqhvEou/SGFLcJ/xTIhQ2ZP5OUau8FFVW1tX8
   w80gzQ3KwV+kSineizwa0+VvVteV1YYK5qsJ9ksQPR+1kXmWp7jWn5ns4
   tncFTDoCiuiGfpIMrsyXrNeQn4J0rEtMVd8k/mG4O6Y6NXJa7hoe6e8Eh
   7wYjxbDCyeaHihIVSAXelEhYggrawOD8d76NrpWZpKE3p/n2VeJ4STklJ
   ZahqmnesL7n5MDuoi7mAVm6fpu/AbWsaRig5OAmo/uIaBkL4E36CV1Evq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="318117411"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="318117411"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 20:12:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="667703659"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="667703659"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 28 Feb 2023 20:12:03 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pXDox-0005sR-0f;
        Wed, 01 Mar 2023 04:12:03 +0000
Date:   Wed, 1 Mar 2023 12:11:35 +0800
From:   kernel test robot <lkp@intel.com>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, pbonzini@redhat.com,
        alex.williamson@redhat.com, mst@redhat.com, jasowang@redhat.com
Cc:     oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, eperezma@redhat.com, arei.gonglei@huawei.com,
        yechuan@huawei.com, Longpeng <longpeng2@huawei.com>
Subject: Re: [PATCH] irqbypass: convert producers/consumers single linked
 list to hlist
Message-ID: <202303011218.cfYZyYAh-lkp@intel.com>
References: <20230301021830.880-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301021830.880-1-longpeng2@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Longpeng(Mike),

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.2 next-20230301]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Longpeng-Mike/irqbypass-convert-producers-consumers-single-linked-list-to-hlist/20230301-101936
patch link:    https://lore.kernel.org/r/20230301021830.880-1-longpeng2%40huawei.com
patch subject: [PATCH] irqbypass: convert producers/consumers single linked list to hlist
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20230301/202303011218.cfYZyYAh-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/4dcec57dc5acaecbf3bb03634ab1ef6a696927be
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Longpeng-Mike/irqbypass-convert-producers-consumers-single-linked-list-to-hlist/20230301-101936
        git checkout 4dcec57dc5acaecbf3bb03634ab1ef6a696927be
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash virt/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303011218.cfYZyYAh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/irqbypass.h:11,
                    from virt/lib/irqbypass.c:17:
   virt/lib/irqbypass.c: In function 'find_producer_by_token':
>> virt/lib/irqbypass.c:42:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:19: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:42:9: note: in expansion of macro 'hash_for_each_possible'
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
>> virt/lib/irqbypass.c:42:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:19: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:42:9: note: in expansion of macro 'hash_for_each_possible'
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
>> virt/lib/irqbypass.c:42:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:19: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:32:50: note: in expansion of macro 'hash_long'
      32 |         (sizeof(val) <= 4 ? hash_32(val, bits) : hash_long(val, bits))
         |                                                  ^~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:42:9: note: in expansion of macro 'hash_for_each_possible'
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
>> virt/lib/irqbypass.c:42:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:35: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:42:9: note: in expansion of macro 'hash_for_each_possible'
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
>> virt/lib/irqbypass.c:42:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:35: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:42:9: note: in expansion of macro 'hash_for_each_possible'
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
>> virt/lib/irqbypass.c:42:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:35: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:32:50: note: in expansion of macro 'hash_long'
      32 |         (sizeof(val) <= 4 ? hash_32(val, bits) : hash_long(val, bits))
         |                                                  ^~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:42:9: note: in expansion of macro 'hash_for_each_possible'
      42 |         hash_for_each_possible(producers, producer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   virt/lib/irqbypass.c: In function 'find_consumer_by_token':
   virt/lib/irqbypass.c:54:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:19: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:54:9: note: in expansion of macro 'hash_for_each_possible'
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   virt/lib/irqbypass.c:54:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:19: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:54:9: note: in expansion of macro 'hash_for_each_possible'
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   virt/lib/irqbypass.c:54:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:19: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:32:50: note: in expansion of macro 'hash_long'
      32 |         (sizeof(val) <= 4 ? hash_32(val, bits) : hash_long(val, bits))
         |                                                  ^~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:54:9: note: in expansion of macro 'hash_for_each_possible'
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   virt/lib/irqbypass.c:54:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:35: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:54:9: note: in expansion of macro 'hash_for_each_possible'
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   virt/lib/irqbypass.c:54:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:35: note: in definition of macro 'hlist_entry_safe'
    1043 |         ({ typeof(ptr) ____ptr = (ptr); \
         |                                   ^~~
   include/linux/hashtable.h:166:9: note: in expansion of macro 'hlist_for_each_entry'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |         ^~~~~~~~~~~~~~~~~~~~
   include/linux/hashtable.h:166:41: note: in expansion of macro 'hash_min'
     166 |         hlist_for_each_entry(obj, &name[hash_min(key, HASH_BITS(name))], member)
         |                                         ^~~~~~~~
   virt/lib/irqbypass.c:54:9: note: in expansion of macro 'hash_for_each_possible'
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |         ^~~~~~~~~~~~~~~~~~~~~~
   virt/lib/irqbypass.c:54:59: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      54 |         hash_for_each_possible(producers, consumer, node, (uint64_t)token)
         |                                                           ^
   include/linux/list.h:1043:35: note: in definition of macro 'hlist_entry_safe'


vim +42 virt/lib/irqbypass.c

  > 17	#include <linux/irqbypass.h>
    18	#include <linux/list.h>
    19	#include <linux/module.h>
    20	#include <linux/mutex.h>
    21	#include <linux/hashtable.h>
    22	
    23	MODULE_LICENSE("GPL v2");
    24	MODULE_DESCRIPTION("IRQ bypass manager utility module");
    25	
    26	/*
    27	 * hash table for produces/consumers. This improve the performace to find
    28	 * an existing producer/consumer.
    29	 */
    30	#define PRODUCERS_HASH_BITS	9
    31	#define CONSUMERS_HASH_BITS	9
    32	static DEFINE_HASHTABLE(producers, PRODUCERS_HASH_BITS);
    33	static DEFINE_HASHTABLE(consumers, CONSUMERS_HASH_BITS);
    34	static DEFINE_MUTEX(lock);
    35	
    36	
    37	/* @lock must be held */
    38	static struct irq_bypass_producer *find_producer_by_token(void *token)
    39	{
    40		struct irq_bypass_producer *producer;
    41	
  > 42		hash_for_each_possible(producers, producer, node, (uint64_t)token)
    43			if (producer->token == token)
    44				return producer;
    45	
    46		return NULL;
    47	}
    48	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
