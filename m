Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591FF6D84C2
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjDERVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 13:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDERVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 13:21:37 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF0D59C4
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 10:21:34 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id 4fb4d7f45d1cf-5024a72b054so454905a12.0
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 10:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680715293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iYqpWC3H/OEu9CLQx7GCPFmJNJ2MQftAdNeFMZwTQ2s=;
        b=tOxHDgwoPLbmSvmRz/8ioLDI2adfwy+fVgn9zT6IQ8341e1p9hposbj820D3zDuxif
         VUstAmpgHTFu92/ltFziNrdCHD4GdwDmRaNxx3TJ5IrMoao5Wfwj4PE44vVs8oSV06hZ
         keaTOZ7QGUj/Ompau50qnaYwrdxrmjHyrG1vctBlnbt1Kxb1VRPq/KkLem4sWdYuafYJ
         uIc9QgFEBuL08Qxiej1vMHOSVkAaUMff12XaKKZPf4l7X4o8pkmT/lTx3BgRAg48OPx4
         9g+XrdLkArgyBNUOUzu+X1t0ucvZrHtOUEUZjBssVb8ggLDsOsZUrGian/NVJcL1uF7Q
         lz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680715293;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iYqpWC3H/OEu9CLQx7GCPFmJNJ2MQftAdNeFMZwTQ2s=;
        b=dYcJqO8UkhRyMJ3EocsGBVg8K0KlHvhagb15AeJreIVDIetXN85oxyD3mpft+7zrCB
         +MDI3K3Vl7Rx3Pv0eq09OyVgreOr8pKX5yJYOtpyizmbevnBq99mnqsagnUzOS0ecnf2
         vXJodia+GYrc1XbG41BLvJloJXzMTMXdaYKnRqkkhd2B/3frbBErNg8jjW/DWYC4Da/y
         Ok8N5XD4J4RKDyyilDw3vWVAe752/FUyNkJnChJCG/p3dr3bZZcUb52PcgCTvipxYF8X
         V47EJTujrYUGioejDvPyppjUiWUvuBPtH/gPQ1vRzz6Z3Dnl3o/lr8wJtpp9GUZ6qz1N
         x92A==
X-Gm-Message-State: AAQBX9fBCwmpkxs3UGfGZp7zY6fNeImuaFITfgfnwCZ/wxxwBIIUTBH5
        f4YeqbIeraX7wtHUuE71gX8aZ2a9Cw==
X-Google-Smtp-Source: AKy350ZX6CAPa43veWOmlFjAcKYYFC2dwoNhMLlNZxjlDArUw3vIPbnzfXTIQ3gqNYZCMB6hA882DZu8XA==
X-Received: from digit-linux-eng.par.corp.google.com ([2a00:79e0:a0:1:d1d4:d452:da86:5ee0])
 (user=digit job=sendgmr) by 2002:a50:a6d5:0:b0:4fd:939:56ca with SMTP id
 f21-20020a50a6d5000000b004fd093956camr1633219edc.5.1680715292857; Wed, 05 Apr
 2023 10:21:32 -0700 (PDT)
Date:   Wed,  5 Apr 2023 19:21:09 +0200
In-Reply-To: <20230405172109.3081788-1-digit@google.com>
Mime-Version: 1.0
References: <20230405172109.3081788-1-digit@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405172109.3081788-4-digit@google.com>
Subject: [PATCH 3/3] Update linux headers to v6.3rc5
From:   "David 'Digit' Turner" <digit@google.com>
To:     qemu-devel@nongnu.org
Cc:     "David 'Digit' Turner" <digit@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 7e364e56293bb98cae1b55fd835f5991c4e96e7d

Signed-off-by: David 'Digit' Turner <digit@google.com>
---
 include/standard-headers/drm/drm_fourcc.h    |  12 ++
 include/standard-headers/linux/ethtool.h     |  48 +++++++-
 include/standard-headers/linux/fuse.h        |  45 +++++++-
 include/standard-headers/linux/pci_regs.h    |   1 +
 include/standard-headers/linux/vhost_types.h |   2 +
 include/standard-headers/linux/virtio_blk.h  | 105 +++++++++++++++++
 linux-headers/asm-arm64/kvm.h                |   1 +
 linux-headers/asm-x86/kvm.h                  |  34 +++++-
 linux-headers/linux/const.h                  |  36 ++++++
 linux-headers/linux/kvm.h                    |   9 ++
 linux-headers/linux/memfd.h                  |  39 +++++++
 linux-headers/linux/nvme_ioctl.h             | 114 +++++++++++++++++++
 linux-headers/linux/vfio.h                   |  15 ++-
 linux-headers/linux/vhost.h                  |   8 ++
 14 files changed, 459 insertions(+), 10 deletions(-)
 create mode 100644 linux-headers/linux/const.h
 create mode 100644 linux-headers/linux/memfd.h
 create mode 100644 linux-headers/linux/nvme_ioctl.h

diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index 69cab17b38..dc3e6112c1 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -87,6 +87,18 @@ extern "C" {
  *
  * The authoritative list of format modifier codes is found in
  * `include/uapi/drm/drm_fourcc.h`
+ *
+ * Open Source User Waiver
+ * -----------------------
+ *
+ * Because this is the authoritative source for pixel formats and modifiers
+ * referenced by GL, Vulkan extensions and other standards and hence used both
+ * by open source and closed source driver stacks, the usual requirement for an
+ * upstream in-kernel or open source userspace user does not apply.
+ *
+ * To ensure, as much as feasible, compatibility across stacks and avoid
+ * confusion with incompatible enumerations stakeholders for all relevant driver
+ * stacks should approve additions.
  */
 
 #define fourcc_code(a, b, c, d) ((uint32_t)(a) | ((uint32_t)(b) << 8) | \
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 87176ab075..99fcddf04f 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -711,6 +711,24 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_mac_stats_src - source of ethtool MAC statistics
+ * @ETHTOOL_MAC_STATS_SRC_AGGREGATE:
+ *	if device supports a MAC merge layer, this retrieves the aggregate
+ *	statistics of the eMAC and pMAC. Otherwise, it retrieves just the
+ *	statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_EMAC:
+ *	if device supports a MM layer, this retrieves the eMAC statistics.
+ *	Otherwise, it retrieves the statistics of the single (express) MAC.
+ * @ETHTOOL_MAC_STATS_SRC_PMAC:
+ *	if device supports a MM layer, this retrieves the pMAC statistics.
+ */
+enum ethtool_mac_stats_src {
+	ETHTOOL_MAC_STATS_SRC_AGGREGATE,
+	ETHTOOL_MAC_STATS_SRC_EMAC,
+	ETHTOOL_MAC_STATS_SRC_PMAC,
+};
+
 /**
  * enum ethtool_module_power_mode_policy - plug-in module power mode policy
  * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
@@ -779,6 +797,31 @@ enum ethtool_podl_pse_pw_d_status {
 	ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR,
 };
 
+/**
+ * enum ethtool_mm_verify_status - status of MAC Merge Verify function
+ * @ETHTOOL_MM_VERIFY_STATUS_UNKNOWN:
+ *	verification status is unknown
+ * @ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+ *	the 802.3 Verify State diagram is in the state INIT_VERIFICATION
+ * @ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+ *	the Verify State diagram is in the state VERIFICATION_IDLE,
+ *	SEND_VERIFY or WAIT_FOR_RESPONSE
+ * @ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+ *	indicates that the Verify State diagram is in the state VERIFIED
+ * @ETHTOOL_MM_VERIFY_STATUS_FAILED:
+ *	the Verify State diagram is in the state VERIFY_FAIL
+ * @ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+ *	verification of preemption operation is disabled
+ */
+enum ethtool_mm_verify_status {
+	ETHTOOL_MM_VERIFY_STATUS_UNKNOWN,
+	ETHTOOL_MM_VERIFY_STATUS_INITIAL,
+	ETHTOOL_MM_VERIFY_STATUS_VERIFYING,
+	ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED,
+	ETHTOOL_MM_VERIFY_STATUS_FAILED,
+	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
@@ -1183,7 +1226,7 @@ struct ethtool_rxnfc {
 		uint32_t			rule_cnt;
 		uint32_t			rss_context;
 	};
-	uint32_t				rule_locs[0];
+	uint32_t				rule_locs[];
 };
 
 
@@ -1741,6 +1784,9 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_800000baseDR8_2_Full_BIT	 = 96,
 	ETHTOOL_LINK_MODE_800000baseSR8_Full_BIT	 = 97,
 	ETHTOOL_LINK_MODE_800000baseVR8_Full_BIT	 = 98,
+	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 99,
+	ETHTOOL_LINK_MODE_10baseT1S_Half_BIT		 = 100,
+	ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT	 = 101,
 
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index a1af78d989..35c131a107 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -201,6 +201,11 @@
  *  7.38
  *  - add FUSE_EXPIRE_ONLY flag to fuse_notify_inval_entry
  *  - add FOPEN_PARALLEL_DIRECT_WRITES
+ *  - add total_extlen to fuse_in_header
+ *  - add FUSE_MAX_NR_SECCTX
+ *  - add extension header
+ *  - add FUSE_EXT_GROUPS
+ *  - add FUSE_CREATE_SUPP_GROUP
  */
 
 #ifndef _LINUX_FUSE_H
@@ -358,6 +363,8 @@ struct fuse_file_lock {
  * FUSE_SECURITY_CTX:	add security context to create, mkdir, symlink, and
  *			mknod
  * FUSE_HAS_INODE_DAX:  use per inode DAX
+ * FUSE_CREATE_SUPP_GROUP: add supplementary group info to create, mkdir,
+ *			symlink and mknod (single group that matches parent)
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -394,6 +401,7 @@ struct fuse_file_lock {
 /* bits 32..63 get shifted down 32 bits into the flags2 field */
 #define FUSE_SECURITY_CTX	(1ULL << 32)
 #define FUSE_HAS_INODE_DAX	(1ULL << 33)
+#define FUSE_CREATE_SUPP_GROUP	(1ULL << 34)
 
 /**
  * CUSE INIT request/reply flags
@@ -499,6 +507,17 @@ struct fuse_file_lock {
  */
 #define FUSE_EXPIRE_ONLY		(1 << 0)
 
+/**
+ * extension type
+ * FUSE_MAX_NR_SECCTX: maximum value of &fuse_secctx_header.nr_secctx
+ * FUSE_EXT_GROUPS: &fuse_supp_groups extension
+ */
+enum fuse_ext_type {
+	/* Types 0..31 are reserved for fuse_secctx_header */
+	FUSE_MAX_NR_SECCTX	= 31,
+	FUSE_EXT_GROUPS		= 32,
+};
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
@@ -882,7 +901,8 @@ struct fuse_in_header {
 	uint32_t	uid;
 	uint32_t	gid;
 	uint32_t	pid;
-	uint32_t	padding;
+	uint16_t	total_extlen; /* length of extensions in 8byte units */
+	uint16_t	padding;
 };
 
 struct fuse_out_header {
@@ -1043,4 +1063,27 @@ struct fuse_secctx_header {
 	uint32_t	nr_secctx;
 };
 
+/**
+ * struct fuse_ext_header - extension header
+ * @size: total size of this extension including this header
+ * @type: type of extension
+ *
+ * This is made compatible with fuse_secctx_header by using type values >
+ * FUSE_MAX_NR_SECCTX
+ */
+struct fuse_ext_header {
+	uint32_t	size;
+	uint32_t	type;
+};
+
+/**
+ * struct fuse_supp_groups - Supplementary group extension
+ * @nr_groups: number of supplementary groups
+ * @groups: flexible array of group IDs
+ */
+struct fuse_supp_groups {
+	uint32_t	nr_groups;
+	uint32_t	groups[];
+};
+
 #endif /* _LINUX_FUSE_H */
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index 85ab127881..dc2000e0fe 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -693,6 +693,7 @@
 #define  PCI_EXP_LNKCTL2_TX_MARGIN	0x0380 /* Transmit Margin */
 #define  PCI_EXP_LNKCTL2_HASD		0x0020 /* HW Autonomous Speed Disable */
 #define PCI_EXP_LNKSTA2		0x32	/* Link Status 2 */
+#define  PCI_EXP_LNKSTA2_FLIT		0x0400 /* Flit Mode Status */
 #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x32	/* end of v2 EPs w/ link */
 #define PCI_EXP_SLTCAP2		0x34	/* Slot Capabilities 2 */
 #define  PCI_EXP_SLTCAP2_IBPD	0x00000001 /* In-band PD Disable Supported */
diff --git a/include/standard-headers/linux/vhost_types.h b/include/standard-headers/linux/vhost_types.h
index c41a73fe36..88600e2d9f 100644
--- a/include/standard-headers/linux/vhost_types.h
+++ b/include/standard-headers/linux/vhost_types.h
@@ -163,5 +163,7 @@ struct vhost_vdpa_iova_range {
 #define VHOST_BACKEND_F_IOTLB_ASID  0x3
 /* Device can be suspended */
 #define VHOST_BACKEND_F_SUSPEND  0x4
+/* Device can be resumed */
+#define VHOST_BACKEND_F_RESUME  0x5
 
 #endif
diff --git a/include/standard-headers/linux/virtio_blk.h b/include/standard-headers/linux/virtio_blk.h
index e81715cd70..7155b1a470 100644
--- a/include/standard-headers/linux/virtio_blk.h
+++ b/include/standard-headers/linux/virtio_blk.h
@@ -41,6 +41,7 @@
 #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
 #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
 #define VIRTIO_BLK_F_SECURE_ERASE	16 /* Secure Erase is supported */
+#define VIRTIO_BLK_F_ZONED		17	/* Zoned block device */
 
 /* Legacy feature bits */
 #ifndef VIRTIO_BLK_NO_LEGACY
@@ -135,6 +136,16 @@ struct virtio_blk_config {
 	/* Secure erase commands must be aligned to this number of sectors. */
 	__virtio32 secure_erase_sector_alignment;
 
+	/* Zoned block device characteristics (if VIRTIO_BLK_F_ZONED) */
+	struct virtio_blk_zoned_characteristics {
+		uint32_t zone_sectors;
+		uint32_t max_open_zones;
+		uint32_t max_active_zones;
+		uint32_t max_append_sectors;
+		uint32_t write_granularity;
+		uint8_t model;
+		uint8_t unused2[3];
+	} zoned;
 } QEMU_PACKED;
 
 /*
@@ -172,6 +183,27 @@ struct virtio_blk_config {
 /* Secure erase command */
 #define VIRTIO_BLK_T_SECURE_ERASE	14
 
+/* Zone append command */
+#define VIRTIO_BLK_T_ZONE_APPEND    15
+
+/* Report zones command */
+#define VIRTIO_BLK_T_ZONE_REPORT    16
+
+/* Open zone command */
+#define VIRTIO_BLK_T_ZONE_OPEN      18
+
+/* Close zone command */
+#define VIRTIO_BLK_T_ZONE_CLOSE     20
+
+/* Finish zone command */
+#define VIRTIO_BLK_T_ZONE_FINISH    22
+
+/* Reset zone command */
+#define VIRTIO_BLK_T_ZONE_RESET     24
+
+/* Reset All zones command */
+#define VIRTIO_BLK_T_ZONE_RESET_ALL 26
+
 #ifndef VIRTIO_BLK_NO_LEGACY
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
@@ -191,6 +223,72 @@ struct virtio_blk_outhdr {
 	__virtio64 sector;
 };
 
+/*
+ * Supported zoned device models.
+ */
+
+/* Regular block device */
+#define VIRTIO_BLK_Z_NONE      0
+/* Host-managed zoned device */
+#define VIRTIO_BLK_Z_HM        1
+/* Host-aware zoned device */
+#define VIRTIO_BLK_Z_HA        2
+
+/*
+ * Zone descriptor. A part of VIRTIO_BLK_T_ZONE_REPORT command reply.
+ */
+struct virtio_blk_zone_descriptor {
+	/* Zone capacity */
+	uint64_t z_cap;
+	/* The starting sector of the zone */
+	uint64_t z_start;
+	/* Zone write pointer position in sectors */
+	uint64_t z_wp;
+	/* Zone type */
+	uint8_t z_type;
+	/* Zone state */
+	uint8_t z_state;
+	uint8_t reserved[38];
+};
+
+struct virtio_blk_zone_report {
+	uint64_t nr_zones;
+	uint8_t reserved[56];
+	struct virtio_blk_zone_descriptor zones[];
+};
+
+/*
+ * Supported zone types.
+ */
+
+/* Conventional zone */
+#define VIRTIO_BLK_ZT_CONV         1
+/* Sequential Write Required zone */
+#define VIRTIO_BLK_ZT_SWR          2
+/* Sequential Write Preferred zone */
+#define VIRTIO_BLK_ZT_SWP          3
+
+/*
+ * Zone states that are available for zones of all types.
+ */
+
+/* Not a write pointer (conventional zones only) */
+#define VIRTIO_BLK_ZS_NOT_WP       0
+/* Empty */
+#define VIRTIO_BLK_ZS_EMPTY        1
+/* Implicitly Open */
+#define VIRTIO_BLK_ZS_IOPEN        2
+/* Explicitly Open */
+#define VIRTIO_BLK_ZS_EOPEN        3
+/* Closed */
+#define VIRTIO_BLK_ZS_CLOSED       4
+/* Read-Only */
+#define VIRTIO_BLK_ZS_RDONLY       13
+/* Full */
+#define VIRTIO_BLK_ZS_FULL         14
+/* Offline */
+#define VIRTIO_BLK_ZS_OFFLINE      15
+
 /* Unmap this range (only valid for write zeroes command) */
 #define VIRTIO_BLK_WRITE_ZEROES_FLAG_UNMAP	0x00000001
 
@@ -217,4 +315,11 @@ struct virtio_scsi_inhdr {
 #define VIRTIO_BLK_S_OK		0
 #define VIRTIO_BLK_S_IOERR	1
 #define VIRTIO_BLK_S_UNSUPP	2
+
+/* Error codes that are specific to zoned block devices */
+#define VIRTIO_BLK_S_ZONE_INVALID_CMD     3
+#define VIRTIO_BLK_S_ZONE_UNALIGNED_WP    4
+#define VIRTIO_BLK_S_ZONE_OPEN_RESOURCE   5
+#define VIRTIO_BLK_S_ZONE_ACTIVE_RESOURCE 6
+
 #endif /* _LINUX_VIRTIO_BLK_H */
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index a7cfefb3a8..d7e7bb885e 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -109,6 +109,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 2747d2ce14..2937e7bf69 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/stddef.h>
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
@@ -505,8 +506,8 @@ struct kvm_nested_state {
 	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
 	 */
 	union {
-		struct kvm_vmx_nested_state_data vmx[0];
-		struct kvm_svm_nested_state_data svm[0];
+		__DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data, vmx);
+		__DECLARE_FLEX_ARRAY(struct kvm_svm_nested_state_data, svm);
 	} data;
 };
 
@@ -523,6 +524,35 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+
+/*
+ * Masked event layout.
+ * Bits   Description
+ * ----   -----------
+ * 7:0    event select (low bits)
+ * 15:8   umask match
+ * 31:16  unused
+ * 35:32  event select (high bits)
+ * 36:54  unused
+ * 55     exclude bit
+ * 63:56  umask mask
+ */
+
+#define KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, exclude) \
+	(((event_select) & 0xFFULL) | (((event_select) & 0XF00ULL) << 24) | \
+	(((mask) & 0xFFULL) << 56) | \
+	(((match) & 0xFFULL) << 8) | \
+	((__u64)(!!(exclude)) << 55))
+
+#define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
+	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
+
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
diff --git a/linux-headers/linux/const.h b/linux-headers/linux/const.h
new file mode 100644
index 0000000000..5e48987251
--- /dev/null
+++ b/linux-headers/linux/const.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* const.h: Macros for dealing with constants.  */
+
+#ifndef _LINUX_CONST_H
+#define _LINUX_CONST_H
+
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
+ *
+ * Similarly, _AT() will cast an expression with a type in C, but
+ * leave it unchanged in asm.
+ */
+
+#ifdef __ASSEMBLY__
+#define _AC(X,Y)	X
+#define _AT(T,X)	X
+#else
+#define __AC(X,Y)	(X##Y)
+#define _AC(X,Y)	__AC(X,Y)
+#define _AT(T,X)	((T)(X))
+#endif
+
+#define _UL(x)		(_AC(x, UL))
+#define _ULL(x)		(_AC(x, ULL))
+
+#define _BITUL(x)	(_UL(1) << (x))
+#define _BITULL(x)	(_ULL(1) << (x))
+
+#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
+#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
+
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+
+#endif /* _LINUX_CONST_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 1e2c16cfe3..599de3c6e3 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -581,6 +581,8 @@ struct kvm_s390_mem_op {
 		struct {
 			__u8 ar;	/* the access register number */
 			__u8 key;	/* access key, ignored if flag unset */
+			__u8 pad1[6];	/* ignored */
+			__u64 old_addr;	/* ignored if cmpxchg flag unset */
 		};
 		__u32 sida_offset; /* offset into the sida */
 		__u8 reserved[32]; /* ignored */
@@ -593,11 +595,17 @@ struct kvm_s390_mem_op {
 #define KVM_S390_MEMOP_SIDA_WRITE	3
 #define KVM_S390_MEMOP_ABSOLUTE_READ	4
 #define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
+#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
+
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
 #define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
 
+/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
+#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
+#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
+
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
@@ -1173,6 +1181,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/linux-headers/linux/memfd.h b/linux-headers/linux/memfd.h
new file mode 100644
index 0000000000..01c0324e77
--- /dev/null
+++ b/linux-headers/linux/memfd.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_MEMFD_H
+#define _LINUX_MEMFD_H
+
+#include <asm-generic/hugetlb_encode.h>
+
+/* flags for memfd_create(2) (unsigned int) */
+#define MFD_CLOEXEC		0x0001U
+#define MFD_ALLOW_SEALING	0x0002U
+#define MFD_HUGETLB		0x0004U
+/* not executable and sealed to prevent changing to executable. */
+#define MFD_NOEXEC_SEAL		0x0008U
+/* executable */
+#define MFD_EXEC		0x0010U
+
+/*
+ * Huge page size encoding when MFD_HUGETLB is specified, and a huge page
+ * size other than the default is desired.  See hugetlb_encode.h.
+ * All known huge page size encodings are provided here.  It is the
+ * responsibility of the application to know which sizes are supported on
+ * the running system.  See mmap(2) man page for details.
+ */
+#define MFD_HUGE_SHIFT	HUGETLB_FLAG_ENCODE_SHIFT
+#define MFD_HUGE_MASK	HUGETLB_FLAG_ENCODE_MASK
+
+#define MFD_HUGE_64KB	HUGETLB_FLAG_ENCODE_64KB
+#define MFD_HUGE_512KB	HUGETLB_FLAG_ENCODE_512KB
+#define MFD_HUGE_1MB	HUGETLB_FLAG_ENCODE_1MB
+#define MFD_HUGE_2MB	HUGETLB_FLAG_ENCODE_2MB
+#define MFD_HUGE_8MB	HUGETLB_FLAG_ENCODE_8MB
+#define MFD_HUGE_16MB	HUGETLB_FLAG_ENCODE_16MB
+#define MFD_HUGE_32MB	HUGETLB_FLAG_ENCODE_32MB
+#define MFD_HUGE_256MB	HUGETLB_FLAG_ENCODE_256MB
+#define MFD_HUGE_512MB	HUGETLB_FLAG_ENCODE_512MB
+#define MFD_HUGE_1GB	HUGETLB_FLAG_ENCODE_1GB
+#define MFD_HUGE_2GB	HUGETLB_FLAG_ENCODE_2GB
+#define MFD_HUGE_16GB	HUGETLB_FLAG_ENCODE_16GB
+
+#endif /* _LINUX_MEMFD_H */
diff --git a/linux-headers/linux/nvme_ioctl.h b/linux-headers/linux/nvme_ioctl.h
new file mode 100644
index 0000000000..f8df31dbc4
--- /dev/null
+++ b/linux-headers/linux/nvme_ioctl.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Definitions for the NVM Express ioctl interface
+ * Copyright (c) 2011-2014, Intel Corporation.
+ */
+
+#ifndef _LINUX_NVME_IOCTL_H
+#define _LINUX_NVME_IOCTL_H
+
+#include <linux/types.h>
+
+struct nvme_user_io {
+	__u8	opcode;
+	__u8	flags;
+	__u16	control;
+	__u16	nblocks;
+	__u16	rsvd;
+	__u64	metadata;
+	__u64	addr;
+	__u64	slba;
+	__u32	dsmgmt;
+	__u32	reftag;
+	__u16	apptag;
+	__u16	appmask;
+};
+
+struct nvme_passthru_cmd {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	__u32	data_len;
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32	result;
+};
+
+struct nvme_passthru_cmd64 {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	union {
+		__u32	data_len; /* for non-vectored io */
+		__u32	vec_cnt; /* for vectored io */
+	};
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32   rsvd2;
+	__u64	result;
+};
+
+/* same as struct nvme_passthru_cmd64, minus the 8b result field */
+struct nvme_uring_cmd {
+	__u8	opcode;
+	__u8	flags;
+	__u16	rsvd1;
+	__u32	nsid;
+	__u32	cdw2;
+	__u32	cdw3;
+	__u64	metadata;
+	__u64	addr;
+	__u32	metadata_len;
+	__u32	data_len;
+	__u32	cdw10;
+	__u32	cdw11;
+	__u32	cdw12;
+	__u32	cdw13;
+	__u32	cdw14;
+	__u32	cdw15;
+	__u32	timeout_ms;
+	__u32   rsvd2;
+};
+
+#define nvme_admin_cmd nvme_passthru_cmd
+
+#define NVME_IOCTL_ID		_IO('N', 0x40)
+#define NVME_IOCTL_ADMIN_CMD	_IOWR('N', 0x41, struct nvme_admin_cmd)
+#define NVME_IOCTL_SUBMIT_IO	_IOW('N', 0x42, struct nvme_user_io)
+#define NVME_IOCTL_IO_CMD	_IOWR('N', 0x43, struct nvme_passthru_cmd)
+#define NVME_IOCTL_RESET	_IO('N', 0x44)
+#define NVME_IOCTL_SUBSYS_RESET	_IO('N', 0x45)
+#define NVME_IOCTL_RESCAN	_IO('N', 0x46)
+#define NVME_IOCTL_ADMIN64_CMD	_IOWR('N', 0x47, struct nvme_passthru_cmd64)
+#define NVME_IOCTL_IO64_CMD	_IOWR('N', 0x48, struct nvme_passthru_cmd64)
+#define NVME_IOCTL_IO64_CMD_VEC	_IOWR('N', 0x49, struct nvme_passthru_cmd64)
+
+/* io_uring async commands: */
+#define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
+#define NVME_URING_CMD_IO_VEC	_IOWR('N', 0x81, struct nvme_uring_cmd)
+#define NVME_URING_CMD_ADMIN	_IOWR('N', 0x82, struct nvme_uring_cmd)
+#define NVME_URING_CMD_ADMIN_VEC _IOWR('N', 0x83, struct nvme_uring_cmd)
+
+#endif /* _LINUX_NVME_IOCTL_H */
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index c59692ce0b..4a534edbdc 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -49,7 +49,11 @@
 /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
 #define VFIO_UNMAP_ALL			9
 
-/* Supports the vaddr flag for DMA map and unmap */
+/*
+ * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
+ * devices, so this capability is subject to change as groups are added or
+ * removed.
+ */
 #define VFIO_UPDATE_VADDR		10
 
 /*
@@ -1343,8 +1347,7 @@ struct vfio_iommu_type1_info_dma_avail {
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
  *
- * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
- * unblock translation of host virtual addresses in the iova range.  The vaddr
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
  * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
  * maintain memory consistency within the user application, the updated vaddr
  * must address the same memory object as originally mapped.  Failure to do so
@@ -1395,9 +1398,9 @@ struct vfio_bitmap {
  * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
  *
  * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
- * virtual addresses in the iova range.  Tasks that attempt to translate an
- * iova's vaddr will block.  DMA to already-mapped pages continues.  This
- * cannot be combined with the get-dirty-bitmap flag.
+ * virtual addresses in the iova range.  DMA to already-mapped pages continues.
+ * Groups may not be added to the container while any addresses are invalid.
+ * This cannot be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
diff --git a/linux-headers/linux/vhost.h b/linux-headers/linux/vhost.h
index f9f115a7c7..92e1b700b5 100644
--- a/linux-headers/linux/vhost.h
+++ b/linux-headers/linux/vhost.h
@@ -180,4 +180,12 @@
  */
 #define VHOST_VDPA_SUSPEND		_IO(VHOST_VIRTIO, 0x7D)
 
+/* Resume a device so it can resume processing virtqueue requests
+ *
+ * After the return of this ioctl the device will have restored all the
+ * necessary states and it is fully operational to continue processing the
+ * virtqueue descriptors.
+ */
+#define VHOST_VDPA_RESUME		_IO(VHOST_VIRTIO, 0x7E)
+
 #endif
-- 
2.40.0.348.gf938b09366-goog

