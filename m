Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665EB270080
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 17:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgIRPGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 11:06:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42449 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgIRPGQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 11:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600441571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xf2I6AVSrGRq/duV5gv6UTIln0Sg/9kyZt7swxOVAAg=;
        b=hTeYaTD2W5Is/SWXL14wA4WbozEVjmAvKe3hhlVnVetz+7CjQyWd1f3D4LkjmlZA04worB
        6C8InDzYvjIbTqF8y8TUxUUTh+QjIriJKtXfLxuCmGkXpXFvnYLMLrBnPbCD8qtPkwNg2f
        5+smyGdE7f19pVUkNWrnlxqCXH0oUwI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-ntYvH_BuNs6je4miXKVF6Q-1; Fri, 18 Sep 2020 11:05:57 -0400
X-MC-Unique: ntYvH_BuNs6je4miXKVF6Q-1
Received: by mail-wm1-f70.google.com with SMTP id p20so1560410wmg.0
        for <kvm@vger.kernel.org>; Fri, 18 Sep 2020 08:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xf2I6AVSrGRq/duV5gv6UTIln0Sg/9kyZt7swxOVAAg=;
        b=h/TKzQd0hv0zP7wY1BjMgMR3q4r5P2vkadN8OYgUFiChLfBl8OxP5eO3JdK/Gy5v8P
         ZdpJ9QuvTYdbo/dtoaEilMg2/xuOgm4kqIoBA4xbwPgTa6IepNPAjoqU7vijZ+MK+JhA
         ou37K0GX8WhBDl3xeU3PT0N1vrrTadtkg+qU36EpwYT5AGCyWgm/1+ygvVwjSrAd4MWx
         sIEHiFdrxvcHrvTvws1OidSIPQFIw4fDqEbflw16rfud0jTJWPNcpHJI8I1yQ/niIT6H
         r1PzPn5R5NwoW3G+KG+1T8J/EB9o0VXmEJSCQ1aXgxWOaYsIHGXQ3J5mCDG2q/SfYpdJ
         CCNg==
X-Gm-Message-State: AOAM531SkHcEBa/F3PHHC6wmbs2F6RQ36NFUAY8HOCehnzSwpxmVr9ML
        WFhHDCyr6ry45SjY4WIkrXXZXGsQwoAZvaRnc3USPjwTDuGVDB2ALQwso6edbDn4FcfTt054R/k
        DFY+8NOrZuAyE
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr39756999wrj.92.1600441554827;
        Fri, 18 Sep 2020 08:05:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7+xpV8os/JQVixJUwclSN3/75wn0pbDCz4ycaPuCf3slCCC9cX00EUh5aOnz1pdujsL4ClQ==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr39756946wrj.92.1600441554290;
        Fri, 18 Sep 2020 08:05:54 -0700 (PDT)
Received: from redhat.com (bzq-109-65-116-225.red.bezeqint.net. [109.65.116.225])
        by smtp.gmail.com with ESMTPSA id q4sm5515780wru.65.2020.09.18.08.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 08:05:53 -0700 (PDT)
Date:   Fri, 18 Sep 2020 11:05:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PULL 01/15] linux headers: sync to 5.9-rc4
Message-ID: <20200918150506.286890-2-mst@redhat.com>
References: <20200918150506.286890-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918150506.286890-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

Update against Linux 5.9-rc4.

Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20200907104903.31551-2-jasowang@redhat.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/standard-headers/drm/drm_fourcc.h     | 140 ++++++++++++++++++
 include/standard-headers/linux/ethtool.h      |  87 +++++++++++
 .../linux/input-event-codes.h                 |   3 +-
 include/standard-headers/linux/vhost_types.h  |  11 ++
 include/standard-headers/linux/virtio_9p.h    |   4 +-
 include/standard-headers/linux/virtio_blk.h   |  26 ++--
 .../standard-headers/linux/virtio_config.h    |   8 +-
 .../standard-headers/linux/virtio_console.h   |   8 +-
 include/standard-headers/linux/virtio_net.h   |   6 +-
 include/standard-headers/linux/virtio_scsi.h  |  20 +--
 linux-headers/asm-generic/unistd.h            |   6 +-
 linux-headers/asm-mips/unistd_n32.h           |   1 +
 linux-headers/asm-mips/unistd_n64.h           |   1 +
 linux-headers/asm-mips/unistd_o32.h           |   1 +
 linux-headers/asm-powerpc/kvm.h               |   5 +
 linux-headers/asm-powerpc/unistd_32.h         |   1 +
 linux-headers/asm-powerpc/unistd_64.h         |   1 +
 linux-headers/asm-s390/kvm.h                  |   7 +-
 linux-headers/asm-s390/unistd_32.h            |   1 +
 linux-headers/asm-s390/unistd_64.h            |   1 +
 linux-headers/asm-x86/unistd_32.h             |   1 +
 linux-headers/asm-x86/unistd_64.h             |   1 +
 linux-headers/asm-x86/unistd_x32.h            |   1 +
 linux-headers/linux/kvm.h                     |   4 +
 linux-headers/linux/vfio.h                    |   2 +-
 linux-headers/linux/vhost.h                   |   2 +
 26 files changed, 308 insertions(+), 41 deletions(-)

diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index 909a66753c..0de1a552ca 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -235,6 +235,12 @@ extern "C" {
 #define DRM_FORMAT_NV61		fourcc_code('N', 'V', '6', '1') /* 2x1 subsampled Cb:Cr plane */
 #define DRM_FORMAT_NV24		fourcc_code('N', 'V', '2', '4') /* non-subsampled Cr:Cb plane */
 #define DRM_FORMAT_NV42		fourcc_code('N', 'V', '4', '2') /* non-subsampled Cb:Cr plane */
+/*
+ * 2 plane YCbCr
+ * index 0 = Y plane, [39:0] Y3:Y2:Y1:Y0 little endian
+ * index 1 = Cr:Cb plane, [39:0] Cr1:Cb1:Cr0:Cb0 little endian
+ */
+#define DRM_FORMAT_NV15		fourcc_code('N', 'V', '1', '5') /* 2x2 subsampled Cr:Cb plane */
 
 /*
  * 2 plane YCbCr MSB aligned
@@ -264,6 +270,22 @@ extern "C" {
  */
 #define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
 
+/* 3 plane non-subsampled (444) YCbCr
+ * 16 bits per component, but only 10 bits are used and 6 bits are padded
+ * index 0: Y plane, [15:0] Y:x [10:6] little endian
+ * index 1: Cb plane, [15:0] Cb:x [10:6] little endian
+ * index 2: Cr plane, [15:0] Cr:x [10:6] little endian
+ */
+#define DRM_FORMAT_Q410		fourcc_code('Q', '4', '1', '0')
+
+/* 3 plane non-subsampled (444) YCrCb
+ * 16 bits per component, but only 10 bits are used and 6 bits are padded
+ * index 0: Y plane, [15:0] Y:x [10:6] little endian
+ * index 1: Cr plane, [15:0] Cr:x [10:6] little endian
+ * index 2: Cb plane, [15:0] Cb:x [10:6] little endian
+ */
+#define DRM_FORMAT_Q401		fourcc_code('Q', '4', '0', '1')
+
 /*
  * 3 plane YCbCr
  * index 0: Y plane, [7:0] Y
@@ -308,6 +330,7 @@ extern "C" {
 #define DRM_FORMAT_MOD_VENDOR_BROADCOM 0x07
 #define DRM_FORMAT_MOD_VENDOR_ARM     0x08
 #define DRM_FORMAT_MOD_VENDOR_ALLWINNER 0x09
+#define DRM_FORMAT_MOD_VENDOR_AMLOGIC 0x0a
 
 /* add more to the end as needed */
 
@@ -322,8 +345,33 @@ extern "C" {
  * When adding a new token please document the layout with a code comment,
  * similar to the fourcc codes above. drm_fourcc.h is considered the
  * authoritative source for all of these.
+ *
+ * Generic modifier names:
+ *
+ * DRM_FORMAT_MOD_GENERIC_* definitions are used to provide vendor-neutral names
+ * for layouts which are common across multiple vendors. To preserve
+ * compatibility, in cases where a vendor-specific definition already exists and
+ * a generic name for it is desired, the common name is a purely symbolic alias
+ * and must use the same numerical value as the original definition.
+ *
+ * Note that generic names should only be used for modifiers which describe
+ * generic layouts (such as pixel re-ordering), which may have
+ * independently-developed support across multiple vendors.
+ *
+ * In future cases where a generic layout is identified before merging with a
+ * vendor-specific modifier, a new 'GENERIC' vendor or modifier using vendor
+ * 'NONE' could be considered. This should only be for obvious, exceptional
+ * cases to avoid polluting the 'GENERIC' namespace with modifiers which only
+ * apply to a single vendor.
+ *
+ * Generic names should not be used for cases where multiple hardware vendors
+ * have implementations of the same standardised compression scheme (such as
+ * AFBC). In those cases, all implementations should use the same format
+ * modifier(s), reflecting the vendor of the standard.
  */
 
+#define DRM_FORMAT_MOD_GENERIC_16_16_TILE DRM_FORMAT_MOD_SAMSUNG_16_16_TILE
+
 /*
  * Invalid Modifier
  *
@@ -891,6 +939,18 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  */
 #define AFBC_FORMAT_MOD_BCH     (1ULL << 11)
 
+/* AFBC uncompressed storage mode
+ *
+ * Indicates that the buffer is using AFBC uncompressed storage mode.
+ * In this mode all superblock payloads in the buffer use the uncompressed
+ * storage mode, which is usually only used for data which cannot be compressed.
+ * The buffer layout is the same as for AFBC buffers without USM set, this only
+ * affects the storage mode of the individual superblocks. Note that even a
+ * buffer without USM set may use uncompressed storage mode for some or all
+ * superblocks, USM just guarantees it for all.
+ */
+#define AFBC_FORMAT_MOD_USM	(1ULL << 12)
+
 /*
  * Arm 16x16 Block U-Interleaved modifier
  *
@@ -915,6 +975,86 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  */
 #define DRM_FORMAT_MOD_ALLWINNER_TILED fourcc_mod_code(ALLWINNER, 1)
 
+/*
+ * Amlogic Video Framebuffer Compression modifiers
+ *
+ * Amlogic uses a proprietary lossless image compression protocol and format
+ * for their hardware video codec accelerators, either video decoders or
+ * video input encoders.
+ *
+ * It considerably reduces memory bandwidth while writing and reading
+ * frames in memory.
+ *
+ * The underlying storage is considered to be 3 components, 8bit or 10-bit
+ * per component YCbCr 420, single plane :
+ * - DRM_FORMAT_YUV420_8BIT
+ * - DRM_FORMAT_YUV420_10BIT
+ *
+ * The first 8 bits of the mode defines the layout, then the following 8 bits
+ * defines the options changing the layout.
+ *
+ * Not all combinations are valid, and different SoCs may support different
+ * combinations of layout and options.
+ */
+#define __fourcc_mod_amlogic_layout_mask 0xf
+#define __fourcc_mod_amlogic_options_shift 8
+#define __fourcc_mod_amlogic_options_mask 0xf
+
+#define DRM_FORMAT_MOD_AMLOGIC_FBC(__layout, __options) \
+	fourcc_mod_code(AMLOGIC, \
+			((__layout) & __fourcc_mod_amlogic_layout_mask) | \
+			(((__options) & __fourcc_mod_amlogic_options_mask) \
+			 << __fourcc_mod_amlogic_options_shift))
+
+/* Amlogic FBC Layouts */
+
+/*
+ * Amlogic FBC Basic Layout
+ *
+ * The basic layout is composed of:
+ * - a body content organized in 64x32 superblocks with 4096 bytes per
+ *   superblock in default mode.
+ * - a 32 bytes per 128x64 header block
+ *
+ * This layout is transferrable between Amlogic SoCs supporting this modifier.
+ */
+#define AMLOGIC_FBC_LAYOUT_BASIC		(1ULL)
+
+/*
+ * Amlogic FBC Scatter Memory layout
+ *
+ * Indicates the header contains IOMMU references to the compressed
+ * frames content to optimize memory access and layout.
+ *
+ * In this mode, only the header memory address is needed, thus the
+ * content memory organization is tied to the current producer
+ * execution and cannot be saved/dumped neither transferrable between
+ * Amlogic SoCs supporting this modifier.
+ *
+ * Due to the nature of the layout, these buffers are not expected to
+ * be accessible by the user-space clients, but only accessible by the
+ * hardware producers and consumers.
+ *
+ * The user-space clients should expect a failure while trying to mmap
+ * the DMA-BUF handle returned by the producer.
+ */
+#define AMLOGIC_FBC_LAYOUT_SCATTER		(2ULL)
+
+/* Amlogic FBC Layout Options Bit Mask */
+
+/*
+ * Amlogic FBC Memory Saving mode
+ *
+ * Indicates the storage is packed when pixel size is multiple of word
+ * boudaries, i.e. 8bit should be stored in this mode to save allocation
+ * memory.
+ *
+ * This mode reduces body layout to 3072 bytes per 64x32 superblock with
+ * the basic layout and 3200 bytes per 64x32 superblock combined with
+ * the scatter layout.
+ */
+#define AMLOGIC_FBC_OPTION_MEM_SAVING		(1ULL << 0)
+
 #if defined(__cplusplus)
 }
 #endif
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index fd8d2cccfe..e13eff4488 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -579,6 +579,76 @@ struct ethtool_pauseparam {
 	uint32_t	tx_pause;
 };
 
+/**
+ * enum ethtool_link_ext_state - link extended state
+ */
+enum ethtool_link_ext_state {
+	ETHTOOL_LINK_EXT_STATE_AUTONEG,
+	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+	ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+	ETHTOOL_LINK_EXT_STATE_NO_CABLE,
+	ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
+	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_autoneg - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_AUTONEG.
+ */
+enum ethtool_link_ext_substate_autoneg {
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
+};
+
+/**
+ * enum ethtool_link_ext_substate_link_training - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
+ */
+enum ethtool_link_ext_substate_link_training {
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_logical_mismatch - more information in addition
+ * to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
+ */
+enum ethtool_link_ext_substate_link_logical_mismatch {
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
+};
+
+/**
+ * enum ethtool_link_ext_substate_bad_signal_integrity - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+ */
+enum ethtool_link_ext_substate_bad_signal_integrity {
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+};
+
+/**
+ * enum ethtool_link_ext_substate_cable_issue - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE.
+ */
+enum ethtool_link_ext_substate_cable_issue {
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
@@ -599,6 +669,7 @@ struct ethtool_pauseparam {
  * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
+ * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -616,6 +687,7 @@ enum ethtool_stringset {
 	ETH_SS_SOF_TIMESTAMPING,
 	ETH_SS_TS_TX_TYPES,
 	ETH_SS_TS_RX_FILTERS,
+	ETH_SS_UDP_TUNNEL_TYPES,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -1530,6 +1602,21 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
 	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
+	ETHTOOL_LINK_MODE_100000baseKR_Full_BIT		 = 75,
+	ETHTOOL_LINK_MODE_100000baseSR_Full_BIT		 = 76,
+	ETHTOOL_LINK_MODE_100000baseLR_ER_FR_Full_BIT	 = 77,
+	ETHTOOL_LINK_MODE_100000baseCR_Full_BIT		 = 78,
+	ETHTOOL_LINK_MODE_100000baseDR_Full_BIT		 = 79,
+	ETHTOOL_LINK_MODE_200000baseKR2_Full_BIT	 = 80,
+	ETHTOOL_LINK_MODE_200000baseSR2_Full_BIT	 = 81,
+	ETHTOOL_LINK_MODE_200000baseLR2_ER2_FR2_Full_BIT = 82,
+	ETHTOOL_LINK_MODE_200000baseDR2_Full_BIT	 = 83,
+	ETHTOOL_LINK_MODE_200000baseCR2_Full_BIT	 = 84,
+	ETHTOOL_LINK_MODE_400000baseKR4_Full_BIT	 = 85,
+	ETHTOOL_LINK_MODE_400000baseSR4_Full_BIT	 = 86,
+	ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT = 87,
+	ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT	 = 88,
+	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index ebf72c1031..e740ad9f2e 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -888,7 +888,8 @@
 #define SW_LINEIN_INSERT	0x0d  /* set = inserted */
 #define SW_MUTE_DEVICE		0x0e  /* set = device disabled */
 #define SW_PEN_INSERTED		0x0f  /* set = pen inserted */
-#define SW_MAX_			0x0f
+#define SW_MACHINE_COVER	0x10  /* set = cover closed */
+#define SW_MAX_			0x10
 #define SW_CNT			(SW_MAX_+1)
 
 /*
diff --git a/include/standard-headers/linux/vhost_types.h b/include/standard-headers/linux/vhost_types.h
index a678d8fbaa..486630b332 100644
--- a/include/standard-headers/linux/vhost_types.h
+++ b/include/standard-headers/linux/vhost_types.h
@@ -60,6 +60,17 @@ struct vhost_iotlb_msg {
 #define VHOST_IOTLB_UPDATE         2
 #define VHOST_IOTLB_INVALIDATE     3
 #define VHOST_IOTLB_ACCESS_FAIL    4
+/*
+ * VHOST_IOTLB_BATCH_BEGIN and VHOST_IOTLB_BATCH_END allow modifying
+ * multiple mappings in one go: beginning with
+ * VHOST_IOTLB_BATCH_BEGIN, followed by any number of
+ * VHOST_IOTLB_UPDATE messages, and ending with VHOST_IOTLB_BATCH_END.
+ * When one of these two values is used as the message type, the rest
+ * of the fields in the message are ignored. There's no guarantee that
+ * these changes take place automatically in the device.
+ */
+#define VHOST_IOTLB_BATCH_BEGIN    5
+#define VHOST_IOTLB_BATCH_END      6
 	uint8_t type;
 };
 
diff --git a/include/standard-headers/linux/virtio_9p.h b/include/standard-headers/linux/virtio_9p.h
index e68f71dbe6..f5604fc5fb 100644
--- a/include/standard-headers/linux/virtio_9p.h
+++ b/include/standard-headers/linux/virtio_9p.h
@@ -25,7 +25,7 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE. */
-#include "standard-headers/linux/types.h"
+#include "standard-headers/linux/virtio_types.h"
 #include "standard-headers/linux/virtio_ids.h"
 #include "standard-headers/linux/virtio_config.h"
 
@@ -36,7 +36,7 @@
 
 struct virtio_9p_config {
 	/* length of the tag name */
-	uint16_t tag_len;
+	__virtio16 tag_len;
 	/* non-NULL terminated tag name */
 	uint8_t tag[0];
 } QEMU_PACKED;
diff --git a/include/standard-headers/linux/virtio_blk.h b/include/standard-headers/linux/virtio_blk.h
index 0229b0fbe4..2dcc90826a 100644
--- a/include/standard-headers/linux/virtio_blk.h
+++ b/include/standard-headers/linux/virtio_blk.h
@@ -55,20 +55,20 @@
 
 struct virtio_blk_config {
 	/* The capacity (in 512-byte sectors). */
-	uint64_t capacity;
+	__virtio64 capacity;
 	/* The maximum segment size (if VIRTIO_BLK_F_SIZE_MAX) */
-	uint32_t size_max;
+	__virtio32 size_max;
 	/* The maximum number of segments (if VIRTIO_BLK_F_SEG_MAX) */
-	uint32_t seg_max;
+	__virtio32 seg_max;
 	/* geometry of the device (if VIRTIO_BLK_F_GEOMETRY) */
 	struct virtio_blk_geometry {
-		uint16_t cylinders;
+		__virtio16 cylinders;
 		uint8_t heads;
 		uint8_t sectors;
 	} geometry;
 
 	/* block size of device (if VIRTIO_BLK_F_BLK_SIZE) */
-	uint32_t blk_size;
+	__virtio32 blk_size;
 
 	/* the next 4 entries are guarded by VIRTIO_BLK_F_TOPOLOGY  */
 	/* exponent for physical block per logical block. */
@@ -76,42 +76,42 @@ struct virtio_blk_config {
 	/* alignment offset in logical blocks. */
 	uint8_t alignment_offset;
 	/* minimum I/O size without performance penalty in logical blocks. */
-	uint16_t min_io_size;
+	__virtio16 min_io_size;
 	/* optimal sustained I/O size in logical blocks. */
-	uint32_t opt_io_size;
+	__virtio32 opt_io_size;
 
 	/* writeback mode (if VIRTIO_BLK_F_CONFIG_WCE) */
 	uint8_t wce;
 	uint8_t unused;
 
 	/* number of vqs, only available when VIRTIO_BLK_F_MQ is set */
-	uint16_t num_queues;
+	__virtio16 num_queues;
 
 	/* the next 3 entries are guarded by VIRTIO_BLK_F_DISCARD */
 	/*
 	 * The maximum discard sectors (in 512-byte sectors) for
 	 * one segment.
 	 */
-	uint32_t max_discard_sectors;
+	__virtio32 max_discard_sectors;
 	/*
 	 * The maximum number of discard segments in a
 	 * discard command.
 	 */
-	uint32_t max_discard_seg;
+	__virtio32 max_discard_seg;
 	/* Discard commands must be aligned to this number of sectors. */
-	uint32_t discard_sector_alignment;
+	__virtio32 discard_sector_alignment;
 
 	/* the next 3 entries are guarded by VIRTIO_BLK_F_WRITE_ZEROES */
 	/*
 	 * The maximum number of write zeroes sectors (in 512-byte sectors) in
 	 * one segment.
 	 */
-	uint32_t max_write_zeroes_sectors;
+	__virtio32 max_write_zeroes_sectors;
 	/*
 	 * The maximum number of segments in a write zeroes
 	 * command.
 	 */
-	uint32_t max_write_zeroes_seg;
+	__virtio32 max_write_zeroes_seg;
 	/*
 	 * Set if a VIRTIO_BLK_T_WRITE_ZEROES request may result in the
 	 * deallocation of one or more of the sectors.
diff --git a/include/standard-headers/linux/virtio_config.h b/include/standard-headers/linux/virtio_config.h
index 9a69d9e242..22e3a85f67 100644
--- a/include/standard-headers/linux/virtio_config.h
+++ b/include/standard-headers/linux/virtio_config.h
@@ -67,13 +67,15 @@
 #define VIRTIO_F_VERSION_1		32
 
 /*
- * If clear - device has the IOMMU bypass quirk feature.
- * If set - use platform tools to detect the IOMMU.
+ * If clear - device has the platform DMA (e.g. IOMMU) bypass quirk feature.
+ * If set - use platform DMA tools to access the memory.
  *
  * Note the reverse polarity (compared to most other features),
  * this is for compatibility with legacy systems.
  */
-#define VIRTIO_F_IOMMU_PLATFORM		33
+#define VIRTIO_F_ACCESS_PLATFORM	33
+/* Legacy name for VIRTIO_F_ACCESS_PLATFORM (for compatibility with old userspace) */
+#define VIRTIO_F_IOMMU_PLATFORM		VIRTIO_F_ACCESS_PLATFORM
 
 /* This feature indicates support for the packed virtqueue layout. */
 #define VIRTIO_F_RING_PACKED		34
diff --git a/include/standard-headers/linux/virtio_console.h b/include/standard-headers/linux/virtio_console.h
index 0dedc9e6f5..71f5f648e3 100644
--- a/include/standard-headers/linux/virtio_console.h
+++ b/include/standard-headers/linux/virtio_console.h
@@ -45,13 +45,13 @@
 
 struct virtio_console_config {
 	/* colums of the screens */
-	uint16_t cols;
+	__virtio16 cols;
 	/* rows of the screens */
-	uint16_t rows;
+	__virtio16 rows;
 	/* max. number of ports this device can hold */
-	uint32_t max_nr_ports;
+	__virtio32 max_nr_ports;
 	/* emergency write register */
-	uint32_t emerg_wr;
+	__virtio32 emerg_wr;
 } QEMU_PACKED;
 
 /*
diff --git a/include/standard-headers/linux/virtio_net.h b/include/standard-headers/linux/virtio_net.h
index a90f79e1b1..e0a070518f 100644
--- a/include/standard-headers/linux/virtio_net.h
+++ b/include/standard-headers/linux/virtio_net.h
@@ -87,14 +87,14 @@ struct virtio_net_config {
 	/* The config defining mac address (if VIRTIO_NET_F_MAC) */
 	uint8_t mac[ETH_ALEN];
 	/* See VIRTIO_NET_F_STATUS and VIRTIO_NET_S_* above */
-	uint16_t status;
+	__virtio16 status;
 	/* Maximum number of each of transmit and receive queues;
 	 * see VIRTIO_NET_F_MQ and VIRTIO_NET_CTRL_MQ.
 	 * Legal values are between 1 and 0x8000
 	 */
-	uint16_t max_virtqueue_pairs;
+	__virtio16 max_virtqueue_pairs;
 	/* Default maximum transmit unit advice */
-	uint16_t mtu;
+	__virtio16 mtu;
 	/*
 	 * speed, in units of 1Mb. All values 0 to INT_MAX are legal.
 	 * Any other value stands for unknown.
diff --git a/include/standard-headers/linux/virtio_scsi.h b/include/standard-headers/linux/virtio_scsi.h
index ab66166b6a..663f36cbb7 100644
--- a/include/standard-headers/linux/virtio_scsi.h
+++ b/include/standard-headers/linux/virtio_scsi.h
@@ -103,16 +103,16 @@ struct virtio_scsi_event {
 } QEMU_PACKED;
 
 struct virtio_scsi_config {
-	uint32_t num_queues;
-	uint32_t seg_max;
-	uint32_t max_sectors;
-	uint32_t cmd_per_lun;
-	uint32_t event_info_size;
-	uint32_t sense_size;
-	uint32_t cdb_size;
-	uint16_t max_channel;
-	uint16_t max_target;
-	uint32_t max_lun;
+	__virtio32 num_queues;
+	__virtio32 seg_max;
+	__virtio32 max_sectors;
+	__virtio32 cmd_per_lun;
+	__virtio32 event_info_size;
+	__virtio32 sense_size;
+	__virtio32 cdb_size;
+	__virtio16 max_channel;
+	__virtio16 max_target;
+	__virtio32 max_lun;
 } QEMU_PACKED;
 
 /* Feature Bits */
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index f4a01305d9..995b36c2ea 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -606,9 +606,9 @@ __SYSCALL(__NR_sendto, sys_sendto)
 #define __NR_recvfrom 207
 __SC_COMP(__NR_recvfrom, sys_recvfrom, compat_sys_recvfrom)
 #define __NR_setsockopt 208
-__SC_COMP(__NR_setsockopt, sys_setsockopt, compat_sys_setsockopt)
+__SC_COMP(__NR_setsockopt, sys_setsockopt, sys_setsockopt)
 #define __NR_getsockopt 209
-__SC_COMP(__NR_getsockopt, sys_getsockopt, compat_sys_getsockopt)
+__SC_COMP(__NR_getsockopt, sys_getsockopt, sys_getsockopt)
 #define __NR_shutdown 210
 __SYSCALL(__NR_shutdown, sys_shutdown)
 #define __NR_sendmsg 211
@@ -850,6 +850,8 @@ __SYSCALL(__NR_pidfd_open, sys_pidfd_open)
 #define __NR_clone3 435
 __SYSCALL(__NR_clone3, sys_clone3)
 #endif
+#define __NR_close_range 436
+__SYSCALL(__NR_close_range, sys_close_range)
 
 #define __NR_openat2 437
 __SYSCALL(__NR_openat2, sys_openat2)
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 3b9eda7e7d..246fbb6a78 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -365,6 +365,7 @@
 #define __NR_fspick	(__NR_Linux + 433)
 #define __NR_pidfd_open	(__NR_Linux + 434)
 #define __NR_clone3	(__NR_Linux + 435)
+#define __NR_close_range	(__NR_Linux + 436)
 #define __NR_openat2	(__NR_Linux + 437)
 #define __NR_pidfd_getfd	(__NR_Linux + 438)
 #define __NR_faccessat2	(__NR_Linux + 439)
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 9cdf9b6c60..194d777dfd 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -341,6 +341,7 @@
 #define __NR_fspick	(__NR_Linux + 433)
 #define __NR_pidfd_open	(__NR_Linux + 434)
 #define __NR_clone3	(__NR_Linux + 435)
+#define __NR_close_range	(__NR_Linux + 436)
 #define __NR_openat2	(__NR_Linux + 437)
 #define __NR_pidfd_getfd	(__NR_Linux + 438)
 #define __NR_faccessat2	(__NR_Linux + 439)
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index e3e5e238f0..3e093dd913 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -411,6 +411,7 @@
 #define __NR_fspick	(__NR_Linux + 433)
 #define __NR_pidfd_open	(__NR_Linux + 434)
 #define __NR_clone3	(__NR_Linux + 435)
+#define __NR_close_range	(__NR_Linux + 436)
 #define __NR_openat2	(__NR_Linux + 437)
 #define __NR_pidfd_getfd	(__NR_Linux + 438)
 #define __NR_faccessat2	(__NR_Linux + 439)
diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
index 264e266a85..c3af3f324c 100644
--- a/linux-headers/asm-powerpc/kvm.h
+++ b/linux-headers/asm-powerpc/kvm.h
@@ -640,6 +640,11 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_ONLINE	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbf)
 #define KVM_REG_PPC_PTCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc0)
 
+/* POWER10 registers */
+#define KVM_REG_PPC_MMCR3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
+#define KVM_REG_PPC_SIER2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
+#define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 862edb7448..0db9481d49 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -418,6 +418,7 @@
 #define __NR_fspick	433
 #define __NR_pidfd_open	434
 #define __NR_clone3	435
+#define __NR_close_range	436
 #define __NR_openat2	437
 #define __NR_pidfd_getfd	438
 #define __NR_faccessat2	439
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index f553224ce4..9f74310988 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -390,6 +390,7 @@
 #define __NR_fspick	433
 #define __NR_pidfd_open	434
 #define __NR_clone3	435
+#define __NR_close_range	436
 #define __NR_openat2	437
 #define __NR_pidfd_getfd	438
 #define __NR_faccessat2	439
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index 0138ccb0d8..f053b8304a 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -231,11 +231,13 @@ struct kvm_guest_debug_arch {
 #define KVM_SYNC_GSCB   (1UL << 9)
 #define KVM_SYNC_BPBC   (1UL << 10)
 #define KVM_SYNC_ETOKEN (1UL << 11)
+#define KVM_SYNC_DIAG318 (1UL << 12)
 
 #define KVM_SYNC_S390_VALID_FIELDS \
 	(KVM_SYNC_PREFIX | KVM_SYNC_GPRS | KVM_SYNC_ACRS | KVM_SYNC_CRS | \
 	 KVM_SYNC_ARCH0 | KVM_SYNC_PFAULT | KVM_SYNC_VRS | KVM_SYNC_RICCB | \
-	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN)
+	 KVM_SYNC_FPRS | KVM_SYNC_GSCB | KVM_SYNC_BPBC | KVM_SYNC_ETOKEN | \
+	 KVM_SYNC_DIAG318)
 
 /* length and alignment of the sdnx as a power of two */
 #define SDNXC 8
@@ -264,7 +266,8 @@ struct kvm_sync_regs {
 	__u8 reserved2 : 7;
 	__u8 padding1[51];	/* riccb needs to be 64byte aligned */
 	__u8 riccb[64];		/* runtime instrumentation controls block */
-	__u8 padding2[192];	/* sdnx needs to be 256byte aligned */
+	__u64 diag318;		/* diagnose 0x318 info */
+	__u8 padding2[184];	/* sdnx needs to be 256byte aligned */
 	union {
 		__u8 sdnx[SDNXL];  /* state description annex */
 		struct {
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index e08233c0c3..1803cd0c3b 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -408,6 +408,7 @@
 #define __NR_fspick 433
 #define __NR_pidfd_open 434
 #define __NR_clone3 435
+#define __NR_close_range 436
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 560e19ae2b..228d5004e5 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -356,6 +356,7 @@
 #define __NR_fspick 433
 #define __NR_pidfd_open 434
 #define __NR_clone3 435
+#define __NR_close_range 436
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index c727981d4a..356c12c2db 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -426,6 +426,7 @@
 #define __NR_fspick 433
 #define __NR_pidfd_open 434
 #define __NR_clone3 435
+#define __NR_close_range 436
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index 843fa62745..ef70e1c7c9 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -348,6 +348,7 @@
 #define __NR_fspick 433
 #define __NR_pidfd_open 434
 #define __NR_clone3 435
+#define __NR_close_range 436
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 7d63d703ca..84ae8e9f5f 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -301,6 +301,7 @@
 #define __NR_fspick (__X32_SYSCALL_BIT + 433)
 #define __NR_pidfd_open (__X32_SYSCALL_BIT + 434)
 #define __NR_clone3 (__X32_SYSCALL_BIT + 435)
+#define __NR_close_range (__X32_SYSCALL_BIT + 436)
 #define __NR_openat2 (__X32_SYSCALL_BIT + 437)
 #define __NR_pidfd_getfd (__X32_SYSCALL_BIT + 438)
 #define __NR_faccessat2 (__X32_SYSCALL_BIT + 439)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index a28c366737..6683e2e1b0 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -289,6 +289,7 @@ struct kvm_run {
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu;
 		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
@@ -1031,6 +1032,9 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_SECURE_GUEST 181
 #define KVM_CAP_HALT_POLL 182
 #define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_LAST_CPU 184
+#define KVM_CAP_SMALLER_MAXPHYADDR 185
+#define KVM_CAP_S390_DIAG318 186
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index f09df262c4..a90672494d 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -1030,7 +1030,7 @@ struct vfio_iommu_type1_info_cap_iova_range {
  * size in bytes that can be used by user applications when getting the dirty
  * bitmap.
  */
-#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
+#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  2
 
 struct vfio_iommu_type1_info_cap_migration {
 	struct	vfio_info_cap_header header;
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index 0c2349612e..7523218532 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -91,6 +91,8 @@
 
 /* Use message type V2 */
 #define VHOST_BACKEND_F_IOTLB_MSG_V2 0x1
+/* IOTLB can accept batching hints */
+#define VHOST_BACKEND_F_IOTLB_BATCH  0x2
 
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
-- 
MST

