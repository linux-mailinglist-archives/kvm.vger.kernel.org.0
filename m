Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A991BB7C2
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgD1Hfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:35:39 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57373 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgD1Hfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059353; x=1619595353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=vKt3nWiFbe2FtSt7t7Xe8Ru+SIfXb/RIIkgh6xvy3e4=;
  b=o7WQpmmssBWud3w48eoBSoKBY2MYuODhpv/k3/7UREpdA7sn3Ds1PAhM
   XQVL/6IxwQcx5FfxV5DI3A3aUdDNFN2LIEY0VZL+KF5B3q+WXiepA516b
   s5gFR19+RvLxqWynY2d3mmhxVYiT4TR7cFz4HZse3hNpXHIdYddXMk0ed
   24UhY2SXl9BRTajn4jakHqTdib33NLhD6JkY7igOc2XyHaXKek5RWPlzq
   9aLPDtTi5XNa4ZxOf9b6GV7PkBGfNLpCbzK9kddewCzEXYpJjghE2v/0Y
   DBS0dAgs534+tjjjw7UG7rJW6yLbIp3z+ogbNbPwRYJM07sFHIAq+jiSl
   g==;
IronPort-SDR: PHhzb3IfnCSdIutWWw9v4FiHN9JrHOedgonlXOIAP6W5lyqIhkNePWYU58IkRIn7zmbrfTYtLu
 FRPM229BmVqwazHo+7S7kLrXqGs/cte/xGoERkboTYDjYCrFdh0B4DxrB3xKe2FVxedUqrrhzg
 Pmr8pCZpkK3GsIhU0zMd6B4mOz4lmXUJrX1XRVODUa5bIYVS4gJfF+HfiRyJcQtZo9Lfez8yjw
 XtBo2Y4fBzAhcKAoXLo0cWB6BQcHyX7kldpjYxInz5lEujnF4ljBgpbiseJkqypFCAtVJrc5Cu
 MPs=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865936"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:35:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcrT/nJyq9HSmo3WXLX0s9/30+tRdER1jXycEhwIX2SSG5Wj5pP9OSWn236MOz3eLkg8IN8HjSkSYyBfy3gZZARV967lU6JV0NDOpso/bn1Q81NJ5vzUG0XyMQJiOn4d0y/kgHbB2ZUvYVLsgyjX6yNUgexxWOekNwMqSd54gfUrpV923eNkgOFRGSvFFs9Jpzqn6VkIIoVahw37NHrLIKR2LtROWTAWLPvVXFRzjnCbRxFxJ+ooLevld+F0kdJwN28wfziYNzeO10U36lElETLcES5PfntU7zIkcI08/9cUQ+ZzbvjBF+VNyR8NcAwEHySB7MriRf1gses96bnoDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKqNwqklkvDtEQvFYsvV84HoOK21YZBaec5bJm1tfmY=;
 b=G/FervavL5yuEhL2VhRty/DdDw9VM7jVh48Qw2+lspY/wZPOWQsUqM10/fvG2gw75NqEmCGqg4J+bcANDor6Jv/Xara8gW2nXI0Fyep+hRZ5DDKzPSnNv0YUbpVSR5MuDuKs+GNvfg6MO9wNZkb5/gnVMusnhuahhhcxlfncQcKw1hHto3d7KvsupN9wcr00uNo2YfVqBw7+NzcRLq0RyLmJa0uUzFysSKBuC4otsN+wRuLMuEPpJuWdZ/TiQ7nlHSMnHM/jmjeXQvXgProcHrBrIfNL15ac/JUGz66a3XhbcJqhflQrxxGw3kB8Vil/XNhYsHy71HrA9sDc7C5xEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKqNwqklkvDtEQvFYsvV84HoOK21YZBaec5bJm1tfmY=;
 b=Ji0khhSvKtj7qonmald0DVq6sFYfW1GpXgNnoS3aZTm2vDiptLL3ZqfVoSRHc2AkCflBhVXcXeagLU8DfOscuq/18a2mVHK95w1/0pUd1YC4ECVL4Ms8FeftLlG2XIJHWtbDuahLKzgpQL/drvzeBoG+rfjTSApdDeWEEdNRDrc=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5929.namprd04.prod.outlook.com (2603:10b6:5:170::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:35:35 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:35:35 +0000
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
Subject: [PATCH v12 14/17] RISC-V: KVM: Implement ONE REG interface for FP registers
Date:   Tue, 28 Apr 2020 13:03:09 +0530
Message-Id: <20200428073312.324684-15-anup.patel@wdc.com>
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
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:35:29 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8fd6aea2-34a3-491c-473f-08d7eb46bd00
X-MS-TrafficTypeDiagnostic: DM6PR04MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB59294AF704935514537259D48DAC0@DM6PR04MB5929.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(1076003)(66946007)(2906002)(5660300002)(66556008)(66476007)(7416002)(86362001)(478600001)(55236004)(55016002)(186003)(8936002)(316002)(4326008)(7696005)(36756003)(956004)(110136005)(8886007)(2616005)(6666004)(26005)(16526019)(54906003)(44832011)(52116002)(81156014)(1006002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UubKk4DRnFZG6KbIi0xtfUBtjgq7Tee7YomBp2ZiSYIx9/eEDk7yArUkpK3He98zOJPk3l5sjIPOwGtzolcwiIOfDYHdDRz0aerLpl3RfTtOcPmJZmvo1jZtyssIDJSDn8udjrM14n/g18wkp965BpFW97VPtWGmPlAwK60tLJJfpcDql2rnm6Q0nB8BbaJGFTxevs2Itt58dZR0EAztrlmQ3Gk7udfrE4bHENk2qyDgL6qzZ/DExrODUDAau2NasJBl4Ri212KcZQNh1VQbeZCNP35ll9NVhnAvlk191doR6QqH/NyHSoL/uzWRav2b/7TgP2hAul6gyVjzeQx5wwc4KjheZAgiYmnpH2IQgUqs12+fWUGZZaAH1gwxhyqu2quP5tZ70SVXbSYjsyHdmoU9Fxp8o2x0Dw/I/Rtyu0SYYhla6IYERfcNqUPIW46c
X-MS-Exchange-AntiSpam-MessageData: pbYZp3Efd+GTfU4CqRpiELazB3BhVXKD1jaCTX9vl7ZoclwpS5q3E1KMAq67W5MMwo+SsZWonrK3/ZxJoCU32FLoAVNnb1dEMaWGlmfMjXUVeMeq7pxJUyJCw+0QUTQV9lfliI3uJ9nxIvJdg/JeYgvnriB/geBOW2iD03n8lJttbJTnfWcMUUW03G2G9QJkFz8rnoYd20FFjUY/aZeSSz8g2cx1wrTpK746hFtw1gNXFNheezanl06SGa58r15WC1arVTn7j5kOIBBNJ80/alYkByupEZqWkGh/cq5JJs8UlVtlb7h9PPkDyPyHep9YFtwqyiHi8aGKujV+PxApwUyGxwrT32xYR+TyOa5tW8l+aKBHuq/kW7tyA0XLj/HKA6TKQXn5zfywdUNYwpE0dglJvGW5w999GiOyq+MGZXCmr5d3qyW5dfAaa88KVKfEqJvfmTWw7BEcAQ9kWekF4HcU4p0DP20TUB+AFVIWwgwykGrGDtkZs1yFWlfjNA5rj/1R22rUtb5SKXQAvONAvlijAsavNcXeO7pFcZkddb/G5gjTKs2oMHUXIEEejFNySD9vr5rMSTfHgDgPzCtrsDnXOBkKt1sQ3tZPD9O/gXMSiHN2e2+1MGKSh+Wpm+mwlEgbepLQQ2Ad4hZdtA2ft+m2LpJ31OOipLesYQ6wmFlU1blFDcfJcELTL+8WkE14VjRBLWltxLgkQnGZGIVueGFO1ZqBfs/lGLE0L45sRXf9mqsqphypbi+25qaqjUwYbbX7kgZUCFeFNFVSE6Ketf0hOwYoss356hdhy+1O9nE=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd6aea2-34a3-491c-473f-08d7eb46bd00
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:35:35.3010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9dcilzW+A2Ts+/+lg7Pql5YUpSXsngrJGOcu2D0ogOiwbs9NX6z2fF4LJ5JJQxdhsmTVV9Nczg+KjSfA8u18cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5929
Sender: kvm-owner@vger.kernel.org
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
index 8f15eee35a1e..f4274c2e5cdc 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -112,6 +112,16 @@ struct kvm_riscv_timer {
 #define KVM_REG_RISCV_TIMER_REG(name)	\
 		(offsetof(struct kvm_riscv_timer, name) / sizeof(u64))
 
+/* F extension registers are mapped as type 5 */
+#define KVM_REG_RISCV_FP_F		(0x05 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_F_REG(name)	\
+		(offsetof(struct __riscv_f_ext_state, name) / sizeof(u32))
+
+/* D extension registers are mapped as type 6 */
+#define KVM_REG_RISCV_FP_D		(0x06 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_D_REG(name)	\
+		(offsetof(struct __riscv_d_ext_state, name) / sizeof(u64))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 0f4b6b7165aa..a52180404271 100644
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

