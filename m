Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF4388591
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353160AbhESDjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:39:19 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:8529 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353242AbhESDjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395468; x=1652931468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2JUAVCLJoqAsQPrVXE4+WUa9LclEzp3rwIey4bAfshc=;
  b=Sm3w3zSIckCV6RWoq4hbFZxKjdaC8q7pNQWYRb7/m44mQVGyVB1rf1kU
   RNmzK8Pq2wgUWjz7aeLhcqOmAmt8MWBuS/guA5o/513ZH6fr/P1kq5N/p
   3EIA4T/5RBfEM3TlAGMn1OYpoOrDtD2tUv3xdjjtxBO9f2qAEFuh2wpW1
   I52AKv4T5qjH/q49nNGa/cHrvp9pJQHVrh0TPS7Qx9G44wBggWFVJi3sm
   EHqmiT+MyTDGdg0/XX37hBAmQhuxJVPpsbIxkpI8fJv33FaZFH2EjgguF
   Cnsc/KqMkqPQZO2qaibrbJREmJ/e57P5LlSDUscKBEMHyrrhw+C2x7rC8
   g==;
IronPort-SDR: KwOf6p4GDm15IGYND2kFnp+81tpBoEWFa6lanfwrps2f4goShGG2Fyxw7Ej2TzngqUQnDR841+
 qfCxOl3Ymsz/Sm/o/9C9mXjcBd2q50i8L/g7Z62vC+Ko0WSS9PjXWiacC8+3dp7V75vBzOqerA
 q1KnFu8xdxjkgZXUsPH7WGHwH0PR6EV2kkgnyVCZrGnLMCt3ym5wLA+nLSej91nijS/uW3cCPK
 0tVok9cZ5QiAlifhBbyuYcDL5YwQbRTMZ43fau+5LNAxhxmpZ2EG06jc5l1ImRqgt5q7SAbL3r
 yHY=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="173270036"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPEm4I4grfNYyaPRZElr0oVBTxwujmwj+Xtpd49CxyR/qrKfxm1tjwvAG/M3TlkKpMNgr5mRhGtvNeXMiddHgjU6+hBQS1QbPu03673OxCfw7sFxEd8FJPKCT4s3GdilxCRvrCBoHNm8Ie1cmR9W4/Jb/bc1jQxGLi97HWdz7cJQHz/g6a5nNQCgIKKwb9Y0TjnagSn2LauCfeACrXMdPw8SoV7FSllLppfLSjfNMWiI2XvkvH6UNrppSJphYmHQdx1pVuERFzfVc1De9WMfA1XPzWy1DuGYY2PV0v4ekNCk369Ra172RMe6KeVTtQ5Dx/qcHuLp4PosxXKq4bBhJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4PuXtMTg3/t/ZX+XrcHFf7z76MuBeOC/0reugET8Hs=;
 b=bfbCkKDp3fmH/KcwjMC6ecZ2iihqaVZeQn7zpZ/wBqjAjkl2F+GLxMjDT/r6ygTRmCgiZpaLc+CvBkkNFlTryOYYPK9CXetNyhjjOi3Vq888yaUIg57zis2/FMcKR14Tj4XxqTPhcw1EdoTw6WPe5NHYV3un4POWt0M5LtFxu9Tb6EcMaHDoATspEY0/FDi4X2smnLq9VPVLmM9ss46OiTmY1DolaIklwi3miYMTXatGrGkvRv5shAs4O5e+eqMX7yo4PQBcXba/hH5HmRqkxtsTTQrHtn/3a603GO2HrRB6w13e1zUxG9CsDIMUjZTPVievOlC5bZ+rAa3aaIzPog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4PuXtMTg3/t/ZX+XrcHFf7z76MuBeOC/0reugET8Hs=;
 b=MZnzZXCCRPp+QxOvXbPU4cTeNJUqT6FU0k44DOaKofQOUZi2BbsbIv5LJe+JqjNE2mkXdA8G7iwQF0ovmJAKVpME4E5DyU04o2/4d3BnVj4kMRmTKZHbQUn4395DJFwO037mAYu5r9fiXGYFBkogOcite3Zy/1GnRZxUqQEdW4M=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7745.namprd04.prod.outlook.com (2603:10b6:5:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 03:37:37 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:37 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 16/18] RISC-V: KVM: Document RISC-V specific parts of KVM API
Date:   Wed, 19 May 2021 09:05:51 +0530
Message-Id: <20210519033553.1110536-17-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4d0985e-bcc3-4bd7-ba58-08d91a77721e
X-MS-TrafficTypeDiagnostic: CO6PR04MB7745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB77451DB6A8BA203A195D42CA8D2B9@CO6PR04MB7745.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1hi9N5My0fCG9ZRHyvcejWUUHEQo59RImqrXKVYfzlMNxL0cRu9Au4kf9q2v2uoy+tQ6YvZ6Pfj3wFWP2JF8zrrtmDTZo5gSmPuwK6+YnSmK/bEvP0db85TSClkw4CTynmJeAcS0w2buT+yHO+are3HAIa3fD4bqUEjTVp1SLPm/ULEFXe2fmakEAM/Kkg2JlHUU0RzLJGDuOeTel+N5oYLAStaSlv22cnS6CNOQcIj4a4e+dVcYLJuNZeEBe0kiXNfK2gvJAkrzhpz8loVmhB2R8hCy3cPFvbGPdIq3r3gp0MsQMRU279nLIovZFHT3c2zUVaHtD3MQpO8viZS5MCIL+w6K7M9/lHf3BeoOp2eULxdfz62FUMepEsIuoafmfAG707clDKaNOQfwDsTk/Vp3nP1L+qPZ20PTYKH6Yy06mgUmWoV/iDZeohfFHT0UOdhcghYpM2k0Uh64JDE9s/NDRTx5bG3tD+2dDmplENt7I7GCvCmcBGNlQTfFRI1UZsHsGC0pK2c8zy7p9vdiNht3P5OJRhW0AUd5unx/Ki6Pa5ZOoZeNMRcMaNkrPGt6mk+fuYWp80QL9/eW0E+vEfTOeNLnAH/T9WZD0XsvxPcznPSdCQAlhHD/cPV86tYHGPYO1TEe1xVsofCdulhMsSq8FWXb8G5fSrgGsCRLuxPqDGFz4Y1QqhMQl3UjSqp/n54T1oFuIJ912TVBXBQoePS9Qsc+dE3q04pw9+SBQNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(7416002)(1076003)(66946007)(478600001)(2906002)(966005)(186003)(956004)(2616005)(26005)(16526019)(36756003)(8676002)(44832011)(6666004)(55016002)(7696005)(52116002)(8886007)(86362001)(38350700002)(30864003)(66476007)(4326008)(54906003)(5660300002)(110136005)(83380400001)(66556008)(316002)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q+KLUY9WTN8Zhcsh0UEbdJcMce2rg2N9s1wHQgr+7/LFdvTBqq13eeNfmr0K?=
 =?us-ascii?Q?rob1fFslwIXxzVLSz3WE06vhG6/1FL7fTYEyyPJXrScexKk+V3H4XJ+Js8QQ?=
 =?us-ascii?Q?7DnEHNvD7wUoBUjlTTlAGeyQT58dGAVS8buWl+djSJ9RTFlzC///5Foe23+t?=
 =?us-ascii?Q?Lmrshu33+6BponSMlVTeZmSAICghmtiFDXFrLEj3F+RzpruMSj9NlZAh1ih6?=
 =?us-ascii?Q?emdJ4tsAK9UpFiS3ERI+kIigJeSPUMpumcjRkVBYnVD2g+MNMD6lqJc/WkNq?=
 =?us-ascii?Q?8czwBXGc3JdLbOCtEmiyXkcJCv/A3+w4v+nEqvtDzHvFBRkZGOZ3tFMyMeZ6?=
 =?us-ascii?Q?8ij3C5H9ePA/X5aRo08n20eGbYnaORHgd1qrRduV1r3rBgdfH6bai7VaKXSo?=
 =?us-ascii?Q?X5WUZV0o4lAp9+lxj7bu+o0yr6IAnrxDga9KLpdWvgQ298fsmkgHH9GMpzaY?=
 =?us-ascii?Q?xdaxbLKX07PclvtPukxQBs7L1dci56O4OOIXmU25G9vz83npL7qZY2AUf4Yi?=
 =?us-ascii?Q?/EIaLwg6G5rMITbjc+PujczDnAeT4+uxR5A7mrdMlxYI+yMMtIL42TLKsqyu?=
 =?us-ascii?Q?I6bNmzEmqeyTY82IZrswOHxnik+OnxzkZ0MHVSb5AYNobC8o+EzMTYrGUyZM?=
 =?us-ascii?Q?hNXABh2brBjR3JClJiO0zxCCIL/aH17sVjHEgFeNC8O4plZWK5ydTicWck0s?=
 =?us-ascii?Q?ikbTA/L+sgQ48flERWYgfoPQrkHkxP1iTRdu93WR9i+F2rBLNd6OPaSTqkmT?=
 =?us-ascii?Q?OPduiYVY/QIuNFH64KGt9QoKvER8fJIse893edihQWc+nJrUO5QJjIMtwHPO?=
 =?us-ascii?Q?AmrmA47h4picpn+Wz001xifUtC93U0hgW/+rWYrMZ3Hm0AAg23rWIbDsHiIH?=
 =?us-ascii?Q?l8639qkQx6kp3Z+Ioo5Q7kyOo9XSVRE64OJNTN8HKP00M/Yd6RGqnGBLsbm+?=
 =?us-ascii?Q?apy6N+/8/tnHS9+EonA9TI5VZ60z2oHHKuoFVfXnC6/FkRhvmfk3dJ0pTVFt?=
 =?us-ascii?Q?XGVUUPg+55YIuFqcCme/ryW7eWMaywiyowaQ0lIZVcIaMR+G+V/amJutQ2yO?=
 =?us-ascii?Q?/G2hjhDi8D7QWH3fPaqJsndJ34jAtFzv+YO7TclvP5uM1UdLaKant2BzVu3e?=
 =?us-ascii?Q?YG7WCB0l7MQElkob5c0nuqrHUtffMXmRuNBhSZDqNAdMQqG3rgDnF0Dkd1Bu?=
 =?us-ascii?Q?rLvch0j57YKq89eWFRC0CrYeY72HBv3/vBQ1uqK5Lq72QG1KHqlnjrsRTF40?=
 =?us-ascii?Q?cN9jdJoyZjIsBhM5ZoaxXmlMIPLrYOD3C0XjPgZlwOBWc7uOz8oiZ+2hS54u?=
 =?us-ascii?Q?ZI161A73rVeMAqCBBdY1+Jw7?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d0985e-bcc3-4bd7-ba58-08d91a77721e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:36.9285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZA0ESo8Md60d3KH5QNelCyYfJFk463qsR79JmPzZrSo776fLXj8bitYvJFS3ghr7ol0lGi9nH3Dx663pPN6s8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7745
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
index 7fcb2fd38f42..642f858d3605 100644
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
@@ -1394,7 +1411,7 @@ for vm-wide capabilities.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (out)
 :Returns: 0 on success; -1 on error
@@ -1411,7 +1428,8 @@ uniprocessor guests).
 Possible values are:
 
    ==========================    ===============================================
-   KVM_MP_STATE_RUNNABLE         the vcpu is currently running [x86,arm/arm64]
+   KVM_MP_STATE_RUNNABLE         the vcpu is currently running
+                                 [x86,arm/arm64,riscv]
    KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
@@ -1420,7 +1438,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
-   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
+   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64,riscv]
    KVM_MP_STATE_CHECK_STOP       the vcpu is in a special error state [s390]
    KVM_MP_STATE_OPERATING        the vcpu is operating (running or halted)
                                  [s390]
@@ -1432,8 +1450,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1442,7 +1460,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1454,8 +1472,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
@@ -2572,6 +2590,144 @@ following id bit patterns::
 
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
@@ -5565,6 +5721,25 @@ Valid values for 'type' are:
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

