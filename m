Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E076BC97AD
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfJCFHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:07:34 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16106 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJCFHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079275; x=1601615275;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5k3R3lBtRzaA/YpHow1pYfa9Y/snax9LFp52mhx9E3Q=;
  b=idAjTXElfNe7LMifXIvmWzQHF3J46xllzm54FduFH1QayskBv3qrPuEy
   d0kDzwysmStaaNnMJ9IW2T1OPFDHbMe06k7s4fzjC422s6IzcGG5gJ2UY
   NorkD3ELvKhuVu2P3qHGjzEsvCxNg7iM35SzbJzkoXSgzwZJfkAD8xViV
   voTXqh1Az+nHGVhQZrLKEQGh52JJqye2VOXmVUWI4EvgTNANIsobTuCFD
   W3FGV0lphPdBiZ7DMxjDQL2uJDTN4UcWKbUoiASGN9+H2IgxJDv4bg+wR
   gbf2oPF1klLSoa7S0a2tAkEmCWKjLOy4WOdVIaLzECmwtAt6fO6N92Uzj
   g==;
IronPort-SDR: ZXgNnmZloQ83bQMKPYvHPR8T0tnci3noAdpUQ1svoihgjmz6Jr+t0YBGw+Uee3be+rLKgM+NA9
 nLqPWWLXOuIM6srhSe4VY7tQVFm8mFNej37f0J3pKFwTSfSP2Z8xdYZKLjdnllOrjiLBUw9mpE
 wIBz6Zgo55PljbTyWa7ODdrpNl1bi6saKrObJ3U4aKdQ9A+A9sN84H2tgJpMOng6yh7sYMMIV+
 vhpEMKyIalC/jsPiMS1SFUUvEt8LXR53t13NZyZYMGv0GjVi0b1OS7zTH0wobXpqS7rEyIbCh8
 oJU=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="220620873"
Received: from mail-co1nam05lp2054.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.54])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:07:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmneHoh7L5PJfWvWWkbOR7EqGJ0ArtfKzfKj+PJNDAuA8u46vi7b6Truf1TvK2Whmhb0dkrEkeDI69uGuY/Rs+6W4hq12gDeirI2U0ZV7Tbh20x9IIcrH4+++h/GqKqolwKylvojOkOwcCUKGz7HhaGL+Rht+i0RYW3SobDqQxPhOFFl1OThOKXSAQ4aYBV6FgWTGHe31vEQH+9Z/roKxmJKzlt0hJ6oD7WQcU6DnjsQY7MtgibqzV5R4LGNnQpNH2n+Eih77VV49RrnYKWrSui8pmJ2yV3UWYH5EoFQiwSffohfBpp89jf5Cri4CPixYWw8ZZokEXYS0IXIi4Ytjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o70Mm2OTkDFO+QMXWQ0QXSv7a+GkAj0XGMfUeIbTFI4=;
 b=MwzyiJlW3+DR5ts29nQiDTF/cHFKt5CDXxWdfOl/E8rzH7/WLZ6JxVTAutBttF/+IfELSabJ4XKIBvyhVBMD/zAY+Wx+INuWw2LK4v+ckPZVtsjCJa273PdCq4Ix6bvdHkIujGCh4yj4wLgjkEs9rdt9wy3KrtLrbm15LEb5/WUtfXisWBVOq+E3ZJsERylM4JtzlwquORQdijliE0JUTK/3idfIkSs2aGsMLuNIJ2o2li7SESm4GIaxTyDpjYa/ewEAXzHzC/ROA5PTMBstShsk5wK50CBzn1S0Meiy++SQNDsBY+pmLaUINA39dCIuatzJv2UpbSCK8PIu+3vLdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o70Mm2OTkDFO+QMXWQ0QXSv7a+GkAj0XGMfUeIbTFI4=;
 b=k+RfI2M1NFy8uQfz0JdIiLSKvmGpZk5XA9MNAOHM8XDH5aRQ3RMxSCTVwk5YMEvG0mJaueTCTDfGME8arEDUg/W3BTBkKlFVM2aJrZJ9kWqmp/dCz6hn/c6+hYLjy2bibPrCFo/Ns6MgEB+ARA9LzFqi3Adq+9YiGFUgpCfekGM=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6272.namprd04.prod.outlook.com (20.178.248.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 3 Oct 2019 05:07:24 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:07:24 +0000
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
Subject: [PATCH v8 07/19] RISC-V: KVM: Implement VCPU world-switch
Thread-Topic: [PATCH v8 07/19] RISC-V: KVM: Implement VCPU world-switch
Thread-Index: AQHVeahxksyFojjmTk+gS6kpnBx3Mw==
Date:   Thu, 3 Oct 2019 05:07:24 +0000
Message-ID: <20191003050558.9031-8-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 65f85462-374a-4cfb-793c-08d747bf93ed
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB62728B7C3F580D1A3BA0C3598D9F0@MN2PR04MB6272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(6512007)(6486002)(81166006)(81156014)(8936002)(6116002)(3846002)(8676002)(50226002)(2906002)(110136005)(66066001)(6436002)(316002)(66476007)(66556008)(7416002)(66446008)(36756003)(1076003)(5660300002)(54906003)(7736002)(305945005)(76176011)(30864003)(25786009)(52116002)(256004)(14444005)(71190400001)(86362001)(99286004)(71200400001)(2616005)(446003)(14454004)(476003)(102836004)(186003)(26005)(11346002)(44832011)(6506007)(486006)(478600001)(4326008)(66946007)(386003)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6272;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tTVFy46JhD+YL3pgTSuEevCiaJEd77pMiV7uFfWThqy972lN1djC7I/xg6FoIzaNVN5z9D0uyyCQDGPvlzFGRHdcJ/CPTFKmqGuOay1i1HqUhbotQOkdbyKjhcHj9nMIjjMF9tXjuf41RiBPTe7JIpCQmKeJ63BvRgPX4mLm8CcVgNE/8EEqR6xU91GrDbVXSP/1r9ClnlSmaGSlad3y9JlzxkBQLYduPocFkKHFxhiiXLvldKoQbY4PcXyyx+xdV4rn9aoFI6lZA4/z8xSlZEETxWgoV9Q2M4c9064tjYcsZW6iBAqwrcq5AwwEB6PnR7WNDVA/A9Or6DHHqgGZMoLJ9utAKyFW8JskOehhBi0SZ4qHq6s/yUL7GD8i8SYGVhlfRaOTkO2/VyiePu8z9zROas3vrMWg5XkaS9bHovk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f85462-374a-4cfb-793c-08d747bf93ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:07:24.5762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kmyg3kWpK7+b/o5yf0JwCNkkcTEBbGEkp389LoiS7LlLx2CBlbJrrn+FYb0LMEvwfaURHZQ+QggiCign2TxCGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6272
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements the VCPU world-switch for KVM RISC-V.

The KVM RISC-V world-switch (i.e. __kvm_riscv_switch_to()) mostly
switches general purpose registers, SSTATUS, STVEC, SSCRATCH and
HSTATUS CSRs. Other CSRs are switched via vcpu_load() and vcpu_put()
interface in kvm_arch_vcpu_load() and kvm_arch_vcpu_put() functions
respectively.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |   9 +-
 arch/riscv/kernel/asm-offsets.c   |  76 ++++++++++++
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu.c             |  32 ++++-
 arch/riscv/kvm/vcpu_switch.S      | 194 ++++++++++++++++++++++++++++++
 5 files changed, 309 insertions(+), 4 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_switch.S

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index d801216da6d0..18f1097f1d8d 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -110,6 +110,13 @@ struct kvm_vcpu_arch {
 	/* ISA feature bits (similar to MISA) */
 	unsigned long isa;
=20
+	/* SSCRATCH and STVEC of Host */
+	unsigned long host_sscratch;
+	unsigned long host_stvec;
+
+	/* CPU context of Host */
+	struct kvm_cpu_context host_context;
+
 	/* CPU context of Guest VCPU */
 	struct kvm_cpu_context guest_context;
=20
@@ -162,7 +169,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, s=
truct kvm_run *run);
 int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long scause, unsigned long stval);
=20
-static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) =
{}
+void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch);
=20
 int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
 int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
);
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offset=
s.c
index 9f5628c38ac9..711656710190 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -7,7 +7,9 @@
 #define GENERATING_ASM_OFFSETS
=20
 #include <linux/kbuild.h>
+#include <linux/mm.h>
 #include <linux/sched.h>
+#include <asm/kvm_host.h>
 #include <asm/thread_info.h>
 #include <asm/ptrace.h>
=20
@@ -109,6 +111,80 @@ void asm_offsets(void)
 	OFFSET(PT_SBADADDR, pt_regs, sbadaddr);
 	OFFSET(PT_SCAUSE, pt_regs, scause);
=20
+	OFFSET(KVM_ARCH_GUEST_ZERO, kvm_vcpu_arch, guest_context.zero);
+	OFFSET(KVM_ARCH_GUEST_RA, kvm_vcpu_arch, guest_context.ra);
+	OFFSET(KVM_ARCH_GUEST_SP, kvm_vcpu_arch, guest_context.sp);
+	OFFSET(KVM_ARCH_GUEST_GP, kvm_vcpu_arch, guest_context.gp);
+	OFFSET(KVM_ARCH_GUEST_TP, kvm_vcpu_arch, guest_context.tp);
+	OFFSET(KVM_ARCH_GUEST_T0, kvm_vcpu_arch, guest_context.t0);
+	OFFSET(KVM_ARCH_GUEST_T1, kvm_vcpu_arch, guest_context.t1);
+	OFFSET(KVM_ARCH_GUEST_T2, kvm_vcpu_arch, guest_context.t2);
+	OFFSET(KVM_ARCH_GUEST_S0, kvm_vcpu_arch, guest_context.s0);
+	OFFSET(KVM_ARCH_GUEST_S1, kvm_vcpu_arch, guest_context.s1);
+	OFFSET(KVM_ARCH_GUEST_A0, kvm_vcpu_arch, guest_context.a0);
+	OFFSET(KVM_ARCH_GUEST_A1, kvm_vcpu_arch, guest_context.a1);
+	OFFSET(KVM_ARCH_GUEST_A2, kvm_vcpu_arch, guest_context.a2);
+	OFFSET(KVM_ARCH_GUEST_A3, kvm_vcpu_arch, guest_context.a3);
+	OFFSET(KVM_ARCH_GUEST_A4, kvm_vcpu_arch, guest_context.a4);
+	OFFSET(KVM_ARCH_GUEST_A5, kvm_vcpu_arch, guest_context.a5);
+	OFFSET(KVM_ARCH_GUEST_A6, kvm_vcpu_arch, guest_context.a6);
+	OFFSET(KVM_ARCH_GUEST_A7, kvm_vcpu_arch, guest_context.a7);
+	OFFSET(KVM_ARCH_GUEST_S2, kvm_vcpu_arch, guest_context.s2);
+	OFFSET(KVM_ARCH_GUEST_S3, kvm_vcpu_arch, guest_context.s3);
+	OFFSET(KVM_ARCH_GUEST_S4, kvm_vcpu_arch, guest_context.s4);
+	OFFSET(KVM_ARCH_GUEST_S5, kvm_vcpu_arch, guest_context.s5);
+	OFFSET(KVM_ARCH_GUEST_S6, kvm_vcpu_arch, guest_context.s6);
+	OFFSET(KVM_ARCH_GUEST_S7, kvm_vcpu_arch, guest_context.s7);
+	OFFSET(KVM_ARCH_GUEST_S8, kvm_vcpu_arch, guest_context.s8);
+	OFFSET(KVM_ARCH_GUEST_S9, kvm_vcpu_arch, guest_context.s9);
+	OFFSET(KVM_ARCH_GUEST_S10, kvm_vcpu_arch, guest_context.s10);
+	OFFSET(KVM_ARCH_GUEST_S11, kvm_vcpu_arch, guest_context.s11);
+	OFFSET(KVM_ARCH_GUEST_T3, kvm_vcpu_arch, guest_context.t3);
+	OFFSET(KVM_ARCH_GUEST_T4, kvm_vcpu_arch, guest_context.t4);
+	OFFSET(KVM_ARCH_GUEST_T5, kvm_vcpu_arch, guest_context.t5);
+	OFFSET(KVM_ARCH_GUEST_T6, kvm_vcpu_arch, guest_context.t6);
+	OFFSET(KVM_ARCH_GUEST_SEPC, kvm_vcpu_arch, guest_context.sepc);
+	OFFSET(KVM_ARCH_GUEST_SSTATUS, kvm_vcpu_arch, guest_context.sstatus);
+	OFFSET(KVM_ARCH_GUEST_HSTATUS, kvm_vcpu_arch, guest_context.hstatus);
+
+	OFFSET(KVM_ARCH_HOST_ZERO, kvm_vcpu_arch, host_context.zero);
+	OFFSET(KVM_ARCH_HOST_RA, kvm_vcpu_arch, host_context.ra);
+	OFFSET(KVM_ARCH_HOST_SP, kvm_vcpu_arch, host_context.sp);
+	OFFSET(KVM_ARCH_HOST_GP, kvm_vcpu_arch, host_context.gp);
+	OFFSET(KVM_ARCH_HOST_TP, kvm_vcpu_arch, host_context.tp);
+	OFFSET(KVM_ARCH_HOST_T0, kvm_vcpu_arch, host_context.t0);
+	OFFSET(KVM_ARCH_HOST_T1, kvm_vcpu_arch, host_context.t1);
+	OFFSET(KVM_ARCH_HOST_T2, kvm_vcpu_arch, host_context.t2);
+	OFFSET(KVM_ARCH_HOST_S0, kvm_vcpu_arch, host_context.s0);
+	OFFSET(KVM_ARCH_HOST_S1, kvm_vcpu_arch, host_context.s1);
+	OFFSET(KVM_ARCH_HOST_A0, kvm_vcpu_arch, host_context.a0);
+	OFFSET(KVM_ARCH_HOST_A1, kvm_vcpu_arch, host_context.a1);
+	OFFSET(KVM_ARCH_HOST_A2, kvm_vcpu_arch, host_context.a2);
+	OFFSET(KVM_ARCH_HOST_A3, kvm_vcpu_arch, host_context.a3);
+	OFFSET(KVM_ARCH_HOST_A4, kvm_vcpu_arch, host_context.a4);
+	OFFSET(KVM_ARCH_HOST_A5, kvm_vcpu_arch, host_context.a5);
+	OFFSET(KVM_ARCH_HOST_A6, kvm_vcpu_arch, host_context.a6);
+	OFFSET(KVM_ARCH_HOST_A7, kvm_vcpu_arch, host_context.a7);
+	OFFSET(KVM_ARCH_HOST_S2, kvm_vcpu_arch, host_context.s2);
+	OFFSET(KVM_ARCH_HOST_S3, kvm_vcpu_arch, host_context.s3);
+	OFFSET(KVM_ARCH_HOST_S4, kvm_vcpu_arch, host_context.s4);
+	OFFSET(KVM_ARCH_HOST_S5, kvm_vcpu_arch, host_context.s5);
+	OFFSET(KVM_ARCH_HOST_S6, kvm_vcpu_arch, host_context.s6);
+	OFFSET(KVM_ARCH_HOST_S7, kvm_vcpu_arch, host_context.s7);
+	OFFSET(KVM_ARCH_HOST_S8, kvm_vcpu_arch, host_context.s8);
+	OFFSET(KVM_ARCH_HOST_S9, kvm_vcpu_arch, host_context.s9);
+	OFFSET(KVM_ARCH_HOST_S10, kvm_vcpu_arch, host_context.s10);
+	OFFSET(KVM_ARCH_HOST_S11, kvm_vcpu_arch, host_context.s11);
+	OFFSET(KVM_ARCH_HOST_T3, kvm_vcpu_arch, host_context.t3);
+	OFFSET(KVM_ARCH_HOST_T4, kvm_vcpu_arch, host_context.t4);
+	OFFSET(KVM_ARCH_HOST_T5, kvm_vcpu_arch, host_context.t5);
+	OFFSET(KVM_ARCH_HOST_T6, kvm_vcpu_arch, host_context.t6);
+	OFFSET(KVM_ARCH_HOST_SEPC, kvm_vcpu_arch, host_context.sepc);
+	OFFSET(KVM_ARCH_HOST_SSTATUS, kvm_vcpu_arch, host_context.sstatus);
+	OFFSET(KVM_ARCH_HOST_HSTATUS, kvm_vcpu_arch, host_context.hstatus);
+	OFFSET(KVM_ARCH_HOST_SSCRATCH, kvm_vcpu_arch, host_sscratch);
+	OFFSET(KVM_ARCH_HOST_STVEC, kvm_vcpu_arch, host_stvec);
+
 	/*
 	 * THREAD_{F,X}* might be larger than a S-type offset can handle, but
 	 * these are used in performance-sensitive assembly so we can't resort
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 37b5a59d4f4f..845579273727 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -8,6 +8,6 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
=20
 kvm-objs :=3D $(common-objs-y)
=20
-kvm-objs +=3D main.o vm.o mmu.o vcpu.o vcpu_exit.o
+kvm-objs +=3D main.o vm.o mmu.o vcpu.o vcpu_exit.o vcpu_switch.o
=20
 obj-$(CONFIG_KVM)	+=3D kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index c9faca14f8cd..38a35367fb83 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -582,14 +582,42 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vc=
pu *vcpu,
=20
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	/* TODO: */
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	unsigned long *vsip =3D raw_cpu_ptr(vsip_shadow);
+
+	csr_write(CSR_VSSTATUS, csr->vsstatus);
+	csr_write(CSR_VSIE, csr->vsie);
+	csr_write(CSR_VSTVEC, csr->vstvec);
+	csr_write(CSR_VSSCRATCH, csr->vsscratch);
+	csr_write(CSR_VSEPC, csr->vsepc);
+	csr_write(CSR_VSCAUSE, csr->vscause);
+	csr_write(CSR_VSTVAL, csr->vstval);
+	csr_write(CSR_VSIP, csr->vsip);
+	*vsip =3D csr->vsip;
+	csr_write(CSR_VSATP, csr->vsatp);
=20
 	kvm_riscv_stage2_update_hgatp(vcpu);
+
+	vcpu->cpu =3D cpu;
 }
=20
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+
+	vcpu->cpu =3D -1;
+
+	csr_write(CSR_HGATP, 0);
+
+	csr->vsstatus =3D csr_read(CSR_VSSTATUS);
+	csr->vsie =3D csr_read(CSR_VSIE);
+	csr->vstvec =3D csr_read(CSR_VSTVEC);
+	csr->vsscratch =3D csr_read(CSR_VSSCRATCH);
+	csr->vsepc =3D csr_read(CSR_VSEPC);
+	csr->vscause =3D csr_read(CSR_VSCAUSE);
+	csr->vstval =3D csr_read(CSR_VSTVAL);
+	csr->vsip =3D csr_read(CSR_VSIP);
+	csr->vsatp =3D csr_read(CSR_VSATP);
 }
=20
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
diff --git a/arch/riscv/kvm/vcpu_switch.S b/arch/riscv/kvm/vcpu_switch.S
new file mode 100644
index 000000000000..e1a17df1b379
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_switch.S
@@ -0,0 +1,194 @@
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
+#include <asm/asm-offsets.h>
+#include <asm/csr.h>
+
+	.text
+	.altmacro
+	.option norelax
+
+ENTRY(__kvm_riscv_switch_to)
+	/* Save Host GPRs (except A0 and T0-T6) */
+	REG_S	ra, (KVM_ARCH_HOST_RA)(a0)
+	REG_S	sp, (KVM_ARCH_HOST_SP)(a0)
+	REG_S	gp, (KVM_ARCH_HOST_GP)(a0)
+	REG_S	tp, (KVM_ARCH_HOST_TP)(a0)
+	REG_S	s0, (KVM_ARCH_HOST_S0)(a0)
+	REG_S	s1, (KVM_ARCH_HOST_S1)(a0)
+	REG_S	a1, (KVM_ARCH_HOST_A1)(a0)
+	REG_S	a2, (KVM_ARCH_HOST_A2)(a0)
+	REG_S	a3, (KVM_ARCH_HOST_A3)(a0)
+	REG_S	a4, (KVM_ARCH_HOST_A4)(a0)
+	REG_S	a5, (KVM_ARCH_HOST_A5)(a0)
+	REG_S	a6, (KVM_ARCH_HOST_A6)(a0)
+	REG_S	a7, (KVM_ARCH_HOST_A7)(a0)
+	REG_S	s2, (KVM_ARCH_HOST_S2)(a0)
+	REG_S	s3, (KVM_ARCH_HOST_S3)(a0)
+	REG_S	s4, (KVM_ARCH_HOST_S4)(a0)
+	REG_S	s5, (KVM_ARCH_HOST_S5)(a0)
+	REG_S	s6, (KVM_ARCH_HOST_S6)(a0)
+	REG_S	s7, (KVM_ARCH_HOST_S7)(a0)
+	REG_S	s8, (KVM_ARCH_HOST_S8)(a0)
+	REG_S	s9, (KVM_ARCH_HOST_S9)(a0)
+	REG_S	s10, (KVM_ARCH_HOST_S10)(a0)
+	REG_S	s11, (KVM_ARCH_HOST_S11)(a0)
+
+	/* Save Host SSTATUS, HSTATUS, SCRATCH and STVEC */
+	csrr	t0, CSR_SSTATUS
+	REG_S	t0, (KVM_ARCH_HOST_SSTATUS)(a0)
+	csrr	t1, CSR_HSTATUS
+	REG_S	t1, (KVM_ARCH_HOST_HSTATUS)(a0)
+	csrr	t2, CSR_SSCRATCH
+	REG_S	t2, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	csrr	t3, CSR_STVEC
+	REG_S	t3, (KVM_ARCH_HOST_STVEC)(a0)
+
+	/* Change Host exception vector to return path */
+	la	t4, __kvm_switch_return
+	csrw	CSR_STVEC, t4
+
+	/* Restore Guest HSTATUS, SSTATUS and SEPC */
+	REG_L	t4, (KVM_ARCH_GUEST_SEPC)(a0)
+	csrw	CSR_SEPC, t4
+	REG_L	t5, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	csrw	CSR_SSTATUS, t5
+	REG_L	t6, (KVM_ARCH_GUEST_HSTATUS)(a0)
+	csrw	CSR_HSTATUS, t6
+
+	/* Restore Guest GPRs (except A0) */
+	REG_L	ra, (KVM_ARCH_GUEST_RA)(a0)
+	REG_L	sp, (KVM_ARCH_GUEST_SP)(a0)
+	REG_L	gp, (KVM_ARCH_GUEST_GP)(a0)
+	REG_L	tp, (KVM_ARCH_GUEST_TP)(a0)
+	REG_L	t0, (KVM_ARCH_GUEST_T0)(a0)
+	REG_L	t1, (KVM_ARCH_GUEST_T1)(a0)
+	REG_L	t2, (KVM_ARCH_GUEST_T2)(a0)
+	REG_L	s0, (KVM_ARCH_GUEST_S0)(a0)
+	REG_L	s1, (KVM_ARCH_GUEST_S1)(a0)
+	REG_L	a1, (KVM_ARCH_GUEST_A1)(a0)
+	REG_L	a2, (KVM_ARCH_GUEST_A2)(a0)
+	REG_L	a3, (KVM_ARCH_GUEST_A3)(a0)
+	REG_L	a4, (KVM_ARCH_GUEST_A4)(a0)
+	REG_L	a5, (KVM_ARCH_GUEST_A5)(a0)
+	REG_L	a6, (KVM_ARCH_GUEST_A6)(a0)
+	REG_L	a7, (KVM_ARCH_GUEST_A7)(a0)
+	REG_L	s2, (KVM_ARCH_GUEST_S2)(a0)
+	REG_L	s3, (KVM_ARCH_GUEST_S3)(a0)
+	REG_L	s4, (KVM_ARCH_GUEST_S4)(a0)
+	REG_L	s5, (KVM_ARCH_GUEST_S5)(a0)
+	REG_L	s6, (KVM_ARCH_GUEST_S6)(a0)
+	REG_L	s7, (KVM_ARCH_GUEST_S7)(a0)
+	REG_L	s8, (KVM_ARCH_GUEST_S8)(a0)
+	REG_L	s9, (KVM_ARCH_GUEST_S9)(a0)
+	REG_L	s10, (KVM_ARCH_GUEST_S10)(a0)
+	REG_L	s11, (KVM_ARCH_GUEST_S11)(a0)
+	REG_L	t3, (KVM_ARCH_GUEST_T3)(a0)
+	REG_L	t4, (KVM_ARCH_GUEST_T4)(a0)
+	REG_L	t5, (KVM_ARCH_GUEST_T5)(a0)
+	REG_L	t6, (KVM_ARCH_GUEST_T6)(a0)
+
+	/* Save Host A0 in SSCRATCH */
+	csrw	CSR_SSCRATCH, a0
+
+	/* Restore Guest A0 */
+	REG_L	a0, (KVM_ARCH_GUEST_A0)(a0)
+
+	/* Resume Guest */
+	sret
+
+	/* Back to Host */
+	.align 2
+__kvm_switch_return:
+	/* Swap Guest A0 with SSCRATCH */
+	csrrw	a0, CSR_SSCRATCH, a0
+
+	/* Save Guest GPRs (except A0) */
+	REG_S	ra, (KVM_ARCH_GUEST_RA)(a0)
+	REG_S	sp, (KVM_ARCH_GUEST_SP)(a0)
+	REG_S	gp, (KVM_ARCH_GUEST_GP)(a0)
+	REG_S	tp, (KVM_ARCH_GUEST_TP)(a0)
+	REG_S	t0, (KVM_ARCH_GUEST_T0)(a0)
+	REG_S	t1, (KVM_ARCH_GUEST_T1)(a0)
+	REG_S	t2, (KVM_ARCH_GUEST_T2)(a0)
+	REG_S	s0, (KVM_ARCH_GUEST_S0)(a0)
+	REG_S	s1, (KVM_ARCH_GUEST_S1)(a0)
+	REG_S	a1, (KVM_ARCH_GUEST_A1)(a0)
+	REG_S	a2, (KVM_ARCH_GUEST_A2)(a0)
+	REG_S	a3, (KVM_ARCH_GUEST_A3)(a0)
+	REG_S	a4, (KVM_ARCH_GUEST_A4)(a0)
+	REG_S	a5, (KVM_ARCH_GUEST_A5)(a0)
+	REG_S	a6, (KVM_ARCH_GUEST_A6)(a0)
+	REG_S	a7, (KVM_ARCH_GUEST_A7)(a0)
+	REG_S	s2, (KVM_ARCH_GUEST_S2)(a0)
+	REG_S	s3, (KVM_ARCH_GUEST_S3)(a0)
+	REG_S	s4, (KVM_ARCH_GUEST_S4)(a0)
+	REG_S	s5, (KVM_ARCH_GUEST_S5)(a0)
+	REG_S	s6, (KVM_ARCH_GUEST_S6)(a0)
+	REG_S	s7, (KVM_ARCH_GUEST_S7)(a0)
+	REG_S	s8, (KVM_ARCH_GUEST_S8)(a0)
+	REG_S	s9, (KVM_ARCH_GUEST_S9)(a0)
+	REG_S	s10, (KVM_ARCH_GUEST_S10)(a0)
+	REG_S	s11, (KVM_ARCH_GUEST_S11)(a0)
+	REG_S	t3, (KVM_ARCH_GUEST_T3)(a0)
+	REG_S	t4, (KVM_ARCH_GUEST_T4)(a0)
+	REG_S	t5, (KVM_ARCH_GUEST_T5)(a0)
+	REG_S	t6, (KVM_ARCH_GUEST_T6)(a0)
+
+	/* Save Guest A0 */
+	csrr	t0, CSR_SSCRATCH
+	REG_S	t0, (KVM_ARCH_GUEST_A0)(a0)
+
+	/* Save Guest HSTATUS, SSTATUS, and SEPC */
+	csrr	t0, CSR_SEPC
+	REG_S	t0, (KVM_ARCH_GUEST_SEPC)(a0)
+	csrr	t1, CSR_SSTATUS
+	REG_S	t1, (KVM_ARCH_GUEST_SSTATUS)(a0)
+	csrr	t2, CSR_HSTATUS
+	REG_S	t2, (KVM_ARCH_GUEST_HSTATUS)(a0)
+
+	/* Restore Host SSTATUS, HSTATUS, SCRATCH and STVEC */
+	REG_L	t3, (KVM_ARCH_HOST_SSTATUS)(a0)
+	csrw	CSR_SSTATUS, t3
+	REG_L	t4, (KVM_ARCH_HOST_HSTATUS)(a0)
+	csrw	CSR_HSTATUS, t4
+	REG_L	t5, (KVM_ARCH_HOST_SSCRATCH)(a0)
+	csrw	CSR_SSCRATCH, t5
+	REG_L	t6, (KVM_ARCH_HOST_STVEC)(a0)
+	csrw	CSR_STVEC, t6
+
+	/* Restore Host GPRs (except A0 and T0-T6) */
+	REG_L	ra, (KVM_ARCH_HOST_RA)(a0)
+	REG_L	sp, (KVM_ARCH_HOST_SP)(a0)
+	REG_L	gp, (KVM_ARCH_HOST_GP)(a0)
+	REG_L	tp, (KVM_ARCH_HOST_TP)(a0)
+	REG_L	s0, (KVM_ARCH_HOST_S0)(a0)
+	REG_L	s1, (KVM_ARCH_HOST_S1)(a0)
+	REG_L	a1, (KVM_ARCH_HOST_A1)(a0)
+	REG_L	a2, (KVM_ARCH_HOST_A2)(a0)
+	REG_L	a3, (KVM_ARCH_HOST_A3)(a0)
+	REG_L	a4, (KVM_ARCH_HOST_A4)(a0)
+	REG_L	a5, (KVM_ARCH_HOST_A5)(a0)
+	REG_L	a6, (KVM_ARCH_HOST_A6)(a0)
+	REG_L	a7, (KVM_ARCH_HOST_A7)(a0)
+	REG_L	s2, (KVM_ARCH_HOST_S2)(a0)
+	REG_L	s3, (KVM_ARCH_HOST_S3)(a0)
+	REG_L	s4, (KVM_ARCH_HOST_S4)(a0)
+	REG_L	s5, (KVM_ARCH_HOST_S5)(a0)
+	REG_L	s6, (KVM_ARCH_HOST_S6)(a0)
+	REG_L	s7, (KVM_ARCH_HOST_S7)(a0)
+	REG_L	s8, (KVM_ARCH_HOST_S8)(a0)
+	REG_L	s9, (KVM_ARCH_HOST_S9)(a0)
+	REG_L	s10, (KVM_ARCH_HOST_S10)(a0)
+	REG_L	s11, (KVM_ARCH_HOST_S11)(a0)
+
+	/* Return to C code */
+	ret
+ENDPROC(__kvm_riscv_switch_to)
--=20
2.17.1

