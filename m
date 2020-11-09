Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343BA2AB70E
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730028AbgKILeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:34:25 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:44538 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730009AbgKILeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921661; x=1636457661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=NJu9N/iQ773oJL4JYaBWpzXl/lb8cvH1l2me7w9PtQs=;
  b=f4/3I6B06eohVHDdVUv+35Gaq/LF1jwF475CKNB4c72KKmlDlNMhMzqs
   otSA+IPsHPk1kOgjJ4Dfo2LErT0d2FaRkTTLwrcda6GBtAxLorHjPwHjC
   Hv+adjOjLAiy/UK0eslKzVSWngbrSMzdwhYO2F+T50FYFGEar2l0fFxG9
   pUG68NV6X/DOKCsvY8KOL0S6fRE7KZpzwKXFY6J6Hu/SYnB8mP3ulfXr+
   ZaOvnzakKBxLdAFIlHYw5MNHbVg2yDnG/rHtLpDKOXCkL1NbsqlatSZTr
   yhItCPhdFcOUOV28sVaAj0Qc9O+TArx+3QkTwgsQ2GakGtBMhJ7YsAvDJ
   Q==;
IronPort-SDR: tRTtO1qmFEvYw1GYnHoZTqsMKdojcXckELMYG1ch77JSr01p3dtlBgNViFyJxDOccMFXMQ2LOJ
 n2tpX0zIfUhh4j+XkQVikKBYbI2NXMNDAYI6PR9kruPpKUq57r2UPIQS2eO+YpMUv/qFNlYSuh
 OvwNXlQyA0vXOUxihb1KaspklyfNLU4pYBRe0Utu71qcE+emzOzI4W5uWq7GOBs+zfGG+mITGf
 Uu8XYtz0Rpa0j5uDWuJxwKdgF2XVVcpIXzRHUX2CmrqREgXvYpxsLV09nBvQYIlCoVGlXOPv9f
 ir0=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="262186929"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:34:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdxyjW3jDlT4BmU7VZpxkhou+q3dJ1az8JLchEZwpBFkOtLIYL1S5Ld6c73xbcN/YZf6TiqtY253w/pbXrUmRoTIiuIBEI/yQLhiGR3qUOnFZoQwhNbJgIZ40oxY9ezOefLVG4yTTC4o0ghWTV8pyKoHSKxz3Y6pH/ZbHjO5EuI3Y0Jm/vjGD5got2n5vbOtYr/0xT/7UK+3qdq0JaSiw5eIVRL9AHdoXTaGXg4GT0AIQQmDzi5tdmb66jgbBgrtkfU62A0oCuYZK/buijkHwhmCpJ+EKjjTCwp1raealq0VoCg5N3nuygXKRij+XtDGAbvXsT25eN4SCZPyJXkZtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0xSyGEMsS5yNoqFz6yLwtHySdmmMcoVSaygeEXJNNk=;
 b=Dw85fkfqx3pkhoLbWlLjSm5PsEp9JRoLvV8wa3mebF5DMb/YDTaZxsgHbu8jDN6DSkJD0we9tl7y+H04b0ZschXMaL5aD6TQ7kE3RoB4DiCgDTgA2QUDpm+Wlu1sEEZbQBcJ0Q16yyQAwL0qGMo73NO1E79BpT+smxPnV3YyNarrG+nxyx16xXQnRrwZjOWkow+TdeoHHWO3sSPw/EUpzYVPWj7Rk1dHZngs95mY69+l2AxPeCL/T0mluLupPE/+zzc4wQvMWbi4QpoeK1BiMPI7tDcS0SoY7OMVHqfOwz8rNBMzc4HbivM6gJXTk3OV1lqKKN9zKHrw+5jC37Xghg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0xSyGEMsS5yNoqFz6yLwtHySdmmMcoVSaygeEXJNNk=;
 b=K9GCOVDr4Ux6asNMp4E5xRcajuNIKC0Is3fXFbneagYTN7bbJU+GaUIyo4K3dzz/UjgIPoETwAcwomCAHgENH9gsuSlo4okKvmBbhMAYsKxah2go1R/h8WNZJhMO+81fCGDu10T2Qn2RDgBbYXd3l8J7CekPOM0Fyu9zyvu626w=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:34:17 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:34:17 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v15 09/17] RISC-V: KVM: Implement VMID allocator
Date:   Mon,  9 Nov 2020 17:02:32 +0530
Message-Id: <20201109113240.3733496-10-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113240.3733496-1-anup.patel@wdc.com>
References: <20201109113240.3733496-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:34:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 63d3f23c-2f57-41e2-a384-08d884a36440
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB386697FAE84595C01B0FDFD18DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kt951RCtAtuWvjNcMG5JXPMi/PXCppN/Tfy3XWbcFciOU6UjPcOvKWOdGdzPXlg0avDPGR2/U3sTi3ZTYvrQVKGCM45xCn/VTc1LyBkUekpEOTisLag6q/TGzMScEVDGSk0TfSwt2iJIL7IzAVPn90EDHEiN6czzHZqYBRj0VuVOu7AKy7hSotSqe5VmzTmDqS8+w4sTBusBdIpvfEM0U/YH6oBHXQ3NcFh7ghnb1aVvBKAEsKiW/+z9OeGBubdmXKFPpoHqrxv5UIon2mBKYUK3xkKIEkI51NKMFhOeiZCMsqmF1oosnJQBh9/jtsig
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(7416002)(83380400001)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(110136005)(54906003)(5660300002)(52116002)(7696005)(956004)(30864003)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(6666004)(2906002)(36756003)(86362001)(8886007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nnLvncIjU+SEwU9DOODFc+BCSNDorc3flkWcScnd9z9Eey26trmMqlg2ICoLmzqcQn9e3OQKpb50hcYYLSiOwRGdFil/lJsrMVALklp6FNhdZciXfkHgDVB43Y8H6EZHhhJbiHULwlQrJPtXfLqWYkJVMSx7BFmJ739VVuDlwvYrFg/R99lwQ+MXFCEKVrJErj6zJbuXqD/WNNV6m7WOAUi69YM+0qBUJJ3MWhim4wUm9ESaCRrDfyHygNIfCI25yv9ebxRWA8mmV3Rh5UxXS6BtN+ucJIUVt/p7aP11NlPLAcJFaXCmSC0AHVCCuYU9VcNuCT51wxYORXiyB6pYOsxbuxmp0VQxw5RbimSOf/PrO88MZquzWCQhn3sMAM+1seuDVDqoGP8Aozup45gqsPDabD19bOFqTEKl8N+tTmEuCHRm+erf4nhVb2HAPrLw2EsBk6/nCFZgj9O3AYkYvnPY2hyEEsZfy+sO8h+AoDocMSgdZJpkUh/lbunkHHXDco8mvc0kyVsI0w6knAuWLWQsgsb+D/w+dGAJxnDiEVZor1OFdlD7r/BeazZY2WB2LWZyLSF53RsAnHF6RoSzxmxnc8SsY+a98UnPFKPmY+9jBRDguZ0px69Zh0E6qDX1Iu33PBCgsAVFfv01wBUgCA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d3f23c-2f57-41e2-a384-08d884a36440
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:34:17.1297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dVQGbsMdLRV0cHRWlPYFi6mgQIiT820hsm25e8QSGua2mUSiArL/Gi+gGlPYYJ9hMHt6fGQ47maEuFws7pjwWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement a simple VMID allocator for Guests/VMs which:
1. Detects number of VMID bits at boot-time
2. Uses atomic number to track VMID version and increments
   VMID version whenever we run-out of VMIDs
3. Flushes Guest TLBs on all host CPUs whenever we run-out
   of VMIDs
4. Force updates HW Stage2 VMID for each Guest VCPU whenever
   VMID changes using VCPU request KVM_REQ_UPDATE_HGATP

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  24 ++++++
 arch/riscv/kvm/Makefile           |   3 +-
 arch/riscv/kvm/main.c             |   4 +
 arch/riscv/kvm/tlb.S              |  74 ++++++++++++++++++
 arch/riscv/kvm/vcpu.c             |   9 +++
 arch/riscv/kvm/vm.c               |   6 ++
 arch/riscv/kvm/vmid.c             | 120 ++++++++++++++++++++++++++++++
 7 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vmid.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 47655fe2f4b9..08681e58c695 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+#define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
@@ -49,7 +50,19 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_vmid {
+	/*
+	 * Writes to vmid_version and vmid happen with vmid_lock held
+	 * whereas reads happen without any lock held.
+	 */
+	unsigned long vmid_version;
+	unsigned long vmid;
+};
+
 struct kvm_arch {
+	/* stage2 vmid */
+	struct kvm_vmid vmid;
+
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
@@ -180,6 +193,11 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long gpa, unsigned long vmid);
+void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
+void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
+void __kvm_riscv_hfence_gvma_all(void);
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva,
@@ -189,6 +207,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
 
+void kvm_riscv_stage2_vmid_detect(void);
+unsigned long kvm_riscv_stage2_vmid_bits(void);
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm);
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid);
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu);
+
 void __kvm_riscv_unpriv_trap(void);
 
 unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 54991cc55c00..b32f60edf48c 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,6 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
-kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 47926f0c175d..49a4941e3838 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -79,8 +79,12 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	kvm_riscv_stage2_vmid_detect();
+
 	kvm_info("hypervisor extension available\n");
 
+	kvm_info("VMID %ld bits available\n", kvm_riscv_stage2_vmid_bits());
+
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/tlb.S b/arch/riscv/kvm/tlb.S
new file mode 100644
index 000000000000..c858570f0856
--- /dev/null
+++ b/arch/riscv/kvm/tlb.S
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/linkage.h>
+#include <asm/asm.h>
+
+	.text
+	.altmacro
+	.option norelax
+
+	/*
+	 * Instruction encoding of hfence.gvma is:
+	 * HFENCE.GVMA rs1, rs2
+	 * HFENCE.GVMA zero, rs2
+	 * HFENCE.GVMA rs1
+	 * HFENCE.GVMA
+	 *
+	 * rs1!=zero and rs2!=zero ==> HFENCE.GVMA rs1, rs2
+	 * rs1==zero and rs2!=zero ==> HFENCE.GVMA zero, rs2
+	 * rs1!=zero and rs2==zero ==> HFENCE.GVMA rs1
+	 * rs1==zero and rs2==zero ==> HFENCE.GVMA
+	 *
+	 * Instruction encoding of HFENCE.GVMA is:
+	 * 0110001 rs2(5) rs1(5) 000 00000 1110011
+	 */
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid_gpa)
+	/*
+	 * rs1 = a0 (GPA)
+	 * rs2 = a1 (VMID)
+	 * HFENCE.GVMA a0, a1
+	 * 0110001 01011 01010 000 00000 1110011
+	 */
+	.word 0x62b50073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid)
+	/*
+	 * rs1 = zero
+	 * rs2 = a0 (VMID)
+	 * HFENCE.GVMA zero, a0
+	 * 0110001 01010 00000 000 00000 1110011
+	 */
+	.word 0x62a00073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid)
+
+ENTRY(__kvm_riscv_hfence_gvma_gpa)
+	/*
+	 * rs1 = a0 (GPA)
+	 * rs2 = zero
+	 * HFENCE.GVMA a0
+	 * 0110001 00000 01010 000 00000 1110011
+	 */
+	.word 0x62050073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_all)
+	/*
+	 * rs1 = zero
+	 * rs2 = zero
+	 * HFENCE.GVMA
+	 * 0110001 00000 00000 000 00000 1110011
+	 */
+	.word 0x62000073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_all)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 43962a25fa55..7192b6edd826 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -637,6 +637,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_riscv_reset_vcpu(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
+			kvm_riscv_stage2_update_hgatp(vcpu);
+
+		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
+			__kvm_riscv_hfence_gvma_all();
 	}
 }
 
@@ -682,6 +688,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		/* Check conditions before entering the guest */
 		cond_resched();
 
+		kvm_riscv_stage2_vmid_update(vcpu);
+
 		kvm_riscv_check_vcpu_requests(vcpu);
 
 		preempt_disable();
@@ -718,6 +726,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		kvm_riscv_update_hvip(vcpu);
 
 		if (ret <= 0 ||
+		    kvm_riscv_stage2_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 496a86a74236..282d67617229 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -26,6 +26,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (r)
 		return r;
 
+	r = kvm_riscv_stage2_vmid_init(kvm);
+	if (r) {
+		kvm_riscv_stage2_free_pgd(kvm);
+		return r;
+	}
+
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
new file mode 100644
index 000000000000..2c6253b293bc
--- /dev/null
+++ b/arch/riscv/kvm/vmid.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/cpumask.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+
+static unsigned long vmid_version = 1;
+static unsigned long vmid_next;
+static unsigned long vmid_bits;
+static DEFINE_SPINLOCK(vmid_lock);
+
+void kvm_riscv_stage2_vmid_detect(void)
+{
+	unsigned long old;
+
+	/* Figure-out number of VMID bits in HW */
+	old = csr_read(CSR_HGATP);
+	csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
+	vmid_bits = csr_read(CSR_HGATP);
+	vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
+	vmid_bits = fls_long(vmid_bits);
+	csr_write(CSR_HGATP, old);
+
+	/* We polluted local TLB so flush all guest TLB */
+	__kvm_riscv_hfence_gvma_all();
+
+	/* We don't use VMID bits if they are not sufficient */
+	if ((1UL << vmid_bits) < num_possible_cpus())
+		vmid_bits = 0;
+}
+
+unsigned long kvm_riscv_stage2_vmid_bits(void)
+{
+	return vmid_bits;
+}
+
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm)
+{
+	/* Mark the initial VMID and VMID version invalid */
+	kvm->arch.vmid.vmid_version = 0;
+	kvm->arch.vmid.vmid = 0;
+
+	return 0;
+}
+
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid)
+{
+	if (!vmid_bits)
+		return false;
+
+	return unlikely(READ_ONCE(vmid->vmid_version) !=
+			READ_ONCE(vmid_version));
+}
+
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_vcpu *v;
+	struct cpumask hmask;
+	struct kvm_vmid *vmid = &vcpu->kvm->arch.vmid;
+
+	if (!kvm_riscv_stage2_vmid_ver_changed(vmid))
+		return;
+
+	spin_lock(&vmid_lock);
+
+	/*
+	 * We need to re-check the vmid_version here to ensure that if
+	 * another vcpu already allocated a valid vmid for this vm.
+	 */
+	if (!kvm_riscv_stage2_vmid_ver_changed(vmid)) {
+		spin_unlock(&vmid_lock);
+		return;
+	}
+
+	/* First user of a new VMID version? */
+	if (unlikely(vmid_next == 0)) {
+		WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
+		vmid_next = 1;
+
+		/*
+		 * We ran out of VMIDs so we increment vmid_version and
+		 * start assigning VMIDs from 1.
+		 *
+		 * This also means existing VMIDs assignement to all Guest
+		 * instances is invalid and we have force VMID re-assignement
+		 * for all Guest instances. The Guest instances that were not
+		 * running will automatically pick-up new VMIDs because will
+		 * call kvm_riscv_stage2_vmid_update() whenever they enter
+		 * in-kernel run loop. For Guest instances that are already
+		 * running, we force VM exits on all host CPUs using IPI and
+		 * flush all Guest TLBs.
+		 */
+		riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
+		sbi_remote_hfence_gvma(cpumask_bits(&hmask), 0, 0);
+	}
+
+	vmid->vmid = vmid_next;
+	vmid_next++;
+	vmid_next &= (1 << vmid_bits) - 1;
+
+	WRITE_ONCE(vmid->vmid_version, READ_ONCE(vmid_version));
+
+	spin_unlock(&vmid_lock);
+
+	/* Request stage2 page table update for all VCPUs */
+	kvm_for_each_vcpu(i, v, vcpu->kvm)
+		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
+}
-- 
2.25.1

