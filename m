Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2870721B14A
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgGJI2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:28:04 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13758 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbgGJI14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:27:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594369676; x=1625905676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=D8uK/kOOdydvYMixhnFCYFsinaCDflnoW0s/L5t6O5I=;
  b=eHIuYJ/11GIJbXCwRukN7akjaOEqNhxwFjuVejY1c8NnIQwFQnh99hBB
   momVYU5Gf8XJtSc72H2zPxkPTfxU61XNd90OkDgbS2sF2fcUyMwlglFcY
   6r31TCYb/JXmnbhU/d5/SU1eszZ7F51o0Nvef0a+D5v7fYOXYvqfVav1a
   lGE2qXI8FJwBPyV6ggcB/BPumOJ0WxWpX6HEjOjMF/UUBVNmwkx9f6no+
   /hIPDBlrM/LgDsQFZo2aPfVFkx4P9JQfJZ4205iWPfnQCsZPN9u2yjqxH
   mnyI+IJ+hiygj67/4JxMBziz+zsS2n9oEvE/EVVcgACut5iggttEW8t7V
   w==;
IronPort-SDR: Dc4EEbKkZG9iT6AwWAaU+cEHspkW82w2O5TR0E7Eue0C4GRdXGopp4SqxeeVGi3Wf3HsrqVl6I
 sUmgx144Q/lT0tujuezp+g43GpjJgJKr2Sagz4ngbSEYjuFvQVPOS9KSbGfuDirvRDMetULjNY
 +LoBMINB1AVqdtofpK7pr29YKtWJ8LvOXBaP9GNTt8q4Lfq/Qz1BjyotVCwL8oL6ZWQ5u1yYY4
 wbjRe+w7wD1gey6N+jK3ACvkOth85Ai/mXeuYGK8pURjw0dvwurGQqtXAzgmRmUbBjUERoltf6
 jyo=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="142275728"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 16:27:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsLQ40pXUS0MBSLDOsPQMnkl4nw6fS6RjJJs2w9vX7NKdscs1qPSs3gla44avh9knhhoUK7oYhg2lHejesP6ozYhk6wmzASmiN/Y712i2jt2NYjSRPbQoSriWuXuBNYFGBmR2mpFKprf/wNovxk6M7pFFJBCBifMxWcZ1ub7lCU6zMWreGrV9Yt0BU5GR6CSdO9cCPfyNWVjvoa4bof6SLSF88w0gOSKemUDOrs/pFtZjmnVgHBBjrQQhzIYG4KR+gn9gCSQE/xCWiZUO5tRi+EfthB7YoMIpjikRS6/VOrdJxypj+DFUJF9S65w+Vp/t1zILrHVA2Ox1C6ZpTpeiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Go9DdSsvSMZSR0poGFn0mPwQ99RnOtDZN8D/ROo49U=;
 b=YxAExDlW7l23lbdnD2AakOMkQK7h6BJboK8HILvN011LKjudRUGeLhSjqAmWrtXxY/PANLazJid9srykdWLcFqu1kWBqfinhphqQRQ6wB0ezgOcp69Z8yaBds2H7KNiDiim3Psq6XyjR9FBSOxw6nrIy89wiQVqE2DC7bK3QuURakR3uHyer/rS3CBLJWKUN1xNadU5uPplfQH62yGOkh597v/ypllRI/uz/gqnqeCM26HV0Tgnzel1WYR4MzgF1foZdIXQXMB9i246TgwhlP+7iHGAgml1LFln/ZxBfPaw9OWO5XBUdsgNu8OJfi6oIAu3KNTKn+0enja0KBszypA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Go9DdSsvSMZSR0poGFn0mPwQ99RnOtDZN8D/ROo49U=;
 b=sEt7q+Htfh9NtMc0S0Jvm5HqU4PliG0HpzqRCHe69qWx0l0jpCrVbb3iwPOK1OF8iYOIcf5RxSJs3mxQZMGj5FaQDWZxTH8uTRkmQwGV1szTAQRzqNyNvD6u+S2I1oPjVxSJRITFAWDXXFYJ9+ZgeZ8RO3fYyKY0kXCw4rW6fYc=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0461.namprd04.prod.outlook.com (2603:10b6:3:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Fri, 10 Jul
 2020 08:27:48 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 08:27:48 +0000
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
Subject: [PATCH v13 14/17] RISC-V: KVM: Implement ONE REG interface for FP registers
Date:   Fri, 10 Jul 2020 13:55:45 +0530
Message-Id: <20200710082548.123180-15-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710082548.123180-1-anup.patel@wdc.com>
References: <20200710082548.123180-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::21) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 08:27:43 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 658f91f7-582e-4cef-0fc5-08d824ab20b7
X-MS-TrafficTypeDiagnostic: DM5PR04MB0461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB04613DBEBDAF52D9FB06F03E8D650@DM5PR04MB0461.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5TSIfCb3X9xzBFDsTQLDeFsGhiTnubN+e1sU1PM0U/Ae/wNbOXdk17QxUJ03XJZV2LN1hUnOJ+dTn34QPyKUOmxFi+imjvOPLYvpHqA69pIQG3SPvtPJQgbo7T5+W9ubKkfKMuDhm5a/cLiY7QXIy53+oopTtL7PAaduITzRzemZKIoGALdpp5ykLYvglLbheC46F+klScSqhV5J4RVr7hpbQ6bcyMdSqMDcg9lI2SJ6/BTZVuAnplouWf5wtUR1hbJ/TF4zpJv8YjSkXw9KZoyL+BFAFepsnAWl6TrBIVlrttjhjEYmFLM5yl2RtF/zQ+dskL2GSko2zU4CNkmYog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(316002)(110136005)(54906003)(7416002)(478600001)(86362001)(8936002)(5660300002)(7696005)(4326008)(2616005)(26005)(956004)(52116002)(8886007)(8676002)(186003)(66946007)(66476007)(55016002)(36756003)(66556008)(44832011)(16526019)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: mhFp4fKQ/QitMGfL75DEgBEcaPbp+VepcVmdaw2wCNp6d2DSwqFc+BqRxEKr0eznnSiPIccCrEGyp0pRKZIBK2igToETYcVq0GDaydLaIBB9EFWB/WFwIdRsSUgCH0CjykDAw9Xh9ghqeZAoRXCmYR96y8Cvd7t2Gub3KXNBS6sVnPlgk3RaujhQpil2aiOfoaQDN3hxYSS0Il77g3VxuLTruTaPcTLDe3VA95TlZQbcQdAanrXsRtAVMRL9RFzdVOooCFkUQFNTWSCYEjmOI91pK8g6JRqznh+TOrOubYgl66bxl8uj43OnldGkDR3FDNmoui6Budw2vb6PHxwXBtyST32EOV4FassU4IttwevyWvDvmlx5wVikL6vEXnMyIa8xdKlIZ6s/9EAbtYiUg7/JT/xPt6BD4FvntbbGHdo1w7dJKZPTq5Dp/LiL6dNIIVdYLCr68oXMc2+dImchsw3pKp0gxHfZ1Zp1q/o5pNA=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658f91f7-582e-4cef-0fc5-08d824ab20b7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 08:27:48.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFl+JzcA4ZoGzOxgDPgAHu6xWfFKuNZVOGzbc/NjITvOmVdFr+XxhRxq5Y6macVzV88rzpjT7wzgmD9EcONsbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0461
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
index 8c35775c0722..96605f773933 100644
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

