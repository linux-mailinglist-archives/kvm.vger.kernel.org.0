Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB4D2F78BD
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbhAOMWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:22:06 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36765 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731606AbhAOMVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713302; x=1642249302;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=b5BQZvkF6iX1PZ8Er+KwwI5ddQoTvYvcdTlCpptiqxg=;
  b=ENzrpy8x/3fMnaJ8XhazbizoNvyTC/9ut38zC3KDszBEL/0Tzkdzj1Nu
   Ep3xjRCC/kpJja6KACmNlYkbygyvpX14GzQZdDN3ygix/YI/kDKM0o4ZP
   iC0hsOW+KoEb1Ed/jsHAsFt9HxZ8yWtQ1jBtGeXOSp2+eDS2bbQkH1zZt
   TCP3Awslb3CWjZitQDdT+o2DmaCOVz0inTSW1RRICIZaP82/eKKgRjyPY
   mU5Zi0ID2yjcidNL+8X9Ob7Efl/b2+T/reCQfwlDwxzwYXWa6BBGWkhs8
   jOfwQgI8K06hOCt7TjsaYJ37GZYRWD5oi1v7J+canSL6arobFy4L5WgkE
   w==;
IronPort-SDR: V0YHNN1BhzGgcezPhwK9fArErwGi3PGUPq4NpVTnpzfd3OtdjQ+JszPZ0X8gowcuE6UBVA+9B/
 x+poNgtiGBZDCiKcCA93D8eRGOMQy6URkHMe8HJDKjshcXwd805LARsZVj/GmHg7kSRXBC4zvT
 /IUSXVAnw6fMT2zcm2S15zIUFwSkcll0MRWL2caPxcrdlecGZUmmxXC7s0Igbe+WRBafl2WNQk
 NlCRVk1GV1J//mPZWKHvVHB6GRu6Fcy8pWdnty1Z3gm3yvp3NXk4Ycup71KBdKBWme01Mnx9/u
 QkY=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="157507154"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:20:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BiBHA17Qs5iyr0/xkBpoO1pOduQ11zF2o4TpXFo3x6sH74puhBGxSksB1i7uXYF7bcnkQUzh991BaSoY/OJC3p2P54WhoHaU9lQIO81So0ihUqnAx7ZUwIl/9+sMi8sYaWdnslNjziqctI6urIEmn4VJon+jxqHGAvo/6vvV1FxW+PgSa1OrFgqFpbtmSufTSr1c5SMUNytOANYHbEFqrs1ajsyYWAuuLT63NDze1sbiWSKxFY8h9aMjGB1SUYY5FGjviz8H25kUczpbk/Fig1AKiIuU6shyjSIvH+euAGGZ1F/8t2wQOCgjBh2fx0kFexCiJ+9unWqHVFtOAg20Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIsEkbh/kabksROMC47HVRLP923Zntw5a8fumkMlRdM=;
 b=TDPdAx9qhzeg2BNJujI7OxKSs/KjWp2QaAmgg8QlVSefFkHQfrf42WGtTzVWREfeOhi6Zhe0zPvzUUs8VHHBIWaDWuBrwBrQGWM87D/pB89t1OsKXwg2PVffEV6Rf6YVCe25Xk6vvC7BAhCEfANq21DHZwUlCNS/2c4GchA8sVus/b05wKRUYI8kNEp2o5qcGgHhpNKYIj5uCzxQLdeHxg+rHnytOahASN9zRxdYhxWHhRsdEtpuIONmBrCWsIyNoNnECQj1YDQrCNPHa83L6VxGYVx5/Y9wJTKZ8zCbO30cWdrdF/Ju47xja6IeuAHw1k5hq+dMqVf5mk9VvrIPyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIsEkbh/kabksROMC47HVRLP923Zntw5a8fumkMlRdM=;
 b=wOydWpv4nFgvHK20OD7lTtDMgxaeDX2pLwJeFO3BYGN4WpJjZ3U2RJa7AlmZjjIPZ/prQqtHgFZB6YAUwklNqTagnWSEbLWOK51fXUjfXHGDiVhEeuCrp+EPznZpSwgdQnjEV5mDgnfVqr1yYRdAvn8UIPxRWXr59eiGp0ts3kA=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:20:39 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:20:39 +0000
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
Subject: [PATCH v16 16/17] RISC-V: KVM: Document RISC-V specific parts of KVM API
Date:   Fri, 15 Jan 2021 17:48:45 +0530
Message-Id: <20210115121846.114528-17-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
References: <20210115121846.114528-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:20:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1727e3dc-0e28-42bc-5bfc-08d8b94ff816
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4330D94960FE2E9078716CD78DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 122+FcxukkV1Ii4Eyx9IKJf/fWROYvjsaykGD1iQNSjetv4gZ1cU6Tb1bGevqdwkiv9frnEP/sy2MYnK3iDRkCAkwKS2bNpbacA0jGiW8SOdNQJ/2fmvGvfCRb+aTW7kLUGPTXyzYcuK1xapUPn9BbGtBIf1ZUFqP56NFD/LCPPOwtVnjDYJmeYukyoGSdAA9nHNXP8ErFdWmKfAKTnjaxdYe2/pY0S4l2tr9bW9AxGZnHMo2DpAK0y4uGas5Wfz29pd/2KjG9AcwB2r2qgYMjw8cPjwP4OQWyFKRyDTZUa0mT7xqHbS+2sa8wqJGGCaPofeSrORVGh7rKoTkXjQmKrYpKMB8c4NaeOzTWxNyiyYXhaLiPQYMQhyttmf54jIowEhhZa6yTLMlUoPgNdzVs6f4YDs/fg+T2kQXR0+S6g0wvHQctg+wZdX5LaFL9k6h1Vod0ycRxsA1WzNVI86ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(7416002)(966005)(66946007)(316002)(1076003)(66476007)(8936002)(110136005)(186003)(66556008)(86362001)(16526019)(36756003)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(30864003)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j6+lYS0inxjsQIUj19KJLCA+yxj9tA2/0AYvZKK7tkw43Ip5TFXfPeJDl5qT?=
 =?us-ascii?Q?UJHSVm2kHagzNEkfSXs3Me9n2Jkmxsx20gh8aaeCc63QieLXZrB/lfQ5KrzO?=
 =?us-ascii?Q?0CUykZ30Mg8QH0eIRMevB6E9qZM1HhDcvl2B05JJFA687/j+HUj/WbR7Bygf?=
 =?us-ascii?Q?B2BTHs8dHkEU0/qz9gLTac9cBNcQ/LmZmljp/Eueb0OnhzjffLxvvjhUb3pR?=
 =?us-ascii?Q?DNH6WXgxl7taYtMfUWIrFJEQOiqdHKyWxpCmsHloXdVmRWu8xIfavhfbkMyX?=
 =?us-ascii?Q?bIW3DSlDVTqUVLZShEBU4sgpND1UrdAhv4t/4EXqeoL4gXxZDIYE9XCdQJCC?=
 =?us-ascii?Q?W54GLIJK6x9jto3JEV1DRmhyrldzDJpDCCDclKjaCvTje61c/+rQYYXSNsdF?=
 =?us-ascii?Q?8DGfuc7f7B8cvt8JGRCsiXhT9M1hpTd+yXV7RQYh9dar5lKJ5ek3UtcOTzmE?=
 =?us-ascii?Q?eTXlFa1sKT+oi+xkCytsLgDWZ76hIAiKVSA6ucq22YkuUMaPMt6bkNZ2+ste?=
 =?us-ascii?Q?o+mshGz4zjd+flfjV/ghWkFszb6Nfxp18VMtZAHdmAswyp662zD+YoJR9jXQ?=
 =?us-ascii?Q?X/VxAnz8lxvy/0iVrHF8N42LDUqiHEbbF0CfJtwkrM8WDYHmPkhfF/xrbi30?=
 =?us-ascii?Q?e0uK3biUOMj0uNjhXcXuRmRT0PC8tRclQTZ4aK+l0XJmAKA47p0Odk7LIXgU?=
 =?us-ascii?Q?Kn72NdJlTRQbFCIOBU0g4oHFnEXjCVTXxA9LA/QzqElWyjyyNvQM6DuXmTCZ?=
 =?us-ascii?Q?g4PfUcl8ONWwQd+mW7Lzz5NecSUzh9kr5vElwZsiifV3lxqq/yjAbdkqeF4Y?=
 =?us-ascii?Q?c4nJImrh/1RGUFDd6VsBfJvEWRbOOObyMzpWjysHB4dNVuDyrkVyyo2if2im?=
 =?us-ascii?Q?w6l9wmJKqJx8p5J2+17lfKPYCoBE0QcRObVCWdZ0oLAsbUxyioZSwvwf97dz?=
 =?us-ascii?Q?itc41TyuyxrXCkO9V5q17ZIcvZr9FmWzEVhITeubZ+XbBD4CsFFJPWYPmFfJ?=
 =?us-ascii?Q?EKij?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1727e3dc-0e28-42bc-5bfc-08d8b94ff816
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:20:39.3092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7z7bEi9J7Dfg1g7Mki1yM9Y22Xivc6wlHKIaLYpzkI/afdxsAh1qnzXbpzQmscbPOSjMJsB3nlTGEU7Ba8PYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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
index c136e254b496..f159ce4a66c9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -530,7 +530,7 @@ translation mode.
 ------------------
 
 :Capability: basic
-:Architectures: x86, ppc, mips
+:Architectures: x86, ppc, mips, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_interrupt (in)
 :Returns: 0 on success, negative on failure.
@@ -599,6 +599,23 @@ interrupt number dequeues the interrupt.
 
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
@@ -1381,7 +1398,7 @@ for vm-wide capabilities.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (out)
 :Returns: 0 on success; -1 on error
@@ -1398,7 +1415,8 @@ uniprocessor guests).
 Possible values are:
 
    ==========================    ===============================================
-   KVM_MP_STATE_RUNNABLE         the vcpu is currently running [x86,arm/arm64]
+   KVM_MP_STATE_RUNNABLE         the vcpu is currently running
+                                 [x86,arm/arm64,riscv]
    KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
@@ -1407,7 +1425,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
-   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
+   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64,riscv]
    KVM_MP_STATE_CHECK_STOP       the vcpu is in a special error state [s390]
    KVM_MP_STATE_OPERATING        the vcpu is operating (running or halted)
                                  [s390]
@@ -1419,8 +1437,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1429,7 +1447,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1441,8 +1459,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
@@ -2556,6 +2574,144 @@ following id bit patterns::
 
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
@@ -5326,6 +5482,25 @@ wants to write. Once finished processing the event, user space must continue
 vCPU execution. If the MSR write was unsuccessful, user space also sets the
 "error" field to "1".
 
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

