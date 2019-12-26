Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1CA812ADFE
	for <lists+kvm@lfdr.de>; Thu, 26 Dec 2019 19:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfLZSwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Dec 2019 13:52:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:38275 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbfLZSwD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Dec 2019 13:52:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Dec 2019 10:52:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,360,1571727600"; 
   d="gz'50?scan'50,208,50";a="230186464"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 26 Dec 2019 10:51:58 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ikYEo-0000g3-2m; Fri, 27 Dec 2019 02:51:58 +0800
Date:   Fri, 27 Dec 2019 02:51:33 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Zengruan Ye <yezengruan@huawei.com>
Cc:     kbuild-all@lists.01.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, yezengruan@huawei.com,
        maz@kernel.org, james.morse@arm.com, linux@armlinux.org.uk,
        suzuki.poulose@arm.com, julien.thierry.kdev@gmail.com,
        catalin.marinas@arm.com, mark.rutland@arm.com, will@kernel.org,
        steven.price@arm.com, daniel.lezcano@linaro.org
Subject: Re: [PATCH v2 5/6] KVM: arm64: Add interface to support VCPU
 preempted check
Message-ID: <201912270236.nkxsDrid%lkp@intel.com>
References: <20191226135833.1052-6-yezengruan@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xrmjtbr5l47tzvih"
Content-Disposition: inline
In-Reply-To: <20191226135833.1052-6-yezengruan@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--xrmjtbr5l47tzvih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Zengruan,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvmarm/next]
[also build test ERROR on kvm/linux-next linus/master v5.5-rc3 next-20191220]
[cannot apply to arm64/for-next/core]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Zengruan-Ye/KVM-arm64-VCPU-preempted-check-support/20191227-000637
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
config: arm64-alldefconfig (attached as .config)
compiler: aarch64-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=arm64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from include/linux/spinlock.h:89:0,
                    from include/linux/radix-tree.h:16,
                    from include/linux/idr.h:15,
                    from include/linux/kernfs.h:13,
                    from include/linux/sysfs.h:16,
                    from include/linux/kobject.h:20,
                    from include/linux/of.h:17,
                    from include/linux/irqdomain.h:35,
                    from include/linux/acpi.h:13,
                    from include/acpi/apei.h:9,
                    from include/acpi/ghes.h:5,
                    from include/linux/arm_sdei.h:8,
                    from arch/arm64/kernel/asm-offsets.c:10:
   arch/arm64/include/asm/spinlock.h: In function 'vcpu_is_preempted':
>> arch/arm64/include/asm/spinlock.h:18:9: error: implicit declaration of function 'pv_vcpu_is_preempted'; did you mean 'vcpu_is_preempted'? [-Werror=implicit-function-declaration]
     return pv_vcpu_is_preempted(cpu);
            ^~~~~~~~~~~~~~~~~~~~
            vcpu_is_preempted
   cc1: some warnings being treated as errors
   make[2]: *** [arch/arm64/kernel/asm-offsets.s] Error 1
   make[2]: Target '__build' not remade because of errors.
   make[1]: *** [prepare0] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [sub-make] Error 2
   27 real  5 user  7 sys  48.63% cpu 	make prepare

vim +18 arch/arm64/include/asm/spinlock.h

    14	
    15	#define vcpu_is_preempted vcpu_is_preempted
    16	static inline bool vcpu_is_preempted(long cpu)
    17	{
  > 18		return pv_vcpu_is_preempted(cpu);
    19	}
    20	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--xrmjtbr5l47tzvih
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--xrmjtbr5l47tzvih--
