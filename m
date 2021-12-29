Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CAF481153
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 10:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhL2JkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 04:40:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:55789 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235098AbhL2JkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 04:40:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640770801; x=1672306801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xg3yNLu1SDSyfnJWw0NUeSPKNgbPrxBdSvpwaZoN6g4=;
  b=dk6Y0zGjUHxxZoc0RAwP4/5yA90M5bFR+oZ28h2a4vkpdAeAo77DYAGw
   ns7BQdc6Tkay68phKVLiDiEDQWXWn/XGGz4r7ldzfnhKA89qqAVIiQnv3
   0hQNuEVBJ92NwZvngNI1OW+cve/2lmEpZqDrpGj8ftCUS1n/oNdbV/Ame
   XLfgw+quGclzOnHo62G7ki4QvkAZRqrZqdbp69xwiaTbbOPTb88lpQgQQ
   c/q26aweiKfPl6toGLBbehQWxHMq70qKFDZS+IfrIMcwietX+k45gVJxl
   2nBcRer1uxaWlNAJ0F8Pye5D+CC1xnnRzqozZtOuzThIYVH3e3uAY4Xl9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="302247434"
X-IronPort-AV: E=Sophos;i="5.88,244,1635231600"; 
   d="scan'208";a="302247434"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Dec 2021 01:40:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,244,1635231600"; 
   d="scan'208";a="609555047"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Dec 2021 01:39:58 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n2VR7-0008nv-Jh; Wed, 29 Dec 2021 09:39:57 +0000
Date:   Wed, 29 Dec 2021 17:39:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kbuild-all@lists.01.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        David Stevens <stevensd@chromium.org>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH kernel v4] KVM: PPC: Merge powerpc's debugfs entry
 content into generic entry
Message-ID: <202112291710.E7bImDlB-lkp@intel.com>
References: <20211220012351.2719879-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220012351.2719879-1-aik@ozlabs.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexey,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on powerpc/topic/ppc-kvm]
[also build test ERROR on v5.16-rc7]
[cannot apply to next-20211224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Alexey-Kardashevskiy/KVM-PPC-Merge-powerpc-s-debugfs-entry-content-into-generic-entry/20211220-092433
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
config: powerpc64-randconfig-s031-20211228 (https://download.01.org/0day-ci/archive/20211229/202112291710.E7bImDlB-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/3d3a1a5e82517f5f1a5dd3d7131afb3aa4312d82
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Alexey-Kardashevskiy/KVM-PPC-Merge-powerpc-s-debugfs-entry-content-into-generic-entry/20211220-092433
        git checkout 3d3a1a5e82517f5f1a5dd3d7131afb3aa4312d82
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=powerpc SHELL=/bin/bash arch/powerpc/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/powerpc/kvm/e500mc.c:384:32: error: initialization of 'int (*)(struct kvm_vcpu *, struct dentry *)' from incompatible pointer type 'void (*)(struct kvm_vcpu *, struct dentry *)' [-Werror=incompatible-pointer-types]
     384 |         .create_vcpu_debugfs = kvmppc_create_vcpu_debugfs_e500,
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/kvm/e500mc.c:384:32: note: (near initialization for 'kvm_ops_e500mc.create_vcpu_debugfs')
   cc1: all warnings being treated as errors


vim +384 arch/powerpc/kvm/e500mc.c

   369	
   370	static struct kvmppc_ops kvm_ops_e500mc = {
   371		.get_sregs = kvmppc_core_get_sregs_e500mc,
   372		.set_sregs = kvmppc_core_set_sregs_e500mc,
   373		.get_one_reg = kvmppc_get_one_reg_e500mc,
   374		.set_one_reg = kvmppc_set_one_reg_e500mc,
   375		.vcpu_load   = kvmppc_core_vcpu_load_e500mc,
   376		.vcpu_put    = kvmppc_core_vcpu_put_e500mc,
   377		.vcpu_create = kvmppc_core_vcpu_create_e500mc,
   378		.vcpu_free   = kvmppc_core_vcpu_free_e500mc,
   379		.init_vm = kvmppc_core_init_vm_e500mc,
   380		.destroy_vm = kvmppc_core_destroy_vm_e500mc,
   381		.emulate_op = kvmppc_core_emulate_op_e500,
   382		.emulate_mtspr = kvmppc_core_emulate_mtspr_e500,
   383		.emulate_mfspr = kvmppc_core_emulate_mfspr_e500,
 > 384		.create_vcpu_debugfs = kvmppc_create_vcpu_debugfs_e500,
   385	};
   386	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
