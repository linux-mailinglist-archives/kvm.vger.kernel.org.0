Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A323D6E75
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbhG0F50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:57:26 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16492 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbhG0F43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:56:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365390; x=1658901390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=XwiO7ddLKeD0FrtuHH0oA4ifMXYPmch7wx/MvkpIEgQ=;
  b=MBopixn2GdGJsI+5gI1FijdwfmSSVBxMerYELqRWvgF0fCsvKtKiq7JS
   sQortuwJBwK0FWGfSG6TtGl92NW9JGeGt1ih2/pFgezf/3R4x6MrVlBvR
   +7MMRB5BryDABK9RF86m5d3F+xmvfickfo8b0pE4lXp1CKQSJfeCnHl/4
   +/m0Flp1N8dmqu6s7itaovG5vM9Ci9LOosZrwWemdGuvl+fWucH+XpFtZ
   k6hKCgj/P2s6hOhYY4ZaPx0bcraGgNGQnWKLYOaMviiKjRRPRSmfAe250
   5yqyt40To1CNP2sv/sT9pSeUutmM2MPL5UI/NalKzJUTtScMPAjSs00JB
   A==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="279400159"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:56:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fvx7U875W8vf2Xq5nRdWfDsaqsGtweEb2i+98YApAMMbAdaokviSo1X9iclyCzKaDZNZ2WzwWs0aVC43a44ONIesAJfOAecZ40Pj7RSVGblq68MaRh44nSisxKsDBuGM1uQ5lU2SA8l3y/jM+FVWnCKgjSIvNl+TvoJzM+UVu55TqTpTnq2OoqDf1GpWp3oYHtGf1EeMtXP7mlQ/P8hWbymoDnE/z0kSmRGm/yfypp4CLLjDbhjPk0cCk33YREj9d9DkU+F80vjl90bwjhyeKpSLlPuDtVEcrcznxku59yKXtUnjL9NsZXMEeMJDI1bioMlvhp8TO6eiqzUNbOxnUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nur1JFKaP87dQxFDvU21CF+tgjEBkb2iHLYo1yfpuVo=;
 b=LPftl+9+JNYt82x/bLAlRcOm9vSrPlkLLNViogDUYwkFL6nO0lPXuNIOSDHA51KC/Hqa+by3sOWaEXe8rqPkr8i7iWrGZLp2Izh4vxX9+lxDs0O/mEfbFcUkuJzFTUepc0T7ob58BbMFdlGNvcQAVbMtp3JaM2bb+vJ3su0UuiAd9bZ3qp0NeRJMO8Kszpla5ro8wzQ0zh08dgsO9vGL0b7GJTZVd9EYenOTpOCeoF7y/QvT5IYnfT/G/ARMyPam60XXpfL8ixHIo7pAT0hhkMm6Y/LviCkYokiRMpbJoS2wPGle2XM9fFBgsnGc0JramjAnU8G0zzB2s7gFOFDrQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nur1JFKaP87dQxFDvU21CF+tgjEBkb2iHLYo1yfpuVo=;
 b=RZQleWECpuFT+W7YBo/SogpA1YQUDQ6MerIMRFYDwG2rBFbx25O1kJUGH7OQbMKmuNaIJ6A65Z2qyg9+OZhQz6ClmNdZKXynTOh7K8WsYiGqDkZ9sM5EcxJ+EQKeWP61U3qIPtHfNNNNcNWV38U0Mts2L0DvK/eP54IT+ys5/60=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7842.namprd04.prod.outlook.com (2603:10b6:5:354::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 05:56:27 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:56:27 +0000
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
Subject: [PATCH v19 16/17] RISC-V: KVM: Document RISC-V specific parts of KVM API
Date:   Tue, 27 Jul 2021 11:24:49 +0530
Message-Id: <20210727055450.2742868-17-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055450.2742868-1-anup.patel@wdc.com>
References: <20210727055450.2742868-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b38c16d2-d125-4e29-f324-08d950c345ae
X-MS-TrafficTypeDiagnostic: CO6PR04MB7842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB784208B128D00929627FA4698DE99@CO6PR04MB7842.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +vr/i1DyY7SR8AvQDSDBW4quH/TV/NiARJQ7qv+u7yculqOBiQIWj8DKgWMd06R+HBcIGtaWL8cRmwWqWYgIJNBBN1aW+bhm+PuS83ILsvBafVVjLPMPq73T7qYz6SyH5th/NwHS3vV9JVNAD5I/+3TZwrpIE9Yw8SYQRpL9+CxwZ73AbmMufRBGiTSRpgwxpWDOGXOsvoTbSdKobVDb3XY9EKuZ78sHBiwXldL06vCcew06FzdGvLRPL1exBCLoZIzHXKk4QNS6DYzO/ok36sg8cL2g5fmRsSxIbD9N8AWoM2erAlsyyHSA6TqNrpkmylcHscD/2cqLANE1G1sZJHy/lZC6NwFVgDePh4a56h0MQ2HMH+VtD5iNM/FjEF12TbxcOrin331cHf0d7q6DuCKzzGfHjO0hR313iOOK2Qo8xGMJ2LwXbaBhZXvov9OJMN3a425XH/kptF6MIf2AFDUu+bjwnW8UX+tzvQSGKIi0SaI2ybZ0GRQ5anTQs/uqE4ngZt69XIHOAACFhX5dqRhJDwVy4MkX4n1afKXGOQqG6WQlENU4Gsu5GJJyGuGtxOFVvTfsKodO1sImf/I7AByAdTVUE2dIZm3FOrU/qsQtqKRGJpEPucVzqzVzp5tygDNTCY6NqskOtANGSSWZ4LIGcV8DcA4E22Fi8rr4wONjRK+p38VaySD94e8DMAkBi5/Ea0hQauDjOIcg12GhkpsrY3KEaQtGxOrEHr1K1abV26zViISA2HxQ/8ykQtSPG1vN8l8AKjoVYPC6zn5Tkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(44832011)(956004)(2616005)(8676002)(316002)(26005)(54906003)(110136005)(38100700002)(5660300002)(478600001)(966005)(66476007)(66946007)(66556008)(8936002)(55016002)(7416002)(8886007)(2906002)(1076003)(86362001)(30864003)(6666004)(38350700002)(36756003)(52116002)(7696005)(83380400001)(186003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KEZq/tSl0Cg0dhIba6gZZqxn4kDPRZNoxNFulJIxwzt/AVPaid3Ru8af1K3C?=
 =?us-ascii?Q?zDcoWgDXFvfjbYH5gCMe5eLuyz+ZbOMqZ06gjGh6N9rJK1ziapw8z969RpqW?=
 =?us-ascii?Q?kkh7kRALNhB/eemYs3RMeDuKvNoaoIl2WvF5/KK4Lbqu58ZthGgqCq2zjwi4?=
 =?us-ascii?Q?LqJKyTWIHAtW5xpg96j6v7FNqVBzDleIzeGgGqcr5gxDJSF3SkgDPZBUUx7d?=
 =?us-ascii?Q?twAJp/EQX5xOE90fkAfdZYfnNKqtUY6ec5H27TQffaGCqozIo2qrIS2UcZIL?=
 =?us-ascii?Q?Sr6oAr3t0l3e8mTWlxF7UnSpMg9tOq9LnGJgMEF1gMLsOVI+BKkq5YTvvEgE?=
 =?us-ascii?Q?Q5+yOTYDipmETnDdySu22Y/ipU103vfHewmOSEUWmttFgPg8uttNF8ikP0Re?=
 =?us-ascii?Q?tnis2zp38HGjbTEaQBSmMPr48Kr2TEAHtQ1wAFi7bV9hAny0927q4DjJIFVN?=
 =?us-ascii?Q?cJOnfWXznDZQ7vUrFg5wFa5dg1xkXxZpiQs/6HnN72+XvZLuQClfC3XMv0jO?=
 =?us-ascii?Q?yqSPFxnyDTAQbIjYUtqpv+yYSF8Sunupt2R+t12m2z+nRRPx1EXSDEJhUI9j?=
 =?us-ascii?Q?iS6JkKQjIQe8CXC0buLjnMi+mxgw7BlJZSqnuxXEuahcXmW2nab7cFo5GySV?=
 =?us-ascii?Q?7ROQ6Mc4nVnkPKE/bWksxu7uTaAk1AXRdtyEZaqMFc66BviTW5VIszeOvhpe?=
 =?us-ascii?Q?jy4VcegBbizE2e5r9SBnmX4GhuU18IBJAKj2vZ8/mp3hnjAQTJ9deGM4oBWC?=
 =?us-ascii?Q?+nSRXJzZUZHAAKGXIuJD+BE0A0ibsVa2nkQAh0cf4mGvKRmQ0HzHgftmb2eu?=
 =?us-ascii?Q?y/ZHOv8CZpj3r0A5ZnGsOlhjuZd93OEPtkf+jebac1s7TmwkOqEiEruj2w2L?=
 =?us-ascii?Q?q/k92dz5mrR78ac20ubBoIE/1LvR1/Gs8wdZ6LoyPurF1tGq4lThvM81OalU?=
 =?us-ascii?Q?3SgJ5GEL5Y5RnFMoPOjjacPHrgP/B7aPDtuwp84HZXBjZJHKUFT1gHcooP0R?=
 =?us-ascii?Q?VDVTICIrViydyFnVfMtJt2M4wQJLHa6IspjsDahRor2Xf5qnygrROhTkkRiT?=
 =?us-ascii?Q?t1TOC3OXMZBzj1KGici5XgE7V28HaAK+Bwyt+tantU2KeuUo2/u2rbRp3N+F?=
 =?us-ascii?Q?kTSrqkVcjpVTtU1SKtj8BGRWnlLhRV4yFn71CPDMWyxyH3gOovKdlWAjOW59?=
 =?us-ascii?Q?CjuCTTyoaQUEfOCRUBNnDsEVb34nLSBDBCAnO37G90bjJrPQfHMf4GrM1AH6?=
 =?us-ascii?Q?xgODMUHQpwovvbqRc15Pf8jF6vqVq7AaB/EmGvSvS2PNswwQP4/DfYK5RfDL?=
 =?us-ascii?Q?kO/rudgLiFlcTCXu7dZ2ONxt?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b38c16d2-d125-4e29-f324-08d950c345ae
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:56:26.9087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W32wx1NbMjmYd+dV5lZCptg63zGHZlluOejp1suDbEpprIPYziJQDjDzFdofFaVglBLQL9pFh4mm56/mGfmZkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7842
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
index c7b165ca70b6..6510ca68ed73 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -532,7 +532,7 @@ translation mode.
 ------------------
 
 :Capability: basic
-:Architectures: x86, ppc, mips
+:Architectures: x86, ppc, mips, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_interrupt (in)
 :Returns: 0 on success, negative on failure.
@@ -601,6 +601,23 @@ interrupt number dequeues the interrupt.
 
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
@@ -1399,7 +1416,7 @@ for vm-wide capabilities.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (out)
 :Returns: 0 on success; -1 on error
@@ -1416,7 +1433,8 @@ uniprocessor guests).
 Possible values are:
 
    ==========================    ===============================================
-   KVM_MP_STATE_RUNNABLE         the vcpu is currently running [x86,arm/arm64]
+   KVM_MP_STATE_RUNNABLE         the vcpu is currently running
+                                 [x86,arm/arm64,riscv]
    KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
@@ -1425,7 +1443,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
-   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
+   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64,riscv]
    KVM_MP_STATE_CHECK_STOP       the vcpu is in a special error state [s390]
    KVM_MP_STATE_OPERATING        the vcpu is operating (running or halted)
                                  [s390]
@@ -1437,8 +1455,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1447,7 +1465,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1459,8 +1477,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
@@ -2577,6 +2595,144 @@ following id bit patterns::
 
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
@@ -5824,6 +5980,25 @@ Valid values for 'type' are:
     Userspace is expected to place the hypercall result into the appropriate
     field before invoking KVM_RUN again.
 
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

