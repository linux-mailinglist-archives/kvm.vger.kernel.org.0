Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871651BB7B2
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgD1Hex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:34:53 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57294 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgD1Hew (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059293; x=1619595293;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=mEZnWb5LBjkOhxQnmJCE/xFu1f2KyjQme4qwBkbzLRY=;
  b=PMBOOecPO9lLvMF0lqJh9k5lUJn1XAPRfrUdBJKrttINiXoM72YMG318
   g7w6TfKoL3Z6dlsT+udD5oiIwsAih9AV7UoiLDSNZf1dDf0HB2wyq/BWB
   fBoLOEfI4m4FOIXOM8tWPDpQ+ofzeXkn7P9PDH3YggTh5uN8QtHXvJpSB
   tmQGJg3sPX3X2u9tdsuQCMOBwbLFkocATY3yspMFovu8zuNjxPijYiSFP
   WEILo3pAzigY8aUPCNIbzwjNsjwFcoquXeNabQ1ACxTDMbc8v7SJUBtzS
   JZNLPhD9q9pIU2AIqGZAW4WZLAyKRdinqdyRqdQLx4RpKIX44eJ/Gpog2
   w==;
IronPort-SDR: Hi8rTgUhQgZI+qaQwsr03OR3YOZw+Rj8menpZfaVhi7IXLUiKAYV67e42pCfsMJ3rkdkiq51+6
 od/M9FBQ7PgUUCg0OMnZSnfSzSa6qVv7uIizrx42ax/Px1ANNalGNrWLWYklDVQdSyOlWW2ddG
 EZZlTkovMQeFGIa1lf0hbYlcLLiWjsUIstLJ6ILl8/BOnYKF4O96bKYYEiQtbJDjzKvFuXf+ei
 asS7YpEcOYsEvs3Bt9UIY9AsPB7EWfq4Z6PB4IrtYZODurREr8g2e+EvLaKSr1pWiMFIVHkOH9
 kyc=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865879"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:34:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lu+zFez75sU0vqg2Sn4tp3SBAZsOq3B5KFddtCLUEduyuu67rG+9baN8dMNdjZfNJTF8UUyP6ChKnNF3qarPvrzfPqnw7C/WxCK6h1AaV59WzbiaFjtvP2IOBZQwepLpwDME/D5XWAh12GiUCKMpuve1cHmhr4BDfNdenSO+0hZXGz2/pNlSaR1+Ptq80PsLggyfwnRnZg3CP/ZolCBdr84ckRzuWxiC0H7g4MdC6gsilWHx1dZ41ki91GYx98wpDUCjnyQYCEf9grRoy2Qgf71K9x/CiGDElnWxANDacN0IV3fghPl9/T4Iox3hGX/+yv1Ir+T1u0KITuI0tNqFpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIX6Q5QfUXOZbgm6NRQBrijkRVELS4Un1UBmeFNITDQ=;
 b=jpZCyJLne3B46EWpyGZ6LU2o7TOM7aGnNoTyHfYreH9vr6XA44c3sFKKPIosCeAzq5agKUOXx69GCeMLt7yM2UrEXa2ik2S3YREBylWPSY/Lk/s91ZIDf00VgXqRY7YtYs1zUCnS6gFyAwRXi1v/M7AxOD/r021rx3zS1445Ebq+lxQOXf4Jq3TkLkmN00pfHqpd9pfydmTZe+6d9Tb/sDGqQokyYw9+VrH868N87qC4FsgPjd1n/KgNUhMp+fUX3J0k1X9GxljkDJydXQLCegM2i4NFuNZaPlVMdc+6NMWrKU0GlN4WGHxt1WCmuGzO/8ehAkyACWxBtkW+8fhc4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIX6Q5QfUXOZbgm6NRQBrijkRVELS4Un1UBmeFNITDQ=;
 b=go4G4CV2ujo/bigWFkwteNY8ANgpJVALjbRUsESXJkm06NGyAqvnxq6mDeroUG62KrKRyXhdR4qvuqNMn6gADJLAvBq3ucAalCFKHF5yJj8HselUidomMw1T6jzN925s0E7w0QUVQT9zssXCG/7ZDeyh5It5IjOzRkmB5Cp7iuI=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5929.namprd04.prod.outlook.com (2603:10b6:5:170::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:34:49 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:34:49 +0000
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
Subject: [PATCH v12 09/17] RISC-V: KVM: Implement VMID allocator
Date:   Tue, 28 Apr 2020 13:03:04 +0530
Message-Id: <20200428073312.324684-10-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:34:43 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8234b5a5-d5bc-4707-66f6-08d7eb46a1c6
X-MS-TrafficTypeDiagnostic: DM6PR04MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5929A8E5C81F50E7F5B708F88DAC0@DM6PR04MB5929.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(1076003)(66946007)(2906002)(5660300002)(66556008)(66476007)(7416002)(86362001)(478600001)(55236004)(55016002)(186003)(8936002)(316002)(4326008)(7696005)(36756003)(956004)(110136005)(8886007)(2616005)(6666004)(26005)(16526019)(54906003)(44832011)(52116002)(81156014)(1006002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yk4drcRfrGBrVWBIjYeBX+cJWGNDbh71iwH1hsjCfdwIX96NwVKGK7sYyGUrN40AYCWuhE8tLlEdG+tanDUudT/V4lJtQyYgCWsgBDXrY8LZlADgxYnxrtf4ppmK5WVKLV6V6F3u96S+0nJHv2M7EBYpx1PBcRyao3eCwBgb4mxuao1pelVkouDAySXLpqstdtu6Ltad+zb25442jrZGQZ75bb0h7BQ+ck4isR6bs38iMZ/gQL3tFIzyOsNR/93+CRUUg53VlSsJH8Sm4RxEz3+rVBszboTsWae+qbntKhzzF/3rp1Hbg5073p7f72je08RNptuTr8kSXumT7dzNU15q0WCP+tlWWRqecXEsy3nyapuPjo+39n5KYJd9TL4dkJGBICD/QALaLfNsG3SJiZsMDSB2iD2ni1gnUfvXSw/05qk8UrG3jwDQYUT7R4ys
X-MS-Exchange-AntiSpam-MessageData: cIlTAC4KAESjVwQngcPBYXCW6YVJT1FBksfaUozDP/0zdf0YgIyeL/2avJ2cxHTMq1MfHyBxd4YzhaxzSxOGVvohlHrqfMaKEJUT6Nr1OpqCDfipl8v9VsS6kg95f9hJOpVhZSlrj0Kpd/rpKPmQFqcbWrEAqqMat72qkMfzt9s1WcPP6RXoJGkjHM9l4lojBKRtaOw4uEyzbMVypxkg2y9UwnqK9YjEoxbQab6sMfSGZ7lJxg56XhQ4Ryn+osKcXw3AjTyb4W4QjNTykbSD9++bmOzDBxjtHykDcO9ygJr6fFzcscYktPl+f+W/AkzhGZgVk7JvS5f7wr7rZCOHqf54ImCzjMNj6IQw6iW1VnVM0W25F7oj1dDJvbLmQL2W6U5ka70ihV16QkoNCVz8dUceO8cZW27AKdnLzhId3WyvtZlvlCg0N+L0q8Fgl3ohPWk9P+r0yq1RcrrcGqLeidSxOYplLn4wwXgad+s2lJyTG7vZh6b8FwH8beR9LlrImbC9Z4P3/ZQ426rGXE6loV1+s15E2l/ThdYiSol5ndOeXSZkpNyTKcYTiiLEPNE07EeRn038M29Ssecp+xPaf8wfKwBxP72r07OsnLzmkqrDF2fT+skS48M3GJ7mLzrR6RBdv1maEw7rRa1L52Z5F97ZHirVyBH4+U0O+YdxOKAYyCM39hw9oRG6L4qA8jiT2Ak4jJLaA4Ye5azpK5STYDRAmmDRoP/9KJdRXJPy+bFMhx6B8Eb7xOkwKm/XDmV+CigwfZDLUc286DEolmHhoDUiOqjI8gY1nlJ77Skyx3I=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8234b5a5-d5bc-4707-66f6-08d7eb46a1c6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:34:49.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEx156acio/mq/sk7HOkHfJVgHnKokEYGhPfXomgy0+E8AdhFVMP4mo8uqufbkW+uy5FprAoYqF57Q4SsU4xYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5929
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
 arch/riscv/include/asm/kvm_host.h |  25 +++++++
 arch/riscv/kvm/Makefile           |   3 +-
 arch/riscv/kvm/main.c             |   4 +
 arch/riscv/kvm/tlb.S              |  43 +++++++++++
 arch/riscv/kvm/vcpu.c             |   9 +++
 arch/riscv/kvm/vm.c               |   6 ++
 arch/riscv/kvm/vmid.c             | 120 ++++++++++++++++++++++++++++++
 7 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vmid.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 05c84c745c61..296a5b13b3a6 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+#define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
@@ -47,7 +48,19 @@ struct kvm_vcpu_stat {
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
@@ -175,6 +188,12 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long vmid,
+				      unsigned long gpa);
+void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
+void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
+void __kvm_riscv_hfence_gvma_all(void);
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write);
@@ -183,6 +202,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
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
index 845579273727..c0f57f26c13d 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -8,6 +8,7 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 
 kvm-objs := $(common-objs-y)
 
-kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 4dee84f5c440..6915ac6888a7 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -77,8 +77,12 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	kvm_riscv_stage2_vmid_detect();
+
 	kvm_info("hypervisor extension available\n");
 
+	kvm_info("host has %ld VMID bits\n", kvm_riscv_stage2_vmid_bits());
+
 	return 0;
 }
 
diff --git a/arch/riscv/kvm/tlb.S b/arch/riscv/kvm/tlb.S
new file mode 100644
index 000000000000..453fca8d7940
--- /dev/null
+++ b/arch/riscv/kvm/tlb.S
@@ -0,0 +1,43 @@
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
+	 * 0110001 rs2(5) rs1(5) 000 00000 1110011
+	 */
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid_gpa)
+	/* hfence.gvma a1, a0 */
+	.word 0x62a60073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_vmid)
+	/* hfence.gvma zero, a0 */
+	.word 0x62a00073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_vmid)
+
+ENTRY(__kvm_riscv_hfence_gvma_gpa)
+	/* hfence.gvma a0 */
+	.word 0x62050073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_gpa)
+
+ENTRY(__kvm_riscv_hfence_gvma_all)
+	/* hfence.gvma */
+	.word 0x62000073
+	ret
+ENDPROC(__kvm_riscv_hfence_gvma_all)
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index de94e1a26117..8e75c92fe37c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -632,6 +632,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 
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
 
@@ -676,6 +682,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		/* Check conditions before entering the guest */
 		cond_resched();
 
+		kvm_riscv_stage2_vmid_update(vcpu);
+
 		kvm_riscv_check_vcpu_requests(vcpu);
 
 		preempt_disable();
@@ -712,6 +720,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_riscv_update_hvip(vcpu);
 
 		if (ret <= 0 ||
+		    kvm_riscv_stage2_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index ac0211820521..c5aab5478c38 100644
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

