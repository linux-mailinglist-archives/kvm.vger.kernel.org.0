Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD31ED96B1
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406095AbfJPQM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:12:26 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35119 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405527AbfJPQM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242346; x=1602778346;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IJ3Dm9W+kcalt2auGmoiqX3hr4+ImieLrvx66PT5Ols=;
  b=cKGzESgSA+y9jNv2nXv7LF0e8qXvlAIGk7SNzlbZBxsoAjESSFcRlkwi
   b+kmXKPlC2GgO6qdJt61hw19LpsxdV+kcImeYDojEmeVNuOqnBVi2m573
   M6244X0gAzdwndITITV0/Yd+H6LKzGz1tk36Gqdk9SPSmcNk2ZPu2h1Dm
   AFyeK2XvNODOBu/BbUZ6kTVpVxwN0JvTdaxaHwu/VCasI9Ov9YTPTfd9p
   uwAevlg4ibf3yYRevhf7EYnXeAdJY/R4wu3LFKFi6K58psInZNzhlbjZ/
   sD59I1hVzjqOgaDdvKkovLP20BbBN3Vhy1dkJDF1jUlzaGvD4gD7E9ZfQ
   Q==;
IronPort-SDR: 9OAP9EgMSeAD5hjhSstKpIfJBsAEhH55hArZLJWbwNMMJa+8MyD7nSxK44a3DexbZzaAQuasWc
 7iWZez98D03hv3ffw8FFDzke39Sg8TvInrCmAE1xEF/DEE8uh2bfmpRcwDqboDxrvCevn/Ws3c
 MkQPKEFysRGlSyhbDSqiWtZgrvEZ87jvP2MfJUXl1UIk5mfjqOIDHyhxXJvXN5rURuagTOfDaU
 XT5FJR8qXQP736/3JbbJTaW8ViaB8Sp+l41b3moU/mJO32riSEkJFVcpB6zU4rUwxXCmSewTur
 WwA=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="122255710"
Received: from mail-by2nam01lp2050.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.50])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:12:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DBdejCKLS0VHlpYkzEW3NaQS9FRm3MEMUKjqobXup81oZpJc/TkC6VA5EytJyGnBhx1K9e1JaRvC8O0rtKNp+l06D5LBGAkH+Q8bzJ/8JJTAgTdP7ELcjhwEqsB54X/f3VB3zwaHmqGaX/sEbxE6MISr5o4cWzwDillmE4iTclVr+lYRBUOZmWbwcPrd1BnHDXtBsqKWynA5hw3Z6OdzVpBtGZkDCQ7e1krjvvIm/9+2m07PmXlb4Y6Y36cN4+GpxSSk3bkmIBlZrxOHDSPoi1g15rkekibL9R8xDRxaUEV8q/1ng+Pq0eX9H1WBic/5Uut2pDQTewGXZW/888lTAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W9iHQHa8mSzpgVf/bk+tR0okD1cn/3zAYWDBfsvfuM=;
 b=WVcivw63TU4yDSaGwt00jaFpZmtZ7L2vU80dkbNzB260gwLNM0o/rXlD3zZaLy5KN4GtDj6C9k3nAKYRDSSu+bDo23vc6pCSlf+7yfdHABMGQ+Z3Bsxc8xBj3AcMIfSks6g31A8p1KcV7vKYHoh1azBjEbGl5SEHKIUghbVH9ekhm2sk/jMW1DfxQI6/W7wkCBRPyR/aQdPqvFBmjZHTTN6VaZin1ww6w8ETfxhvd5gx+/Owq6b7rE6hho3kz3JbKbnFyAhjbd2CrHGV8r0hPyhSxlY3ZQ2yVZwW85yIvUsrmurTD4WnO+WCnN6cNlpYyGvMmaX2eW71U17ogo3RdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8W9iHQHa8mSzpgVf/bk+tR0okD1cn/3zAYWDBfsvfuM=;
 b=C8ErkGlREdBlJza3OBeTbL0Go7bkcHqXno5+klLGTpIfwP1CkIi2C4gAVjmuxfayOblRIL+q3itOIkP5H6h1psbHcdLBmO+cmi0j6UayFkrsZFUjP86FfMG+GT7XdwCDsoe3JvFJIvRI6NHdu+79II1Z11Wxo57D5yx093hqA1g=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6397.namprd04.prod.outlook.com (52.132.170.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 16 Oct 2019 16:12:21 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:12:21 +0000
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
Subject: [PATCH v9 21/22] RISC-V: KVM: Document RISC-V specific parts of KVM
 API.
Thread-Topic: [PATCH v9 21/22] RISC-V: KVM: Document RISC-V specific parts of
 KVM API.
Thread-Index: AQHVhDx90Yj7z2ZylEe56xaO8Mjg6g==
Date:   Wed, 16 Oct 2019 16:12:20 +0000
Message-ID: <20191016160649.24622-22-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 3156640d-a092-429a-b838-08d752539f7a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6397:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB63971A3C4B73AD55F613502E8D920@MN2PR04MB6397.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(199004)(81166006)(102836004)(316002)(44832011)(486006)(55236004)(110136005)(305945005)(7736002)(8676002)(11346002)(2616005)(446003)(54906003)(476003)(86362001)(6512007)(6436002)(386003)(6506007)(81156014)(2906002)(6486002)(1076003)(8936002)(186003)(26005)(50226002)(5660300002)(6306002)(9456002)(36756003)(66946007)(64756008)(66446008)(66476007)(71200400001)(71190400001)(66556008)(52116002)(7416002)(99286004)(256004)(25786009)(76176011)(966005)(14454004)(4326008)(478600001)(3846002)(6116002)(14444005)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6397;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d81WN/12LAdg+vYNG0gCollF6DEjfk6AMXtlF7oH+O/X3Zv9T3mbUyFJyPGZVznVGq/b9K7NODy4UYFnpOpIlGyh33TWhjRsZ5OvZjTkb3FOWvZcxTVgKIxxWkHRgM8HD8zy+GQvK/pSaX/6QUq/0wRhHP0dTN7XilBvxFzXSQB73McrbwZahcpm4feE/dlXe6w5c9Z58mUzgpnP988J3+uL81CvLHule/IjusDv9GxEYiwMOmPPE/VlLz9a1pnbSIgmRmMi/ZNVago/v2DsfPAGfrfMhJ/aj3Obr3CJZs4VmzrX7vWB+yMivlJl9GF2aQ050aF2nWGf/jwJwRK0ABqOrgIQXFvXLFucPmQJD5IVYlwMrWwy1j7SgTON3PlhzcKAEqhHjyHimvHg9W2J/N1geN7HL6Rb6vUyZUCmT+hVcdhWQ4biW43D45iOWwBUHqiQR67/PvPJJLNcSUgwbw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3156640d-a092-429a-b838-08d752539f7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:12:21.0366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YjqPAx2l5M8ZvWvCvxMzS5F6RpS152IzdhnZLitm6McGxFbhaaRrSejLJ1Tlpbww8Qh8eVahqlpC5qUhhJjQEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6397
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document RISC-V specific parts of the KVM API, such as:
 - The interrupt numbers passed to the KVM_INTERRUPT ioctl.
 - The states supported by the KVM_{GET,SET}_MP_STATE ioctls.
 - The registers supported by the KVM_{GET,SET}_ONE_REG interface
   and the encoding of those register ids.
 - The exit reason KVM_EXIT_RISCV_SBI for SBI calls forwarded to
   userspace tool.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Documentation/virt/kvm/api.txt | 158 +++++++++++++++++++++++++++++++--
 1 file changed, 151 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.tx=
t
index 4833904d32a5..83d654f463b6 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -471,7 +471,7 @@ struct kvm_translation {
 4.16 KVM_INTERRUPT
=20
 Capability: basic
-Architectures: x86, ppc, mips
+Architectures: x86, ppc, mips, riscv
 Type: vcpu ioctl
 Parameters: struct kvm_interrupt (in)
 Returns: 0 on success, negative on failure.
@@ -531,6 +531,22 @@ interrupt number dequeues the interrupt.
=20
 This is an asynchronous vcpu ioctl and can be invoked from any thread.
=20
+RISC-V:
+
+Queues an external interrupt to be injected into the virutal CPU. This ioc=
tl
+is overloaded with 2 different irq values:
+
+a) KVM_INTERRUPT_SET
+
+  This sets external interrupt for a virtual CPU and it will receive
+  once it is ready.
+
+b) KVM_INTERRUPT_UNSET
+
+  This clears pending external interrupt for a virtual CPU.
+
+This is an asynchronous vcpu ioctl and can be invoked from any thread.
+
=20
 4.17 KVM_DEBUG_GUEST
=20
@@ -1219,7 +1235,7 @@ for vm-wide capabilities.
 4.38 KVM_GET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390, arm, arm64
+Architectures: x86, s390, arm, arm64, riscv
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (out)
 Returns: 0 on success; -1 on error
@@ -1233,7 +1249,8 @@ uniprocessor guests).
=20
 Possible values are:
=20
- - KVM_MP_STATE_RUNNABLE:        the vcpu is currently running [x86,arm/ar=
m64]
+ - KVM_MP_STATE_RUNNABLE:        the vcpu is currently running
+                                 [x86,arm/arm64,riscv]
  - KVM_MP_STATE_UNINITIALIZED:   the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal=
 [x86]
  - KVM_MP_STATE_INIT_RECEIVED:   the vcpu has received an INIT signal, and=
 is
@@ -1242,7 +1259,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
  - KVM_MP_STATE_SIPI_RECEIVED:   the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
- - KVM_MP_STATE_STOPPED:         the vcpu is stopped [s390,arm/arm64]
+ - KVM_MP_STATE_STOPPED:         the vcpu is stopped [s390,arm/arm64,riscv=
]
  - KVM_MP_STATE_CHECK_STOP:      the vcpu is in a special error state [s39=
0]
  - KVM_MP_STATE_OPERATING:       the vcpu is operating (running or halted)
                                  [s390]
@@ -1253,7 +1270,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IR=
QCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspa=
ce on
 these architectures.
=20
-For arm/arm64:
+For arm/arm64/riscv:
=20
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1261,7 +1278,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is pa=
used or not.
 4.39 KVM_SET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390, arm, arm64
+Architectures: x86, s390, arm, arm64, riscv
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (in)
 Returns: 0 on success; -1 on error
@@ -1273,7 +1290,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IR=
QCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspa=
ce on
 these architectures.
=20
-For arm/arm64:
+For arm/arm64/riscv:
=20
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
@@ -2282,6 +2299,116 @@ following id bit patterns:
   0x7020 0000 0003 02 <0:3> <reg:5>
=20
=20
+RISC-V registers are mapped using the lower 32 bits. The upper 8 bits of
+that is the register group type.
+
+RISC-V config registers are meant for configuring a Guest VCPU and it has
+the following id bit patterns:
+  0x8020 0000 01 <index into the kvm_riscv_config struct:24> (32bit Host)
+  0x8030 0000 01 <index into the kvm_riscv_config struct:24> (64bit Host)
+
+Following are the RISC-V config registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x80x0 0000 0100 0000 isa       ISA feature bitmap of Guest VCPU
+  0x80x0 0000 0100 0001 tbfreq    Time base frequency
+
+The isa config register can be read anytime but can only be written before
+a Guest VCPU runs. It will have ISA feature bits matching underlying host
+set by default. The tbfreq config register is a read-only register and it
+will return host timebase frequenc.
+
+RISC-V core registers represent the general excution state of a Guest VCPU
+and it has the following id bit patterns:
+  0x8020 0000 02 <index into the kvm_riscv_core struct:24> (32bit Host)
+  0x8030 0000 02 <index into the kvm_riscv_core struct:24> (64bit Host)
+
+Following are the RISC-V core registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x80x0 0000 0200 0000 regs.pc   Program counter
+  0x80x0 0000 0200 0001 regs.ra   Return address
+  0x80x0 0000 0200 0002 regs.sp   Stack pointer
+  0x80x0 0000 0200 0003 regs.gp   Global pointer
+  0x80x0 0000 0200 0004 regs.tp   Task pointer
+  0x80x0 0000 0200 0005 regs.t0   Caller saved register 0
+  0x80x0 0000 0200 0006 regs.t1   Caller saved register 1
+  0x80x0 0000 0200 0007 regs.t2   Caller saved register 2
+  0x80x0 0000 0200 0008 regs.s0   Callee saved register 0
+  0x80x0 0000 0200 0009 regs.s1   Callee saved register 1
+  0x80x0 0000 0200 000a regs.a0   Function argument (or return value) 0
+  0x80x0 0000 0200 000b regs.a1   Function argument (or return value) 1
+  0x80x0 0000 0200 000c regs.a2   Function argument 2
+  0x80x0 0000 0200 000d regs.a3   Function argument 3
+  0x80x0 0000 0200 000e regs.a4   Function argument 4
+  0x80x0 0000 0200 000f regs.a5   Function argument 5
+  0x80x0 0000 0200 0010 regs.a6   Function argument 6
+  0x80x0 0000 0200 0011 regs.a7   Function argument 7
+  0x80x0 0000 0200 0012 regs.s2   Callee saved register 2
+  0x80x0 0000 0200 0013 regs.s3   Callee saved register 3
+  0x80x0 0000 0200 0014 regs.s4   Callee saved register 4
+  0x80x0 0000 0200 0015 regs.s5   Callee saved register 5
+  0x80x0 0000 0200 0016 regs.s6   Callee saved register 6
+  0x80x0 0000 0200 0017 regs.s7   Callee saved register 7
+  0x80x0 0000 0200 0018 regs.s8   Callee saved register 8
+  0x80x0 0000 0200 0019 regs.s9   Callee saved register 9
+  0x80x0 0000 0200 001a regs.s10  Callee saved register 10
+  0x80x0 0000 0200 001b regs.s11  Callee saved register 11
+  0x80x0 0000 0200 001c regs.t3   Caller saved register 3
+  0x80x0 0000 0200 001d regs.t4   Caller saved register 4
+  0x80x0 0000 0200 001e regs.t5   Caller saved register 5
+  0x80x0 0000 0200 001f regs.t6   Caller saved register 6
+  0x80x0 0000 0200 0020 mode      Privilege mode (1 =3D S-mode or 0 =3D U-=
mode)
+
+RISC-V csr registers represent the supervisor mode control/status register=
s
+of a Guest VCPU and it has the following id bit patterns:
+  0x8020 0000 03 <index into the kvm_riscv_csr struct:24> (32bit Host)
+  0x8030 0000 03 <index into the kvm_riscv_csr struct:24> (64bit Host)
+
+Following are the RISC-V csr registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x80x0 0000 0300 0000 sstatus   Supervisor status
+  0x80x0 0000 0300 0001 sie       Supervisor interrupt enable
+  0x80x0 0000 0300 0002 stvec     Supervisor trap vector base
+  0x80x0 0000 0300 0003 sscratch  Supervisor scratch register
+  0x80x0 0000 0300 0004 sepc      Supervisor exception program counter
+  0x80x0 0000 0300 0005 scause    Supervisor trap cause
+  0x80x0 0000 0300 0006 stval     Supervisor bad address or instruction
+  0x80x0 0000 0300 0007 sip       Supervisor interrupt pending
+  0x80x0 0000 0300 0008 satp      Supervisor address translation and prote=
ction
+
+RISC-V F extension registers represent the single precision floating point
+state of a Guest VCPU and it has the following id bit patterns:
+  0x8020 0000 04 <index into the __riscv_f_ext_state struct:24>
+
+Following are the RISC-V F extension registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x8020 0000 0400 0000 f[0]      Floating point register 0
+  ...
+  0x8020 0000 0400 001f f[31]     Floating point register 31
+  0x8020 0000 0400 0020 fcsr      Floating point control and status regist=
er
+
+RISC-V D extension registers represent the double precision floating point
+state of a Guest VCPU and it has the following id bit patterns:
+  0x8020 0000 05 <index into the __riscv_d_ext_state struct:24> (fcsr)
+  0x8030 0000 05 <index into the __riscv_d_ext_state struct:24> (non-fcsr)
+
+Following are the RISC-V D extension registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x8030 0000 0500 0000 f[0]      Floating point register 0
+  ...
+  0x8030 0000 0500 001f f[31]     Floating point register 31
+  0x8020 0000 0500 0020 fcsr      Floating point control and status regist=
er
+
+
 4.69 KVM_GET_ONE_REG
=20
 Capability: KVM_CAP_ONE_REG
@@ -4468,6 +4595,23 @@ Hyper-V SynIC state change. Notification is used to =
remap SynIC
 event/message pages and to enable/disable SynIC messages/events processing
 in userspace.
=20
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
+If exit reason is KVM_EXIT_RISCV_SBI then it indicates that the VCPU has
+done a SBI call which is not handled by KVM RISC-V kernel module. The deta=
ils
+of the SBI call are available in 'riscv_sbi' member of kvm_run structure. =
The
+'extension_id' field of 'riscv_sbi' represents SBI extension ID whereas th=
e
+'function_id' field represents function ID of given SBI extension. The 'ar=
gs'
+array field of 'riscv_sbi' represents parameters for the SBI call and 'ret=
'
+array field represents return values. The userspace should update the retu=
rn
+values of SBI call before resuming the VCPU. For more details on RISC-V SB=
I
+spec refer, https://github.com/riscv/riscv-sbi-doc.
+
 		/* Fix the size of the union. */
 		char padding[256];
 	};
--=20
2.17.1

