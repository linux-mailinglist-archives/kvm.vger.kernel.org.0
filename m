Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2227D96A2
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405961AbfJPQLf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:11:35 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35035 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405972AbfJPQLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242295; x=1602778295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C3GUJdBwVCbHGX1wubvwKyAEkqUWvJnaoUpMqi7vbH0=;
  b=icCah0OFpxj30thPxV+3Him57PwKzAvx2KG2AdlAJFc8tt7FhgItwqUY
   NoALWYj9DLhq0hsExDcmfhdIvsCY90pwdr/Zq8Q9xAN5ZnhfNvhogSR3J
   +0ka8RfMEMK9idFBW+eZ7JHSwvHIftS0xPbQFfJAMAdaEGDA2Hnbzt35l
   k3hSeLwBXMJ7FXg+JjRhPEt0m7a8lXWNKb89SgCM2UIncKAdvsuElG0D9
   EGbgeRPVt2+5+QMOCzC3rP6S6F6jDzhMhqUUCbs1hqFE4faa+WzTqSFD+
   2M3hiDPPQu73OrHgUGujMU4j6dz3KXhAXpWbKrRCKYvKROi7Vs3xKlCuI
   A==;
IronPort-SDR: 7Dy+rFfv4j8918b+rPEMEPPDfRA1hWWxFwIyqLj7fkmxSzOHeldcP5Q+AoE/XYTaissmQjvFLg
 FsZCFbjhJbtMSTzN1+6TtYhn2oLaIYJek4F3eXlx0sofzUSSCIYQ+Bt1ShyF8KfhpGCDhy0UGh
 XHjKrUOZBKFZtoFZSMM6ST9jQp2zd8UxK7+ge7sJ7K0wirNbOCEGhDahOkhhX17gmwbI0KFgOR
 xxPUGvx48ngGu/90G74WKbFHFidm81aSulv1GffULTpwf5Fho9QZig84dJuPT1QjtwIOBuVjbZ
 uvs=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="122255659"
Received: from mail-by2nam01lp2057.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.57])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:11:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y+jQB7hObtM3fY6XkES33UG07ZJS87CMXJ6B/gdYoD2gCGkDPL+jr8Ij5Dh87i50hm4895/HUBNY4TGoE779P3LQeVVxhkuell4PLMOFmsVlTlLcdZ4cYLp3l1NwM9uJTw9sgcQeLD/24Snn3LyEssceTC0zpCNInM51jbWiX2X3hXKzl348/9td3GB8j73HyvcGMNSA+kggdhrObE67zuYvx5SrIPFjdYwhhVXubUEKw7exmiQT59JNrVuETzKnSnxXVZimK54zk6noWOMbPaBqolgKXr//cd/HXrGhAnQBKo/QLTVDm7+2oRxVA9Fs3OY46He/pntb7zgUhipMTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHxpYu9NFS3nQRUQJ9lBnb+tHQ2T3lavzappgyWIWyU=;
 b=WC2269FScipgpL9SlvVcgptS3l5nQ1nj0jNCxVWRp0j1tX5hPbF158U3sfIndkbaqSe0zLtAnroT+NhJeOJyLNK4pD/eGjvayqjZGclfZr9chc4nNZmljknDv+tLiOFkw+ChBPzyurQ2J7TjNNnB7jXnHNNgs1p576de17hFksvgrfqqvzTe7Z264lcVEQt3yxEqnpvAKOvEUKBesHt3mDe8PTMJH+v0RqAkDmsyrv4oEhzUfp8lvErvxPmpguMpcyKpsJJw1Umcr+nqOv+mNdmnCKB9xtGNFpcw+lR2mQzJDfiPtNiQUZLfnNc8KW1OlxXjyezi9qCK70lKuSzG0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHxpYu9NFS3nQRUQJ9lBnb+tHQ2T3lavzappgyWIWyU=;
 b=sl5PeRG9Usjy8FBzQroLKufs2OoapL4HuwK3whsD9Iz3pHAjCgS3VUWqFrT2gPqvUAY8tIaWxxjfwJyrzgRwYLdAjHBu0orsTfdt9RjDXbduG6tMBkGfWHDWfObG9GWAkgpqIV9OZGv+NqBDRWMg1OqrlSHq95/gDu+y9xSzk5M=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6397.namprd04.prod.outlook.com (52.132.170.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 16 Oct 2019 16:11:30 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:11:30 +0000
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
Subject: [PATCH v9 17/22] RISC-V: KVM: Forward unhandled SBI calls to
 userspace
Thread-Topic: [PATCH v9 17/22] RISC-V: KVM: Forward unhandled SBI calls to
 userspace
Thread-Index: AQHVhDxfUvetN2L4mUy34GHS0wzU/A==
Date:   Wed, 16 Oct 2019 16:11:30 +0000
Message-ID: <20191016160649.24622-18-anup.patel@wdc.com>
References: <20191016160649.24622-1-anup.patel@wdc.com>
In-Reply-To: <20191016160649.24622-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.27.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75f027fb-ec7d-440e-a537-08d75253816a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB63977A43B347865ED23D8B138D920@MN2PR04MB6397.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(199004)(189003)(71190400001)(71200400001)(66556008)(66476007)(66446008)(64756008)(66946007)(6116002)(3846002)(14444005)(66066001)(76176011)(52116002)(256004)(99286004)(25786009)(7416002)(14454004)(4326008)(478600001)(7736002)(8676002)(305945005)(110136005)(476003)(54906003)(86362001)(2616005)(11346002)(446003)(316002)(102836004)(81166006)(486006)(55236004)(44832011)(5660300002)(50226002)(26005)(9456002)(186003)(8936002)(36756003)(1076003)(6436002)(6512007)(2906002)(6486002)(386003)(81156014)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6397;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/zOzA2k3+uPPO7tyA/DlvAM7dwkoUKW30DudsyU/dAzVZcDWkH7e/49X/3SAcNUUSby42kht7FsRY2/CiwsRL/hJeZ8fnCLjd2IULYNH5bnfmHE1pEgrvmr2h1hGqC/XVhAwDNhTesfbmObPPgJcMLnTTpmrw/zif+Pyyi8OdUEV2isSt1/5UKBwjrLf9pkWzU+8/Ub31FdpN36IzwMzzMhl/ePetfgIAfQL19tZB6+DeQA09oCtcF09xTmh1LX9ZeYKBV33492VavwhJVXB+SIZF9cSCGKmle/3bBHMdWeEdADCQJaA45iT5Bqm5OII6syBXgn0xNvk3sZZDfDKmrTSKGFR35N851apWs2wHDFjS1jbK0b9hZ0Ud1YsnGJ2mVURXwemGyoUzs7htA9W9gbSSuAM7K4Wu8tDwZSlEw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f027fb-ec7d-440e-a537-08d75253816a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:11:30.4936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rXMEftJP5YsoZVqOPeQc6IZznOUKlCicuabpNyr7T1YK363/SwD9a8cnB2/JihA23n2sPod/ObvUlGFjcZG6jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6397
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
 arch/riscv/include/asm/kvm_host.h |  8 +++++
 arch/riscv/kvm/vcpu.c             |  9 +++++
 arch/riscv/kvm/vcpu_sbi.c         | 56 +++++++++++++++++++++++++++----
 include/uapi/linux/kvm.h          |  8 +++++
 4 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 58cb6789f502..ec1ca4bc98f2 100644
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
@@ -250,6 +257,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcp=
u, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
=20
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
=20
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 092b209644de..fd77cd39dd8c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -884,6 +884,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
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
index 3d0c33c94daf..901ac73d23cf 100644
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
@@ -44,6 +82,16 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		return -EINVAL;
=20
 	switch (cp->a7) {
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
 	case SBI_EXT_0_1_SET_TIMER:
 #if __riscv_xlen =3D=3D 32
 		next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
@@ -91,12 +139,8 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
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

