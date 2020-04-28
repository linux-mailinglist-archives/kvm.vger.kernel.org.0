Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9521BB7C6
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgD1Hf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:35:56 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57413 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgD1Hfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:35:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059356; x=1619595356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6S+R7bwVmxE1LqS33wXuTSfax3DLmGMDbbRdj/k6pi4=;
  b=ZKOi2wQIcjT3oq7s1gsxt5+PLXr/BLDNBLNJ+0lGxNV02DVGrF4QqCyx
   QKAVo5BbP6xTVZCmouo1WuvfRu7ac85W0dyxR8xg7VMRjvnyTCh+OnTjf
   dOakbyjU4FiGluWaCxJj8wqdWOw/eSi5FfSilKhsvl5Xs/APTq3rT0p0m
   YpbtqOKZtoIoAB/6fnoIUz6o3ySHn/xY7grXT+gpPZWFLGUtUGe5Jfexx
   VSuXPgX0oeBDxxONvGqR9PMimWUsjZnfKNCBr+njJoTohK9Q6nmqPw+Sf
   NyW5GAP2wYYwQ/oesHhzpkPVyrMMVpRnbBICpsJd1V7JbhuYrBrQ6qd5z
   g==;
IronPort-SDR: d2LBoWx4UOevHsEGFk6IYVZZEmkVoKGM36E5oZVIoVbvRpXJHF3oTf1MRafyIt1EP5GU3aGbKV
 TM6zcQthHmzOV9OHhYwot/xyFZWu9bJR6MM3d5EGmaSObI7dQOOxD6WeJj2HV5EOuA/EsZDG5H
 DtuuL5vxt1GQS6nfPA2pwIbVyfRP0VwL8M23gigsOBtjg81/dXMzU+pizTiL+wdjIoi+v+NBG+
 xnJGqNC5rp5ArFnB9xOksv4jM4sE8iBpINx8TcOLkCZl7HD0JNAuyUIg7R8at8DQFeyl9Y+JJT
 a2s=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865954"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:35:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRyHr8LsrSCL3UYChmGFDl3m89YDGsa5MSpmCSwVE0uf276BQlMxMY1i1KSqSHwluYG7uoMLRbP1NLmIuMIJtaWEBKjxcOBeb9EnBTr8KtjaAKk5aX/Ep0y+9e3DW2V3IrEBnE8dZlzOMhyvazuEc65HQd/x8R76sJTYLTRAYXxcdslCM/WGUmc6Ov/oQ1621AWkFE5cfWWVond1iTGc3i2oi/YeKD5qBYtpqDts7sAfBBRBwV9xbcM6gPf/HXBvaFkOFHpdOr5xPJ4RKuqFUpsqf1wOIS//SdPxRX0SwcyGusRcTkWhNsCaYyiFtB3rO9G3av58OSu/53abp12w0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQTg+Nj9C1Ex8WU2GmgU3H9BxMyHanFRicua+xztLkU=;
 b=VzCftoZS2XMJOzRGl6SBlHr8fgKIHv/HJzvy2oU7PPVNn9dgkPjyQezZGjSNlV6J57P4cADONww0dW4lXqQ+ucNfEKvA5QkNgdpfT8FZM7/Z/3laj7vlwJ48wb0uspK7tIaNwizNVs0qOxePjksnsOEq6DdKm/LbDtUyXlqvPDPd+I22P7r0e93tBqP/W7bjuXWOhNfsXAD+TAGfPNYWv7N4TD90b8X3upms3Vzv64rZaFWNB0ssaxNa2C/m5nEnawHfyS/ROpV1c/oc5ksW1yJ7zhkhy77KZmd2x+AYtrEoggqBrrK2sPYhluNq2LoADYj72ct10nVf52s2qX8DDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQTg+Nj9C1Ex8WU2GmgU3H9BxMyHanFRicua+xztLkU=;
 b=mkJUGGoOmj7dsRi2tayDsJ8uqGFbn32kEzy0HIwNioRYgU51Cs+aPrYCCKSGQ/0awPun5TKDvHlHVNe2ublwO0/Iqj1TZkcdtl+PDXc4aA2Kx/JqRYb8GPI9mzgT4LYeu4LKvaFaP6YNC+CELjQeX5V3Efa8pqBZT/zuJwb4UPw=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5929.namprd04.prod.outlook.com (2603:10b6:5:170::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:35:52 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:35:52 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH v12 16/17] RISC-V: KVM: Document RISC-V specific parts of KVM API
Date:   Tue, 28 Apr 2020 13:03:11 +0530
Message-Id: <20200428073312.324684-17-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:35:44 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d096549a-8128-4327-032d-08d7eb46c73b
X-MS-TrafficTypeDiagnostic: DM6PR04MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB5929B1ABA95C32ED302961D68DAC0@DM6PR04MB5929.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(1076003)(66946007)(2906002)(5660300002)(966005)(66556008)(66476007)(7416002)(86362001)(478600001)(55236004)(55016002)(30864003)(186003)(8936002)(316002)(4326008)(7696005)(36756003)(956004)(110136005)(8886007)(2616005)(6666004)(26005)(16526019)(54906003)(44832011)(52116002)(81156014)(1006002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: znN1eJcq33kgJLfAsXHgSQZWF0lybzDS/6XOvYiN7cEOC/WOyDKYIUfrPQW5aTRY1W5X3bioTYSZB8IP6coZtvBny9sypPTia4zlUhJhIiEbPjEn2D6pJ/H0Aa682VjjdjDl1rHoOxK8xU+InS2oupGVLNr9BWN3e7BJ5KzMyAG8Q08oXQX3A84zLSUzeWOuCifC9FuHfhLjoiYwh8Q08+9lmi85Ogdkwj51HXKEthPAsRcHrpq38AF1ylGRkfEjA6d0E2eqgZMHB4kBFB5k/D/Jttpjd7lrgJX+aUym6p1GZ3jR2edq6GC71NiVtIWOhN5pbIoOe+GNa6hBC1TTY+6WA1/6EoElMvZZFbsVW99wyTZtcWu3qcUc/aLK2oleXS7gjh1zcugXofJJZH19Rug4hYyhdGvGfgDAL6dC83cdOyyrXp+tvXY80L6TWVr14C5zHsDzk8Tk8v8PqALp5ywT6CF5d0KtGy7tDRaXoifjNPPmr7CNz7R0TrSLb7/GhM8LjQ+UmUCV41nBA2J24w==
X-MS-Exchange-AntiSpam-MessageData: 5tzWF+V/EBmKNS7mabwiCBtyaxvwDDQo+mvu8CBrTIvroWwrCMb3TMKDeLljNPK3bYPtII/aHnC/CccYtnvZ++5QsYx3eZ6Nqk4nbLAwpJgKAW912EjMs9yqrFDK5l3sr0LPN6ReLQPBn+u7gU+7K9OX+Ny+vi5zC309+U/3z8F78okf3j25dE8fPa3BbiAW0z0VXGdXNjdPzfNGrI1t+TTvyqzn+Wsjrhwu1mTCl33zu9weQ2EAb8r4iOGQIas47QjORD1u5cWf0tV5Exux7mojuvc4iSs/A2G96WaxUzItdDRcJiF8B5IFz8Lg4kpWzsADHLJ+boRyH9s6DNyRODjNJbfqF86uurBkPgX0v4xSlkVvMNIp0F+y2sBDXFsv3y1d6OLD+CbVpJ2LcS1AWiCEcI8VO6ynvCmi4MmfrAtWGyUEnfDWgoh3PMFQ3jaxWnS2ZDMgGGy6eHFZHQeRE2HYlq8xOrvmday4OKsuqO6XUmrUyvyfy/gRLZ3OPYiom/dPjXz8uJVQgUMxp/jD3S5A4VN4ijiBzOtyjuABD8oV51TE7WKYQ84JAIM/GX1wiHjn027iYw+Wl7IN5vjb8FtWzN3Rl7rmi5sfcZUjTZHsauYSA6ljqAr3IhK51NiTWw6CgUndiC1af1cgxlyezTqZzN0iwtGKWVDWBIquePR316ZALMQe+A+2uO+QwYtYvvvSrBxzWYRB1QfpMz5d5vbORSpK2XMQG7p7mpatCZpDkfC9MUg3Yj62E2Z/qLpWHYAG7oNwzcF78gUH0SKXcH3YI12VrLr9kCVyrGLFjiM=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d096549a-8128-4327-032d-08d7eb46c73b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:35:52.3652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62mHqJPMfVprurP6Bkh9LqEUIEuMwCA8BsouoMbPn830/rnRqPoBeVTlMFiEBXUMSoG1vxhCSw4VkorDVNrcTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5929
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
 Documentation/virt/kvm/api.rst | 193 +++++++++++++++++++++++++++++++--
 1 file changed, 184 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index efbbe570aa9b..c2f9a535993f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -513,7 +513,7 @@ translation mode.
 ------------------
 
 :Capability: basic
-:Architectures: x86, ppc, mips
+:Architectures: x86, ppc, mips, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_interrupt (in)
 :Returns: 0 on success, negative on failure.
@@ -582,6 +582,23 @@ interrupt number dequeues the interrupt.
 
 This is an asynchronous vcpu ioctl and can be invoked from any thread.
 
+RISC-V:
+^^^^^^^
+
+Queues an external interrupt to be injected into the virutal CPU. This ioctl
+is overloaded with 2 different irq values:
+
+a) KVM_INTERRUPT_SET
+
+   This sets external interrupt for a virtual CPU and it will receive
+   once it is ready.
+
+b) KVM_INTERRUPT_UNSET
+
+   This clears pending external interrupt for a virtual CPU.
+
+This is an asynchronous vcpu ioctl and can be invoked from any thread.
+
 
 4.17 KVM_DEBUG_GUEST
 --------------------
@@ -1360,7 +1377,7 @@ for vm-wide capabilities.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (out)
 :Returns: 0 on success; -1 on error
@@ -1377,7 +1394,8 @@ uniprocessor guests).
 Possible values are:
 
    ==========================    ===============================================
-   KVM_MP_STATE_RUNNABLE         the vcpu is currently running [x86,arm/arm64]
+   KVM_MP_STATE_RUNNABLE         the vcpu is currently running
+                                 [x86,arm/arm64,riscv]
    KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
@@ -1386,7 +1404,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
-   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
+   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64,riscv]
    KVM_MP_STATE_CHECK_STOP       the vcpu is in a special error state [s390]
    KVM_MP_STATE_OPERATING        the vcpu is operating (running or halted)
                                  [s390]
@@ -1398,8 +1416,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1408,7 +1426,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1420,8 +1438,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
@@ -2532,6 +2550,144 @@ following id bit patterns::
 
   0x7020 0000 0003 02 <0:3> <reg:5>
 
+RISC-V registers are mapped using the lower 32 bits. The upper 8 bits of
+that is the register group type.
+
+RISC-V config registers are meant for configuring a Guest VCPU and it has
+the following id bit patterns::
+
+  0x8020 0000 01 <index into the kvm_riscv_config struct:24> (32bit Host)
+  0x8030 0000 01 <index into the kvm_riscv_config struct:24> (64bit Host)
+
+Following are the RISC-V config registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x80x0 0000 0100 0000 isa       ISA feature bitmap of Guest VCPU
+======================= ========= =============================================
+
+The isa config register can be read anytime but can only be written before
+a Guest VCPU runs. It will have ISA feature bits matching underlying host
+set by default.
+
+RISC-V core registers represent the general excution state of a Guest VCPU
+and it has the following id bit patterns::
+
+  0x8020 0000 02 <index into the kvm_riscv_core struct:24> (32bit Host)
+  0x8030 0000 02 <index into the kvm_riscv_core struct:24> (64bit Host)
+
+Following are the RISC-V core registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
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
+  0x80x0 0000 0200 0020 mode      Privilege mode (1 = S-mode or 0 = U-mode)
+======================= ========= =============================================
+
+RISC-V csr registers represent the supervisor mode control/status registers
+of a Guest VCPU and it has the following id bit patterns::
+
+  0x8020 0000 03 <index into the kvm_riscv_csr struct:24> (32bit Host)
+  0x8030 0000 03 <index into the kvm_riscv_csr struct:24> (64bit Host)
+
+Following are the RISC-V csr registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x80x0 0000 0300 0000 sstatus   Supervisor status
+  0x80x0 0000 0300 0001 sie       Supervisor interrupt enable
+  0x80x0 0000 0300 0002 stvec     Supervisor trap vector base
+  0x80x0 0000 0300 0003 sscratch  Supervisor scratch register
+  0x80x0 0000 0300 0004 sepc      Supervisor exception program counter
+  0x80x0 0000 0300 0005 scause    Supervisor trap cause
+  0x80x0 0000 0300 0006 stval     Supervisor bad address or instruction
+  0x80x0 0000 0300 0007 sip       Supervisor interrupt pending
+  0x80x0 0000 0300 0008 satp      Supervisor address translation and protection
+======================= ========= =============================================
+
+RISC-V timer registers represent the timer state of a Guest VCPU and it has
+the following id bit patterns::
+
+  0x8030 0000 04 <index into the kvm_riscv_timer struct:24>
+
+Following are the RISC-V timer registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x8030 0000 0400 0000 frequency Time base frequency (read-only)
+  0x8030 0000 0400 0001 time      Time value visible to Guest
+  0x8030 0000 0400 0002 compare   Time compare programmed by Guest
+  0x8030 0000 0400 0003 state     Time compare state (1 = ON or 0 = OFF)
+======================= ========= =============================================
+
+RISC-V F-extension registers represent the single precision floating point
+state of a Guest VCPU and it has the following id bit patterns::
+
+  0x8020 0000 05 <index into the __riscv_f_ext_state struct:24>
+
+Following are the RISC-V F-extension registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x8020 0000 0500 0000 f[0]      Floating point register 0
+  ...
+  0x8020 0000 0500 001f f[31]     Floating point register 31
+  0x8020 0000 0500 0020 fcsr      Floating point control and status register
+======================= ========= =============================================
+
+RISC-V D-extension registers represent the double precision floating point
+state of a Guest VCPU and it has the following id bit patterns::
+
+  0x8020 0000 06 <index into the __riscv_d_ext_state struct:24> (fcsr)
+  0x8030 0000 06 <index into the __riscv_d_ext_state struct:24> (non-fcsr)
+
+Following are the RISC-V D-extension registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x8030 0000 0600 0000 f[0]      Floating point register 0
+  ...
+  0x8030 0000 0600 001f f[31]     Floating point register 31
+  0x8020 0000 0600 0020 fcsr      Floating point control and status register
+======================= ========= =============================================
+
 
 4.69 KVM_GET_ONE_REG
 --------------------
@@ -5130,6 +5286,25 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+::
+
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
+If exit reason is KVM_EXIT_RISCV_SBI then it indicates that the VCPU has
+done a SBI call which is not handled by KVM RISC-V kernel module. The details
+of the SBI call are available in 'riscv_sbi' member of kvm_run structure. The
+'extension_id' field of 'riscv_sbi' represents SBI extension ID whereas the
+'function_id' field represents function ID of given SBI extension. The 'args'
+array field of 'riscv_sbi' represents parameters for the SBI call and 'ret'
+array field represents return values. The userspace should update the return
+values of SBI call before resuming the VCPU. For more details on RISC-V SBI
+spec refer, https://github.com/riscv/riscv-sbi-doc.
+
 ::
 
 		/* Fix the size of the union. */
-- 
2.25.1

