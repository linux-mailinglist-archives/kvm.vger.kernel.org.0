Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A574AA089
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 20:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiBDTyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 14:54:37 -0500
Received: from mga14.intel.com ([192.55.52.115]:6092 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235923AbiBDTvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 14:51:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644004308; x=1675540308;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kJDjmslEqoVtkUzkgdS2gg8FX4/9XXiEMdV+Zf7EL6U=;
  b=dYy/hFrs+aglHtGueBFBqq8/HWh0B2UU7atv80H8YqhfoAp7djVRW6lZ
   BnwAzdchTsCmZ2X58lHZbWQ2sdgrP3qVni15geUt7MKdA9gBQ/zn5JMHe
   BlQEt81ZWT7ofTXAtBqJJ53GS6QbXNirpJzEukDeU51s4IUmISFiokBGb
   rFcbXumNyvgmueDSxpUiovKjxFfRE6E3xISJ4Z0iTm1MoAwjtFD1peXNR
   bvaAMxuNuubwpSA8/2XMbEoK6hnV2NqM4r2nTpvwRleF7YNN6ou/MNMX8
   aKLCN/pCDmkq7HKCbjvPVJXuyrpXUmrU8BEwkm9RCb7+5cwSg4cM/+nJ+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="248645870"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="248645870"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 11:51:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="483715942"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 04 Feb 2022 11:51:44 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nG4cS-000Y5z-0G; Fri, 04 Feb 2022 19:51:44 +0000
Date:   Sat, 5 Feb 2022 03:51:06 +0800
From:   kernel test robot <lkp@intel.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: Re: [PATCH v7 03/17] KVM: s390: pv: handle secure storage exceptions
 for normal guests
Message-ID: <202202050319.tZ4OT36V-lkp@intel.com>
References: <20220204155349.63238-4-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204155349.63238-4-imbrenda@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Claudio,

I love your patch! Perhaps something to improve:

[auto build test WARNING on kvm/queue]
[also build test WARNING on v5.17-rc2 next-20220204]
[cannot apply to kvms390/next s390/features]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220204-235609
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
config: s390-randconfig-r044-20220131 (https://download.01.org/0day-ci/archive/20220205/202202050319.tZ4OT36V-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a73e4ce6a59b01f0e37037761c1e6889d539d233)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/cc87a31d00bc8f7a4e95369503a5ce184747a32b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Claudio-Imbrenda/KVM-s390-pv-implement-lazy-destroy-for-reboot/20220204-235609
        git checkout cc87a31d00bc8f7a4e95369503a5ce184747a32b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/ arch/s390/mm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from arch/s390/mm/fault.c:36:
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
   In file included from arch/s390/mm/fault.c:36:
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
   In file included from arch/s390/mm/fault.c:36:
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
>> arch/s390/mm/fault.c:805:18: warning: variable 'mm' is uninitialized when used here [-Wuninitialized]
                   mmap_read_lock(mm);
                                  ^~
   arch/s390/mm/fault.c:771:22: note: initialize the variable 'mm' to silence this warning
           struct mm_struct *mm;
                               ^
                                = NULL
   13 warnings generated.


vim +/mm +805 arch/s390/mm/fault.c

   766	
   767	void do_secure_storage_access(struct pt_regs *regs)
   768	{
   769		unsigned long addr = regs->int_parm_long & __FAIL_ADDR_MASK;
   770		struct vm_area_struct *vma;
   771		struct mm_struct *mm;
   772		struct page *page;
   773		struct gmap *gmap;
   774		int rc;
   775	
   776		/*
   777		 * bit 61 tells us if the address is valid, if it's not we
   778		 * have a major problem and should stop the kernel or send a
   779		 * SIGSEGV to the process. Unfortunately bit 61 is not
   780		 * reliable without the misc UV feature so we need to check
   781		 * for that as well.
   782		 */
   783		if (test_bit_inv(BIT_UV_FEAT_MISC, &uv_info.uv_feature_indications) &&
   784		    !test_bit_inv(61, &regs->int_parm_long)) {
   785			/*
   786			 * When this happens, userspace did something that it
   787			 * was not supposed to do, e.g. branching into secure
   788			 * memory. Trigger a segmentation fault.
   789			 */
   790			if (user_mode(regs)) {
   791				send_sig(SIGSEGV, current, 0);
   792				return;
   793			}
   794	
   795			/*
   796			 * The kernel should never run into this case and we
   797			 * have no way out of this situation.
   798			 */
   799			panic("Unexpected PGM 0x3d with TEID bit 61=0");
   800		}
   801	
   802		switch (get_fault_type(regs)) {
   803		case GMAP_FAULT:
   804			gmap = (struct gmap *)S390_lowcore.gmap;
 > 805			mmap_read_lock(mm);
   806			addr = __gmap_translate(gmap, addr);
   807			mmap_read_unlock(mm);
   808			if (IS_ERR_VALUE(addr)) {
   809				do_fault_error(regs, VM_ACCESS_FLAGS, VM_FAULT_BADMAP);
   810				break;
   811			}
   812			fallthrough;
   813		case USER_FAULT:
   814			mm = current->mm;
   815			mmap_read_lock(mm);
   816			vma = find_vma(mm, addr);
   817			if (!vma) {
   818				mmap_read_unlock(mm);
   819				do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
   820				break;
   821			}
   822			page = follow_page(vma, addr, FOLL_WRITE | FOLL_GET);
   823			if (IS_ERR_OR_NULL(page)) {
   824				mmap_read_unlock(mm);
   825				break;
   826			}
   827			if (arch_make_page_accessible(page))
   828				send_sig(SIGSEGV, current, 0);
   829			put_page(page);
   830			mmap_read_unlock(mm);
   831			break;
   832		case KERNEL_FAULT:
   833			page = phys_to_page(addr);
   834			if (unlikely(!try_get_page(page)))
   835				break;
   836			rc = arch_make_page_accessible(page);
   837			put_page(page);
   838			if (rc)
   839				BUG();
   840			break;
   841		default:
   842			do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
   843			WARN_ON_ONCE(1);
   844		}
   845	}
   846	NOKPROBE_SYMBOL(do_secure_storage_access);
   847	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
