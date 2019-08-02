Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E067EDED
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390336AbfHBHsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:48:07 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:63071 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390313AbfHBHsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732087; x=1596268087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6kkVXIHm/hNFZvLo9XCNEDjCogkgbulsl32NeWpu0Q4=;
  b=h/5XozJe9mQrv46SoxTyAlIzflwyBRVielJUOvyHSbCvllxkBkkfUr6W
   /QcEd9h1Yd/r7fZ6/zmCWjoYnRiR0EAKuXaBkAYuPfIJw3QKwrMOHattN
   Cmg5c/euqSJnLnW/eurC3ujTD2Zn+qQDwFh+i0OIJR0bV6LKMvlyKQxtB
   SYfM0txZbK+qbUJ0oeoIgcWYdTwygmHSbSTrNTAsVc0XK97ViRVdDLqoA
   92cs3ff/3aJq9aCzu3zDx0FZdFyDRjmQL4NxmSFSXTHY46A+j93oepjJb
   EbWqT9t0C14sWQx6nvEHVKSm1Tc33EH1YfM23F/CZ0gs/OJXZ0mADZLJE
   Q==;
IronPort-SDR: cj8DPoxitMb4TZe3n9jyZktC58d6XBYz5B7liRN4MEBrbAH1mIWO2C6nY49aglI5njSVI3ddez
 uxS6qiX04rmaJZm1u+0OjGSEIvUtwa+f/9dZcQ3WtP0bQcWj0JDp8+OBoC7Yd/4ePOPWXfQ2fX
 pDsXWCknlNhj+4McHYjb8eE7phgZkGKtuDpBScFonNbU2LQoCBnyWmVDiCKU1Egr3u+qgaIPw6
 nN5KPZ4sf6XniYgKLqci3UwkfozJWiPuxiMp9Y31UozcapWzTXajGTAwwxPeVM1HIjbV4b68w0
 3S0=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="114783235"
Received: from mail-by2nam01lp2053.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.53])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:48:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EL7d558ejUAO2TAB1m8Hn568IubwIRHLY9alrB34GBtx76M4mXQ60uCikCFObF0/sOSvxPrUEG8PxB13abAVjFmNmNjpro3hSA126vDj7tb0qjiC8i6MnHG3MJtsKEmiG7e26BGs04zBzanrvI7aN+aHPJHGXt0YYWmCkvxBGx4lUQnt+ROf5GWA8xg7pL7JqHKN3LujLXb6IynwO6m+D7NkVIQx2iLsoQbps1hRz7s8ACeYu/6/YDjx8ycHNBphK1XoY1VVNy/Pkc6heJmaoVFKN81uDp4zDZChX2Qyx6LguGYgMLasEqX7klgvYZ3bi5nJiC3031TKTWgamrd2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTpCuhzfhJIzcSLagnnwxAUQGbqvHlVlL319bWGShoQ=;
 b=GibPaoZAz6y+g4Ns39he+GrMUHPLvPOIaagWdjXQSHEb56RzAMCMhG5BxXzpmfo3zf2wBiUoUVNNfGMlEMWq3p8djfPGUH86V4y1JNdq1uOyOiFm/QyNFq5GL7kst4ugCjzAEkyoOE4BQCEHFK7gFEUVo/aUQqtFXPJd28denUuuNNEfpwFk2QOcuargs2gV1aglpfffuESKTc8RtSPI0Z1p9MNqFQ311mA4PvzAw9/sohf7SbRKxlHHpx+a/OwQpE3Cf9KQjMjYI148CK093ytVtD9nhp96WBDdqJfAkb7oqTzTpAJhAhr2s/nFnd8fv0ukDKeUFJ/rFtK+4ZjHdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTpCuhzfhJIzcSLagnnwxAUQGbqvHlVlL319bWGShoQ=;
 b=aRibGQhCsdO+AzSUTWQhS+z1+xNh9gajBFaFH8bSu127CKZTYHeLTfLSpfUH3CDBteIQkvjVZQaNBQC6TshN3Uabm9fWreZohJnSgiO3Nfv7m7uATqrT1+Hv/LRfQfweGls0y4ZoeDFNfip01wQH2fQlg7p4CC9I6i2xQw2/aro=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5566.namprd04.prod.outlook.com (20.178.248.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 07:48:02 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:48:02 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [RFC PATCH v2 11/19] RISC-V: KVM: Implement VMID allocator
Thread-Topic: [RFC PATCH v2 11/19] RISC-V: KVM: Implement VMID allocator
Thread-Index: AQHVSQac3scKLsu6jkGzn8MXjWKofA==
Date:   Fri, 2 Aug 2019 07:48:02 +0000
Message-ID: <20190802074620.115029-12-anup.patel@wdc.com>
References: <20190802074620.115029-1-anup.patel@wdc.com>
In-Reply-To: <20190802074620.115029-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0111.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::27)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1b62651-be07-44d6-df7a-08d7171dbf30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB5566;
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-microsoft-antispam-prvs: <MN2PR04MB556666626EEEB1A39FFA960E8DD90@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(36756003)(14454004)(7736002)(54906003)(6116002)(102836004)(110136005)(71190400001)(446003)(4326008)(3846002)(5660300002)(52116002)(66066001)(2906002)(25786009)(6486002)(6506007)(386003)(55236004)(76176011)(316002)(53936002)(6436002)(305945005)(9456002)(81156014)(64756008)(66476007)(78486014)(86362001)(66556008)(66946007)(8936002)(11346002)(476003)(68736007)(81166006)(2616005)(478600001)(486006)(26005)(1076003)(99286004)(50226002)(14444005)(256004)(71200400001)(66446008)(186003)(6512007)(44832011)(8676002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5566;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pq6cQNAFlRmDaWYSTlDjq0uSwOZ3wwcXxhxUg9oTt87e6/ybuIIRuDMiQtSYpwfCjaxPNzQSsszKa9BDBQVxyMHuyQviwVvm0FtHBTl5XESo+bld7SMw67WyodSmhVWmmeiij69OcbEpG0PLKT2H5+ZeBuFvSB4K/UqAtnMkHkWHl07NKlbj+Ts/+70cb0jvupQdpS4zRApViWI4weIMQV7iaihOBjgwCE2CRkQ9ijIhy1u/Ne56J36/mkcOEZ0K0uP7FIEYlTRvMGNAxdYqdxw2Y6s1ntAR3Peqqx6y+YP73KFlU5T0OIbVxTiZsJ51HpVqmFWButFUHhCKBUbix+x30xt6kSu42VXNHd4txu6X+xFQf7SJUWKZlFUzik1g+JnlTFYGkADmZnMlL4t4FWlyMMhUIkBc9MqMkbwSILo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1b62651-be07-44d6-df7a-08d7171dbf30
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:48:02.7694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5566
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
---
 arch/riscv/include/asm/kvm_host.h |  21 +++++
 arch/riscv/kvm/Makefile           |   3 +-
 arch/riscv/kvm/main.c             |   4 +
 arch/riscv/kvm/tlb.S              |  43 +++++++++++
 arch/riscv/kvm/vcpu.c             |   6 ++
 arch/riscv/kvm/vm.c               |   6 ++
 arch/riscv/kvm/vmid.c             | 124 ++++++++++++++++++++++++++++++
 7 files changed, 206 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vmid.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 45225baa7d0c..ca2b4f2b558c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -27,6 +27,7 @@
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+#define KVM_REQ_UPDATE_HGATP		KVM_ARCH_REQ(2)
=20
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
@@ -47,7 +48,15 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
=20
+struct kvm_vmid {
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
@@ -155,6 +164,12 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcp=
u *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
=20
+extern void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long vmid,
+					     unsigned long gpa);
+extern void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
+extern void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
+extern void __kvm_riscv_hfence_gvma_all(void);
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long h=
va,
 			 bool is_write);
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
@@ -162,6 +177,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
=20
+void kvm_riscv_stage2_vmid_detect(void);
+unsigned long kvm_riscv_stage2_vmid_bits(void);
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm);
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid);
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu);
+
 int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)=
;
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long scause, unsigned long stval);
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 845579273727..c0f57f26c13d 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -8,6 +8,7 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
=20
 kvm-objs :=3D $(common-objs-y)
=20
-kvm-objs +=3D main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs +=3D main.o vm.o vmid.o tlb.o mmu.o
+kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o
=20
 obj-$(CONFIG_KVM)	+=3D kvm.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index a26a68df7cfc..379fc960d412 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -64,8 +64,12 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
=20
+	kvm_riscv_stage2_vmid_detect();
+
 	kvm_info("hypervisor extension available\n");
=20
+	kvm_info("host has %ld VMID bits\n", kvm_riscv_stage2_vmid_bits());
+
 	return 0;
 }
=20
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
index 652004aa1c2b..69548ddaa272 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -625,6 +625,9 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_vc=
pu *vcpu)
=20
 		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
 			kvm_riscv_reset_vcpu(vcpu);
+
+		if (kvm_check_request(KVM_REQ_UPDATE_HGATP, vcpu))
+			kvm_riscv_stage2_update_hgatp(vcpu);
 	}
 }
=20
@@ -656,6 +659,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		/* Check conditions before entering the guest */
 		cond_resched();
=20
+		kvm_riscv_stage2_vmid_update(vcpu);
+
 		kvm_riscv_check_vcpu_requests(vcpu);
=20
 		preempt_disable();
@@ -686,6 +691,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		kvm_riscv_vcpu_flush_interrupts(vcpu, true);
=20
 		if (ret <=3D 0 ||
+		    kvm_riscv_stage2_vmid_ver_changed(&vcpu->kvm->arch.vmid) ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode =3D OUTSIDE_GUEST_MODE;
 			local_irq_enable();
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index ac0211820521..c5aab5478c38 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -26,6 +26,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type=
)
 	if (r)
 		return r;
=20
+	r =3D kvm_riscv_stage2_vmid_init(kvm);
+	if (r) {
+		kvm_riscv_stage2_free_pgd(kvm);
+		return r;
+	}
+
 	return 0;
 }
=20
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
new file mode 100644
index 000000000000..deee60013890
--- /dev/null
+++ b/arch/riscv/kvm/vmid.c
@@ -0,0 +1,124 @@
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
+
+static unsigned long vmid_version =3D 1;
+static unsigned long vmid_next;
+static unsigned long vmid_bits;
+static DEFINE_SPINLOCK(vmid_lock);
+
+void kvm_riscv_stage2_vmid_detect(void)
+{
+	unsigned long old;
+
+	/* Figure-out number of VMID bits in HW */
+	old =3D csr_read(CSR_HGATP);
+	csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
+	vmid_bits =3D csr_read(CSR_HGATP);
+	vmid_bits =3D (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
+	vmid_bits =3D fls_long(vmid_bits);
+	csr_write(CSR_HGATP, old);
+
+	/* We polluted local TLB so flush all guest TLB */
+	__kvm_riscv_hfence_gvma_all();
+
+	/* We don't use VMID bits if they are not sufficient */
+	if ((1UL << vmid_bits) < num_possible_cpus())
+		vmid_bits =3D 0;
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
+	kvm->arch.vmid.vmid_version =3D 0;
+	kvm->arch.vmid.vmid =3D 0;
+
+	return 0;
+}
+
+static void local_guest_tlb_flush(void *info)
+{
+	__kvm_riscv_hfence_gvma_all();
+}
+
+static void force_exit_and_guest_tlb_flush(const cpumask_t *mask)
+{
+	preempt_disable();
+	smp_call_function_many(mask, local_guest_tlb_flush, NULL, true);
+	preempt_enable();
+}
+
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid)
+{
+	if (!vmid_bits)
+		return false;
+
+	return unlikely(READ_ONCE(vmid->vmid_version) !=3D
+			READ_ONCE(vmid_version));
+}
+
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_vcpu *v;
+	struct kvm_vmid *vmid =3D &vcpu->kvm->arch.vmid;
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
+	if (unlikely(vmid_next =3D=3D 0)) {
+		WRITE_ONCE(vmid_version, READ_ONCE(vmid_version) + 1);
+		vmid_next =3D 1;
+
+		/*
+		 * On SMP we know no other CPUs can use this CPU's or
+		 * each other's VMID after forced exit returns since the
+		 * vmid_lock blocks them from re-entry to the guest.
+		 */
+		force_exit_and_guest_tlb_flush(cpu_all_mask);
+	}
+
+	vmid->vmid =3D vmid_next;
+	vmid_next++;
+	vmid_next &=3D (1 << vmid_bits) - 1;
+
+	/* Ensure VMID next update is completed */
+	smp_wmb();
+
+	WRITE_ONCE(vmid->vmid_version, READ_ONCE(vmid_version));
+
+	spin_unlock(&vmid_lock);
+
+	/* Request stage2 page table update for all VCPUs */
+	kvm_for_each_vcpu(i, v, vcpu->kvm)
+		kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
+}
--=20
2.17.1

