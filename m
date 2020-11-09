Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777EA2AB718
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgKILex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:34:53 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:1455 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730075AbgKILes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:34:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921686; x=1636457686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Oz1QbsEusOtvbubifHA39dsl4XUiDJgxL10JqXIFoa4=;
  b=rH9J3Wz0v7rpw4CC7BFmqu/Yc0MWZ7qVrehltg/KZRchGueJXgSFjU3G
   KygEl/OaOjd4L76HFFlC90p8vaYcZoad/fAa39FYYqvAUn2NPwmFT8una
   /eoTdgUmHTRgxXwWKl/3YiNlIPXm3lriWX6FBn2WZ+2nZP7a5blXXk8YC
   6Nd9nuyPds4lAvLuvPp0Bw11UXrLciCQA5aZnlRMA6GC96nisIptDPEaJ
   izoMDZnb97kwIDdxIr9iSVWAbual5ya2i3huUsKbEPG5V1pWoHk4dDVcf
   skAQ6V5bsrdWUWQCl/tOVxXYSQFtdWzEDOJ67PKnrOew0OUMeKKFMkTko
   g==;
IronPort-SDR: SKkXdsgOy8c5H62CISKOlbeYpUQRWVLMNE6EmXSK+Pe7LswQu+mHyXIfUSptHDD9008a8whJF7
 hjxYfykBru5NLVwyRED5KqOpevMXeTuBEl69/YP/N0PV/c7Ky/Davnp8iJMs/Zn8mQpr7sQ4VE
 CLSLRRzVFZa9pT4yC6ROXXRgVU1gqqFRKy68f3/USPKNtbo3mY8/ducR4UXWbAXmfzWXkg42hy
 BJUHZWUcupKbTKUGR2PVkx9z9B00BSxShSYJL7H0FLGwsYJGfuM+p5LueVeeRN33NRXdeA5DxG
 j6U=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="152081059"
Received: from mail-bn8nam08lp2046.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.46])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:34:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkS5AOORpF3Wl+PF5tGw5s/U06IpVGN/B/KnRa5re5ZWaPwXk5AO0tMGORvX+oRG/r9OU/VNVm1izcRukeM86J8Ql5lqHU8txcfKd5QA4nFrpcsLXNcIZ8ioB4i3D47HNgBfCWz9x9rTmKEOgP1+/0W0/qszFYMYtD0vsmCt9Nad1lSMz+1QZE9+8vae8eVpZ8lKCj3/sS/kLcPPw2eawaZ0B9kxg8dKkY1kzOX34hOv3hBVhB0PlqxxgAiDOUokE6R0hcSCkBlUkPH/MT+BwnNnIsGveaMXGL2VcIzg5Pr4YSo0B4QVS8XCaheaLdlthzfJ5EffjWDcByNsg990rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9l/BYtVt7dK9ZDfAtSAr1mkf2KZcxu9AfQS9ivD09A=;
 b=dEB1vxdztrMs6oYjcbXggBlLQW3NUmILW6F3cFJdeeW3jQqHB66g6aBx7wK5qGKeVl2qzN7hjPW3l8cpHef/Eg7JUrNI3t8rFCmg/AYgtH8J0IrFPXZwjt8o6wMo2M9js0KFM6DPAmJpvolfcTIJmU0OpH006kntuzewVFqVMNx4jcW5/UX7+xEuIWJOb5+qNHhgFhHuT17CyLcCJqtSjKD4vJrFB5U3/5jufJjHUJMBvN/OLG417UhHrzzSd2ncLjdPt4gf5VomGM1qNMRdWA4NWksZLfMApBqLlbHKrjHCKiotzAU3F7zwEeTYb6vIKr79UT8bRIUmMf0WPkLjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y9l/BYtVt7dK9ZDfAtSAr1mkf2KZcxu9AfQS9ivD09A=;
 b=S/BNgCamdQ/kcp3Udl4jAGd+HAoBwi24SvplU1y5dEghuJg//pYNghG2NtvTjtjPTgEtbw2mJY/yjeCdML0hvyHHSzZIkGxgtkJR7QpNARWdUPGWNf2PQ7u6B76WaOs32eiwYwX74YKZz0sI1kpqb0tw/qrxOWUnD/g2lfh008g=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:34:43 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:34:43 +0000
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
Subject: [PATCH v15 14/17] RISC-V: KVM: Implement ONE REG interface for FP registers
Date:   Mon,  9 Nov 2020 17:02:37 +0530
Message-Id: <20201109113240.3733496-15-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113240.3733496-1-anup.patel@wdc.com>
References: <20201109113240.3733496-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::17) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MAXPR01CA0099.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:34:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a61b9369-64f6-4243-387a-08d884a373a4
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB3866FA6CD1604AA9FD6811C38DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 80IFlSWv5tX+FI+5VH1T8brwLrky9ond++5R8qCBHfiXEnpbIekKcW9nWki3csnUuZcT3Ae+SfDr3ChpXP01jX/wp5Wx2IfSN7M/qQsY90aZkFLhgJS1hKZEv/agsNFy4egdfeYpHtcNnK5fQ+2OwEWPiIXcjgfAD2p8yOBvv1VkKg490GRUmrT8/gQmn9HjhBKmx0uSYEcjhJICHeElK4ltpM6KZcjnqfzQSiCTX+mOlS78MVJD5tToR3fEjt6WWgkG8Q3YwvrF7e0J73DsAZH4UXiMurJd2DTwQ8HVw+D9BpQnY9nK/VE2BLwct/Uf274qoHWJn+WSWNiCaa3X3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(7416002)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(110136005)(54906003)(5660300002)(52116002)(7696005)(956004)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(2906002)(36756003)(86362001)(8886007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Hto5f1kh/Lr1BynwhF1hbP25lQ3TtQP/Qr0gblCKfcQ2BfS/XiKOJme+DDX+CQQ+LWrh+I9Gz45FawFCwkwHii5pHn8x1moddwy1OOvL33xHy8kiHo0uBlgM/LrjQAbzv2mLi7bhcLZBatDDfVnSN8lnZ2xd6P/ObfWdv1+8ykzR5ZZqr17y5i35wi0nVG2vXKmHumz1VMjh4Be/+Y35szh2bL1EO5c2V7l0Oc/Wm1wqVCiR8zrPL685v9eQxaJeWKl8VsjxEvwEFxo39zjz/5RZQEWE7hRh3zLu4hOcBvx0hDYSjs/nu6nSUws0BirCuqk7MBbZttQd0iNeq7iobt0nJidCUk1e67WArj9ke4idRl1QfmbsQIACtEU1kOkYchH8Xk8l5XMOiNkAfxnqxaQjWYnYf9/LrdI3HLgR/NaXHV+Ujk8GtouDiXgof+sB+Sq248M2YNdHQLS9dIWWZeByiMeDsf4M7ZKl+Tfx8r01lxEjICSIabwGCatpNPLPSOw1A0Hc09ChlEqz7jact7R1ybJQIBgiRo28L9xoVbvmBwda9bJpX/by8O3bXftxIa+sLAM1O3P+jatmFOcmIODYYitd7yJnR3K+o/ACFHn8kgxoedWpW5SS2lQHh0hjymwyiOFa0s3H4Ulm4ZMxLg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a61b9369-64f6-4243-387a-08d884a373a4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:34:42.8972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNRPeOUvGN8ALawCcNpDFSxYq93iSGikOQ0lUbuBUUXueu2RozQ6gdbeyHFpze97beI7f2l1Yw/uNWqsHcBRdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
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
index 00196a13d743..7e96ac1f51f0 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -113,6 +113,16 @@ struct kvm_riscv_timer {
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

