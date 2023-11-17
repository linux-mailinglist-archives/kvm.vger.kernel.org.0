Return-Path: <kvm+bounces-1970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75AB57EF529
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7066E1C20B1E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99C51374DA;
	Fri, 17 Nov 2023 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YeirgAEh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76114D56;
	Fri, 17 Nov 2023 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700234540; x=1731770540;
  h=date:from:to:cc:subject:message-id;
  bh=/udBxVL3O5zc7LvSoekqJ4hXLDmkwe5gx96DAHcn/1Y=;
  b=YeirgAEhInJiXT9YmN1waTPkQJ6mJrnFAXCm3rZOurI+bWpSVMe0TgTC
   Q2iO2HsJL31uPXmKLVzaX1pNLEPyfrs5gw1IDxlA3PiWnkEz/5x19WcUd
   Q6SwMmatNBEsx+hdNK4Vmny01lNOFhKDJJySzuoZG7C0zJWyd4e89r+tz
   9vOdyblRtlodwnpvIsp0R0UGlORRIYUOFIisqATjimMAm7pSzR6ZMlKir
   gfxpcNTohxypMhyZh4xLbVOeOoq05rZGE9GYCtq7k/dHLTip4pRIGWOjM
   8wMk8G+BX8ztooRBhAoLZLwcIQAwOw+jt1KFlei01O/uxW9sBVqwgUvAD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="4399866"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="4399866"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 07:22:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="765656805"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="765656805"
Received: from lkp-server02.sh.intel.com (HELO b8de5498638e) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 17 Nov 2023 07:22:01 -0800
Received: from kbuild by b8de5498638e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r40fP-0002sJ-1S;
	Fri, 17 Nov 2023 15:21:59 +0000
Date: Fri, 17 Nov 2023 23:21:11 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
 alsa-devel@alsa-project.org, apparmor@lists.ubuntu.com,
 dmaengine@vger.kernel.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org,
 linux-hexagon@vger.kernel.org, linux-input@vger.kernel.org,
 linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-security-module@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-trace-kernel@vger.kernel.org
Subject: [linux-next:master] BUILD REGRESSION
 eff99d8edbed7918317331ebd1e365d8e955d65e
Message-ID: <202311172304.pOmaLLVT-lkp@intel.com>
User-Agent: s-nail v14.9.24
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: eff99d8edbed7918317331ebd1e365d8e955d65e  Add linux-next specific files for 20231117

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202310190541.U0K7h90n-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202310262104.JQhDdU3I-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202310302025.Pokm9vEs-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202310310710.DqPlsmsZ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202311011040.L1ncxDT3-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202311171015.WiPtQrdU-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202311172010.AfFjwTiU-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

./security/landlock/ruleset.h:287: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
Warning: Documentation/devicetree/bindings/power/wakeup-source.txt references a file that doesn't exist: Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
arch/loongarch/kvm/mmu.c:810:13: error: implicit declaration of function 'mmu_invalidate_retry_hva'; did you mean 'mmu_invalidate_retry_gfn'? [-Werror=implicit-function-declaration]
drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: warning: use of bitwise '|' with boolean operands [-Wbitwise-instead-of-logical]
drivers/net/ethernet/engleder/tsnep_main.c:470:25: warning: argument 2 null where non-null expected [-Wnonnull]
fs/bcachefs/fs-common.c:356:5: warning: stack frame size (1112) exceeds limit (1024) in 'bch2_rename_trans' [-Wframe-larger-than]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- alpha-defconfig
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- arc-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- arc-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- arc-randconfig-001-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- arc-randconfig-002-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- arm-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- arm-allnoconfig
|   `-- arch-arm-kernel-process.c:warning:variable-buf-set-but-not-used
|-- arm-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- arm-defconfig
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   `-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|-- arm-randconfig-001-20231117
|   |-- arch-arm-kernel-process.c:warning:variable-buf-set-but-not-used
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- arm-randconfig-002-20231117
|   |-- arch-arm-kernel-process.c:warning:variable-buf-set-but-not-used
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- arm-randconfig-003-20231117
|   |-- arch-arm-kernel-process.c:warning:variable-buf-set-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- arm-randconfig-004-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- arm64-randconfig-001-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- arm64-randconfig-002-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   `-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|-- arm64-randconfig-003-20231117
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- arm64-randconfig-004-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- csky-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- csky-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- csky-randconfig-001-20231117
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- csky-randconfig-002-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   `-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|-- i386-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- i386-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- i386-buildonly-randconfig-001-20231117
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- i386-buildonly-randconfig-002-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- i386-buildonly-randconfig-003-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   `-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|-- i386-buildonly-randconfig-004-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- i386-buildonly-randconfig-005-20231117
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- i386-buildonly-randconfig-006-20231117
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- i386-defconfig
|   `-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|-- i386-randconfig-001-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   `-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|-- i386-randconfig-002-20231117
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   `-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|-- i386-randconfig-003-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- i386-randconfig-004-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- i386-randconfig-005-20231117
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   `-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|-- i386-randconfig-011-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- i386-randconfig-012-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- i386-randconfig-013-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- i386-randconfig-014-20231117
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- i386-randconfig-015-20231117
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- i386-randconfig-016-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- i386-randconfig-141-20231117
|   |-- crypto-tcrypt.c-do_test()-warn:Function-too-hairy.-No-more-merges.
|   |-- drivers-dma-dw-axi-dmac-dw-axi-dmac-platform.c-axi_chan_resume()-warn:inconsistent-indenting
|   |-- drivers-dma-dw-axi-dmac-dw-axi-dmac-platform.c-dma_chan_pause()-warn:inconsistent-indenting
|   |-- drivers-hwtracing-stm-core.c-stm_register_device()-error:double-free-of-stm
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-zstd-decompress-zstd_decompress_internal.h-ZSTD_DCtx_get_bmi2()-warn:inconsistent-indenting
|-- loongarch-allmodconfig
|   |-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_kvm_defines
|   |-- arch-loongarch-kvm-mmu.c:error:implicit-declaration-of-function-mmu_invalidate_retry_hva
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- loongarch-allnoconfig
|   `-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_kvm_defines
|-- loongarch-allyesconfig
|   |-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_kvm_defines
|   |-- arch-loongarch-kvm-mmu.c:error:implicit-declaration-of-function-mmu_invalidate_retry_hva
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- loongarch-defconfig
|   |-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_kvm_defines
|   |-- arch-loongarch-kvm-mmu.c:error:implicit-declaration-of-function-mmu_invalidate_retry_hva
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- loongarch-randconfig-001-20231117
|   |-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_kvm_defines
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- loongarch-randconfig-002-20231117
|   |-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_kvm_defines
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- m68k-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- m68k-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- m68k-defconfig
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- microblaze-allmodconfig
|   |-- arch-microblaze-kernel-traps.c:warning:no-previous-prototype-for-trap_init
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-fp-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-loglvl-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-pc-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-task-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-trace-not-described-in-unwind_trap
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- microblaze-allnoconfig
|   |-- arch-microblaze-kernel-traps.c:warning:no-previous-prototype-for-trap_init
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-fp-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-loglvl-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-pc-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-task-not-described-in-unwind_trap
|   `-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-trace-not-described-in-unwind_trap
|-- microblaze-allyesconfig
|   |-- arch-microblaze-kernel-traps.c:warning:no-previous-prototype-for-trap_init
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-fp-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-loglvl-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-pc-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-task-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-trace-not-described-in-unwind_trap
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- microblaze-defconfig
|   |-- arch-microblaze-kernel-traps.c:warning:no-previous-prototype-for-trap_init
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-fp-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-loglvl-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-pc-not-described-in-unwind_trap
|   |-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-task-not-described-in-unwind_trap
|   `-- arch-microblaze-kernel-unwind.c:warning:Function-parameter-or-member-trace-not-described-in-unwind_trap
|-- mips-allmodconfig
|   |-- arch-mips-kernel-ftrace.c:warning:no-previous-prototype-for-prepare_ftrace_return
|   |-- arch-mips-kernel-machine_kexec.c:warning:no-previous-prototype-for-machine_shutdown
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- mips-allyesconfig
|   |-- arch-mips-kernel-ftrace.c:warning:no-previous-prototype-for-prepare_ftrace_return
|   |-- arch-mips-kernel-machine_kexec.c:warning:no-previous-prototype-for-machine_shutdown
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- nios2-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- nios2-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- nios2-randconfig-001-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- nios2-randconfig-002-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- parisc-allyesconfig
|   |-- (.text):undefined-reference-to-L874
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- parisc-randconfig-001-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- parisc-randconfig-002-20231117
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-net-ppp-pppoe.c:warning:variable-pde-set-but-not-used
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- powerpc-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- powerpc-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- powerpc-randconfig-001-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- powerpc-randconfig-002-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- drivers-video-fbdev-fsl-diu-fb.c:warning:Function-parameter-or-member-bits_per_pixel-not-described-in-fsl_diu_get_pixel_format
|   |-- drivers-video-fbdev-fsl-diu-fb.c:warning:Function-parameter-or-member-mfb-not-described-in-fsl_diu_data
|   |-- drivers-video-fbdev-fsl-diu-fb.c:warning:variable-hw-set-but-not-used
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- sound-soc-fsl-mpc5200_psc_ac97.c:warning:cannot-understand-function-prototype:const-struct-snd_soc_dai_ops-psc_ac97_analog_ops
|-- powerpc-randconfig-003-20231117
|   |-- arch-powerpc-kernel-traps.c:warning:no-previous-prototype-for-is_valid_bugaddr
|   |-- arch-powerpc-platforms-powermac-smp.c:warning:no-previous-prototype-for-smp_psurge_give_timebase
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- powerpc64-randconfig-001-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- powerpc64-randconfig-002-20231117
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- powerpc64-randconfig-003-20231117
|   |-- arch-powerpc-include-asm-book3s-pgtable-64k.h:warning:no-return-statement-in-function-returning-non-void
|   |-- arch-powerpc-kernel-traps.c:warning:no-previous-prototype-for-is_valid_bugaddr
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-net-ethernet-engleder-tsnep_main.c:warning:argument-null-where-non-null-expected
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- riscv-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- riscv-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- riscv-defconfig
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- riscv-randconfig-001-20231117
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   `-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|-- riscv-randconfig-002-20231117
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- riscv-rv32_defconfig
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- s390-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- s390-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- s390-defconfig
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- s390-randconfig-001-20231117
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- s390-randconfig-002-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- sh-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- sh-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-clocksource-timer-ti-32k.c:warning:expecting-prototype-for-timer().-Prototype-was-for-OMAP2_32KSYNCNT_REV_OFF()-instead
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- sh-randconfig-001-20231117
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- sh-randconfig-002-20231117
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- sparc-allmodconfig
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-alloc_tag_store
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-find_tag_store
|   |-- arch-sparc-kernel-module.c:error:variable-strtab-set-but-not-used
|   |-- arch-sparc-kernel-pci_sun4v.c:error:no-previous-prototype-for-dma_4v_iotsb_bind
|   |-- arch-sparc-kernel-traps_64.c:error:no-previous-prototype-for-trap_init
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- sparc-allnoconfig
|   |-- kernel-dma.c:warning:no-previous-prototype-for-free_dma
|   `-- kernel-dma.c:warning:no-previous-prototype-for-request_dma
|-- sparc-allyesconfig
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-alloc_tag_store
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-find_tag_store
|   |-- arch-sparc-kernel-module.c:error:variable-strtab-set-but-not-used
|   |-- arch-sparc-kernel-pci_sun4v.c:error:no-previous-prototype-for-dma_4v_iotsb_bind
|   |-- arch-sparc-kernel-traps_64.c:error:no-previous-prototype-for-trap_init
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- sparc-defconfig
|   |-- arch-sparc-kernel-module.c:error:variable-strtab-set-but-not-used
|   |-- kernel-dma.c:warning:no-previous-prototype-for-free_dma
|   `-- kernel-dma.c:warning:no-previous-prototype-for-request_dma
|-- sparc-randconfig-002-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   `-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|-- sparc64-allmodconfig
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-alloc_tag_store
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-find_tag_store
|   |-- arch-sparc-kernel-module.c:error:variable-strtab-set-but-not-used
|   |-- arch-sparc-kernel-pci_sun4v.c:error:no-previous-prototype-for-dma_4v_iotsb_bind
|   |-- arch-sparc-kernel-traps_64.c:error:no-previous-prototype-for-trap_init
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- sparc64-allyesconfig
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-alloc_tag_store
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-find_tag_store
|   |-- arch-sparc-kernel-module.c:error:variable-strtab-set-but-not-used
|   |-- arch-sparc-kernel-pci_sun4v.c:error:no-previous-prototype-for-dma_4v_iotsb_bind
|   |-- arch-sparc-kernel-traps_64.c:error:no-previous-prototype-for-trap_init
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- sparc64-defconfig
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-alloc_tag_store
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-find_tag_store
|   |-- arch-sparc-kernel-module.c:error:variable-strtab-set-but-not-used
|   |-- arch-sparc-kernel-pci_sun4v.c:error:no-previous-prototype-for-dma_4v_iotsb_bind
|   |-- arch-sparc-kernel-traps_64.c:error:no-previous-prototype-for-trap_init
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- sparc64-randconfig-001-20231117
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-alloc_tag_store
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-find_tag_store
|   |-- arch-sparc-kernel-module.c:error:variable-strtab-set-but-not-used
|   |-- arch-sparc-kernel-traps_64.c:error:no-previous-prototype-for-trap_init
|   |-- arch-sparc-mm-init_64.c:error:variable-pagecv_flag-set-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- sparc64-randconfig-002-20231117
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-alloc_tag_store
|   |-- arch-sparc-kernel-adi_64.c:error:no-previous-prototype-for-find_tag_store
|   |-- arch-sparc-kernel-traps_64.c:error:no-previous-prototype-for-trap_init
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- fs-bcachefs-bcachefs_format.h:warning:p-offset-in-struct-bkey-isn-t-aligned-to
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- um-allmodconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- um-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- x86_64-allnoconfig
|   |-- Warning:Documentation-devicetree-bindings-power-wakeup-source.txt-references-a-file-that-doesn-t-exist:Documentation-devicetree-bindings-input-qcom-pm8xxx-keypad.txt
|   |-- drivers-pinctrl-qcom-pinctrl-lpass-lpi.c:linux-seq_file.h-is-included-more-than-once.
|   `-- security-landlock-ruleset.h:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-allyesconfig
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-firmware-broadcom-bcm47xx_sprom.c:warning:snprintf-output-may-be-truncated-before-the-last-format-character
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|-- x86_64-buildonly-randconfig-001-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-wdt87xx_i2c.c:warning:wdt87xx_acpi_id-defined-but-not-used
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- x86_64-buildonly-randconfig-002-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- x86_64-buildonly-randconfig-003-20231117
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- x86_64-buildonly-randconfig-004-20231117
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   `-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|-- x86_64-buildonly-randconfig-005-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-net-ppp-pppoe.c:warning:variable-pde-set-but-not-used
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- x86_64-defconfig
|   `-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|-- x86_64-randconfig-001-20231117
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- x86_64-randconfig-002-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- x86_64-randconfig-003-20231117
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- x86_64-randconfig-004-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- x86_64-randconfig-005-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- x86_64-randconfig-006-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- x86_64-randconfig-011-20231117
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- x86_64-randconfig-012-20231117
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
|-- x86_64-randconfig-013-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   `-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|-- x86_64-randconfig-014-20231117
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- x86_64-randconfig-015-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|-- x86_64-randconfig-016-20231117
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   `-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|-- x86_64-randconfig-071-20231117
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- x86_64-randconfig-072-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   `-- sound-firewire-dice-dice.c:warning:)-at-directive-output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and
|-- x86_64-randconfig-073-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-input-touchscreen-stmpe-ts.c:warning:stmpe_ts_ids-defined-but-not-used
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- x86_64-randconfig-074-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- net-8021q-vlan.c:warning:i-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size-between-and
|   `-- net-tipc-link.c:warning::unknown-directive-output-may-be-truncated-writing-bytes-into-a-region-of-size-between-and
|-- x86_64-randconfig-075-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- x86_64-randconfig-076-20231117
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-leds-leds-pca955x.c:warning:d-directive-output-may-be-truncated-writing-between-and-bytes-into-a-region-of-size
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   `-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|-- xtensa-randconfig-001-20231117
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
|   |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
|   `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
`-- xtensa-randconfig-002-20231117
    |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
    |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
    |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
    |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
    |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
    |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
    |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
    |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
    |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
    |-- drivers-net-ppp-pppoe.c:warning:variable-pde-set-but-not-used
    |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
    |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
    |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
    |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
    |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
    `-- lib-test_ida.c:warning:no-previous-prototype-for-ida_dump
clang_recent_errors
|-- hexagon-allmodconfig
|   |-- arch-hexagon-kernel-process.c:warning:no-previous-prototype-for-function-do_work_pending
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_halt
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_power_off
|   |-- arch-hexagon-kernel-traps.c:warning:no-previous-prototype-for-function-do_genex
|   |-- arch-hexagon-kernel-vdso.c:warning:no-previous-prototype-for-function-arch_setup_additional_pages
|   |-- arch-hexagon-kernel-vm_events.c:warning:no-previous-prototype-for-function-dummy_handler
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-paging_init
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-setup_arch_memory
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-execute_protection_fault
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-write_protection_fault
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_mm
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_page
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_range
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-tlb_flush_all
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-mmc-host-sdhci-of-dwcmshc.c:warning:use-of-bitwise-with-boolean-operands
|   |-- drivers-mtd-nand-raw-lpc32xx_mlc.c:warning:cast-from-irqreturn_t-(-)(int-struct-lpc32xx_nand_host-)-(aka-enum-irqreturn-(-)(int-struct-lpc32xx_nand_host-)-)-to-irq_handler_t-(aka-enum-irqreturn-(-)(in
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-fs-common.c:warning:stack-frame-size-()-exceeds-limit-()-in-bch2_rename_trans
|   |-- kernel-gcov-clang.c:warning:Excess-function-parameter-dest-description-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Excess-function-parameter-source-description-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Function-parameter-or-member-dst-not-described-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Function-parameter-or-member-src-not-described-in-gcov_info_add
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-function-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|   |-- sound-core-seq-seq_midi.c:warning:cast-from-int-(-)(struct-snd_rawmidi_substream-const-char-int)-to-snd_seq_dump_func_t-(aka-int-(-)(void-void-int)-)-converts-to-incompatible-function-type
|   `-- stdin:warning:syscall-clone3-not-implemented-W-warnings
|-- hexagon-allnoconfig
|   |-- arch-hexagon-kernel-process.c:warning:no-previous-prototype-for-function-do_work_pending
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_halt
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_power_off
|   |-- arch-hexagon-kernel-traps.c:warning:no-previous-prototype-for-function-do_genex
|   |-- arch-hexagon-kernel-vdso.c:warning:no-previous-prototype-for-function-arch_setup_additional_pages
|   |-- arch-hexagon-kernel-vm_events.c:warning:no-previous-prototype-for-function-dummy_handler
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-paging_init
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-setup_arch_memory
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-execute_protection_fault
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-write_protection_fault
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_mm
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_page
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_range
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-tlb_flush_all
|   `-- stdin:warning:syscall-clone3-not-implemented-W-warnings
|-- hexagon-allyesconfig
|   |-- arch-hexagon-kernel-process.c:warning:no-previous-prototype-for-function-do_work_pending
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_halt
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_power_off
|   |-- arch-hexagon-kernel-traps.c:warning:no-previous-prototype-for-function-do_genex
|   |-- arch-hexagon-kernel-vdso.c:warning:no-previous-prototype-for-function-arch_setup_additional_pages
|   |-- arch-hexagon-kernel-vm_events.c:warning:no-previous-prototype-for-function-dummy_handler
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-paging_init
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-setup_arch_memory
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-execute_protection_fault
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-write_protection_fault
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_mm
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_page
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_range
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-tlb_flush_all
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- drivers-mmc-host-sdhci-of-dwcmshc.c:warning:use-of-bitwise-with-boolean-operands
|   |-- drivers-mtd-nand-raw-lpc32xx_mlc.c:warning:cast-from-irqreturn_t-(-)(int-struct-lpc32xx_nand_host-)-(aka-enum-irqreturn-(-)(int-struct-lpc32xx_nand_host-)-)-to-irq_handler_t-(aka-enum-irqreturn-(-)(in
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-fs-common.c:warning:stack-frame-size-()-exceeds-limit-()-in-bch2_rename_trans
|   |-- kernel-gcov-clang.c:warning:Excess-function-parameter-dest-description-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Excess-function-parameter-source-description-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Function-parameter-or-member-dst-not-described-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Function-parameter-or-member-src-not-described-in-gcov_info_add
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-function-ida_dump
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
|   |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt
|   |-- sound-core-seq-seq_midi.c:warning:cast-from-int-(-)(struct-snd_rawmidi_substream-const-char-int)-to-snd_seq_dump_func_t-(aka-int-(-)(void-void-int)-)-converts-to-incompatible-function-type
|   `-- stdin:warning:syscall-clone3-not-implemented-W-warnings
|-- hexagon-defconfig
|   |-- arch-hexagon-kernel-process.c:warning:no-previous-prototype-for-function-do_work_pending
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_halt
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_power_off
|   |-- arch-hexagon-kernel-traps.c:warning:no-previous-prototype-for-function-do_genex
|   |-- arch-hexagon-kernel-vdso.c:warning:no-previous-prototype-for-function-arch_setup_additional_pages
|   |-- arch-hexagon-kernel-vm_events.c:warning:no-previous-prototype-for-function-dummy_handler
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-paging_init
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-setup_arch_memory
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-execute_protection_fault
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-write_protection_fault
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_mm
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_page
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_range
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-tlb_flush_all
|   `-- stdin:warning:syscall-clone3-not-implemented-W-warnings
|-- hexagon-randconfig-001-20231117
|   |-- arch-hexagon-kernel-process.c:warning:no-previous-prototype-for-function-do_work_pending
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_halt
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_power_off
|   |-- arch-hexagon-kernel-traps.c:warning:no-previous-prototype-for-function-do_genex
|   |-- arch-hexagon-kernel-vdso.c:warning:no-previous-prototype-for-function-arch_setup_additional_pages
|   |-- arch-hexagon-kernel-vm_events.c:warning:no-previous-prototype-for-function-dummy_handler
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-paging_init
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-setup_arch_memory
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-execute_protection_fault
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-write_protection_fault
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_mm
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_page
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_range
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-tlb_flush_all
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-host-not-described-in-memstick_remove_host
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-mrq-not-described-in-memstick_init_req
|   |-- drivers-memstick-core-memstick.c:warning:Function-parameter-or-member-tpc-not-described-in-memstick_init_req
|   |-- kernel-gcov-clang.c:warning:Excess-function-parameter-dest-description-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Excess-function-parameter-source-description-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Function-parameter-or-member-dst-not-described-in-gcov_info_add
|   |-- kernel-gcov-clang.c:warning:Function-parameter-or-member-src-not-described-in-gcov_info_add
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-in-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-olen-not-described-in-sw842_compress
|   |-- lib-842_compress.c:warning:Function-parameter-or-member-wmem-not-described-in-sw842_compress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-ilen-not-described-in-sw842_decompress
|   |-- lib-842_decompress.c:warning:Function-parameter-or-member-out-not-described-in-sw842_decompress
|   `-- stdin:warning:syscall-clone3-not-implemented-W-warnings
|-- hexagon-randconfig-002-20231117
|   |-- arch-hexagon-kernel-process.c:warning:no-previous-prototype-for-function-do_work_pending
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_halt
|   |-- arch-hexagon-kernel-reset.c:warning:no-previous-prototype-for-function-machine_power_off
|   |-- arch-hexagon-kernel-traps.c:warning:no-previous-prototype-for-function-do_genex
|   |-- arch-hexagon-kernel-vdso.c:warning:no-previous-prototype-for-function-arch_setup_additional_pages
|   |-- arch-hexagon-kernel-vm_events.c:warning:no-previous-prototype-for-function-dummy_handler
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-paging_init
|   |-- arch-hexagon-mm-init.c:warning:no-previous-prototype-for-function-setup_arch_memory
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-execute_protection_fault
|   |-- arch-hexagon-mm-vm_fault.c:warning:no-previous-prototype-for-function-write_protection_fault
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_mm
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_page
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-flush_tlb_range
|   |-- arch-hexagon-mm-vm_tlb.c:warning:no-previous-prototype-for-function-tlb_flush_all
|   |-- block-partitions-aix.c:warning:Function-parameter-or-member-state-not-described-in-read_lba
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-file-not-described-in-binder_task_work_cb
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-length-not-described-in-binder_sg_copy
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-offset-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-skip_size-not-described-in-binder_ptr_fixup
|   |-- drivers-android-binder.c:warning:Function-parameter-or-member-thread-not-described-in-binder_free_buf
|   |-- drivers-android-binder_alloc.c:warning:Function-parameter-or-member-lru-not-described-in-binder_alloc_free_page
|   |-- drivers-mtd-nand-raw-lpc32xx_mlc.c:warning:cast-from-irqreturn_t-(-)(int-struct-lpc32xx_nand_host-)-(aka-enum-irqreturn-(-)(int-struct-lpc32xx_nand_host-)-)-to-irq_handler_t-(aka-enum-irqreturn-(-)(in
|   |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
|   |-- fs-bcachefs-fs-common.c:warning:stack-frame-size-()-exceeds-limit-()-in-bch2_rename_trans
|   |-- lib-test_ida.c:warning:no-previous-prototype-for-function-ida_dump
|   `-- stdin:warning:syscall-clone3-not-implemented-W-warnings
`-- x86_64-rhel-8.3-rust
    |-- drivers-usb-host-xhci.c:warning:Function-parameter-or-member-desc-not-described-in-xhci_get_endpoint_index
    |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-buf-not-described-in-ftrace_set_global_notrace
    |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_global_notrace
    |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-len-not-described-in-ftrace_set_notrace
    |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_filter
    |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_global_notrace
    |-- kernel-trace-ftrace.c:warning:Function-parameter-or-member-reset-not-described-in-ftrace_set_notrace
    |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-level-not-described-in-apparmor_socket_getsockopt
    |-- security-apparmor-lsm.c:warning:Function-parameter-or-member-optname-not-described-in-apparmor_socket_getsockopt
    `-- security-apparmor-lsm.c:warning:Function-parameter-or-member-sock-not-described-in-apparmor_socket_setsockopt

elapsed time: 772m

configs tested: 170
configs skipped: 2

tested configs:
alpha                             allnoconfig   gcc  
alpha                            allyesconfig   gcc  
alpha                               defconfig   gcc  
arc                              allmodconfig   gcc  
arc                               allnoconfig   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                   randconfig-001-20231117   gcc  
arc                   randconfig-002-20231117   gcc  
arm                              allmodconfig   gcc  
arm                               allnoconfig   gcc  
arm                              allyesconfig   gcc  
arm                                 defconfig   gcc  
arm                   randconfig-001-20231117   gcc  
arm                   randconfig-002-20231117   gcc  
arm                   randconfig-003-20231117   gcc  
arm                   randconfig-004-20231117   gcc  
arm64                            allmodconfig   gcc  
arm64                             allnoconfig   gcc  
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                 randconfig-001-20231117   gcc  
arm64                 randconfig-002-20231117   gcc  
arm64                 randconfig-003-20231117   gcc  
arm64                 randconfig-004-20231117   gcc  
csky                             allmodconfig   gcc  
csky                              allnoconfig   gcc  
csky                             allyesconfig   gcc  
csky                                defconfig   gcc  
csky                  randconfig-001-20231117   gcc  
csky                  randconfig-002-20231117   gcc  
hexagon                          allmodconfig   clang
hexagon                           allnoconfig   clang
hexagon                          allyesconfig   clang
hexagon                             defconfig   clang
hexagon               randconfig-001-20231117   clang
hexagon               randconfig-002-20231117   clang
i386                             allmodconfig   gcc  
i386                              allnoconfig   gcc  
i386                             allyesconfig   gcc  
i386         buildonly-randconfig-001-20231117   gcc  
i386         buildonly-randconfig-002-20231117   gcc  
i386         buildonly-randconfig-003-20231117   gcc  
i386         buildonly-randconfig-004-20231117   gcc  
i386         buildonly-randconfig-005-20231117   gcc  
i386         buildonly-randconfig-006-20231117   gcc  
i386                                defconfig   gcc  
i386                  randconfig-001-20231117   gcc  
i386                  randconfig-002-20231117   gcc  
i386                  randconfig-003-20231117   gcc  
i386                  randconfig-004-20231117   gcc  
i386                  randconfig-005-20231117   gcc  
i386                  randconfig-006-20231117   gcc  
i386                  randconfig-011-20231117   gcc  
i386                  randconfig-012-20231117   gcc  
i386                  randconfig-013-20231117   gcc  
i386                  randconfig-014-20231117   gcc  
i386                  randconfig-015-20231117   gcc  
i386                  randconfig-016-20231117   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                        allyesconfig   gcc  
loongarch                           defconfig   gcc  
loongarch             randconfig-001-20231117   gcc  
loongarch             randconfig-002-20231117   gcc  
m68k                             allmodconfig   gcc  
m68k                              allnoconfig   gcc  
m68k                             allyesconfig   gcc  
m68k                                defconfig   gcc  
microblaze                       allmodconfig   gcc  
microblaze                        allnoconfig   gcc  
microblaze                       allyesconfig   gcc  
microblaze                          defconfig   gcc  
mips                             allmodconfig   gcc  
mips                              allnoconfig   gcc  
mips                             allyesconfig   gcc  
nios2                            allmodconfig   gcc  
nios2                             allnoconfig   gcc  
nios2                            allyesconfig   gcc  
nios2                               defconfig   gcc  
nios2                 randconfig-001-20231117   gcc  
nios2                 randconfig-002-20231117   gcc  
openrisc                         allmodconfig   gcc  
openrisc                          allnoconfig   gcc  
openrisc                         allyesconfig   gcc  
openrisc                            defconfig   gcc  
parisc                           allmodconfig   gcc  
parisc                            allnoconfig   gcc  
parisc                           allyesconfig   gcc  
parisc                              defconfig   gcc  
parisc                randconfig-001-20231117   gcc  
parisc                randconfig-002-20231117   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                          allyesconfig   gcc  
powerpc               randconfig-001-20231117   gcc  
powerpc               randconfig-002-20231117   gcc  
powerpc               randconfig-003-20231117   gcc  
powerpc64             randconfig-001-20231117   gcc  
powerpc64             randconfig-002-20231117   gcc  
powerpc64             randconfig-003-20231117   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                            allyesconfig   gcc  
riscv                               defconfig   gcc  
riscv                 randconfig-001-20231117   gcc  
riscv                 randconfig-002-20231117   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                              allnoconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                  randconfig-001-20231117   gcc  
s390                  randconfig-002-20231117   gcc  
sh                               allmodconfig   gcc  
sh                                allnoconfig   gcc  
sh                               allyesconfig   gcc  
sh                                  defconfig   gcc  
sh                    randconfig-001-20231117   gcc  
sh                    randconfig-002-20231117   gcc  
sparc                            allmodconfig   gcc  
sparc                             allnoconfig   gcc  
sparc                            allyesconfig   gcc  
sparc                               defconfig   gcc  
sparc64                          allmodconfig   gcc  
sparc64                          allyesconfig   gcc  
sparc64                             defconfig   gcc  
sparc64               randconfig-001-20231117   gcc  
sparc64               randconfig-002-20231117   gcc  
um                               allmodconfig   gcc  
um                                allnoconfig   gcc  
um                               allyesconfig   gcc  
um                                  defconfig   gcc  
um                             i386_defconfig   gcc  
um                    randconfig-001-20231117   gcc  
um                    randconfig-002-20231117   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64       buildonly-randconfig-001-20231117   gcc  
x86_64       buildonly-randconfig-002-20231117   gcc  
x86_64       buildonly-randconfig-003-20231117   gcc  
x86_64       buildonly-randconfig-004-20231117   gcc  
x86_64       buildonly-randconfig-005-20231117   gcc  
x86_64       buildonly-randconfig-006-20231117   gcc  
x86_64                              defconfig   gcc  
x86_64                randconfig-001-20231117   gcc  
x86_64                randconfig-002-20231117   gcc  
x86_64                randconfig-003-20231117   gcc  
x86_64                randconfig-004-20231117   gcc  
x86_64                randconfig-005-20231117   gcc  
x86_64                randconfig-006-20231117   gcc  
x86_64                randconfig-011-20231117   gcc  
x86_64                randconfig-012-20231117   gcc  
x86_64                randconfig-013-20231117   gcc  
x86_64                randconfig-014-20231117   gcc  
x86_64                randconfig-015-20231117   gcc  
x86_64                randconfig-016-20231117   gcc  
x86_64                randconfig-071-20231117   gcc  
x86_64                randconfig-072-20231117   gcc  
x86_64                randconfig-073-20231117   gcc  
x86_64                randconfig-074-20231117   gcc  
x86_64                randconfig-075-20231117   gcc  
x86_64                randconfig-076-20231117   gcc  
x86_64                          rhel-8.3-rust   clang
xtensa                            allnoconfig   gcc  
xtensa                           allyesconfig   gcc  
xtensa                randconfig-001-20231117   gcc  
xtensa                randconfig-002-20231117   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

