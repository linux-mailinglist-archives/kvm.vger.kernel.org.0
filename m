Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA83C97CD
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfJCFIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:08:39 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16241 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbfJCFIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:08:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079325; x=1601615325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ESFHtviBea+JR+gBup4Tgcx2jwQAoeXMFh5jibdHh6Q=;
  b=EmKl4N8BQCUOeqPnDlzWl3LhLifq4yvz1ZJOTs1FlD5LN8M5nbcjlpUR
   VmGUW5fPronwnU7lNXFPycL/kGTpPET5beqp/2qWaz5K4WbNg+XbC37i8
   RfuHx//+Rk/1yEFH0JrQgPD49S9mte3hbXgR/yy4/aM0XM0v0BDAnf8zG
   ZREQAeLngAWdJg5TkMBferz9DiHi05JDXMlgDdivrnmTm3QofbG4BaxHK
   URwi3dWR/Hyqc4CVwqK1eKaDIVokutFVmrC/S1KO45NQ9PwcOtuVMLpnu
   o+96F6GI/gfbdntD/ogMF7hfwg7MkPKqyJYl1+lWRvUnW9eOSmzYSlxHA
   g==;
IronPort-SDR: hoJAlWN+pPo5uM1NzZgWV++uVVU1NZb2FiaYwX/S0D3aRxZba2eZ9OBIMt8DtvKu3keF/7lUie
 grRGBWw5JV1YTp1WOL099jLCjYWxU6ss3unuxBupEOFFi5Bm9y1QtoPTHFaPdDqkOfAupzekqb
 +vxYkJR4GnTpeTnHHbnHusZodofSONMgopdEV//eIvztvqDBEHQjpRcDJzGMJC5ioTozXnxnN2
 kLvZntpHu9E6ONMX3tTEjdk43iRSPFz0PrZUIg+E/VTC3cSm8C/Rx0KTJKrMuSZymKqCb1AVia
 4aE=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="220620950"
Received: from mail-co1nam05lp2051.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.51])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:08:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3UjjqBaJvcWwOzl8B7Y4O/ZtynApCmASyDc6F7JYEs1maVXpPNLT790nPCjf9ntMtGVAJGK+Qhmv63mK3VpoZr8AABT9QjcXNP99YBjIObIlYPvIPE1MgrMqnoWtyDTJ5/n6Vo3H55Ys/NPEIa4wbuJtoYWl9bU4/yENClNMBt7i/8ZEdV60iEV2HrVdFQi+UI1vC2KD4njsT15bnAljXZ9ied92ozvbrq0QR8RmXj2mUiHOVppV6kXz4YJ5uQZF0WTOkWUD0NOoWus8vKWCP8dVE8rj/FZDD5+9RVTcQjTFmk/sG2ftwB9dSECBAx0J40d2t44fKq6UfMT3x0yaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpSpk2hHGYy+s9hLvF22G4ZffHrpeex2nXK6niW88ok=;
 b=nYZE2HslKfueoedg23WLztHOmbiPvb7OGAx7MHw9vzJTee4ZkqBWJyYoU3wj4hLWrPRXXUeZHiVeKumD5FXKZb5Tx47NwWpNvPSuz0d+2pS++5WX934qUESnx9dueHrzQlJ+woAwDtlRSbIc2EcuQsGbY9x9AMEkmjRglfjRFPGG/t6yJMtuWE0veDsdoq6DA/TA8GMLY3Qcnu2DEQnc3DYy0k9X3vPr3EZ38xLjZY3U3ea5ZKcg9Hd/HsY67Y/s2xp7BTFkPJIb2c///pUHafXKHTmOdqNy7O+sVmLM1stUKSY1xaYUT1jo+61neGSHWH82KzWufIoSGBvuHr6EwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpSpk2hHGYy+s9hLvF22G4ZffHrpeex2nXK6niW88ok=;
 b=znTjhndw93gJDRjlBd9BFTYGJ6JgG2AwgP4XviaiNXLzjOlhDAFZdGnIt0TLnna+FNvbkKMiUpqT2BkcJP8L4qTQNT9KRFRmjCoe+0zhJ+rVBxLKCurJjI906Stl/K7V064sl+7jKWj2dcPfhqXV6ZmkCaOpfpQfZhuG4DjoIS8=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6272.namprd04.prod.outlook.com (20.178.248.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 3 Oct 2019 05:08:35 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:08:35 +0000
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
Subject: [PATCH v8 17/19] RISC-V: KVM: Forward unhandled SBI calls to
 userspace
Thread-Topic: [PATCH v8 17/19] RISC-V: KVM: Forward unhandled SBI calls to
 userspace
Thread-Index: AQHVeaibrnyZ/lSFMUO2gp5hDHHZAw==
Date:   Thu, 3 Oct 2019 05:08:35 +0000
Message-ID: <20191003050558.9031-18-anup.patel@wdc.com>
References: <20191003050558.9031-1-anup.patel@wdc.com>
In-Reply-To: <20191003050558.9031-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [111.235.74.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb090c41-6fec-4b4e-7bec-08d747bfbe3b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6272FAE262006D61144A50578D9F0@MN2PR04MB6272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(6512007)(6486002)(81166006)(81156014)(8936002)(6116002)(3846002)(8676002)(50226002)(2906002)(110136005)(66066001)(6436002)(316002)(66476007)(66556008)(7416002)(66446008)(36756003)(1076003)(5660300002)(54906003)(7736002)(305945005)(76176011)(25786009)(52116002)(256004)(14444005)(71190400001)(86362001)(99286004)(71200400001)(2616005)(446003)(14454004)(476003)(102836004)(186003)(26005)(11346002)(44832011)(6506007)(486006)(478600001)(4326008)(66946007)(386003)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6272;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QUnN037z1zdnbRbMAoTBMjyjkAKrKzXp5Mp/Akia71NO8wX2Ej71UkqNbtkbByCEukd1zczeUfTHJUqB6uK5yVNPYlOOdh4kVNHExhYTaE621XjMWpWeH7i4miU4sjjyMGSzU757mz+j/OzcO1G2+erbAya58cTsa8N4A2ozPw1go6TFoDXHHdYAH5ekGWkBky+lv8RgvHvFux7kxxa9oJBSPoxPoF7rZwz+lrU5eiv2sEnV2u3v9SabzvLHJ8RX2qV1wRD1lgw0+LrmxmHR4UrtrvN0pfjTh8R1tdJdkyjZz2apVYXz+ag0UPVFIKvfKLJ/DPyNNaEgIJrb68RP33zZYN7+KXVH/epw8t/ksY98bEakI03ig5qph9LKQ8M2dvI4UExySo5nP0LgZ8uj/jBLkdoIAFRhYcyVyDrbcL0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb090c41-6fec-4b4e-7bec-08d747bfbe3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:08:35.5847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Who5KASXGs/UHa6SDj6drdHPcRLgszkzdWsk0Hk/jIdkL0UNF9fLkfiJGT6df6IbFf5WAb5ni4usb1zAofW/tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6272
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of returning error to Guest for unhandled SBI calls, we should
forward such SBI calls to KVM user-space tool (QEMU/KVMTOOL).

This way KVM userspace tool can do something about unhandled SBI calls:
1. Print unhandled SBI call details and kill the Guest
2. Emulate unhandled SBI call and resume the Guest

To achieve this, we end-up having a RISC-V specific SBI exit reason
and riscv_sbi member under "struct kvm_run". The riscv_sbi member of
"struct kvm_run" added by this patch is compatible with both SBI v0.1
and SBI v0.2 specs.

Currently, we implement SBI v0.1 for Guest where CONSOLE_GETCHAR and
CONSOLE_PUTCHART SBI calls are unhandled in KVM RISC-V kernel module
so we forward these calls to userspace. In future when we implement
SBI v0.2 for Guest, we will forward SBI v0.2 experimental and vendor
extension calls to userspace.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h |  8 ++++
 arch/riscv/kvm/vcpu.c             |  9 ++++
 arch/riscv/kvm/vcpu_sbi.c         | 69 +++++++++++++++++++++++++------
 include/uapi/linux/kvm.h          |  8 ++++
 4 files changed, 81 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 74ccd8d00ec5..6f44eefc1641 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -74,6 +74,10 @@ struct kvm_mmio_decode {
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
@@ -176,6 +180,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
=20
+	/* SBI context */
+	struct kvm_sbi_context sbi_context;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_page_cache mmu_page_cache;
=20
@@ -250,6 +257,7 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu=
);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
=20
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
=20
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8f2b058a4714..27174e2ec8a0 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -885,6 +885,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
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
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 88fa0faa3545..983ccaf2a54e 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -31,6 +31,44 @@ static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcp=
u,
 	run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
 }
=20
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
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
 	int i, ret =3D 1;
@@ -44,7 +82,16 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		return -EINVAL;
=20
 	switch (cp->a7) {
-	case SBI_SET_TIMER:
+	case SBI_EXT_0_1_CONSOLE_GETCHAR:
+	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+		/*
+		 * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
+		 * handled in kernel so we forward these to user-space
+		 */
+		kvm_riscv_vcpu_sbi_forward(vcpu, run);
+		ret =3D 0;
+		break;
+	case SBI_EXT_0_1_SET_TIMER:
 #if __riscv_xlen =3D=3D 32
 		next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
 #else
@@ -52,10 +99,10 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
 #endif
 		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
 		break;
-	case SBI_CLEAR_IPI:
+	case SBI_EXT_0_1_CLEAR_IPI:
 		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
 		break;
-	case SBI_SEND_IPI:
+	case SBI_EXT_0_1_SEND_IPI:
 		hmask =3D kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
 						   &ut_scause);
 		if (ut_scause) {
@@ -69,11 +116,11 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
 			}
 		}
 		break;
-	case SBI_SHUTDOWN:
+	case SBI_EXT_0_1_SHUTDOWN:
 		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
 		ret =3D 0;
 		break;
-	case SBI_REMOTE_FENCE_I:
+	case SBI_EXT_0_1_REMOTE_FENCE_I:
 		sbi_remote_fence_i(NULL);
 		break;
 	/*
@@ -81,21 +128,17 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, st=
ruct kvm_run *run)
 	 * Preferred method is now a SBI call. Until then, just flush
 	 * all tlbs.
 	 */
-	case SBI_REMOTE_SFENCE_VMA:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
 		/* TODO: Parse vma range. */
 		sbi_remote_sfence_vma(NULL, 0, 0);
 		break;
-	case SBI_REMOTE_SFENCE_VMA_ASID:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
 		/* TODO: Parse vma range for given ASID */
 		sbi_remote_sfence_vma(NULL, 0, 0);
 		break;
 	default:
-		/*
-		 * For now, just return error to Guest.
-		 * TODO: In-future, we will route unsupported SBI calls
-		 * to user-space.
-		 */
-		cp->a0 =3D -ENOTSUPP;
+		/* Return error for unsupported SBI calls */
+		cp->a0 =3D SBI_ERR_NOT_SUPPORTED;
 		break;
 	};
=20
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52641d8ca9e8..441fd81312a4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -235,6 +235,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_RISCV_SBI        28
=20
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -394,6 +395,13 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
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

