Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F0D1E249C
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgEZO4F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 10:56:05 -0400
Received: from mga18.intel.com ([134.134.136.126]:12103 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgEZO4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 10:56:05 -0400
IronPort-SDR: xadmTCFUBRPIJ+tXYpMfhKNPqHj1Q11gXgD2hV3has3QE3yRWl4p/mG0XzuutuBhbj0nPqNdOo
 0xlCpzVXXBzw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 07:56:04 -0700
IronPort-SDR: jqZ+tLf1islW1l+9enfHOXh8olOhqqefZ1/MQqusWt3goPcHrGuWVjrroCOTGRiFws8bnx1gUl
 lYEvKqDwEwJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="468326431"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.140])
  by fmsmga005.fm.intel.com with ESMTP; 26 May 2020 07:56:01 -0700
Date:   Tue, 26 May 2020 23:05:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com
Subject: Re: [PATCH v9 07/14] KVM: Don't allocate dirty bitmap if dirty ring
 is enabled
Message-ID: <20200526150547.GC30967@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523225659.1027044-8-peterx@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on vhost/linux-next]
[also build test WARNING on linus/master v5.7-rc7]
[cannot apply to kvm/linux-next tip/auto-latest linux/master next-20200522]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Peter-Xu/KVM-Dirty-ring-interface/20200524-070926
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
:::::: branch date: 2 days ago
:::::: commit date: 2 days ago
compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
reproduce (this is a W=1 build):
        # save the attached .config to linux build tree
        make W=1 ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


cppcheck warnings: (new ones prefixed by >>)

>> arch/x86/kvm/mmu/mmu.c:1280:3: warning: Returning an integer in a function with pointer return type is not portable. [CastIntegerToAddressAtReturn]
     return false;
     ^
   arch/x86/kvm/mmu/mmu.c:3725:9: warning: Redundant initialization for 'root'. The initialized value is overwritten before it is read. [redundantInitialization]
      root = __pa(sp->spt);
           ^
   arch/x86/kvm/mmu/mmu.c:3715:15: note: root is initialized
      hpa_t root = vcpu->arch.mmu->pae_root[i];
                 ^
   arch/x86/kvm/mmu/mmu.c:3725:9: note: root is overwritten
      root = __pa(sp->spt);
           ^
   arch/x86/kvm/mmu/mmu.c:3769:8: warning: Redundant initialization for 'root'. The initialized value is overwritten before it is read. [redundantInitialization]
     root = __pa(sp->spt);
          ^
   arch/x86/kvm/mmu/mmu.c:3758:14: note: root is initialized
     hpa_t root = vcpu->arch.mmu->root_hpa;
                ^
   arch/x86/kvm/mmu/mmu.c:3769:8: note: root is overwritten
     root = __pa(sp->spt);
          ^
   arch/x86/kvm/mmu/mmu.c:4670:15: warning: Clarify calculation precedence for '&' and '?'. [clarifyCalculation]
    const u8 x = BYTE_MASK(ACC_EXEC_MASK);
                 ^
   arch/x86/kvm/mmu/mmu.c:4671:15: warning: Clarify calculation precedence for '&' and '?'. [clarifyCalculation]
    const u8 w = BYTE_MASK(ACC_WRITE_MASK);
                 ^
   arch/x86/kvm/mmu/mmu.c:4672:15: warning: Clarify calculation precedence for '&' and '?'. [clarifyCalculation]
    const u8 u = BYTE_MASK(ACC_USER_MASK);

# https://github.com/0day-ci/linux/commit/2c23bd2b96e30ae3814e3e56f01a6234131cb531
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 2c23bd2b96e30ae3814e3e56f01a6234131cb531
vim +1280 arch/x86/kvm/mmu/mmu.c

b8e8c8303ff28c arch/x86/kvm/mmu.c     Paolo Bonzini   2019-11-04  1269  
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1270  static struct kvm_memory_slot *
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1271  gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1272  			    bool no_dirty_log)
05da45583de9b3 arch/x86/kvm/mmu.c     Marcelo Tosatti 2008-02-23  1273  {
05da45583de9b3 arch/x86/kvm/mmu.c     Marcelo Tosatti 2008-02-23  1274  	struct kvm_memory_slot *slot;
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1275  
54bf36aac52031 arch/x86/kvm/mmu.c     Paolo Bonzini   2015-04-08  1276  	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
91b0d268a59dd9 arch/x86/kvm/mmu/mmu.c Paolo Bonzini   2020-01-21  1277  	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
91b0d268a59dd9 arch/x86/kvm/mmu/mmu.c Paolo Bonzini   2020-01-21  1278  		return NULL;
2c23bd2b96e30a arch/x86/kvm/mmu/mmu.c Peter Xu        2020-05-23  1279  	if (no_dirty_log && kvm_slot_dirty_track_enabled(slot))
2c23bd2b96e30a arch/x86/kvm/mmu/mmu.c Peter Xu        2020-05-23 @1280  		return false;
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1281  
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1282  	return slot;
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1283  }
5d163b1c9d6e55 arch/x86/kvm/mmu.c     Xiao Guangrong  2011-03-09  1284  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

