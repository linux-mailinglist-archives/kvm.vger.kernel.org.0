Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8261E25797B
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgHaMjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:39:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45698 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgHaMb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877088; x=1630413088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=fTyaWd/81z4y5vjB0aNAr+BvQeZI4/NmfzWNKQMEy8g=;
  b=Y4TxDNzHnpkWIv9nhwc+a7VOSn3+hMEoiTEleDcaDk2JRExYPN71C8Z2
   jrI4w8bVgOXVouCFc/TDls3fcHZ+yvTOrEuoHDW9uLKFdDBhzePWj7kFc
   hlDZi2azNGkG5PLYnQpxZEZ3a3xY1N1kRtuqyRG3wDY6CGtU6C69VQwXM
   YHQUko8pnzFApzts9qio6IMXGM7sdgCQ+cOFvDuMvE8U2lG4QmKY7XC1n
   SqO22F15aKz+UvXZWvr/Ndnlfp8i0WsLLNJLw+rhjLJUVijvq8qEJ51C0
   tUUuNCKUCWJJilBN8iD718MKYd3fdLQj6erBQEEgE75SQ/YxPXs2Bm8hd
   w==;
IronPort-SDR: D1kVn7Qa/C/laX/TSfNnd8WcU/+wK75oS3WLhYzkgFeH/Wlsbs/tvMTJ5jvZu9eWmSg5ReIyYF
 CfaQ4AnXyTaRZ1/SXpnaMg6DgQmh8w3MRkdKOKWD/AZTC63W7C19YVrYELIyC390MLeBFNe1Gc
 cqjDq/+QJq3wZNCoexigNQvtt6K/kGOpreAKXJbCWxyhW0oGX4b8htt2N8J6TmANU1xuZHqMUL
 zLdYUtaSoq4bZ7mVRXlM9HCVtKG/YOo3bdpC0qCSBqBYYjSa7ScXsJdlPmrC2E4eH1hKZDnQ3o
 zKI=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="255743365"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:31:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmT0iuL7T1ZvNMwFBw35E2NtiSm9feXPDvtyKSFXe3QelWv4W3llyDnMj+61BZHlfYyuyzWyrDlWeNfhlp7p0o0ujLRKoa85MRIrdgqbsZkBhyA7pmRId3Kwnf1a4Z1U2JQ8UqAcy4hXA/ens9G0jKy2faPcw6V5IFXd0kkEy2TNQCfT0FHH0IZtVxQ4dWgp4I/VdCoxIbdZlJ6xdLHGOs6tG7Bt8AbHVaAmI49CHssBw2xWg0As0sUjXufldOZ0McDEU9+GuQ5tl2r7MLJtrMkFLwfyUsaE5YaNX9HSEOPfw6DEzj2jz96qvlW2Megcgfy/NMTkbkyBBh4u2x++Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4Qj0UtRwrSQ5ohLZzVOkmYsEljNd39yxA4ELM9UXnU=;
 b=ocP0wTCdvCT1gNjdh3c5WCX1+oZYxzAT+vnQnt6MxK9SfIj0YMEgiJST7THe0X6sdp42TXMxiFbcHql+sfXuZCHTVEjs7BLazvEq8JLznVkAefiKduhC3tQxYaZGDUGhl8HhNt/gqymfE7mjfSiMkge7IuNH5InFlD1HaOPMueBOLuC9yf4oxv5zJ6VdveyDMioyXLNfXTm9GyJuxCuC0spuMi0Fun02JRasdzWoXF4Mmd4WNh99fwMbiMh3G8hXG7sETxFs8EyjZnP/r51lz/9aPXkcA8cJgmyGvBki386P8obLCJF2/yNI+eV2UZLAT3qy3g6BmOAYcrw9euQPQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4Qj0UtRwrSQ5ohLZzVOkmYsEljNd39yxA4ELM9UXnU=;
 b=L7cV2eQhrSeI3Ve25cINZzQfN3tktKCi/9ZPxnIPdcB+6m2qFqYdnqGAPcpNgGXUYx1dgpPMUWctoO6kMkK59xeagO2/zVgvh8SXF6/ZSyIZJzDh1zLRQRZQ43HTrhSNxTd2GYP73vRsk0WIL8zXd9mHWFrB6eR1dtb5Q2pItqs=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6092.namprd04.prod.outlook.com (2603:10b6:5:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 12:31:24 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:31:24 +0000
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
Subject: [PATCH v14 09/17] RISC-V: KVM: Implement VMID allocator
Date:   Mon, 31 Aug 2020 18:00:07 +0530
Message-Id: <20200831123015.336047-10-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:31:19 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a8eadc0-aa52-4a31-facb-08d84da9c60d
X-MS-TrafficTypeDiagnostic: DM6PR04MB6092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB60923DE4340D1D70CC5151D18D510@DM6PR04MB6092.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vBqlCxl3luSS5v0iamwpJ8/jX5Q1G4vblfLwjCxiWectre5jnP1KmMhEDerxmosKZfL2NE4TjXdiTX0afnefRTS9d3306cE/1zgb++xU/46+YVlm3NPMeWQMVE9AYjLoFFVgqHMw4mjxmuiItefupaZ5xVrwBXvJcb5vKJEio3zZdim2JJkPf6Fvjz2N1/+Q1NaW3IZ9IvJQb6Dm5qu9eYZAv4hrVY1KNwFKsDOAEhM7Y3HRmc2W9ay7DdFjSWFzsYyLBHeSp2u0b+Mu5anGuYWEqISlwbLXOpKIdx0+JdMKnn9zbfjhYoieR84sfvRD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(44832011)(6666004)(52116002)(8676002)(86362001)(36756003)(478600001)(6486002)(7416002)(30864003)(110136005)(8936002)(54906003)(83380400001)(66946007)(1076003)(66556008)(2906002)(26005)(186003)(66476007)(956004)(316002)(16576012)(4326008)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: L+3VDMjEq44BUkMkToMVMugtoc2sxwMRsiAwPqxBVaOZ91YhAla3rhXrmDzm6AusONMNNztaXyUrBkxYZqnajK0u8LHp1xG12OBWBAj7JbhL4lbP81erhZDsfvjMTNs7J4vrWMgk++B57hA16fYURoqq83nHn/5mo7TlkvQMsY63pQ7goGG8mi6/AzKzxtjz4vW59VK1ZDhny5tN9fOO9V1xtw8sMsQ0uEq4vGmx8oZjOsz+qBtAYNkxu2VfqZh6gq5xBIfSHtIpS00jlsQEyRXuOP8rTYaU+6ELkUSQjVEmCZz0wcx40pbczBz2rQxJ1zk8IIaqbwDBf+kRdqg7WPo8gJT1tuN5RIjB2cLdIalOi0lPFmn+R2Gm4DIRhoXFFxYeitzBuDEjFJyw7fTXDsiESbz2zJJhmTl6V3C+Q6eSWfqhGVZtBIjMIKSQbF1THaCq8EvaTDS2Suzy9h4fTcaOK7PwblyA6LHgkKnqt0+53Lfp0lkW7lebhDJU6W4Gr+dTBQ6M4C2K2CaH+NXLjwajqreQkcXv7USrFttRYaj4EIlxksDzvZPFJolOtUS5LAYMzSNXMWthoM4wkLB6a8JRck00VGbecY0mqvgFzVZNmvz/vUtqfJThx7A5gIwkYNQ2gmNECf2V/23zuG09Zg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8eadc0-aa52-4a31-facb-08d84da9c60d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:31:24.4849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjywlHcol6FayIK7qW8pHA4FvHFJvi5QWJQR4xuFCZnZ62T/igZaYTuPzATK2w9c0TXunVrubcF70Cja++/AXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6092
Sender: kvm-owner@vger.kernel.org
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
index bfc9fca6b049..ca4eb4ce1335 100644
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
 			 gpa_t gpa, unsigned long hva, bool is_write);
@@ -188,6 +206,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
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

