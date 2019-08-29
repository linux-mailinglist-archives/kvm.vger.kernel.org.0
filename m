Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE6BA1BF6
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 15:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfH2N4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 09:56:35 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:60091 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbfH2N4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 09:56:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567087052; x=1598623052;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BQSrVXqIypAetjOrz0oeqDGKqU+4YngxTjXjhqIUisA=;
  b=QWq6HtSlGyJwQEVGWWcR1ny94d7sCv2733BS3mBVVl7O3PUbUc4TEkuK
   pumr1oMPc71x7QQ2SB20NgGdro/KHHX6NbjmrfZy9gPZ3StWfHtwqkqJs
   BStn+TX6qVgUgNaAhg+qB+6Xt+qx3p4bTctYFbPZKfWhNSbnfEBdJ3E2i
   RRyZgtCkkCzC6p8TgvZ+LRsfNLswcAmaZJ2dHqKKW9ahDqpd4N9iNcR0I
   fE313Y6d6AEA+7jkiuK0gCm1mzOil2U77VybjTo8w/84Jb9VGge4Smrsw
   DQK8RZecS/ihX5RqyHEC1ak0eFc6q4s5B25lO37JFYzgEQT/9MMD+kFt7
   Q==;
IronPort-SDR: c8UJQ6OmBveqXSaeoLvFctFGmyK+31xcaYLz3CHpQlLuhnirvAeYzV4TyVxIDElUzNveHXybPx
 iqYBuY1q1IqkMQw3zEakC0o/hfk9JegBxNUhkHBLlj4f0ooX5J4nSr0BZDOI+4K6EoiA1PQrln
 qqjG8CDs/H4VPEr7Cha9iumIlELU0iPZ8Rxa6rSwoIRRK851gLwd2+munyUSiXWI6HM1a4VC9Q
 zkvDJfRHeq/+smEnyvzDkZ3r7HgxiaQmD+IIJn/NkizEchB4SkM/n79qDo+ZlRYxMCqjpqYaFr
 ybc=
X-IronPort-AV: E=Sophos;i="5.64,443,1559491200"; 
   d="scan'208";a="217472165"
Received: from mail-by2nam05lp2050.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.50])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2019 21:57:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLys36m7qQEjojWK1RI0PpgViRZQG1GbRUqYeraiWgSSyHRMiszYa+28/uI9+hGa2LU8ctiB2tLhV4wF4g3O4xkvo3yjhlOlppG7PNDy/50ax5iLP2q6leNPx/QgKCmS/yJHkaGnU51qE0eLd7BdfjSjkBnyVAvqJKSDTjFf2aVx/yCye84Azqymez531Z9jFlcNajKYJI8As1fRYTdv0Gw245wipT9q1SBauG7YSnQMT04DyK2PAuRA1ZFJPd36jZb6e+tlZ0hOfdjGjz/vAix9Frr5FbKTKH8CgG57QZZvZqyWCnuDtbwt7BK/meTM5kkRUbcbKLuzR/i8a8/Pkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPkeDVmRs+x35XCADQwZfZuCxRfGijJMFhe2MkaQyag=;
 b=FSurM7MQ8O4fwe8JL0CJUb+xnonjcpYdmBkjUqf3hrA50lEzqQf4Brh19qWNK16PgkoEX6ZAevFrHjMToUYsimhWLJNU2UCbBnaRlpEDbEcNQgMzMIZmjhZtOcO61/m1SxJFi6jGcSDIX/D3iZAe1PLw/ExMIieEohaIJy0tckzDb9KxFHGxzfzn6LLDJOcicdU2kJGN1lHV+kKcwpKvDa5FdpFJ4zS6tp413BigXN9JYeVneTAJeBiij2lMNMaVjhxIhk2pJTbqW2v0zZrDmM58fEhAyozeXpUucskUygG30eQi0cja2BGRZVKwFrqfnSbiMDwIVrbniPGBOePMiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RPkeDVmRs+x35XCADQwZfZuCxRfGijJMFhe2MkaQyag=;
 b=vSXV68z/B66kiBzsKP373OvDfYUCFI5/I79k8Xf2w366T4+4CnaqBv9aHpLT9QdOh2wkbmYFDRpA/Zm2Qi/Y5231fsIzHRalkgw04QpFLEhB3zTdC1WTCwlx6uIPvATuwjBqS7n+tBmMxXNr6I0CJSR5qu42ld6HLXxSN/F2C+4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5616.namprd04.prod.outlook.com (20.179.22.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 13:56:31 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.013; Thu, 29 Aug 2019
 13:56:31 +0000
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
Subject: [PATCH v6 12/21] RISC-V: KVM: Implement VMID allocator
Thread-Topic: [PATCH v6 12/21] RISC-V: KVM: Implement VMID allocator
Thread-Index: AQHVXnGPDFiLzcdrokmlX6cARjPZzA==
Date:   Thu, 29 Aug 2019 13:56:31 +0000
Message-ID: <20190829135427.47808-13-anup.patel@wdc.com>
References: <20190829135427.47808-1-anup.patel@wdc.com>
In-Reply-To: <20190829135427.47808-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR0101CA0072.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.51.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69ff7c61-2120-4bfe-06f1-08d72c88b235
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5616;
x-ms-traffictypediagnostic: MN2PR04MB5616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB56163548A133123053C1907C8DA20@MN2PR04MB5616.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(189003)(199004)(7416002)(52116002)(81166006)(316002)(6506007)(386003)(25786009)(7736002)(81156014)(305945005)(2906002)(36756003)(71190400001)(14454004)(99286004)(1076003)(256004)(14444005)(4326008)(66946007)(76176011)(66446008)(64756008)(66556008)(66476007)(102836004)(6116002)(50226002)(55236004)(476003)(6512007)(3846002)(71200400001)(5660300002)(26005)(186003)(44832011)(86362001)(66066001)(6436002)(446003)(8936002)(6486002)(110136005)(54906003)(2616005)(486006)(53936002)(11346002)(478600001)(8676002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5616;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gD7nnIxeO6qx3Tc7laR6cA3dnnUcTFkFrPpNKVJm9uW3ZOXGqtzgMENltvMUvH6pJ0hUUqIuNiegnzU8i7GnwmP3NIW6a3NQ5ozNfNl8a3j2wBvhUQ19EryQgDILKeJ+pX8HXNUDa4xfOVCAqSy5QovITk9CzQEofZgJ8qUD9pmk5hfQwcThHAIolWOIUJwmp8TEbAJzwpmjFJWGBLDroOa/7KUShuONBYWVY5bnIuOrxbFvpXL7B73A6x9bz+AZTs9gNPxM/I+ZIkjZeCDftJtOC+AcORf6LCglIAickPRaAlsHp11wuGXcwFN32Rzf3raFWSbFi3jfDMTXt6g1QeUgTe8eY4KBhEZgBeb9bym1DFYU3RtH2tvpEOODLVkyvjT75f4aCqa4wkWmK1yRGeI/TxzYmKt40DH6vUo8s3Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ff7c61-2120-4bfe-06f1-08d72c88b235
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 13:56:31.5547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eujv3J5Z6XZzb4kDCShDiEyB9XEaP+e3hOdBcEnq/j1fHfq8pYhCdQk8f+ab8J6OAEDlxVWTTis/WG4+KZcwyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5616
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
 arch/riscv/include/asm/kvm_host.h |  25 ++++++
 arch/riscv/kvm/Makefile           |   3 +-
 arch/riscv/kvm/main.c             |   4 +
 arch/riscv/kvm/tlb.S              |  43 +++++++++++
 arch/riscv/kvm/vcpu.c             |   9 +++
 arch/riscv/kvm/vm.c               |   6 ++
 arch/riscv/kvm/vmid.c             | 123 ++++++++++++++++++++++++++++++
 7 files changed, 212 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/vmid.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 36974001433f..5f1dd289fd8f 100644
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
@@ -47,7 +48,19 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
=20
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
@@ -169,6 +182,12 @@ static inline void kvm_arch_vcpu_block_finish(struct k=
vm_vcpu *vcpu) {}
 int kvm_riscv_setup_vsip(void);
 void kvm_riscv_cleanup_vsip(void);
=20
+void __kvm_riscv_hfence_gvma_vmid_gpa(unsigned long vmid,
+				      unsigned long gpa);
+void __kvm_riscv_hfence_gvma_vmid(unsigned long vmid);
+void __kvm_riscv_hfence_gvma_gpa(unsigned long gpa);
+void __kvm_riscv_hfence_gvma_all(void);
+
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long h=
va,
 			 bool is_write);
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
@@ -176,6 +195,12 @@ int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
=20
+void kvm_riscv_stage2_vmid_detect(void);
+unsigned long kvm_riscv_stage2_vmid_bits(void);
+int kvm_riscv_stage2_vmid_init(struct kvm *kvm);
+bool kvm_riscv_stage2_vmid_ver_changed(struct kvm_vmid *vmid);
+void kvm_riscv_stage2_vmid_update(struct kvm_vcpu *vcpu);
+
 void __kvm_riscv_unpriv_trap(void);
=20
 unsigned long kvm_riscv_vcpu_unpriv_read(struct kvm_vcpu *vcpu,
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
index d088247843c5..55df85184241 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -72,8 +72,12 @@ int kvm_arch_init(void *opaque)
 	if (ret)
 		return ret;
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
index 7f1f07badaad..66158c0b90e6 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -637,6 +637,12 @@ static void kvm_riscv_check_vcpu_requests(struct kvm_v=
cpu *vcpu)
=20
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
=20
@@ -699,6 +705,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		/* Check conditions before entering the guest */
 		cond_resched();
=20
+		kvm_riscv_stage2_vmid_update(vcpu);
+
 		kvm_riscv_check_vcpu_requests(vcpu);
=20
 		preempt_disable();
@@ -735,6 +743,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		kvm_riscv_update_vsip(vcpu);
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
index 000000000000..69f770fa4f46
--- /dev/null
+++ b/arch/riscv/kvm/vmid.c
@@ -0,0 +1,123 @@
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
+static void local_guest_tlb_flush_all(void *info)
+{
+	__kvm_riscv_hfence_gvma_all();
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
+		smp_call_function_many(cpu_online_mask,
+				       local_guest_tlb_flush_all, NULL, true);
+	}
+
+	vmid->vmid =3D vmid_next;
+	vmid_next++;
+	vmid_next &=3D (1 << vmid_bits) - 1;
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

