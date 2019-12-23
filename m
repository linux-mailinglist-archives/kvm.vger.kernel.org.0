Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E666129588
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfLWLhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:37:45 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12839 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfLWLho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577101065; x=1608637065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UvnUQXs2BdistOOiP52rG9y1rY3zBMVacp8wm498aN0=;
  b=b2zOcsYkw+JaIFSnXXS2IcXAVUGtdWjutGUg+2W+WSGfhlJ1+ofsSMaz
   jgcnp+NjWd44h/P8jDzWM1OXfsCbkc5067KQt+cGqMPIIsuAigI6a8UUP
   teJHvbBw9Un2/3sJtb0CTjePdqpIvSCO228pRhaMjkJUiSj24kAy3jY1S
   xqHOvXebkLAuFq4N70FP3SHueJOn7tRy9UnbxAyHgzwB4PgWcf6r7hgik
   lkFqm0g8SKA7uRKT8He1LqqeNp+yHdOVODi/7LAG45Oq/2EVhswVAVZTI
   iPuDKYE7M4Pcy/7GURaXTz1mWIhHttvg5MJTIOsyRwA6l6sILu6IGOHQK
   w==;
IronPort-SDR: Fd2Ws8oDgUv1zMS3K3ILrDogwtWmi/ynayxiE26SVINd6nM5w9q241OLFauM7x8NakymsPPDOX
 h7KdyFRA0XofrQSY51BXNaluUoMGOsU2DhKiOGjPUvkqaawTmrWd44h2T+OKmZFqScYDPPO+Su
 /CmB5chNU1WMZ7b1kHxC5J1c8I23mk7ydDPqOuMCCtYt2gWabFzVl+u+JMmQ+IlwUBqMZFBe97
 OXEkd2tJAQgm0nmZG1XtME3Zg1JkOUBLujkQU23kG20qQDq3kSnsk2JNxDR8yWqsGmQK8o4930
 +ko=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="126720992"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:37:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QS0s6vd//UEbaY2p7nt+omAXdFpkJIPNf10/ScusN8SMz9va0EL7VYsYPI41PGcAml0KrkVv3REQYoPk+nWymE9f7auyAbvvQnlyro0PXheuNvvg85d8JMTV3vlBXxn1W5JNtjbkKsShVnUY99fwKvOcTo7QzjLEKLW+Jqy5FSH5tVM6N3xf1eOhdNb6Oz2cC/RjHREHbGlEE/nA63R7R02HktOOj72GluyKb8WfGh2eIzaEN7awFczpTn8yp6u9OGG78WAHfjo10f8ljSIzavuo9h0LzkEppoCZvI4bSelaLsrys15VLKzt0FmxnM4RdXbzcpXMHrT6rAK/+ZO6gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo7PibNqTAfNpsI1KmijOpO1HcCZgruOgUqa9D8Q00Q=;
 b=C3NlR4AVV0XovgieOIEqvnPpFzOqJbicUH/pjs6lwXjSGD7mFnD7Pe1dVAY6B6a/v5dON4mzwOlMS2s80t0pO5/j0SWvyJDKfpYJcycyNhsOFbt1ZtgQgjOSY68yG0U6X7HHmPg8Kz98txPZjYFVK4VspoWGHmftY66CkH+g1rHibEY0zDjAEaoXrNhAhjkX5ixjyvDSna+AOmE/5VmZGEOY3nlzExQYXa42vV73ON/eUQ0JATve2HawmDxut1eQWVfNOkpA5Co6KzVHQ36onOsGRxFaXTpJaMrHG9PhMisiJTvLyIU5OnaT6dMw6GBJefkjWaZdd0o0enzvanVYHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo7PibNqTAfNpsI1KmijOpO1HcCZgruOgUqa9D8Q00Q=;
 b=nYNBRMn3VfQY3slps3mMYco7CeOqNgfoypKK3llsoTM3u33dXZDYO5YwWLxv5vRAKxEFV0e/FwGcW9vJZt+9V0RFmRlfw84jHJDg4j570CzAwiE2k/24mMEDAXHEhvoF8O6QelCMW2f8L740OOPuxB7vkIt9D0Bn3grKn791dmY=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6480.namprd04.prod.outlook.com (52.132.171.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 11:37:38 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:37:38 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:37:32 +0000
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
        Anup Patel <Anup.Patel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: [PATCH v10 18/19] RISC-V: KVM: Document RISC-V specific parts of KVM
 API.
Thread-Topic: [PATCH v10 18/19] RISC-V: KVM: Document RISC-V specific parts of
 KVM API.
Thread-Index: AQHVuYVhZt7io4wKC0e+0q40zZhOyA==
Date:   Mon, 23 Dec 2019 11:37:38 +0000
Message-ID: <20191223113443.68969-19-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: bf9675fe-3233-4020-e7b0-08d7879c8361
x-ms-traffictypediagnostic: MN2PR04MB6480:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB64809AD861E52516E57199338D2E0@MN2PR04MB6480.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(36756003)(2616005)(956004)(478600001)(44832011)(2906002)(55016002)(966005)(7416002)(52116002)(7696005)(66446008)(66556008)(64756008)(66476007)(4326008)(1006002)(66946007)(8936002)(26005)(1076003)(54906003)(110136005)(186003)(8676002)(71200400001)(81166006)(81156014)(55236004)(86362001)(16526019)(8886007)(30864003)(5660300002)(316002)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6480;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uozsYUpFcZHyepjyj6LN6vCN9hZk7G25Dg75cNcTZut7XuvxwH1gvIgz0qNGsXzanEe6Pu3yEZSOAJxw9qsLylmzWX5Iv+GBzUAd9J4Cm6qgKHkpvVsKSzcxVGnKKTbsnH+v8EpvCQgA8QZyQ3LNOuOHNFPR6jz08LsOsbSRCJI5mz6xF6BvrZ0GdwvKVJeo785/0plXJNq078DX2lfeY8lRYHkSRfo7+lcAP/q1W1ovDpy5LvHgXwxHe0UhDfw5s4m/KowTL1Ila6A/N5zXfW5WoqAc00IWr+0SMsGPilH3mB2OmZOa4/YTKEM222iB7qA3lmgXeLJwqt6aywuN2a27xFhrlun7m2284+yS2vqjHynDFRCSTEaTkj0obMkqe6d2Kq3E+UxMrK51y/olfwGXjTlKMkurf2ptBoGaW1G7pbnVyq10sYPs9wH7HXK38KfFt7zjTrVMNiQd9MJ5xrJUC6bbemJxfVYr/Ypek2TWSSYnvyoJa66ZcYjyS1kKMEC0BXvI3hE6Rk3iVEeJ/eAE1H7AIzQHqMmbJXHET0U=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf9675fe-3233-4020-e7b0-08d7879c8361
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:37:38.8182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9/hnI73z775V3nPi70nzG4rtF+M2IAGORZ94/2vxNoee/Wds6oYakfjKE9/tVY9sDarbkPghhx2AU/0Bu9X9gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6480
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

CC: Jonathan Corbet <corbet@lwn.net>
CC: linux-doc@vger.kernel.org
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Documentation/virt/kvm/api.txt | 169 +++++++++++++++++++++++++++++++--
 1 file changed, 162 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.tx=
t
index ebb37b34dcfc..381a2e6df8c6 100644
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
@@ -1239,7 +1255,7 @@ for vm-wide capabilities.
 4.38 KVM_GET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390, arm, arm64
+Architectures: x86, s390, arm, arm64, riscv
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (out)
 Returns: 0 on success; -1 on error
@@ -1253,7 +1269,8 @@ uniprocessor guests).
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
@@ -1262,7 +1279,7 @@ Possible values are:
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
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1281,7 +1298,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is pa=
used or not.
 4.39 KVM_SET_MP_STATE
=20
 Capability: KVM_CAP_MP_STATE
-Architectures: x86, s390, arm, arm64
+Architectures: x86, s390, arm, arm64, riscv
 Type: vcpu ioctl
 Parameters: struct kvm_mp_state (in)
 Returns: 0 on success; -1 on error
@@ -1293,7 +1310,7 @@ On x86, this ioctl is only useful after KVM_CREATE_IR=
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
@@ -2302,6 +2319,127 @@ following id bit patterns:
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
+
+The isa config register can be read anytime but can only be written before
+a Guest VCPU runs. It will have ISA feature bits matching underlying host
+set by default.
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
+RISC-V timer registers represent the timer state of a Guest VCPU and it ha=
s
+the following id bit patterns:
+  0x8030 0000 04 <index into the kvm_riscv_timer struct:24>
+
+Following are the RISC-V timer registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x8030 0000 0400 0000 frequency Time base frequency (read-only)
+  0x8030 0000 0400 0001 time      Time value visible to Guest
+  0x8030 0000 0400 0002 compare   Time compare programmed by Guest
+  0x8030 0000 0400 0003 state     Time compare state (1 =3D ON or 0 =3D OF=
F)
+
+RISC-V F-extension registers represent the single precision floating point
+state of a Guest VCPU and it has the following id bit patterns:
+  0x8020 0000 05 <index into the __riscv_f_ext_state struct:24>
+
+Following are the RISC-V F-extension registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x8020 0000 0500 0000 f[0]      Floating point register 0
+  ...
+  0x8020 0000 0500 001f f[31]     Floating point register 31
+  0x8020 0000 0500 0020 fcsr      Floating point control and status regist=
er
+
+RISC-V D-extension registers represent the double precision floating point
+state of a Guest VCPU and it has the following id bit patterns:
+  0x8020 0000 06 <index into the __riscv_d_ext_state struct:24> (fcsr)
+  0x8030 0000 06 <index into the __riscv_d_ext_state struct:24> (non-fcsr)
+
+Following are the RISC-V D-extension registers:
+
+    Encoding            Register  Description
+------------------------------------------------------------------
+  0x8030 0000 0600 0000 f[0]      Floating point register 0
+  ...
+  0x8030 0000 0600 001f f[31]     Floating point register 31
+  0x8020 0000 0600 0020 fcsr      Floating point control and status regist=
er
+
+
 4.69 KVM_GET_ONE_REG
=20
 Capability: KVM_CAP_ONE_REG
@@ -4542,6 +4680,23 @@ Note that KVM does not skip the faulting instruction=
 as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing s=
tate
 if it decides to decode and emulate the instruction.
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

