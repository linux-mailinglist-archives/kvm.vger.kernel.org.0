Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0395D670D61
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 00:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjAQX2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 18:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjAQX1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 18:27:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0C45AB7B
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 13:28:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0830BB81A26
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 21:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9CAC433EF
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673990881;
        bh=sqVUPy2Kgiw1obnSTM5FO0JbvpmgQRed/lpm4VFQ4TE=;
        h=Date:From:To:Subject:From;
        b=sbqdQRnytcAoE3jkioCWsJLbuOFJxa+mbPWpz6cBeDluRd3Il1UXlcAp57xpNH6fL
         g3/rywDdN90NRKe/sLDDkk23iGpkqhyICISYpmb0pSPS1jZ1BD4L1qgzO4qcswyKPs
         ZbPzjJsOkIoKRfxncGyzvycCNpzVPC49PBmjo3Vo=
Date:   Tue, 17 Jan 2023 13:28:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     kvm@vger.kernel.org
Subject: Fw: [linux-next:master] BUILD REGRESSION
 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9
Message-Id: <20230117132800.b18b01c3895c26e8d3d003aa@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

a KVM build error here.

Begin forwarded message:

Date: Wed, 18 Jan 2023 00:44:23 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org, Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9


tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9  Add linux-next specific files for 20230117

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202301100332.4EaKi4d1-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202301171414.xpf8WpXn-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202301171511.4ZszviYP-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/mm/unevictable-lru.rst:186: WARNING: Title underline too short.
ERROR: modpost: "kunit_running" [drivers/gpu/drm/vc4/vc4.ko] undefined!
arch/arm/kernel/entry-armv.S:485:5: warning: "CONFIG_ARM_THUMB" is not defined, evaluates to 0 [-Wundef]
drivers/gpu/drm/ttm/ttm_bo_util.c:364:32: error: implicit declaration of function 'vmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]
drivers/gpu/drm/ttm/ttm_bo_util.c:429:17: error: implicit declaration of function 'vunmap'; did you mean 'kunmap'? [-Werror=implicit-function-declaration]
drivers/scsi/qla2xxx/qla_mid.c:1094:51: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat=]
drivers/scsi/qla2xxx/qla_mid.c:1189:6: warning: no previous prototype for 'qla_trim_buf' [-Wmissing-prototypes]
drivers/scsi/qla2xxx/qla_mid.c:1221:6: warning: no previous prototype for '__qla_adjust_buf' [-Wmissing-prototypes]
libbpf: failed to find '.BTF' ELF section in vmlinux
usr/include/asm/kvm.h:508:17: error: expected specifier-qualifier-list before '__DECLARE_FLEX_ARRAY'

Unverified Error/Warning (likely false positive, please contact us if interested):

FAILED: load BTF from vmlinux: No data available
drivers/firmware/arm_scmi/bus.c:156:24: warning: Uninitialized variable: victim->id_table [uninitvar]
drivers/firmware/arm_scmi/virtio.c:341:12: warning: Uninitialized variable: msg->poll_status [uninitvar]
drivers/gpio/gpio-mxc.c:293:32: warning: Uninitialized variable: port->hwdata [uninitvar]
drivers/gpio/gpio-mxc.c:550:31: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
drivers/gpio/gpio-mxc.c:550:31: warning: Signed integer overflow for expression '1<<i'. [integerOverflow]
drivers/gpio/gpio-mxc.c:596:22: warning: Uninitialized variables: port.node, port.clk, port.irq, port.irq_high, port.domain, port.gc, port.dev, port.both_edges, port.gpio_saved_reg, port.power_off, port.wakeup_pads, port.is_pad_wakeup, port.hwdata [uninitvar]
drivers/gpio/gpio-mxc.c:615:25: warning: Uninitialized variables: port.node, port.irq, port.irq_high, port.domain, port.gc, port.dev, port.both_edges, port.gpio_saved_reg, port.power_off, port.wakeup_pads, port.is_pad_wakeup, port.hwdata [uninitvar]
drivers/nvmem/imx-ocotp.c:599:21: sparse: sparse: symbol 'imx_ocotp_layout' was not declared. Should it be static?
net/devlink/leftover.c:7181 devlink_fmsg_prepare_skb() error: uninitialized symbol 'err'.

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arc-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm-buildonly-randconfig-r002-20230117
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm-randconfig-r046-20230117
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm64-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm64-randconfig-r033-20230117
|   `-- ERROR:kunit_running-drivers-gpu-drm-vc4-vc4.ko-undefined
|-- i386-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- i386-randconfig-a016-20230116
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- ia64-allmodconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vmap
|   |-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vunmap
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- nios2-randconfig-c031-20230115
|   |-- FAILED:load-BTF-from-vmlinux:No-data-available
|   `-- libbpf:failed-to-find-.BTF-ELF-section-in-vmlinux
|-- parisc-randconfig-r033-20230116
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- parisc-randconfig-s051-20230116
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- powerpc-allmodconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
clang_recent_errors
`-- x86_64-buildonly-randconfig-r006-20230116
    `-- ERROR:kunit_running-drivers-gpu-drm-vc4-vc4.ko-undefined

elapsed time: 724m

configs tested: 68
configs skipped: 22

gcc tested configs:
x86_64                              defconfig
x86_64                            allnoconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-bpf
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
arm64                            allyesconfig
x86_64                           rhel-8.3-kvm
ia64                             allmodconfig
x86_64                           allyesconfig
i386                 randconfig-a014-20230116
i386                 randconfig-a013-20230116
i386                 randconfig-a012-20230116
i386                 randconfig-a011-20230116
x86_64               randconfig-a011-20230116
i386                 randconfig-a015-20230116
x86_64               randconfig-a013-20230116
x86_64               randconfig-a012-20230116
x86_64               randconfig-a015-20230116
i386                 randconfig-a016-20230116
x86_64               randconfig-a014-20230116
x86_64               randconfig-a016-20230116
mips                         db1xxx_defconfig
powerpc                 mpc837x_rdb_defconfig
m68k                         apollo_defconfig
um                               alldefconfig
sh                 kfr2r09-romimage_defconfig
arc                  randconfig-r043-20230115
s390                 randconfig-r044-20230116
riscv                randconfig-r042-20230116
arc                  randconfig-r043-20230116
arm                  randconfig-r046-20230115
arm                  randconfig-r046-20230117
arc                  randconfig-r043-20230117
arm                       multi_v4t_defconfig
sh                        dreamcast_defconfig
arm64                               defconfig
s390                          debug_defconfig

clang tested configs:
i386                 randconfig-a002-20230116
x86_64                          rhel-8.3-rust
i386                 randconfig-a004-20230116
i386                 randconfig-a003-20230116
i386                 randconfig-a001-20230116
i386                 randconfig-a006-20230116
i386                 randconfig-a005-20230116
x86_64               randconfig-a001-20230116
x86_64               randconfig-a006-20230116
x86_64               randconfig-a003-20230116
x86_64               randconfig-a002-20230116
x86_64               randconfig-a004-20230116
x86_64               randconfig-a005-20230116
arm                            dove_defconfig
hexagon              randconfig-r041-20230116
riscv                randconfig-r042-20230117
hexagon              randconfig-r045-20230117
s390                 randconfig-r044-20230117
hexagon              randconfig-r045-20230115
hexagon              randconfig-r041-20230117
riscv                randconfig-r042-20230115
arm                  randconfig-r046-20230116
s390                 randconfig-r044-20230115
hexagon              randconfig-r045-20230116
hexagon              randconfig-r041-20230115
arm                           omap1_defconfig
riscv                    nommu_virt_defconfig
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
