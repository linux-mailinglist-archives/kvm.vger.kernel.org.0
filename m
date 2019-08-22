Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C94A98E45
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 10:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732716AbfHVIq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 04:46:57 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41710 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfHVIq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 04:46:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566463617; x=1597999617;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uYpvIL6ndES95HKLR0l8blOeFE5Qlv2xB6BJhN0Ji8s=;
  b=N6jseTiVoiJlvMVsN2KELoYseEMwO9OWKK1q6pEAFnYHop/RqoPlpFzL
   KUF1viuxbdPiU3hiw6g3Yr7dnbeBYtTg8rKAnM1QGFPdsCLEhRu58Hbem
   NAOL+cejvKmaenROBDtdDcR+LgCaGNzvAe/yhtL+uKZJhMJUVWRQpg/Sc
   a81uH3OUgtDlHZ6VbIceCcFQLQIJ6HOr9LTqb7AsgYlV0yGRJgn/Sv8qF
   bFG5xtmMGFcNDshtcgdoSWuDA2ACSUJkiVMPaM2UoujHU2pc8gqEDe99z
   ojfhyfT0gLl/WBHQu4uZEp12tx8gTHtwGfBoDEFnUb/BZ4WuNSeTGa0d1
   Q==;
IronPort-SDR: d4Ys+SAI7GFPnnfqUKqdU4QnPejjEu8ZHZn9KYuqmQiIfm5rsuSXllIhUU3I+sJ6hkj0wBys8s
 Yl9oohVZKFFQv5X2PvM64lDJDBFisEVozB9ByaWI0JhTxlllWqsOqp6pb2wfo+7zxQ2L3qOYMZ
 ZTd/rMAW7KrTmGVWUr3yrofA/dpjsypApE44Kly17nR/DRa35+13xWqzXY4gcLtRF08zZGTtpL
 0FJeaixqY9fN4RsCZvrcJw1tZPfw6djhAq18NHgADNY6brxoYs+mMev/mWRP2jKr2/PPJrLkOe
 BGk=
X-IronPort-AV: E=Sophos;i="5.64,416,1559491200"; 
   d="scan'208";a="118000201"
Received: from mail-bn3nam04lp2052.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.52])
  by ob1.hgst.iphmx.com with ESMTP; 22 Aug 2019 16:46:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+n6I4ZMNXCEeTlfug9NYoUVTRR9nJZZYjJkXMqIJxBLSsQCY4sPYvwpu3kZo6fTupUnHBMJjR5H4rKdQ4vYbmY+LCNS/FAs6Zj0nKP09SXuydKm3Aoha+RMFNR8IEjDTIWZzVNXSuMMBtL/6TQe52uFOOutScHiV2ZfoDLbg51xilqVepQiLd+qznj4EcRm7g4EtvbTwgcKIlxF4rDTCLxNZteYJP1828ALuCGmtL95djlrp+ZDGfDlmTD2YWYhn+wVI4/SzIbWtoeY6YBzkpDe5tcygAonOlwar4AkMpGNDky+L57RYGSgPH9ddLmd+DRfjbF+ZYjZKCObZYXicw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUp94i1yj8RK9kYLt0v4cN0+hl7Y9xQm3n7Bbg0IzG0=;
 b=BJ7Ue+eUTAfZSnEJ3+sp8dJvYmBnuZyI0pJxWFlLdpb1yOuRll3V8bsm7k+6OSfiHSqkUe4NYYY+qLc4Kf5JkLuzLdTCeY2BfO9UGIWyQvdbYIVzcOwPS6fPynjXyjxBoOU+yRME0WxHDqY4qsYz2oRnwhlsWiz0rUYOz9esj6DTDPwis8J294osQJAuaPWEgNNAnyV03LMQMl3c4H8JDjwVVWQtHZHTg3fb5ApcFfgo0lzf+ASYvnh8rGoRCNfgZ2nLzPH1ONPenAnn/fiTCva7suo6x2TwenZH8Cy5EPuAn6bNEqMZQBQxE3UBIsX/fsst6kMNCtkiFI8nnLdoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUp94i1yj8RK9kYLt0v4cN0+hl7Y9xQm3n7Bbg0IzG0=;
 b=IvihsfXzyihCXS2CMlyEAo6GDHWB1YqfJQA4IyKZ23lTmz4639yQuaGY1+3T09jNk8v2vrkxO8k6rhUJCIE7+mgN5kKKE13AlJJ0nI/AfeRZIbKS710VkHjS5ea+0jXWoM4P3f9n373H6l/3kUiBJ9C+ijuuPqTQoIrqoKlMfzA=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6048.namprd04.prod.outlook.com (20.178.249.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Thu, 22 Aug 2019 08:46:50 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2178.018; Thu, 22 Aug 2019
 08:46:50 +0000
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
Subject: [PATCH v5 18/20] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [PATCH v5 18/20] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVWMYj7BIk45hJRkG+kdNzYgsvYw==
Date:   Thu, 22 Aug 2019 08:46:50 +0000
Message-ID: <20190822084131.114764-19-anup.patel@wdc.com>
References: <20190822084131.114764-1-anup.patel@wdc.com>
In-Reply-To: <20190822084131.114764-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0118.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::34) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [199.255.44.175]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc613a84-cf84-4556-aedf-08d726dd45cf
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB6048;
x-ms-traffictypediagnostic: MN2PR04MB6048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB604827DB8B2D4B61C536AF058DA50@MN2PR04MB6048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(199004)(189003)(6116002)(6486002)(3846002)(54906003)(316002)(76176011)(52116002)(2616005)(50226002)(446003)(5660300002)(1076003)(8936002)(8676002)(81156014)(81166006)(11346002)(478600001)(14454004)(53936002)(110136005)(86362001)(4326008)(186003)(26005)(66066001)(66476007)(25786009)(102836004)(7736002)(36756003)(6512007)(305945005)(386003)(6506007)(99286004)(71190400001)(71200400001)(7416002)(486006)(476003)(6436002)(66946007)(44832011)(256004)(66556008)(64756008)(14444005)(2906002)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6048;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Txv0A7WcNpWLGLPzC+E5wsJl/v3C0i03+KJYFsE1lnygYhgSdhJLZspro/TBYKdJxVhuTNZ1J38+8rDPkLra8OSmoG/Acw+SjgbYxLfxsAsMWYRKx224ZEbjbqXnVW0HjiCL+nqQMI/JyIMq0knS89WeGuV1hTgWT6dgnDJ7+Aq3yRIsvEFGbL8bRQhxdTPg5iPxxihCfXUxj+ALflO+AgGAim58BuDBMBFvTIiucvJSr/s9RovgEwAeAfukWcC+7AxarNomvK2sSCbM6rXAFsO5VBGW+rEYkYUWDMP2WoI0GP8ET9PaBvMs8i5Zb2uBbepOs8O03oS+KdZzC7OiGymmpC2N/8tp7re0xeo4XVKwS6etgm8q6itha/JdmgkKsmajE6lkoWL/6JnLxEQ55JLR0zJ4jQASVcehJYD1MpI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc613a84-cf84-4556-aedf-08d726dd45cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 08:46:50.4836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: he8AT9LOOqwyBZ48PrH/Y5SampBVH0OEh5609Hj5oDdy66SAE8RZ7X8IFUxVpsa/1Dkpj8eTENdvtenRlr6trg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6048
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
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
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

