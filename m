Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E540C3D6E59
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhG0Fzx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:55:53 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:3907 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbhG0Fzl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365342; x=1658901342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=CiuWqujcTXs7WRkm4i73aOXVi8u+owq23S4GlxHX/D0=;
  b=EmhW3XwFL/t92oyRfl1qDEHv1tSMJnxP4cnb4U18vGstamMUvss8+bmi
   BRCGJ8aJvRE3Bz4hxwbk2w5mJNGwtHGgqLlEpOtNGvZqTUsETOeIpA0sj
   CkEBb73Wa5ddA0U+J95AfAjkvJIw4Y7Y/r0xnaHNkbk4NPvtWy4ib9j47
   bjk39aNWBpiSc3FUG2Tvku4+fPAlfXarzHJ46fdSlgMvopbSmgGA8EQZL
   QQ4SH7l6f8g+rudbAAts7OZV8MgABqRn1yraLj7BTmuZDy7tvsWDlaK6y
   8Tuib/ojJpVISqBZ52EfeflNHy8wTDf4qjSbOpaeST328HCwahJ0OXURb
   A==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="176146066"
Received: from mail-sn1anam02lp2043.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.43])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:55:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7tlU2T9Rz+2Fvd542xgH3uCNGDyuBXqN8RVm+xJMNwktgvIc3rcnWxBYA4SUaqab2BuDKDFH+hK867awkWnXA915hR231pchAxK/r11hmiBBmRxl6x/4Gjpe0ld/h4GG42nUwF9c0/pbVu7zsT/i2a7aJr/czhwcgdrbseipz90NCE9lS+9ulf3rEfimqQAMdY24HgrRf8gA6slY0vyyECDb5XcFpuX9H5jTFuOUIfsSr8EdySno0a6LpUF+YTPuHOrVAPB3mZhFK2ker/cc89b10SyWFBc6H2zQyGjlX57ZPa1hCJ4eF9QnXsDGPWAnipr4fy7zPwofJoEYfsZ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Py20hpvvlPoYE475yKuGbnhGqNPCgiFYsfz+DrLLUEk=;
 b=nq5vT8jelkZPAJJixcDSta9Wt1YkH5MzknZGq/v4N7tu6FGTet9Z8r0ZwF0lemuUwL9ijzBUweAxNJoTxAxtMDh2RGeH5h5Ev3jLou/mbo895Uw+baVS1LjgKc93S7PM7I7dqoAt3n4LGCUEnW6XRdt6nwWG1s4/y/1/0kzuQ/O9MI1YWlyxIORkWss/4UHmMxr0mGBU4hCiGWQlJv/vApokXGqY4VfuN2dN5i8akBex2BGfJIBxE3DHqXClk5UrtA9joW8MhSkMHRFxJWOtZBwJUjR1UnassVfIMk2zHDIkA1H2dpiA9NL5OIeaIsUuFYrIRbn6vlX3nw+Sb8Y9ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Py20hpvvlPoYE475yKuGbnhGqNPCgiFYsfz+DrLLUEk=;
 b=i7z2sRIR5OsAz5WPahOCca6r/6wpHjrqx8ROaxCXmZi+YdhO939ZLZES43sNzcs9XPyXSxD7/17v1utUx6TZMDeJfW8HjwY4w8pitDBf0UGnMUBJrZtu1x9JN7BqnnSRn2KEspAMi0KlIFqKxAPQTceBcZTZJcH2p6k4XNQvtLI=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 05:55:39 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:55:39 +0000
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
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v19 05/17] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Date:   Tue, 27 Jul 2021 11:24:38 +0530
Message-Id: <20210727055450.2742868-6-anup.patel@wdc.com>
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
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:55:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aba7d9ff-a39c-49cc-09cc-08d950c32913
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB8377610504D4BACC1936B3C48DE99@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LnfAVL5TshTktG6q7mOPRSzHOwFl+K7BkEGNwLB7JMu2cBhcmRAY/1DcxcpZfzgawT/TrLJJrHtatiO9GU8cnlUdE9TLEt0ZQVk69+hXZ0pkAA/82tqhTahUc4HLFVks8T+VaRcKG81zRcx2UxGqzjS6NHKvujSdx4qpLMMlXbLw0xq8outSWwlKMNTZ78FxVwv3xvMIuFgWutXNM5vnYuKDD37AeZ/BVEod57txe6sLLmiBRfc3mhx6nJkSEN7SvflhhakKT/4wqu/XOc+vLrkcpK8spdDN9AcxgFVEyZj+WzpgvD5QamP8CpqS2JrSzyLWyTJUb9vaxuZNlZQFWOLVyozS1y8OO/hvV6+8pa6EjSAnave0jZu25iptpLwZZM8TpUzEd/QmJChSkKTJIxGrXuQZsDbWZf6BBuzlM6cFB/8KFU5io9KOBIcKnvvuEYhqpESUBidd3vB6pYBlM7eqyvouBu+zyCKggMgfZ4AyL40e252r3PO38txGTLg/Xc+5lwfiwnmOuLYW+4xw1+Yf75E8G4FaDC0q2+WO+TvOxVRr/0P1p1f6qD6ZlpEWAZjDnQ7sJV7d+cv/cYG8Bo7nrLsm0i756M3JmB2FZ5iHEbeTf72aDZ+p9hTUnC0izHLnrbRxHg0M8uciooTP4W5l6olGmpsIdY41EIet11jcHBqln9IklYHDuVKPYD9R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(52116002)(26005)(66946007)(54906003)(5660300002)(956004)(2616005)(8936002)(186003)(38100700002)(316002)(36756003)(508600001)(8886007)(7416002)(66476007)(2906002)(1076003)(110136005)(86362001)(30864003)(44832011)(83380400001)(8676002)(4326008)(66556008)(55016002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xSDNGN5l8Oov0oR4kLy2dWn+6vQb662rzQtAAmcR7ySj7Iql02KnJ5sdLdEW?=
 =?us-ascii?Q?AOE75L//fsl2+zdJYZPap6mpMVC32n5+XGuaNDSN+IuRfBxHVov723PuJOp+?=
 =?us-ascii?Q?tfZ9bTWoEiYsylvCATL+Pf2eBLr9YJfuXPcyaMmNX+894ozYYn3M5j/DdjVy?=
 =?us-ascii?Q?bdWyKtPnABGKaaE8Y+qUVDVWEIjNAonsN+TtE7x9zPFN8Q7rOZb1rvrJHhrr?=
 =?us-ascii?Q?WEAznHHcQqPfhWKNkoN2wBHQhVCCCfFVZ7/tCAYg7phugSKHwSNP585Jpofc?=
 =?us-ascii?Q?6AmUSQAIhHSDWpz7B2wpo+gBznMDhVqPb6LrNV1dxfpZ/qMkSfDBMcFB8CmE?=
 =?us-ascii?Q?LcnNz3g1yOCaQaRyfYKQSqfT8COO1xCXEgdd97lj0dfYwY8ZX5LSuQBU3xf/?=
 =?us-ascii?Q?CGHYWrMk5QlKsZOAYONWQ0TF6HMtdYfQ+Mc09Qxn0kz7iZppC9O1UdloA4FU?=
 =?us-ascii?Q?Np/0d2cF4sMDXcror46MowIHdsNfv/4rf+YLYA+CQ+MwXLQk4Lqaf0PMZE3t?=
 =?us-ascii?Q?iUi18ZP/QDYPjFJXTwT/EPF/IUyVIkadSpMRdIgBJM+Y55ekVciIbxihQcJg?=
 =?us-ascii?Q?xGUe44SlCNhyyky74PT1Gp/yS7IDQTJsSsUgBwDmAqk+NLQsKXeQoVmdFXnz?=
 =?us-ascii?Q?eEEJwR2gf9jwKU8vlqf5/fBjLN3wTIxoweAqog32d3AyHIRwONc8bgz2JkJz?=
 =?us-ascii?Q?epUkZxiTF/qukFB4jHCQkEWTFeVxJbt8s8HWvW6qCK2gOXqapIOLcHmd81CI?=
 =?us-ascii?Q?OEQCBW5nRVFg7fXer0zxOxBZyfRl2WcX4DAEXLv85mI93ANaEoZ1tEsAhzFl?=
 =?us-ascii?Q?b0xz4V8NPdE7RDrYr9NbqDsLWDfYVrpuH+UBg9PJeSuJXzU9Az1S0Pzxq/fa?=
 =?us-ascii?Q?UG/axYl7PiUazj+a2HhbGjTGkRAR903Ck0SbSsdbT8TrnQ3C7wU5Q5DlfqIz?=
 =?us-ascii?Q?/8SmSwjZj9jJM9Scb2FCy+tIazqBRVCeSHvcjcyPI49Hul+3iOAeE8Jr4kMl?=
 =?us-ascii?Q?dymcz8/ETBfjvEuwOAIAtI5VPDh3ZNdbm54wRZRIAgkECmmn25DfpHJjZjzc?=
 =?us-ascii?Q?MPpULMrMJiol5FmDDQSzog5jRavtdwL5nP+LhlNrUbS4r1bM7G7yebX5vKAf?=
 =?us-ascii?Q?rJFE/LrLgk2BIz7WIEuIKDc4mRcU5uSA/IPuGF0PxlSjvVvIfJNsy2oBCUJI?=
 =?us-ascii?Q?2VHq33oBme3aBUQvmkIn1tEF5fdwloVtumCz3xCU1tBf/EMIiDcmmCBvNZkv?=
 =?us-ascii?Q?mhHAvM+eOUP/gJDF6nzJxlAP7D8aKUi2RLwWGO6GSqJbMUtYahpag4MKqT54?=
 =?us-ascii?Q?Y476BNg+R66LdfHKKjO9TME8?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba7d9ff-a39c-49cc-09cc-08d950c32913
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:55:39.0989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FTBhy+aB3RpUHJH0rmfECpaL8uwRZZyhm1MXGznZbLl/MZ0CGzcPHKE8aDtJedL1/7ttfkZKG6RfBhjPxE0huQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For KVM RISC-V, we use KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls to access
VCPU config and registers from user-space.

We have three types of VCPU registers:
1. CONFIG - these are VCPU config and capabilities
2. CORE   - these are VCPU general purpose registers
3. CSR    - these are VCPU control and status registers

The CONFIG register available to user-space is ISA. The ISA register is
a read and write register where user-space can only write the desired
VCPU ISA capabilities before running the VCPU.

The CORE registers available to user-space are PC, RA, SP, GP, TP, A0-A7,
T0-T6, S0-S11 and MODE. Most of these are RISC-V general registers except
PC and MODE. The PC register represents program counter whereas the MODE
register represent VCPU privilege mode (i.e. S/U-mode).

The CSRs available to user-space are SSTATUS, SIE, STVEC, SSCRATCH, SEPC,
SCAUSE, STVAL, SIP, and SATP. All of these are read/write registers.

In future, more VCPU register types will be added (such as FP) for the
KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  53 ++++++-
 arch/riscv/kvm/vcpu.c             | 246 +++++++++++++++++++++++++++++-
 2 files changed, 295 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 3d3d703713c6..f7e9dc388d54 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -41,10 +41,61 @@ struct kvm_guest_debug_arch {
 struct kvm_sync_regs {
 };
 
-/* dummy definition */
+/* for KVM_GET_SREGS and KVM_SET_SREGS */
 struct kvm_sregs {
 };
 
+/* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_config {
+	unsigned long isa;
+};
+
+/* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_core {
+	struct user_regs_struct regs;
+	unsigned long mode;
+};
+
+/* Possible privilege modes for kvm_riscv_core */
+#define KVM_RISCV_MODE_S	1
+#define KVM_RISCV_MODE_U	0
+
+/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_csr {
+	unsigned long sstatus;
+	unsigned long sie;
+	unsigned long stvec;
+	unsigned long sscratch;
+	unsigned long sepc;
+	unsigned long scause;
+	unsigned long stval;
+	unsigned long sip;
+	unsigned long satp;
+	unsigned long scounteren;
+};
+
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
+/* If you need to interpret the index values, here is the key: */
+#define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
+#define KVM_REG_RISCV_TYPE_SHIFT	24
+
+/* Config registers are mapped as type 1 */
+#define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CONFIG_REG(name)	\
+	(offsetof(struct kvm_riscv_config, name) / sizeof(unsigned long))
+
+/* Core registers are mapped as type 2 */
+#define KVM_REG_RISCV_CORE		(0x02 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CORE_REG(name)	\
+		(offsetof(struct kvm_riscv_core, name) / sizeof(unsigned long))
+
+/* Control and status registers are mapped as type 3 */
+#define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_REG(name)	\
+		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b6993108f377..a67cd9caa911 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
-#include <asm/delay.h>
 #include <asm/hwcap.h>
 
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
@@ -138,6 +137,225 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
+static int kvm_riscv_vcpu_get_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		reg_val = vcpu->arch.isa;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_config(struct kvm_vcpu *vcpu,
+					 const struct kvm_one_reg *reg)
+{
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CONFIG);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_CONFIG_REG(isa):
+		if (!vcpu->arch.ran_atleast_once) {
+			vcpu->arch.isa = reg_val;
+			vcpu->arch.isa &= riscv_isa_extension_base(NULL);
+			vcpu->arch.isa &= KVM_RISCV_ISA_ALLOWED;
+		} else {
+			return -EOPNOTSUPP;
+		}
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
+		reg_val = cntx->sepc;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
+		reg_val = ((unsigned long *)cntx)[reg_num];
+	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode))
+		reg_val = (cntx->sstatus & SR_SPP) ?
+				KVM_RISCV_MODE_S : KVM_RISCV_MODE_U;
+	else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_core(struct kvm_vcpu *vcpu,
+				       const struct kvm_one_reg *reg)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CORE);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_core) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num == KVM_REG_RISCV_CORE_REG(regs.pc))
+		cntx->sepc = reg_val;
+	else if (KVM_REG_RISCV_CORE_REG(regs.pc) < reg_num &&
+		 reg_num <= KVM_REG_RISCV_CORE_REG(regs.t6))
+		((unsigned long *)cntx)[reg_num] = reg_val;
+	else if (reg_num == KVM_REG_RISCV_CORE_REG(mode)) {
+		if (reg_val == KVM_RISCV_MODE_S)
+			cntx->sstatus |= SR_SPP;
+		else
+			cntx->sstatus &= ~SR_SPP;
+	} else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_get_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip)) {
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+		reg_val = csr->hvip >> VSIP_TO_HVIP_SHIFT;
+		reg_val = reg_val & VSIP_VALID_MASK;
+	} else if (reg_num == KVM_REG_RISCV_CSR_REG(sie)) {
+		reg_val = csr->hie >> VSIP_TO_HVIP_SHIFT;
+		reg_val = reg_val & VSIP_VALID_MASK;
+	} else
+		reg_val = ((unsigned long *)csr)[reg_num];
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
+				      const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_CSR);
+	unsigned long reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(unsigned long))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_csr) / sizeof(unsigned long))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip) ||
+	    reg_num == KVM_REG_RISCV_CSR_REG(sie)) {
+		reg_val = reg_val & VSIP_VALID_MASK;
+		reg_val = reg_val << VSIP_TO_HVIP_SHIFT;
+	}
+
+	((unsigned long *)csr)[reg_num] = reg_val;
+
+	if (reg_num == KVM_REG_RISCV_CSR_REG(sip))
+		WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_set_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
+static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
+				  const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CONFIG)
+		return kvm_riscv_vcpu_get_reg_config(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CORE)
+		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
+		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+
+	return -EINVAL;
+}
+
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
@@ -162,8 +380,30 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
-	/* TODO: */
-	return -EINVAL;
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	long r = -EINVAL;
+
+	switch (ioctl) {
+	case KVM_SET_ONE_REG:
+	case KVM_GET_ONE_REG: {
+		struct kvm_one_reg reg;
+
+		r = -EFAULT;
+		if (copy_from_user(&reg, argp, sizeof(reg)))
+			break;
+
+		if (ioctl == KVM_SET_ONE_REG)
+			r = kvm_riscv_vcpu_set_reg(vcpu, &reg);
+		else
+			r = kvm_riscv_vcpu_get_reg(vcpu, &reg);
+		break;
+	}
+	default:
+		break;
+	}
+
+	return r;
 }
 
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
-- 
2.25.1

