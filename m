Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0863D6E70
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbhG0F5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:57:17 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:33781 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbhG0F4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365380; x=1658901380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9ilstC2JTn0JK7VQYCSDo0tgCGfaR3tqlXPcyYc8/U0=;
  b=BjrgFfHx2jAu96qsOtPKkPTCYXgbXO/7IIqMBgMhsmEKgcCdgYnv5Co6
   l267MX6BBhhTiYw/GyuJoxeVNu/I/NJdwriOlp7kZXuH+y6zEw2Zks2cN
   u0amZp1nM1//tgsCQhXiQcwZN5Im3MVHZ8c/ilYuM/EGT2IP97BiQ8cLw
   O9+DpSACAm1nrkVtOUbftw3n0DKGObCZboPBO8kQQlzAa0C2OBy++z35O
   orjU58Lk38cmsAOoKnRRxkFuJQpUJ0QbKhHjbep6Z8KoOLcxY5n1OE19X
   FaEZthYchuJBSGDH6HhYnzoe9P7DRxqTN7YXnCttu8bnga4OAt/XQLoqD
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="287130040"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:56:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=id2lu0TrnFk+YFzr0XYdS7GbfJ51RQ1Zicv/RC5qK+ZrGNWwsPOmAZ5Ltimc1+oQUnZnXfLl73mbuKLh3Dyts2iPLH6OF/XryiPWAVBdX8hhLv+Q+wtx1X/MR8ly7SFPf0yqIgYF70Ng8SVFs7+CMrXNcCD7mfNfUSiFgnd+CiVn9Dsg/+ExrdBkwP997yWKu6TNsZL0u4mBGEnPISHaurkONSHmr0P5A04EGoW3/Q9sHHofZENtiaEITTj3e8AcYSpswCz1chrum8qa6GASW7XBOPvsTZmw/OroqrnY3HSIkK6c0Odmg9rjBjSsMOA9Ekn0Oxv/sMpPPNJ/73oVwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKy5SbU0QVn2+pitRs+yj9i75lvBSlPxJg0htb/9Jvc=;
 b=Zk1qrte15uX6xVQBuyrPc4TsS9pcxFEO6xvIUig8FUcfHpk76Bm3e1VIiyxNzP1gMdPDwbE7BCze6vABkykr6SlHRgDKjtfYIYN/wSfA9DCzDxuguu+97SLm4WuALnTSnHhsc6l66+t1nY20CJz1GaeugNLMLHfisun2ZfUFdZd6qkcEKp9DIOxcAYFYOA/eJQpg+hNF+2fD2gKuqTAsScOrUSvdzDH+ptvFfE7zmFVpT3n9sI4SOgVhYQE6GmoMkWmN+BTGRBzo1LADchbzJSCQoy0x75wfKUO4HclCly2J1T2b8sQ7N/2608qmL0aE/5Dnu2GIiMZrM4+dfYZOuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKy5SbU0QVn2+pitRs+yj9i75lvBSlPxJg0htb/9Jvc=;
 b=UgWPppPu12tbYksS9m42/N4xfFGFM7cgLZjiQBBkaAkKl6YJx5bxOTYLZPYdO9soTLJuvSHStFC5wuhgmeU05Pjx9RPmiGyYnE2DM44EVozh5+gi//b3M63ZGISuNhw7S0mU5c4Tak2VJTVzy5lzEyxxqSRHSUFZBBzE/iQEXzw=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8284.namprd04.prod.outlook.com (2603:10b6:303:153::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 05:56:18 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:56:18 +0000
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
Subject: [PATCH v19 14/17] RISC-V: KVM: Implement ONE REG interface for FP registers
Date:   Tue, 27 Jul 2021 11:24:47 +0530
Message-Id: <20210727055450.2742868-15-anup.patel@wdc.com>
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
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:56:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ff5cc6a-75e5-4ec3-bf97-08d950c34069
X-MS-TrafficTypeDiagnostic: CO1PR04MB8284:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB82844F6CE42B53D4B328739F8DE99@CO1PR04MB8284.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mb/Vrli7qOTtCCm23wEpjd9vOEUXLNEm6YKFesujosWgspyTaFc9j86KH93l8Ojxl+Qt8wmK+eJoBqV4QWia2uLMEK9Nda1099Y+ytWkshQ+H2P5U14SpMuVwdNwOULZreBULnYSpIWDguJ9NOPeb4jfuGPXhpYTLT4F08gi1vQtBAyw2OvRIfOJkR/TwrXv+R/wcTTJP1nj63JMGQ+wwHZsJknUC4sGiIbJ3HlAqkj9aSiWnCB338r1pwQ+K5SV3/1AWV/PyQRsN/1Ec3DTn/eMDXPhWeQsuwJYXHtgWNVmaN5lW+6DBFmLqQRIJCD1No+f40WM/UGCvgNWZeabNM3tvcRjVZj6Rm4dxN3MGbFxajz2rACwCMHFslsCPRFuOGR+LPjfO5zY9Ib2WQKC3ceVRNy38waC6QCo+cmmjcjSVdT25C6ON/figg8+UNiUaKskCBkS6ISgIA1cDa6HB4SLUY5wYsWg/XYbgdzDFHouYw7YWQmazy8kxiXq4xk1g/nVFX3oy9Z++OQiLj/Cai8068iLeDIclt7jPAyn8ntzE4H1LKLsRkweATi7FO2NyFp8/thcyJzr6CBsGgzhG0qCTD2MWjv5SsQkdYDmke3RkQbNXs+3SRQulXnPWR/xnMzx/+lJ3QwJ8C4SyOWbBPbPIYdcN42WZVShIMFe6FeBknmI/dxBR6e7kW0COnu5XPnSY8xEmY8XGDvXpMkStQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(66946007)(66476007)(66556008)(956004)(478600001)(38100700002)(38350700002)(26005)(54906003)(55016002)(36756003)(110136005)(1076003)(2616005)(5660300002)(2906002)(8676002)(6666004)(44832011)(4326008)(7416002)(8886007)(316002)(86362001)(186003)(52116002)(7696005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7iqTDHE5aG+WH9kz+AnvKUbErkMz5uBBA6Fp5GbEDd3AFX8qifw3bCFJqWxH?=
 =?us-ascii?Q?UXKquZzTUE+WBdtVtM5V00hhgBk8gKX7qJw5uS3as30N3hig54eSYWVQ4OM4?=
 =?us-ascii?Q?Jei6PJmsjqSUy/G/5ZOzaM9Xbjn9aAcy7LdjbpS8jHh5f2CEg4yw7EnrKcV6?=
 =?us-ascii?Q?0O5sHRzXEHwJuVVvTgxxfhcLplEe1xBFajN1sG9hPCu4wB+bG7etViNhQt75?=
 =?us-ascii?Q?RVMqdrmz27DWC6zaQEfwm+rRh1/a6MAhnDTH0bHJ19pfg0zd2rZPbWSmWmqA?=
 =?us-ascii?Q?d6w+jRbsmpGnnpBRk38jk4gUICjBLGwjpSpbJcYOIsodU4rAamWmPJBsu16Q?=
 =?us-ascii?Q?QjI8IVeYiOkW4jyFsAQvcuHPa3tIIEcNwVuT9iDSgTyrYhRBPxQAtrN97y3T?=
 =?us-ascii?Q?S68LCLyFHB+VTlghUmDHzBewMDsxkwAqDObYxayVEz8LluvO9Bjrf2blnkDZ?=
 =?us-ascii?Q?LziijEhJGCUJXxZiK+vHB4VynalzAgsn1RAGCRAqdBMIt+o8CEIaApWNYSim?=
 =?us-ascii?Q?wbC0WgfBOHV/9OEcvd4A39tNm0QTf6BhWeCJl6azNjfnR2ELfkoJLTVbFsJw?=
 =?us-ascii?Q?zSwhwyOTHOhjX3IMmc8w0icreF+txQ9lf//9F1TRb2SXY+v0phYn0xPC5KoL?=
 =?us-ascii?Q?wluZYFSovyV12NOUd8zCubf1CyCUZc+DEzSqrtvIrlKq0OoCrf6lqMY8/zuW?=
 =?us-ascii?Q?KxphzSK3QibMoJcYuEidUpFdGk0vGcKT+8E7U8FkhZBXCLg4MbNet5Itiw88?=
 =?us-ascii?Q?xfuSVGO2oRNzDpJE2L0Pg4e2X1DjVuapDpYj8rpahJPPGkusRXIQen9C6wd2?=
 =?us-ascii?Q?2fdQbeXQdxlag8m0Q0SF3KoFGzTP4OLdWtAnLNmLN0i+o2bTgaNsCR1dkP9D?=
 =?us-ascii?Q?u0EDGbo+sWagPArcyrMfvj2Z4h2mWaSk7iAqMAsl1OSmEjBJz8FrzpG0X82k?=
 =?us-ascii?Q?FlpgCItD+6ClzwZCiplYwFGPnOprQwDlzicZhUhsuQCPYTI1GNykvlYE2Yp6?=
 =?us-ascii?Q?QnQ4Kqutejf94S48HtEs/o2mNOY534nekDpGyg4NenPhI0VR9OhCczf81dSz?=
 =?us-ascii?Q?y72G1zgidiC5qrzEvkVnfhITWuCXvfcqjlfqVyx+lo3rwweKy8vj5gWc9YrL?=
 =?us-ascii?Q?uREEpaVmH9jGhjOIEXbI2o9paMzXDOrrkoPPdu1t9j+4bDUlP6s8Ouokcz8X?=
 =?us-ascii?Q?TSbemC0K8SFQVCEV4baEm4QV2zILXanp8xY8lA8MKrj8+tkzYPBc6n0c6f+f?=
 =?us-ascii?Q?aqZaEkgQ5hVNZQB8QZhieTPBGXfWP2rWH/iVvLVZ0fo87cPovQUEd2QMewKs?=
 =?us-ascii?Q?UigBNBAYpRR2HE3Bp+6CIfdP?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff5cc6a-75e5-4ec3-bf97-08d950c34069
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:56:18.0546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GQsneGg4+xuynQVmyIBE7yJMqwTsPOV5BBHFeG797lerc0umaXckgfayI1Yl74jl7KhizF8irR7ziJrAF96ZkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8284
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
index 024f2c6e7582..333d84015047 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -421,6 +421,98 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
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
@@ -432,6 +524,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
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
@@ -447,6 +545,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
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

