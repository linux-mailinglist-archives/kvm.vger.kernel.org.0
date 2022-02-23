Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F360E4C1C21
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 20:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbiBWT0X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 14:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiBWT0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 14:26:20 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0783546144;
        Wed, 23 Feb 2022 11:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645644352; x=1677180352;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=amQaGc1KIsJ13G32G3Xr6iYz+fX7KyuUC+u3T0GfmjI=;
  b=bE/QBsf1mAu4B1lGxZjwL5R3bUW+5iKW+W/eA+aD1e/UbC68uJ8oRtJf
   i5y+TqbuYGS9E3G2HDUhi1qAj/gIr0hbiQCp/sVFpVVemz5zV8MGq2ReM
   71rrBC9puTcIpaCaGetkMJF33YJbiaEpCYXxc3nRpG3GfOcNrHU009c8R
   oXA/GCzR1NG5lLidVMDp8OVXXUNAg03/7mWgr5lcBDwfoIEzGai1R0A39
   kgGXoYyOtcFvLR8byiwAPjtQgLCxR6xz88DXAqEyRugbDOqQr1o1tw3eZ
   0NUx8VzFJglpfJxNmgGLMdXOSnpe4SGrCDxl8X1V/ASysbaDrcNtJq8zl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10267"; a="312779112"
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="312779112"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 11:25:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,391,1635231600"; 
   d="scan'208";a="543437237"
Received: from lkp-server01.sh.intel.com (HELO 788b1cd46f0d) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 23 Feb 2022 11:25:45 -0800
Received: from kbuild by 788b1cd46f0d with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nMxGi-0001jZ-Cv; Wed, 23 Feb 2022 19:25:44 +0000
Date:   Thu, 24 Feb 2022 03:25:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: Re: [PATCH 6/9] kvm: s390: Add configuration dump functionality
Message-ID: <202202240358.kEydOdbz-lkp@intel.com>
References: <20220223092007.3163-7-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223092007.3163-7-frankja@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
config: s390-randconfig-c005-20220223 (https://download.01.org/0day-ci/archive/20220224/202202240358.kEydOdbz-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project d271fc04d5b97b12e6b797c6067d3c96a8d7470e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/63a2029ece7e8fee92aa5ad277e2cbd8b13b7e6b
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Janosch-Frank/kvm-s390-Add-PV-dump-support/20220223-172213
        git checkout 63a2029ece7e8fee92aa5ad277e2cbd8b13b7e6b
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash arch/s390/kvm/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

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
   arch/s390/kvm/pv.c:369:6: warning: variable 'cc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!buff_kvm)
               ^~~~~~~~~
   arch/s390/kvm/pv.c:411:6: note: uninitialized use occurs here
           if (cc || ret)
               ^~
   arch/s390/kvm/pv.c:369:2: note: remove the 'if' if its condition is always false
           if (!buff_kvm)
           ^~~~~~~~~~~~~~
   arch/s390/kvm/pv.c:357:6: warning: variable 'cc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!buff_user_len ||
               ^~~~~~~~~~~~~~~~~
   arch/s390/kvm/pv.c:411:6: note: uninitialized use occurs here
           if (cc || ret)
               ^~
   arch/s390/kvm/pv.c:357:2: note: remove the 'if' if its condition is always false
           if (!buff_user_len ||
           ^~~~~~~~~~~~~~~~~~~~~
>> arch/s390/kvm/pv.c:357:6: warning: variable 'cc' is used uninitialized whenever '||' condition is true [-Wsometimes-uninitialized]
           if (!buff_user_len ||
               ^~~~~~~~~~~~~~
   arch/s390/kvm/pv.c:411:6: note: uninitialized use occurs here
           if (cc || ret)
               ^~
   arch/s390/kvm/pv.c:357:6: note: remove the '||' if its condition is always false
           if (!buff_user_len ||
               ^~~~~~~~~~~~~~~~~
   arch/s390/kvm/pv.c:348:6: warning: variable 'cc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (*gaddr & ~HPAGE_MASK)
               ^~~~~~~~~~~~~~~~~~~~
   arch/s390/kvm/pv.c:411:6: note: uninitialized use occurs here
           if (cc || ret)
               ^~
   arch/s390/kvm/pv.c:348:2: note: remove the 'if' if its condition is always false
           if (*gaddr & ~HPAGE_MASK)
           ^~~~~~~~~~~~~~~~~~~~~~~~~
   arch/s390/kvm/pv.c:344:8: note: initialize the variable 'cc' to silence this warning
           int cc, ret;
                 ^
                  = 0
   16 warnings generated.


vim +357 arch/s390/kvm/pv.c

   309	
   310	/*
   311	 * kvm_s390_pv_dump_stor_state
   312	 *
   313	 * @kvm: pointer to the guest's KVM struct
   314	 * @buff_user: Userspace pointer where we will write the results to
   315	 * @gaddr: Starting absolute guest address for which the storage state
   316	 *         is requested. This value will be updated with the last
   317	 *         address for which data was written when returning to
   318	 *         userspace.
   319	 * @buff_user_len: Length of the buff_user buffer
   320	 * @rc: Pointer to where the uvcb return code is stored
   321	 * @rrc: Pointer to where the uvcb return reason code is stored
   322	 *
   323	 * Return:
   324	 *  0 on success
   325	 *  -ENOMEM if allocating the cache fails
   326	 *  -EINVAL if gaddr is not aligned to 1MB
   327	 *  -EINVAL if buff_user_len is not aligned to uv_info.conf_dump_storage_state_len
   328	 *  -EINVAL if the UV call fails, rc and rrc will be set in this case
   329	 *  -EFAULT if copying the result to buff_user failed
   330	 */
   331	int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
   332					u64 *gaddr, u64 buff_user_len, u16 *rc, u16 *rrc)
   333	{
   334		struct uv_cb_dump_stor_state uvcb = {
   335			.header.cmd = UVC_CMD_DUMP_CONF_STOR_STATE,
   336			.header.len = sizeof(uvcb),
   337			.config_handle = kvm->arch.pv.handle,
   338			.gaddr = *gaddr,
   339			.dump_area_origin = 0,
   340		};
   341		size_t buff_kvm_size;
   342		size_t size_done = 0;
   343		u8 *buff_kvm = NULL;
   344		int cc, ret;
   345	
   346		ret = -EINVAL;
   347		/* UV call processes 1MB guest storage chunks at a time */
   348		if (*gaddr & ~HPAGE_MASK)
   349			goto out;
   350	
   351		/*
   352		 * We provide the storage state for 1MB chunks of guest
   353		 * storage. The buffer will need to be aligned to
   354		 * conf_dump_storage_state_len so we don't end on a partial
   355		 * chunk.
   356		 */
 > 357		if (!buff_user_len ||

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
