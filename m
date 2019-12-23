Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0DB129586
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfLWLhf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:37:35 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:30144 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfLWLhe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577101060; x=1608637060;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s19LqAAiCQ0Am5ZHPdERR7cYkGZL6XJU9sLHCFmJWrQ=;
  b=HHSZViFxO/6TwohhOLmOrK/AKqJ0xCXCsPIt3rIucoDmfrkCyJHevb5R
   SWPjTEc4XTbN1KCDxUc7sJ5DP3UPRDB25wfeoIKyH6npKPL52YCmtt9UE
   LR2dFLysS+UahZBPQdVODJrAO1IvsV4+HF9csmXbm7On9uhd21uKj1xpW
   ayy7RMO9xrxe3kg00uLO9BjRhgciLH9WnvyLJmf+TSgCoAhZPYdtw2Y0X
   CgONGn0blJNe2sOAUkPRnzvv/bwuh1vrdcT4mOu1iHoxEhJzIN9ALcjDL
   Etziq8e7YfSBOF7tr+cGQM5smpbDwtAr2/VpHVGh/v3GXeuzZrb6We/a7
   w==;
IronPort-SDR: 8nkqGn6L2vnc6EDAvsNs3HbKX5SfjA6vOOR1/78K/9GOXV3ym9TeXGy64H11qhzkMkm5sQp729
 ELp6mVKL/jg1ul0DkLIrX/1yxeYUvTnxzjYDw8kCCkpBQPfH9F3rCqsXetoBi7ydck16dqDGSN
 6/CXHuGTQHj8aO9WdWHvuf2fdyP2WPmahJbiWcOGSF/+eft6djRk65v/rNfDT/LAhbOi3V2gVC
 6i6U4cUJA5FszZ9b2IpH/3C2O6a7TS6lFC0COMbX/X8Gl3haJ7PERrCV7/jfApXTFyC7F0RHIP
 ZeQ=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="227595236"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:37:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQHErEEsLoqdtFQGPK6AYdt7NptoNkaLjNf5p+AXZXYBCrRLynpYe9iLscSkFbPN4WIX9HSWpB3GDrfFXRctJUn5SmeTAxiepwtHsDNbnZN9dKmnRWksyPRA6giayMmurkDgBhg8/V4wUsPzfOsUwu/kaRxTLNzKU2ofrrvTNNDyabBBR5o2/f2VeNOJGqGQ7rqe/91+fK4hkVe5UJtrv/Pu35HOLy8v/27q9ujdviTYrMn9/AsSFiFnGcIYJ3u1NyL31EXTErVuxLbTuT1SggPnTVetkznrZwQYXbStHUa8/jCNx+kBK4jU0JwSsITVUOuCEuSGPPrhEhACjHzuMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEQQw+o3sgy8bMnrMjMzFN2pN3pbVmfXvveqv5rerwQ=;
 b=JDOwXdytmWE6RLAPydXLcb4hvaifnvxLJH6lKNyBkJVRsmFg1bErjxY/IbtoGSC1WAP6fiGU6vpjjV2Kih1CJ8QN9re30q1FaYp4Vf6Q7EYDUhAJL10GDDDS9TEwS2ecJGWZQP0NFoNYPclJeuQZuwH96bgodr6pPwBbXvdxwtFSKRJmASllmPtp5o7xYH4m4/q+aDZSMND8sQ8plnMT3GrbvWc4g/BMgZdRYn/dpyHlHmkPbEJ3Urq0lFQ4Gr+COKMD3Tt8nxdE5g1SNB14LIgxr9nekbMisCKUTeorWvpc025s5pSgR6e880wahDLOD4Y7N2ZGT+h/hxTloyyiZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEQQw+o3sgy8bMnrMjMzFN2pN3pbVmfXvveqv5rerwQ=;
 b=DqAqCM6Map4eZGuBxBlR1clZ5IGo6HDkyYU3RYSR+Gu3dt/iDMwFcarw0PLIJH/f4lKvzPDbX5DBNz2l0tHwQHoSwNPN1J7NBpfH8MZp1Xv/gAeELeURG7siMrjzG/5iAWJ8a6CqXVdWJ2pUrLP816kLGvEzG1B7zJv+GxM8KIk=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6480.namprd04.prod.outlook.com (52.132.171.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 11:37:31 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:37:31 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:37:25 +0000
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
Subject: [PATCH v10 17/19] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [PATCH v10 17/19] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVuYVczyS/Qp+ER0eimfSGrXcT1Q==
Date:   Mon, 23 Dec 2019 11:37:30 +0000
Message-ID: <20191223113443.68969-18-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 69e19262-a5be-4222-9c29-08d7879c7e97
x-ms-traffictypediagnostic: MN2PR04MB6480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB64803A38AAB291F2E25B9AF68D2E0@MN2PR04MB6480.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(36756003)(2616005)(956004)(478600001)(44832011)(2906002)(55016002)(7416002)(52116002)(7696005)(66446008)(66556008)(64756008)(66476007)(4326008)(6666004)(1006002)(66946007)(8936002)(26005)(1076003)(54906003)(110136005)(186003)(8676002)(71200400001)(81166006)(81156014)(55236004)(86362001)(16526019)(8886007)(5660300002)(316002)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6480;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HmXPb78KzdzUZk/NpJJwwkSlB8RfNlRXOMgGvv4GzyBXBRnuH6kW70TpaR/mHTgi+c58agGDMTq9GznbVZGFvSjOxBfG+Q30RKfzAjXtz8upwwaKyeYKQ3Tsca968pdtJPcA/jahLRV5iPSlsRLVd0LGrxthInb6/FC+F+EGS9JZhzsmedX9qHLkvVkiWc81q2uaQK3EJRxmii8a74Uo2YNZWqepsUrGMPkefMo5W3dkkmnBDapE9llJXSb34HGu5w5bMIob8/yiWoPVFYmDNr0pZGvqLabTYWU0ScIEwrCtnzZy9MBfsFECvfPzXV5GsQ0cGj0+2dASQlSni9933omf+IObUV95MnM8oHmDo63ApMX1PuayxciBDI4lh+oECz07/zpMaJHKaCSFEEmOJRX69N/fVnRqEyPTcMA724HEaRBED87E2MjtFhGugc4T5AvtHwBj9kPtLO71bq9ehpiUhpwNjZHgk9gSsH2NXsCAf7T7JPKqZMHJybR/ERwS
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e19262-a5be-4222-9c29-08d7879c7e97
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:37:31.1543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3amzyAJMyhLleWTXhgaK2Yo2WTFyePgLL3b9ePUjjr9M+Yqw8dISB3PY3kEe3qUPGUDZX1g5Nirz83vQqq+BSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6480
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The KVM host kernel is running in HS-mode needs so we need to handle
the SBI calls coming from guest kernel running in VS-mode.

This patch adds SBI v0.1 support in KVM RISC-V. Almost all SBI v0.1
calls are implemented in KVM kernel module except GETCHAR and PUTCHART
calls which are forwarded to user space because these calls cannot be
implemented in kernel space. In future, when we implement SBI v0.2 for
Guest, we will forward SBI v0.2 experimental and vendor extension calls
to user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h |  10 ++
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu.c             |   9 ++
 arch/riscv/kvm/vcpu_exit.c        |   4 +
 arch/riscv/kvm/vcpu_sbi.c         | 171 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   8 ++
 6 files changed, 203 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 56a8ab9772ae..a7ad0a8f5604 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -77,6 +77,10 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
=20
+struct kvm_sbi_context {
+	int return_handled;
+};
+
 #define KVM_MMU_PAGE_CACHE_NR_OBJS	32
=20
 struct kvm_mmu_page_cache {
@@ -179,6 +183,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
=20
+	/* SBI context */
+	struct kvm_sbi_context sbi_context;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_page_cache mmu_page_cache;
=20
@@ -251,4 +258,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcp=
u, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
=20
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
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
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index a2547517680e..b1ccbbbf679c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -883,6 +883,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
 		}
 	}
=20
+	/* Process SBI value returned from user-space */
+	if (run->exit_reason =3D=3D KVM_EXIT_RISCV_SBI) {
+		ret =3D kvm_riscv_vcpu_sbi_return(vcpu, vcpu->run);
+		if (ret) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			return ret;
+		}
+	}
+
 	if (run->immediate_exit) {
 		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
 		return -EINTR;
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 8d0ae1a23b70..ac97a72bd29f 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -616,6 +616,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
 			ret =3D stage2_page_fault(vcpu, run, scause, stval,
 						htval, htinst);
 		break;
+	case EXC_SUPERVISOR_SYSCALL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu, run);
+		break;
 	default:
 		break;
 	};
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
new file mode 100644
index 000000000000..5b26a1793108
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,171 @@
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
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_timer.h>
+
+#define SBI_VERSION_MAJOR			0
+#define SBI_VERSION_MINOR			1
+
+static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
+				    struct kvm_run *run, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off =3D true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&run->system_event, 0, sizeof(run->system_event));
+	run->system_event.type =3D type;
+	run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+}
+
+static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
+				       struct kvm_run *run)
+{
+	struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
+
+	vcpu->arch.sbi_context.return_handled =3D 0;
+	run->exit_reason =3D KVM_EXIT_RISCV_SBI;
+	run->riscv_sbi.extension_id =3D cp->a7;
+	run->riscv_sbi.function_id =3D cp->a6;
+	run->riscv_sbi.args[0] =3D cp->a0;
+	run->riscv_sbi.args[1] =3D cp->a1;
+	run->riscv_sbi.args[2] =3D cp->a2;
+	run->riscv_sbi.args[3] =3D cp->a3;
+	run->riscv_sbi.args[4] =3D cp->a4;
+	run->riscv_sbi.args[5] =3D cp->a5;
+	run->riscv_sbi.ret[0] =3D cp->a0;
+	run->riscv_sbi.ret[1] =3D cp->a1;
+}
+
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
+
+	/* Handle SBI return only once */
+	if (vcpu->arch.sbi_context.return_handled)
+		return 0;
+	vcpu->arch.sbi_context.return_handled =3D 1;
+
+	/* Update return values */
+	cp->a0 =3D run->riscv_sbi.ret[0];
+	cp->a1 =3D run->riscv_sbi.ret[1];
+
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc +=3D 4;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int i, ret =3D 1;
+	u64 next_cycle;
+	struct kvm_vcpu *rvcpu;
+	bool next_sepc =3D true;
+	struct cpumask cm, hm;
+	ulong hmask, ut_scause =3D 0;
+	struct kvm *kvm =3D vcpu->kvm;
+	struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
+
+	if (!cp)
+		return -EINVAL;
+
+	switch (cp->a7) {
+	case SBI_EXT_0_1_CONSOLE_GETCHAR:
+	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+		/*
+		 * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
+		 * handled in kernel so we forward these to user-space
+		 */
+		kvm_riscv_vcpu_sbi_forward(vcpu, run);
+		next_sepc =3D false;
+		ret =3D 0;
+		break;
+	case SBI_EXT_0_1_SET_TIMER:
+#if __riscv_xlen =3D=3D 32
+		next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle =3D (u64)cp->a0;
+#endif
+		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_EXT_0_1_CLEAR_IPI:
+		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
+		break;
+	case SBI_EXT_0_1_SEND_IPI:
+		if (cp->a0)
+			hmask =3D kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   &ut_scause);
+		else
+			hmask =3D (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (ut_scause) {
+			kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause,
+						     cp->a0);
+			next_sepc =3D false;
+			break;
+		}
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, i);
+			kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
+		}
+		break;
+	case SBI_EXT_0_1_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		next_sepc =3D false;
+		ret =3D 0;
+		break;
+	case SBI_EXT_0_1_REMOTE_FENCE_I:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
+		if (cp->a0)
+			hmask =3D kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   &ut_scause);
+		else
+			hmask =3D (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (ut_scause) {
+			kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause,
+						     cp->a0);
+			next_sepc =3D false;
+			break;
+		}
+		cpumask_clear(&cm);
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, i);
+			if (rvcpu->cpu < 0)
+				continue;
+			cpumask_set_cpu(rvcpu->cpu, &cm);
+		}
+		riscv_cpuid_to_hartid_mask(&cm, &hm);
+		if (cp->a7 =3D=3D SBI_EXT_0_1_REMOTE_FENCE_I)
+			sbi_remote_fence_i(cpumask_bits(&hm));
+		else if (cp->a7 =3D=3D SBI_EXT_0_1_REMOTE_SFENCE_VMA)
+			sbi_remote_hfence_vvma(cpumask_bits(&hm),
+						cp->a1, cp->a2);
+		else
+			sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
+						cp->a1, cp->a2, cp->a3);
+		break;
+	default:
+		/* Return error for unsupported SBI calls */
+		cp->a0 =3D SBI_ERR_NOT_SUPPORTED;
+		break;
+	};
+
+	if (next_sepc)
+		cp->sepc +=3D 4;
+
+	return ret;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f0a16b4adbbd..b6a90dd8f779 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_RISCV_SBI        28
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -400,6 +401,13 @@ struct kvm_run {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
--=20
2.17.1

