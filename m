Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD3841935B
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhI0LoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:44:09 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36452 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhI0Lng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:43:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742919; x=1664278919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=mxMf9YPP42Ro/O9a0FHt+9algYvZDNT6zaI+54s3FiM=;
  b=VUX/tabT4mAgoLz5aaewGxbWJ8D1yEyGg23rPfY+o3BwsOZVc39VQTxc
   eLMS8YouM7y5j513YeUlHPUxxEIlYsdPfkNw0//FOGMzWvrnL9KS5F02R
   rh4st701oSmY5DUcpfCPEc0/5dmkdqOXKtR6lT+qa2HBnCbARzGwpT7XZ
   +fIIKLgWKU4QSZVVc2vvwzMEDyX+cV4N/lRgHB006f2sy22ZBDID0ghFL
   DLVIcDi5maI7Mm77z38KG4TBrksekbHrVsVx77Tw19zuRVSE3sUkU7d8C
   LEUHgvkp+fT482RG3yj37/7KsuNRUHX5nWGtg3M/JWhnfjHuVijbPZBd0
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="181673115"
Received: from mail-dm6nam10lp2106.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.106])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7I1cdS/f9/+drB3z9OqE1I+W07aZQ5N7+YrIrZuBTrI6uchVpS71mx9M3hi5zWv/nhonxSqP0HeaLUOJ1b7loeKvoIE10ySCg3SG6VNIyTIrQpyKOgDK0D+cRkYTDjnmDL3n9GbncYzaTr2nBqNsawRBt5EcK4inWTpZ+4fr9Ws1t5dlKmnw4n5pG4qnyD+Hou2SC3o1PLAh+yr+hYA5K1ZqbEE6JgMjTDQuYH4BtsSmPtwkjfwm5VPF0zpqAgpMwqnDeW819a74ReWhDcDFDNVVcnN4Su7+rNYULORwknSRiZQHEwSIwKsCDVDxlDRHPzyJhnpMxKuf0wccbsCyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=lSjyCKwxIMDBJHPEQP6cbw5qRX23sExGv7K6j7MoPDk=;
 b=e8J/ebygS9z4Fz80mFbZjJtQ/VG+Tf7dEx1nysrWNFMVMx1HGeCSvzSXKH3zD1ua8OfpOZ4QhLfLTHEJP4dQCVl6JCyle+9AkTGSEytv0bpwfYwFaoAoDRlqOT438UiD8vi3hAywPtuspGUYGbyKVKfhoODQZsOuH+ahqYgBITEgih0R/P35We31xahrF+ezKY3v7Xb9QqK1hW/zKoK4zYqudS/rK+0XEU5g2N3bHBQZLzYmzSgJeC4n3G7WZX5fvI1UUTG1OZedpNpR2Kz2A8u++hGhDvpBevUbUlHucstOYjgJL1CyZhJgbZ4xwu7Ks9Xs0G+gQNpivQ1BTKXK+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSjyCKwxIMDBJHPEQP6cbw5qRX23sExGv7K6j7MoPDk=;
 b=x/Xp5vVokjNI3PTnCTmadiXluPSlK7eorS470V7ba2ZQGE1eJ0FZGMcdNWcnfF5kadsozkEkD/1mKsGI4bvDwk0Ig6fi/XP8ygualz9vkr7b6S5LzddNp7bfmo6n/9KoMcpJ3o5ALDtHr+QINcnWsr5ODsZ9D4hJy4cvVBxQDRs=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:41:55 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:55 +0000
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
Subject: [PATCH v20 16/17] RISC-V: KVM: Document RISC-V specific parts of KVM API
Date:   Mon, 27 Sep 2021 17:10:15 +0530
Message-Id: <20210927114016.1089328-17-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:41:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6455c85b-bf6c-4689-21a3-08d981abce56
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB82368EA72473AC2521900E908DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tF6QzWsJvxtulDcXQJq4dAzq7d9gSARd0U8zhuSQFrYOB0i0pnSgvYiaRlo0prCn5oa4yxdowQX41+fEL5ur5pzXdXm/volCpm+D5EKrlH5icmpGRR+BYh6NvcH+jIKLZVd5cLmxlaggTB0Wn8dbmy8drWJbq5M89/5fgDaxnDR0oFUfpJGfQ/Yt7hIgQEydH9Tqvi2nSSZFM5XpvP05sU+dny8+mXqzEMJ0cbC2hh81rFTcm1jX+9VTBgcuphiLon7vr8rxbenLgjjp9EWB+rzrrESZAkST2fnePJ0po54X25FpY9mQtxnS2M0TauHekGnER8bu/e1KnohGldLXj8Bsablt9E3LJtEWtgs1Q6MQlWdi8qCBcYA30PXha591GKicDAywzcOGVMSzJGmh3MbVQqbaC+m5kD076OHUnB05Fp4SdB3WaDsqj1o8GYEjjSIhfsd5a+UttQ7exNSkeDePyz5quoL+OU/TgK7326okPYMP+OYGxEO5TxIAaX9KmV/FFxpVmHgFmDQtHmZuiqGa1glO9jucduuxY5BtMbf22vG6IdMX6JskjeNQqRXldehRY+bnVNFTKTbjRq5UivIVc0ln5UVGZoZTFSvK+nLskHsiURzMdCuccZpau4l3NoFQKydVOtwIN9YUDM21bPrVX2TcQeReraEdvZR7/VPYskNVUIILpiLhQHwjBQDM3cLHxJys0Tdqcju4PqiC6GD4E3pIDwOBmvkNZJwKfzqsRnpqJiWY9w3WiNNABIX5V1yivNpQbvLfewu1wGLhLu8y8mHsyhoOjXz/7fImjyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(66946007)(44832011)(38100700002)(54906003)(110136005)(186003)(55016002)(966005)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(7416002)(26005)(83380400001)(30864003)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?svqe3Ypn2V5W/nN5hfh/8TjKY4oGHpZIpQeg2QTMUQLOLcLd1llMmM4x1YE9?=
 =?us-ascii?Q?CG4nIYsC7QB3zwoU0dDY/mojMnY1sxQJoM35nS76Ipq2ME43MBF4O4ORI3vt?=
 =?us-ascii?Q?49Wv1w2vDm3xxFCEg1Ep3Af4jYMQ6SZ4eqy7mExoInND4AyMrLjahuakPt+B?=
 =?us-ascii?Q?MD7E6pKGcWlr6xy7FYy3M5QMWsyKEPpLpd/OTOY9xtSbJk7al1d2oXPbFmr4?=
 =?us-ascii?Q?XR7wEu1puh1SGjzQCYZMNvGZ+sKtu3RsnMRp7Jz1POAjtovlMFUn2dbmkNc7?=
 =?us-ascii?Q?99rNMKrmalcjYcIUoQVu1hozGEpNqhubdSf2rPlsJ38VR37tYosUD+AeqE90?=
 =?us-ascii?Q?u7tytlITLRuwZYAurI2o2yRAmGC0U48Tv4A0kNiwVxabbNkEubyKGvIww3ot?=
 =?us-ascii?Q?KyjdnYB69LHoO9crsHStAuCNqk73ki7gQJD7Awe93Qsy4FYMVPTMeZWlCruF?=
 =?us-ascii?Q?qOmcCvj6Th3LMyowC+aY+iBqgjzLRgUrkZYqix9/RxmXJcUfCJloeHwQd3Nl?=
 =?us-ascii?Q?+RrbTgfD8trc+C616AEJI9nvEzY5ZIW5H3/Gj3T7i8M5lX7+KpmPbw75j6hM?=
 =?us-ascii?Q?hQQnf7qyydiu69R3dogJ2BLuShrb2AXLO6Zhcq+A3at9W5bADfl6rYIDy+SY?=
 =?us-ascii?Q?mbtHpfoga7TmLX/prMJ2whO5TpBGhBs0RK8GUTISa9ZMU3DUvf7SDlAmZO4T?=
 =?us-ascii?Q?kjoN1kySmWpM4VKLc3KjB06RtrvT+HtH1JukbTnqnh99Y2IwVn6lsrTMU2QI?=
 =?us-ascii?Q?XY1dfSwJSJyKwxb4DptNxS/qG3MEu7Xn50r2UbNzDb9bJ9roWIJzXIkyxB7G?=
 =?us-ascii?Q?pYgUaItU4Km9nGU+zKHuKOFdDViCvHuEkhVZUlAtUEFaDRfALvr0OtiaQy/J?=
 =?us-ascii?Q?OhLIcB+7NPA9q4yl0N1fdS9c7ResGHMB8b/6sb0VHiLLzIzSOCF5ZJPYn8R9?=
 =?us-ascii?Q?/ykGWWS9uCwDy12U+2dvF/w1EM3dQgO/OZ5rFOESjMMlVge26/ARPMmk+eQr?=
 =?us-ascii?Q?hk8A8pbQIw2de0jZI1I4AkyFD0OXA/oA/vKqJWdmsQ1yMrnI9K8cXv9p8lAg?=
 =?us-ascii?Q?NudWCJpqJ630Lpai9GUEOWOZdnPv0jP9MY4ARMIBfy5NTNCct76ffaMpcAIF?=
 =?us-ascii?Q?GOKRUzGJpTJAC0qm3cHSHeCRLOjWS93Tg8TMRj1Si//CS98evap0NcrmuhDZ?=
 =?us-ascii?Q?prDlgc8SJoO90hme5BZBGMhSJDSWBsrm79llJ6VCqDJ1s/wWOWzY4QwMJhz9?=
 =?us-ascii?Q?estkVSdfpsZsWd3uNjoh+zzJb7T7GNV7IyZRbKH2zMMrp6jfvb4PFtro0U4t?=
 =?us-ascii?Q?sC3s7RUFKHTLHbTbLL5Xxt/u?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6455c85b-bf6c-4689-21a3-08d981abce56
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:55.5068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGp9LyCkce1//MHs59Zy0gZfkLsDFip2kHELhDyEQ/UZNUYlwnznP3NObTjcyPBkw76qxWu9pBxHn4L+xytkYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
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
index a6729c8cf063..0c0bf26426b3 100644
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
@@ -5848,6 +6004,25 @@ Valid values for 'type' are:
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

