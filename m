Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA0C84B97
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 14:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbfHGM3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 08:29:43 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37848 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388011AbfHGM3m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 08:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565180982; x=1596716982;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eXtvJk+xo1JyZ3ZvvjsmCgzGVhFl9tK5s7imVVk0Yoo=;
  b=T0PzfsJHCEA49u8XKbVAs353djgBWbNSnNrv1fT2M/WFGjrJKVDOHHdz
   dt4Q++oxpAjynIP/T+lnPvCkftLCYBiSyd2BRhLMxVJErdHSOq9eHr94m
   otG26D6QSEO0qBzYzk3oz/8Si5VIeDFKc8T9ZLD8zL8KCTR/9kgIqykTP
   ieyBWlK6IonlrxJjXhVd5nDfpgkrIyMMsVRLxDnyOiB2bJ7sO90pSAKcP
   QF33CHi6JTWUNNV3YC4J3BM0KKVvvj3tJxVXpvm3AoyyFT07rM1PCSC9o
   hlMb9naYwODJliCVNYEe0xyvbMA5UHk/EbZpC+v8Id/jaHx1To8iJ6KUj
   A==;
IronPort-SDR: INIq8ogO91Co5Orxg0dqdXxDQ+P6pqV+ybO23E9r4fiOvmaaw/PPc9DNwoFJETvK7qAIxFxfoP
 y7Jbh4VvSE4v0bPD4Jy+r6+sMOZ7tZRcwTKMFgQ7AjxeDDGr93Rr4dpyAwZo+78a9CPXMYusDa
 C9xvuAc2VdfzEKswySWXqGgux7o3hIwtTs3M6S8/0VIYTQ2lBHA1OQR3MGXiOTo3seG7N4ksbb
 tEazqo3xfQx0KN+RDKqZ5doovkfpHLeHKDsEr5Gedbpw6RtfqH1qsvSC5cW1MRMqL8G/MGwwHy
 Qhs=
X-IronPort-AV: E=Sophos;i="5.64,357,1559491200"; 
   d="scan'208";a="119865599"
Received: from mail-dm3nam03lp2051.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.51])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2019 20:29:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIMJ4qqsnqc2KSimFWUc22eY4iC/+ELFpTapeJWD8539ckFY8oDsbePdxp18O5MskNhkvZ3eS4Q1suT2i5bvgU849AA8RY93aep8cNCdmyH6bBmUISKx02RXvIuSGEYE5aebwkuj03QOlGcr9c0nAE6rL/Arq5GCpqnPMfQNDFrRIoktSuIy+YoNjy22qBfWMjHxsmv/lBldgP3/Q0AGynnhsnSFMZQfmY/F/hZlqlhNN3F2DscAm46ONU/arO8ysMCDpWQ0DpnH1RYEAZ0It8MHCcAB5zOavQaemVr4Nl1UUVzyKKWlXlPCmHh6ncVmTuha9kNjtgKg4p/zOaPU/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTSLCHqipwRASZPGwi5Ji5OLWMsWf3Fls9avWoQXiiE=;
 b=MdTwmBLpHT/CT5qUkYctkbMpwhLMkUuyD9V5ZU4Dzf3WxgWXVUOEYBP7GzqtP0CFXe5kK21nh7ngb4ymP2hbgJaqcoLiw/JAdhh8aCP745iiliXafckRg89CU1dbsdPdJFY5Dpb5qhem3IwpV5B176uZMbN+TROcSfgR/wynV0vDVrnjXEpX79XcBMjKtBN5R+4zI177SFuGpsrq40dQLi97mwSGh51p62xZL0WB/0AwUU92jhhrl7ewJy+O8TRyApnQThkqWuoOAaQB/btkZBCckwSTeoAhJwV1+Ok10OivuuK2foKcUmjLSDNHSJAHnywz/5BueFTwOjPYKilFrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTSLCHqipwRASZPGwi5Ji5OLWMsWf3Fls9avWoQXiiE=;
 b=ZdVcNBy9RodVzqPsMcDVcw3XoVGb3QdDLVuCW92lviSQppG4IE6PR1eOOtlKKfebN92ceIe1U7UR5/tPOPV4SOTNa7KNINzXx9x2lrL0M9rjxEKhPY6igx5ZSaKrgwUxb4csH/I+Bj2FFe35ZpSaSDojDhcg2UkoDzdejuj6/HA=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5821.namprd04.prod.outlook.com (20.179.22.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Wed, 7 Aug 2019 12:29:40 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2157.015; Wed, 7 Aug 2019
 12:29:40 +0000
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
Subject: [PATCH v4 18/20] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [PATCH v4 18/20] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVTRvI0V/1/jXIF064SLMkmSrnNA==
Date:   Wed, 7 Aug 2019 12:29:39 +0000
Message-ID: <20190807122726.81544-19-anup.patel@wdc.com>
References: <20190807122726.81544-1-anup.patel@wdc.com>
In-Reply-To: <20190807122726.81544-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0097.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::13)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.52.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccc92b7f-080a-412d-e092-08d71b32eab2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5821;
x-ms-traffictypediagnostic: MN2PR04MB5821:
x-microsoft-antispam-prvs: <MN2PR04MB58210450BCE8E7596D2C94958DD40@MN2PR04MB5821.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(199004)(189003)(110136005)(1076003)(71190400001)(6486002)(71200400001)(50226002)(186003)(53936002)(2906002)(25786009)(66066001)(8676002)(36756003)(54906003)(81156014)(7736002)(81166006)(6436002)(316002)(6512007)(8936002)(26005)(4326008)(305945005)(66446008)(6506007)(64756008)(66556008)(66476007)(66946007)(11346002)(68736007)(478600001)(2616005)(86362001)(476003)(55236004)(102836004)(486006)(446003)(76176011)(14454004)(14444005)(52116002)(3846002)(6116002)(256004)(5660300002)(7416002)(44832011)(386003)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5821;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rxGxln3aDgcGnMQ08Z9pyT4ncu9BVy8pITMgh0QlBXLbRZa1ol6JNXKXBKsk8SbfAR99EskQk1BZyMomKqfB/4CiLvCHrEhhBedU20z2pXdKK5rU3pvBJue+Pa52nqda6z/aTKvBDtC+BtJzlpIAwodHzCAq3f/6Ap6aFkaen8Us8D/nbocasBYFakZt6qWDe9uep4Qily/BfTwb/FM0heKXiYYvrVLpyYEEng+ya2HKCV91H2aYJMNMg3YhJ1UOhXsJPGF8hz85Ltw3Ix3nmfiky5c3fmfQV+VcAlTITMzlF/HrJ6UprzhiOZWHmB2dNlTZZwkRo1Fx7iX14cHEGrbbjNsTusIC6lZsxmDr/iIvxFyean6nBRoviQVX7r7UDx0SrN+reCmButpFVrxhS6m0qTGdpQGY6e/5geuN29M=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc92b7f-080a-412d-e092-08d71b32eab2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 12:29:40.0957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zhNZPEETwfM/LSUnNBLOXrxzPoivhXKh3H5hC4i9kCZYP9nJj4sKlDMfhrNRgK2plcXAb9jhu2lUawgFDsC7fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5821
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The KVM host kernel running in HS-mode needs to handle SBI calls coming
from guest kernel running in VS-mode.

This patch adds SBI v0.1 support in KVM RISC-V. All the SBI calls are
implemented correctly except remote tlb flushes. For remote TLB flushes,
we are doing full TLB flush and this will be optimized in future.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h |   2 +
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu_exit.c        |   3 +
 arch/riscv/kvm/vcpu_sbi.c         | 119 ++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 2af3a179c08e..0b1eceaef59f 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -241,4 +241,6 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu=
);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
=20
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 3e0c7558320d..b56dc1650d2c 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,6 +9,6 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs :=3D $(common-objs-y)
=20
 kvm-objs +=3D main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
+kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
=20
 obj-$(CONFIG_KVM)	+=3D kvm.o
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index fbc04fe335ad..87b83fcf9a14 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -534,6 +534,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct k=
vm_run *run,
 		    (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
 			ret =3D stage2_page_fault(vcpu, run, scause, stval);
 		break;
+	case EXC_SUPERVISOR_SYSCALL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu);
 	default:
 		break;
 	};
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
new file mode 100644
index 000000000000..5793202eb514
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * Copyright (c) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/kvm_vcpu_timer.h>
+
+#define SBI_VERSION_MAJOR			0
+#define SBI_VERSION_MINOR			1
+
+/* TODO: Handle traps due to unpriv load and redirect it back to VS-mode *=
/
+static unsigned long kvm_sbi_unpriv_load(const unsigned long *addr,
+					 struct kvm_vcpu *vcpu)
+{
+	unsigned long flags, val;
+	unsigned long __hstatus, __sstatus;
+
+	local_irq_save(flags);
+	__hstatus =3D csr_read(CSR_HSTATUS);
+	__sstatus =3D csr_read(CSR_SSTATUS);
+	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
+	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus);
+	val =3D *addr;
+	csr_write(CSR_HSTATUS, __hstatus);
+	csr_write(CSR_SSTATUS, __sstatus);
+	local_irq_restore(flags);
+
+	return val;
+}
+
+static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off =3D true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+	vcpu->run->system_event.type =3D type;
+	vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+}
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu)
+{
+	int ret =3D 1;
+	u64 next_cycle;
+	int vcpuid;
+	struct kvm_vcpu *remote_vcpu;
+	ulong dhart_mask;
+	struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
+
+	if (!cp)
+		return -EINVAL;
+	switch (cp->a7) {
+	case SBI_SET_TIMER:
+#if __riscv_xlen =3D=3D 32
+		next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle =3D (u64)cp->a0;
+#endif
+		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_CONSOLE_PUTCHAR:
+		/* Not implemented */
+		cp->a0 =3D -ENOTSUPP;
+		break;
+	case SBI_CONSOLE_GETCHAR:
+		/* Not implemented */
+		cp->a0 =3D -ENOTSUPP;
+		break;
+	case SBI_CLEAR_IPI:
+		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
+		break;
+	case SBI_SEND_IPI:
+		dhart_mask =3D kvm_sbi_unpriv_load((unsigned long *)cp->a0, vcpu);
+		for_each_set_bit(vcpuid, &dhart_mask, BITS_PER_LONG) {
+			remote_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, vcpuid);
+			kvm_riscv_vcpu_set_interrupt(remote_vcpu, IRQ_S_SOFT);
+		}
+		break;
+	case SBI_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN);
+		ret =3D 0;
+		break;
+	case SBI_REMOTE_FENCE_I:
+		sbi_remote_fence_i(NULL);
+		break;
+	/*
+	 * TODO: There should be a way to call remote hfence.bvma.
+	 * Preferred method is now a SBI call. Until then, just flush
+	 * all tlbs.
+	 */
+	case SBI_REMOTE_SFENCE_VMA:
+		/*TODO: Parse vma range.*/
+		sbi_remote_sfence_vma(NULL, 0, 0);
+		break;
+	case SBI_REMOTE_SFENCE_VMA_ASID:
+		/*TODO: Parse vma range for given ASID */
+		sbi_remote_sfence_vma(NULL, 0, 0);
+		break;
+	default:
+		cp->a0 =3D ENOTSUPP;
+		break;
+	};
+
+	if (ret >=3D 0)
+		cp->sepc +=3D 4;
+
+	return ret;
+}
--=20
2.17.1

