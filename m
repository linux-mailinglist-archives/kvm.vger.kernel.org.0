Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134B849D79F
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 02:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiA0Bwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 20:52:36 -0500
Received: from mga03.intel.com ([134.134.136.65]:64816 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234680AbiA0Bwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 20:52:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643248352; x=1674784352;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Zn6FBnuPEEI2Cb2M7YzXMP2WnCuo4at1k1dY0EJeSnw=;
  b=VMgckLjW/fAXhFGj6Yl7RItjHkDPDh3xLqrqn7ZtX3a/zVQyc/a+DR7j
   kbU30wlgs3VDdkp/GXS0YUcLLKcRQ5sMZjvSBbLM9LujDcvUD4+eSa3+4
   ghrWUDExR0Wpmdf3zGpwxqR/hyaQq54JqWLp4AlULbf57oC4/DWvf5GpD
   zx8pMIeuRGZeJmct1exRQu0TFgKKPGXy48Mo51T3E7C7W5ftm49J5ijes
   eeuV1zNFTtICnWtxC+cVjjdG91gbo8oHQEP5pAkGKl3VHRh+W9QSCJ/Hw
   V03hvVsLY7xoPG6BjDVLACZ40iCm9LKPwLBtohsJbDT6U+T+zawbD1ZI+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246662482"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="246662482"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 17:52:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="696453841"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 26 Jan 2022 17:52:29 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nCtxd-000LxU-6o; Thu, 27 Jan 2022 01:52:29 +0000
Date:   Thu, 27 Jan 2022 09:52:03 +0800
From:   kernel test robot <lkp@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>
Subject: [kvm:queue 305/328] arch/x86/kvm/x86.c:4345:32: warning: cast to
 pointer from integer of different size
Message-ID: <202201270930.LTyNaecg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   b029c138e8f090f5cb9ba77ef20509f903ef0004
commit: db9556a4eb6b43313cee57abcbbbad01f2708baa [305/328] KVM: x86: add system attribute to retrieve full set of supported xsave states
config: i386-randconfig-a003 (https://download.01.org/0day-ci/archive/20220127/202201270930.LTyNaecg-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?id=db9556a4eb6b43313cee57abcbbbad01f2708baa
        git remote add kvm https://git.kernel.org/pub/scm/virt/kvm/kvm.git
        git fetch --no-tags kvm queue
        git checkout db9556a4eb6b43313cee57abcbbbad01f2708baa
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash arch/x86/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from include/linux/uaccess.h:11,
                    from include/linux/sched/task.h:11,
                    from include/linux/sched/signal.h:9,
                    from include/linux/rcuwait.h:6,
                    from include/linux/percpu-rwsem.h:7,
                    from include/linux/fs.h:33,
                    from include/linux/huge_mm.h:8,
                    from include/linux/mm.h:717,
                    from include/linux/kvm_host.h:16,
                    from arch/x86/kvm/x86.c:19:
   arch/x86/kvm/x86.c: In function 'kvm_x86_dev_get_attr':
>> arch/x86/kvm/x86.c:4345:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
         |                                ^
   arch/x86/include/asm/uaccess.h:221:24: note: in definition of macro 'do_put_user_call'
     221 |  register __typeof__(*(ptr)) __val_pu asm("%"_ASM_AX);  \
         |                        ^~~
   arch/x86/kvm/x86.c:4345:7: note: in expansion of macro 'put_user'
    4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
         |       ^~~~~~~~
>> arch/x86/kvm/x86.c:4345:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
         |                                ^
   arch/x86/include/asm/uaccess.h:223:14: note: in definition of macro 'do_put_user_call'
     223 |  __ptr_pu = (ptr);      \
         |              ^~~
   arch/x86/kvm/x86.c:4345:7: note: in expansion of macro 'put_user'
    4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
         |       ^~~~~~~~
>> arch/x86/kvm/x86.c:4345:32: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
         |                                ^
   arch/x86/include/asm/uaccess.h:230:31: note: in definition of macro 'do_put_user_call'
     230 |          [size] "i" (sizeof(*(ptr)))   \
         |                               ^~~
   arch/x86/kvm/x86.c:4345:7: note: in expansion of macro 'put_user'
    4345 |   if (put_user(supported_xcr0, (u64 __user *)attr->addr))
         |       ^~~~~~~~


vim +4345 arch/x86/kvm/x86.c

  4337	
  4338	static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)
  4339	{
  4340		if (attr->group)
  4341			return -ENXIO;
  4342	
  4343		switch (attr->attr) {
  4344		case KVM_X86_XCOMP_GUEST_SUPP:
> 4345			if (put_user(supported_xcr0, (u64 __user *)attr->addr))
  4346				return -EFAULT;
  4347			return 0;
  4348		default:
  4349			return -ENXIO;
  4350			break;
  4351		}
  4352	}
  4353	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
