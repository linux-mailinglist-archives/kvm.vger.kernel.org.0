Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A04A1C13
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 15:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfH2N5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 09:57:25 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:1261 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727495AbfH2N5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 09:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567087043; x=1598623043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Kkephy5QLnYFqirv8XkQdyOo6hue7ZqNcRAcvw1tD5U=;
  b=KVkZ+gUVpkhvK6VBh19Vynmg15P0FaSRjR5ndhSrDsoGw5XCcpa9B/sb
   p24sBkMRBHGAPojXQ8+cjSJMQXGxROuNKJ1jWkjeuvw1Q11nl5kEOmreg
   QTQUeoHlNerkAnGk4WnXa4uAtPiVoyZcVRRAjmfjn6Esg36kFh0c8NjaT
   RHiJBefW6VvnVGXJoEU20j56MQxsM6pjY6uwSv1jUmj0c7v4esxrhoxrZ
   WXWjJGPoyAq0vCCJySem40GQy2cZZ+46pQYHKb7EkbVIJF4MHyksejldC
   wrx+JTJsyjPXIsxrqUROovyTAjlxN4/5V6DD83/O6PMNRGu4R6guN/48m
   w==;
IronPort-SDR: ipXeVTaOw8eLJYvApl4VOlESG8CU7Y9snjye70KLFhufr7slUiguzAvSqdV32mWe4i6v4IKaZv
 rxVQu0ap4qm1ooIUJD5FdPqviduQEeh6U+qUzO65DbB7btgYjBj8vV4GeqIpkQT10VlPFNnNpP
 NmktjrhtwyYLsrahfsG4jhWRGJwY6ZyTEaLXhi+Lthw9hZWAZ7FYi/JVQNzLlPe/ihnM6cm2iv
 HBQw5NaNjmzQNpEdyz2laL8+SW2ufv0B2m/gzkT0BLTeYaxAviljAK12KbJAcReReQw+Qxf2JD
 S6E=
X-IronPort-AV: E=Sophos;i="5.64,443,1559491200"; 
   d="scan'208";a="117866040"
Received: from mail-co1nam04lp2053.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.53])
  by ob1.hgst.iphmx.com with ESMTP; 29 Aug 2019 21:57:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMwDZWvu14c/3qqT4oeZdHTolfk159K9eF0lU9cagNuWh5HV5PhFMbAez6c4H8MABoLsiqoL77sCYDYIElMA2ob3Hl9HgYbSeol6wj9sLd0HoSZET51ZFMnLD0T9rI8WNiU4CgU2cVpMlP5G9LHp3iBiz2juMHS8mDPFvU9rtmc/lW6ggEgb/BXqRbnR4ztZ4V3cadCcVyyTHLBi14OvHdrt7S90X5aCyonV1cYWl2ZSPTCda/Jto3Ma+UuHj3XkI3cqr+9OoihyaxqubSBsWrstSuJlWfSmxtEJe3UFeRl/HjVQfLKZCL6Fv7YAYqj0I3NHkp6NK5Jl1lC2L0tS2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzGICNTx8LnRhCayZgeedsdYmTwnBn+eOIwNyw84v/Q=;
 b=PbNjxE4gtQE1u9VMnnkcKnsMBpm01LI9+Ub2cTOKTndxYipXtHvufpTmXhtVHvYrGOfSIi86VW844yXUm7M2u8XzOqSngo4jutw4fqKShX+7OBKJNB2RRG/9YGgpKkTG0lHmUO3FR+nUBupQ8522z+pHFJBVHdqbhBZBIIsT+qyHnblW9gaNhEfRCoVojChgbL90HQN1stg6UZBMwj2FFRSav2gPk5W9xYdBYy8hVenidgpvlg7KDZvrx24SrNco4bD6C+kl2cgXS6CNolbKl40RpqR4yIYcgqNqKJeyoT1xTVwQJlmUurt/EiSJh0A0T/jigkAlb45IUcxtCTiu5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzGICNTx8LnRhCayZgeedsdYmTwnBn+eOIwNyw84v/Q=;
 b=ycENAVFHyJqAMhOty14wDZMO0P6VjUbHlrLuNxVVXYD4qKuWinPJpd7AWzrl8ZsZKK+USJCUACxATcZ1MZDKWwmFazPgVP1M8dRQzmrmuMwA2r5TFj/l2gnAt2giG62Es7VhtVfQBTVv1mG50zhcSITzD70UxCVB8u1hnwqbzLw=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6255.namprd04.prod.outlook.com (20.178.245.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 13:57:19 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.013; Thu, 29 Aug 2019
 13:57:19 +0000
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
Subject: [PATCH v6 19/21] RISC-V: KVM: Document RISC-V specific parts of KVM
 API.
Thread-Topic: [PATCH v6 19/21] RISC-V: KVM: Document RISC-V specific parts of
 KVM API.
Thread-Index: AQHVXnGsCSsdv7zarECkOyVwalOdxA==
Date:   Thu, 29 Aug 2019 13:57:19 +0000
Message-ID: <20190829135427.47808-20-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: b80431f6-5b6c-46bb-0076-08d72c88ceaa
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6255;
x-ms-traffictypediagnostic: MN2PR04MB6255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB62552D69C73C7E2CBFD8FF658DA20@MN2PR04MB6255.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(199004)(189003)(446003)(55236004)(11346002)(76176011)(386003)(2616005)(53936002)(36756003)(25786009)(5660300002)(4326008)(6436002)(316002)(6486002)(99286004)(6506007)(71190400001)(256004)(14444005)(6512007)(486006)(52116002)(2906002)(476003)(1076003)(102836004)(478600001)(81166006)(81156014)(110136005)(8676002)(54906003)(26005)(66446008)(64756008)(66556008)(66476007)(86362001)(7416002)(6116002)(50226002)(7736002)(14454004)(3846002)(66066001)(8936002)(44832011)(71200400001)(66946007)(186003)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6255;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XrFnqR1NDeExSbnxXopvJGoM7M21s0VVTnan05cvMKCIHDZOJJEzeTpfr8iSkn9CSCB5Ls+1DNPeR+P/8qLc0vBCo2Hjbk6y3sJRJWIs65YkV7/AnrVT0Xal4NdFkm4Kh2Quzh7ido/uDgE+IApnzKI5A3qSU7ahFrAlQsbjUtCQImhW5RLqvATCb2xUR9ha+geh4rgaX0CJKTZ13tOKKdXbW8EL/R53y7LrErkGjiBAUguE90j8QhEPnYt8AnKfrDVWqwyV3gEcRGTcBvGCwPqsizcPfm4g9Qyl1kS5TLjiMXsF5mAA5Pq2Sv8IkfG9JxX2NPIQSDYUfEgDQ2XH+5xk50uTcGgtEoKuDxDJ8ml2IhH5JdXehZEyQ6SNTOmrZK4YKezYCpI9PUUvXErx+AdINoOYkvtr2Y5rX4nNbj8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b80431f6-5b6c-46bb-0076-08d72c88ceaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 13:57:19.2245
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 70Cp6mQTwuVrKNGgzeGCGiYyt61rasYqFFHSPyfDOD5gsx+OI9DdSrf4v82+DLgy1QkCqZvSM2gtI5uNvgtgNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6255
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document RISC-V specific parts of the KVM API, such as:
 - The interrupt numbers passed to the KVM_INTERRUPT ioctl.
 - The states supported by the KVM_{GET,SET}_MP_STATE ioctls.
 - The registers supported by the KVM_{GET,SET}_ONE_REG interface
   and the encoding of those register ids.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Documentation/virt/kvm/api.txt | 140 +++++++++++++++++++++++++++++++--
 1 file changed, 133 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.tx=
t
index 2d067767b617..80c4ffad8bd7 100644
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
@@ -1206,7 +1222,7 @@ for vm-wide capabilities.
 4.38 KVM_GET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390, arm, arm64
+Architectures: x86, s390, arm, arm64, riscv
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (out)
 Returns: 0 on success; -1 on error
@@ -1220,7 +1236,8 @@ uniprocessor guests).
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
@@ -1229,7 +1246,7 @@ Possible values are:
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
@@ -1240,7 +1257,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IR=
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
@@ -1248,7 +1265,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is pa=
used or not.
 4.39 KVM_SET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390, arm, arm64
+Architectures: x86, s390, arm, arm64, riscv
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (in)
 Returns: 0 on success; -1 on error
@@ -1260,7 +1277,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IR=
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
@@ -2269,6 +2286,115 @@ following id bit patterns:
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
+  0x8020 0000 02 <index into the kvm_regs struct:24> (32bit Host)
+  0x8030 0000 02 <index into the kvm_regs struct:24> (64bit Host)
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
+
+RISC-V csr registers represent the supervisor mode control/status register=
s
+of a Guest VCPU and it has the following id bit patterns:
+  0x8020 0000 03 <index into the kvm_sregs struct:24> (32bit Host)
+  0x8030 0000 03 <index into the kvm_sregs struct:24> (64bit Host)
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
--=20
2.17.1

