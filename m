Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF772F78B5
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbhAOMVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:21:41 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36814 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731581AbhAOMVf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713294; x=1642249294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Avhe8xRg37tbBK+gtU/OneZO10+fWOTIrNRB9I3H28I=;
  b=r5HCDzjGGh1bbKraO6Tcdc3adJz7JvL89emxS7wvgVvWpy19nvxE0q1r
   8jc878++6EYcJ5IWMEO/zzuXn0iM1sANSQK7IerA7uX1q6/tjg5GUGgTp
   XklBD/NRteF7Vc7w6chS8OEZx/+iGTKA6U/No7Tf/2hzAdE9EpGM6rHPe
   WwumErfMQwOFHh9CmuadMFIMbkXCR16g8A2LTZidiIystkreBidLa6z71
   oJP1syQzgz/MFsEIlavX26qFL6+xwpXeqraX5Kctp/lW48Z/rwFbmwStS
   Vy/YF58ak5vvwepJGSk5kbLBoTTm1ESUQSf8/X5H46iMUGEpjV43LWOQn
   g==;
IronPort-SDR: TNCyBwrITsyijKPr16LzhoIGyuG5sLgkiLMWwJ1l7GgABJmcb+cp60txSsyiLD/tWo86eldJ4J
 fLmgKspA+dngpc563OAN+Ol4rl1KgcnFJdNBL6feu1C3uzSyDGqffawjn8uHiUI0r/JcXGQEoC
 UVnPsLRgy+IKx2CGB5MuqiV9q2CjSkVA8oL7gjfiRHfY1c9fv/Gfyw0Xfjj/PYODZNNCLpc82C
 qch5dAeqeBYW72G3UOOuAY35jz0J36UheOXSp0dIQCdpHzDdjtFUTz6B5WKm3zP7ccwBFLvCE3
 kmc=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="157507140"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:20:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZgZQFQFDqaTtUqNPpp++0Ys7iJGZkdRT+3/c/LenpOcAZW4ty3YOVbi4dDXDjXnpooJkdRIsGRrTwvgOrdyFhYo8AadajTWfSfLLLxmLkLmn8pPgCKQpOgQuX9zWpJrobfK0HhFDKNRaCFP1cidRsLc+UG1vM/NNQ8YGq/mQdRlg7FAmuXHZuWq7d3X+mTCiCAn1v/bGUouUHh8uUbQQ30LH4S6qmWzfVxuapsE3SgaZy5kFqas5K/aPFoC6W5lThGkiYGfOi3ORiN3UGfQnSzj9rcDUCJLUapfPY1sUswEuSu6BpNmbbaalDxyDxKLgH7dO5gcSoK2wEx0CAaceww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rbY6Bu/pBIzW8MEDBdceVbFC0gJoZKzAsnc+vEk3jY=;
 b=ADN5SitsCTh2xk6CexoK5OB+FstvRM0pUhnX658dTMWJ3e7Ncj3oJsYWUoNKSF3KI5SiYDi25XYlbuczI9FbOE7yU1EKdGzkftqwSZyIB8BEKirOeIDZwTnAemHgdetvEU5VkjP3cm/o7jG9u+absFSVDWkwSwnP2psaVgUtGmEvqQlh1Gg6MN9SFUHJD3sZiinkQeOhDhAcFZGqR+td1GpkXk5AQFqEvQq46FH9ltTmXKZBExqH43ntbNbCy8W7CMHsrgRBllJU6CoCZKLqx6Ob9J/VizuDX724KIV0mG7zUiKVA2qJ6rKINEF+wabO8uDubFy/zs0SZl478bYSHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rbY6Bu/pBIzW8MEDBdceVbFC0gJoZKzAsnc+vEk3jY=;
 b=MWE2z/5yRT9/uurtGQLwx+vm/MR/OcpkNKSEoyxHoOKoQMqJxEVmm1XHtynUv3VuU0PLf6O2js+ZnT6MmJXqt8xXpjmVznR6kuYBYQ9uzQZK5ZvqGCuLQUr3x/Wo/C0yLaHSgXff44vHR9Dn1yNdqsiaBTGW6R6YmUn5j1PfFyk=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:20:27 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:20:27 +0000
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
Subject: [PATCH v16 14/17] RISC-V: KVM: Implement ONE REG interface for FP registers
Date:   Fri, 15 Jan 2021 17:48:43 +0530
Message-Id: <20210115121846.114528-15-anup.patel@wdc.com>
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
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:20:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c8e5417-10e5-4d1d-6499-08d8b94ff159
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4330C7CF436CAAA5D7F1F49B8DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tabe0ciHIWDrNzql/2ATb8f7icZ53Ro7PMoIIUNl6BWtQEfbidZ84qjlvN33jrPfMRrVFgz23dBxpOwf5Uyt1HGyePRTH/4VVWmxjzEVA6zxzvCKmvL48rh+7YubSZDVpsEdVsY+tP0uBe4GPqj343peWUFnvoD8ukeqbiFL8+s2PI9k/LGhIUydj/rYH6Jt6TEtIHlk+vAWW5trygI7dBStl+eolqyZEGkHsMR1I/jTXgERdoz6vB/RqKTSZcj7EMV05zL7ubYw52/xQdSDl0OA6W/NjqiRwZNLmj6XJsrPPFuTNGRvz1lDMHyAOitzjyqz/rv49Zqr8phOfHmxgZl34w0ILRNc89HvQV90hf10GJh0JJlhcip5BOR66jsxDN9caXpkF1a0sFBloQOOJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(7416002)(66946007)(316002)(1076003)(66476007)(8936002)(110136005)(186003)(66556008)(86362001)(16526019)(36756003)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NjVBpIIQBbkOXob83ejxnTmZaLXAk9xJHxFDp1JpDNeHymkzahFd+PTgkOF/?=
 =?us-ascii?Q?ItLfOyFdOHOu/yS2D15XupX0dd6CwyZ02F/B0LkpSfb2tpgtg2KcsnyI7gTM?=
 =?us-ascii?Q?v8+e+EZxK2g7gJY71cG3B8q/rfy0eAB8xlBKAilpkjPHFl6/u7aLOQFfTXBo?=
 =?us-ascii?Q?bP0nUNySRIKnE5VcaVq5VsG7ZDCXs9C3WToOffCZSq6uMvq4ndzHtlg7AwNd?=
 =?us-ascii?Q?RIKr/klaxsfiOmpIfXIJQ9mOhHktYXKQimy5+MZA2jT5JxeNmPcLu9PF5d1F?=
 =?us-ascii?Q?ftnVgxJuwqUxVPBLSBsXTdY4Hl7YgFwfE0fOYGet2imbBlgTlZH99+xjttqS?=
 =?us-ascii?Q?qxaMn+2i0XBQLpQhwxifMxCXVSgNliiIbv3W/o2hCwm/ZSA9vDfVj/gpN8nb?=
 =?us-ascii?Q?8ucqimZ07JlbZuUp/gRB3qqx9SzgAeRCZIw5I8spItDb77Z1SMemAdbnjfNu?=
 =?us-ascii?Q?Lct8KUs4FmA40qYBx7tROsud0UNNOX3hL3vxIh1KyuKhbNiu7ZqWdDl49o0E?=
 =?us-ascii?Q?sFi4NY+cerrsTVpNs8lCGgiB2Z5Yp4Z8zIHGSfmf2qTIVPcGSMFIMWfXdmgH?=
 =?us-ascii?Q?rKxv3WfLmNc3TTNcoa2R1NVizMjEq5LAJa3hfZ73rIW+Ezh7anP/QvwmQ8Vo?=
 =?us-ascii?Q?0gAOYi2kfAyXxfFEpEk6NB6S5mOqQ6D7sYECpyKNxeuzZFumewvJUxI8CQp6?=
 =?us-ascii?Q?TkI7yDrVeCIrpv2rtmboJHmVonqIlEoU1kC7sK0rnrWKoFYFKWvJ5pRbYXpE?=
 =?us-ascii?Q?wuf1GKopXPIEAiUucLr1UxbvYTxVegXkYyj6KDu4acemgBI7LhMm5Wexh6XG?=
 =?us-ascii?Q?pKiinQqhm9ERPCLNryK79m06yDzxpCSZggHTODAiT0ncXdTFrlYEoEDbK6AI?=
 =?us-ascii?Q?Ftfr3tlGyR+w8gCmtmhvuTvxFi3Tuncp1NWiXhc41OTYe+jNMAM1P48B2oNu?=
 =?us-ascii?Q?XQ8OJMUL1R88ICAmRyln7LqbIw9igETZJ0mwvpAC7L9BpWHUyUtVX7DSgTNf?=
 =?us-ascii?Q?XKib?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8e5417-10e5-4d1d-6499-08d8b94ff159
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:20:27.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/zstFQvfQrvPo4pfn+wXyllElgXFF1M8ZhHGs3T8ccITYYmZ1GE1G9BY67PBfNSg8NuMvF8QRw4oxbMXM/daA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
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
index d039f17f106d..2d8bab65dec9 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -431,6 +431,98 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
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
@@ -442,6 +534,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
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
@@ -457,6 +555,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
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

