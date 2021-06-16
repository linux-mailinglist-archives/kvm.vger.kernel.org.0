Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8683F3A9B3E
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 14:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhFPM5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 08:57:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:38939 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232550AbhFPM5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 08:57:49 -0400
IronPort-SDR: 2hxxd5nD+EOU6PaCuNyhySVLuGf36C5gcGph5SWkrQrAx+sTkNl9LRApxD0gK86EEcr/WjH1+9
 dEOoQQGukCwg==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="270018716"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="gz'50?scan'50,208,50";a="270018716"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 05:55:42 -0700
IronPort-SDR: Y6fXVe7nkLge2k3LyShwCt8mMFLwGSBr1DgPkCQUgh/TANllVMbX84QG0tNe+t0HXveCn6s2j4
 6KqzboqhV/oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="gz'50?scan'50,208,50";a="554026010"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 16 Jun 2021 05:55:39 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ltV50-0001CU-JE; Wed, 16 Jun 2021 12:55:38 +0000
Date:   Wed, 16 Jun 2021 20:55:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>
Cc:     kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 1/4] KVM: stats: Make sure no missing or mismatched
 binary stats definition
Message-ID: <202106162007.Ut8IJLnT-lkp@intel.com>
References: <20210614025351.365284-2-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20210614025351.365284-2-jingzhangos@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jing,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on 39be2e28180a2e87af5fbb8d83643812e1a3b371]

url:    https://github.com/0day-ci/linux/commits/Jing-Zhang/Remove-duplicated-stats-definitions-for-debugfs/20210616-151523
base:   39be2e28180a2e87af5fbb8d83643812e1a3b371
config: s390-randconfig-r022-20210615 (attached as .config)
compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 64720f57bea6a6bf033feef4a5751ab9c0c3b401)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/2145147a4e85c8196c004804d103c1a3d7adeffe
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jing-Zhang/Remove-duplicated-stats-definitions-for-debugfs/20210616-151523
        git checkout 2145147a4e85c8196c004804d103c1a3d7adeffe
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/s390/kvm/kvm-s390.c:23:
   In file included from include/linux/kvm_host.h:35:
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
   include/uapi/linux/byteorder/big_endian.h:36:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from arch/s390/kvm/kvm-s390.c:23:
   In file included from include/linux/kvm_host.h:35:
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
   include/uapi/linux/byteorder/big_endian.h:34:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from arch/s390/kvm/kvm-s390.c:23:
   In file included from include/linux/kvm_host.h:35:
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
>> arch/s390/kvm/kvm-s390.c:63:2: error: implicit declaration of function 'STATS_DESC_COUNTR' [-Werror,-Wimplicit-function-declaration]
           STATS_DESC_COUNTR(VM, inject_io),
           ^
>> arch/s390/kvm/kvm-s390.c:63:20: error: use of undeclared identifier 'VM'
           STATS_DESC_COUNTR(VM, inject_io),
                             ^
>> arch/s390/kvm/kvm-s390.c:63:24: error: use of undeclared identifier 'inject_io'
           STATS_DESC_COUNTR(VM, inject_io),
                                 ^
   arch/s390/kvm/kvm-s390.c:64:20: error: use of undeclared identifier 'VM'
           STATS_DESC_COUNTR(VM, inject_float_mchk),
                             ^
>> arch/s390/kvm/kvm-s390.c:64:24: error: use of undeclared identifier 'inject_float_mchk'
           STATS_DESC_COUNTR(VM, inject_float_mchk),
                                 ^
   arch/s390/kvm/kvm-s390.c:65:20: error: use of undeclared identifier 'VM'
           STATS_DESC_COUNTR(VM, inject_pfault_done),
                             ^
>> arch/s390/kvm/kvm-s390.c:65:24: error: use of undeclared identifier 'inject_pfault_done'
           STATS_DESC_COUNTR(VM, inject_pfault_done),
                                 ^
   arch/s390/kvm/kvm-s390.c:66:20: error: use of undeclared identifier 'VM'
           STATS_DESC_COUNTR(VM, inject_service_signal),
                             ^
>> arch/s390/kvm/kvm-s390.c:66:24: error: use of undeclared identifier 'inject_service_signal'
           STATS_DESC_COUNTR(VM, inject_service_signal),
                                 ^
   arch/s390/kvm/kvm-s390.c:67:20: error: use of undeclared identifier 'VM'
           STATS_DESC_COUNTR(VM, inject_virtio)
                             ^
>> arch/s390/kvm/kvm-s390.c:67:24: error: use of undeclared identifier 'inject_virtio'
           STATS_DESC_COUNTR(VM, inject_virtio)
                                 ^
>> arch/s390/kvm/kvm-s390.c:69:15: error: invalid application of 'sizeof' to an incomplete type 'struct _kvm_stats_desc []'
   static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
   ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:42:32: note: expanded from macro 'ARRAY_SIZE'
   #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
                                  ^
   include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert'
   #define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr)
                                    ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:78:56: note: expanded from macro '__static_assert'
   #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                          ^~~~
   arch/s390/kvm/kvm-s390.c:75:12: error: invalid application of 'sizeof' to an incomplete type 'struct _kvm_stats_desc []'
                   .count = ARRAY_SIZE(kvm_vm_stats_desc),
                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kernel.h:42:32: note: expanded from macro 'ARRAY_SIZE'
   #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
                                  ^~~~~
   arch/s390/kvm/kvm-s390.c:78:10: error: invalid application of 'sizeof' to an incomplete type 'struct _kvm_stats_desc []'
                           sizeof(kvm_vm_stats_desc),
                                 ^~~~~~~~~~~~~~~~~~~
   12 warnings and 14 errors generated.


vim +/STATS_DESC_COUNTR +63 arch/s390/kvm/kvm-s390.c

    55	
    56	#define MEM_OP_MAX_SIZE 65536	/* Maximum transfer size for KVM_S390_MEM_OP */
    57	#define LOCAL_IRQS 32
    58	#define VCPU_IRQS_MAX_BUF (sizeof(struct kvm_s390_irq) * \
    59				   (KVM_MAX_VCPUS + LOCAL_IRQS))
    60	
    61	struct _kvm_stats_desc kvm_vm_stats_desc[] = {
    62		KVM_GENERIC_VM_STATS(),
  > 63		STATS_DESC_COUNTR(VM, inject_io),
  > 64		STATS_DESC_COUNTR(VM, inject_float_mchk),
  > 65		STATS_DESC_COUNTR(VM, inject_pfault_done),
  > 66		STATS_DESC_COUNTR(VM, inject_service_signal),
  > 67		STATS_DESC_COUNTR(VM, inject_virtio)
    68	};
  > 69	static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
    70			sizeof(struct kvm_vm_stat) / sizeof(u64));
    71	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--envbJBWh7q8WU6mo
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICNXryWAAAy5jb25maWcAnDxdd9u2ku/9FTzpS3vOTaMP24l3jx8gEpRQkQRDgLLkFx7F
plNtbcsryb3t/fU7A/ADIEE5Z/vQRDODATAYzBeG+fmnnz3ydto/b0+7++3T0z/e9/KlPGxP
5YP3uHsq/9sLuJdw6dGAyd+AONq9vP396Ti9HnmXv42nv40+Hu7H3rI8vJRPnr9/edx9f4Ph
u/3LTz//5PMkZPPC94sVzQTjSSHpWt58uH/avnz3/ioPR6DzkMtvI++X77vTf336BP9/3h0O
+8Onp6e/novXw/5/yvuTd3XxeTJ6vPz8rdxeba++PY6m08eyfLzYXn6+HG+/Xd+P7qffLkbj
Xz/Us87baW9GxlKYKPyIJPObfxog/mxox9MR/FfjiMAB8yRvyQFU006ml6NJDY8CJJ2FQUsK
IDepgTDXtgDeRMTFnEturM9GFDyXaS6deJZELKEGiidCZrkveSZaKMu+Frc8W7aQWc6iQLKY
FpLMIloInhkTyEVGCewuCTn8D0gEDoUD/tmbK3V58o7l6e21PXKWMFnQZFWQDHbLYiZvpu3u
uU+ievsfPgAXB6IgueTe7ui97E/I3VppIUgkcWgFXJAVLZY0S2hUzO9Y2i7dxMwAM3GjoruY
uDHru6ERfAhx4Ubkic/jNKNCUFSRZtfGus39dvFq9ecIcA/n8Os7hzit3fQ5XpxjaG7IwTqg
IckjqXTBOKsavOBCJiSmNx9+edm/lO3FFbfEOECxESuW+j0A/unLqIXfEukviq85zU39z7gQ
RUxjnm0KIiXxFy0yFzRis85hkQy4kBzMHU5AoqjWdLg03vHt2/Gf46l8bjV9ThOaMV/dKZb8
Tn2JWm1dtYDHhHVggsXGllKSCYrwFmbyDegsn4dCnVD58uDtHzur6Q5SN3nVbqCD9uGiLemK
JlLUu5O7ZzDHrg0u7ooURvGA+aaKJBwxLIio4+gV0qResPmiAE1RK8uErVXVlnpLqLmBitE4
lcBVmbaGaQ1f8ShPJMk2TmWtqByrrMf7HIbXgvDT/JPcHv/0TrAcbwtLO562p6O3vb/fv72c
di/fW9GsWAaj07wgvuLBTK/iQBYJkWxlqOdMBLAK7sMVQjI5jClWU2vrgjll+AOrb64GLI0J
HpFKYdXuMz/3RF8HJEiqAJy5BPhZ0DWohku0QhObwzsg8CFC8aiU0oHqgfKAuuAyI34HgYyF
BOWHw41j80IiJqEUXAid+7OICWleK3v/zYVd6r/cPLfbr2HqlBwSYMsF+Exqut2Io/sKC7Fg
obwZfzbheBoxWZv4SaunLJFL8Hkh7fKY6mMT93+UD29P5cF7LLent0N5VOBqUw5sE8ugtRN5
moK/F0WSx6SYEQiHfEuVqwADVjGefGnBQ+Q2vDH4NMHQwoiO/HnG89QQUErmVN9GmrVQsN7+
vPOz4yQ0bAl/GDcoWlYzdGcsbjMm6Yz4yx5G+AtzhSFhWeHE+CGEeiQJblkgF9a1kOYAh2JU
M6UsEL3ps8AMQypgCLfnTgmkmQS0RVAphrkHdMV8y1hWCBiJ5sRpKeuV0Sw8h5+l4fDEMRO+
Y1rlwVyOAgIA8H5g5sxBOeqicK5BebbEtXOMCRKbjaCZmxaEr2nrVS6ov0w5KDg6KQiWDRut
zlFFo7UyNROAgwU1CCg4Ep9I52lnNCIbWynhbFRMlBnqpH6TGLgJnmdwcm28lAWdkBYAdSTb
al0wHP4Bzg797FGuIFshLqwp74Q01jvjHP2mMoqmmeApHBC7o0XIM6VIPIvBDNia2CET8BeX
C+nEd/o3uByfplLlkmj2jSWloTnLoGuKwRYxVA2LNUq+Gy6FC7jgkTFFygVbVyGMAVXmufu7
SGJm5leGnGgUguxMHZsRCP/C3Jo8h1y58xP0thOtarAfp2t/Yc6QcpOXYPOERGZiqvZgAlQ0
aALEwrKmhBnpDuNFnlkmnwQrBluoRGgIB5jMSJYxU9xLJNnEog8pLPk3UCUevEmd6CkN+4em
PNotgZtc+x0k+50ZsRUefswhlggy4JfZDOEuR5xYCRrSK1ah64YvQfrGTRH0q6WG8YwGgdM0
qAPEO1I0oXitQQiEWYtVDHvjfh2dVWWWtDw87g/P25f70qN/lS8Q3xHw9D5GeBBBt2Gbk7ky
xa4pmnjhB6dpAt1Yz1F7bmMuEeUzPaFlACBrJHAu2dJplUREZi57ALws4wtkoF4ZhAzVSTsH
ARE6UAz0igzuM497TBr8gmQBRKOBe1mLPAwjqoMUJTMCjmJgoSqeg6xOMhLZKQsPWQRXxzFO
2TPlhKxMz66wNPcqNqLdO0iMCjt0gOlnqH5JwIgR/WLiB/6qDvmMk4LUeKkD6R6uThsXtxTS
OAfCsm4GsLmzhdqWbTXnQhp3WWXc6vIacSQHS4NLgcg47dzwJmbNQaQzaurc9HrU9d48BuYh
ONhmJeZCdMkrAiUGy3VpXc8IFp9iYcEQoQFStzI97O/L43F/8E7/vOqky4jCTW6xWvrd9WhU
hJTIPDPXbVFcv0tRjEfX79CM32Myvr56h4L648l7TKYmQaPpzRqcl6ldwDk0zu7y4PXErvnc
FasaeznMTm1V5naJAX+7zItNgCd6Dnt9FosneQY/IMEKaQvQwuGGensBqZ1j55ZehXQJ7+pi
xmTfuLvMoukmk0zlMDdXF41KcZlGubJcdiZp2oOAijrztS+4iGX3zsd+FwJB67ILCzJya4WC
CirB7ECmvbFKWHdwUO6zANTkchA1tUdZ7AxLtbi7GRsPD0u6plYmpQAFeA9XsKxUuHFvzQhV
pk34zMpaIDLm+ErgzlbQraE9NEIaxRajdYzDTNd0zvIp0xiXz/vDP93HAW3AVc0TwsOqLtC1
7w26un1GSEkgEF5sBCJB+cTNxVVbQPCX2pV1crsuUP0s5jk4/JvJZTP+lmRJEWwgKwUHVg9p
tmvtRteEP3FXyfRrwKxyur8QPmqWO67wYRu5uyRq81dTBm/PrwB7fd0fTsYTW0bEogjyODUX
bNG2Wdpt7blWu8Ppbfu0+0/nwQ5cqqQ+JLSqiJmTiN2pKiEIjArrtqfDltGPYyecpGkUgI4p
bXJLBDx4sdikkJOFruxdP6qs4o4/AghWy/1F//1HY8z0xoQXkNfbtdsG20uLEEjEJvELlW46
oAX+6WCFIRnGQ+tCBSCYxdoMViHrPSnhApMVHEAAurmkVrWsoVipKrOannErZ25IIJSyU0L7
YK2FmFVOHKuOIweAzHjkMuyIbzWj0r2ObukyZfn0eCqPJ12dNIfnyS1LsCYbhRIYOS9DO9p6
edwe7v/Yncp7NDsfH8pXoIZcxdu/4rzH7hWx825tU21YHb/CwWeWA1jqSNMhgd/h3hWQSVAr
1gf7IYHPkm6Ec2PmGdEwZD7DJCqHTB3SdSw5+Vj979hFTNnwCRT0tZjZRVB92N1wWEMzKt0I
DS3gboedekpVX0jUg1ZBs4xnrgcuRWbVOtpnNMVxYXldhYRUBYtHks1znou+6CFUUC9L1cNz
RwRYig4h9mfhpq6W9QkEldWzn6M0IBobjw8IhX4h79BNJ+BbQNxwiEVYgLgh+OjuUcRFzIPq
wbor2ozORUFQqZWv0acJ1q8rqapiYIJUco7jXXBV1dQ8K3vfk7ulj2ewjpoK5JXFnMgFzKHT
IkyOnWh8SHmHBKyO/lvvgLTO6CeNXvVKL7W6BfpwVNbdoajG6a6BAVzA835soapDWC7Wz651
J4JDVIL6GM+eQWFAJu3ifIVxXPVI8voR0+R39hlxiEJdEJfigzBAbECMNb4f4AOXbuDuJhiE
oU1a5HPqOAAtBx7KIgC+mw4WbkYdylGfheYLH6DyCKwOGjMshqIadkajW6ZruIFge9R7uR2/
KRqcGnFAwm+TLkkjETVDHcP2LmnEdMNLU/8wIscI6yr4TgRxYSCM1hGOLShsLnLYWxJMewhS
G8luzUtbFTyZIU+glr2KSWrEn7XPbqBnB7fx+lKbCR6GYA5dAb1F0I+0W6WSYJZlnVBkt0Zh
+gyqO1wfu3O4hTL7gZZmbdHle5tJdCrhZ5vUtYNVIHiBYedQHakqi4KWWyXXuc9XH79tj+WD
96cui74e9o+7J6sPAIkqCTimVlhd+KNVgbvZYRfnDHzOrcE6fmx5wySaJc4K4juRUqMecBz4
rGAGC6oCL7BU3ParVbfYKsLoYwTv7ONTNXGVvSuaPOmW2a3BGu0e3ne4g5641itQTT/z+wiR
+U2/mX0yNQGbO3OUCl03QCmz/kOEg21eXUJnu1aXqHqV6zJBFb7Ft1ihu06qR9aCxUrZ3YxV
KAg3QC5uPnw6ftu9fHreP4CmfSs/dA23auiIILAzH9dneF3Nn8sCjLO6TYXtixAlfMHgXL5W
eYOBqd/CbzH2slH4dDoTcyfQauVq31klnWdMOp9gK1QhxyNThjUBVtXdTwE1BYSnXMqBcr7a
ShxgpUUHGpm9htuZ7M5a7ZxhUw6Yss0Q15rM56LHA9gW8dczy0YzF7of19W5YLk8Ja5ED9G6
wbQ2tFbY5EQXIShA1Wqhq+Xbw2mHBseT/7yWViao3kvUIBKs8NXYef9FwEVL2k5PQ2aB2ypV
Z0ZzvfFXFROpxFtXdHjbLmMkj0DHeFUxhIxENdk+O5DLzcw85xo8C40QH34U9QnWXSXtEQBy
qGeiLQtZi2yrNnWbHKRGzH5sIR3XJ5Jxx1NVJydSbPDNNvZdHqIoZoszRO/w+DEGdlfkIIkg
q240bJKhOzm7GE1wfjkVzfkFtUS9ThKTVjVUn5WzovgB9OCaW4rBFVskwyJUZOdEaBCcX857
IuwQnRWh6uI6L0NN8iP4wWUbJIOrtmmG5ajpzgnSpHhnSe+JskvVk2WevHtDmuiYSI7lkiy+
NUIo1XuiBusMzLR84L0hHh9AqiUN4NqkQXd2wD5ImpoUbT+cstj07/L+7bT99lSqL1Y81bNw
Mmz3jCVhLDEN7MzSIlStzhANgOyiIP5S5Za2mxFG9To8K47CzxhkIc8dcNUbZ7DsFuyH9mI+
psTbl+338tlZ42xeTdppVK+r6nlKITBUT2hG9tU+wqwhpjNjtBa1gv9h5tl9p+lRdAsANFYh
oXqsKfr4kAhZzM0IUjWOLilNcSx+bWIom27hNxuWzaPUa6upqrfE3uh34NWOrHjaJqgPnycD
D2juxYBkuVVkG8SINGKySKWSm3ohvXCxrsjioCLtVRpU/cHV+IjNKxnFS21VmWI2zzpy9VWB
tqiz4ZoBniUJgqyQ/bffpYgdc9ZCU0oEx6qG31yMrq+MF2ZHtcn9qhRRiAwJhE1OdJjBqrEs
7upQVW/JxvsUGWxLbXCh2SQKQNUpaINg0UTcjK8tpTHKYg72dynnUWse7mZ5YD663E1DHrli
3ztRNWuZxBVMmTCnTED+NMvsUqpqOHU10QZ1hxPWwpZaR9oAnWZYPMSZXDkk3OVCWulcY8xT
SXUdsGqHsl9UHSbN+NCEDr+atK19+m20/Gt3X3rBYfeXFb3r4rnPrL34zHU/fB+fhJ9NuhhW
bZLqNMb/eL89PHjfDruH7yqNaR+ldvfVEjzeNdC5rmYtaGS5NAtcpeAfzBNcyTgdSNrgNJKA
REP1B8gKFO+QgfMGXdUf0PX2E+4Oz//eHkrvab99KA/tisNbVcixHHANUpoS4PcIhusER0Ka
2axttOPUG4bereMQWrq6zmHqTHelja6pmgem5YZnbQSIWW/T7mkIVsHpKqNu4WoCVOpqdKEt
tlvUcfEVctNljh8/Drz2KVb6rbZiqMoupsbVcHqeU/MxF5bzc8k1n95bGqJXeQQ/yIyB12Cm
/8/o3PLL+nfBJn5rnSqYSGPWA1rBZw2bGoPxpU8sSKa1JDS1CFEhhSy/aeS2C5b9W6QUdfZ2
9B7UPTfT8wXDHgrDn2mA0XtasTaHN6JKQMOezV8F6CeaKhsY40c4NaIt4Sp6loUVzqkaiiif
rc/RxNJl87nV1c5DDNvlgEoAdslnv7diAIA+IpMBqG8WkaHiElyGfq0sySEQhx/DmKL+1rP3
QHyXkdjwdfALPZK62vj1QRZZAZeNx/KmU1Y9Nj9EdbHwf4Duy4Wr6dCiufnw9J/9x8NT+aHD
pPmyaIhDFfq5vGst0ojztGefg2wWeA+7I+YG4HXK++3bsfTw2zMs5u0PHkM/qYc8lfen8sGs
rNWsYQXuqCrIeFykS+kHq75vEJ/wc/9vT/v7P6u74z10XWw9wzq1jjvwhUC9Mc0bES4912W4
SsnUtAmkFZ7odjohtNOxoUA6xSFy0YGHZAZmUHSh9resK/Xhezan7s4TayU6F9sd7/tmSNBE
8EwUERPTaDWaBK0gSHA5uVwXQcqlE2jbXPBe8ca2rrCH6+lEXIzGLRlYz4iLHJw6mBX84Mt8
EkkDcf1lNCGRYduYiCbXo9G0C5mMWki9CQmYy8uReXQ1arYYf/7s7nesSdT016O1uyky9q+m
l65bFojx1ZdJuxh/olrRq943yAxBT/vdbxpeEDm5MISjgRGdE3/TA8dkffXl82UPfj3111dG
NKOhLJDFl+tFSsW6N4LS8Wh0ocRUZ/H2MvX31eXf26PHXo6nw9uz+pbi+AcEMQ/e6bB9OSKd
97R7KfGK3+9e8a/mF5z/j9EunayUTHEmT6fysPXCdE68xzqketj/+wXDKu95j8Vl75dD+b9v
u0MJc0/8X40OTux5IBh6poaTpP6CW6HzKiUJ851XyrpA2sr4gtXmpXfC6rUo5kYrUEZYgF/0
W5+bAJX9y/4qQkEqm1lbGTVtNZ9uY/0FpPjnv7zT9rX8l+cHH+Esf+0bOmF+DLrINEya228o
XTFuM8T6qLiB2r2i5vKbO2/cWIT7+C99EOtLHwWP+HzecTQKLnyS6EC0b+9RJLLWrGPnFETK
XHIvBP4TJAPwiM3gj86KEYH/CITdGa5RWdrwavv/OsvqbAiif/UJx0CTLerCwqmKLsVr4sjA
5aFjlwObqaqEESGp3/2vnyp4dYpisAZR0elcAWJrBuk76baV1CsKXIUX7dG0s2xEL30wZ/qp
1oJhBwLjNixVF6oBYWCCsU3FuEUkq7jjTosUVtZTLPby+nYavOMs0f+qTfuJPQLAgAfOz30V
MgwxoorqFNHC6WreMnYWgzRJTGTG1khSm8X8WB6esJF9hx+5PW4t/14N4pC+WmGyDQexkXw9
iBV+RmlSrG/Go8nFeZrNzeerLzbJ73zjmJqunEDUvGdT9L0CSUdkS7qZcZK5Y25jjYMCheUJ
yeyCZA0rSELAGjl5tzRT191q0YHvZh2w83x9PsvIOc7zcOJe9TxjLgWy8EWctrehxeQsiiDe
NwpiDU71gBNfOqcULKDYD+2sjjRUMg6sSmDLW7XQnJfHLX6U6/x8sSGJyZxGEUncS8R+Ep65
PtS0aWbYV9OXjcD6s1kOaLd1ywL44cDcLWiyyIkDQ8TlaDx2TIPXJXceTigYuZr1rYZqaXWW
RjWa5/g1B17Pdh0GEDTx85fP1ybfPhbjMPeHVhap658VsSgyMCFjO3Ow8DKmURGvrajEIsh5
kbK1z1x6YBLO8sl4NJ66p1HIybUbiV9jYBcl85Mv0/GXAaLNF1/GZHwxGlqpppiPx65PqWxC
KUX6f6Q9S3PjOM5/xceZqm929LBk+TAHWZIddURJLcq23BeXJ/Ekrk3ilOOund5f/xGkHiQF
Or27l04bAN8QCIIAqB0QEQLjpAn89NMapuYqwLmcaZk48i4kJb1Lq8Q01CSpcVmmEK3CLGw+
mQtBNLJlKSRNBOnucORy/SWt6RpHrooiThvDGJn8SkrTAO92DMj+nfrNZyNIs5TxlqEVsGYm
9ziO+nQ3821TF1br/BsuIJXJua+Xju3MPidkUvKztcgKnJu2YcQOkdvAsuxbBEZmYwdZ2w4s
41BJxGSjKTxVpiPUVsM/MaIkW4KrbVpODb2hK8d3DZ854T9MojHNkybFkpEoVdzPbMc01DLJ
CbgJf7YU7DC/rL3G8vFu8v9XPNLdjN+muWkgPyVRt3EdzJqmXVe0Hv7/tHZMEbsyKcQXQpK2
T1pldI5lNfqRYERhWF2BnBk7LND7NMXNsTJtRfa1IcOP/BmzQ0mIa6MqGdW3VIyqth3XyDy0
Jkv0VlMhagLfM01OSX3PmjWmBr4lte847ictfOO6G95CVdyRdrc1bMXpV+o1BnH5Da58ZYnd
6vNawiYBZXqKPcWNdy0B1y2isORNGNWlBdvVPUtvM3Ebiw2krtlh9lWvmZAwmHrYPi/wqxLM
xGx/Ua/yJGScRAWuO0tEm5QdCPQj031Tf5mPu7Tmf4z1ldEy8GZTfZTllgz9HGFE+69Iz6oC
chmCoQdGoZPE4cwJLKZGlDWYtUd9DeMmc28uHWMSx59jh6Ee7zt+OK46IqFr2krazlUbx2fy
pe3dZ5S+h1EidDNpvC26IulUk2McpN5dAoSShQZZWlLITgcRAlSjdOLWgKrT2/YI4ugQV3Er
b2F4hoUWiS2KQHleZ7C8O1weubEWgsN1Ax0fwg/lJ/zbGtEVcJYuSqqIQwGvwq3Bsg9YVoSY
Ir4FBedhRoaSrE271CokiZZ1poXsc+p5AQLPFKM7Ni29vzRmdxLWj+fD5fBwPV7Glzm1HDSw
kdMtF4whskT4LAlvNCpTdgSSu9tWgg3hXLWEAB/BGA8kWOdpMw/2Zb1TjFziYoOD0anOYibZ
uWeAHkkzGOrg8rZGXZTuNtEoPZY4SIh4C/myXYJHdcVrVJeyvdsbzUtakkWbqlAYRJahvPex
2dFTWvSgwW1/uFXqcRBSjjqibYRr5PDZhdt2lPg9VZivRPoIni/NcDH6oPHQ+HK0zl1nJqX6
EL85h8nKgoAa3HwAi2ZgoVFWqszKIaPJ5tBN7ThWSy0Zx3tMWwpjCAIMsRmVK5Zosi4I6q/D
MumvWfhUwZ3K5Ln7UgcL8FBlV27P9jB8E5NIPHSZNySS7hPgl3Ddg+jP3uBKipzf1VeKAISq
N2SNqQ5NmmU7YPtXHQIuGpIgGouUXpIL7qyrNa3VPDcKBnIr9i5XwnjLdNuxuVze6NiPPbfc
tl6zw27rROaUPBzJk55tlN2egckaO5sDpnVSA8EifckOOCCuF2qPmHSUnVt7UHt1qrcpcODb
sjZ4JzIi4ZHVWmeU4gITZivt9NFtAtIk9hXKvkqqh9MdVX8o0ys2YppOHs5v18v5pQ0WGsAv
J7illTkbqoC5xpwOS0Wws5/mfKl12ZILL8SSdm2NGQTqiTKeVOKey69hPBKKbxMoBjZyuaH2
ZYjzRW5LYOuSdQPcQzRE8sZ92cu7HdM2eH6gPKnh5QHwI+ZCldYhKWHfu57ZOI+T6/Nxcnh8
5PFahxdR68c/5LvwcWN939Mc9h/d7W8AD1MsQHsmGxyXWsFIsldsrB+Hj8n76e3henmRRPqQ
KtpA0uspbPqUmMQWwP3ewVGlfRfBGxI9dxRDFhvNEREIMOUJVK5IXAENLmcdcL+xTWVI2Mxc
bl/r5Qxv4vj3O1ssZQ/j9GFcMl1MMu9ItVgY1Gk0aBmFc881QLUM+D1mptctTlzKUZvD6zKN
nEDPmCYJAG10wpdnGY9HPTgqjLFy7iSBexxfqIn5Wq0qpqbheSLFLBURBNFK+wdacc/ixZb7
oCrx/BKQpy8OK+VaCbyXCEPwnL2Q9xQTQbwKCPfJdnrFAjq+yO48TMOY7T1hzfZSTJHkDq+8
ItlfAi6QK85Oli/d27TV7KOtY9neGB5TZya7B3VwulBOwl39DIxdrLeFFl+dWdNIF7UaQrfN
6ei43q/LOGQDhCm+0RCYaGeWermh4fDTUjcORhTMLcx01FFkZTBzZpLfVAtvZbhOXbu+Z2Pw
aGr7TjauJ04gIVjBu2JPfc/HpptNzNT2ML1BoZhb4/oB4XgzU60zF9N8JQqPtYvW6gVzy1Cr
Nw8w9VGm8JsG5SuycKf4tUC3rqtwvUpgQp35FBO/XVVVPZ96HtL1eD6fK6bGu6Qicp6bFiDS
TNFa8XHscAnPj5vDMRG+wGK5ZCuZhYzt6B+WdLZoyQsssXuHBHWZBx/VVaoqLB1FF+izKsAV
Kin32xR1FcDoeaZ97in+Wc0i/xFcLd+oelQlgu+7iLUIBAt4Fgr+wQ9kEuXNPrEteFklX80r
mJC1HtQmy9auXM8K/KWbuJDCtzqIZhDrwXmxDXeF/GZUjxI5zkVC99ELDT1VUYKFm+lrUIk1
QndhUXwD3B6uD8+P56dJeTnCMyTn79fJ6sy2sbezrFD0hcsqaWuGuUQaVwkglxoyRI0oL4ry
cyrunyh/4RihzHy55pv9k8VEO/r8mMKVeOxYv8ivKFhqSXK1T9MKjlDjsgRu+x0brp3k4cZp
uHKCoC+A2yaTFfAnqsNU0egoxkC4y1WWVspNAwRvAYzrJJgzcBV1pnzl7bJ9nvQI5QgJOck8
zPqvkvifkXzZRLfuENiXXuS7vgc/lLI0zHc3byCESCql4gOGRMn+fhGjuIaUhkGnpMg/HzUh
N2n4XHMXchRNEsYq+4hNfBsSPjoxrS6H9+fTw+hsGJ3fPs4v3DX5/eXwo9Vox6dV4fIe6VYr
Bcz+ZmuS0z8CC8dXxZb+4XiSMeaT1vuII7334iifxuOOMqBkGEjjQQmtqyRfqa/BMLzJnr6G
2hE7G6uxexKpPZbR9+PDiZ0IoABy0oAS4ZTpZ9g1HEdG1VrRY3rgfont+BzNdP5kVGZdJYbg
JT4RSXaf5kZ0xPYxwxtdAp2yX6gtGrDFehVW6sSTEBIE7PReRpxZTfXsREChUhFbo1WRV6AK
DCEYPYxNkmSAZuQJoQBTqkgy9nERDfbtPhn1bpWQRWrwsOT4ZYWdJTgqK6q0WGud36SbMItT
FcgaFs4WKnSXqIBtmNXyPinqS7ZMwKWRCl7tWu9jBZpGYTxik7RGDcgM8yUUl54Keb1N87vQ
zDf3SQ5prGo0oB0IskicL7V6M/zVDY7Ji02hjiQrVil8Q6NaWjj8KNFtrSOQ2QSA1ZowbaoM
Y2eEWs2n1gi4vUuSjI64jYSrNOJetzr3Z3WlXqAL8G6ZhdQkC6pEMPaoWApPJTINw1CO7TFM
yCU7rQ8QdIUwWl5r/Mh2DNlVC0BMJwLNlvG0JE8l4GgiyqQOs10+kmQlkxtZZFrrMgshcXGu
XB63iB0/O8k8LQHH7VcpO/2qldAwHQ2MhoSu85UGLJME0kbptHUSkhGIsQGT/wnVR8qqLbM1
mhIblpabr1VhAp4fITVKQ0rCqv5S7KBWSdGUoKNZqNNNMfqCi5ImhlxpHH/Hvl+TVFvDDrkv
qauJppTpNbXG802aE+27/caOtWr3O8io6992Mdv1dBEWZiWV7W/YbttbR1GNgN+KAJNLe8IA
GzwlFUukXJNeqD3FDXfbCO2aLvbFXZQyFbqus2T00gthuxT3xH/VIb0lT8oqQ68nCO7UTyJ9
kXXOU/WyrXMtJ4khtKyKfRdNMmiLVMBGSqLc2N354wr6WXt/Mj4G5cmWB39IUpL9gtea5f17
gO253JP7IeG4pGJyosDVX0654E5/OeRVhIt5uP1NxtGwsK2MJoqXD8PadmTrloDmruV481AH
U9efeiMoGD7d0Rgy4nouZqwasA5WyDcYFnv83MHMdT3ashutg8JS7+BQzdzIURykUmelO59O
EaCHDKL0LMNFcIf3mqZ95fMWWRD4uOfSMADvRjtA4Lu3CLZ4aLXgrNgJrFtLUbveHHfz5Pg6
CsG30LRUdRZ5c1u1Vfac4f1tKnZfxw7jAG0hUuray8y15+PqWpSjLoj2VUDSqsmfL6e3f/5i
/zphYmpSrRaTVhn7DjcomIid/DJsFL9q39UC9k0y6g3JmirBLkk5lr/wpxepmbgka4RbZCK6
Iq4IRRCZUV4OH8/87rI+Xx6ete9frb+qp57lmdexqgNPdeLoJ6++nJ6exjKlZjJppb4iK4H3
3b2uNswWWzBZdlfgzloK4V3CdvxFgjoJKIQQ/peprtEKXvFqUDCQkmqjJGJV0K2YwLs3pN0a
Td3pnadL+5hcxfwNTJYfr3+dIMgZLun/Oj1NfoFpvh4uT8erzmH9dIJLF1x+m4YXsunWZXaH
7Ix8OA5sBLmhJDx+psvNvkuqr454RiDlqVyws3JMwtaOI9lQetj4Ek/CbUZOByLzBAlbS6XE
m5C8JclXqZzLHmDtsyJ888yTTO2EyGXSDUSEkBO6UkK0lzTbJ7GaqQtcw7J9yqA+7j3ZwJN6
DdPv8q9gJStjgim8XyGO4g6q2ZMVkZZ4QEg68HJfCkA/CdHYqUME59bNHm+RQdV8WMO08fj1
Tgdj4MV6iaTzg9ohMFfy4tpq78uIsntISiQyv+5GuG7RVWj3JIlyymhxTB6U+ItEWlf71Vw3
cUpL5a1buMpi5zJJB4+n01lgjZ7kbuHSBxDFjqTisQ8ryVp9jKmklCpPEQisuNxucXLSqbYX
bBOBNPfGa9aOBNsVJLxQMYe8XbJuswbHhLjagPkOHBmkaQVUDLfwAoX2Ap7/wRHwaIPwUsSO
fr0jZLcUXc41cAWA5PrtM07gbCCSz/QPyyhNcHy+xlrgUfqAVMqI2P1If4leQYNRgbZnk9Zj
dXwoOD1czh/nv66Tux/vx8tvm8nT9yM7G8jugX3WiNukknNClewW6FGZcV8SK6ngBMScDLBD
t8/JwrfDH09Y/OFY0+AGGQkbmdIaNQnBFzeWtqVKadgRyV7IHFdG2UyOfJXAzhQZJEfgjy5K
FOhZY8AHtoO1GNg+1r9ADvvswcQVHVThISkzNiNp4VgWjNtAUEaO69/G+y6KZ3weWKpHgIQw
uGG0KxtGnxFQ2yf2JyRWAB27wWdQC8aeIQ0MwRdSyQB9bHAg8KfWeO3i2gnk8EMJbNvIXHEE
Fiso4z1TQewYI+GdBhs8Ia6DqqctwTLz1NcuO34AL6y0sJ19cGvqgCxNq2Jv3/w2Ip9tcyuD
nO6+6TLyHVxP6RqLv9rO4hZFDilW4MIWjYNSiQpk1BxFUF9BjcL24xE7MFwWLsoI/YDYlxuO
izBoHKJSgZAU6yFDrG/1j9trvrqj5qnnjIVM4HhjUcKAHgrcI6O6F3/BX1MfgiySbomjEa6b
RmT0XO9CBk/rsE3WIyyObIY+roen09uTdOQU6ZseHo4vx8v59XjVHBY1jKB+O7ycn8DH9vH0
dLqCY+35jVU3KnuLTq6pQ/95+u3xdDk+8OcVlDo7bSSuZ668L7SA3rlObfmzeoXyfXg/PDAy
eJjcNKS+tdls6ssNfV5YqOS8dfZHoOmPt+vz8eOkzJaRRqSvO17/db78k4/sx7+Pl/+bpK/v
x0fecIR21Zu7rtzVn6yh5Ycr448JuGg//ZjwtQeuSSO5gWQWeFNZLLegcT6KnpdMtbZe0h/n
FzD5fMpYn1H2lnGE47WPQ/gidJ9I+PZ4OZ8eVSYWoK7ciu4hyxmcECRlPU/pjkKKIPnzJFxn
LQikrMgN8cnLNMlikVt0g11p8Ofn5FSZ7Eeb1lF5LqcjBE+eMlSTzcP5SKukh4FWOZ8GniKo
OhxNPXdqG1GeEWVPTZipESO7ZUuYKI6SmRxcr+HmDt73iDIJy06HpaY4dHjNwjom2ER4xcu0
gRz4RA8XgxcI0GuKiIcX0PP3CxrNBTY3xZYhIFoCXtYyBecmIh/O+DUr+Pbvy7T2pyL/TCeZ
sFYl3gzTbFEYAnsLeHXR5JpTHV/P1+P75fyAGS4hoXEN8Ti4CEAKi0rfXz+e0PpKQrsTJV6j
UnIoSIt1Hm/TKhkNgLK+/UL5I8iT4m0SPZ/ef518gBH5rz5L8LAzvrKNhIHpOcLCNjC0SCx8
OR8eH86vpoIoXkj6pvx9eTkePx4OL8fJ1/Ml/Wqq5DNSYdP8B2lMFYxwcpxNdroeBXbx/fQC
RtB+kpCqfr4QL/X1++GFDd84Pyi+l938DbBOaDfwdt3fpoowbH85+1Oc0JuGSOd821vaxE/M
H7Vz0+UupimB1zKKPE5ImEsmLJkIXmMtKgIPVUluQzIBeKXw12BQNNxQcJ9hxQAnlw8pTTfj
z6EbxOjGdBiveDVx6HfS1BG/+Bbs8veVbb43ssEJcu59/AVPZtxSLGnI9iLlPN1i9FAlHc92
Mdf1MLf+lqCsc0/JHdHCqzqYz9wQaZISzzOc0FsKuDQ3xFANFIxT2b+unBNXf0k4lWV6Cvko
tOTmA2wfLVCwYvVW4a1hXfbyHPBtyPia4O6ljPB+mS4LNSk/gNsLBSQTeypis9l/5bctpDIj
Ut48hS+gJ3HU3tJt609q6CTDo5UPvew4GD/u9AosZLuQtv0WoEbHcuDMGQFUqgUJp3IUm/g9
igIiEeNKbkPFPSHj0EHjSuLQlQ11bJ2rWNaSBGCuAWw5eQrMWy2a3rthk1IDDvxIOnzfr/uG
xnO0x/dN9OUe8rvhrr+R66D2QELCmRK70gLUWQWg71sKIJh6jgKYe56txS60UB0geQmRJmLr
4ykA3/EUuxOt7wPXxpzLAbMI2/zW/8vReThpWnO7wgQaQzlzW+a+2Vy9XU/yTZIVZdLHWWEH
i2amGuPSPHSaxpAnECKPpjOpUQ6QTw0cMJdixiC0y/VdBTD31TZJVLpTB5vPPFzPAtm2yG/V
NrCFtPc9UjUcB/HW+1TrPkKywUc4EDC8NC4a832LP1UKUQuymg4YK7DlVGoAo7bVmiv/UzvI
8nJ+uzJN6lHOEgtJVBL+Dres3o9LtOrq+wtTXnSfbhJNHQ8/kw8F/gtriK1y/E9aQ6Ln4+vp
AWwcx7ePs8b4dQYP/Ny1iXLQxRQ0ybcCIerlauIHivSF36osiSIayDI0Db+qQoMdPWaWnNyH
RrFrabkcBUypWIDaRIlSXpOcphW4gtJV6aqZ8EuKysTNt2CuuPqNZk4EFpweWwC3eERMbT6/
yTowTiBzGKF9ancpqzsQ04ikykJJthUFJ85WtOxaGndjjNT2G7ULOK5dotasJhiM8dpBfA8m
aepZhst+hnLRDZYhplNfFrOeN3cq/na1BnUVnxkG8ue+IYMcf5whDuUbdzqdOooZjfiO6+KK
J5Ohno2HigIqcLDgUCZlpzPZSlLz2yfPm9kyb92czJ4dHr+/vnaBLzo7KDjh7QQZ/49vDz96
c+a/wTsrjunvZZb1QT3cVLHqEkL8Hp8+rpfTn9/BXCu3cZNOpI54Pnwcf8sY2fFxkp3P75Nf
WDu/Tv7q+/Eh9UPJA/Efluzfj7o9QoVNn35czh8P5/cjW52R4FuQle1jjLhsQurYliV/EwNM
VyhJuXYtzzKwX/strXZVYVD5OArV+NJ6xU4xeDIE8wiFgDoeXq7PkhTpoJfrpDpcjxNyfjtd
lfNzuEymU0v9LtgZz7LRG8kW5Shuzlj1ElLukejP99fT4+n6Q1qdrjPEceUEAvFdrSoyd3HE
OoY5vzKMY8lq911NHcfWf6si765eO0r9NGUbEZquiSEcZQ8ejUJ8uuybuYKT5Ovx8PH9Il7H
+85mRX50h6S2r+yZ8Fvt2bIpaDCTzzUdRGfEe9L4mDRK880+jcjU8S0lk+MA1WsCHGNr/1O2
zijxY/lNFRWObis9zlUukG7Ml/CxPD09X7HPOIy/xHvKzmbolrJu7G65OlgGjItvTRnbBizs
bp8/h6PkSBEP5MirF9KZ68jqDTyzIxtA4LesIkWE0QfqBT0DGXYihnId/IgXgas37rYKKN/D
E8g4YWlZisu2gLEpsCwssLDXFv6/tSdpbhzn9f5+RapP79AzE9txlkMfaEm21dYWSd5ycaUT
T7drslWW+qbfr38AKEogCbn7Vb3DTNoARHGBQBDEQkWHuFuIjRkyDEEGfDP8WqnB0M4CXBbl
6VjcSpO6HNvJkZMVLN+ZmHIShBKIMNs9pIFdSUeeXA1G/ACaF/Xo1H5bAX0dniJUlAWDwYgd
uPA3N2bAGXU0GtiKZ71bruLKPRsYPSGoRmcDWW8i3IXMG1bNp3MxRy1iLnnaWQBcXNjpdKvk
bDySBrqsxoNLXg5rFWSJO9MaJmb6WEVpcn46YryvIfwGapWcD/jXcQOrAVNvaUy2ENDeZ7ff
n/bv+sgviofF5dWF5OtCCMvYoBanV1cD2f+nMRulapb1iERAgRCyDCXBaDy008Y0MpCaof3+
6HLCKXJ8eTbqeaGhKlPgMaEAmIbbMnirUjVX8Kcaj6xNTJxGPcEfD++Hl4f9v9ZRlI4wyw0/
IFuEzR5493B4EtamlfkC3rImYvIhMtK3lkTjZ3/yB140P92D3ky1tthT81Jf6BkDpbUDUZ7K
clnUMrpG53gslMPQ9uphqgyDFFUzuYfNJvYEOhIFI9w+ff94gH+/PL9RsjRpfn6H3NJ3X57f
Yds8CGbW8dD+1kN0NesxGMK55mwk2YjwXGOJfQSAxGBSpUhcrbCnb2K/Yb64fpSkxdXASJme
5vQj+izyun9D1UFQJyfF6flpymI6J2kxtM0V+Nup4pfMQUYxqRcW1cjSLAurFF9QDE6tLzEt
kgHXYvVv/wCRgOCQN4S0Gp+Lmg0iRhdfXOXKCY7nUKcEwfiM931eDE/PGfqmUKCHMLefBuC6
/XhT3ulqT+gDIjK1i2wW7/nfwyOq0cju94c3bdTylpL0iTGvopjEoSoxjDLarSweTyeDPmWq
kFP1llP0N7J1oqqcnso7crW5GokFTQAxtvdGbORS2hhhzxw5CuoqGY+S002vU88vZur/17NH
y9z94wtaAOxvq5vnZHN1et6jtmhkzzLUKWig55K6ggjG3jWIXb7m9HsYclaUOtnaFdcsBzFm
bzcJjzqGWKe+A7mF1Rnz60B2/EQKijG89MPDMGLg7sfhRYg89hNFqmQ3jeWF99phCjQlD4Qf
dZkniZDquJhvT6qPb2909d51wOSpAjTfym1qNkq8EQ+UX9622L/+/fz6SIz4qM/+kv//MTI2
GFV5L+B+YmamsrDM41CcKteHLFQbLx02wLofWZNamv9sucQG4pVFFVLYv7ZirLGM5x1JNK/u
ZW3FPcJPdDOqczRqxqJS11LAy3c86TsgKFmO216VL8sgkjI/S2RipKBEOKWq3uLkCgPumqCC
pIJNjVf2hB8UHU4FqPMwsjGpqmov9SFDzClNcfdCKoaZS75luqZwEm26VMxMSZWcn0ClBWVp
dnE1lAaBWDfQEWFp2uMqJb2tu+uA8yYvnBnn1p0i/qYa6D0OD1USp1Yad9Js4d9ZFFjZ7pcI
d8hIAQ64hwm6Ttq/dEZarnrZ/iba3nx4AHFLcoJt0iuFmzJsyKAqUxXHkq8kurspS+hFm3ro
JE7vMKOdLaobEAijKobVCuRrfENVRcGylGMtgeRsxz9wAiwxY1BeUp8cFH+pjzJvcjBO9B7B
FpggW3uRd5ivk3Bo/3KfhZekbpnSMophegEztWzHLZjy30uqjiGgerpNXmy/zd0G67jy6edI
cQkEOn9qvno9/vrLJf3as5wWQV8UGD0spNrceB1BSOOKuVv1BKwCyfUyryUhsXG4xHqolEJg
EJFnCUaVVkG5nLgPNTh0MxbrUiHNWpWZ+1zfVMym1dD5pia1XilxtFmc6Cdkf+qh92THrtYe
q3/rtNk8S2XfZ4Ur4H76GqbTk4D8FF8bJ9EO8U7ZZPQERIeCrUUhjwljHoNyW2AioT4KUCZk
uTKtvEDeFsBs7AQiL0L5DUpTyN4VPcxH8KC2+A4z/U+rs7710+ieFSRhyA6UgZXGqgk7tT8f
eiYUixvmMGWYvZbL3A6Gua3iEjavHfw5TqCStQL1aAq6br4WSbH6qhWIxnAbmHsa9tEu7tII
pjIvtkZ1CG7vfuwtbSGL6k5W9LAJiWtROWja0w1SmfK/wlVIO2q3oXb8UuVX5+e95UWW4dRD
mffIbWsDTF79NVX1X9EG/5/VzttbVqwdeZFW8KTMM6uWmj1tomoxgWWBId5nowsJH+cYrI3Z
0T8d3p4vL8dXfww+8W+iI13WUzkkkMYi9y2rtbT/aQG8pAoELdfibB6dMX0Wett/3D+f/C3N
ZFe8ngMWbg5Wgq5SBAujICwcD/R3zoE4tZjqLbb8pggF58wkLHnV20VUZrwr3pkYDuE93DZf
zqI6mYhz3Mavz+KZyupY94orpPjHrEN3NPRnrVVGMcoaZTb0sI5SLjxKzCngrKkKZQCsqCUW
p31SLyLJb8m9FtTkKNBbi5kN533wW+cvs7fYqH+HnfR2Zeo2E5QqFUmr66Wq5rzTBqL3O6M3
dgcMC60lq3wqNISYgDYtdpjNse+k6ZDSCexIZy069Ee2EtC0VEYJdeE3ukCH//rkpsdk1xGI
Z6r2hTfS26o6FMBnmJFtNaGYqht5hqN0EoWhmM+yW4VSzVKs20ILpdsatULVV1PTOAOVSWSF
PHU5svAev842Z/0MCdjzPp4sveY1BHMLoXf6tkko56DzzIUXVW17/9HvVsAvMA5psoVT0pfB
6fDs1CdL8IiJ/GNbvRsCWGKO7ISrQZ+1aEnItlTz4Fgzl2dDsRmXDpnnN97XvunnL4Zrpsna
NvyBG7JjXbPHKD0h97Htwqf7/d8Pt+/7Tx6hkw26gWOEmQfUBicPfJNnPovAxybB8D+0WXxy
O4I4Yif6qs7PBHQKJ5MyUlWefRkK6OL4081Ij1Do4bUEnYzYViv5O1t6sl9DqJKDpBcsJV0G
q0b0fMgZz+8EP7r1ZLoXQxvlbQfKm6UucdzFSMoPYZNcjO33tpjL8WkvhrmmO5hxb2cux7/s
zOV57yt5ZRsH09uZcyv5o4OT3BAckvGRx+XUFg6RHCJiEV2NfqOlq7HsI+W0JN/r2ERnovON
1W1efRcxcNpBBtxd9k7HYPg7HQQq6fYUaVQVxLG99OatA/etBiEGTjD8yOVEg+hbeYP3lt0g
pMsxjvc+RIPom/N2jCN5xgc9K8HvsRG+yOPLXSnAlvacpipABUBlNimCgwhzuroD0Jisjpal
HIDYEpW5quOexOMt0baMk8S9UHOIZir6JUkZRZIZ1eBjGAxGmnqDjLNlXPtgmhIr4a/B1Mty
EfMkZYjAw24HWWZxYF2bNIBdhq4ySXyjE2CbDHHMHyDfra/5qcsy3+t4gv3dxyteLnvZ7BbR
lu0X+As2zOsluug4NmnQ46sYjmpYuTCCBchm3MiuDWtRqBvkDqzRdhfOsVaNTlUv61NIRZax
OPCpzKbaWIkxaVs1azOpWbr5MUOyQYrbJiV+oKqbGQwC7XdoJdqpBLRbO2DJI+Id8FuYQhMT
J1y3M33kJdkL9fWceHOo8LCNrWFBFl3mkx1XJDTmtZx/+fTX27fD018fb/vXx+f7/R8/9g8v
+1dmdomx/CpOSYSXrnDq1pVOUdnPc0lRNCp8tw48ACOp0i+fHm6f7jG64DP+7/75P0+ff94+
3sKv2/uXw9Pnt9u/99Dg4f7z4el9/x058vO3l78/aSZd7F+f9g9UiXZPriQds/5Xl6f65PB0
QJfiw//cNoEN5gwdkIECTYC7lSrhG43rNsXnz6NUmJyc36UBCGY2WABLZnZF0w4Fy2paF5fW
IcVX9NNhWDdyWk9SVY94CoKrl9ZcU8rTZdD9s93GGblCo51D/NTbKqTB68+X9+eTu+fX/cnz
64nmM7YsRIwVYFXBdmYLPPThkQpFoE9aLYK4mFuVDG2E/8jcyhfJgD5pyW1CHUwkZKc3p+O9
PVF9nV8UhU+94FfLpgU8uPmksBGpmdBuA7ezslmoXRhXuqScmw+r74FoA8eg3vRZDfFsOhhe
psvE6xHWOxeB/qAK+mu51msE/ZEMMWaSlvU84glaG7i9kTbANtJfG34/vj0c7v74Z//z5I44
/TtWJfrpMXhpJTDTsNDnsijwexEFImEotBgFpQSuUn+yQEivouF4PLgyQ1Ef7z/QvfIOTvX3
J9ETjQfdTv9zeP9xot7enu8OhApv32+9AQZB6r1jJsCCOegNanha5MmWPPF9TlPRLK6AHfoX
rIqu45Uw+rkCEbgyA5pQJBtub29+dyeBxChiYXSDtO/EW+gRro54IokGlpRrj6fy6UToTQGd
7G97w/0IjASItutSFV772bydbhelMM1rvUx9PsdEJkaKzzGfes9Mpsrn2bkE3OCk+zO4AlrP
9ys8fN+/vfsvK4PR0G+ZwELTm83cKavjUkwStYiGR1ZdE1Te9MAr68FpGE99rhf3D8bvjpgM
zwTYWOCHNAYGjxL8e2xIZRrKMY7m45mrgTccAA7H577kmKuxHbbTIcTatkbgjPymatBKJrm/
X64LnQZUqwuHlx+WG3srEypRUmB9gOPrm6+nsVhaySykSiM4LfpSM1A6sVzKq88wnLRECJeO
70biR/43O9W7Vp+c9OcxKgsrT1A752deN+t1joPvg3ej03P//PiCvt223mx6TqZor6XkJvdg
l2cSxzjXMx5y7n/WzeWL9m6Gs8Pz40n28fht/2rCk6WeYjWAXVBImllYTmYmJ7aAaYSW23GN
+4UcISLYIY6sPVB47/0a4xEhQhfeYutLUXipcdPiyvTD4dvrLSjvr88f74cnQSZjQXol8BrC
G4HGChZ6K9VRHVkxINI82rbkT11H9IuGWmWEdesYmYiWvi6EG9ELShha4gfHSI6PxZAd44Ru
zJ2Sc3z0PbJ3zrxcbhwhoX/7lv8GTlerYbRCR9ueGypQFY6NAjeJXTW6Or6PQLeJSNpOQKhr
nLCnjHbsSWlr2Zmnj8pS+d3KIDo7CPzakURwaWmvlrtJOkVfH9GLWQcHgMZ+VC60hDhdp2dH
PgQkbQoDuN1EVBDA/tlhVLVN0whNXGQdq7cFM8YxZLGcJA1NtZzYZJvx6dUuiMrGsBYZv93u
mm0RVJdYRG+FWGxDorgwRRw6rJZWGN39N50n3qjC0Nvh+5MO1rj7sb/75/D0nXs7aU+P1szU
WBElq5cmBBGFhW2q1uDIFtyloGXGf+k6E8ZL6jc6aJqcxJkqtzgXWT018jjpFcTovanKHfmq
2EEnynNBbN8AGhIWDGArZGI1pnEWwv9KGAqQMV7Ny5AXsMF6hxEcj9MJFh5oV0nbVnmeHPLY
Qa+9IC02wXxGrpFlNLUFXwBcBzuUyLOBVTkASH11ONjF9XJnqSqenk4fWWO07vmQiASYOJps
exLCcxJZyyACVa5Rh/HeD1MqP3RuqeaB/euCWTfjiX8yCZj1Xh9Eut/AF2GesqF3KO5c0K0g
QrXfjA1HbxhUERI9MA71VDYNnSY1NzI4HhMMKr3OcY1grZxx+q4j3APCAUv0mxsEu793m8tz
D0ZxSYVPGyu+ag1QlakEq+fwpXgIzDDttzsJvnow20DUDWg3u4mZLY4hJoAYihiYQhFueyAZ
gSDcPMD2EO6qPMmtQj0civcw/Ku1cPBKK+d7VeVBDHJjFcFMlbxIEFrIrVSYGbZDNZpUQZcO
fCtCQYM4FYblrt6dn1kCrPUcnOYYgYSEy6y9LmISfR3ndWI5fiFtYNdwsnCq6K8PYzo7gVeB
2l8yD6VqlujZZd9ysUxVtcBiRGSyZ8uR5Faf8LcozkxLyc2uVjy7aHmNWiWTzGkRaw+35ndO
FYBnsHeV1hrAuhhmWIVV7rPILKoxJj6fhnzx+DOUBHuXcX9QjPfL3X2CBr1WPLd5BauoA3oM
oMYtmN8/suhfZ5e073OMIkDQl9fD0/s/Osr1cf/23b+SpB14QV239j0EYm1xy6rduOgk+SyB
rTVpTfAXvRTXyziqv7TePEaz8Vpg7jzhNlNpHPQzG8e7ie226SRHBS0qS6DipdmIGv4DlWCS
V1Zewt5Zas/xh4f9H++Hx0aReSPSOw1/ZXPajYHehmdNKSSghJ7pcBNePQmXvABBgUGT3EO3
jFRIVwSA4h/HHOCYgjbOgKESKX5I96KKArrLTuMqVXXAtk0XQ33CWJmtO29anKwjtaCMt9rF
tFP8fneGaIrI2HC4Mxwb7r99fKdqB/HT2/vrx6NbYY6qf6MOalcNs/tnKYUGRoJnvTs2Oejv
FVeaLsU4vyPt4P3kMW/t5aRSGahFWVxjySvFxRDheNuauC6VVFC9uTfVNBNMCs+P4hxJe4lH
Ij/46yeqeTytXWAYr5w7Ww1fZsCZcC6fcPdEjconXzHGxHXmNd3K5eA0jY5A3ZY883Tnk3iW
pZa97tisU/ITPfWtWgEnLKBfBPlqNynzRZRxTv4t3rQ5CGMAosT9YNDh/otVX7prjAlflIXR
psYsm3nmsx7iafOUjQ74dL7OeqKfCF3kcZVnfUFa3VtAysiVATVJmYeq1reOx74ATbze+CNZ
S8FMbeh8HS5Ttvnp345ob4DUHPec1u1rjusDC+cCG49X/H6nDZZy4ciGH5twnZey64lNVgZL
kt6/Qar9+U0Icq8YM+RRRjuF2VVb21yVLCeG1OIzQqCO2eum03B5GqUJiH9/kgzmyGC0Y8YS
d37ZVyiYo+ZMVBGczPsCbh0+W6W7Ylbb8sdgfAhdjLkBHC2ylO6s2Gvg7DcT9piuC72PNxUn
0ZnE7VSzlaLqzCMNFJ0RYKgLVXH3NgeBA3IUa70zaGxnerWxyKOoWmZ5JzPhLOGUw6Q2jnm6
dNLMW+25U99T30Ai/Un+/PL2+QQzln68aB1hfvv0naujWEEYnW7ynM+JBcbY+CUzPGskKefL
+ssp7w+mEt/NlzDcGk4cIvOtr0HtAeUnzGUZSXsImnOWhTgfxwemHQJBJ7r/QEVI2AM08zth
6hpoh5QTjD5VvmNJbdtchhOziKKCVVXDfrLN7b/fXg5PeLsPQ3j8eN//u4d/7N/v/vzzT14m
GuOFqUmqQdXEbPJDAxbgFaKGNaJUa91EBhPatyERAY6x93Mq0RxfR5vIk/WmlpG3Fcvk67XG
gAjM1+TE5xCU68qKlNNQ6qHz3SEsjAoPgJaw6stg7ILJsaJqsOcuVstBHeugSa6OkZAtVtOd
eS+KYatJVAnHsGhpWhu6H2xD3Tvlqs7xvFUlUVT4IrBZcLIPtAWVhbZo4mrgGPSBtC093VLw
427L9lPrMUldrkLd/FrF/BbHHJj/D9zeao40tyDIegS/wchepMHCicShgxV6Ji6zKopC+La1
ydLlroXeyM13qmXLP1oZvb99vz1BLfQOTepW2R5ah7gSDi8Fgo9tzeIJm1DaQ9iquKv1hx3p
gqCdYQoUo7da0rCnx+7LgxKmIqtjlfjZioBxRY1Zy5KA3TlbPMWzbICWRSUIPLaxSH7BW0gC
ujFriZ3MAYf7N52/2w1oOOB4hxEQFF1XPpPa43VE1XVzAC+7o7dt1iDuh4MEXm312P2hn/O8
LhKtj1EYHKW6kuUwEGTBts4lqZBRakcYluWnDcsyXWbaoHAcO4ND71ymMbYdN5JNQO7WcT1H
U56rOjXolHRmIMBLHYcEI79pyZASjkhZ7TWCTgSugRAHrptl3EfDoNg3p8+6G4ETyImi0q0+
RHV+iN66dsMFwjWtYKSBP2EFnFlS+ADLa3kcXnvmuOU21BD6O7q7CuiqTjZOr2l/5Tuve2nZ
j5j13Jf+etXbN4BwwEBs22XfbJRWp2DSqnw67e+NVsA8Hl3DhyGNsYlM1GwlbQoNm1QZqPrw
GfKHHVR7KqjWom1oAjsHcEMzVs9p3sBVBvJbUYABPdDnuGDI4WuQCM1LE4rQ3lF5Kr08ndmG
qj5qJpaeNQuoCVzu6vtObSxdrTKNq9pmwAZti51NFG+nm8yy8oB1s/qLi7OvfQH73RfVXWrI
W0j3Qf+C0rxZJXRXgtMuh6loQj0h+GdZVn05dGZoxjJrKOWbcxi0VrDZFb17HRsLJ7V2VUbT
5igjoRBGSa3EuOxOUAGN2jraH1tLFFHeGyusMC1yJbMHUF7BuLHU0k1X9zwFLjU0np7xhl4x
gqJhK4C+bIxUmTT+C4JRhHYPeR+mBMo+3zVqgNMdfrVT79/eUX/Fw2WAxRtvv7OszZQPzTrB
U4K0xlwmTF6XQM0KICNotKE571ecNBltob1xC0Z/xLuYvGwG7TCyYU+ducZQMCmg4qRK+A0f
QrTF0jmEOW3wgDH+aKoWkQm6c1Bx3upwXLYjaorHE/nLcl5r7gyOsSsanz27TAXCFz5mzXf8
It6mJsN1Y+bDS21VooG3cgjwTqhcUi4MyyCukfAhqjJS2j5/+i9moW9TQ5QgbmmL16d0x78z
WYQ1823XthGUuRV+HDY8jTO0chYOWKAM49W5VTVlYk5QdCI8or9P0Au6V5zx+3hXqlAOR5TF
x1porK+2vNLH4fMzwahMo5lHGzJnO8PWF7o6aLByHgFkFRRb55EFgOt849A2LlM2aXN9zCsR
0NXHMpbidAi3MW4I9iOYvWsKMrTvsRLtDY7RVQ9bcc9oAsHm4PLKwuUe6Dla+mygsWx646lQ
N4KPWpIh6NMFrUlOCDoJflymcA6PvFZ1HijZhYxKnbfCtWWsJsMrk6FMNcHWbFR3riL/uhYl
mUm4p5vTdJCGlMbQEt1dXytPmutJo02337bZhLViKHHfosPGGYDiW3jcQvo1mraPPEmWb3t9
KaIShbhlyjy6z3mRlNrP4X8B+oT/Gb4PAQA=

--envbJBWh7q8WU6mo--
