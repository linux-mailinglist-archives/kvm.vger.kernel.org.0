Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2DF475651
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 11:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbhLOK1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 05:27:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:56890 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241691AbhLOK1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 05:27:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639564021; x=1671100021;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LkGJ+4FAnooNMJajceOtXw2YvpQUK863tvBjQaYETEY=;
  b=kecCFAc8n17dfd/nOZthsWTDNWO6OUeFAUPHwPaENdrazlt58+vuf213
   nNJqXoxOZtJPdT2+RQMwUF3OLvO04rwxErXRCXzz50VDIH5/wSEr9F8wM
   NpgklHJ+/ByQGkv9uXdfqI8r3ME2KRrIjbbsHbUn2aXHPL0K7hgNPEqx1
   AG8Huuo8FUHzIK82LCz7bMK2J4tpLRI7MKYHPeeYM13jpmimaVqrOW8oz
   sTu7zSrMGI/E75gWPURBjxQ7zVekdOlrodmHElAtwBWKkq6iiN18ptAXI
   GdH/Sb+AP4OraypbH31P5gzyx3SjhSKLK4fyYJa43dc9cvWSBF4EyKika
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="263346735"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="263346735"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 02:27:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="682438445"
Received: from lkp-server02.sh.intel.com (HELO 9f38c0981d9f) ([10.239.97.151])
  by orsmga005.jf.intel.com with ESMTP; 15 Dec 2021 02:26:56 -0800
Received: from kbuild by 9f38c0981d9f with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mxRUt-0001bw-UV; Wed, 15 Dec 2021 10:26:55 +0000
Date:   Wed, 15 Dec 2021 18:26:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     kbuild-all@lists.01.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Fabiano Rosas <farosas@linux.ibm.com>,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: Re: [PATCH kernel v3] KVM: PPC: Merge powerpc's debugfs entry
 content into generic entry
Message-ID: <202112151845.kedQxkhk-lkp@intel.com>
References: <20211215013309.217102-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215013309.217102-1-aik@ozlabs.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexey,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on powerpc/topic/ppc-kvm]
[also build test ERROR on v5.16-rc5]
[cannot apply to next-20211214]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Alexey-Kardashevskiy/KVM-PPC-Merge-powerpc-s-debugfs-entry-content-into-generic-entry/20211215-094051
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
config: powerpc-randconfig-r003-20211214 (https://download.01.org/0day-ci/archive/20211215/202112151845.kedQxkhk-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/bb4c492cb444748049b4392c1d6f97ca5c82f846
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Alexey-Kardashevskiy/KVM-PPC-Merge-powerpc-s-debugfs-entry-content-into-generic-entry/20211215-094051
        git checkout bb4c492cb444748049b4392c1d6f97ca5c82f846
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash arch/powerpc/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> arch/powerpc/kvm/e500.c:498:32: error: initialization of 'int (*)(struct kvm_vcpu *, struct dentry *)' from incompatible pointer type 'void (*)(struct kvm_vcpu *, struct dentry *)' [-Werror=incompatible-pointer-types]
     498 |         .create_vcpu_debugfs = kvmppc_create_vcpu_debugfs_e500,
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/kvm/e500.c:498:32: note: (near initialization for 'kvm_ops_e500.create_vcpu_debugfs')
   cc1: all warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for HOTPLUG_CPU
   Depends on SMP && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV || FSL_SOC_BOOKE
   Selected by
   - PM_SLEEP_SMP && SMP && (ARCH_SUSPEND_POSSIBLE || ARCH_HIBERNATION_POSSIBLE && PM_SLEEP


vim +498 arch/powerpc/kvm/e500.c

   483	
   484	static struct kvmppc_ops kvm_ops_e500 = {
   485		.get_sregs = kvmppc_core_get_sregs_e500,
   486		.set_sregs = kvmppc_core_set_sregs_e500,
   487		.get_one_reg = kvmppc_get_one_reg_e500,
   488		.set_one_reg = kvmppc_set_one_reg_e500,
   489		.vcpu_load   = kvmppc_core_vcpu_load_e500,
   490		.vcpu_put    = kvmppc_core_vcpu_put_e500,
   491		.vcpu_create = kvmppc_core_vcpu_create_e500,
   492		.vcpu_free   = kvmppc_core_vcpu_free_e500,
   493		.init_vm = kvmppc_core_init_vm_e500,
   494		.destroy_vm = kvmppc_core_destroy_vm_e500,
   495		.emulate_op = kvmppc_core_emulate_op_e500,
   496		.emulate_mtspr = kvmppc_core_emulate_mtspr_e500,
   497		.emulate_mfspr = kvmppc_core_emulate_mfspr_e500,
 > 498		.create_vcpu_debugfs = kvmppc_create_vcpu_debugfs_e500,
   499	};
   500	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
