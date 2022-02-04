Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4F4D4AA23D
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242053AbiBDVWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:22:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:52428 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234384AbiBDVWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644009773; x=1675545773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Q0sBxlENUk9O0bMBfazY3nvfd6WM4GRtxdNNT+RMwcU=;
  b=DM415larZZi97GY1cyAVZE+wBk0mlLka6MLxR+13jZJ1grlme3jb+fpc
   PS00F+vbOBoMsJEYY5fgnpwQKE3TKxb2nXOhIrfu8xCLdg+Csm4pNT5x9
   qFnKDdi1w4IU+kvN3TaqJucCf8JI6jHQs/TJP3N9RH0+pyyfIe53HpqgR
   qhQbBZwpWNByYlNUlwGO5Zmkv4geZ8JIFQGrztgTzW1L+SyHUTM/Q44bA
   hjWPMAFjEGgYGMvbjNYisVfQ8KZxoCIk/TG1E6SLgwT4ThR99jKuhlXx9
   nozsWpmF6bFsnBsQY0KYnl+2Hji+6YJ2Dn6KKBqWpfHiYLeYiVM+W8Zwx
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="309190138"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="309190138"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 13:22:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="498596555"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 04 Feb 2022 13:22:49 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nG62b-000YCb-2j; Fri, 04 Feb 2022 21:22:49 +0000
Date:   Sat, 5 Feb 2022 05:22:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 10/17] KVM: s390: pv: add mmu_notifier
Message-ID: <202202050525.5A9HirW8-lkp@intel.com>
References: <20220204155349.63238-11-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204155349.63238-11-imbrenda@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Claudio,

I love your patch! Yet something to improve:

[auto build test ERROR on kvm/queue]
[also build test ERROR on v5.17-rc2 next-20220204]
[cannot apply to kvms390/next s390/features]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220204-235609
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: s390-randconfig-r044-20220131 (https://download.01.org/0day-ci/archive/20220205/202202050525.5A9HirW8-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a73e4ce6a59b01f0e37037761c1e6889d539d233)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/9ee65f25ad996d38f6935360c99a89e72024174b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220204-235609
        git checkout 9ee65f25ad996d38f6935360c99a89e72024174b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/s390/kvm/pv.c:9:
   In file included from include/linux/kvm_host.h:41:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:37:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from arch/s390/kvm/pv.c:9:
   In file included from include/linux/kvm_host.h:41:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:37:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from arch/s390/kvm/pv.c:9:
   In file included from include/linux/kvm_host.h:41:
   In file included from include/linux/kvm_para.h:5:
   In file included from include/uapi/linux/kvm_para.h:37:
   In file included from arch/s390/include/asm/kvm_para.h:25:
   In file included from arch/s390/include/asm/diag.h:12:
   In file included from include/linux/if_ether.h:19:
   In file included from include/linux/skbuff.h:31:
   In file included from include/linux/dma-mapping.h:10:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> arch/s390/kvm/pv.c:255:3: error: implicit declaration of function 'mmu_notifier_register' [-Werror,-Wimplicit-function-declaration]
                   mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
                   ^
   arch/s390/kvm/pv.c:255:3: note: did you mean 'mmu_notifier_release'?
   include/linux/mmu_notifier.h:679:20: note: 'mmu_notifier_release' declared here
   static inline void mmu_notifier_release(struct mm_struct *mm)
                      ^
   12 warnings and 1 error generated.


vim +/mmu_notifier_register +255 arch/s390/kvm/pv.c

   210	
   211	int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
   212	{
   213		struct uv_cb_cgc uvcb = {
   214			.header.cmd = UVC_CMD_CREATE_SEC_CONF,
   215			.header.len = sizeof(uvcb)
   216		};
   217		int cc, ret;
   218		u16 dummy;
   219	
   220		ret = kvm_s390_pv_alloc_vm(kvm);
   221		if (ret)
   222			return ret;
   223	
   224		/* Inputs */
   225		uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
   226		uvcb.guest_stor_len = kvm->arch.pv.guest_len;
   227		uvcb.guest_asce = kvm->arch.gmap->asce;
   228		uvcb.guest_sca = (unsigned long)kvm->arch.sca;
   229		uvcb.conf_base_stor_origin = (u64)kvm->arch.pv.stor_base;
   230		uvcb.conf_virt_stor_origin = (u64)kvm->arch.pv.stor_var;
   231	
   232		cc = uv_call_sched(0, (u64)&uvcb);
   233		*rc = uvcb.header.rc;
   234		*rrc = uvcb.header.rrc;
   235		KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
   236			     uvcb.guest_handle, uvcb.guest_stor_len, *rc, *rrc);
   237	
   238		/* Outputs */
   239		kvm->arch.pv.handle = uvcb.guest_handle;
   240	
   241		atomic_inc(&kvm->mm->context.protected_count);
   242		if (cc) {
   243			if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
   244				kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
   245			} else {
   246				atomic_dec(&kvm->mm->context.protected_count);
   247				kvm_s390_pv_dealloc_vm(kvm);
   248			}
   249			return -EIO;
   250		}
   251		kvm->arch.gmap->guest_handle = uvcb.guest_handle;
   252		/* Add the notifier only once. No races because we hold kvm->lock */
   253		if (kvm->arch.pv.mmu_notifier.ops != &kvm_s390_pv_mmu_notifier_ops) {
   254			kvm->arch.pv.mmu_notifier.ops = &kvm_s390_pv_mmu_notifier_ops;
 > 255			mmu_notifier_register(&kvm->arch.pv.mmu_notifier, kvm->mm);
   256		}
   257		return 0;
   258	}
   259	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
