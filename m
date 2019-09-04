Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1BBA8C8A
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbfIDQO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:14:27 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2533 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731673AbfIDQO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613666; x=1599149666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DN6BRXwjXvdAEUtL4pmEIG/OkLtWZNmK0r14sAMxDWg=;
  b=Ut/zUCkreQVo6A0Be5k1gjxa6/2CPLRvy8lJng9e8HW2EPyYK73erxkR
   YY/eS2PaOu+qADw5ZvM/y1l/+AOM1rLLp8DZKyt+4rQJ9O9mWICwvE1lF
   XK6vP4MaXL2+qr3W1kTPoZzPLqCriFqSdec26fhjSc5l2DtBHpoowfvxZ
   2aX9B9LJ0Hv89ohsJEXkTcgchhAANvFOjdue4gVNz2/jz+EDsdgEiigUI
   MlexgDjW9QsEXYTaHlcmcj2TiFyylITY+b6Bet3GXE0ysGRgm4w1unD/l
   mx1CD7bE3QzW7j3MwF2Gqr1g0rT5CD1ZmSe7MC9qbO53i59aWBr977P0r
   w==;
IronPort-SDR: UBXSs77zFhJeufHK7psThMjuhGrkmLPOyRqmJj1dDpltjKeQMFKzjmAV4VCzlNnusTCdHpJt8K
 qyV+ROJXmtpzzkdjOxPpgPtYiNNuG8wUUKNUgUiPZiL/XwUoutakHaf7JGC9lpAHghbH2cgp7h
 Z0RjDmeSXPeVIe53yJb+6WV547mEHa5/mIKJgwVB1fnrS/OOp2imekkBAPXuecxrv2TRXAzGET
 JJjlGnpAlGqW9kmDZ27bdQXDfyFK4ptow5LOGRhEEdRgBVPUfFqbmV6vQ2oAq7pgDX8aZjrT74
 4Eo=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="118323841"
Received: from mail-sn1nam01lp2052.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.52])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:14:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfkT5mFMpxujvSbSLl+UWTfyA3TMuTAA52vV6bzJjm0XwrKoSnwLDjNByECAm5UrnnXDA5qfUTKjOU1b3anLu1LKy+EPc4scuFTNWOTOIJCvaHExOCOu3W6EeATPEVX2RJMlPBkRG4zEIZjFXO1ZGoMG1tOrT2EmCL+GYlT8tvjHH+D7qDvJxuO1wX5smhObq1O0OZcnR8s5c2Zhytdt87pH1Mc/kqxUWonZNSLPKmBvyF5j3WUcRd/w+Rk8tzPncmXn6VRrZJO3oWFs8ZYItChCwo1SZOjaJiRmokVbXNY47EURROOoyTEYMJPhKOV9QbQSYs57fLC67l6JBeKiHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlExK4GI7KPjXYte+HD78yOVyZFnrfSi5vtYaZEBg70=;
 b=HKcDsSaO/2ekgrXsK0ODSfRY/ydRhEh+XUdU6v0wlYLSYW9tUAqHD+YAo6jqFohVLJEV+CZKTW3wmw3gOQoOrxVIgGhDBJ5kH4csQ3EvUu8JAkTR1+f7ztB1Ec97XJ0a84hDMt2JKq7hXCG/U8NMkh2D0JjeG4vV3DSLjFadponl/f3UTzJeF/Cz3HT+MwBTdFFbrt4MgMMyrwYqArdwPO8dHEfMBVw85z6nXhntJn+bXQZoRCUZxeXdkKFDPrcBz9VHVG8EW/4V7/KR5blwcPukyawQR7bWK+tEgSYDKvSx/n9ech/OpIsC+J8KeCn3i1m0KH6c++WYcGMSQ6WMbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlExK4GI7KPjXYte+HD78yOVyZFnrfSi5vtYaZEBg70=;
 b=d2hw7/kQ85RxvqXlwU+nKQiRN+bUKjfcvTFeT14Abn165mmqAQIs0LjwKj3HAFPeJQMqhayMRaXPCqXMiTl+TA4bxbxCh7W0n625ptZZF/w1hoj0qQ9pSgVN+96TKDC4JIVQvrBB1YuYODdHiAvR3gFNI/+5g0JsHLywzJgcFsI=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:14:22 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:14:22 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v7 05/21] RISC-V: Add initial skeletal KVM support
Thread-Topic: [PATCH v7 05/21] RISC-V: Add initial skeletal KVM support
Thread-Index: AQHVYzvPhDMqwAcG0ESUwE+6t6Xuig==
Date:   Wed, 4 Sep 2019 16:14:21 +0000
Message-ID: <20190904161245.111924-7-anup.patel@wdc.com>
References: <20190904161245.111924-1-anup.patel@wdc.com>
In-Reply-To: <20190904161245.111924-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::24)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.53.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ef50b11-e673-43eb-2262-08d73152f20d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB55047398A6925CD0CAC19F898DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:164;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(14444005)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(53946003)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(30864003)(66066001)(44832011)(4326008)(2906002)(446003)(81166006)(110136005)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ULPTdRh19Ol+U8Rpqt+sklaLn9hnlDcQhxfph3th1dVeANsMP5zBR0FbkKYO0JIgkYfpBr1cOIkMC9eTePVEWxiwYt6DOmAuyWFRpI7h0W13gFbJod2d74E8Q1bMJy83F4wDMzjRo7iSCrfXjkvuX2WNkOMaONNFGxHeL5SU4z9j2U2JWhxO1+q0X4WHDJWZ7WmD8EsPQoTnSufYImgBP+VSl39YaTyUpj8TAmprRh3WUARq63WpI1QqQj14qmj4m7P73TQeN/crvzIn7UILqmw/HylSrn9X0XRVWkt05wLwc9t6NYNSV5wbgaOWKkG8Enfse79jIBcujQ8eccaWVDq8WpPNyarB2DopnkumHBpqTRNglGoU+jeqA8RDlwaISX202EVoMawj9YVz5bJiMgKffeVu7BEA8L5uXBAMfSg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef50b11-e673-43eb-2262-08d73152f20d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:14:21.8858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r6u0wq/TF0pmMjsYm2pJGz8RIUr5Dad6OHyEK9Y8JDpgR/hYc1Gj+KNQpFu1lONvVPmDVnRNleBzw3DNBgQs0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds initial skeletal KVM RISC-V support which has:
1. A simple implementation of arch specific VM functions
   except kvm_vm_ioctl_get_dirty_log() which will implemeted
   in-future as part of stage2 page loging.
2. Stubs of required arch specific VCPU functions except
   kvm_arch_vcpu_ioctl_run() which is semi-complete and
   extended by subsequent patches.
3. Stubs for required arch specific stage2 MMU functions.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/Kconfig                |   2 +
 arch/riscv/Makefile               |   2 +
 arch/riscv/include/asm/kvm_host.h |  81 ++++++++
 arch/riscv/include/uapi/asm/kvm.h |  47 +++++
 arch/riscv/kvm/Kconfig            |  33 ++++
 arch/riscv/kvm/Makefile           |  13 ++
 arch/riscv/kvm/main.c             |  80 ++++++++
 arch/riscv/kvm/mmu.c              |  83 ++++++++
 arch/riscv/kvm/vcpu.c             | 312 ++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c        |  35 ++++
 arch/riscv/kvm/vm.c               |  79 ++++++++
 11 files changed, 767 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_host.h
 create mode 100644 arch/riscv/include/uapi/asm/kvm.h
 create mode 100644 arch/riscv/kvm/Kconfig
 create mode 100644 arch/riscv/kvm/Makefile
 create mode 100644 arch/riscv/kvm/main.c
 create mode 100644 arch/riscv/kvm/mmu.c
 create mode 100644 arch/riscv/kvm/vcpu.c
 create mode 100644 arch/riscv/kvm/vcpu_exit.c
 create mode 100644 arch/riscv/kvm/vm.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 83e48e2fbd4a..9ba340713b8a 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -290,3 +290,5 @@ menu "Power management options"
 source "kernel/power/Kconfig"
=20
 endmenu
+
+source "arch/riscv/kvm/Kconfig"
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 7a117be8297c..9f4f418978b1 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -74,6 +74,8 @@ head-y :=3D arch/riscv/kernel/head.o
=20
 core-y +=3D arch/riscv/kernel/ arch/riscv/mm/ arch/riscv/net/
=20
+core-$(CONFIG_KVM) +=3D arch/riscv/kvm/
+
 libs-y +=3D arch/riscv/lib/
=20
 PHONY +=3D vdso_install
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
new file mode 100644
index 000000000000..9459709656be
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __RISCV_KVM_HOST_H__
+#define __RISCV_KVM_HOST_H__
+
+#include <linux/types.h>
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
+
+#ifdef CONFIG_64BIT
+#define KVM_MAX_VCPUS			(1U << 16)
+#else
+#define KVM_MAX_VCPUS			(1U << 9)
+#endif
+
+#define KVM_USER_MEM_SLOTS		512
+#define KVM_HALT_POLL_NS_DEFAULT	500000
+
+#define KVM_VCPU_MAX_FEATURES		0
+
+#define KVM_REQ_SLEEP \
+	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+
+struct kvm_vm_stat {
+	ulong remote_tlb_flush;
+};
+
+struct kvm_vcpu_stat {
+	u64 halt_successful_poll;
+	u64 halt_attempted_poll;
+	u64 halt_poll_invalid;
+	u64 halt_wakeup;
+	u64 ecall_exit_stat;
+	u64 wfi_exit_stat;
+	u64 mmio_exit_user;
+	u64 mmio_exit_kernel;
+	u64 exits;
+};
+
+struct kvm_arch_memory_slot {
+};
+
+struct kvm_arch {
+	/* stage2 page table */
+	pgd_t *pgd;
+	phys_addr_t pgd_phys;
+};
+
+struct kvm_vcpu_arch {
+	/* Don't run the VCPU (blocked) */
+	bool pause;
+
+	/* SRCU lock index for in-kernel run loop */
+	int srcu_idx;
+};
+
+static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
+
+void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
+int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
+void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
+void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
+
+int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)=
;
+int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			unsigned long scause, unsigned long stval);
+
+static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) =
{}
+
+#endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/as=
m/kvm.h
new file mode 100644
index 000000000000..d15875818b6e
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __LINUX_KVM_RISCV_H
+#define __LINUX_KVM_RISCV_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#define __KVM_HAVE_READONLY_MEM
+
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+
+/* for KVM_GET_REGS and KVM_SET_REGS */
+struct kvm_regs {
+};
+
+/* for KVM_GET_FPU and KVM_SET_FPU */
+struct kvm_fpu {
+};
+
+/* KVM Debug exit structure */
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
+/* definition of registers in kvm_run */
+struct kvm_sync_regs {
+};
+
+/* dummy definition */
+struct kvm_sregs {
+};
+
+#endif
+
+#endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
new file mode 100644
index 000000000000..35fd30d0e432
--- /dev/null
+++ b/arch/riscv/kvm/Kconfig
@@ -0,0 +1,33 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# KVM configuration
+#
+
+source "virt/kvm/Kconfig"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	help
+	  Say Y here to get to see options for using your Linux host to run
+	  other operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on OF
+	select PREEMPT_NOTIFIERS
+	select ANON_INODES
+	select KVM_MMIO
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select SRCU
+	help
+	  Support hosting virtualized guest machines.
+
+	  If unsure, say N.
+
+endif # VIRTUALIZATION
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
new file mode 100644
index 000000000000..37b5a59d4f4f
--- /dev/null
+++ b/arch/riscv/kvm/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for RISC-V KVM support
+#
+
+common-objs-y =3D $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmi=
o.o)
+
+ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
+
+kvm-objs :=3D $(common-objs-y)
+
+kvm-objs +=3D main.o vm.o mmu.o vcpu.o vcpu_exit.o
+
+obj-$(CONFIG_KVM)	+=3D kvm.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
new file mode 100644
index 000000000000..e1ffe6d42f39
--- /dev/null
+++ b/arch/riscv/kvm/main.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/hwcap.h>
+
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_check_processor_compat(void)
+{
+	return 0;
+}
+
+int kvm_arch_hardware_setup(void)
+{
+	return 0;
+}
+
+int kvm_arch_hardware_enable(void)
+{
+	unsigned long hideleg, hedeleg;
+
+	hedeleg =3D 0;
+	hedeleg |=3D (1UL << EXC_INST_MISALIGNED);
+	hedeleg |=3D (1UL << EXC_BREAKPOINT);
+	hedeleg |=3D (1UL << EXC_SYSCALL);
+	hedeleg |=3D (1UL << EXC_INST_PAGE_FAULT);
+	hedeleg |=3D (1UL << EXC_LOAD_PAGE_FAULT);
+	hedeleg |=3D (1UL << EXC_STORE_PAGE_FAULT);
+	csr_write(CSR_HEDELEG, hedeleg);
+
+	hideleg =3D 0;
+	hideleg |=3D SIE_SSIE;
+	hideleg |=3D SIE_STIE;
+	hideleg |=3D SIE_SEIE;
+	csr_write(CSR_HIDELEG, hideleg);
+
+	return 0;
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	csr_write(CSR_HEDELEG, 0);
+	csr_write(CSR_HIDELEG, 0);
+}
+
+int kvm_arch_init(void *opaque)
+{
+	if (!riscv_isa_extension_available(NULL, h)) {
+		kvm_info("hypervisor extension not available\n");
+		return -ENODEV;
+	}
+
+	kvm_info("hypervisor extension available\n");
+
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+}
+
+static int riscv_kvm_init(void)
+{
+	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+}
+module_init(riscv_kvm_init);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
new file mode 100644
index 000000000000..04dd089b86ff
--- /dev/null
+++ b/arch/riscv/kvm/mmu.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/hugetlb.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/kvm_host.h>
+#include <linux/sched/signal.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
+			   struct kvm_memory_slot *dont)
+{
+}
+
+int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    unsigned long npages)
+{
+	return 0;
+}
+
+void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
+{
+}
+
+void kvm_arch_flush_shadow_all(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
+{
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				const struct kvm_userspace_memory_region *mem,
+				const struct kvm_memory_slot *old,
+				const struct kvm_memory_slot *new,
+				enum kvm_mr_change change)
+{
+	/* TODO: */
+}
+
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				struct kvm_memory_slot *memslot,
+				const struct kvm_userspace_memory_region *mem,
+				enum kvm_mr_change change)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
new file mode 100644
index 000000000000..48536cb0c8e7
--- /dev/null
+++ b/arch/riscv/kvm/vcpu.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/signal.h>
+#include <linux/fs.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/delay.h>
+#include <asm/hwcap.h>
+
+#define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCP=
U }
+
+struct kvm_stats_debugfs_item debugfs_entries[] =3D {
+	VCPU_STAT(ecall_exit_stat),
+	VCPU_STAT(wfi_exit_stat),
+	VCPU_STAT(mmio_exit_user),
+	VCPU_STAT(mmio_exit_kernel),
+	VCPU_STAT(exits),
+	{ NULL }
+};
+
+struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+{
+	/* TODO: */
+	return NULL;
+}
+
+int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return false;
+}
+
+bool kvm_arch_has_vcpu_debugfs(void)
+{
+	return false;
+}
+
+int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf=
)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+long kvm_arch_vcpu_async_ioctl(struct file *filp,
+			       unsigned int ioctl, unsigned long arg)
+{
+	/* TODO; */
+	return -ENOIOCTLCMD;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	/* TODO: */
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu=
)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu=
)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				  struct kvm_translation *tr)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *r=
egs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *r=
egs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	/* TODO; To be implemented later. */
+	return -EINVAL;
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	/* TODO: */
+
+	kvm_riscv_stage2_update_hgatp(vcpu);
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int ret;
+	unsigned long scause, stval;
+
+	vcpu->arch.srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+
+	/* Process MMIO value returned from user-space */
+	if (run->exit_reason =3D=3D KVM_EXIT_MMIO) {
+		ret =3D kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
+		if (ret) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			return ret;
+		}
+	}
+
+	if (run->immediate_exit) {
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+		return -EINTR;
+	}
+
+	vcpu_load(vcpu);
+
+	kvm_sigset_activate(vcpu);
+
+	ret =3D 1;
+	run->exit_reason =3D KVM_EXIT_UNKNOWN;
+	while (ret > 0) {
+		/* Check conditions before entering the guest */
+		cond_resched();
+
+		kvm_riscv_check_vcpu_requests(vcpu);
+
+		preempt_disable();
+
+		local_irq_disable();
+
+		/*
+		 * Exit if we have a signal pending so that we can deliver
+		 * the signal to user space.
+		 */
+		if (signal_pending(current)) {
+			ret =3D -EINTR;
+			run->exit_reason =3D KVM_EXIT_INTR;
+		}
+
+		/*
+		 * Ensure we set mode to IN_GUEST_MODE after we disable
+		 * interrupts and before the final VCPU requests check.
+		 * See the comment in kvm_vcpu_exiting_guest_mode() and
+		 * Documentation/virtual/kvm/vcpu-requests.rst
+		 */
+		vcpu->mode =3D IN_GUEST_MODE;
+
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+		smp_mb__after_srcu_read_unlock();
+
+		if (ret <=3D 0 ||
+		    kvm_request_pending(vcpu)) {
+			vcpu->mode =3D OUTSIDE_GUEST_MODE;
+			local_irq_enable();
+			preempt_enable();
+			vcpu->arch.srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+			continue;
+		}
+
+		guest_enter_irqoff();
+
+		__kvm_riscv_switch_to(&vcpu->arch);
+
+		vcpu->mode =3D OUTSIDE_GUEST_MODE;
+		vcpu->stat.exits++;
+
+		/* Save SCAUSE and STVAL because we might get an interrupt
+		 * between __kvm_riscv_switch_to() and local_irq_enable()
+		 * which can potentially overwrite SCAUSE and STVAL.
+		 */
+		scause =3D csr_read(CSR_SCAUSE);
+		stval =3D csr_read(CSR_STVAL);
+
+		/*
+		 * We may have taken a host interrupt in VS/VU-mode (i.e.
+		 * while executing the guest). This interrupt is still
+		 * pending, as we haven't serviced it yet!
+		 *
+		 * We're now back in HS-mode with interrupts disabled
+		 * so enabling the interrupts now will have the effect
+		 * of taking the interrupt again, in HS-mode this time.
+		 */
+		local_irq_enable();
+
+		/*
+		 * We do local_irq_enable() before calling guest_exit() so
+		 * that if a timer interrupt hits while running the guest
+		 * we account that tick as being spent in the guest. We
+		 * enable preemption after calling guest_exit() so that if
+		 * we get preempted we make sure ticks after that is not
+		 * counted as guest time.
+		 */
+		guest_exit();
+
+		preempt_enable();
+
+		vcpu->arch.srcu_idx =3D srcu_read_lock(&vcpu->kvm->srcu);
+
+		ret =3D kvm_riscv_vcpu_exit(vcpu, run, scause, stval);
+	}
+
+	kvm_sigset_deactivate(vcpu);
+
+	vcpu_put(vcpu);
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+
+	return ret;
+}
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
new file mode 100644
index 000000000000..e4d7c8f0807a
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+
+/**
+ * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulat=
ion
+ *			     or in-kernel IO emulation
+ *
+ * @vcpu: The VCPU pointer
+ * @run:  The VCPU run struct containing the mmio data
+ */
+int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	/* TODO: */
+	return 0;
+}
+
+/*
+ * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
+ * proper exit to userspace.
+ */
+int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			unsigned long scause, unsigned long stval)
+{
+	/* TODO: */
+	return 0;
+}
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
new file mode 100644
index 000000000000..ac0211820521
--- /dev/null
+++ b/arch/riscv/kvm/vm.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_host.h>
+
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	/* TODO: To be added later. */
+	return -ENOTSUPP;
+}
+
+int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
+{
+	int r;
+
+	r =3D kvm_riscv_stage2_alloc_pgd(kvm);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	int i;
+
+	for (i =3D 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
+			kvm->vcpus[i] =3D NULL;
+		}
+	}
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_DEVICE_CTRL:
+	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_MP_STATE:
+	case KVM_CAP_IMMEDIATE_EXIT:
+		r =3D 1;
+		break;
+	case KVM_CAP_NR_VCPUS:
+		r =3D num_online_cpus();
+		break;
+	case KVM_CAP_MAX_VCPUS:
+		r =3D KVM_MAX_VCPUS;
+		break;
+	case KVM_CAP_NR_MEMSLOTS:
+		r =3D KVM_USER_MEM_SLOTS;
+		break;
+	default:
+		r =3D 0;
+		break;
+	}
+
+	return r;
+}
+
+long kvm_arch_vm_ioctl(struct file *filp,
+		       unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
--=20
2.17.1

