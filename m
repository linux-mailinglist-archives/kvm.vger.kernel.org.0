Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6E38858A
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238204AbhESDjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:39:16 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58335 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353145AbhESDir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395448; x=1652931448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=278HJ4SpY7PPvwg4GD/FbRyz7lrkW6MSx1whRCP2a/8=;
  b=FxacuIE5CCgjbYYZ3nGIGOm3p2dE+o30/DLiuPar3wKju9kJ9IQcLhJN
   olJ7cg/1Ey35EyHXhRghTN7o/lyYwc/Nz5x0yP7jxuZ6Bzf25+N7BFc+A
   F7NtGd2qmXzpovuhOKuo5+KFuUSFIMddBJ1kGyIymiNObW1BJuTRgaRfP
   v61QJAguBZ9OTxa1PwfCmUKdAxQflYDzTiUSsJLroowsYw9h65mzHWSVu
   iOD72rjO3eW/3PCy1a8xhMSyvdm+VjbmtZ1K9Wl926dvpIZt8HAureVQ1
   I8Q2lPAtqvU0Q9c0xUwtWc5XoFPdgZbbklOAdqRY+87Ht5tP4H7JC+yMX
   w==;
IronPort-SDR: yKPpV8em2PyvranP0V2UJbDGakm4mHeM794gneHKBhBLb0QiwFWsKSTrJwBLVNsRLkoc4JFZyZ
 jBfGdIFDg1D88umn/eCsLOHjeSovyECCY9ZtjvsqfwJkAxHlu/oiF5UM9HLlnTAczje97jYQkg
 Flin5ML/YQWO6cuuNFthnu2c19cMqPUS82yWd5np2k1QzkOD8Pk6lefqXh7llOYj50pJZE84qL
 iLFdj/Cpk0r2ELKr4K//BRowLguR+fSHZTQ+zE+IkKQQ35PdYze/aHqOl8ZiluwDi09gnF8TID
 1Ao=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="168652846"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIcvGrZEytvJcjLJs5XIqY+bGxrA5/tWaUAM0y9wVKyIfZSqDlnBUHs1H+Zc6f/rye2h8Dwr0/XpwO0rPmWMJaI3++ZD0IxH+1KCNw/9URqs8sUxaTKUt9uP8dsr8H0nMggeVGdWnaWPYtsss6Kv5nPoUaT814PxRgUM9NeCELsNiBzh3KPqZxd1MANTReJHDWz+KCPaJrDp1Hfx/Gc1+FlAel0nM3cd8k2xvNW/5x6VT+Oy45HN4EMkR0Sdb+G8CzV6zzc6N+0WxZfYpoV94g0wsB+4LELws/rm57PMOsygBgvP9kGskF9lqFqIkijI+nb+15SerAR6eDaGRyq4mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFyGjQMF20mufNmi4q+JiZCdy1yuJHpHs/K7vLNxmQU=;
 b=GlDoqyBQGDCkrR+fmeiYNVIRtz+Ho8bA8aFISVKUw/ByD8TFj2MDIpV/A1EzPLPEPi9qfIIut5xpLTPtykbrvWvFAeVBGeX0OhoWFSEHH6a55Y3Bzn46kE/6j7Xf1Nz7K3uF5/lAMXlFgDxVqcMAozFQabk4hev1VeGpP2FDpI9tN6YzVEjZyRaLAHseoZSJwN51bPo1x0X8/bk86eaucImIkULWr7L9Kog3ZnTE8gPlF5xv+EU2nBwlaFv0QD3A+RXaidF6mRPZFZuxs6lpMIMHdORIFr8ytXGkAOGX9dUscWBoAC+x7npAvIa77zb0v7G/Q9Atw6FRBTkvozHWwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oFyGjQMF20mufNmi4q+JiZCdy1yuJHpHs/K7vLNxmQU=;
 b=P4ckI6n2g7gX3K/oV6YMSDjwlgvQqQ67hUPNGcqiIfHJt24O2a0gfHMFHc3kXi4JKEWPdax/PHSdV4Q/3rr1ctPFUfDjFmof6PX7atJ1wPX7RWGaGRZtGwbHAa4EKe2Dc6Ui9UV0MCTlDJPRpGuZFgYibXlN6UhcDK5T7mtB99M=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7745.namprd04.prod.outlook.com (2603:10b6:5:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 03:37:27 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:27 +0000
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
Subject: [PATCH v18 14/18] RISC-V: KVM: Implement ONE REG interface for FP registers
Date:   Wed, 19 May 2021 09:05:49 +0530
Message-Id: <20210519033553.1110536-15-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e0d1f92-b2c3-4e0c-48bf-08d91a776c4f
X-MS-TrafficTypeDiagnostic: CO6PR04MB7745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7745C820E0F98D61BA933E6B8D2B9@CO6PR04MB7745.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a96r6V1T8SIxApeIQl3KlFn4jbI7Ke5dLxzIaT9wnJNHn5e5WwmeWfZL7AWStMDojsUtnHtseJTyawY7gqqS8SUyKxckc9IYUsYR3E8WxRbwVmHRwCWSqF1euyJIp595u5ZRL4zWM9d9g08wXzEedNQaC+DebNpqw2tpN5RLi6bJq9y5zNjsIMBBmpl8hEA7eMgN7bwiLly7GUejOQrT2kIKiSHbGaTxWvmXCCX/3gh+twDUt9sU0PPYZSSrClSjQnFt1yUhI+fXyCDq6D/1tg4afJfoa4HBHXePJ5rBGMm9MS2R6pZNy8cVKndsB4iqSBm1fA+dvw50/4xBXn5djCmYoD2VkaCLtL+jxQkxcUI7rE8SN0+V5F8pUUh207AcSPPTO69Pkggdk0onnMUhfpX3PyPIRslUJJMj7xauzR3OhTYgvYTDQHuh6IU3LCqdbAm9nxjEIlXVVRwaLjHFMSKY8m4dVEInhuEgWlpVTd57JMjzQiHtN8KP0JgZrNrx+/nHkWfeCcc6ax5aAUIk32Md7u8ksZOjeyItUpj9axbKOE/81aG+GjspDWWBoUYtRYpYbpa94PqjMvNNRZVC9HAXE1UX/rnTeKBJn0XWRwxd5g3L4xr0cgpbnx1dz48lYD7Hqrs0S1CTTDJ0WqgkBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(7416002)(1076003)(66946007)(478600001)(2906002)(186003)(956004)(2616005)(26005)(16526019)(36756003)(8676002)(44832011)(6666004)(55016002)(7696005)(52116002)(8886007)(86362001)(38350700002)(66476007)(4326008)(54906003)(5660300002)(110136005)(66556008)(316002)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hIh4K2MZHKdKHG4IX0HbFzKliSGYO10DjQllj7Zkv3zQH+xUUW0zthQxaL1O?=
 =?us-ascii?Q?hHrocExW0zv0zQ9GbmE4PbiQX/Gpv36miYk6d9b0sXGFt0/0MCfeEb6ozoVS?=
 =?us-ascii?Q?Nv5bV+ih3ZHVMZDKdNfF1ub6Sdh+3c5lOPbcBRrhzP4BStj7vsHUq2pk0kz9?=
 =?us-ascii?Q?BuoZ/yxZrR1eRc3+QpZJNxLuWxqhoGO/EHxJ3PZx7+fvptdRDCQqOKFKIaVZ?=
 =?us-ascii?Q?lSIwumiJ9tvJaIjhrA4c23Z+GrUIsQjgq0TYsLFV/gcAM90c3AUvrOKoaisy?=
 =?us-ascii?Q?PWFISJYmANQ8L+s8RC70qGt8MEJSWXRtzkdJMmDYlhMYT/PjED3N71PwZV/S?=
 =?us-ascii?Q?2zaTnTgIvFDE73fsRzSTKMz+Jv66M5g02hJ/dk350wvEAO/ghceyVpzISeXw?=
 =?us-ascii?Q?ZRM68487ZIWo/4kj9AeSNr02biMzBqhF7i8aX2Sam8+t7aD7MGMul+tSw3lv?=
 =?us-ascii?Q?FdkKHUI0P9EVVHvABYAMcRHQ4PHAAGIAfVj6TdJjAaw4Jb7Cc4otks8DucYP?=
 =?us-ascii?Q?ImlF13xyGVLEMWwHXNuYMX/YmgkMHhMViiEXUTQncCqOmhkpceuIcR53qIAY?=
 =?us-ascii?Q?pLG2Hm5OOIpfexcgmpOkH0CgBAOj785VaMpFfX0926COkpdp5KZ7oPj+00lW?=
 =?us-ascii?Q?gapPZGffkAbtN9IUNJ9q2GAIx/x7JA+tVpdN1RVWr2W0bPAFYgXczBZMJd9h?=
 =?us-ascii?Q?Kcn/6rlQhd5KwSepjNZna1Qz/JIKCSH0vLzZhTWgkCrBcNLRANYyGAiS7toe?=
 =?us-ascii?Q?mn11oPq1muz3C+zr7qz59vslzpjDlZzxOncJo8cSCMGRW0uOjIIyv7knJWRb?=
 =?us-ascii?Q?FCwJCm959X2vkVa7/YwBSLTdKV5WqFMmTb2pl0cpOtaSnTewm5fr3FNkCqqs?=
 =?us-ascii?Q?graKnqXjRNGBhbrrN2qckEuhtOdO0n/pNk5CSzCaQco1ysSPOWMAZXhyj5cI?=
 =?us-ascii?Q?MDYT5jbiUlBsv9VBH/DP6BRt2n6X1UOWCE/7jRqHsdSsqY4ZIczSti5vB2QY?=
 =?us-ascii?Q?cWqqrlO7NNNZ1gy1IEOCV7vPRALRzSncudTlO4IA2K652fr/2/JDkxVvV/aY?=
 =?us-ascii?Q?pbBDzaJDasCug+2CD0lIpkJRR2pN+GQXF4dXVeOw7FVdxvd21lPDkUbvIcm/?=
 =?us-ascii?Q?jc3QbnYYBd7zuFXPPtQQVSaQXJnMs31fEJTkR5Hxxi6n5EzBuT5NFAz26PBo?=
 =?us-ascii?Q?xok2CP+mGDGLQj99NdkxxvU+rWRWsTjfyCTlzQD2MVnatBnuFGuGU6tm5/r/?=
 =?us-ascii?Q?XqCaWLK5KhsRhYrMtLf0oIbIkFcbB+I6MOEA5UtAms/Og8AFXFfwHDQTdTo6?=
 =?us-ascii?Q?99Z+eo1grDT8O18mAcrLthOW?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0d1f92-b2c3-4e0c-48bf-08d91a776c4f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:27.1376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RGcJfRDzbEsmz7iFGMbtXh0O7GtdblGjKbrjtG/JzWLl5Lx8prhIMSf4qVfAeC3cSnabZpZcsIGfvBeG2XrtWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7745
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

Add a KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctl interface for floating
point registers such as F0-F31 and FCSR. This support is added for
both 'F' and 'D' extensions.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/uapi/asm/kvm.h |  10 +++
 arch/riscv/kvm/vcpu.c             | 104 ++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 08691dd27bcf..f808ad1ce500 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -113,6 +113,16 @@ struct kvm_riscv_timer {
 #define KVM_REG_RISCV_TIMER_REG(name)	\
 		(offsetof(struct kvm_riscv_timer, name) / sizeof(__u64))
 
+/* F extension registers are mapped as type 5 */
+#define KVM_REG_RISCV_FP_F		(0x05 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_F_REG(name)	\
+		(offsetof(struct __riscv_f_ext_state, name) / sizeof(__u32))
+
+/* D extension registers are mapped as type 6 */
+#define KVM_REG_RISCV_FP_D		(0x06 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_D_REG(name)	\
+		(offsetof(struct __riscv_d_ext_state, name) / sizeof(__u64))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index f2f2321507e6..7119158b370f 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -416,6 +416,98 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_riscv_vcpu_get_reg_fp(struct kvm_vcpu *vcpu,
+				     const struct kvm_one_reg *reg,
+				     unsigned long rtype)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val;
+
+	if ((rtype == KVM_REG_RISCV_FP_F) &&
+	    riscv_isa_extension_available(&isa, f)) {
+		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+			return -EINVAL;
+		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val = &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
+			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val = &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
+		   riscv_isa_extension_available(&isa, d)) {
+		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.fcsr;
+		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <= reg_num) &&
+			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.f[reg_num];
+		} else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	if (copy_to_user(uaddr, reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int kvm_riscv_vcpu_set_reg_fp(struct kvm_vcpu *vcpu,
+				     const struct kvm_one_reg *reg,
+				     unsigned long rtype)
+{
+	struct kvm_cpu_context *cntx = &vcpu->arch.guest_context;
+	unsigned long isa = vcpu->arch.isa;
+	unsigned long __user *uaddr =
+			(unsigned long __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    rtype);
+	void *reg_val;
+
+	if ((rtype == KVM_REG_RISCV_FP_F) &&
+	    riscv_isa_extension_available(&isa, f)) {
+		if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+			return -EINVAL;
+		if (reg_num == KVM_REG_RISCV_FP_F_REG(fcsr))
+			reg_val = &cntx->fp.f.fcsr;
+		else if ((KVM_REG_RISCV_FP_F_REG(f[0]) <= reg_num) &&
+			  reg_num <= KVM_REG_RISCV_FP_F_REG(f[31]))
+			reg_val = &cntx->fp.f.f[reg_num];
+		else
+			return -EINVAL;
+	} else if ((rtype == KVM_REG_RISCV_FP_D) &&
+		   riscv_isa_extension_available(&isa, d)) {
+		if (reg_num == KVM_REG_RISCV_FP_D_REG(fcsr)) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u32))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.fcsr;
+		} else if ((KVM_REG_RISCV_FP_D_REG(f[0]) <= reg_num) &&
+			   reg_num <= KVM_REG_RISCV_FP_D_REG(f[31])) {
+			if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+				return -EINVAL;
+			reg_val = &cntx->fp.d.f[reg_num];
+		} else
+			return -EINVAL;
+	} else
+		return -EINVAL;
+
+	if (copy_from_user(reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 				  const struct kvm_one_reg *reg)
 {
@@ -427,6 +519,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
 		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
+		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_F);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
+		return kvm_riscv_vcpu_set_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_D);
 
 	return -EINVAL;
 }
@@ -442,6 +540,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
 		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_F)
+		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_F);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_FP_D)
+		return kvm_riscv_vcpu_get_reg_fp(vcpu, reg,
+						 KVM_REG_RISCV_FP_D);
 
 	return -EINVAL;
 }
-- 
2.25.1

