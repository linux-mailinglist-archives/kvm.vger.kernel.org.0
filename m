Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECF84D430F
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 10:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240613AbiCJJHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 04:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbiCJJG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 04:06:56 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDAC137766
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 01:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646903156; x=1678439156;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=M82xsNeo1Txk79yU2M24O6ziQEPCl6oeTfC2wcFQDzY=;
  b=k/bOnumtsJOosZM7xUPgwebAUwROh92Ysbby6AuV315fSXlBOn/NVhzG
   uhQes7+SKouCZRKu8WokXuNLWmbgLFHSnQWzQMe/MfH4c2hKiYhXagG7H
   lJ3cfQdvq/wbjdX+YHxn/sjf10/iKRzXVcgaMsuQNVLj6ugd7b/winKqD
   HpRW3yBzuSim1h2Y2Y2IoOmy8GZeGyyVf42zCfn3nL/YUx4iwCJSjMQd+
   UH0Pg8Z26xGfslDa0HQUm2y2X+mz6nrYIFZ6wIWrDoAEbnirVFQq+rjRR
   3e5tmfM3XWWpn++IQwWI01kFjiH4rIRMDLwPFnxbYhj5D5wElgv4V0TrN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="242644530"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="242644530"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 01:05:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="510819893"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 10 Mar 2022 01:05:46 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSEjx-0004hY-FK; Thu, 10 Mar 2022 09:05:45 +0000
Date:   Thu, 10 Mar 2022 17:05:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:queue 210/210] arch/x86/kvm/cpuid.c:739:2: warning: unannotated
 fall-through between switch labels
Message-ID: <202203101604.2rV6WBqW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   ce41d078aaa9cf15cbbb4a42878cc6160d76525e
commit: ce41d078aaa9cf15cbbb4a42878cc6160d76525e [210/210] KVM: x86: synthesize CPUID leaf 0x80000021h if useful
config: x86_64-randconfig-a014 (https://download.01.org/0day-ci/archive/20220310/202203101604.2rV6WBqW-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 276ca87382b8f16a65bddac700202924228982f6)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=ce41d078aaa9cf15cbbb4a42878cc6160d76525e
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout ce41d078aaa9cf15cbbb4a42878cc6160d76525e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash arch/x86/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/cpuid.c:739:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
           default:
           ^
   arch/x86/kvm/cpuid.c:739:2: note: insert 'break;' to avoid fall-through
           default:
           ^
           break; 
   1 warning generated.


vim +739 arch/x86/kvm/cpuid.c

e53c95e8d41ef9 Sean Christopherson 2020-03-02  707  
e53c95e8d41ef9 Sean Christopherson 2020-03-02  708  static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
aa10a7dc8858f6 Sean Christopherson 2020-03-02  709  					      u32 function, u32 index)
00b27a3efb1160 Avi Kivity          2011-11-23  710  {
e53c95e8d41ef9 Sean Christopherson 2020-03-02  711  	struct kvm_cpuid_entry2 *entry;
e53c95e8d41ef9 Sean Christopherson 2020-03-02  712  
e53c95e8d41ef9 Sean Christopherson 2020-03-02  713  	if (array->nent >= array->maxnent)
aa10a7dc8858f6 Sean Christopherson 2020-03-02  714  		return NULL;
e53c95e8d41ef9 Sean Christopherson 2020-03-02  715  
e53c95e8d41ef9 Sean Christopherson 2020-03-02  716  	entry = &array->entries[array->nent++];
aa10a7dc8858f6 Sean Christopherson 2020-03-02  717  
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  718  	memset(entry, 0, sizeof(*entry));
00b27a3efb1160 Avi Kivity          2011-11-23  719  	entry->function = function;
00b27a3efb1160 Avi Kivity          2011-11-23  720  	entry->index = index;
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  721  	switch (function & 0xC0000000) {
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  722  	case 0x40000000:
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  723  		/* Hypervisor leaves are always synthesized by __do_cpuid_func.  */
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  724  		return entry;
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  725  
ce41d078aaa9cf Paolo Bonzini       2021-10-21  726  	case 0x80000000:
ce41d078aaa9cf Paolo Bonzini       2021-10-21  727  		/*
ce41d078aaa9cf Paolo Bonzini       2021-10-21  728  		 * 0x80000021 is sometimes synthesized by __do_cpuid_func, which
ce41d078aaa9cf Paolo Bonzini       2021-10-21  729  		 * would result in out-of-bounds calls to do_host_cpuid.
ce41d078aaa9cf Paolo Bonzini       2021-10-21  730  		 */
ce41d078aaa9cf Paolo Bonzini       2021-10-21  731  		{
ce41d078aaa9cf Paolo Bonzini       2021-10-21  732  			static int max_cpuid_80000000;
ce41d078aaa9cf Paolo Bonzini       2021-10-21  733  			if (!READ_ONCE(max_cpuid_80000000))
ce41d078aaa9cf Paolo Bonzini       2021-10-21  734  				WRITE_ONCE(max_cpuid_80000000, cpuid_eax(0x80000000));
ce41d078aaa9cf Paolo Bonzini       2021-10-21  735  			if (function > READ_ONCE(max_cpuid_80000000))
ce41d078aaa9cf Paolo Bonzini       2021-10-21  736  				return entry;
ce41d078aaa9cf Paolo Bonzini       2021-10-21  737  		}
ce41d078aaa9cf Paolo Bonzini       2021-10-21  738  
2746a6b72ab9a9 Paolo Bonzini       2021-10-28 @739  	default:
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  740  		break;
2746a6b72ab9a9 Paolo Bonzini       2021-10-28  741  	}
ab8bcf64971180 Paolo Bonzini       2019-06-24  742  
00b27a3efb1160 Avi Kivity          2011-11-23  743  	cpuid_count(entry->function, entry->index,
00b27a3efb1160 Avi Kivity          2011-11-23  744  		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);
d9aadaf689928b Paolo Bonzini       2019-07-04  745  
d9aadaf689928b Paolo Bonzini       2019-07-04  746  	switch (function) {
d9aadaf689928b Paolo Bonzini       2019-07-04  747  	case 4:
d9aadaf689928b Paolo Bonzini       2019-07-04  748  	case 7:
d9aadaf689928b Paolo Bonzini       2019-07-04  749  	case 0xb:
d9aadaf689928b Paolo Bonzini       2019-07-04  750  	case 0xd:
a06dcd625d6181 Jim Mattson         2019-09-12  751  	case 0xf:
a06dcd625d6181 Jim Mattson         2019-09-12  752  	case 0x10:
a06dcd625d6181 Jim Mattson         2019-09-12  753  	case 0x12:
d9aadaf689928b Paolo Bonzini       2019-07-04  754  	case 0x14:
a06dcd625d6181 Jim Mattson         2019-09-12  755  	case 0x17:
a06dcd625d6181 Jim Mattson         2019-09-12  756  	case 0x18:
690a757d610e50 Jing Liu            2022-01-05  757  	case 0x1d:
690a757d610e50 Jing Liu            2022-01-05  758  	case 0x1e:
a06dcd625d6181 Jim Mattson         2019-09-12  759  	case 0x1f:
d9aadaf689928b Paolo Bonzini       2019-07-04  760  	case 0x8000001d:
d9aadaf689928b Paolo Bonzini       2019-07-04  761  		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
d9aadaf689928b Paolo Bonzini       2019-07-04  762  		break;
d9aadaf689928b Paolo Bonzini       2019-07-04  763  	}
aa10a7dc8858f6 Sean Christopherson 2020-03-02  764  
aa10a7dc8858f6 Sean Christopherson 2020-03-02  765  	return entry;
00b27a3efb1160 Avi Kivity          2011-11-23  766  }
00b27a3efb1160 Avi Kivity          2011-11-23  767  

:::::: The code at line 739 was first introduced by commit
:::::: 2746a6b72ab9a92bd188c4ac3e4122ee1c18f754 KVM: x86: skip host CPUID call for hypervisor leaves

:::::: TO: Paolo Bonzini <pbonzini@redhat.com>
:::::: CC: Paolo Bonzini <pbonzini@redhat.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
