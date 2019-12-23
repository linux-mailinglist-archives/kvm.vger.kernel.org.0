Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83531129562
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLWLg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:36:28 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:30035 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726861AbfLWLg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:36:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577101025; x=1608637025;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SInFWrw+r/ygdwMtUL/aZCCEy20MTafcY2u413fJeWI=;
  b=E6cEicBhmqA+hEINxK+i9cQ8ij8boQiuVMSv0JX60gx08Krn4qE2WBRv
   MF7SSG8eNwAqC+VFCRraH+PPo0ikZ1DodD8u8dPyaWMlw+8Gl4NLO/pFO
   4NcA6Vvsq0wMltLKKHGbfMdfS27P9BqbKt/ir1Q1JT4+kQsvsuA2k+I4W
   BGrlRkXeEBWeQiZduA81StcoRhsivGygb4WNlr/cDe8/flKQ8p+5HCyzX
   3oyUzPr0LujcRJXMcpkgSkPML2+QZxRaccBVET9ICbKFJNVARKR0yS5kP
   ICrJHEZ2t93XpAQ/XcLE3jEjMALcMZWxBAku4P0BXDJC1KgD7esWxrE/z
   A==;
IronPort-SDR: PHa/iTdzsrBmyN4FrCWMf210kETBxIddLeL3b/L1zPRsP7LkoNQEBYdFsbiYajgkfdc9BWOvlX
 HoKZvr6Dqk50nUAF3cKdW/biOlYwgbFMs72Ez8WcoTwG1ZsUseKa8RlnMmrsbxEjWYMw85x77G
 QrdIGGB2sZyzDON/MW2EQgrO22guvdcq1m/nae7suxYd3Aib1AxAwKNI+rn5kPL1ePt4Y1Ov76
 yPZ09ccycnH2rswSTLv+4PLMn2lC/kVjLX1Q4ECutozbhY7ic1qGt7GQbAXl2kVAK/m+qXm6Ed
 sbE=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="227595156"
Received: from mail-sn1nam02lp2051.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.51])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:36:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbw/WTG9H3i7iQlN4Ok9OQXar8gK9J4pIBVsQzS3cub6PYcAsNZm6OrkS6Bfbk071KEV3ncP/YhQgZkVUubT3RwDVG8i9Gnn7/xaKR62syplWWvoVQRSwdt9TXSHNbDelPCn2/W8xFuQQrTxWuYBASBZ8x7FTrertPFE9QkMNROqSRpQtrRwoNOuvwhYrfvZxI1MzWCCo/HqLD1PB7H8GAwpIqOxoPu50uxVp3+91Vme9aLXaX2fGUruaAuwunmfVsdfFoCnefu3DbZW0OqHZT6yHvn1ObJUbBTMxfFX5uOsJmC9t8ddteEWWuGLg1ojlfDPfXBRulUGlZJngBJ0Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu2rKQFWTiSds3OtsUQH7lcDtBFu910gSz/j/JZSyLI=;
 b=T7StGcqV1qiWJ+pG+9vH26E8RFgsNSx75cTxxFmfnYGPZIvF52+zEAeVtQDNXqmJlm3clTnfIwy15NmbeVJYn53RiRJF0UEy0f1vL2APuGkMVT1r+CU0W6vpo1rO9ByAuqBs+MtQhp0sH9GhsZEX5R8QLX5sXKW1qPq4WBs1mwkGhR4hdiiOK0VJH6knNQGSs/r8YVnG+oxvEVAdqGkS2HgSwE4NdRO3Agt+AGAn/4oDAioW16XiPk3gdL57qm6RXXs+IefcWulPy61Ukad4ewZF3Y6OswLWM//W1hm7R3V3M62hmRURBdtEadpYECRCdXNPtzsGsoATyhJcUPWwCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu2rKQFWTiSds3OtsUQH7lcDtBFu910gSz/j/JZSyLI=;
 b=uviFr5kv2lvnt6XNTuOm58yEoDjAnY1qpQz0Ac+87lv17blyzrabLLcMyA5RZezo2XgrbRhkMaAwv7vuh+usjNvdgqAP1m0SYmGxokRbORpQoDzn6lZmwtSDCLxezmA74Gw2i/eOjU5wTSlUfCwSGOwW7M2DLyTw8Yb3H2sQ5hw=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6096.namprd04.prod.outlook.com (20.178.248.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Mon, 23 Dec 2019 11:36:17 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:36:17 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:36:12 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v10 07/19] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Thread-Topic: [PATCH v10 07/19] RISC-V: KVM: Implement
 KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Thread-Index: AQHVuYUwjvcujEliK0GLDXKVbckoGA==
Date:   Mon, 23 Dec 2019 11:36:17 +0000
Message-ID: <20191223113443.68969-8-anup.patel@wdc.com>
References: <20191223113443.68969-1-anup.patel@wdc.com>
In-Reply-To: <20191223113443.68969-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 32f4981e-9110-438c-9f22-08d7879c52b6
x-ms-traffictypediagnostic: MN2PR04MB6096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB60960E6E5D09E893159D067E8D2E0@MN2PR04MB6096.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(189003)(199004)(4326008)(55236004)(8676002)(66946007)(66446008)(64756008)(26005)(71200400001)(5660300002)(8886007)(7696005)(52116002)(36756003)(66556008)(66476007)(1076003)(86362001)(30864003)(7416002)(81166006)(478600001)(316002)(2616005)(8936002)(54906003)(16526019)(55016002)(81156014)(186003)(1006002)(956004)(110136005)(2906002)(44832011)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6096;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hx8emLdgLwdgu6vHts3qzB8T4knGueuC58+geIyxLTZsoF3oqIALIIIGzB6rhyiQrs5B7As56IHtsR2MrgqP54Qnoi76WvqbYdwauJqy9dRNbTREFWOr3sh5AtwcrmjmasjFeky+aqeWDWmgeVlFsaWWjE/KcvmxIrBVsI5yJLPgwlI295gZYxT69ZLIZJYjldQ4XknkyHYpbXHwDQ8ZhlFihSnTiNNJFAUoe8LzMXK1GWO8VMcZTaAPqj87ByWqeKmlG2J7lsoL+vAyJJZ0HtwQKmJBJhwHr6KYyIXWDt1gPzuP2idH2zfIGQppZAro4nxmhGskvzomp1bxAVJTnrkCJ5LD+jYjDF9VRwWFqkJg8AgvSYRbmP/VJ7je8FyZBZdlJkucTksNzsjftbQgM76RhN1mlXWLcFN8mAMY6yCBB3EIp1MTsM6DpKW/RmE0rLJAqd6IGufdA2xqbHAk080bDihZLVNCnvVgJy9rFZ/RGOEiOh6fdYG5COp1XgKk
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32f4981e-9110-438c-9f22-08d7879c52b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:36:17.4549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KAneFIgBGNncQBb1SGbTtb06xdjfA2orUeeayO3W1YKFb3+ffYB4D8GK5rWvNOac9gOMJqcHGNTnCnYntUQqwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6096
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to access
VCPU config and registers from user-space.

We have three types of VCPU registers:
1. CONFIG - these are VCPU config and capabilities
2. CORE   - these are VCPU general purpose registers
3. CSR    - these are VCPU control and status registers

The CONFIG register available to user-space is ISA. The ISA register is
a read and write register where user-space can only write the desired
VCPU ISA capabilities before running the VCPU.

The CORE registers available to user-space are PC, RA, SP, GP, TP, A0-A7,
T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers except
PC and MODE. The PC register represents program counter whereas the MODE
register represent VCPU privilege mode (i.e. S/U-mode).

The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, SEPC,
SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.

In future, more VCPU register types will be added (such as FP) for the
KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  52 ++++++-
 arch/riscv/kvm/vcpu.c             | 246 +++++++++++++++++++++++++++++-
 2 files changed, 294 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/as=
m/kvm.h
index 6dbc056d58ba..3a20327242f1 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -41,10 +41,60 @@ struct kvm_guest_debug_arch {
 struct kvm_sync_regs {
 };
=20
-/* dummy definition */
+/* for KVM_GET_SREGS and KVM_SET_SREGS */
 struct kvm_sregs {
 };
=20
+/* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_config {
+	unsigned long isa;
+};
+
+/* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_core {
+	struct user_regs_struct regs;
+	unsigned long mode;
+};
+
+/* Possible privilege modes for kvm_riscv_core */
+#define KVM_RISCV_MODE_S	1
+#define KVM_RISCV_MODE_U	0
+
+/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_csr {
+	unsigned long sstatus;
+	unsigned long sie;
+	unsigned long stvec;
+	unsigned long sscratch;
+	unsigned long sepc;
+	unsigned long scause;
+	unsigned long stval;
+	unsigned long sip;
+	unsigned long satp;
+};
+
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
+/* If you need to interpret the index values, here is the key: */
+#define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
+#define KVM_REG_RISCV_TYPE_SHIFT	24
+
+/* Config registers are mapped as type 1 */
+#define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CONFIG_REG(name)	\
+	(offsetof(struct kvm_riscv_config, name) / sizeof(unsigned long))
+
+/* Core registers are mapped as type 2 */
+#define KVM_REG_RISCV_CORE		(0x02 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CORE_REG(name)	\
+		(offsetof(struct kvm_riscv_core, name) / sizeof(unsigned long))
+
+/* Control and status registers are mapped as type 3 */
+#define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_REG(name)	\
+		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+
 #endif
=20
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 989f2be83c19..39e5f7a66e13 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
-#include <asm/delay.h>
 #include <asm/hwcap.h>
=20
 #define VCPU_STAT(x) { #x, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCP=
U }
@@ -162,6 +161,225 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu,=
 struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
=20
+static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		reg_val =3D vcpu->arch.isa;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		if (!vcpu->arch.ran_atleast_once) {
+			vcpu->arch.isa =3D reg_val;
+			vcpu->arch.isa &=3D riscv_isa_extension_base(NULL);
+			vcpu->arch.isa &=3D KVM_RISCV_ISA_ALLOWED;
+		} else {
+			return -ENOTSUPP;
+		}
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >=3D sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(regs.pc))
+		reg_val =3D cntx->sepc;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <=3D KVM_REG_RISCV_CORE_REG(regs.t6))
+		reg_val =3D ((unsigned long *)cntx)[reg_num];
+	else if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(mode))
+		reg_val =3D (cntx->sstatus & SR_SPP) ?
+				KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
+	else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >=3D sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(regs.pc))
+		cntx->sepc =3D reg_val;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <=3D KVM_REG_RISCV_CORE_REG(regs.t6))
+		((unsigned long *)cntx)[reg_num] =3D reg_val;
+	else if (reg_num =3D=3D KVM_REG_RISCV_CORE_REG(mode)) {
+		if (reg_val =3D=3D KVM_RISCV_MODE_S)
+			cntx->sstatus |=3D SR_SPP;
+		else
+			cntx->sstatus &=3D ~SR_SPP;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip)) {
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+		reg_val =3D csr->hip >> VSIP_TO_HIP_SHIFT;
+		reg_val =3D reg_val & VSIP_VALID_MASK;
+	} else if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sie)) {
+		reg_val =3D csr->hie >> VSIP_TO_HIP_SHIFT;
+		reg_val =3D reg_val & VSIP_VALID_MASK;
+	} else
+		reg_val =3D ((unsigned long *)csr)[reg_num];
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =3D
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num =3D reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) !=3D sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >=3D sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip) ||
+	    reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sie)) {
+		reg_val =3D reg_val << VSIP_TO_HIP_SHIFT;
+		reg_val =3D reg_val & VSIP_VALID_MASK;
+	}
+
+	((unsigned long *)csr)[reg_num] =3D reg_val;
+
+	if (reg_num =3D=3D KVM_REG_RISCV_CSR_REG(sip))
+		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
+static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) =3D=3D KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
@@ -186,8 +404,30 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-	/* TODO: */
-	return -EINVAL;
+	struct kvm_vcpu *vcpu =3D filp->private_data;
+	void __user *argp =3D (void __user *)arg;
+	long r =3D -EINVAL;
+
+	switch (ioctl) {
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r =3D -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+
+		if (ioctl =3D=3D KVM_SET_ONE_REG)
+			r =3D kvm_riscv_vcpu_set_reg(vcpu, &reg);
+		else
+			r =3D kvm_riscv_vcpu_get_reg(vcpu, &reg);
+		break;
+	}
+	default:
+		break;
+	}
+
+	return r;
 }
=20
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
--=20
2.17.1

