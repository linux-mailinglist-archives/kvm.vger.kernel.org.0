Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9150E64DC65
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 14:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLONlI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 08:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLONlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 08:41:06 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A5214D16;
        Thu, 15 Dec 2022 05:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671111664; x=1702647664;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=4wh4eb0YGFGHFG9dwz94YTVzd1p9vAC1js7+jLRKDKY=;
  b=n7t//DygNOpd2Qp8Gv7lDTHud79cspZN1qhTzOYjMJe9l3OwHUFEuVeG
   9y6E/xDHX16yD4w3U2JHlQKiVN1UjGHHoh2i/aSngka0tWXtqd6le1mtP
   /k++BJoMhk3AwPIs/oOG2ASDabvO1E5nn0danVvIRvwwbANDIWzFmunMk
   kaptnTg+GWfUB9FbB0JdnXhSGHRDSB78i1qJb0mlEqPoljcgKAseeObvl
   sdOqbwKGrtwTEbaQDsdkEIPCukdtu+HsiKEhuzvgybUSx2m37yrmZG6cC
   RuTjyqwq7dQ4OZ9DjCD6RHhZE/vt5B29GQOcE0mEUyv9x3QHr+qVWSSZW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="319819371"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="319819371"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 05:40:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="738110965"
X-IronPort-AV: E=Sophos;i="5.96,247,1665471600"; 
   d="scan'208";a="738110965"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Dec 2022 05:40:52 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p5oTj-0006Iw-0a;
        Thu, 15 Dec 2022 13:40:51 +0000
Date:   Thu, 15 Dec 2022 21:40:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        linux-xfs@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-can@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, kvm@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 459c73db4069c27c1d4a0e20d055b837396364b8
Message-ID: <639b23c8.DdUNqMCLdxZ7gLv2%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 459c73db4069c27c1d4a0e20d055b837396364b8  Add linux-next specific files for 20221215

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202211242120.MzZVGULn-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212141410.IlFkWqph-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212142121.vendKsOc-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/gpu/drm-internals:179: ./include/drm/drm_file.h:411: WARNING: undefined label: drm_accel_node (if the link has no caption the label must precede a section header)
Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree
Warning: tools/power/cpupower/man/cpupower-powercap-info.1 references a file that doesn't exist: Documentation/power/powercap/powercap.txt
arch/loongarch/kernel/asm-offsets.c:265:6: warning: no previous prototype for 'output_pbe_defines' [-Wmissing-prototypes]
arch/parisc/include/asm/pgtable.h:154:32: warning: "PMD_SHIFT" is not defined, evaluates to 0 [-Wundef]
arch/powerpc/kernel/kvm_emul.o: warning: objtool: kvm_template_end(): can't find starting instruction
arch/powerpc/kernel/optprobes_head.o: warning: objtool: optprobe_template_end(): can't find starting instruction
drivers/gpu/drm/amd/amdgpu/../display/dc/irq/dcn201/irq_service_dcn201.c:40:20: warning: no previous prototype for 'to_dal_irq_source_dcn201' [-Wmissing-prototypes]
drivers/regulator/tps65219-regulator.c:310:60: warning: parameter 'dev' set but not used [-Wunused-but-set-parameter]
drivers/regulator/tps65219-regulator.c:370:26: warning: ordered comparison of pointer with integer zero [-Wextra]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/i2c/busses/i2c-qcom-geni.c:1028:28: sparse: sparse: symbol 'i2c_master_hub' was not declared. Should it be static?
fs/xfs/xfs_iomap.c:86:29: sparse: sparse: symbol 'xfs_iomap_page_ops' was not declared. Should it be static?

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arm-randconfig-c033-20221214
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- i386-randconfig-s002
|   `-- fs-xfs-xfs_iomap.c:sparse:sparse:symbol-xfs_iomap_page_ops-was-not-declared.-Should-it-be-static
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- ia64-randconfig-r032-20221214
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|-- loongarch-allyesconfig
|   `-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_pbe_defines
|-- m68k-allmodconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- m68k-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- microblaze-randconfig-r033-20221214
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-irq-dcn201-irq_service_dcn201.c:warning:no-previous-prototype-for-to_dal_irq_source_dcn201
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- parisc-randconfig-r015-20221214
|   `-- arch-parisc-include-asm-pgtable.h:warning:PMD_SHIFT-is-not-defined-evaluates-to
|-- parisc-randconfig-r032-20221214
|   `-- arch-parisc-include-asm-pgtable.h:warning:PMD_SHIFT-is-not-defined-evaluates-to
|-- parisc-randconfig-r034-20221214
|   `-- arch-parisc-include-asm-pgtable.h:warning:PMD_SHIFT-is-not-defined-evaluates-to

elapsed time: 722m

configs tested: 80
configs skipped: 2

gcc tested configs:
powerpc                           allnoconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
arc                                 defconfig
i386                                defconfig
s390                             allmodconfig
x86_64                        randconfig-a004
alpha                               defconfig
x86_64                        randconfig-a002
s390                                defconfig
x86_64                               rhel-8.3
arc                  randconfig-r043-20221214
x86_64                           rhel-8.3-bpf
ia64                             allmodconfig
x86_64                           allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
s390                             allyesconfig
arm                                 defconfig
i386                          randconfig-a014
s390                 randconfig-r044-20221214
sh                   secureedge5410_defconfig
i386                          randconfig-a001
x86_64                        randconfig-a013
riscv                randconfig-r042-20221214
x86_64                        randconfig-a006
x86_64                        randconfig-a011
x86_64                          rhel-8.3-rust
i386                          randconfig-a003
alpha                            allyesconfig
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
i386                          randconfig-a005
arm64                            allyesconfig
x86_64                        randconfig-a015
sh                               allmodconfig
m68k                             allyesconfig
i386                          randconfig-a012
sh                          urquell_defconfig
arm                              allyesconfig
i386                          randconfig-a016
x86_64                            allnoconfig
sparc                               defconfig
m68k                             allmodconfig
arc                              allyesconfig
mips                             allyesconfig
powerpc                          allmodconfig
i386                             allyesconfig
arm                          pxa3xx_defconfig
sh                                  defconfig
powerpc                     rainier_defconfig
powerpc                         wii_defconfig
sh                           se7705_defconfig
loongarch                         allnoconfig
sh                        sh7763rdp_defconfig
sh                             espt_defconfig
powerpc                 canyonlands_defconfig
i386                          randconfig-c001

clang tested configs:
arm                  randconfig-r046-20221214
hexagon              randconfig-r041-20221214
hexagon              randconfig-r045-20221214
x86_64                        randconfig-a014
x86_64                        randconfig-a001
i386                          randconfig-a013
x86_64                        randconfig-a003
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a005
i386                          randconfig-a002
i386                          randconfig-a011
i386                          randconfig-a004
arm                          ixp4xx_defconfig
i386                          randconfig-a015
i386                          randconfig-a006
powerpc                      obs600_defconfig
x86_64                        randconfig-k001
mips                        bcm63xx_defconfig
arm                      pxa255-idp_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
