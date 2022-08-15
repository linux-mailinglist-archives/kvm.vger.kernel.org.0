Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8C9592D39
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242414AbiHOKOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 06:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242545AbiHOKNu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 06:13:50 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474E623BF9
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:40 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so6367624pjk.1
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=oAq6o0jFtqV3Z32Di7VJjVh+El5W8i0/stoBlm7/lCs=;
        b=ph8Ui4daxtmuQgm/V3RnXn7BZv4Cc8CTiQos4otj2w0Mif4dR6pWK+LWiS1OLD/5bk
         7hMTLGbb3qCzIch/9LFMeQDnSXFanG8YvBYp2j4iXLnfQE3itCAduaPJuaRmJxcJicSd
         NySKW/G4vysIABptWMbGnf6/Kd2R101mB//wobotl/zFN75RYxy6hxSxzSgzuuanVdfN
         sw0T9nz0neHVMkyZoImfy3Mxj2kk+oNYBb4cqwroAFecNSFaIt9JezmXpcz4mo4arPQ7
         NDns8NwCVzPuxBYUn5gGFFYhP8JgX1wCMmuP6MuactLcJD12qs8HecopliyXmJAueefu
         vDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=oAq6o0jFtqV3Z32Di7VJjVh+El5W8i0/stoBlm7/lCs=;
        b=nRvOFM8NdGuQ5asZpkGyR03uTIz3e7Fsy/U3ePVlysl4FiCO2NToxcaipa2RJD1Qa8
         4QZXJqHZU369bohFQ6u7Q2Gt6OciwxLfhtopz6cy4YklVchCunsGEQZDHGjxs23OZdxo
         fL05zdPrEgYzdOuoQEnNwamD7VX/ogR+6uKUW781yRJtAifD1sgpwC7M9rxEq1gLkzda
         J/49WykQfbC7L01FUqe1BfaWKwvtiY0NkMwzO1itIWE0ifEQdnpdLr5PX2uZy0Dm+WlO
         PvzzmGQ+rM3UFpqESJJTg5vmuAVndSRcH/mhvOmA+wTLDqXNBIoe+k/w0Ugk8nFblksW
         KSQA==
X-Gm-Message-State: ACgBeo1W/F3f2M4BoXhMOdhggD3FDnrLWmVx2cV0USnyW3ZikhpN9a98
        cZl21u+QRWiagoRfRgXBw60CxA==
X-Google-Smtp-Source: AA6agR6GUGkgeL6fjqK6d4JNckN6bf2vXB/2uri4aqb6qVtVU6k+rTl8k6aiOw2+s27xN+PZJkAxqw==
X-Received: by 2002:a17:902:e742:b0:16f:2ef:77d8 with SMTP id p2-20020a170902e74200b0016f02ef77d8mr16138906plf.32.1660558419474;
        Mon, 15 Aug 2022 03:13:39 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.84.46])
        by smtp.gmail.com with ESMTPSA id i190-20020a6254c7000000b0052d4f2e2f6asm6267437pfb.119.2022.08.15.03.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 03:13:38 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 1/5] Update UAPI headers based on Linux-6.0-rc1
Date:   Mon, 15 Aug 2022 15:43:21 +0530
Message-Id: <20220815101325.477694-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220815101325.477694-1-apatel@ventanamicro.com>
References: <20220815101325.477694-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We update all UAPI headers based on Linux-6.0-rc1 so that we can
use latest features.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arm/aarch64/include/asm/kvm.h |  36 +++++++
 include/linux/kvm.h           | 181 ++++++++++++++++++++++++++++++++--
 include/linux/virtio_9p.h     |   2 +-
 include/linux/virtio_config.h |   7 +-
 include/linux/virtio_ids.h    |  14 +--
 include/linux/virtio_net.h    |  34 ++++++-
 include/linux/virtio_pci.h    |   2 +
 riscv/include/asm/kvm.h       |  22 +++++
 x86/include/asm/kvm.h         |  33 ++++---
 9 files changed, 301 insertions(+), 30 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index c1b6ddc..3bb1343 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -139,8 +139,10 @@ struct kvm_guest_debug_arch {
 	__u64 dbg_wvr[KVM_ARM_MAX_DBG_REGS];
 };
 
+#define KVM_DEBUG_ARCH_HSR_HIGH_VALID	(1 << 0)
 struct kvm_debug_exit_arch {
 	__u32 hsr;
+	__u32 hsr_high;	/* ESR_EL2[61:32] */
 	__u64 far;	/* used for watchpoints */
 };
 
@@ -332,6 +334,40 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_ARM64_SVE_VLS_WORDS	\
 	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
 
+/* Bitmap feature firmware registers */
+#define KVM_REG_ARM_FW_FEAT_BMAP		(0x0016 << KVM_REG_ARM_COPROC_SHIFT)
+#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
+						KVM_REG_ARM_FW_FEAT_BMAP |	\
+						((r) & 0xffff))
+
+#define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
+
+enum {
+	KVM_REG_ARM_STD_BIT_TRNG_V1_0	= 0,
+#ifdef __KERNEL__
+	KVM_REG_ARM_STD_BMAP_BIT_COUNT,
+#endif
+};
+
+#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(1)
+
+enum {
+	KVM_REG_ARM_STD_HYP_BIT_PV_TIME	= 0,
+#ifdef __KERNEL__
+	KVM_REG_ARM_STD_HYP_BMAP_BIT_COUNT,
+#endif
+};
+
+#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_FEAT_BMAP_REG(2)
+
+enum {
+	KVM_REG_ARM_VENDOR_HYP_BIT_FUNC_FEAT	= 0,
+	KVM_REG_ARM_VENDOR_HYP_BIT_PTP		= 1,
+#ifdef __KERNEL__
+	KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_COUNT,
+#endif
+};
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 91a6fe4..eed0315 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -270,6 +270,8 @@ struct kvm_xen_exit {
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
 #define KVM_EXIT_RISCV_SBI        35
+#define KVM_EXIT_RISCV_CSR        36
+#define KVM_EXIT_NOTIFY           37
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -444,8 +446,17 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_WAKEUP         4
+#define KVM_SYSTEM_EVENT_SUSPEND        5
+#define KVM_SYSTEM_EVENT_SEV_TERM       6
 			__u32 type;
-			__u64 flags;
+			__u32 ndata;
+			union {
+#ifndef __KERNEL__
+				__u64 flags;
+#endif
+				__u64 data[16];
+			};
 		} system_event;
 		/* KVM_EXIT_S390_STSI */
 		struct {
@@ -487,6 +498,18 @@ struct kvm_run {
 			unsigned long args[6];
 			unsigned long ret[2];
 		} riscv_sbi;
+		/* KVM_EXIT_RISCV_CSR */
+		struct {
+			unsigned long csr_num;
+			unsigned long new_value;
+			unsigned long write_mask;
+			unsigned long ret_value;
+		} riscv_csr;
+		/* KVM_EXIT_NOTIFY */
+		struct {
+#define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
+			__u32 flags;
+		} notify;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -533,7 +556,7 @@ struct kvm_coalesced_mmio {
 
 struct kvm_coalesced_mmio_ring {
 	__u32 first, last;
-	struct kvm_coalesced_mmio coalesced_mmio[0];
+	struct kvm_coalesced_mmio coalesced_mmio[];
 };
 
 #define KVM_COALESCED_MMIO_MAX \
@@ -612,7 +635,7 @@ struct kvm_clear_dirty_log {
 /* for KVM_SET_SIGNAL_MASK */
 struct kvm_signal_mask {
 	__u32 len;
-	__u8  sigset[0];
+	__u8  sigset[];
 };
 
 /* for KVM_TPR_ACCESS_REPORTING */
@@ -640,6 +663,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
 #define KVM_MP_STATE_AP_RESET_HOLD     9
+#define KVM_MP_STATE_SUSPENDED         10
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -1144,6 +1168,15 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_MEM_OP_EXTENSION 211
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
+#define KVM_CAP_VM_TSC_CONTROL 214
+#define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 216
+#define KVM_CAP_S390_PROTECTED_DUMP 217
+#define KVM_CAP_X86_TRIPLE_FAULT_EVENT 218
+#define KVM_CAP_X86_NOTIFY_VMEXIT 219
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
+#define KVM_CAP_S390_ZPCI_OP 221
+#define KVM_CAP_S390_CPU_TOPOLOGY 222
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1208,7 +1241,7 @@ struct kvm_irq_routing_entry {
 struct kvm_irq_routing {
 	__u32 nr;
 	__u32 flags;
-	struct kvm_irq_routing_entry entries[0];
+	struct kvm_irq_routing_entry entries[];
 };
 
 #endif
@@ -1232,6 +1265,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1327,7 +1361,7 @@ struct kvm_dirty_tlb {
 
 struct kvm_reg_list {
 	__u64 n; /* number of regs */
-	__u64 reg[0];
+	__u64 reg[];
 };
 
 struct kvm_one_reg {
@@ -1470,7 +1504,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
-/* Available with KVM_CAP_TSC_CONTROL */
+/* Available with KVM_CAP_TSC_CONTROL for a vCPU, or with
+*  KVM_CAP_VM_TSC_CONTROL to set defaults for a VM */
 #define KVM_SET_TSC_KHZ           _IO(KVMIO,  0xa2)
 #define KVM_GET_TSC_KHZ           _IO(KVMIO,  0xa3)
 /* Available with KVM_CAP_PCI_2_3 */
@@ -1645,6 +1680,55 @@ struct kvm_s390_pv_unp {
 	__u64 tweak;
 };
 
+enum pv_cmd_dmp_id {
+	KVM_PV_DUMP_INIT,
+	KVM_PV_DUMP_CONFIG_STOR_STATE,
+	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
+};
+
+struct kvm_s390_pv_dmp {
+	__u64 subcmd;
+	__u64 buff_addr;
+	__u64 buff_len;
+	__u64 gaddr;		/* For dump storage state */
+	__u64 reserved[4];
+};
+
+enum pv_cmd_info_id {
+	KVM_PV_INFO_VM,
+	KVM_PV_INFO_DUMP,
+};
+
+struct kvm_s390_pv_info_dump {
+	__u64 dump_cpu_buffer_len;
+	__u64 dump_config_mem_buffer_per_1m;
+	__u64 dump_config_finalize_len;
+};
+
+struct kvm_s390_pv_info_vm {
+	__u64 inst_calls_list[4];
+	__u64 max_cpus;
+	__u64 max_guests;
+	__u64 max_guest_addr;
+	__u64 feature_indication;
+};
+
+struct kvm_s390_pv_info_header {
+	__u32 id;
+	__u32 len_max;
+	__u32 len_written;
+	__u32 reserved;
+};
+
+struct kvm_s390_pv_info {
+	struct kvm_s390_pv_info_header header;
+	union {
+		struct kvm_s390_pv_info_dump dump;
+		struct kvm_s390_pv_info_vm vm;
+	};
+};
+
 enum pv_cmd_id {
 	KVM_PV_ENABLE,
 	KVM_PV_DISABLE,
@@ -1653,6 +1737,8 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
+	KVM_PV_DUMP,
 };
 
 struct kvm_pv_cmd {
@@ -1686,6 +1772,32 @@ struct kvm_xen_hvm_attr {
 		struct {
 			__u64 gfn;
 		} shared_info;
+		struct {
+			__u32 send_port;
+			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
+			__u32 flags;
+#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
+#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
+#define KVM_XEN_EVTCHN_RESET		(1 << 2)
+			/*
+			 * Events sent by the guest are either looped back to
+			 * the guest itself (potentially on a different port#)
+			 * or signalled via an eventfd.
+			 */
+			union {
+				struct {
+					__u32 port;
+					__u32 vcpu;
+					__u32 priority;
+				} port;
+				struct {
+					__u32 port; /* Zero for eventfd */
+					__s32 fd;
+				} eventfd;
+				__u32 padding[4];
+			} deliver;
+		} evtchn;
+		__u32 xen_version;
 		__u64 pad[8];
 	} u;
 };
@@ -1694,11 +1806,17 @@ struct kvm_xen_hvm_attr {
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
 #define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
+#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
 
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_HVM_EVTCHN_SEND	_IOW(KVMIO,  0xd0, struct kvm_irq_routing_xen_evtchn)
+
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
@@ -1716,6 +1834,13 @@ struct kvm_xen_vcpu_attr {
 			__u64 time_blocked;
 			__u64 time_offline;
 		} runstate;
+		__u32 vcpu_id;
+		struct {
+			__u32 port;
+			__u32 priority;
+			__u64 expires_ns;
+		} timer;
+		__u8 vector;
 	} u;
 };
 
@@ -1726,6 +1851,10 @@ struct kvm_xen_vcpu_attr {
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
 #define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
+#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
+#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
@@ -2025,7 +2154,8 @@ struct kvm_stats_header {
 #define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
 #define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
 #define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
-#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
+#define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_BOOLEAN
 
 #define KVM_STATS_BASE_SHIFT		8
 #define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
@@ -2060,4 +2190,41 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_XSAVE2 */
 #define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 
+/* Available with KVM_CAP_S390_PROTECTED_DUMP */
+#define KVM_S390_PV_CPU_COMMAND	_IOWR(KVMIO, 0xd0, struct kvm_pv_cmd)
+
+/* Available with KVM_CAP_X86_NOTIFY_VMEXIT */
+#define KVM_X86_NOTIFY_VMEXIT_ENABLED		(1ULL << 0)
+#define KVM_X86_NOTIFY_VMEXIT_USER		(1ULL << 1)
+
+/* Available with KVM_CAP_S390_ZPCI_OP */
+#define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
+
+struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;               /* target device */
+	__u8  op;               /* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;      /* Guest addr of interrupt bit vector */
+			__u64 sb;       /* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;      /* Number of interrupts */
+			__u8 isc;       /* Guest interrupt subclass */
+			__u8 sbo;       /* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN                0
+#define KVM_S390_ZPCIOP_DEREG_AEN      1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
+
 #endif /* __LINUX_KVM_H */
diff --git a/include/linux/virtio_9p.h b/include/linux/virtio_9p.h
index 4410474..374b68f 100644
--- a/include/linux/virtio_9p.h
+++ b/include/linux/virtio_9p.h
@@ -38,7 +38,7 @@ struct virtio_9p_config {
 	/* length of the tag name */
 	__virtio16 tag_len;
 	/* non-NULL terminated tag name */
-	__u8 tag[0];
+	__u8 tag[];
 } __attribute__((packed));
 
 #endif /* _LINUX_VIRTIO_9P_H */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index f0fb0ae..3c05162 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		38
+#define VIRTIO_TRANSPORT_F_END		41
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -98,4 +98,9 @@
  * Does the device support Single Root I/O Virtualization?
  */
 #define VIRTIO_F_SR_IOV			37
+
+/*
+ * This feature indicates that the driver can reset a queue individually.
+ */
+#define VIRTIO_F_RING_RESET		40
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 80d76b7..7aa2eb7 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -73,12 +73,12 @@
  * Virtio Transitional IDs
  */
 
-#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
-#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
-#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
-#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
-#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
-#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
-#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
+#define VIRTIO_TRANS_ID_NET		0x1000 /* transitional virtio net */
+#define VIRTIO_TRANS_ID_BLOCK		0x1001 /* transitional virtio block */
+#define VIRTIO_TRANS_ID_BALLOON		0x1002 /* transitional virtio balloon */
+#define VIRTIO_TRANS_ID_CONSOLE		0x1003 /* transitional virtio console */
+#define VIRTIO_TRANS_ID_SCSI		0x1004 /* transitional virtio SCSI */
+#define VIRTIO_TRANS_ID_RNG		0x1005 /* transitional virtio rng */
+#define VIRTIO_TRANS_ID_9P		0x1009 /* transitional virtio 9p console */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 3f55a42..29ced55 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -56,7 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
-
+#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -355,4 +355,36 @@ struct virtio_net_hash_config {
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
 
+/*
+ * Control notifications coalescing.
+ *
+ * Request the device to change the notifications coalescing parameters.
+ *
+ * Available with the VIRTIO_NET_F_NOTF_COAL feature bit.
+ */
+#define VIRTIO_NET_CTRL_NOTF_COAL		6
+/*
+ * Set the tx-usecs/tx-max-packets patameters.
+ * tx-usecs - Maximum number of usecs to delay a TX notification.
+ * tx-max-packets - Maximum number of packets to send before a TX notification.
+ */
+struct virtio_net_ctrl_coal_tx {
+	__le32 tx_max_packets;
+	__le32 tx_usecs;
+};
+
+#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
+
+/*
+ * Set the rx-usecs/rx-max-packets patameters.
+ * rx-usecs - Maximum number of usecs to delay a RX notification.
+ * rx-max-frames - Maximum number of packets to receive before a RX notification.
+ */
+struct virtio_net_ctrl_coal_rx {
+	__le32 rx_max_packets;
+	__le32 rx_usecs;
+};
+
+#define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET		1
+
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index 3a86f36..f703afc 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -202,6 +202,8 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_PCI_COMMON_Q_AVAILHI	44
 #define VIRTIO_PCI_COMMON_Q_USEDLO	48
 #define VIRTIO_PCI_COMMON_Q_USEDHI	52
+#define VIRTIO_PCI_COMMON_Q_NDATA	56
+#define VIRTIO_PCI_COMMON_Q_RESET	58
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index f808ad1..7351417 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -82,6 +82,25 @@ struct kvm_riscv_timer {
 	__u64 state;
 };
 
+/*
+ * ISA extension IDs specific to KVM. This is not the same as the host ISA
+ * extension IDs as that is internal to the host and should not be exposed
+ * to the guest. This should always be contiguous to keep the mapping simple
+ * in KVM implementation.
+ */
+enum KVM_RISCV_ISA_EXT_ID {
+	KVM_RISCV_ISA_EXT_A = 0,
+	KVM_RISCV_ISA_EXT_C,
+	KVM_RISCV_ISA_EXT_D,
+	KVM_RISCV_ISA_EXT_F,
+	KVM_RISCV_ISA_EXT_H,
+	KVM_RISCV_ISA_EXT_I,
+	KVM_RISCV_ISA_EXT_M,
+	KVM_RISCV_ISA_EXT_SVPBMT,
+	KVM_RISCV_ISA_EXT_SSTC,
+	KVM_RISCV_ISA_EXT_MAX,
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -123,6 +142,9 @@ struct kvm_riscv_timer {
 #define KVM_REG_RISCV_FP_D_REG(name)	\
 		(offsetof(struct __riscv_d_ext_state, name) / sizeof(__u64))
 
+/* ISA Extension registers are mapped as type 7 */
+#define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index bf6e960..46de10a 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -198,13 +198,13 @@ struct kvm_msrs {
 	__u32 nmsrs; /* number of msrs in entries */
 	__u32 pad;
 
-	struct kvm_msr_entry entries[0];
+	struct kvm_msr_entry entries[];
 };
 
 /* for KVM_GET_MSR_INDEX_LIST */
 struct kvm_msr_list {
 	__u32 nmsrs; /* number of msrs in entries */
-	__u32 indices[0];
+	__u32 indices[];
 };
 
 /* Maximum size of any access bitmap in bytes */
@@ -241,7 +241,7 @@ struct kvm_cpuid_entry {
 struct kvm_cpuid {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry entries[0];
+	struct kvm_cpuid_entry entries[];
 };
 
 struct kvm_cpuid_entry2 {
@@ -263,7 +263,7 @@ struct kvm_cpuid_entry2 {
 struct kvm_cpuid2 {
 	__u32 nent;
 	__u32 padding;
-	struct kvm_cpuid_entry2 entries[0];
+	struct kvm_cpuid_entry2 entries[];
 };
 
 /* for KVM_GET_PIT and KVM_SET_PIT */
@@ -306,7 +306,8 @@ struct kvm_pit_state {
 	struct kvm_pit_channel_state channels[3];
 };
 
-#define KVM_PIT_FLAGS_HPET_LEGACY  0x00000001
+#define KVM_PIT_FLAGS_HPET_LEGACY     0x00000001
+#define KVM_PIT_FLAGS_SPEAKER_DATA_ON 0x00000002
 
 struct kvm_pit_state2 {
 	struct kvm_pit_channel_state channels[3];
@@ -325,6 +326,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
+#define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -359,7 +361,10 @@ struct kvm_vcpu_events {
 		__u8 smm_inside_nmi;
 		__u8 latched_init;
 	} smi;
-	__u8 reserved[27];
+	struct {
+		__u8 pending;
+	} triple_fault;
+	__u8 reserved[26];
 	__u8 exception_has_payload;
 	__u64 exception_payload;
 };
@@ -389,7 +394,7 @@ struct kvm_xsave {
 	 * the contents of CPUID leaf 0xD on the host.
 	 */
 	__u32 region[1024];
-	__u32 extra[0];
+	__u32 extra[];
 };
 
 #define KVM_MAX_XCRS	16
@@ -428,11 +433,13 @@ struct kvm_sync_regs {
 	struct kvm_vcpu_events events;
 };
 
-#define KVM_X86_QUIRK_LINT0_REENABLED	   (1 << 0)
-#define KVM_X86_QUIRK_CD_NW_CLEARED	   (1 << 1)
-#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE	   (1 << 2)
-#define KVM_X86_QUIRK_OUT_7E_INC_RIP	   (1 << 3)
-#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
+#define KVM_X86_QUIRK_LINT0_REENABLED		(1 << 0)
+#define KVM_X86_QUIRK_CD_NW_CLEARED		(1 << 1)
+#define KVM_X86_QUIRK_LAPIC_MMIO_HOLE		(1 << 2)
+#define KVM_X86_QUIRK_OUT_7E_INC_RIP		(1 << 3)
+#define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT	(1 << 4)
+#define KVM_X86_QUIRK_FIX_HYPERCALL_INSN	(1 << 5)
+#define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
@@ -515,7 +522,7 @@ struct kvm_pmu_event_filter {
 	__u32 fixed_counter_bitmap;
 	__u32 flags;
 	__u32 pad[4];
-	__u64 events[0];
+	__u64 events[];
 };
 
 #define KVM_PMU_EVENT_ALLOW 0
-- 
2.34.1

