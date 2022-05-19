Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1003452C90F
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 02:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiESA4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 20:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiESA4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 20:56:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF701758C;
        Wed, 18 May 2022 17:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652921780; x=1684457780;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=h3f7BNLBihE/PBZJDUN1Icz6iYcquhWnL2epLBoNpRY=;
  b=cZfXUVn6YjFY5Kg2aEYT/dXTzBiPBYahhrxiFB9PcSHZXHeR+xNvNJEy
   g0kAWFylOdtGrSVN+BwYesqVovI4q54DBt3tCAYxfcDMm+6TRwU137WtD
   hESQz3JR8MfTQKy+Q2uNLQG2aIqjz4LhYC5tbTHzU5ov1atdUqkqq+0Mu
   GWoJ1IzYh3OjyQSIPqsR+1/voY4597KHhTtX4fdendJ4zBJ+75ldK/YJU
   v0GPNZRPs3RxII+YMnb7FSoMSJcPRzdTd0x+ZqDJE2BJDe23pzdatoZBn
   Y5N1i8t2EOaLW3X10puOHxLn05lwJ0UuFJ6ua9XPGw96YlCs/BzsRy43s
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="270785566"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="270785566"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 17:56:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="817716693"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2022 17:56:14 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrUSc-0002qL-3l;
        Thu, 19 May 2022 00:56:14 +0000
Date:   Thu, 19 May 2022 08:55:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-staging@lists.linux.dev, linux-omap@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-hwmon@vger.kernel.org,
        linux-fbdev@vger.kernel.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 736ee37e2e8eed7fe48d0a37ee5a709514d478b3
Message-ID: <6285958d.+Z2aDZ4O1Y9eiazd%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 736ee37e2e8eed7fe48d0a37ee5a709514d478b3  Add linux-next specific files for 20220518

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
https://lore.kernel.org/linux-mm/202205172344.3GFeaum1-lkp@intel.com
https://lore.kernel.org/linux-mm/202205190527.o9wVEvHI-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

<command-line>: fatal error: ./include/generated/utsrelease.h: No such file or directory
arch/x86/kvm/pmu.h:20:32: warning: 'vmx_icl_pebs_cpu' defined but not used [-Wunused-const-variable=]
csky-linux-ld: (.text+0x1bc): undefined reference to `blkcg_get_fc_appid'
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
drivers/nvme/host/fc.c:1914: undefined reference to `blkcg_get_fc_appid'
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:686: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5102:14: warning: variable 'allow_lttpr_non_transparent_mode' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5147:6: warning: no previous prototype for 'dp_parse_lttpr_mode' [-Wmissing-prototypes]
drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]
drivers/staging/vt6655/card.c:759:16: sparse: sparse: cast to restricted __le64
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
{standard input}:1991: Error: unknown pseudo-op: `.lc'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arm-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm64-allmodconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- arm64-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-buildonly-randconfig-r004-20220518
|   `-- csky-linux-ld:(.text):undefined-reference-to-blkcg_get_fc_appid
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-buildonly-randconfig-r002-20220518
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- i386-debian-10.3
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- i386-debian-10.3-kselftests
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- m68k-allmodconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   `-- drivers-hwmon-nct6775-platform.c:sparse:void
|-- m68k-allyesconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   `-- drivers-hwmon-nct6775-platform.c:sparse:void
|-- mips-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- mips-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- parisc-buildonly-randconfig-r004-20220518
|   `-- drivers-nvme-host-fc.c:undefined-reference-to-blkcg_get_fc_appid
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- riscv-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sh-allmodconfig
|   `-- standard-input:Error:unknown-pseudo-op:lc
|-- sh-allyesconfig
|   `-- standard-input:Error:unknown-pseudo-op:lc
|-- sparc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- x86_64-allmodconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- x86_64-kexec
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-func
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-kselftests
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-kunit
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-syz
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- xtensa-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
`-- xtensa-buildonly-randconfig-r003-20220518
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

elapsed time: 726m

configs tested: 60
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm64                               defconfig
arm64                            allyesconfig
i386                             allyesconfig
mips                             allyesconfig
riscv                            allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
s390                             allmodconfig
m68k                             allyesconfig
m68k                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
s390                             allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
arc                              allyesconfig
arm                          pxa910_defconfig
sh                           sh2007_defconfig
mips                       capcella_defconfig
m68k                        m5307c3_defconfig
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
nios2                               defconfig
alpha                               defconfig
csky                                defconfig
arc                                 defconfig
parisc                              defconfig
s390                                defconfig
parisc64                            defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
sparc                            allyesconfig
sparc                               defconfig
powerpc                           allnoconfig
riscv                             allnoconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                                  kexec
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit

clang tested configs:
powerpc                        icon_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
