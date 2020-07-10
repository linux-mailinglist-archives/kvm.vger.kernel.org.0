Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0E221B14E
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgGJI2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:28:13 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:31073 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgGJI2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594369686; x=1625905686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=W0jTz/41TXqVBU2s3gwLOK8P0y1SQD6UG38dMdl+VjQ=;
  b=BGZWS/9WcJgNHxm0JFSPRF72t1RLtQEkBHMJ84K/ViTKSKhxAiBDGpVK
   dvZEEOWLVIMSkOI2Lwpv80C6CnkkcPZLwQBVwNsHiHRVlYQzmMwzAt3j7
   eScg1PCOzS63+Oz81LH2RQDSMM0V4gSo7dsillz+duKUdhgbHQ/Do88yH
   Vd/ZQ2sRFaA5lVFBw5obBDQevBeCIdz7G0VnLr82B/ni1aLcVYi6UxmiD
   8c08BD9+FVoN99/nJIqCaD3KANsztX4MLdnEeLVlgrOYdZ9IR5UoYi1s0
   LLoQiBKr2dudnW+tVIehczJMWZuAS84aiRSJBI27yzrKaNsr30hZUlxL7
   A==;
IronPort-SDR: fSgQkdqvCT0JSAZFEtGkB68GCogV42tqS3qpnh8F0J5TNfQ4HhMqAMOfSSmCkHwcSJ4Q7lAvSG
 I2uI3W+azdd5f3LHJmv/hY3cdToSRiToAzY6fVyoShhQ0pbz2QiQMcejo/E01UywIk4WmZnEwF
 duv4rmywz42OfEQyTl4PDF8KO7B5vArguR8Hv85h3Qz48WA1FCnI5VT08TLpZUwcvPeBt8Xwmc
 A27zGJDjAlobIoiNa6kvwOR3Vr4UfkbYtbaa0SEK0vNvgSu9uymuupBEFro8XEICh4z3Daaank
 UBY=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="142121727"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 16:28:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gutxEnrDoAen6CO+mMt2ea4+RijEAUPLhg5VCgHc0lgZ/ipB2H1T55nFvB2IDSRDGTfiNAfLXaFwQarfcRg5boyqyXa4BpmMdMu5BHCRK5ldBU9kzcANG8F21Kbc3CkArS60IahTDboQORLaC8YaDeMqb34lTF+i0fHWrX0g27jNtUGD3kzJ8pQQ61JxvdtvF25I1ZRytFfWjX5nj85J4Jio+MYXk+69ugRKq6nTnvbcb+RhXElmK28NdxFLQQ8A+NS4dfWgZoejlRxoVtnPoZTppBUc2v1aljsBqxDcukzIJzhGzS5X5qu8dCzu0L6556ylcMK0aGkTEHnjmQU7bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ok3rijfn/+tKZvBy7TLQ5ZAnijTgYLOqfyXSiwbjHiM=;
 b=gPF/jQSax85AM+ye3HSFMTLm1YV+x6Jvmeg+nyzVnfKUlDbD8NHIoHFalWRdxjA8kmEOcew8ni4yTudPK0hCWGf9aNR5qdpRvYlq/TK+rjDqZAZjG2ew4CM9wHyKZEez6ZFzbM88mesZF3ncbbkRfDE00wZHVHF4iBSwYN/tYWQsIH5ZXY6bjCvkLLWO5gFw359PI0j0g8OqP3IvspSXtyoAqIiBGKWu2GfrRvrx+VYGXEelEqLdhHS6K3ZrSUXj8vgplMjnJo2/pmav13+l/Kjd/5XiNFaBLlVhoCdCQDYM4MSlryAneOHHlNCxpzZJ6eoiqju7a8z7xsplh0QDtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ok3rijfn/+tKZvBy7TLQ5ZAnijTgYLOqfyXSiwbjHiM=;
 b=pJJ/5zgk/e/pox3onhyk2x31ddeI6uh87f3rez1/NCS0G6PruGVZE0qdmoFD1rZlpF8jiRHEAgsiR4nfL3mGKmQQB6JG5Xl92mmKWpS9bOhCWwaZBOYsrkPvqoLVvYgWpuzCwOCbkY3byGmBiyOCMj3xVv6i3dFh1PxpoaXcXjQ=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0461.namprd04.prod.outlook.com (2603:10b6:3:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Fri, 10 Jul
 2020 08:28:03 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 08:28:03 +0000
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
Subject: [PATCH v13 16/17] RISC-V: KVM: Document RISC-V specific parts of KVM API
Date:   Fri, 10 Jul 2020 13:55:47 +0530
Message-Id: <20200710082548.123180-17-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710082548.123180-1-anup.patel@wdc.com>
References: <20200710082548.123180-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::21) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 08:27:54 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b15f3a4b-97c4-4efa-bf4e-08d824ab2992
X-MS-TrafficTypeDiagnostic: DM5PR04MB0461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB046166464311949382BD3FC48D650@DM5PR04MB0461.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5b/aL4QUFMwyRD6YP6KZhiZCEMXX/Tda2NHLLOXxZDqxfijuKwvBkWa3pRdLBDFHt5w7Wsr0XlFbGjaJgMjgljbmIijWY7cKLMxChQpTyMFaAQT7X9PpKWdSi2jg9Y+z/KTQmFInvrLQJA9IZWYN8qhbY5MsgzSBVGHMGj0B4bw9FytrAz+mFKWC2vxcGiarkYdIFzpk38h6ZHEPDA6ybiJ8kdveUtN2ii7UJGL1xfH+rtaJ4TAnLbtlTJZ0jAUFBFlubs0+2uWQNicQCZjg0jfJHb9wEM8VaSsAq8SR2kn/HwbiStwFVejCcBM/EviCg5xX8T3narfu0T6XLhtSaNSUYL1OLhP+AAGzLhpA2BgoQVgK+HA0FLK83Z22DlCc9geO5IUNXGNLKW/lUJ38Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(316002)(83380400001)(110136005)(54906003)(7416002)(478600001)(6666004)(86362001)(8936002)(966005)(5660300002)(7696005)(4326008)(2616005)(26005)(956004)(52116002)(30864003)(8886007)(8676002)(186003)(66946007)(66476007)(55016002)(36756003)(66556008)(44832011)(16526019)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: R3DVbrCSyz7akB0lz/PHMkra0U6gJXrP//6S32G82M6AarCfrkDzqg0nvzBRtMUzDnDSU22lT2C3vf3nGGv/z0c7zN/0oDNrQMHLfucuioq0EKPG7VCWuUTBdtHA3PpGbut2jEAtaXCjfIcKkhkl6bafe8kRDUJbB+eQ6juAAALMWOIBdv0Kpre9GZn6+t9j/TE+Y6RfWxcVxC9QkiU2dDzvjpLLbFQ6cMrxjsLfj4xmA7vgG8v612gR9ToGfmscRKS8+wHqR4kKJgpQNYE8DA1F9LDM3/CewZTj3BMTvi/cHCspSArXfAauH9N2o4pPdaR51aqI3RayDmlCy9pPIe39M8q0rnC8fjec/opXBQAAKYtpsyOuiX7FWqTjXNzEqVEVTSoIdTJsFre2L6mk+XbZ9iZuxFkoRfazvbHz+JfJ2B9abVUWH2oSWwVdwXqBsbkHKvhm/9jdhTspkkRIPhRq8EI1gXwCOb/Su9vFI2k=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b15f3a4b-97c4-4efa-bf4e-08d824ab2992
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 08:28:03.3222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tXQfGUGbmcwjyGNkVb0VOXlQ+5Yq6Ye3PhJ/mmmLdwMv9RwJnYeMHNCTZJN9SKQ6nGXr04xofzgfRedm/9fJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0461
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
index 426f94582b7a..b9dab2ff13e7 100644
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
@@ -5154,6 +5310,25 @@ Note that KVM does not skip the faulting instruction as it does for
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

