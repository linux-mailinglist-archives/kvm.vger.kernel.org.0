Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A23C78B22
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388018AbfG2L5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:57:54 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:29803 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388007AbfG2L5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:57:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564401471; x=1595937471;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uu59jDp/K1nnzcez40mdfvwFKgriw67uN4ufSF9dCuY=;
  b=gJkA5qMh1y5ryGJlIUDaHZXJYqx64pVjK7S/rdjbrSZ8TvttRzfP1tvj
   HMHgTi1mxESL8j1KF7lb50k5kOHqaeVVsKMsoqhe4OyoUgHTsWZRAxrKV
   0DQFK6fZAwbFFsTS6MJuaqcyo5jPskhd1K8KAmm3TWEn+8H1PVpnsJaEe
   YOm1iVPvOb21E7ohf1/YWduI8PPCySD4VLMmP8mQKfAG+pR0SjZhaJQfw
   Iy5MNpEsh/7LC0TtSkBC0wkobvw93wcs8PvwMJAoDLrZ4KXQXPUg6EbE7
   OEp8tXBiAf2d3nlTRFWr3GH+5hXRAc6xPXv9BcjbSY61+mXXEUVhoE52P
   A==;
IronPort-SDR: FWsf0WRLVob71DmHVAOdha8sqvyGwWPeuAAjSA/FkAwI8QVnRJJt/9UMkH6nxKTyllt+BY4b6q
 W7u/VR/5pjssRinDdL55np0RCBler13dBAKaJRRygHkKi1Qogug5OKDEMr7V21s8U0kZO5enjp
 is+itxLkbi+pqYWgeODOKVorNPG9NfmkHevcqoJ+f9LSpzQbWPY4kuVlXydzKEgN1nd0a0b/TD
 3MvlkwNcf9txEplUxXjNQbFCRMCNq7jf/1xfa9RT6jsKg+xrqNu20UOBjg+cHcLkIBRLrsqqqa
 +cw=
X-IronPort-AV: E=Sophos;i="5.64,322,1559491200"; 
   d="scan'208";a="115403256"
Received: from mail-by2nam01lp2053.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.53])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2019 19:57:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CC1HdqcL0VsOTkdcoAKlEYxujR+EQzvchoji6iuAs2c8fFdWOTdFVbBi/O0xmLR6rEmdPeM+4Rx0zHgzqDOjg1m3Aai0yA8jzhF6Emw4wOdIVb0Qi/ebAbFY9ZHsf/VNz0op6zy4BxjJ/Y7tYwGNMJqwttxDq614vRRotno/gjcR3PPbPrYlI0K8HwkYBdptZHi8PnTnEIrxWt1w6AxvRynnG+5BDlVqL50ZWcBTkqpnV/nF9hzkAPoFLj0I1kbnrbczVbWbMQctcO6VmpnIYwxmRxjtUd2RYjMmK0Qz3bId+b7B5pXuTb3ALiWchKL2W9Zgdsq1Skyhk5IIoGvJWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZp+5gpkCVIzUXx2Eo46YjyDp7k8TkMMKd5bxbFMm8I=;
 b=gjtBLAMpT4I0hsUchUTVnKWTMFm+fSqkmIha7RhZDfssSdDm1jXigIT8a5Ff6s9IodUuobYhpikdmngW4+IJMWvbB05vpwH+DrdfUKjXP/C/kMvG/TkCxpOChG/PNobzVmr+Dgy0fhgWIorZgxODqj36qZ+dRknoLKrVN6QyPl1MBiZE1Ta4VBajF0v30d3bIKYng5SWDoXY/n14JyVjmY9+SIC8dM/WYK5EFZC+POrFVdIRhrun9HPfMnj+X9IM1jEBZIDI2LfDZpRIo7veXNBZtQJqDIwTPExTRQQ1zftyvbsLP5yPovN7/buoS/x+203wtJ5GRxjexAyfA+6fXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZp+5gpkCVIzUXx2Eo46YjyDp7k8TkMMKd5bxbFMm8I=;
 b=lnuNRvPEKHPNM4iEspP/VfG9laZuB4ELlaKjdfRfet4msjuEFgsDYJaz0646PTbpbMj4ZyT0hkdpmcxRv75/4b6WiKi7tVsQ7Y3ioebs0diDyFvkbNQnZh9KO+b/QWQC5q8cgVLI5cxTBZ/KqwjVu5Sqz73IpL7Rio9KDeK+jWI=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5678.namprd04.prod.outlook.com (20.179.21.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 11:57:48 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 11:57:48 +0000
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
Subject: [RFC PATCH 14/16] RISC-V: KVM: FP lazy save/restore
Thread-Topic: [RFC PATCH 14/16] RISC-V: KVM: FP lazy save/restore
Thread-Index: AQHVRgTXLsTKZv9ye0WZ5nDcokAn/A==
Date:   Mon, 29 Jul 2019 11:57:48 +0000
Message-ID: <20190729115544.17895-15-anup.patel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
In-Reply-To: <20190729115544.17895-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0116.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::32)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.23.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea64eaf3-c5c3-49c7-6c93-08d7141bf9a9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5678;
x-ms-traffictypediagnostic: MN2PR04MB5678:
x-microsoft-antispam-prvs: <MN2PR04MB5678CA86919D08EEFD3D28E48DDD0@MN2PR04MB5678.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(7416002)(52116002)(6436002)(6486002)(7736002)(476003)(2616005)(2906002)(5660300002)(66066001)(4326008)(446003)(53946003)(68736007)(11346002)(81156014)(81166006)(14454004)(53936002)(26005)(186003)(78486014)(99286004)(36756003)(44832011)(486006)(305945005)(8676002)(54906003)(110136005)(25786009)(8936002)(478600001)(76176011)(102836004)(71200400001)(30864003)(6512007)(1076003)(66446008)(64756008)(66946007)(256004)(55236004)(316002)(9456002)(86362001)(66476007)(50226002)(66556008)(6506007)(386003)(71190400001)(14444005)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5678;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p3VYc5pWbpysvfJV4rPSJqsZQ5p5KFYuIuSUOFhzT/90pBoPTPvKVNJzfZo8SijPs6TRnpw2RJfnaRd/OoULi6Z4oeHopeOoc9TKS1kJ9p85MfFPzSWsWPPHuj/mHgnrZHlmHu7UPa1vruvDrRUhvZXnzTKjoQuHK7XWHd/eaRG95klZ0wcV+ts7EeGilT5MRzA0gkq7NwKph/ujLqz6Yjoypwhb7Mebtfi7g5IWYscgGW2dlVjAiY2AKlB8Oc1F/Yuv0UXP98aAhsNA+5iO+0Y1cAq4HWSqZY+En8zRczsVxU1nRrnoJKJC2A4vyOu87dkcdDKk4o3dDTsCB9RI0iLePesCq3WiXuuH+tM5FK6wZc6u3X3yRJoI0b5K/z9Q3kwJSz3b36/9tVDSPD71CYmSrP9mKzL7F6Drl4CqDEA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea64eaf3-c5c3-49c7-6c93-08d7141bf9a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 11:57:48.3725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5678
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

This patch adds floating point (F and D extension) context save/restore
for guest VCPUs. The FP context is saved and restored lazily only when
kernel enter/exits the in-kernel run loop and not during the KVM world
switch. This way FP save/restore has minimal impact on KVM performance.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h |   5 +
 arch/riscv/kernel/asm-offsets.c   |  72 +++++++++++++
 arch/riscv/kvm/vcpu.c             |  75 +++++++++++++
 arch/riscv/kvm/vcpu_switch.S      | 174 ++++++++++++++++++++++++++++++
 4 files changed, 326 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 193a7ff0eb31..1bb4befa89da 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -113,6 +113,7 @@ struct kvm_cpu_context {
 	unsigned long sepc;
 	unsigned long sstatus;
 	unsigned long hstatus;
+	union __riscv_fp_state fp;
 };
=20
 struct kvm_vcpu_csr {
@@ -212,6 +213,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
 			unsigned long scause, unsigned long stval);
=20
 void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
+void __kvm_riscv_vcpu_fp_f_save(struct kvm_cpu_context *context);
+void __kvm_riscv_vcpu_fp_f_restore(struct kvm_cpu_context *context);
+void __kvm_riscv_vcpu_fp_d_save(struct kvm_cpu_context *context);
+void __kvm_riscv_vcpu_fp_d_restore(struct kvm_cpu_context *context);
=20
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offset=
s.c
index 711656710190..9980069a1acf 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -185,6 +185,78 @@ void asm_offsets(void)
 	OFFSET(KVM_ARCH_HOST_SSCRATCH, kvm_vcpu_arch, host_sscratch);
 	OFFSET(KVM_ARCH_HOST_STVEC, kvm_vcpu_arch, host_stvec);
=20
+	/* F extension */
+
+	OFFSET(KVM_ARCH_FP_F_F0, kvm_cpu_context, fp.f.f[0]);
+	OFFSET(KVM_ARCH_FP_F_F1, kvm_cpu_context, fp.f.f[1]);
+	OFFSET(KVM_ARCH_FP_F_F2, kvm_cpu_context, fp.f.f[2]);
+	OFFSET(KVM_ARCH_FP_F_F3, kvm_cpu_context, fp.f.f[3]);
+	OFFSET(KVM_ARCH_FP_F_F4, kvm_cpu_context, fp.f.f[4]);
+	OFFSET(KVM_ARCH_FP_F_F5, kvm_cpu_context, fp.f.f[5]);
+	OFFSET(KVM_ARCH_FP_F_F6, kvm_cpu_context, fp.f.f[6]);
+	OFFSET(KVM_ARCH_FP_F_F7, kvm_cpu_context, fp.f.f[7]);
+	OFFSET(KVM_ARCH_FP_F_F8, kvm_cpu_context, fp.f.f[8]);
+	OFFSET(KVM_ARCH_FP_F_F9, kvm_cpu_context, fp.f.f[9]);
+	OFFSET(KVM_ARCH_FP_F_F10, kvm_cpu_context, fp.f.f[10]);
+	OFFSET(KVM_ARCH_FP_F_F11, kvm_cpu_context, fp.f.f[11]);
+	OFFSET(KVM_ARCH_FP_F_F12, kvm_cpu_context, fp.f.f[12]);
+	OFFSET(KVM_ARCH_FP_F_F13, kvm_cpu_context, fp.f.f[13]);
+	OFFSET(KVM_ARCH_FP_F_F14, kvm_cpu_context, fp.f.f[14]);
+	OFFSET(KVM_ARCH_FP_F_F15, kvm_cpu_context, fp.f.f[15]);
+	OFFSET(KVM_ARCH_FP_F_F16, kvm_cpu_context, fp.f.f[16]);
+	OFFSET(KVM_ARCH_FP_F_F17, kvm_cpu_context, fp.f.f[17]);
+	OFFSET(KVM_ARCH_FP_F_F18, kvm_cpu_context, fp.f.f[18]);
+	OFFSET(KVM_ARCH_FP_F_F19, kvm_cpu_context, fp.f.f[19]);
+	OFFSET(KVM_ARCH_FP_F_F20, kvm_cpu_context, fp.f.f[20]);
+	OFFSET(KVM_ARCH_FP_F_F21, kvm_cpu_context, fp.f.f[21]);
+	OFFSET(KVM_ARCH_FP_F_F22, kvm_cpu_context, fp.f.f[22]);
+	OFFSET(KVM_ARCH_FP_F_F23, kvm_cpu_context, fp.f.f[23]);
+	OFFSET(KVM_ARCH_FP_F_F24, kvm_cpu_context, fp.f.f[24]);
+	OFFSET(KVM_ARCH_FP_F_F25, kvm_cpu_context, fp.f.f[25]);
+	OFFSET(KVM_ARCH_FP_F_F26, kvm_cpu_context, fp.f.f[26]);
+	OFFSET(KVM_ARCH_FP_F_F27, kvm_cpu_context, fp.f.f[27]);
+	OFFSET(KVM_ARCH_FP_F_F28, kvm_cpu_context, fp.f.f[28]);
+	OFFSET(KVM_ARCH_FP_F_F29, kvm_cpu_context, fp.f.f[29]);
+	OFFSET(KVM_ARCH_FP_F_F30, kvm_cpu_context, fp.f.f[30]);
+	OFFSET(KVM_ARCH_FP_F_F31, kvm_cpu_context, fp.f.f[31]);
+	OFFSET(KVM_ARCH_FP_F_FCSR, kvm_cpu_context, fp.f.fcsr);
+
+	/* D extension */
+
+	OFFSET(KVM_ARCH_FP_D_F0, kvm_cpu_context, fp.d.f[0]);
+	OFFSET(KVM_ARCH_FP_D_F1, kvm_cpu_context, fp.d.f[1]);
+	OFFSET(KVM_ARCH_FP_D_F2, kvm_cpu_context, fp.d.f[2]);
+	OFFSET(KVM_ARCH_FP_D_F3, kvm_cpu_context, fp.d.f[3]);
+	OFFSET(KVM_ARCH_FP_D_F4, kvm_cpu_context, fp.d.f[4]);
+	OFFSET(KVM_ARCH_FP_D_F5, kvm_cpu_context, fp.d.f[5]);
+	OFFSET(KVM_ARCH_FP_D_F6, kvm_cpu_context, fp.d.f[6]);
+	OFFSET(KVM_ARCH_FP_D_F7, kvm_cpu_context, fp.d.f[7]);
+	OFFSET(KVM_ARCH_FP_D_F8, kvm_cpu_context, fp.d.f[8]);
+	OFFSET(KVM_ARCH_FP_D_F9, kvm_cpu_context, fp.d.f[9]);
+	OFFSET(KVM_ARCH_FP_D_F10, kvm_cpu_context, fp.d.f[10]);
+	OFFSET(KVM_ARCH_FP_D_F11, kvm_cpu_context, fp.d.f[11]);
+	OFFSET(KVM_ARCH_FP_D_F12, kvm_cpu_context, fp.d.f[12]);
+	OFFSET(KVM_ARCH_FP_D_F13, kvm_cpu_context, fp.d.f[13]);
+	OFFSET(KVM_ARCH_FP_D_F14, kvm_cpu_context, fp.d.f[14]);
+	OFFSET(KVM_ARCH_FP_D_F15, kvm_cpu_context, fp.d.f[15]);
+	OFFSET(KVM_ARCH_FP_D_F16, kvm_cpu_context, fp.d.f[16]);
+	OFFSET(KVM_ARCH_FP_D_F17, kvm_cpu_context, fp.d.f[17]);
+	OFFSET(KVM_ARCH_FP_D_F18, kvm_cpu_context, fp.d.f[18]);
+	OFFSET(KVM_ARCH_FP_D_F19, kvm_cpu_context, fp.d.f[19]);
+	OFFSET(KVM_ARCH_FP_D_F20, kvm_cpu_context, fp.d.f[20]);
+	OFFSET(KVM_ARCH_FP_D_F21, kvm_cpu_context, fp.d.f[21]);
+	OFFSET(KVM_ARCH_FP_D_F22, kvm_cpu_context, fp.d.f[22]);
+	OFFSET(KVM_ARCH_FP_D_F23, kvm_cpu_context, fp.d.f[23]);
+	OFFSET(KVM_ARCH_FP_D_F24, kvm_cpu_context, fp.d.f[24]);
+	OFFSET(KVM_ARCH_FP_D_F25, kvm_cpu_context, fp.d.f[25]);
+	OFFSET(KVM_ARCH_FP_D_F26, kvm_cpu_context, fp.d.f[26]);
+	OFFSET(KVM_ARCH_FP_D_F27, kvm_cpu_context, fp.d.f[27]);
+	OFFSET(KVM_ARCH_FP_D_F28, kvm_cpu_context, fp.d.f[28]);
+	OFFSET(KVM_ARCH_FP_D_F29, kvm_cpu_context, fp.d.f[29]);
+	OFFSET(KVM_ARCH_FP_D_F30, kvm_cpu_context, fp.d.f[30]);
+	OFFSET(KVM_ARCH_FP_D_F31, kvm_cpu_context, fp.d.f[31]);
+	OFFSET(KVM_ARCH_FP_D_FCSR, kvm_cpu_context, fp.d.fcsr);
+
 	/*
 	 * THREAD_{F,X}* might be larger than a S-type offset can handle, but
 	 * these are used in performance-sensitive assembly so we can't resort
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index ed1f06b17953..82719ada3baa 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -31,6 +31,72 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
 	{ NULL }
 };
=20
+#ifdef CONFIG_FPU
+static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
+{
+	unsigned long isa =3D vcpu->arch.isa;
+	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
+
+	cntx->sstatus &=3D ~SR_FS;
+	if ((riscv_isa_extension_available(F) && (isa & RISCV_ISA_EXT_F)) ||
+	    (riscv_isa_extension_available(D) && (isa & RISCV_ISA_EXT_D)))
+		cntx->sstatus |=3D SR_FS_INITIAL;
+	else
+		cntx->sstatus |=3D SR_FS_OFF;
+}
+
+static void kvm_riscv_vcpu_fp_clean(struct kvm_cpu_context *cntx)
+{
+	cntx->sstatus &=3D ~SR_FS;
+	cntx->sstatus |=3D SR_FS_CLEAN;
+}
+
+static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx)
+{
+	if ((cntx->sstatus & SR_FS) =3D=3D SR_FS_DIRTY) {
+		if (riscv_isa_extension_available(D))
+			__kvm_riscv_vcpu_fp_d_save(cntx);
+		else if (riscv_isa_extension_available(F))
+			__kvm_riscv_vcpu_fp_f_save(cntx);
+		kvm_riscv_vcpu_fp_clean(cntx);
+	}
+}
+
+static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx)
+{
+	if ((cntx->sstatus & SR_FS) !=3D SR_FS_OFF) {
+		if (riscv_isa_extension_available(D))
+			__kvm_riscv_vcpu_fp_d_restore(cntx);
+		else if (riscv_isa_extension_available(F))
+			__kvm_riscv_vcpu_fp_f_restore(cntx);
+		kvm_riscv_vcpu_fp_clean(cntx);
+	}
+}
+
+static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx)
+{
+	/* No need to check host sstatus as it can be modified outside */
+	if (riscv_isa_extension_available(D))
+		__kvm_riscv_vcpu_fp_d_save(cntx);
+	else if (riscv_isa_extension_available(F))
+		__kvm_riscv_vcpu_fp_f_save(cntx);
+}
+
+static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx)
+{
+	if (riscv_isa_extension_available(D))
+		__kvm_riscv_vcpu_fp_d_restore(cntx);
+	else if (riscv_isa_extension_available(F))
+		__kvm_riscv_vcpu_fp_f_restore(cntx);
+}
+#else
+static void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu) {}
+static void kvm_riscv_vcpu_guest_fp_save(struct kvm_cpu_context *cntx) {}
+static void kvm_riscv_vcpu_guest_fp_restore(struct kvm_cpu_context *cntx) =
{}
+static void kvm_riscv_vcpu_host_fp_save(struct kvm_cpu_context *cntx) {}
+static void kvm_riscv_vcpu_host_fp_restore(struct kvm_cpu_context *cntx) {=
}
+#endif
+
 #define KVM_RISCV_ISA_ALLOWED	(RISCV_ISA_EXT_A | \
 				 RISCV_ISA_EXT_C | \
 				 RISCV_ISA_EXT_D | \
@@ -52,6 +118,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
=20
+	kvm_riscv_vcpu_fp_reset(vcpu);
+
 	kvm_riscv_vcpu_timer_reset(vcpu);
=20
 	raw_spin_lock_irqsave(&vcpu->arch.irqs_lock, f);
@@ -247,6 +315,7 @@ static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcp=
u *vcpu,
 			vcpu->arch.isa =3D reg_val;
 			vcpu->arch.isa &=3D riscv_isa;
 			vcpu->arch.isa &=3D KVM_RISCV_ISA_ALLOWED;
+			kvm_riscv_vcpu_fp_reset(vcpu);
 		} else {
 			return -ENOTSUPP;
 		}
@@ -566,6 +635,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	csr_write(CSR_VSIP, csr->vsip);
 	csr_write(CSR_VSATP, csr->vsatp);
=20
+	kvm_riscv_vcpu_host_fp_save(&vcpu->arch.host_context);
+	kvm_riscv_vcpu_guest_fp_restore(&vcpu->arch.guest_context);
+
 	kvm_riscv_stage2_update_pgtbl(vcpu);
=20
 	vcpu->cpu =3D cpu;
@@ -577,6 +649,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	vcpu->cpu =3D -1;
=20
+	kvm_riscv_vcpu_guest_fp_save(&vcpu->arch.guest_context);
+	kvm_riscv_vcpu_host_fp_restore(&vcpu->arch.host_context);
+
 	csr_write(CSR_HGATP, 0);
 	csr_write(CSR_HIDELEG, 0);
 	csr_write(CSR_HEDELEG, 0);
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
index c5b85605bf73..4ad337ea34c2 100644
--- a/arch/riscv/kvm/vcpu_switch.S
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -191,3 +191,177 @@ __kvm_switch_return:
 	/* Return to C code */
 	ret
 ENDPROC(__kvm_riscv_switch_to)
+
+#ifdef	CONFIG_FPU
+	.align 3
+	.global __kvm_riscv_vcpu_fp_f_save
+__kvm_riscv_vcpu_fp_f_save:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	csrs CSR_SSTATUS, t1
+	frcsr t0
+	fsw f0,  KVM_ARCH_FP_F_F0(a0)
+	fsw f1,  KVM_ARCH_FP_F_F1(a0)
+	fsw f2,  KVM_ARCH_FP_F_F2(a0)
+	fsw f3,  KVM_ARCH_FP_F_F3(a0)
+	fsw f4,  KVM_ARCH_FP_F_F4(a0)
+	fsw f5,  KVM_ARCH_FP_F_F5(a0)
+	fsw f6,  KVM_ARCH_FP_F_F6(a0)
+	fsw f7,  KVM_ARCH_FP_F_F7(a0)
+	fsw f8,  KVM_ARCH_FP_F_F8(a0)
+	fsw f9,  KVM_ARCH_FP_F_F9(a0)
+	fsw f10, KVM_ARCH_FP_F_F10(a0)
+	fsw f11, KVM_ARCH_FP_F_F11(a0)
+	fsw f12, KVM_ARCH_FP_F_F12(a0)
+	fsw f13, KVM_ARCH_FP_F_F13(a0)
+	fsw f14, KVM_ARCH_FP_F_F14(a0)
+	fsw f15, KVM_ARCH_FP_F_F15(a0)
+	fsw f16, KVM_ARCH_FP_F_F16(a0)
+	fsw f17, KVM_ARCH_FP_F_F17(a0)
+	fsw f18, KVM_ARCH_FP_F_F18(a0)
+	fsw f19, KVM_ARCH_FP_F_F19(a0)
+	fsw f20, KVM_ARCH_FP_F_F20(a0)
+	fsw f21, KVM_ARCH_FP_F_F21(a0)
+	fsw f22, KVM_ARCH_FP_F_F22(a0)
+	fsw f23, KVM_ARCH_FP_F_F23(a0)
+	fsw f24, KVM_ARCH_FP_F_F24(a0)
+	fsw f25, KVM_ARCH_FP_F_F25(a0)
+	fsw f26, KVM_ARCH_FP_F_F26(a0)
+	fsw f27, KVM_ARCH_FP_F_F27(a0)
+	fsw f28, KVM_ARCH_FP_F_F28(a0)
+	fsw f29, KVM_ARCH_FP_F_F29(a0)
+	fsw f30, KVM_ARCH_FP_F_F30(a0)
+	fsw f31, KVM_ARCH_FP_F_F31(a0)
+	sw t0, KVM_ARCH_FP_F_FCSR(a0)
+	csrw CSR_SSTATUS, t2
+	ret
+
+	.align 3
+	.global __kvm_riscv_vcpu_fp_d_save
+__kvm_riscv_vcpu_fp_d_save:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	csrs CSR_SSTATUS, t1
+	frcsr t0
+	fsd f0,  KVM_ARCH_FP_D_F0(a0)
+	fsd f1,  KVM_ARCH_FP_D_F1(a0)
+	fsd f2,  KVM_ARCH_FP_D_F2(a0)
+	fsd f3,  KVM_ARCH_FP_D_F3(a0)
+	fsd f4,  KVM_ARCH_FP_D_F4(a0)
+	fsd f5,  KVM_ARCH_FP_D_F5(a0)
+	fsd f6,  KVM_ARCH_FP_D_F6(a0)
+	fsd f7,  KVM_ARCH_FP_D_F7(a0)
+	fsd f8,  KVM_ARCH_FP_D_F8(a0)
+	fsd f9,  KVM_ARCH_FP_D_F9(a0)
+	fsd f10, KVM_ARCH_FP_D_F10(a0)
+	fsd f11, KVM_ARCH_FP_D_F11(a0)
+	fsd f12, KVM_ARCH_FP_D_F12(a0)
+	fsd f13, KVM_ARCH_FP_D_F13(a0)
+	fsd f14, KVM_ARCH_FP_D_F14(a0)
+	fsd f15, KVM_ARCH_FP_D_F15(a0)
+	fsd f16, KVM_ARCH_FP_D_F16(a0)
+	fsd f17, KVM_ARCH_FP_D_F17(a0)
+	fsd f18, KVM_ARCH_FP_D_F18(a0)
+	fsd f19, KVM_ARCH_FP_D_F19(a0)
+	fsd f20, KVM_ARCH_FP_D_F20(a0)
+	fsd f21, KVM_ARCH_FP_D_F21(a0)
+	fsd f22, KVM_ARCH_FP_D_F22(a0)
+	fsd f23, KVM_ARCH_FP_D_F23(a0)
+	fsd f24, KVM_ARCH_FP_D_F24(a0)
+	fsd f25, KVM_ARCH_FP_D_F25(a0)
+	fsd f26, KVM_ARCH_FP_D_F26(a0)
+	fsd f27, KVM_ARCH_FP_D_F27(a0)
+	fsd f28, KVM_ARCH_FP_D_F28(a0)
+	fsd f29, KVM_ARCH_FP_D_F29(a0)
+	fsd f30, KVM_ARCH_FP_D_F30(a0)
+	fsd f31, KVM_ARCH_FP_D_F31(a0)
+	sw t0, KVM_ARCH_FP_D_FCSR(a0)
+	csrw CSR_SSTATUS, t2
+	ret
+
+	.align 3
+	.global __kvm_riscv_vcpu_fp_f_restore
+__kvm_riscv_vcpu_fp_f_restore:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	lw t0, KVM_ARCH_FP_F_FCSR(a0)
+	csrs CSR_SSTATUS, t1
+	flw f0,  KVM_ARCH_FP_F_F0(a0)
+	flw f1,  KVM_ARCH_FP_F_F1(a0)
+	flw f2,  KVM_ARCH_FP_F_F2(a0)
+	flw f3,  KVM_ARCH_FP_F_F3(a0)
+	flw f4,  KVM_ARCH_FP_F_F4(a0)
+	flw f5,  KVM_ARCH_FP_F_F5(a0)
+	flw f6,  KVM_ARCH_FP_F_F6(a0)
+	flw f7,  KVM_ARCH_FP_F_F7(a0)
+	flw f8,  KVM_ARCH_FP_F_F8(a0)
+	flw f9,  KVM_ARCH_FP_F_F9(a0)
+	flw f10, KVM_ARCH_FP_F_F10(a0)
+	flw f11, KVM_ARCH_FP_F_F11(a0)
+	flw f12, KVM_ARCH_FP_F_F12(a0)
+	flw f13, KVM_ARCH_FP_F_F13(a0)
+	flw f14, KVM_ARCH_FP_F_F14(a0)
+	flw f15, KVM_ARCH_FP_F_F15(a0)
+	flw f16, KVM_ARCH_FP_F_F16(a0)
+	flw f17, KVM_ARCH_FP_F_F17(a0)
+	flw f18, KVM_ARCH_FP_F_F18(a0)
+	flw f19, KVM_ARCH_FP_F_F19(a0)
+	flw f20, KVM_ARCH_FP_F_F20(a0)
+	flw f21, KVM_ARCH_FP_F_F21(a0)
+	flw f22, KVM_ARCH_FP_F_F22(a0)
+	flw f23, KVM_ARCH_FP_F_F23(a0)
+	flw f24, KVM_ARCH_FP_F_F24(a0)
+	flw f25, KVM_ARCH_FP_F_F25(a0)
+	flw f26, KVM_ARCH_FP_F_F26(a0)
+	flw f27, KVM_ARCH_FP_F_F27(a0)
+	flw f28, KVM_ARCH_FP_F_F28(a0)
+	flw f29, KVM_ARCH_FP_F_F29(a0)
+	flw f30, KVM_ARCH_FP_F_F30(a0)
+	flw f31, KVM_ARCH_FP_F_F31(a0)
+	fscsr t0
+	csrw CSR_SSTATUS, t2
+	ret
+
+	.align 3
+	.global __kvm_riscv_vcpu_fp_d_restore
+__kvm_riscv_vcpu_fp_d_restore:
+	csrr t2, CSR_SSTATUS
+	li t1, SR_FS
+	lw t0, KVM_ARCH_FP_D_FCSR(a0)
+	csrs CSR_SSTATUS, t1
+	fld f0,  KVM_ARCH_FP_D_F0(a0)
+	fld f1,  KVM_ARCH_FP_D_F1(a0)
+	fld f2,  KVM_ARCH_FP_D_F2(a0)
+	fld f3,  KVM_ARCH_FP_D_F3(a0)
+	fld f4,  KVM_ARCH_FP_D_F4(a0)
+	fld f5,  KVM_ARCH_FP_D_F5(a0)
+	fld f6,  KVM_ARCH_FP_D_F6(a0)
+	fld f7,  KVM_ARCH_FP_D_F7(a0)
+	fld f8,  KVM_ARCH_FP_D_F8(a0)
+	fld f9,  KVM_ARCH_FP_D_F9(a0)
+	fld f10, KVM_ARCH_FP_D_F10(a0)
+	fld f11, KVM_ARCH_FP_D_F11(a0)
+	fld f12, KVM_ARCH_FP_D_F12(a0)
+	fld f13, KVM_ARCH_FP_D_F13(a0)
+	fld f14, KVM_ARCH_FP_D_F14(a0)
+	fld f15, KVM_ARCH_FP_D_F15(a0)
+	fld f16, KVM_ARCH_FP_D_F16(a0)
+	fld f17, KVM_ARCH_FP_D_F17(a0)
+	fld f18, KVM_ARCH_FP_D_F18(a0)
+	fld f19, KVM_ARCH_FP_D_F19(a0)
+	fld f20, KVM_ARCH_FP_D_F20(a0)
+	fld f21, KVM_ARCH_FP_D_F21(a0)
+	fld f22, KVM_ARCH_FP_D_F22(a0)
+	fld f23, KVM_ARCH_FP_D_F23(a0)
+	fld f24, KVM_ARCH_FP_D_F24(a0)
+	fld f25, KVM_ARCH_FP_D_F25(a0)
+	fld f26, KVM_ARCH_FP_D_F26(a0)
+	fld f27, KVM_ARCH_FP_D_F27(a0)
+	fld f28, KVM_ARCH_FP_D_F28(a0)
+	fld f29, KVM_ARCH_FP_D_F29(a0)
+	fld f30, KVM_ARCH_FP_D_F30(a0)
+	fld f31, KVM_ARCH_FP_D_F31(a0)
+	fscsr t0
+	csrw CSR_SSTATUS, t2
+	ret
+#endif
--=20
2.17.1

