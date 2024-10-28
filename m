Return-Path: <kvm+bounces-29798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A64419B22E3
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 03:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC0991C2099D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 02:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAF118A959;
	Mon, 28 Oct 2024 02:38:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15878169397
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 02:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730083114; cv=none; b=EKhH16g35FVmhYKDJsqZ4IBwVp9WRZSDlN9UhJoJA5WThozLzx/tLvadFRdMdQHzrbqJRqh4Yi+rtwox8t0Ek3C/0th8O6z7TWEfIQ/d8fMbQmuLmXyofoA/ZBa04SR6rjrhgEx/l8RQLH9Ikj73cSfoLK8GPfCQHtgUWkawEHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730083114; c=relaxed/simple;
	bh=4utDQJ44vdd0Rz7wXRQpUIOTvQcKu7z0h7I0+Wf9bKM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evhVpmBqG6NkZ6uEdcsc8nJZSCndncebf3BShAtdYCISzcveRAGt1X69h96gjkzEROzCAYnbw+EGjs1odWsV01JrXwKrqDsv059l104OHp1gpKcsyi8UvuJqdGWlik8bVMAGdtPGwt0V3CUD+qAIT3tHu7/zPk/jp+UzLpk5SZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8DxDeMW+R5nC8wXAA--.49163S3;
	Mon, 28 Oct 2024 10:38:14 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by front1 (Coremail) with SMTP id qMiowMAx18AR+R5nE_sgAA--.13349S5;
	Mon, 28 Oct 2024 10:38:12 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: "Michael S . Tsirkin" <mst@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-devel@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	kvm@vger.kernel.org
Subject: [PATCH v3 3/3] linux-headers: Update to Linux v6.12-rc5
Date: Mon, 28 Oct 2024 10:38:09 +0800
Message-Id: <20241028023809.1554405-4-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20241028023809.1554405-1-maobibo@loongson.cn>
References: <20241028023809.1554405-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMAx18AR+R5nE_sgAA--.13349S5
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==

update linux-headers to v6.12-rc5. Pass to compile on aarch64, arm,
loongarch64, x86_64, i386, riscv64,riscv32 softmmu and linux-user.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 include/standard-headers/drm/drm_fourcc.h     |  43 +++
 include/standard-headers/linux/const.h        |  17 +
 include/standard-headers/linux/ethtool.h      | 226 ++++++++++++
 include/standard-headers/linux/fuse.h         |  22 +-
 .../linux/input-event-codes.h                 |   2 +
 include/standard-headers/linux/pci_regs.h     |  41 ++-
 .../standard-headers/linux/virtio_balloon.h   |  16 +-
 include/standard-headers/linux/virtio_gpu.h   |   1 +
 linux-headers/asm-arm64/mman.h                |   9 +
 linux-headers/asm-arm64/unistd.h              |  25 +-
 linux-headers/asm-arm64/unistd_64.h           | 324 +++++++++++++++++
 linux-headers/asm-generic/unistd.h            |   6 +-
 linux-headers/asm-loongarch/kvm.h             |  24 ++
 linux-headers/asm-loongarch/kvm_para.h        |  21 ++
 linux-headers/asm-loongarch/unistd.h          |   4 +-
 linux-headers/asm-loongarch/unistd_64.h       | 320 +++++++++++++++++
 linux-headers/asm-riscv/kvm.h                 |   7 +
 linux-headers/asm-riscv/unistd.h              |  41 +--
 linux-headers/asm-riscv/unistd_32.h           | 315 +++++++++++++++++
 linux-headers/asm-riscv/unistd_64.h           | 325 ++++++++++++++++++
 linux-headers/asm-x86/kvm.h                   |   2 +
 linux-headers/asm-x86/unistd_64.h             |   1 +
 linux-headers/asm-x86/unistd_x32.h            |   1 +
 linux-headers/linux/bits.h                    |   3 +
 linux-headers/linux/const.h                   |  17 +
 linux-headers/linux/iommufd.h                 | 143 +++++++-
 linux-headers/linux/kvm.h                     |  23 +-
 linux-headers/linux/mman.h                    |   1 +
 linux-headers/linux/psp-sev.h                 |  28 ++
 29 files changed, 1915 insertions(+), 93 deletions(-)
 create mode 100644 linux-headers/asm-arm64/unistd_64.h
 create mode 100644 linux-headers/asm-loongarch/kvm_para.h
 create mode 100644 linux-headers/asm-loongarch/unistd_64.h
 create mode 100644 linux-headers/asm-riscv/unistd_32.h
 create mode 100644 linux-headers/asm-riscv/unistd_64.h

diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index b72917073d..d4a2231306 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -701,6 +701,31 @@ extern "C" {
  */
 #define I915_FORMAT_MOD_4_TILED_MTL_RC_CCS_CC fourcc_mod_code(INTEL, 15)
 
+/*
+ * Intel Color Control Surfaces (CCS) for graphics ver. 20 unified compression
+ * on integrated graphics
+ *
+ * The main surface is Tile 4 and at plane index 0. For semi-planar formats
+ * like NV12, the Y and UV planes are Tile 4 and are located at plane indices
+ * 0 and 1, respectively. The CCS for all planes are stored outside of the
+ * GEM object in a reserved memory area dedicated for the storage of the
+ * CCS data for all compressible GEM objects.
+ */
+#define I915_FORMAT_MOD_4_TILED_LNL_CCS fourcc_mod_code(INTEL, 16)
+
+/*
+ * Intel Color Control Surfaces (CCS) for graphics ver. 20 unified compression
+ * on discrete graphics
+ *
+ * The main surface is Tile 4 and at plane index 0. For semi-planar formats
+ * like NV12, the Y and UV planes are Tile 4 and are located at plane indices
+ * 0 and 1, respectively. The CCS for all planes are stored outside of the
+ * GEM object in a reserved memory area dedicated for the storage of the
+ * CCS data for all compressible GEM objects. The GEM object must be stored in
+ * contiguous memory with a size aligned to 64KB
+ */
+#define I915_FORMAT_MOD_4_TILED_BMG_CCS fourcc_mod_code(INTEL, 17)
+
 /*
  * Tiled, NV12MT, grouped in 64 (pixels) x 32 (lines) -sized macroblocks
  *
@@ -1475,6 +1500,7 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
 #define AMD_FMT_MOD_TILE_VER_GFX10 2
 #define AMD_FMT_MOD_TILE_VER_GFX10_RBPLUS 3
 #define AMD_FMT_MOD_TILE_VER_GFX11 4
+#define AMD_FMT_MOD_TILE_VER_GFX12 5
 
 /*
  * 64K_S is the same for GFX9/GFX10/GFX10_RBPLUS and hence has GFX9 as canonical
@@ -1485,6 +1511,8 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
 /*
  * 64K_D for non-32 bpp is the same for GFX9/GFX10/GFX10_RBPLUS and hence has
  * GFX9 as canonical version.
+ *
+ * 64K_D_2D on GFX12 is identical to 64K_D on GFX11.
  */
 #define AMD_FMT_MOD_TILE_GFX9_64K_D 10
 #define AMD_FMT_MOD_TILE_GFX9_64K_S_X 25
@@ -1492,6 +1520,21 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
 #define AMD_FMT_MOD_TILE_GFX9_64K_R_X 27
 #define AMD_FMT_MOD_TILE_GFX11_256K_R_X 31
 
+/* Gfx12 swizzle modes:
+ *    0 - LINEAR
+ *    1 - 256B_2D  - 2D block dimensions
+ *    2 - 4KB_2D
+ *    3 - 64KB_2D
+ *    4 - 256KB_2D
+ *    5 - 4KB_3D   - 3D block dimensions
+ *    6 - 64KB_3D
+ *    7 - 256KB_3D
+ */
+#define AMD_FMT_MOD_TILE_GFX12_256B_2D 1
+#define AMD_FMT_MOD_TILE_GFX12_4K_2D 2
+#define AMD_FMT_MOD_TILE_GFX12_64K_2D 3
+#define AMD_FMT_MOD_TILE_GFX12_256K_2D 4
+
 #define AMD_FMT_MOD_DCC_BLOCK_64B 0
 #define AMD_FMT_MOD_DCC_BLOCK_128B 1
 #define AMD_FMT_MOD_DCC_BLOCK_256B 2
diff --git a/include/standard-headers/linux/const.h b/include/standard-headers/linux/const.h
index 1eb84b5087..2122610de7 100644
--- a/include/standard-headers/linux/const.h
+++ b/include/standard-headers/linux/const.h
@@ -28,6 +28,23 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
+#if !defined(__ASSEMBLY__)
+/*
+ * Missing __asm__ support
+ *
+ * __BIT128() would not work in the __asm__ code, as it shifts an
+ * 'unsigned __init128' data type as direct representation of
+ * 128 bit constants is not supported in the gcc compiler, as
+ * they get silently truncated.
+ *
+ * TODO: Please revisit this implementation when gcc compiler
+ * starts representing 128 bit constants directly like long
+ * and unsigned long etc. Subsequently drop the comment for
+ * GENMASK_U128() which would then start supporting __asm__ code.
+ */
+#define _BIT128(x)	((unsigned __int128)(1) << (x))
+#endif
+
 #define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
 #define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index b0b4b68410..b05e84825b 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -752,6 +752,197 @@ enum ethtool_module_power_mode {
 	ETHTOOL_MODULE_POWER_MODE_HIGH,
 };
 
+/**
+ * enum ethtool_c33_pse_ext_state - groups of PSE extended states
+ *      functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_STATE_ERROR_CONDITION: Group of error_condition states
+ * @ETHTOOL_C33_PSE_EXT_STATE_MR_MPS_VALID: Group of mr_mps_valid states
+ * @ETHTOOL_C33_PSE_EXT_STATE_MR_PSE_ENABLE: Group of mr_pse_enable states
+ * @ETHTOOL_C33_PSE_EXT_STATE_OPTION_DETECT_TED: Group of option_detect_ted
+ *	states
+ * @ETHTOOL_C33_PSE_EXT_STATE_OPTION_VPORT_LIM: Group of option_vport_lim states
+ * @ETHTOOL_C33_PSE_EXT_STATE_OVLD_DETECTED: Group of ovld_detected states
+ * @ETHTOOL_C33_PSE_EXT_STATE_PD_DLL_POWER_TYPE: Group of pd_dll_power_type
+ *	states
+ * @ETHTOOL_C33_PSE_EXT_STATE_POWER_NOT_AVAILABLE: Group of power_not_available
+ *	states
+ * @ETHTOOL_C33_PSE_EXT_STATE_SHORT_DETECTED: Group of short_detected states
+ */
+enum ethtool_c33_pse_ext_state {
+	ETHTOOL_C33_PSE_EXT_STATE_ERROR_CONDITION = 1,
+	ETHTOOL_C33_PSE_EXT_STATE_MR_MPS_VALID,
+	ETHTOOL_C33_PSE_EXT_STATE_MR_PSE_ENABLE,
+	ETHTOOL_C33_PSE_EXT_STATE_OPTION_DETECT_TED,
+	ETHTOOL_C33_PSE_EXT_STATE_OPTION_VPORT_LIM,
+	ETHTOOL_C33_PSE_EXT_STATE_OVLD_DETECTED,
+	ETHTOOL_C33_PSE_EXT_STATE_PD_DLL_POWER_TYPE,
+	ETHTOOL_C33_PSE_EXT_STATE_POWER_NOT_AVAILABLE,
+	ETHTOOL_C33_PSE_EXT_STATE_SHORT_DETECTED,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_mr_mps_valid - mr_mps_valid states
+ *      functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_MR_MPS_VALID_DETECTED_UNDERLOAD: Underload
+ *	state
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_MR_MPS_VALID_CONNECTION_OPEN: Port is not
+ *	connected
+ *
+ * The PSE monitors either the DC or AC Maintain Power Signature
+ * (MPS, see 33.2.9.1). This variable indicates the presence or absence of
+ * a valid MPS.
+ */
+enum ethtool_c33_pse_ext_substate_mr_mps_valid {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_MR_MPS_VALID_DETECTED_UNDERLOAD = 1,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_MR_MPS_VALID_CONNECTION_OPEN,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_error_condition - error_condition states
+ *      functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_NON_EXISTING_PORT: Non-existing
+ *	port number
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_UNDEFINED_PORT: Undefined port
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_INTERNAL_HW_FAULT: Internal
+ *	hardware fault
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_COMM_ERROR_AFTER_FORCE_ON:
+ *	Communication error after force on
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_UNKNOWN_PORT_STATUS: Unknown
+ *	port status
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_HOST_CRASH_TURN_OFF: Host
+ *	crash turn off
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_HOST_CRASH_FORCE_SHUTDOWN:
+ *	Host crash force shutdown
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_CONFIG_CHANGE: Configuration
+ *	change
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_DETECTED_OVER_TEMP: Over
+ *	temperature detected
+ *
+ * error_condition is a variable indicating the status of
+ * implementation-specific fault conditions or optionally other system faults
+ * that prevent the PSE from meeting the specifications in Table 33–11 and that
+ * require the PSE not to source power. These error conditions are different
+ * from those monitored by the state diagrams in Figure 33–10.
+ */
+enum ethtool_c33_pse_ext_substate_error_condition {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_NON_EXISTING_PORT = 1,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_UNDEFINED_PORT,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_INTERNAL_HW_FAULT,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_COMM_ERROR_AFTER_FORCE_ON,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_UNKNOWN_PORT_STATUS,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_HOST_CRASH_TURN_OFF,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_HOST_CRASH_FORCE_SHUTDOWN,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_CONFIG_CHANGE,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_ERROR_CONDITION_DETECTED_OVER_TEMP,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_mr_pse_enable - mr_pse_enable states
+ *      functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_MR_PSE_ENABLE_DISABLE_PIN_ACTIVE: Disable
+ *	pin active
+ *
+ * mr_pse_enable is control variable that selects PSE operation and test
+ * functions.
+ */
+enum ethtool_c33_pse_ext_substate_mr_pse_enable {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_MR_PSE_ENABLE_DISABLE_PIN_ACTIVE = 1,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_option_detect_ted - option_detect_ted
+ *	states functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_DETECT_TED_DET_IN_PROCESS: Detection
+ *	in process
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_DETECT_TED_CONNECTION_CHECK_ERROR:
+ *	Connection check error
+ *
+ * option_detect_ted is a variable indicating if detection can be performed
+ * by the PSE during the ted_timer interval.
+ */
+enum ethtool_c33_pse_ext_substate_option_detect_ted {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_DETECT_TED_DET_IN_PROCESS = 1,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_DETECT_TED_CONNECTION_CHECK_ERROR,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_option_vport_lim - option_vport_lim states
+ *      functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_VPORT_LIM_HIGH_VOLTAGE: Main supply
+ *	voltage is high
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_VPORT_LIM_LOW_VOLTAGE: Main supply
+ *	voltage is low
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_VPORT_LIM_VOLTAGE_INJECTION: Voltage
+ *	injection into the port
+ *
+ * option_vport_lim is an optional variable indicates if VPSE is out of the
+ * operating range during normal operating state.
+ */
+enum ethtool_c33_pse_ext_substate_option_vport_lim {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_VPORT_LIM_HIGH_VOLTAGE = 1,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_VPORT_LIM_LOW_VOLTAGE,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_OPTION_VPORT_LIM_VOLTAGE_INJECTION,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_ovld_detected - ovld_detected states
+ *      functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_OVLD_DETECTED_OVERLOAD: Overload state
+ *
+ * ovld_detected is a variable indicating if the PSE output current has been
+ * in an overload condition (see 33.2.7.6) for at least TCUT of a one-second
+ * sliding time.
+ */
+enum ethtool_c33_pse_ext_substate_ovld_detected {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_OVLD_DETECTED_OVERLOAD = 1,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_power_not_available - power_not_available
+ *	states functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_BUDGET_EXCEEDED: Power
+ *	budget exceeded for the controller
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_PORT_PW_LIMIT_EXCEEDS_CONTROLLER_BUDGET:
+ *	Configured port power limit exceeded controller power budget
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_PD_REQUEST_EXCEEDS_PORT_LIMIT:
+ *	Power request from PD exceeds port limit
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_HW_PW_LIMIT: Power
+ *	denied due to Hardware power limit
+ *
+ * power_not_available is a variable that is asserted in an
+ * implementation-dependent manner when the PSE is no longer capable of
+ * sourcing sufficient power to support the attached PD. Sufficient power
+ * is defined by classification; see 33.2.6.
+ */
+enum ethtool_c33_pse_ext_substate_power_not_available {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_BUDGET_EXCEEDED =  1,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_PORT_PW_LIMIT_EXCEEDS_CONTROLLER_BUDGET,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_PD_REQUEST_EXCEEDS_PORT_LIMIT,
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_POWER_NOT_AVAILABLE_HW_PW_LIMIT,
+};
+
+/**
+ * enum ethtool_c33_pse_ext_substate_short_detected - short_detected states
+ *      functions. IEEE 802.3-2022 33.2.4.4 Variables
+ *
+ * @ETHTOOL_C33_PSE_EXT_SUBSTATE_SHORT_DETECTED_SHORT_CONDITION: Short
+ *	condition was detected
+ *
+ * short_detected is a variable indicating if the PSE output current has been
+ * in a short circuit condition for TLIM within a sliding window (see 33.2.7.7).
+ */
+enum ethtool_c33_pse_ext_substate_short_detected {
+	ETHTOOL_C33_PSE_EXT_SUBSTATE_SHORT_DETECTED_SHORT_CONDITION = 1,
+};
+
 /**
  * enum ethtool_pse_types - Types of PSE controller.
  * @ETHTOOL_PSE_UNKNOWN: Type of PSE controller is unknown
@@ -877,6 +1068,24 @@ enum ethtool_mm_verify_status {
 	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
 };
 
+/**
+ * enum ethtool_module_fw_flash_status - plug-in module firmware flashing status
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_STARTED: The firmware flashing process has
+ *	started.
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS: The firmware flashing process
+ *	is in progress.
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_COMPLETED: The firmware flashing process was
+ *	completed successfully.
+ * @ETHTOOL_MODULE_FW_FLASH_STATUS_ERROR: The firmware flashing process was
+ *	stopped due to an error.
+ */
+enum ethtool_module_fw_flash_status {
+	ETHTOOL_MODULE_FW_FLASH_STATUS_STARTED = 1,
+	ETHTOOL_MODULE_FW_FLASH_STATUS_IN_PROGRESS,
+	ETHTOOL_MODULE_FW_FLASH_STATUS_COMPLETED,
+	ETHTOOL_MODULE_FW_FLASH_STATUS_ERROR,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
@@ -1845,6 +2054,7 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 99,
 	ETHTOOL_LINK_MODE_10baseT1S_Half_BIT		 = 100,
 	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT	 = 101,
+	ETHTOOL_LINK_MODE_10baseT1BRR_Full_BIT		 = 102,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
@@ -2323,4 +2533,20 @@ struct ethtool_link_settings {
 	 * uint32_t map_lp_advertising[link_mode_masks_nwords];
 	 */
 };
+
+/**
+ * enum phy_upstream - Represents the upstream component a given PHY device
+ * is connected to, as in what is on the other end of the MII bus. Most PHYs
+ * will be attached to an Ethernet MAC controller, but in some cases, there's
+ * an intermediate PHY used as a media-converter, which will driver another
+ * MII interface as its output.
+ * @PHY_UPSTREAM_MAC: Upstream component is a MAC (a switch port,
+ *		      or ethernet controller)
+ * @PHY_UPSTREAM_PHY: Upstream component is a PHY (likely a media converter)
+ */
+enum phy_upstream {
+	PHY_UPSTREAM_MAC,
+	PHY_UPSTREAM_PHY,
+};
+
 #endif /* _LINUX_ETHTOOL_H */
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index bac9dbc49f..889e12ad15 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -217,6 +217,9 @@
  *  - add backing_id to fuse_open_out, add FOPEN_PASSTHROUGH open flag
  *  - add FUSE_NO_EXPORT_SUPPORT init flag
  *  - add FUSE_NOTIFY_RESEND, add FUSE_HAS_RESEND init flag
+ *
+ *  7.41
+ *  - add FUSE_ALLOW_IDMAP
  */
 
 #ifndef _LINUX_FUSE_H
@@ -248,7 +251,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 40
+#define FUSE_KERNEL_MINOR_VERSION 41
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -417,6 +420,7 @@ struct fuse_file_lock {
  * FUSE_NO_EXPORT_SUPPORT: explicitly disable export support
  * FUSE_HAS_RESEND: kernel supports resending pending requests, and the high bit
  *		    of the request ID indicates resend requests
+ * FUSE_ALLOW_IDMAP: allow creation of idmapped mounts
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -462,6 +466,7 @@ struct fuse_file_lock {
 
 /* Obsolete alias for FUSE_DIRECT_IO_ALLOW_MMAP */
 #define FUSE_DIRECT_IO_RELAX	FUSE_DIRECT_IO_ALLOW_MMAP
+#define FUSE_ALLOW_IDMAP	(1ULL << 40)
 
 /**
  * CUSE INIT request/reply flags
@@ -980,6 +985,21 @@ struct fuse_fallocate_in {
  */
 #define FUSE_UNIQUE_RESEND (1ULL << 63)
 
+/**
+ * This value will be set by the kernel to
+ * (struct fuse_in_header).{uid,gid} fields in
+ * case when:
+ * - fuse daemon enabled FUSE_ALLOW_IDMAP
+ * - idmapping information is not available and uid/gid
+ *   can not be mapped in accordance with an idmapping.
+ *
+ * Note: an idmapping information always available
+ * for inode creation operations like:
+ * FUSE_MKNOD, FUSE_SYMLINK, FUSE_MKDIR, FUSE_TMPFILE,
+ * FUSE_CREATE and FUSE_RENAME2 (with RENAME_WHITEOUT).
+ */
+#define FUSE_INVALID_UIDGID ((uint32_t)(-1))
+
 struct fuse_in_header {
 	uint32_t	len;
 	uint32_t	opcode;
diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index 2221b0c383..50b2b7497e 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -618,6 +618,8 @@
 #define KEY_CAMERA_ACCESS_ENABLE	0x24b	/* Enables programmatic access to camera devices. (HUTRR72) */
 #define KEY_CAMERA_ACCESS_DISABLE	0x24c	/* Disables programmatic access to camera devices. (HUTRR72) */
 #define KEY_CAMERA_ACCESS_TOGGLE	0x24d	/* Toggles the current state of the camera access control. (HUTRR72) */
+#define KEY_ACCESSIBILITY		0x24e	/* Toggles the system bound accessibility UI/command (HUTRR116) */
+#define KEY_DO_NOT_DISTURB		0x24f	/* Toggles the system-wide "Do Not Disturb" control (HUTRR94)*/
 
 #define KEY_BRIGHTNESS_MIN		0x250	/* Set Brightness to Minimum */
 #define KEY_BRIGHTNESS_MAX		0x251	/* Set Brightness to Maximum */
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index 94c00996e6..12323b3334 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -634,9 +634,11 @@
 #define  PCI_EXP_RTCTL_SENFEE	0x0002	/* System Error on Non-Fatal Error */
 #define  PCI_EXP_RTCTL_SEFEE	0x0004	/* System Error on Fatal Error */
 #define  PCI_EXP_RTCTL_PMEIE	0x0008	/* PME Interrupt Enable */
-#define  PCI_EXP_RTCTL_CRSSVE	0x0010	/* CRS Software Visibility Enable */
+#define  PCI_EXP_RTCTL_RRS_SVE	0x0010	/* Config RRS Software Visibility Enable */
+#define  PCI_EXP_RTCTL_CRSSVE PCI_EXP_RTCTL_RRS_SVE /* compatibility */
 #define PCI_EXP_RTCAP		0x1e	/* Root Capabilities */
-#define  PCI_EXP_RTCAP_CRSVIS	0x0001	/* CRS Software Visibility capability */
+#define  PCI_EXP_RTCAP_RRS_SV	0x0001	/* Config RRS Software Visibility */
+#define  PCI_EXP_RTCAP_CRSVIS PCI_EXP_RTCAP_RRS_SV /* compatibility */
 #define PCI_EXP_RTSTA		0x20	/* Root Status */
 #define  PCI_EXP_RTSTA_PME_RQ_ID 0x0000ffff /* PME Requester ID */
 #define  PCI_EXP_RTSTA_PME	0x00010000 /* PME status */
@@ -740,6 +742,7 @@
 #define PCI_EXT_CAP_ID_DVSEC	0x23	/* Designated Vendor-Specific */
 #define PCI_EXT_CAP_ID_DLF	0x25	/* Data Link Feature */
 #define PCI_EXT_CAP_ID_PL_16GT	0x26	/* Physical Layer 16.0 GT/s */
+#define PCI_EXT_CAP_ID_NPEM	0x29	/* Native PCIe Enclosure Management */
 #define PCI_EXT_CAP_ID_PL_32GT  0x2A    /* Physical Layer 32.0 GT/s */
 #define PCI_EXT_CAP_ID_DOE	0x2E	/* Data Object Exchange */
 #define PCI_EXT_CAP_ID_MAX	PCI_EXT_CAP_ID_DOE
@@ -1121,6 +1124,40 @@
 #define  PCI_PL_16GT_LE_CTRL_USP_TX_PRESET_MASK		0x000000F0
 #define  PCI_PL_16GT_LE_CTRL_USP_TX_PRESET_SHIFT	4
 
+/* Native PCIe Enclosure Management */
+#define PCI_NPEM_CAP     0x04 /* NPEM capability register */
+#define  PCI_NPEM_CAP_CAPABLE     0x00000001 /* NPEM Capable */
+
+#define PCI_NPEM_CTRL    0x08 /* NPEM control register */
+#define  PCI_NPEM_CTRL_ENABLE     0x00000001 /* NPEM Enable */
+
+/*
+ * Native PCIe Enclosure Management indication bits and Reset command bit
+ * are corresponding for capability and control registers.
+ */
+#define  PCI_NPEM_CMD_RESET       0x00000002 /* Reset Command */
+#define  PCI_NPEM_IND_OK          0x00000004 /* OK */
+#define  PCI_NPEM_IND_LOCATE      0x00000008 /* Locate */
+#define  PCI_NPEM_IND_FAIL        0x00000010 /* Fail */
+#define  PCI_NPEM_IND_REBUILD     0x00000020 /* Rebuild */
+#define  PCI_NPEM_IND_PFA         0x00000040 /* Predicted Failure Analysis */
+#define  PCI_NPEM_IND_HOTSPARE    0x00000080 /* Hot Spare */
+#define  PCI_NPEM_IND_ICA         0x00000100 /* In Critical Array */
+#define  PCI_NPEM_IND_IFA         0x00000200 /* In Failed Array */
+#define  PCI_NPEM_IND_IDT         0x00000400 /* Device Type */
+#define  PCI_NPEM_IND_DISABLED    0x00000800 /* Disabled */
+#define  PCI_NPEM_IND_SPEC_0      0x01000000
+#define  PCI_NPEM_IND_SPEC_1      0x02000000
+#define  PCI_NPEM_IND_SPEC_2      0x04000000
+#define  PCI_NPEM_IND_SPEC_3      0x08000000
+#define  PCI_NPEM_IND_SPEC_4      0x10000000
+#define  PCI_NPEM_IND_SPEC_5      0x20000000
+#define  PCI_NPEM_IND_SPEC_6      0x40000000
+#define  PCI_NPEM_IND_SPEC_7      0x80000000
+
+#define PCI_NPEM_STATUS  0x0c /* NPEM status register */
+#define  PCI_NPEM_STATUS_CC       0x00000001 /* Command Completed */
+
 /* Data Object Exchange */
 #define PCI_DOE_CAP		0x04    /* DOE Capabilities Register */
 #define  PCI_DOE_CAP_INT_SUP			0x00000001  /* Interrupt Support */
diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
index f343bfefd8..3121cd2e0e 100644
--- a/include/standard-headers/linux/virtio_balloon.h
+++ b/include/standard-headers/linux/virtio_balloon.h
@@ -71,7 +71,13 @@ struct virtio_balloon_config {
 #define VIRTIO_BALLOON_S_CACHES   7   /* Disk caches */
 #define VIRTIO_BALLOON_S_HTLB_PGALLOC  8  /* Hugetlb page allocations */
 #define VIRTIO_BALLOON_S_HTLB_PGFAIL   9  /* Hugetlb page allocation failures */
-#define VIRTIO_BALLOON_S_NR       10
+#define VIRTIO_BALLOON_S_OOM_KILL      10 /* OOM killer invocations */
+#define VIRTIO_BALLOON_S_ALLOC_STALL   11 /* Stall count of memory allocatoin */
+#define VIRTIO_BALLOON_S_ASYNC_SCAN    12 /* Amount of memory scanned asynchronously */
+#define VIRTIO_BALLOON_S_DIRECT_SCAN   13 /* Amount of memory scanned directly */
+#define VIRTIO_BALLOON_S_ASYNC_RECLAIM 14 /* Amount of memory reclaimed asynchronously */
+#define VIRTIO_BALLOON_S_DIRECT_RECLAIM 15 /* Amount of memory reclaimed directly */
+#define VIRTIO_BALLOON_S_NR       16
 
 #define VIRTIO_BALLOON_S_NAMES_WITH_PREFIX(VIRTIO_BALLOON_S_NAMES_prefix) { \
 	VIRTIO_BALLOON_S_NAMES_prefix "swap-in", \
@@ -83,7 +89,13 @@ struct virtio_balloon_config {
 	VIRTIO_BALLOON_S_NAMES_prefix "available-memory", \
 	VIRTIO_BALLOON_S_NAMES_prefix "disk-caches", \
 	VIRTIO_BALLOON_S_NAMES_prefix "hugetlb-allocations", \
-	VIRTIO_BALLOON_S_NAMES_prefix "hugetlb-failures" \
+	VIRTIO_BALLOON_S_NAMES_prefix "hugetlb-failures", \
+	VIRTIO_BALLOON_S_NAMES_prefix "oom-kills", \
+	VIRTIO_BALLOON_S_NAMES_prefix "alloc-stalls", \
+	VIRTIO_BALLOON_S_NAMES_prefix "async-scans", \
+	VIRTIO_BALLOON_S_NAMES_prefix "direct-scans", \
+	VIRTIO_BALLOON_S_NAMES_prefix "async-reclaims", \
+	VIRTIO_BALLOON_S_NAMES_prefix "direct-reclaims" \
 }
 
 #define VIRTIO_BALLOON_S_NAMES VIRTIO_BALLOON_S_NAMES_WITH_PREFIX("")
diff --git a/include/standard-headers/linux/virtio_gpu.h b/include/standard-headers/linux/virtio_gpu.h
index 2db643ed8f..6459fdb9fb 100644
--- a/include/standard-headers/linux/virtio_gpu.h
+++ b/include/standard-headers/linux/virtio_gpu.h
@@ -311,6 +311,7 @@ struct virtio_gpu_cmd_submit {
 #define VIRTIO_GPU_CAPSET_VIRGL2 2
 /* 3 is reserved for gfxstream */
 #define VIRTIO_GPU_CAPSET_VENUS 4
+#define VIRTIO_GPU_CAPSET_DRM 6
 
 /* VIRTIO_GPU_CMD_GET_CAPSET_INFO */
 struct virtio_gpu_get_capset_info {
diff --git a/linux-headers/asm-arm64/mman.h b/linux-headers/asm-arm64/mman.h
index d0dbfe9587..7b500a3a7b 100644
--- a/linux-headers/asm-arm64/mman.h
+++ b/linux-headers/asm-arm64/mman.h
@@ -7,4 +7,13 @@
 #define PROT_BTI	0x10		/* BTI guarded page */
 #define PROT_MTE	0x20		/* Normal Tagged mapping */
 
+/* Override any generic PKEY permission defines */
+#define PKEY_DISABLE_EXECUTE	0x4
+#define PKEY_DISABLE_READ	0x8
+#undef PKEY_ACCESS_MASK
+#define PKEY_ACCESS_MASK       (PKEY_DISABLE_ACCESS |\
+				PKEY_DISABLE_WRITE  |\
+				PKEY_DISABLE_READ   |\
+				PKEY_DISABLE_EXECUTE)
+
 #endif /* ! _UAPI__ASM_MMAN_H */
diff --git a/linux-headers/asm-arm64/unistd.h b/linux-headers/asm-arm64/unistd.h
index ce2ee8f1e3..df36f23876 100644
--- a/linux-headers/asm-arm64/unistd.h
+++ b/linux-headers/asm-arm64/unistd.h
@@ -1,25 +1,2 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/*
- * Copyright (C) 2012 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-
-#define __ARCH_WANT_RENAMEAT
-#define __ARCH_WANT_NEW_STAT
-#define __ARCH_WANT_SET_GET_RLIMIT
-#define __ARCH_WANT_TIME32_SYSCALLS
-#define __ARCH_WANT_SYS_CLONE3
-#define __ARCH_WANT_MEMFD_SECRET
-
-#include <asm-generic/unistd.h>
+#include <asm/unistd_64.h>
diff --git a/linux-headers/asm-arm64/unistd_64.h b/linux-headers/asm-arm64/unistd_64.h
new file mode 100644
index 0000000000..99a1d70459
--- /dev/null
+++ b/linux-headers/asm-arm64/unistd_64.h
@@ -0,0 +1,324 @@
+#ifndef _ASM_UNISTD_64_H
+#define _ASM_UNISTD_64_H
+
+#define __NR_io_setup 0
+#define __NR_io_destroy 1
+#define __NR_io_submit 2
+#define __NR_io_cancel 3
+#define __NR_io_getevents 4
+#define __NR_setxattr 5
+#define __NR_lsetxattr 6
+#define __NR_fsetxattr 7
+#define __NR_getxattr 8
+#define __NR_lgetxattr 9
+#define __NR_fgetxattr 10
+#define __NR_listxattr 11
+#define __NR_llistxattr 12
+#define __NR_flistxattr 13
+#define __NR_removexattr 14
+#define __NR_lremovexattr 15
+#define __NR_fremovexattr 16
+#define __NR_getcwd 17
+#define __NR_lookup_dcookie 18
+#define __NR_eventfd2 19
+#define __NR_epoll_create1 20
+#define __NR_epoll_ctl 21
+#define __NR_epoll_pwait 22
+#define __NR_dup 23
+#define __NR_dup3 24
+#define __NR_fcntl 25
+#define __NR_inotify_init1 26
+#define __NR_inotify_add_watch 27
+#define __NR_inotify_rm_watch 28
+#define __NR_ioctl 29
+#define __NR_ioprio_set 30
+#define __NR_ioprio_get 31
+#define __NR_flock 32
+#define __NR_mknodat 33
+#define __NR_mkdirat 34
+#define __NR_unlinkat 35
+#define __NR_symlinkat 36
+#define __NR_linkat 37
+#define __NR_renameat 38
+#define __NR_umount2 39
+#define __NR_mount 40
+#define __NR_pivot_root 41
+#define __NR_nfsservctl 42
+#define __NR_statfs 43
+#define __NR_fstatfs 44
+#define __NR_truncate 45
+#define __NR_ftruncate 46
+#define __NR_fallocate 47
+#define __NR_faccessat 48
+#define __NR_chdir 49
+#define __NR_fchdir 50
+#define __NR_chroot 51
+#define __NR_fchmod 52
+#define __NR_fchmodat 53
+#define __NR_fchownat 54
+#define __NR_fchown 55
+#define __NR_openat 56
+#define __NR_close 57
+#define __NR_vhangup 58
+#define __NR_pipe2 59
+#define __NR_quotactl 60
+#define __NR_getdents64 61
+#define __NR_lseek 62
+#define __NR_read 63
+#define __NR_write 64
+#define __NR_readv 65
+#define __NR_writev 66
+#define __NR_pread64 67
+#define __NR_pwrite64 68
+#define __NR_preadv 69
+#define __NR_pwritev 70
+#define __NR_sendfile 71
+#define __NR_pselect6 72
+#define __NR_ppoll 73
+#define __NR_signalfd4 74
+#define __NR_vmsplice 75
+#define __NR_splice 76
+#define __NR_tee 77
+#define __NR_readlinkat 78
+#define __NR_newfstatat 79
+#define __NR_fstat 80
+#define __NR_sync 81
+#define __NR_fsync 82
+#define __NR_fdatasync 83
+#define __NR_sync_file_range 84
+#define __NR_timerfd_create 85
+#define __NR_timerfd_settime 86
+#define __NR_timerfd_gettime 87
+#define __NR_utimensat 88
+#define __NR_acct 89
+#define __NR_capget 90
+#define __NR_capset 91
+#define __NR_personality 92
+#define __NR_exit 93
+#define __NR_exit_group 94
+#define __NR_waitid 95
+#define __NR_set_tid_address 96
+#define __NR_unshare 97
+#define __NR_futex 98
+#define __NR_set_robust_list 99
+#define __NR_get_robust_list 100
+#define __NR_nanosleep 101
+#define __NR_getitimer 102
+#define __NR_setitimer 103
+#define __NR_kexec_load 104
+#define __NR_init_module 105
+#define __NR_delete_module 106
+#define __NR_timer_create 107
+#define __NR_timer_gettime 108
+#define __NR_timer_getoverrun 109
+#define __NR_timer_settime 110
+#define __NR_timer_delete 111
+#define __NR_clock_settime 112
+#define __NR_clock_gettime 113
+#define __NR_clock_getres 114
+#define __NR_clock_nanosleep 115
+#define __NR_syslog 116
+#define __NR_ptrace 117
+#define __NR_sched_setparam 118
+#define __NR_sched_setscheduler 119
+#define __NR_sched_getscheduler 120
+#define __NR_sched_getparam 121
+#define __NR_sched_setaffinity 122
+#define __NR_sched_getaffinity 123
+#define __NR_sched_yield 124
+#define __NR_sched_get_priority_max 125
+#define __NR_sched_get_priority_min 126
+#define __NR_sched_rr_get_interval 127
+#define __NR_restart_syscall 128
+#define __NR_kill 129
+#define __NR_tkill 130
+#define __NR_tgkill 131
+#define __NR_sigaltstack 132
+#define __NR_rt_sigsuspend 133
+#define __NR_rt_sigaction 134
+#define __NR_rt_sigprocmask 135
+#define __NR_rt_sigpending 136
+#define __NR_rt_sigtimedwait 137
+#define __NR_rt_sigqueueinfo 138
+#define __NR_rt_sigreturn 139
+#define __NR_setpriority 140
+#define __NR_getpriority 141
+#define __NR_reboot 142
+#define __NR_setregid 143
+#define __NR_setgid 144
+#define __NR_setreuid 145
+#define __NR_setuid 146
+#define __NR_setresuid 147
+#define __NR_getresuid 148
+#define __NR_setresgid 149
+#define __NR_getresgid 150
+#define __NR_setfsuid 151
+#define __NR_setfsgid 152
+#define __NR_times 153
+#define __NR_setpgid 154
+#define __NR_getpgid 155
+#define __NR_getsid 156
+#define __NR_setsid 157
+#define __NR_getgroups 158
+#define __NR_setgroups 159
+#define __NR_uname 160
+#define __NR_sethostname 161
+#define __NR_setdomainname 162
+#define __NR_getrlimit 163
+#define __NR_setrlimit 164
+#define __NR_getrusage 165
+#define __NR_umask 166
+#define __NR_prctl 167
+#define __NR_getcpu 168
+#define __NR_gettimeofday 169
+#define __NR_settimeofday 170
+#define __NR_adjtimex 171
+#define __NR_getpid 172
+#define __NR_getppid 173
+#define __NR_getuid 174
+#define __NR_geteuid 175
+#define __NR_getgid 176
+#define __NR_getegid 177
+#define __NR_gettid 178
+#define __NR_sysinfo 179
+#define __NR_mq_open 180
+#define __NR_mq_unlink 181
+#define __NR_mq_timedsend 182
+#define __NR_mq_timedreceive 183
+#define __NR_mq_notify 184
+#define __NR_mq_getsetattr 185
+#define __NR_msgget 186
+#define __NR_msgctl 187
+#define __NR_msgrcv 188
+#define __NR_msgsnd 189
+#define __NR_semget 190
+#define __NR_semctl 191
+#define __NR_semtimedop 192
+#define __NR_semop 193
+#define __NR_shmget 194
+#define __NR_shmctl 195
+#define __NR_shmat 196
+#define __NR_shmdt 197
+#define __NR_socket 198
+#define __NR_socketpair 199
+#define __NR_bind 200
+#define __NR_listen 201
+#define __NR_accept 202
+#define __NR_connect 203
+#define __NR_getsockname 204
+#define __NR_getpeername 205
+#define __NR_sendto 206
+#define __NR_recvfrom 207
+#define __NR_setsockopt 208
+#define __NR_getsockopt 209
+#define __NR_shutdown 210
+#define __NR_sendmsg 211
+#define __NR_recvmsg 212
+#define __NR_readahead 213
+#define __NR_brk 214
+#define __NR_munmap 215
+#define __NR_mremap 216
+#define __NR_add_key 217
+#define __NR_request_key 218
+#define __NR_keyctl 219
+#define __NR_clone 220
+#define __NR_execve 221
+#define __NR_mmap 222
+#define __NR_fadvise64 223
+#define __NR_swapon 224
+#define __NR_swapoff 225
+#define __NR_mprotect 226
+#define __NR_msync 227
+#define __NR_mlock 228
+#define __NR_munlock 229
+#define __NR_mlockall 230
+#define __NR_munlockall 231
+#define __NR_mincore 232
+#define __NR_madvise 233
+#define __NR_remap_file_pages 234
+#define __NR_mbind 235
+#define __NR_get_mempolicy 236
+#define __NR_set_mempolicy 237
+#define __NR_migrate_pages 238
+#define __NR_move_pages 239
+#define __NR_rt_tgsigqueueinfo 240
+#define __NR_perf_event_open 241
+#define __NR_accept4 242
+#define __NR_recvmmsg 243
+#define __NR_wait4 260
+#define __NR_prlimit64 261
+#define __NR_fanotify_init 262
+#define __NR_fanotify_mark 263
+#define __NR_name_to_handle_at 264
+#define __NR_open_by_handle_at 265
+#define __NR_clock_adjtime 266
+#define __NR_syncfs 267
+#define __NR_setns 268
+#define __NR_sendmmsg 269
+#define __NR_process_vm_readv 270
+#define __NR_process_vm_writev 271
+#define __NR_kcmp 272
+#define __NR_finit_module 273
+#define __NR_sched_setattr 274
+#define __NR_sched_getattr 275
+#define __NR_renameat2 276
+#define __NR_seccomp 277
+#define __NR_getrandom 278
+#define __NR_memfd_create 279
+#define __NR_bpf 280
+#define __NR_execveat 281
+#define __NR_userfaultfd 282
+#define __NR_membarrier 283
+#define __NR_mlock2 284
+#define __NR_copy_file_range 285
+#define __NR_preadv2 286
+#define __NR_pwritev2 287
+#define __NR_pkey_mprotect 288
+#define __NR_pkey_alloc 289
+#define __NR_pkey_free 290
+#define __NR_statx 291
+#define __NR_io_pgetevents 292
+#define __NR_rseq 293
+#define __NR_kexec_file_load 294
+#define __NR_pidfd_send_signal 424
+#define __NR_io_uring_setup 425
+#define __NR_io_uring_enter 426
+#define __NR_io_uring_register 427
+#define __NR_open_tree 428
+#define __NR_move_mount 429
+#define __NR_fsopen 430
+#define __NR_fsconfig 431
+#define __NR_fsmount 432
+#define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
+#define __NR_close_range 436
+#define __NR_openat2 437
+#define __NR_pidfd_getfd 438
+#define __NR_faccessat2 439
+#define __NR_process_madvise 440
+#define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_quotactl_fd 443
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
+#define __NR_memfd_secret 447
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
+#define __NR_cachestat 451
+#define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
+#define __NR_mseal 462
+
+
+#endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index d983c48a3b..5bf6148cac 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -737,7 +737,7 @@ __SC_COMP(__NR_pselect6_time64, sys_pselect6, compat_sys_pselect6_time64)
 #define __NR_ppoll_time64 414
 __SC_COMP(__NR_ppoll_time64, sys_ppoll, compat_sys_ppoll_time64)
 #define __NR_io_pgetevents_time64 416
-__SYSCALL(__NR_io_pgetevents_time64, sys_io_pgetevents)
+__SC_COMP(__NR_io_pgetevents_time64, sys_io_pgetevents, compat_sys_io_pgetevents_time64)
 #define __NR_recvmmsg_time64 417
 __SC_COMP(__NR_recvmmsg_time64, sys_recvmmsg, compat_sys_recvmmsg_time64)
 #define __NR_mq_timedsend_time64 418
@@ -776,12 +776,8 @@ __SYSCALL(__NR_fsmount, sys_fsmount)
 __SYSCALL(__NR_fspick, sys_fspick)
 #define __NR_pidfd_open 434
 __SYSCALL(__NR_pidfd_open, sys_pidfd_open)
-
-#ifdef __ARCH_WANT_SYS_CLONE3
 #define __NR_clone3 435
 __SYSCALL(__NR_clone3, sys_clone3)
-#endif
-
 #define __NR_close_range 436
 __SYSCALL(__NR_close_range, sys_close_range)
 #define __NR_openat2 437
diff --git a/linux-headers/asm-loongarch/kvm.h b/linux-headers/asm-loongarch/kvm.h
index f9abef3823..70d89070bf 100644
--- a/linux-headers/asm-loongarch/kvm.h
+++ b/linux-headers/asm-loongarch/kvm.h
@@ -64,6 +64,7 @@ struct kvm_fpu {
 #define KVM_REG_LOONGARCH_KVM		(KVM_REG_LOONGARCH | 0x20000ULL)
 #define KVM_REG_LOONGARCH_FPSIMD	(KVM_REG_LOONGARCH | 0x30000ULL)
 #define KVM_REG_LOONGARCH_CPUCFG	(KVM_REG_LOONGARCH | 0x40000ULL)
+#define KVM_REG_LOONGARCH_LBT		(KVM_REG_LOONGARCH | 0x50000ULL)
 #define KVM_REG_LOONGARCH_MASK		(KVM_REG_LOONGARCH | 0x70000ULL)
 #define KVM_CSR_IDX_MASK		0x7fff
 #define KVM_CPUCFG_IDX_MASK		0x7fff
@@ -77,11 +78,34 @@ struct kvm_fpu {
 /* Debugging: Special instruction for software breakpoint */
 #define KVM_REG_LOONGARCH_DEBUG_INST	(KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
 
+/* LBT registers */
+#define KVM_REG_LOONGARCH_LBT_SCR0	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 1)
+#define KVM_REG_LOONGARCH_LBT_SCR1	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 2)
+#define KVM_REG_LOONGARCH_LBT_SCR2	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 3)
+#define KVM_REG_LOONGARCH_LBT_SCR3	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 4)
+#define KVM_REG_LOONGARCH_LBT_EFLAGS	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 5)
+#define KVM_REG_LOONGARCH_LBT_FTOP	(KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 6)
+
 #define LOONGARCH_REG_SHIFT		3
 #define LOONGARCH_REG_64(TYPE, REG)	(TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
 #define KVM_IOC_CSRID(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
 #define KVM_IOC_CPUCFG(REG)		LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
+
+/* Device Control API on vm fd */
+#define KVM_LOONGARCH_VM_FEAT_CTRL		0
+#define  KVM_LOONGARCH_VM_FEAT_LSX		0
+#define  KVM_LOONGARCH_VM_FEAT_LASX		1
+#define  KVM_LOONGARCH_VM_FEAT_X86BT		2
+#define  KVM_LOONGARCH_VM_FEAT_ARMBT		3
+#define  KVM_LOONGARCH_VM_FEAT_MIPSBT		4
+#define  KVM_LOONGARCH_VM_FEAT_PMU		5
+#define  KVM_LOONGARCH_VM_FEAT_PV_IPI		6
+#define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME	7
+
+/* Device Control API on vcpu fd */
 #define KVM_LOONGARCH_VCPU_CPUCFG	0
+#define KVM_LOONGARCH_VCPU_PVTIME_CTRL	1
+#define  KVM_LOONGARCH_VCPU_PVTIME_GPA	0
 
 struct kvm_debug_exit_arch {
 };
diff --git a/linux-headers/asm-loongarch/kvm_para.h b/linux-headers/asm-loongarch/kvm_para.h
new file mode 100644
index 0000000000..4ba4ad8db1
--- /dev/null
+++ b/linux-headers/asm-loongarch/kvm_para.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _ASM_KVM_PARA_H
+#define _ASM_KVM_PARA_H
+
+#include <linux/types.h>
+
+/*
+ * CPUCFG index area: 0x40000000 -- 0x400000ff
+ * SW emulation for KVM hypervirsor
+ */
+#define CPUCFG_KVM_BASE			0x40000000
+#define CPUCFG_KVM_SIZE			0x100
+#define CPUCFG_KVM_SIG			(CPUCFG_KVM_BASE + 0)
+#define  KVM_SIGNATURE			"KVM\0"
+#define CPUCFG_KVM_FEATURE		(CPUCFG_KVM_BASE + 4)
+#define  KVM_FEATURE_IPI		1
+#define  KVM_FEATURE_STEAL_TIME		2
+/* BIT 24 - 31 are features configurable by user space vmm */
+#define  KVM_FEATURE_VIRT_EXTIOI	24
+
+#endif /* _ASM_KVM_PARA_H */
diff --git a/linux-headers/asm-loongarch/unistd.h b/linux-headers/asm-loongarch/unistd.h
index fcb668984f..1f01980f9c 100644
--- a/linux-headers/asm-loongarch/unistd.h
+++ b/linux-headers/asm-loongarch/unistd.h
@@ -1,5 +1,3 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#define __ARCH_WANT_SYS_CLONE
-#define __ARCH_WANT_SYS_CLONE3
 
-#include <asm-generic/unistd.h>
+#include <asm/unistd_64.h>
diff --git a/linux-headers/asm-loongarch/unistd_64.h b/linux-headers/asm-loongarch/unistd_64.h
new file mode 100644
index 0000000000..887ea50cca
--- /dev/null
+++ b/linux-headers/asm-loongarch/unistd_64.h
@@ -0,0 +1,320 @@
+#ifndef _ASM_UNISTD_64_H
+#define _ASM_UNISTD_64_H
+
+#define __NR_io_setup 0
+#define __NR_io_destroy 1
+#define __NR_io_submit 2
+#define __NR_io_cancel 3
+#define __NR_io_getevents 4
+#define __NR_setxattr 5
+#define __NR_lsetxattr 6
+#define __NR_fsetxattr 7
+#define __NR_getxattr 8
+#define __NR_lgetxattr 9
+#define __NR_fgetxattr 10
+#define __NR_listxattr 11
+#define __NR_llistxattr 12
+#define __NR_flistxattr 13
+#define __NR_removexattr 14
+#define __NR_lremovexattr 15
+#define __NR_fremovexattr 16
+#define __NR_getcwd 17
+#define __NR_lookup_dcookie 18
+#define __NR_eventfd2 19
+#define __NR_epoll_create1 20
+#define __NR_epoll_ctl 21
+#define __NR_epoll_pwait 22
+#define __NR_dup 23
+#define __NR_dup3 24
+#define __NR_fcntl 25
+#define __NR_inotify_init1 26
+#define __NR_inotify_add_watch 27
+#define __NR_inotify_rm_watch 28
+#define __NR_ioctl 29
+#define __NR_ioprio_set 30
+#define __NR_ioprio_get 31
+#define __NR_flock 32
+#define __NR_mknodat 33
+#define __NR_mkdirat 34
+#define __NR_unlinkat 35
+#define __NR_symlinkat 36
+#define __NR_linkat 37
+#define __NR_umount2 39
+#define __NR_mount 40
+#define __NR_pivot_root 41
+#define __NR_nfsservctl 42
+#define __NR_statfs 43
+#define __NR_fstatfs 44
+#define __NR_truncate 45
+#define __NR_ftruncate 46
+#define __NR_fallocate 47
+#define __NR_faccessat 48
+#define __NR_chdir 49
+#define __NR_fchdir 50
+#define __NR_chroot 51
+#define __NR_fchmod 52
+#define __NR_fchmodat 53
+#define __NR_fchownat 54
+#define __NR_fchown 55
+#define __NR_openat 56
+#define __NR_close 57
+#define __NR_vhangup 58
+#define __NR_pipe2 59
+#define __NR_quotactl 60
+#define __NR_getdents64 61
+#define __NR_lseek 62
+#define __NR_read 63
+#define __NR_write 64
+#define __NR_readv 65
+#define __NR_writev 66
+#define __NR_pread64 67
+#define __NR_pwrite64 68
+#define __NR_preadv 69
+#define __NR_pwritev 70
+#define __NR_sendfile 71
+#define __NR_pselect6 72
+#define __NR_ppoll 73
+#define __NR_signalfd4 74
+#define __NR_vmsplice 75
+#define __NR_splice 76
+#define __NR_tee 77
+#define __NR_readlinkat 78
+#define __NR_newfstatat 79
+#define __NR_fstat 80
+#define __NR_sync 81
+#define __NR_fsync 82
+#define __NR_fdatasync 83
+#define __NR_sync_file_range 84
+#define __NR_timerfd_create 85
+#define __NR_timerfd_settime 86
+#define __NR_timerfd_gettime 87
+#define __NR_utimensat 88
+#define __NR_acct 89
+#define __NR_capget 90
+#define __NR_capset 91
+#define __NR_personality 92
+#define __NR_exit 93
+#define __NR_exit_group 94
+#define __NR_waitid 95
+#define __NR_set_tid_address 96
+#define __NR_unshare 97
+#define __NR_futex 98
+#define __NR_set_robust_list 99
+#define __NR_get_robust_list 100
+#define __NR_nanosleep 101
+#define __NR_getitimer 102
+#define __NR_setitimer 103
+#define __NR_kexec_load 104
+#define __NR_init_module 105
+#define __NR_delete_module 106
+#define __NR_timer_create 107
+#define __NR_timer_gettime 108
+#define __NR_timer_getoverrun 109
+#define __NR_timer_settime 110
+#define __NR_timer_delete 111
+#define __NR_clock_settime 112
+#define __NR_clock_gettime 113
+#define __NR_clock_getres 114
+#define __NR_clock_nanosleep 115
+#define __NR_syslog 116
+#define __NR_ptrace 117
+#define __NR_sched_setparam 118
+#define __NR_sched_setscheduler 119
+#define __NR_sched_getscheduler 120
+#define __NR_sched_getparam 121
+#define __NR_sched_setaffinity 122
+#define __NR_sched_getaffinity 123
+#define __NR_sched_yield 124
+#define __NR_sched_get_priority_max 125
+#define __NR_sched_get_priority_min 126
+#define __NR_sched_rr_get_interval 127
+#define __NR_restart_syscall 128
+#define __NR_kill 129
+#define __NR_tkill 130
+#define __NR_tgkill 131
+#define __NR_sigaltstack 132
+#define __NR_rt_sigsuspend 133
+#define __NR_rt_sigaction 134
+#define __NR_rt_sigprocmask 135
+#define __NR_rt_sigpending 136
+#define __NR_rt_sigtimedwait 137
+#define __NR_rt_sigqueueinfo 138
+#define __NR_rt_sigreturn 139
+#define __NR_setpriority 140
+#define __NR_getpriority 141
+#define __NR_reboot 142
+#define __NR_setregid 143
+#define __NR_setgid 144
+#define __NR_setreuid 145
+#define __NR_setuid 146
+#define __NR_setresuid 147
+#define __NR_getresuid 148
+#define __NR_setresgid 149
+#define __NR_getresgid 150
+#define __NR_setfsuid 151
+#define __NR_setfsgid 152
+#define __NR_times 153
+#define __NR_setpgid 154
+#define __NR_getpgid 155
+#define __NR_getsid 156
+#define __NR_setsid 157
+#define __NR_getgroups 158
+#define __NR_setgroups 159
+#define __NR_uname 160
+#define __NR_sethostname 161
+#define __NR_setdomainname 162
+#define __NR_getrusage 165
+#define __NR_umask 166
+#define __NR_prctl 167
+#define __NR_getcpu 168
+#define __NR_gettimeofday 169
+#define __NR_settimeofday 170
+#define __NR_adjtimex 171
+#define __NR_getpid 172
+#define __NR_getppid 173
+#define __NR_getuid 174
+#define __NR_geteuid 175
+#define __NR_getgid 176
+#define __NR_getegid 177
+#define __NR_gettid 178
+#define __NR_sysinfo 179
+#define __NR_mq_open 180
+#define __NR_mq_unlink 181
+#define __NR_mq_timedsend 182
+#define __NR_mq_timedreceive 183
+#define __NR_mq_notify 184
+#define __NR_mq_getsetattr 185
+#define __NR_msgget 186
+#define __NR_msgctl 187
+#define __NR_msgrcv 188
+#define __NR_msgsnd 189
+#define __NR_semget 190
+#define __NR_semctl 191
+#define __NR_semtimedop 192
+#define __NR_semop 193
+#define __NR_shmget 194
+#define __NR_shmctl 195
+#define __NR_shmat 196
+#define __NR_shmdt 197
+#define __NR_socket 198
+#define __NR_socketpair 199
+#define __NR_bind 200
+#define __NR_listen 201
+#define __NR_accept 202
+#define __NR_connect 203
+#define __NR_getsockname 204
+#define __NR_getpeername 205
+#define __NR_sendto 206
+#define __NR_recvfrom 207
+#define __NR_setsockopt 208
+#define __NR_getsockopt 209
+#define __NR_shutdown 210
+#define __NR_sendmsg 211
+#define __NR_recvmsg 212
+#define __NR_readahead 213
+#define __NR_brk 214
+#define __NR_munmap 215
+#define __NR_mremap 216
+#define __NR_add_key 217
+#define __NR_request_key 218
+#define __NR_keyctl 219
+#define __NR_clone 220
+#define __NR_execve 221
+#define __NR_mmap 222
+#define __NR_fadvise64 223
+#define __NR_swapon 224
+#define __NR_swapoff 225
+#define __NR_mprotect 226
+#define __NR_msync 227
+#define __NR_mlock 228
+#define __NR_munlock 229
+#define __NR_mlockall 230
+#define __NR_munlockall 231
+#define __NR_mincore 232
+#define __NR_madvise 233
+#define __NR_remap_file_pages 234
+#define __NR_mbind 235
+#define __NR_get_mempolicy 236
+#define __NR_set_mempolicy 237
+#define __NR_migrate_pages 238
+#define __NR_move_pages 239
+#define __NR_rt_tgsigqueueinfo 240
+#define __NR_perf_event_open 241
+#define __NR_accept4 242
+#define __NR_recvmmsg 243
+#define __NR_wait4 260
+#define __NR_prlimit64 261
+#define __NR_fanotify_init 262
+#define __NR_fanotify_mark 263
+#define __NR_name_to_handle_at 264
+#define __NR_open_by_handle_at 265
+#define __NR_clock_adjtime 266
+#define __NR_syncfs 267
+#define __NR_setns 268
+#define __NR_sendmmsg 269
+#define __NR_process_vm_readv 270
+#define __NR_process_vm_writev 271
+#define __NR_kcmp 272
+#define __NR_finit_module 273
+#define __NR_sched_setattr 274
+#define __NR_sched_getattr 275
+#define __NR_renameat2 276
+#define __NR_seccomp 277
+#define __NR_getrandom 278
+#define __NR_memfd_create 279
+#define __NR_bpf 280
+#define __NR_execveat 281
+#define __NR_userfaultfd 282
+#define __NR_membarrier 283
+#define __NR_mlock2 284
+#define __NR_copy_file_range 285
+#define __NR_preadv2 286
+#define __NR_pwritev2 287
+#define __NR_pkey_mprotect 288
+#define __NR_pkey_alloc 289
+#define __NR_pkey_free 290
+#define __NR_statx 291
+#define __NR_io_pgetevents 292
+#define __NR_rseq 293
+#define __NR_kexec_file_load 294
+#define __NR_pidfd_send_signal 424
+#define __NR_io_uring_setup 425
+#define __NR_io_uring_enter 426
+#define __NR_io_uring_register 427
+#define __NR_open_tree 428
+#define __NR_move_mount 429
+#define __NR_fsopen 430
+#define __NR_fsconfig 431
+#define __NR_fsmount 432
+#define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
+#define __NR_close_range 436
+#define __NR_openat2 437
+#define __NR_pidfd_getfd 438
+#define __NR_faccessat2 439
+#define __NR_process_madvise 440
+#define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_quotactl_fd 443
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
+#define __NR_cachestat 451
+#define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
+#define __NR_mseal 462
+
+
+#endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index e878e7cc39..e97db32964 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -168,6 +168,13 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZTSO,
 	KVM_RISCV_ISA_EXT_ZACAS,
 	KVM_RISCV_ISA_EXT_SSCOFPMF,
+	KVM_RISCV_ISA_EXT_ZIMOP,
+	KVM_RISCV_ISA_EXT_ZCA,
+	KVM_RISCV_ISA_EXT_ZCB,
+	KVM_RISCV_ISA_EXT_ZCD,
+	KVM_RISCV_ISA_EXT_ZCF,
+	KVM_RISCV_ISA_EXT_ZCMOP,
+	KVM_RISCV_ISA_EXT_ZAWRS,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/linux-headers/asm-riscv/unistd.h b/linux-headers/asm-riscv/unistd.h
index 950ab3fd44..81896bbbf7 100644
--- a/linux-headers/asm-riscv/unistd.h
+++ b/linux-headers/asm-riscv/unistd.h
@@ -14,41 +14,10 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <https://www.gnu.org/licenses/>.
  */
+#include <asm/bitsperlong.h>
 
-#if defined(__LP64__) && !defined(__SYSCALL_COMPAT)
-#define __ARCH_WANT_NEW_STAT
-#define __ARCH_WANT_SET_GET_RLIMIT
-#endif /* __LP64__ */
-
-#define __ARCH_WANT_SYS_CLONE3
-#define __ARCH_WANT_MEMFD_SECRET
-
-#include <asm-generic/unistd.h>
-
-/*
- * Allows the instruction cache to be flushed from userspace.  Despite RISC-V
- * having a direct 'fence.i' instruction available to userspace (which we
- * can't trap!), that's not actually viable when running on Linux because the
- * kernel might schedule a process on another hart.  There is no way for
- * userspace to handle this without invoking the kernel (as it doesn't know the
- * thread->hart mappings), so we've defined a RISC-V specific system call to
- * flush the instruction cache.
- *
- * __NR_riscv_flush_icache is defined to flush the instruction cache over an
- * address range, with the flush applying to either all threads or just the
- * caller.  We don't currently do anything with the address range, that's just
- * in there for forwards compatibility.
- */
-#ifndef __NR_riscv_flush_icache
-#define __NR_riscv_flush_icache (__NR_arch_specific_syscall + 15)
-#endif
-__SYSCALL(__NR_riscv_flush_icache, sys_riscv_flush_icache)
-
-/*
- * Allows userspace to query the kernel for CPU architecture and
- * microarchitecture details across a given set of CPUs.
- */
-#ifndef __NR_riscv_hwprobe
-#define __NR_riscv_hwprobe (__NR_arch_specific_syscall + 14)
+#if __BITS_PER_LONG == 64
+#include <asm/unistd_64.h>
+#else
+#include <asm/unistd_32.h>
 #endif
-__SYSCALL(__NR_riscv_hwprobe, sys_riscv_hwprobe)
diff --git a/linux-headers/asm-riscv/unistd_32.h b/linux-headers/asm-riscv/unistd_32.h
new file mode 100644
index 0000000000..9625743dfd
--- /dev/null
+++ b/linux-headers/asm-riscv/unistd_32.h
@@ -0,0 +1,315 @@
+#ifndef _ASM_UNISTD_32_H
+#define _ASM_UNISTD_32_H
+
+#define __NR_io_setup 0
+#define __NR_io_destroy 1
+#define __NR_io_submit 2
+#define __NR_io_cancel 3
+#define __NR_setxattr 5
+#define __NR_lsetxattr 6
+#define __NR_fsetxattr 7
+#define __NR_getxattr 8
+#define __NR_lgetxattr 9
+#define __NR_fgetxattr 10
+#define __NR_listxattr 11
+#define __NR_llistxattr 12
+#define __NR_flistxattr 13
+#define __NR_removexattr 14
+#define __NR_lremovexattr 15
+#define __NR_fremovexattr 16
+#define __NR_getcwd 17
+#define __NR_lookup_dcookie 18
+#define __NR_eventfd2 19
+#define __NR_epoll_create1 20
+#define __NR_epoll_ctl 21
+#define __NR_epoll_pwait 22
+#define __NR_dup 23
+#define __NR_dup3 24
+#define __NR_fcntl64 25
+#define __NR_inotify_init1 26
+#define __NR_inotify_add_watch 27
+#define __NR_inotify_rm_watch 28
+#define __NR_ioctl 29
+#define __NR_ioprio_set 30
+#define __NR_ioprio_get 31
+#define __NR_flock 32
+#define __NR_mknodat 33
+#define __NR_mkdirat 34
+#define __NR_unlinkat 35
+#define __NR_symlinkat 36
+#define __NR_linkat 37
+#define __NR_umount2 39
+#define __NR_mount 40
+#define __NR_pivot_root 41
+#define __NR_nfsservctl 42
+#define __NR_statfs64 43
+#define __NR_fstatfs64 44
+#define __NR_truncate64 45
+#define __NR_ftruncate64 46
+#define __NR_fallocate 47
+#define __NR_faccessat 48
+#define __NR_chdir 49
+#define __NR_fchdir 50
+#define __NR_chroot 51
+#define __NR_fchmod 52
+#define __NR_fchmodat 53
+#define __NR_fchownat 54
+#define __NR_fchown 55
+#define __NR_openat 56
+#define __NR_close 57
+#define __NR_vhangup 58
+#define __NR_pipe2 59
+#define __NR_quotactl 60
+#define __NR_getdents64 61
+#define __NR_llseek 62
+#define __NR_read 63
+#define __NR_write 64
+#define __NR_readv 65
+#define __NR_writev 66
+#define __NR_pread64 67
+#define __NR_pwrite64 68
+#define __NR_preadv 69
+#define __NR_pwritev 70
+#define __NR_sendfile64 71
+#define __NR_signalfd4 74
+#define __NR_vmsplice 75
+#define __NR_splice 76
+#define __NR_tee 77
+#define __NR_readlinkat 78
+#define __NR_sync 81
+#define __NR_fsync 82
+#define __NR_fdatasync 83
+#define __NR_sync_file_range 84
+#define __NR_timerfd_create 85
+#define __NR_acct 89
+#define __NR_capget 90
+#define __NR_capset 91
+#define __NR_personality 92
+#define __NR_exit 93
+#define __NR_exit_group 94
+#define __NR_waitid 95
+#define __NR_set_tid_address 96
+#define __NR_unshare 97
+#define __NR_set_robust_list 99
+#define __NR_get_robust_list 100
+#define __NR_getitimer 102
+#define __NR_setitimer 103
+#define __NR_kexec_load 104
+#define __NR_init_module 105
+#define __NR_delete_module 106
+#define __NR_timer_create 107
+#define __NR_timer_getoverrun 109
+#define __NR_timer_delete 111
+#define __NR_syslog 116
+#define __NR_ptrace 117
+#define __NR_sched_setparam 118
+#define __NR_sched_setscheduler 119
+#define __NR_sched_getscheduler 120
+#define __NR_sched_getparam 121
+#define __NR_sched_setaffinity 122
+#define __NR_sched_getaffinity 123
+#define __NR_sched_yield 124
+#define __NR_sched_get_priority_max 125
+#define __NR_sched_get_priority_min 126
+#define __NR_restart_syscall 128
+#define __NR_kill 129
+#define __NR_tkill 130
+#define __NR_tgkill 131
+#define __NR_sigaltstack 132
+#define __NR_rt_sigsuspend 133
+#define __NR_rt_sigaction 134
+#define __NR_rt_sigprocmask 135
+#define __NR_rt_sigpending 136
+#define __NR_rt_sigqueueinfo 138
+#define __NR_rt_sigreturn 139
+#define __NR_setpriority 140
+#define __NR_getpriority 141
+#define __NR_reboot 142
+#define __NR_setregid 143
+#define __NR_setgid 144
+#define __NR_setreuid 145
+#define __NR_setuid 146
+#define __NR_setresuid 147
+#define __NR_getresuid 148
+#define __NR_setresgid 149
+#define __NR_getresgid 150
+#define __NR_setfsuid 151
+#define __NR_setfsgid 152
+#define __NR_times 153
+#define __NR_setpgid 154
+#define __NR_getpgid 155
+#define __NR_getsid 156
+#define __NR_setsid 157
+#define __NR_getgroups 158
+#define __NR_setgroups 159
+#define __NR_uname 160
+#define __NR_sethostname 161
+#define __NR_setdomainname 162
+#define __NR_getrusage 165
+#define __NR_umask 166
+#define __NR_prctl 167
+#define __NR_getcpu 168
+#define __NR_getpid 172
+#define __NR_getppid 173
+#define __NR_getuid 174
+#define __NR_geteuid 175
+#define __NR_getgid 176
+#define __NR_getegid 177
+#define __NR_gettid 178
+#define __NR_sysinfo 179
+#define __NR_mq_open 180
+#define __NR_mq_unlink 181
+#define __NR_mq_notify 184
+#define __NR_mq_getsetattr 185
+#define __NR_msgget 186
+#define __NR_msgctl 187
+#define __NR_msgrcv 188
+#define __NR_msgsnd 189
+#define __NR_semget 190
+#define __NR_semctl 191
+#define __NR_semop 193
+#define __NR_shmget 194
+#define __NR_shmctl 195
+#define __NR_shmat 196
+#define __NR_shmdt 197
+#define __NR_socket 198
+#define __NR_socketpair 199
+#define __NR_bind 200
+#define __NR_listen 201
+#define __NR_accept 202
+#define __NR_connect 203
+#define __NR_getsockname 204
+#define __NR_getpeername 205
+#define __NR_sendto 206
+#define __NR_recvfrom 207
+#define __NR_setsockopt 208
+#define __NR_getsockopt 209
+#define __NR_shutdown 210
+#define __NR_sendmsg 211
+#define __NR_recvmsg 212
+#define __NR_readahead 213
+#define __NR_brk 214
+#define __NR_munmap 215
+#define __NR_mremap 216
+#define __NR_add_key 217
+#define __NR_request_key 218
+#define __NR_keyctl 219
+#define __NR_clone 220
+#define __NR_execve 221
+#define __NR_mmap2 222
+#define __NR_fadvise64_64 223
+#define __NR_swapon 224
+#define __NR_swapoff 225
+#define __NR_mprotect 226
+#define __NR_msync 227
+#define __NR_mlock 228
+#define __NR_munlock 229
+#define __NR_mlockall 230
+#define __NR_munlockall 231
+#define __NR_mincore 232
+#define __NR_madvise 233
+#define __NR_remap_file_pages 234
+#define __NR_mbind 235
+#define __NR_get_mempolicy 236
+#define __NR_set_mempolicy 237
+#define __NR_migrate_pages 238
+#define __NR_move_pages 239
+#define __NR_rt_tgsigqueueinfo 240
+#define __NR_perf_event_open 241
+#define __NR_accept4 242
+#define __NR_riscv_hwprobe 258
+#define __NR_riscv_flush_icache 259
+#define __NR_prlimit64 261
+#define __NR_fanotify_init 262
+#define __NR_fanotify_mark 263
+#define __NR_name_to_handle_at 264
+#define __NR_open_by_handle_at 265
+#define __NR_syncfs 267
+#define __NR_setns 268
+#define __NR_sendmmsg 269
+#define __NR_process_vm_readv 270
+#define __NR_process_vm_writev 271
+#define __NR_kcmp 272
+#define __NR_finit_module 273
+#define __NR_sched_setattr 274
+#define __NR_sched_getattr 275
+#define __NR_renameat2 276
+#define __NR_seccomp 277
+#define __NR_getrandom 278
+#define __NR_memfd_create 279
+#define __NR_bpf 280
+#define __NR_execveat 281
+#define __NR_userfaultfd 282
+#define __NR_membarrier 283
+#define __NR_mlock2 284
+#define __NR_copy_file_range 285
+#define __NR_preadv2 286
+#define __NR_pwritev2 287
+#define __NR_pkey_mprotect 288
+#define __NR_pkey_alloc 289
+#define __NR_pkey_free 290
+#define __NR_statx 291
+#define __NR_rseq 293
+#define __NR_kexec_file_load 294
+#define __NR_clock_gettime64 403
+#define __NR_clock_settime64 404
+#define __NR_clock_adjtime64 405
+#define __NR_clock_getres_time64 406
+#define __NR_clock_nanosleep_time64 407
+#define __NR_timer_gettime64 408
+#define __NR_timer_settime64 409
+#define __NR_timerfd_gettime64 410
+#define __NR_timerfd_settime64 411
+#define __NR_utimensat_time64 412
+#define __NR_pselect6_time64 413
+#define __NR_ppoll_time64 414
+#define __NR_io_pgetevents_time64 416
+#define __NR_recvmmsg_time64 417
+#define __NR_mq_timedsend_time64 418
+#define __NR_mq_timedreceive_time64 419
+#define __NR_semtimedop_time64 420
+#define __NR_rt_sigtimedwait_time64 421
+#define __NR_futex_time64 422
+#define __NR_sched_rr_get_interval_time64 423
+#define __NR_pidfd_send_signal 424
+#define __NR_io_uring_setup 425
+#define __NR_io_uring_enter 426
+#define __NR_io_uring_register 427
+#define __NR_open_tree 428
+#define __NR_move_mount 429
+#define __NR_fsopen 430
+#define __NR_fsconfig 431
+#define __NR_fsmount 432
+#define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
+#define __NR_close_range 436
+#define __NR_openat2 437
+#define __NR_pidfd_getfd 438
+#define __NR_faccessat2 439
+#define __NR_process_madvise 440
+#define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_quotactl_fd 443
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
+#define __NR_memfd_secret 447
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
+#define __NR_cachestat 451
+#define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
+#define __NR_mseal 462
+
+
+#endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-riscv/unistd_64.h b/linux-headers/asm-riscv/unistd_64.h
new file mode 100644
index 0000000000..95bca8ae81
--- /dev/null
+++ b/linux-headers/asm-riscv/unistd_64.h
@@ -0,0 +1,325 @@
+#ifndef _ASM_UNISTD_64_H
+#define _ASM_UNISTD_64_H
+
+#define __NR_io_setup 0
+#define __NR_io_destroy 1
+#define __NR_io_submit 2
+#define __NR_io_cancel 3
+#define __NR_io_getevents 4
+#define __NR_setxattr 5
+#define __NR_lsetxattr 6
+#define __NR_fsetxattr 7
+#define __NR_getxattr 8
+#define __NR_lgetxattr 9
+#define __NR_fgetxattr 10
+#define __NR_listxattr 11
+#define __NR_llistxattr 12
+#define __NR_flistxattr 13
+#define __NR_removexattr 14
+#define __NR_lremovexattr 15
+#define __NR_fremovexattr 16
+#define __NR_getcwd 17
+#define __NR_lookup_dcookie 18
+#define __NR_eventfd2 19
+#define __NR_epoll_create1 20
+#define __NR_epoll_ctl 21
+#define __NR_epoll_pwait 22
+#define __NR_dup 23
+#define __NR_dup3 24
+#define __NR_fcntl 25
+#define __NR_inotify_init1 26
+#define __NR_inotify_add_watch 27
+#define __NR_inotify_rm_watch 28
+#define __NR_ioctl 29
+#define __NR_ioprio_set 30
+#define __NR_ioprio_get 31
+#define __NR_flock 32
+#define __NR_mknodat 33
+#define __NR_mkdirat 34
+#define __NR_unlinkat 35
+#define __NR_symlinkat 36
+#define __NR_linkat 37
+#define __NR_umount2 39
+#define __NR_mount 40
+#define __NR_pivot_root 41
+#define __NR_nfsservctl 42
+#define __NR_statfs 43
+#define __NR_fstatfs 44
+#define __NR_truncate 45
+#define __NR_ftruncate 46
+#define __NR_fallocate 47
+#define __NR_faccessat 48
+#define __NR_chdir 49
+#define __NR_fchdir 50
+#define __NR_chroot 51
+#define __NR_fchmod 52
+#define __NR_fchmodat 53
+#define __NR_fchownat 54
+#define __NR_fchown 55
+#define __NR_openat 56
+#define __NR_close 57
+#define __NR_vhangup 58
+#define __NR_pipe2 59
+#define __NR_quotactl 60
+#define __NR_getdents64 61
+#define __NR_lseek 62
+#define __NR_read 63
+#define __NR_write 64
+#define __NR_readv 65
+#define __NR_writev 66
+#define __NR_pread64 67
+#define __NR_pwrite64 68
+#define __NR_preadv 69
+#define __NR_pwritev 70
+#define __NR_sendfile 71
+#define __NR_pselect6 72
+#define __NR_ppoll 73
+#define __NR_signalfd4 74
+#define __NR_vmsplice 75
+#define __NR_splice 76
+#define __NR_tee 77
+#define __NR_readlinkat 78
+#define __NR_newfstatat 79
+#define __NR_fstat 80
+#define __NR_sync 81
+#define __NR_fsync 82
+#define __NR_fdatasync 83
+#define __NR_sync_file_range 84
+#define __NR_timerfd_create 85
+#define __NR_timerfd_settime 86
+#define __NR_timerfd_gettime 87
+#define __NR_utimensat 88
+#define __NR_acct 89
+#define __NR_capget 90
+#define __NR_capset 91
+#define __NR_personality 92
+#define __NR_exit 93
+#define __NR_exit_group 94
+#define __NR_waitid 95
+#define __NR_set_tid_address 96
+#define __NR_unshare 97
+#define __NR_futex 98
+#define __NR_set_robust_list 99
+#define __NR_get_robust_list 100
+#define __NR_nanosleep 101
+#define __NR_getitimer 102
+#define __NR_setitimer 103
+#define __NR_kexec_load 104
+#define __NR_init_module 105
+#define __NR_delete_module 106
+#define __NR_timer_create 107
+#define __NR_timer_gettime 108
+#define __NR_timer_getoverrun 109
+#define __NR_timer_settime 110
+#define __NR_timer_delete 111
+#define __NR_clock_settime 112
+#define __NR_clock_gettime 113
+#define __NR_clock_getres 114
+#define __NR_clock_nanosleep 115
+#define __NR_syslog 116
+#define __NR_ptrace 117
+#define __NR_sched_setparam 118
+#define __NR_sched_setscheduler 119
+#define __NR_sched_getscheduler 120
+#define __NR_sched_getparam 121
+#define __NR_sched_setaffinity 122
+#define __NR_sched_getaffinity 123
+#define __NR_sched_yield 124
+#define __NR_sched_get_priority_max 125
+#define __NR_sched_get_priority_min 126
+#define __NR_sched_rr_get_interval 127
+#define __NR_restart_syscall 128
+#define __NR_kill 129
+#define __NR_tkill 130
+#define __NR_tgkill 131
+#define __NR_sigaltstack 132
+#define __NR_rt_sigsuspend 133
+#define __NR_rt_sigaction 134
+#define __NR_rt_sigprocmask 135
+#define __NR_rt_sigpending 136
+#define __NR_rt_sigtimedwait 137
+#define __NR_rt_sigqueueinfo 138
+#define __NR_rt_sigreturn 139
+#define __NR_setpriority 140
+#define __NR_getpriority 141
+#define __NR_reboot 142
+#define __NR_setregid 143
+#define __NR_setgid 144
+#define __NR_setreuid 145
+#define __NR_setuid 146
+#define __NR_setresuid 147
+#define __NR_getresuid 148
+#define __NR_setresgid 149
+#define __NR_getresgid 150
+#define __NR_setfsuid 151
+#define __NR_setfsgid 152
+#define __NR_times 153
+#define __NR_setpgid 154
+#define __NR_getpgid 155
+#define __NR_getsid 156
+#define __NR_setsid 157
+#define __NR_getgroups 158
+#define __NR_setgroups 159
+#define __NR_uname 160
+#define __NR_sethostname 161
+#define __NR_setdomainname 162
+#define __NR_getrlimit 163
+#define __NR_setrlimit 164
+#define __NR_getrusage 165
+#define __NR_umask 166
+#define __NR_prctl 167
+#define __NR_getcpu 168
+#define __NR_gettimeofday 169
+#define __NR_settimeofday 170
+#define __NR_adjtimex 171
+#define __NR_getpid 172
+#define __NR_getppid 173
+#define __NR_getuid 174
+#define __NR_geteuid 175
+#define __NR_getgid 176
+#define __NR_getegid 177
+#define __NR_gettid 178
+#define __NR_sysinfo 179
+#define __NR_mq_open 180
+#define __NR_mq_unlink 181
+#define __NR_mq_timedsend 182
+#define __NR_mq_timedreceive 183
+#define __NR_mq_notify 184
+#define __NR_mq_getsetattr 185
+#define __NR_msgget 186
+#define __NR_msgctl 187
+#define __NR_msgrcv 188
+#define __NR_msgsnd 189
+#define __NR_semget 190
+#define __NR_semctl 191
+#define __NR_semtimedop 192
+#define __NR_semop 193
+#define __NR_shmget 194
+#define __NR_shmctl 195
+#define __NR_shmat 196
+#define __NR_shmdt 197
+#define __NR_socket 198
+#define __NR_socketpair 199
+#define __NR_bind 200
+#define __NR_listen 201
+#define __NR_accept 202
+#define __NR_connect 203
+#define __NR_getsockname 204
+#define __NR_getpeername 205
+#define __NR_sendto 206
+#define __NR_recvfrom 207
+#define __NR_setsockopt 208
+#define __NR_getsockopt 209
+#define __NR_shutdown 210
+#define __NR_sendmsg 211
+#define __NR_recvmsg 212
+#define __NR_readahead 213
+#define __NR_brk 214
+#define __NR_munmap 215
+#define __NR_mremap 216
+#define __NR_add_key 217
+#define __NR_request_key 218
+#define __NR_keyctl 219
+#define __NR_clone 220
+#define __NR_execve 221
+#define __NR_mmap 222
+#define __NR_fadvise64 223
+#define __NR_swapon 224
+#define __NR_swapoff 225
+#define __NR_mprotect 226
+#define __NR_msync 227
+#define __NR_mlock 228
+#define __NR_munlock 229
+#define __NR_mlockall 230
+#define __NR_munlockall 231
+#define __NR_mincore 232
+#define __NR_madvise 233
+#define __NR_remap_file_pages 234
+#define __NR_mbind 235
+#define __NR_get_mempolicy 236
+#define __NR_set_mempolicy 237
+#define __NR_migrate_pages 238
+#define __NR_move_pages 239
+#define __NR_rt_tgsigqueueinfo 240
+#define __NR_perf_event_open 241
+#define __NR_accept4 242
+#define __NR_recvmmsg 243
+#define __NR_riscv_hwprobe 258
+#define __NR_riscv_flush_icache 259
+#define __NR_wait4 260
+#define __NR_prlimit64 261
+#define __NR_fanotify_init 262
+#define __NR_fanotify_mark 263
+#define __NR_name_to_handle_at 264
+#define __NR_open_by_handle_at 265
+#define __NR_clock_adjtime 266
+#define __NR_syncfs 267
+#define __NR_setns 268
+#define __NR_sendmmsg 269
+#define __NR_process_vm_readv 270
+#define __NR_process_vm_writev 271
+#define __NR_kcmp 272
+#define __NR_finit_module 273
+#define __NR_sched_setattr 274
+#define __NR_sched_getattr 275
+#define __NR_renameat2 276
+#define __NR_seccomp 277
+#define __NR_getrandom 278
+#define __NR_memfd_create 279
+#define __NR_bpf 280
+#define __NR_execveat 281
+#define __NR_userfaultfd 282
+#define __NR_membarrier 283
+#define __NR_mlock2 284
+#define __NR_copy_file_range 285
+#define __NR_preadv2 286
+#define __NR_pwritev2 287
+#define __NR_pkey_mprotect 288
+#define __NR_pkey_alloc 289
+#define __NR_pkey_free 290
+#define __NR_statx 291
+#define __NR_io_pgetevents 292
+#define __NR_rseq 293
+#define __NR_kexec_file_load 294
+#define __NR_pidfd_send_signal 424
+#define __NR_io_uring_setup 425
+#define __NR_io_uring_enter 426
+#define __NR_io_uring_register 427
+#define __NR_open_tree 428
+#define __NR_move_mount 429
+#define __NR_fsopen 430
+#define __NR_fsconfig 431
+#define __NR_fsmount 432
+#define __NR_fspick 433
+#define __NR_pidfd_open 434
+#define __NR_clone3 435
+#define __NR_close_range 436
+#define __NR_openat2 437
+#define __NR_pidfd_getfd 438
+#define __NR_faccessat2 439
+#define __NR_process_madvise 440
+#define __NR_epoll_pwait2 441
+#define __NR_mount_setattr 442
+#define __NR_quotactl_fd 443
+#define __NR_landlock_create_ruleset 444
+#define __NR_landlock_add_rule 445
+#define __NR_landlock_restrict_self 446
+#define __NR_memfd_secret 447
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
+#define __NR_cachestat 451
+#define __NR_fchmodat2 452
+#define __NR_map_shadow_stack 453
+#define __NR_futex_wake 454
+#define __NR_futex_wait 455
+#define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
+#define __NR_mseal 462
+
+
+#endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 1c8f918234..4711ef2c3d 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -106,6 +106,7 @@ struct kvm_ioapic_state {
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
 #define KVM_RUN_X86_BUS_LOCK     (1 << 1)
+#define KVM_RUN_X86_GUEST_MODE   (1 << 2)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
@@ -436,6 +437,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
 #define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
+#define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index da439afee1..24c979be54 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -336,6 +336,7 @@
 #define __NR_statx 332
 #define __NR_io_pgetevents 333
 #define __NR_rseq 334
+#define __NR_uretprobe 335
 #define __NR_pidfd_send_signal 424
 #define __NR_io_uring_setup 425
 #define __NR_io_uring_enter 426
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 4fcb607c72..c23dd21a2d 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -289,6 +289,7 @@
 #define __NR_statx (__X32_SYSCALL_BIT + 332)
 #define __NR_io_pgetevents (__X32_SYSCALL_BIT + 333)
 #define __NR_rseq (__X32_SYSCALL_BIT + 334)
+#define __NR_uretprobe (__X32_SYSCALL_BIT + 335)
 #define __NR_pidfd_send_signal (__X32_SYSCALL_BIT + 424)
 #define __NR_io_uring_setup (__X32_SYSCALL_BIT + 425)
 #define __NR_io_uring_enter (__X32_SYSCALL_BIT + 426)
diff --git a/linux-headers/linux/bits.h b/linux-headers/linux/bits.h
index d9897771be..c0d00c0a98 100644
--- a/linux-headers/linux/bits.h
+++ b/linux-headers/linux/bits.h
@@ -12,4 +12,7 @@
         (((~_ULL(0)) - (_ULL(1) << (l)) + 1) & \
          (~_ULL(0) >> (__BITS_PER_LONG_LONG - 1 - (h))))
 
+#define __GENMASK_U128(h, l) \
+	((_BIT128((h)) << 1) - (_BIT128(l)))
+
 #endif /* _LINUX_BITS_H */
diff --git a/linux-headers/linux/const.h b/linux-headers/linux/const.h
index 1eb84b5087..2122610de7 100644
--- a/linux-headers/linux/const.h
+++ b/linux-headers/linux/const.h
@@ -28,6 +28,23 @@
 #define _BITUL(x)	(_UL(1) << (x))
 #define _BITULL(x)	(_ULL(1) << (x))
 
+#if !defined(__ASSEMBLY__)
+/*
+ * Missing __asm__ support
+ *
+ * __BIT128() would not work in the __asm__ code, as it shifts an
+ * 'unsigned __init128' data type as direct representation of
+ * 128 bit constants is not supported in the gcc compiler, as
+ * they get silently truncated.
+ *
+ * TODO: Please revisit this implementation when gcc compiler
+ * starts representing 128 bit constants directly like long
+ * and unsigned long etc. Subsequently drop the comment for
+ * GENMASK_U128() which would then start supporting __asm__ code.
+ */
+#define _BIT128(x)	((unsigned __int128)(1) << (x))
+#endif
+
 #define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (__typeof__(x))(a) - 1)
 #define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
 
diff --git a/linux-headers/linux/iommufd.h b/linux-headers/linux/iommufd.h
index 72e8f4b9dd..782baf477f 100644
--- a/linux-headers/linux/iommufd.h
+++ b/linux-headers/linux/iommufd.h
@@ -4,8 +4,8 @@
 #ifndef _IOMMUFD_H
 #define _IOMMUFD_H
 
-#include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 #define IOMMUFD_TYPE (';')
 
@@ -37,19 +37,20 @@
 enum {
 	IOMMUFD_CMD_BASE = 0x80,
 	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
-	IOMMUFD_CMD_IOAS_ALLOC,
-	IOMMUFD_CMD_IOAS_ALLOW_IOVAS,
-	IOMMUFD_CMD_IOAS_COPY,
-	IOMMUFD_CMD_IOAS_IOVA_RANGES,
-	IOMMUFD_CMD_IOAS_MAP,
-	IOMMUFD_CMD_IOAS_UNMAP,
-	IOMMUFD_CMD_OPTION,
-	IOMMUFD_CMD_VFIO_IOAS,
-	IOMMUFD_CMD_HWPT_ALLOC,
-	IOMMUFD_CMD_GET_HW_INFO,
-	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING,
-	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP,
-	IOMMUFD_CMD_HWPT_INVALIDATE,
+	IOMMUFD_CMD_IOAS_ALLOC = 0x81,
+	IOMMUFD_CMD_IOAS_ALLOW_IOVAS = 0x82,
+	IOMMUFD_CMD_IOAS_COPY = 0x83,
+	IOMMUFD_CMD_IOAS_IOVA_RANGES = 0x84,
+	IOMMUFD_CMD_IOAS_MAP = 0x85,
+	IOMMUFD_CMD_IOAS_UNMAP = 0x86,
+	IOMMUFD_CMD_OPTION = 0x87,
+	IOMMUFD_CMD_VFIO_IOAS = 0x88,
+	IOMMUFD_CMD_HWPT_ALLOC = 0x89,
+	IOMMUFD_CMD_GET_HW_INFO = 0x8a,
+	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING = 0x8b,
+	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP = 0x8c,
+	IOMMUFD_CMD_HWPT_INVALIDATE = 0x8d,
+	IOMMUFD_CMD_FAULT_QUEUE_ALLOC = 0x8e,
 };
 
 /**
@@ -356,10 +357,13 @@ struct iommu_vfio_ioas {
  *                                the parent HWPT in a nesting configuration.
  * @IOMMU_HWPT_ALLOC_DIRTY_TRACKING: Dirty tracking support for device IOMMU is
  *                                   enforced on device attachment
+ * @IOMMU_HWPT_FAULT_ID_VALID: The fault_id field of hwpt allocation data is
+ *                             valid.
  */
 enum iommufd_hwpt_alloc_flags {
 	IOMMU_HWPT_ALLOC_NEST_PARENT = 1 << 0,
 	IOMMU_HWPT_ALLOC_DIRTY_TRACKING = 1 << 1,
+	IOMMU_HWPT_FAULT_ID_VALID = 1 << 2,
 };
 
 /**
@@ -396,8 +400,8 @@ struct iommu_hwpt_vtd_s1 {
  * @IOMMU_HWPT_DATA_VTD_S1: Intel VT-d stage-1 page table
  */
 enum iommu_hwpt_data_type {
-	IOMMU_HWPT_DATA_NONE,
-	IOMMU_HWPT_DATA_VTD_S1,
+	IOMMU_HWPT_DATA_NONE = 0,
+	IOMMU_HWPT_DATA_VTD_S1 = 1,
 };
 
 /**
@@ -411,6 +415,9 @@ enum iommu_hwpt_data_type {
  * @data_type: One of enum iommu_hwpt_data_type
  * @data_len: Length of the type specific data
  * @data_uptr: User pointer to the type specific data
+ * @fault_id: The ID of IOMMUFD_FAULT object. Valid only if flags field of
+ *            IOMMU_HWPT_FAULT_ID_VALID is set.
+ * @__reserved2: Padding to 64-bit alignment. Must be 0.
  *
  * Explicitly allocate a hardware page table object. This is the same object
  * type that is returned by iommufd_device_attach() and represents the
@@ -441,6 +448,8 @@ struct iommu_hwpt_alloc {
 	__u32 data_type;
 	__u32 data_len;
 	__aligned_u64 data_uptr;
+	__u32 fault_id;
+	__u32 __reserved2;
 };
 #define IOMMU_HWPT_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_ALLOC)
 
@@ -482,8 +491,8 @@ struct iommu_hw_info_vtd {
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
  */
 enum iommu_hw_info_type {
-	IOMMU_HW_INFO_TYPE_NONE,
-	IOMMU_HW_INFO_TYPE_INTEL_VTD,
+	IOMMU_HW_INFO_TYPE_NONE = 0,
+	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
 };
 
 /**
@@ -620,7 +629,7 @@ struct iommu_hwpt_get_dirty_bitmap {
  * @IOMMU_HWPT_INVALIDATE_DATA_VTD_S1: Invalidation data for VTD_S1
  */
 enum iommu_hwpt_invalidate_data_type {
-	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1,
+	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1 = 0,
 };
 
 /**
@@ -692,4 +701,100 @@ struct iommu_hwpt_invalidate {
 	__u32 __reserved;
 };
 #define IOMMU_HWPT_INVALIDATE _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_INVALIDATE)
+
+/**
+ * enum iommu_hwpt_pgfault_flags - flags for struct iommu_hwpt_pgfault
+ * @IOMMU_PGFAULT_FLAGS_PASID_VALID: The pasid field of the fault data is
+ *                                   valid.
+ * @IOMMU_PGFAULT_FLAGS_LAST_PAGE: It's the last fault of a fault group.
+ */
+enum iommu_hwpt_pgfault_flags {
+	IOMMU_PGFAULT_FLAGS_PASID_VALID		= (1 << 0),
+	IOMMU_PGFAULT_FLAGS_LAST_PAGE		= (1 << 1),
+};
+
+/**
+ * enum iommu_hwpt_pgfault_perm - perm bits for struct iommu_hwpt_pgfault
+ * @IOMMU_PGFAULT_PERM_READ: request for read permission
+ * @IOMMU_PGFAULT_PERM_WRITE: request for write permission
+ * @IOMMU_PGFAULT_PERM_EXEC: (PCIE 10.4.1) request with a PASID that has the
+ *                           Execute Requested bit set in PASID TLP Prefix.
+ * @IOMMU_PGFAULT_PERM_PRIV: (PCIE 10.4.1) request with a PASID that has the
+ *                           Privileged Mode Requested bit set in PASID TLP
+ *                           Prefix.
+ */
+enum iommu_hwpt_pgfault_perm {
+	IOMMU_PGFAULT_PERM_READ			= (1 << 0),
+	IOMMU_PGFAULT_PERM_WRITE		= (1 << 1),
+	IOMMU_PGFAULT_PERM_EXEC			= (1 << 2),
+	IOMMU_PGFAULT_PERM_PRIV			= (1 << 3),
+};
+
+/**
+ * struct iommu_hwpt_pgfault - iommu page fault data
+ * @flags: Combination of enum iommu_hwpt_pgfault_flags
+ * @dev_id: id of the originated device
+ * @pasid: Process Address Space ID
+ * @grpid: Page Request Group Index
+ * @perm: Combination of enum iommu_hwpt_pgfault_perm
+ * @addr: Fault address
+ * @length: a hint of how much data the requestor is expecting to fetch. For
+ *          example, if the PRI initiator knows it is going to do a 10MB
+ *          transfer, it could fill in 10MB and the OS could pre-fault in
+ *          10MB of IOVA. It's default to 0 if there's no such hint.
+ * @cookie: kernel-managed cookie identifying a group of fault messages. The
+ *          cookie number encoded in the last page fault of the group should
+ *          be echoed back in the response message.
+ */
+struct iommu_hwpt_pgfault {
+	__u32 flags;
+	__u32 dev_id;
+	__u32 pasid;
+	__u32 grpid;
+	__u32 perm;
+	__u64 addr;
+	__u32 length;
+	__u32 cookie;
+};
+
+/**
+ * enum iommufd_page_response_code - Return status of fault handlers
+ * @IOMMUFD_PAGE_RESP_SUCCESS: Fault has been handled and the page tables
+ *                             populated, retry the access. This is the
+ *                             "Success" defined in PCI 10.4.2.1.
+ * @IOMMUFD_PAGE_RESP_INVALID: Could not handle this fault, don't retry the
+ *                             access. This is the "Invalid Request" in PCI
+ *                             10.4.2.1.
+ */
+enum iommufd_page_response_code {
+	IOMMUFD_PAGE_RESP_SUCCESS = 0,
+	IOMMUFD_PAGE_RESP_INVALID = 1,
+};
+
+/**
+ * struct iommu_hwpt_page_response - IOMMU page fault response
+ * @cookie: The kernel-managed cookie reported in the fault message.
+ * @code: One of response code in enum iommufd_page_response_code.
+ */
+struct iommu_hwpt_page_response {
+	__u32 cookie;
+	__u32 code;
+};
+
+/**
+ * struct iommu_fault_alloc - ioctl(IOMMU_FAULT_QUEUE_ALLOC)
+ * @size: sizeof(struct iommu_fault_alloc)
+ * @flags: Must be 0
+ * @out_fault_id: The ID of the new FAULT
+ * @out_fault_fd: The fd of the new FAULT
+ *
+ * Explicitly allocate a fault handling object.
+ */
+struct iommu_fault_alloc {
+	__u32 size;
+	__u32 flags;
+	__u32 out_fault_id;
+	__u32 out_fault_fd;
+};
+#define IOMMU_FAULT_QUEUE_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_FAULT_QUEUE_ALLOC)
 #endif
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index c93876ca0b..49dd1b30ce 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -192,11 +192,20 @@ struct kvm_xen_exit {
 /* Flags that describe what fields in emulation_failure hold valid data. */
 #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
 
+/*
+ * struct kvm_run can be modified by userspace at any time, so KVM must be
+ * careful to avoid TOCTOU bugs. In order to protect KVM, HINT_UNSAFE_IN_KVM()
+ * renames fields in struct kvm_run from <symbol> to <symbol>__unsafe when
+ * compiled into the kernel, ensuring that any use within KVM is obvious and
+ * gets extra scrutiny.
+ */
+#define HINT_UNSAFE_IN_KVM(_symbol) _symbol
+
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
-	__u8 immediate_exit;
+	__u8 HINT_UNSAFE_IN_KVM(immediate_exit);
 	__u8 padding1[6];
 
 	/* out */
@@ -913,6 +922,9 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_PRE_FAULT_MEMORY 236
+#define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
+#define KVM_CAP_X86_GUEST_MODE 238
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1544,4 +1556,13 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
+
+struct kvm_pre_fault_memory {
+	__u64 gpa;
+	__u64 size;
+	__u64 flags;
+	__u64 padding[5];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/linux-headers/linux/mman.h b/linux-headers/linux/mman.h
index 4e8cb60780..2b83059586 100644
--- a/linux-headers/linux/mman.h
+++ b/linux-headers/linux/mman.h
@@ -17,6 +17,7 @@
 #define MAP_SHARED	0x01		/* Share changes */
 #define MAP_PRIVATE	0x02		/* Changes are private */
 #define MAP_SHARED_VALIDATE 0x03	/* share + validate extension flags */
+#define MAP_DROPPABLE	0x08		/* Zero memory under memory pressure. */
 
 /*
  * Huge page size encoding when MAP_HUGETLB is specified, and a huge page
diff --git a/linux-headers/linux/psp-sev.h b/linux-headers/linux/psp-sev.h
index c3046c6bff..17bf191573 100644
--- a/linux-headers/linux/psp-sev.h
+++ b/linux-headers/linux/psp-sev.h
@@ -31,6 +31,7 @@ enum {
 	SNP_PLATFORM_STATUS,
 	SNP_COMMIT,
 	SNP_SET_CONFIG,
+	SNP_VLEK_LOAD,
 
 	SEV_MAX,
 };
@@ -50,6 +51,7 @@ typedef enum {
 	SEV_RET_INVALID_PLATFORM_STATE,
 	SEV_RET_INVALID_GUEST_STATE,
 	SEV_RET_INAVLID_CONFIG,
+	SEV_RET_INVALID_CONFIG = SEV_RET_INAVLID_CONFIG,
 	SEV_RET_INVALID_LEN,
 	SEV_RET_ALREADY_OWNED,
 	SEV_RET_INVALID_CERTIFICATE,
@@ -214,6 +216,32 @@ struct sev_user_data_snp_config {
 	__u8 rsvd1[52];
 } __attribute__((packed));
 
+/**
+ * struct sev_data_snp_vlek_load - SNP_VLEK_LOAD structure
+ *
+ * @len: length of the command buffer read by the PSP
+ * @vlek_wrapped_version: version of wrapped VLEK hashstick (Must be 0h)
+ * @rsvd: reserved
+ * @vlek_wrapped_address: address of a wrapped VLEK hashstick
+ *                        (struct sev_user_data_snp_wrapped_vlek_hashstick)
+ */
+struct sev_user_data_snp_vlek_load {
+	__u32 len;				/* In */
+	__u8 vlek_wrapped_version;		/* In */
+	__u8 rsvd[3];				/* In */
+	__u64 vlek_wrapped_address;		/* In */
+} __attribute__((packed));
+
+/**
+ * struct sev_user_data_snp_vlek_wrapped_vlek_hashstick - Wrapped VLEK data
+ *
+ * @data: Opaque data provided by AMD KDS (as described in SEV-SNP Firmware ABI
+ *        1.54, SNP_VLEK_LOAD)
+ */
+struct sev_user_data_snp_wrapped_vlek_hashstick {
+	__u8 data[432];				/* In */
+} __attribute__((packed));
+
 /**
  * struct sev_issue_cmd - SEV ioctl parameters
  *
-- 
2.39.3


