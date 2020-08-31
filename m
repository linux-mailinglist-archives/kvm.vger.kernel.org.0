Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323DC25791D
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgHaMXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:23:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:45343 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgHaMXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:23:49 -0400
IronPort-SDR: x8fWOLSEXn7y/DDcvAcfXsb8rVYC6sWPXSu2A7uQDq7cwsX8PkeH7JfWTBxIDOtl44zcYoNSgI
 EeW9CZJO1mDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9729"; a="154481121"
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="gz'50?scan'50,208,50";a="154481121"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2020 05:11:45 -0700
IronPort-SDR: FDDxWVn7v3rFNovZBjaIB1Y5zkQutVpEirzaObinDIPn0eWVckUushrxFMvoZtBR7bu/3LWpAS
 9b+AV/5xoBVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,375,1592895600"; 
   d="gz'50?scan'50,208,50";a="333321269"
Received: from lkp-server02.sh.intel.com (HELO 713faec3b0e5) ([10.239.97.151])
  by fmsmga002.fm.intel.com with ESMTP; 31 Aug 2020 05:11:41 -0700
Received: from kbuild by 713faec3b0e5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kCiey-00002C-JZ; Mon, 31 Aug 2020 12:11:40 +0000
Date:   Mon, 31 Aug 2020 20:11:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v10 2/2] s390: virtio: PV needs VIRTIO I/O device
 protection
Message-ID: <202008312006.Oa6I33Mk%lkp@intel.com>
References: <1598864986-13875-3-git-send-email-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <1598864986-13875-3-git-send-email-pmorel@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pierre,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linux/master]
[cannot apply to s390/features linus/master v5.9-rc3 next-20200828]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Pierre-Morel/s390-virtio-let-arch-validate-VIRTIO-features/20200831-171552
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git bcf876870b95592b52519ed4aafcf9d95999bc9c
config: s390-randconfig-r004-20200831 (attached as .config)
compiler: clang version 12.0.0 (https://github.com/llvm/llvm-project c10e63677f5d20f18010f8f68c631ddc97546f7d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:20:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
                     ^
   In file included from arch/s390/mm/init.c:20:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:22:
   In file included from include/linux/writeback.h:14:
   In file included from include/linux/blk-cgroup.h:23:
   In file included from include/linux/blkdev.h:28:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:45: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu(__raw_readl(PCI_IOBASE + addr));
                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:21:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x00ff0000UL) >>  8) |            \
                     ^
   In file included from arch/s390/mm/init.c:20:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:22:
   In file included from include/linux/writeback.h:14:
   In file included from include/linux/blk-cgroup.h:23:
   In file included from include/linux/blkdev.h:28:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:45: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu(__raw_readl(PCI_IOBASE + addr));
                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:22:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0xff000000UL) >> 24)))
                     ^
   In file included from arch/s390/mm/init.c:20:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:22:
   In file included from include/linux/writeback.h:14:
   In file included from include/linux/blk-cgroup.h:23:
   In file included from include/linux/blkdev.h:28:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:490:45: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu(__raw_readl(PCI_IOBASE + addr));
                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:120:12: note: expanded from macro '__swab32'
           __fswab32(x))
                     ^
   In file included from arch/s390/mm/init.c:20:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:22:
   In file included from include/linux/writeback.h:14:
   In file included from include/linux/blk-cgroup.h:23:
   In file included from include/linux/blkdev.h:28:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:72:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:46: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew(cpu_to_le16(value), PCI_IOBASE + addr);
                                            ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:46: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel(cpu_to_le32(value), PCI_IOBASE + addr);
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
>> arch/s390/mm/init.c:166:5: warning: no previous prototype for function 'arch_has_restricted_virtio_memory_access' [-Wmissing-prototypes]
   int arch_has_restricted_virtio_memory_access(void)
       ^
   arch/s390/mm/init.c:166:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int arch_has_restricted_virtio_memory_access(void)
   ^
   static 
   In file included from arch/s390/mm/init.c:11:
   In file included from include/linux/signal.h:5:
   In file included from include/linux/bug.h:5:
   In file included from arch/s390/include/asm/bug.h:5:
   In file included from include/linux/kernel.h:12:
   In file included from include/linux/bitops.h:29:
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
                           "oi     %0,%b1\n"
                           ^
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   arch/s390/include/asm/bitops.h:69:4: error: invalid operand in inline asm: 'oi	$0,${1:b}'
   21 warnings and 3 errors generated.

# https://github.com/0day-ci/linux/commit/76e649717b36f092b03739629b7a036fcc383ee1
git remote add linux-review https://github.com/0day-ci/linux
git fetch --no-tags linux-review Pierre-Morel/s390-virtio-let-arch-validate-VIRTIO-features/20200831-171552
git checkout 76e649717b36f092b03739629b7a036fcc383ee1
vim +/arch_has_restricted_virtio_memory_access +166 arch/s390/mm/init.c

   165	
 > 166	int arch_has_restricted_virtio_memory_access(void)
   167	{
   168		return is_prot_virt_guest();
   169	}
   170	EXPORT_SYMBOL(arch_has_restricted_virtio_memory_access);
   171	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--9jxsPFA5p3P2qPhR
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--9jxsPFA5p3P2qPhR--
