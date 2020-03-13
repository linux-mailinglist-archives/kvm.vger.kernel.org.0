Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC91C184202
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgCMH7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:59:30 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10272 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgCMH7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086369; x=1615622369;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=g1R8Lqs/Xugk7Z/kJsE6u24T9wMgBLSMPZrYIWOmSng=;
  b=DnD2cyH4TgKb0dSTNQaSyyQUKPi1jV/assRocyaNK9eTagGcUKVvjZzJ
   TPfTpTrD6tNIoSgCM8FVnIlO7Ynr5Q9lz4Y6x6veywfCVd+vmiMtbuIom
   Uxw/96b7UdyjntEh4WuCONvDRM6JAQuT1xBbCSQko05++y2w/L90pRxY9
   kZ/+5yk52f024VZjBxQDDHnrURjBPha+aF065gXG5WZV66B0TyvI0sh+d
   DdKYur8tZnybpMQLtd3SlMPC+r5GrPN7Y9KzH5FNv7t8wVu5CUX3AVwiN
   uEpqdctMitcacHp3ipZgJh5CRz5msQ8NenkGMq3ahLkCQcKTx/K8alz17
   A==;
IronPort-SDR: XNhZLRimaaZ7oD8+3kF/yaZulfxhLXDWy9+e8IvfLiyPaga3aaVAqJOBylN/UyMKIC5iUxcEGS
 i6TwvxR6nvluw7mGAAI+mZj4RTB7dHusyYsKc608Pl1XouabTWIU/uyN2xTva+aV4MDxI7/nx/
 0HRu0AOdYl1OIfbFi5yyOSnWiIRFOHtdiziBdlEIcOhgZij/s4GXXYfMQfmlmwtKAxf7C5c8QC
 Rg8JoNHTtVW9A1Y0qkWDh6a7wfMpfd+FKWQsqy+cdeDvUi4ImLTfFsGJmMjQhwHOvlPQkjMibm
 UW8=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132374937"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:59:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPhy7X9YRl/GPWl8vengIjximkx2mdoLBjFZijv+ABXt2U2sp+znZIWxRNh0YjjrpEik0kMYL5KZY1HsJgjBYhqeeReHUuGT6B+Fhwr2vXRFFZ3buw5fnbzYBIbjIqd29TQ0K8n/SXO2mElS4mHtg3pPnGaEmWh2f/DYsYyyR9ubsBDXOFWAY48QaiDYAqR4Og4NoltxQzxyCLix2duHU3+jApsdQkvFl2iZgy5RVQ4HeNdOPe22R6ri8IGgZdedbKqEknRhaBoV6Zdfc/eXlcXCt3W2hdyWjl9uafOoGsg69Xr0MroeITWyppOx5ezOAmfHqy19obYJJH5cJ6nYyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ty4bdh+Kt5OwCxO77RvcRNz5CQ2H9hWVWWTZic2g1I=;
 b=BvmWNUgT0Jgenv8FF3aBz05ND8lt7tTtvgPhPqpqgAPT0UT5niBwAmb82Zs5i4jiibElkeKuWVfAeJxdFysHLFY3wOjszhc/+XDMAdK5Pa9KahlTsBRpK4kvVMAHvQJ0WhemT53LbU83UXNJp3tlzCF+TpP+IUqB0gE/15ERCKG0oz0/1jjIxXWk786oPZbmmIA97ApHZmRttbEUuWC//K71lD7vdyDLcUcjrERLpvG80JVl/Mc8kJX69du9h4OpMJm3bGx/EeIlr7+gnqbMtuHe/wNUdOg/eWvKHtU8H7LwR25jM4l+wBKFEzb+vt0cdlfZEYEsWsc4sBpBwOed3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ty4bdh+Kt5OwCxO77RvcRNz5CQ2H9hWVWWTZic2g1I=;
 b=G6vkxEAIyi+dMeRjX5hO6jg1VoAWip3bcY0ET8SiWViJaPFwpAYOrFJsnrT8HRPE6R2ZsPMMFsTu4B4dNAuf17KKAqLnlWGgAzoT0U9GoudFvn4LAgcBEYeFRwhOO6lPl0b1eGu5W61XvTlo4shEUFxXV9qMfBlSbm4x/+S26Dc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6944.namprd04.prod.outlook.com (2603:10b6:208:1ed::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Fri, 13 Mar
 2020 07:59:27 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:59:27 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 17/20] RISC-V: KVM: Implement ONE REG interface for FP registers
Date:   Fri, 13 Mar 2020 13:21:28 +0530
Message-Id: <20200313075131.69837-18-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:59:20 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 21f22c27-0a0e-414b-1891-08d7c7247394
X-MS-TrafficTypeDiagnostic: MN2PR04MB6944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB6944DF07E0E1D58237B0C2F28DFA0@MN2PR04MB6944.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(199004)(26005)(4326008)(44832011)(55016002)(1076003)(8936002)(478600001)(86362001)(36756003)(66556008)(16526019)(66946007)(956004)(66476007)(186003)(2616005)(316002)(7416002)(1006002)(110136005)(8886007)(8676002)(2906002)(81166006)(81156014)(5660300002)(54906003)(52116002)(7696005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6944;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tYAAn1V17PSZOZBWkkNyns//L7v77S9suPMNYVgFjG6OtaXW2igIf28w80DqaIldN7qqzRlXTxupBJxTEid9hUc74Lrtf+Rvkfw8qyMhPfi9IWGvFv6pM0dSbpC0nwYTHdty28uXVLXbz0kWGt2cENGrpJ+7qSleuuLbVISrjDNQzt5+tu0KM4ItN+KPipoNTMSH/k1/v7/9h/SiZqaULKErffuL63VJ2x7o+FrXn+yLs+WXEpZRyfJo9q3450mQzCZa8UBoYQam5AketfPDTWjK7qwmm7Rx18AWinrYHu/Zk6CM6fx/6cfeYCY9o3/QjJqV7YAwvpSfAxPvEcqCz96EQhQqThY8mWEdXz4rd/l9l9TDg67KfZdrJRizhjR2qymbhFufdwmcET/Mr3axFLOMcjZ7o8xrQpFLBVEsastZeHZZarDKHU/SGSC7BLmUn90ZfJHp6PPJXhRGoAKWUMjxzUT7Oim/CAlPAohnyYM+b6zc7MPZaAcrqXXmhSGu8u+uS48e3NnDVXwXiWucLQ==
X-MS-Exchange-AntiSpam-MessageData: o/FYUxyEKLzruMwPf/BitlzVWi3N3FvlUbQ/B3/mjUtAd9p/n4ZZ00k/6Ctw/04ZMz770Nfh/g6CwwSFx/M1Y/PSNqb3IjqNmJL70bpDaL+/nLaL8FiDYI3UMlue/ysuObbUOpCcSTbzn5mb/BxR5A==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f22c27-0a0e-414b-1891-08d7c7247394
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:59:27.3057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GIHRth+jnPv9TWQE5Qq9z81tA8gR3CZtOfm0VUA8IAKEj1lJn0H6q5urSCZDZNWX7E4EpAKb3rZ+jhZB95/Ohg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6944
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
index f6f8b8ee035d..f1cda13bccfc 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -417,6 +417,98 @@ static int kvm_riscv_vcpu_set_reg_csr(struct kvm_vcpu *vcpu,
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
@@ -428,6 +520,12 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
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
@@ -443,6 +541,12 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
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
2.17.1

