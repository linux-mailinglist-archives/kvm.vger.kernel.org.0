Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD97E4C1C85
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 20:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiBWTrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 14:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244415AbiBWTrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 14:47:18 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3694340D8;
        Wed, 23 Feb 2022 11:46:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645645609; x=1677181609;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gA2PEXZwL/NQTTul/+BF1zLlwkEDilbgAxnSaDLm/EA=;
  b=jIBtrlYpPYa91fMCDOi4GwBOU/HBenV3lpMv1JaBWz4/BtumWP/NltiM
   0KdUfHxNTly47XVnrmFPrdb9u+hS0SGXF4DZYd+vRdGDaP32w1T7ZJlOW
   PILZy4aRWehs6Tb5H2C5IVBSsw2eXKGqROPr6IRjCkt11ES5kqEDb6t5l
   Z9GI7K9R9FxYG/4omVUus5mqoUyMIspDjDBmXVXn32oVm2rV8LeCydwbV
   7/ckLQ8NTUdhfVofDkoFOXGK5WV6r/CZWv/iG7pqx2ArgUXHYrrJogX+M
   ZQx94OUuFRkwx8z6XixedWSfEZfsGpyoionYrxQVCHJ5c+oxudJ/dvzFJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="239460195"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="239460195"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 11:46:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="684022275"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 23 Feb 2022 11:46:45 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nMxb3-0001l6-6L; Wed, 23 Feb 2022 19:46:45 +0000
Date:   Thu, 24 Feb 2022 03:46:30 +0800
From:   kernel test robot <lkp@intel.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: Re: [PATCH 7/9] kvm: s390: Add CPU dump functionality
Message-ID: <202202240337.wksMLgVn-lkp@intel.com>
References: <20220223092007.3163-8-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223092007.3163-8-frankja@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Janosch,

I love your patch! Perhaps something to improve:

[auto build test WARNING on kvms390/next]
[also build test WARNING on next-20220222]
[cannot apply to kvm/master s390/features v5.17-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Janosch-Frank/kvm-s390-Add-PV-dump-support/20220223-172213
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git next
config: s390-randconfig-r044-20220223 (https://download.01.org/0day-ci/archive/20220224/202202240337.wksMLgVn-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/8e5a2c1d95d561cf1530c7a3427a1a367ab67364
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Janosch-Frank/kvm-s390-Add-PV-dump-support/20220223-172213
        git checkout 8e5a2c1d95d561cf1530c7a3427a1a367ab67364
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from arch/s390/kvm/kvm-s390.c:23:
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
   In file included from arch/s390/kvm/kvm-s390.c:23:
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
   In file included from arch/s390/kvm/kvm-s390.c:23:
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
>> arch/s390/kvm/kvm-s390.c:5088:5: warning: no previous prototype for function 'kvm_s390_handle_pv_vcpu_dump' [-Wmissing-prototypes]
   int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
       ^
   arch/s390/kvm/kvm-s390.c:5088:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
   ^
   static 
   13 warnings generated.


vim +/kvm_s390_handle_pv_vcpu_dump +5088 arch/s390/kvm/kvm-s390.c

  5087	
> 5088	int kvm_s390_handle_pv_vcpu_dump(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
  5089	{
  5090		struct kvm_s390_pv_dmp dmp;
  5091		void *data;
  5092		int ret;
  5093	
  5094		/* Dump initialization is a prerequisite */
  5095		if (!vcpu->kvm->arch.pv.dumping)
  5096			return -EINVAL;
  5097	
  5098		if (copy_from_user(&dmp, (__u8 __user *)cmd->data, sizeof(dmp)))
  5099			return -EFAULT;
  5100	
  5101		/* We only handle this subcmd right now */
  5102		if (dmp.subcmd != KVM_PV_DUMP_CPU)
  5103			return -EINVAL;
  5104	
  5105		/* CPU dump length is the same as create cpu storage donation. */
  5106		if (dmp.buff_len != uv_info.guest_cpu_stor_len)
  5107			return -EINVAL;
  5108	
  5109		data = vzalloc(uv_info.guest_cpu_stor_len);
  5110		if (!data)
  5111			return -ENOMEM;
  5112	
  5113		ret = kvm_s390_pv_dump_cpu(vcpu, data, &cmd->rc, &cmd->rrc);
  5114	
  5115		VCPU_EVENT(vcpu, 3, "PROTVIRT DUMP CPU %d rc %x rrc %x",
  5116			   vcpu->vcpu_id, cmd->rc, cmd->rrc);
  5117	
  5118		if (ret) {
  5119			vfree(data);
  5120			return -EINVAL;
  5121		}
  5122	
  5123		/* On success copy over the dump data */
  5124		if (copy_to_user((__u8 __user *)dmp.buff_addr, data, uv_info.guest_cpu_stor_len)) {
  5125			vfree(data);
  5126			return -EFAULT;
  5127		}
  5128	
  5129		vfree(data);
  5130		return 0;
  5131	}
  5132	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
