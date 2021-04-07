Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5D357395
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhDGRwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:52:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:57361 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhDGRwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 13:52:23 -0400
IronPort-SDR: VjQCOctKfEsTVBgrPyc4tMKsvLVGRatSh07ExKdH+Di8xAJ0P6aNALRqqRu2YBcCEDXBfptvdU
 paEuHAHz2jng==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="190159901"
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="gz'50?scan'50,208,50";a="190159901"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 10:52:09 -0700
IronPort-SDR: JJghOiZopRK8iZhUEoxm8t7GpWe7bqGTvhmbt/4sR5nJvyBoyxQWbWbcaM5Y3pMZV4geaYhROi
 912QBmLZiZkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="gz'50?scan'50,208,50";a="441408854"
Received: from lkp-server01.sh.intel.com (HELO 69d8fcc516b7) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 07 Apr 2021 10:52:06 -0700
Received: from kbuild by 69d8fcc516b7 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lUCLW-000DZD-36; Wed, 07 Apr 2021 17:52:06 +0000
Date:   Thu, 8 Apr 2021 01:51:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        oren@nvidia.com, nitzanc@nvidia.com,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: Re: [PATCH 1/3] virtio: update reset callback to return status
Message-ID: <202104080147.7sSt8rCk-lkp@intel.com>
References: <20210407120924.133294-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20210407120924.133294-1-mgurtovoy@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Max,

I love your patch! Yet something to improve:

[auto build test ERROR on vhost/linux-next]
[also build test ERROR on linus/master v5.12-rc6 next-20210407]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Max-Gurtovoy/virtio-update-reset-callback-to-return-status/20210407-201026
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
config: s390-randconfig-r032-20210407 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project c060945b23a1c54d4b2a053ff4b093a2277b303d)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/74d4580725028f138a4713e8594f9068e9c83805
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Max-Gurtovoy/virtio-update-reset-callback-to-return-status/20210407-201026
        git checkout 74d4580725028f138a4713e8594f9068e9c83805
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:19:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x000000ffUL) << 24) |            \
                     ^
   In file included from drivers/s390/virtio/virtio_ccw.c:12:
   In file included from include/linux/memblock.h:14:
   In file included from arch/s390/include/asm/dma.h:5:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:119:21: note: expanded from macro '__swab32'
           ___constant_swab32(x) :                 \
                              ^
   include/uapi/linux/swab.h:20:12: note: expanded from macro '___constant_swab32'
           (((__u32)(x) & (__u32)0x0000ff00UL) <<  8) |            \
                     ^
   In file included from drivers/s390/virtio/virtio_ccw.c:12:
   In file included from include/linux/memblock.h:14:
   In file included from arch/s390/include/asm/dma.h:5:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
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
   In file included from drivers/s390/virtio/virtio_ccw.c:12:
   In file included from include/linux/memblock.h:14:
   In file included from arch/s390/include/asm/dma.h:5:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
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
   In file included from drivers/s390/virtio/virtio_ccw.c:12:
   In file included from include/linux/memblock.h:14:
   In file included from arch/s390/include/asm/dma.h:5:
   In file included from arch/s390/include/asm/io.h:80:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:120:12: note: expanded from macro '__swab32'
           __fswab32(x))
                     ^
   In file included from drivers/s390/virtio/virtio_ccw.c:12:
   In file included from include/linux/memblock.h:14:
   In file included from arch/s390/include/asm/dma.h:5:
   In file included from arch/s390/include/asm/io.h:80:
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
>> drivers/s390/virtio/virtio_ccw.c:1016:11: error: incompatible function pointer types initializing 'int (*)(struct virtio_device *)' with an expression of type 'void (struct virtio_device *)' [-Werror,-Wincompatible-function-pointer-types]
           .reset = virtio_ccw_reset,
                    ^~~~~~~~~~~~~~~~
   20 warnings and 1 error generated.


vim +1016 drivers/s390/virtio/virtio_ccw.c

971bedca26e037 drivers/s390/virtio/virtio_ccw.c Cornelia Huck 2019-01-21  1008  
0db1dba5dfaf70 drivers/s390/virtio/virtio_ccw.c Bhumika Goyal 2017-01-14  1009  static const struct virtio_config_ops virtio_ccw_config_ops = {
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1010  	.get_features = virtio_ccw_get_features,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1011  	.finalize_features = virtio_ccw_finalize_features,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1012  	.get = virtio_ccw_get_config,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1013  	.set = virtio_ccw_set_config,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1014  	.get_status = virtio_ccw_get_status,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1015  	.set_status = virtio_ccw_set_status,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14 @1016  	.reset = virtio_ccw_reset,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1017  	.find_vqs = virtio_ccw_find_vqs,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1018  	.del_vqs = virtio_ccw_del_vqs,
971bedca26e037 drivers/s390/virtio/virtio_ccw.c Cornelia Huck 2019-01-21  1019  	.bus_name = virtio_ccw_bus_name,
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1020  };
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1021  
7e64e0597fd67c drivers/s390/kvm/virtio_ccw.c    Cornelia Huck 2012-12-14  1022  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--opJtzjQTFsWo+cga
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--opJtzjQTFsWo+cga--
