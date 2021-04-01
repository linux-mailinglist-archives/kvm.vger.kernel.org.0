Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2475D351B3B
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhDASHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:02 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233850AbhDASBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300102; x=1648836102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=74pXqSLILFKG+9b1abxJ5RhZKwhRrtjXjdLy6dCkMcc=;
  b=qZHKhU+gRgmfZY9LD5ZU+6VK9EJ4LY5r/2WmsaBpdJdapx4rpd0cgT/b
   PlCXMVTce6qQ7R7BOnu3rqirety0H29MYilRzj2fFQ6esAYe55S5D8yty
   dZAzqaf3uDEo5i68Mh8q5ytrU4Kp86ApqWEKyCcVFpDG6e15FrW9tmnNL
   J5WpEoMHJdv8+2ZVrR007NtMuA91b8GsyuA50dgJReHiKjRovOZoxXgSv
   g/qMMiy7/RD9nVuxOhikEwoPjYWhZxGiOKf4llwQiwrPRdFhSEjyCwN6Y
   gQ2p8cNtEbc2fwD15iUiQHoxYQw1xWpUx7mUFncgS18ddcHqfLOekl+8l
   g==;
IronPort-SDR: 070u/ukldnEbFRTFSxTObkY6IE9rp+Nw7dhVzzPd/OMEkEqvmJSUajMRpMf4qzboiiZJUb96k8
 PiE2sEo9Luaf8KY71dLI0AdK8mlrf75eBQLty6MKQoYOdMXu1eCXXGAR7RrifFHBTZAmUKlicv
 OJ8Qi7uVsFUNSIRhPZRueSPBpeIzV9z9BA15MXBO9u+8LStxry/S18cV8sZIIdVPEJ/5OOfGNx
 YRQdY4tOu7d6NKzP50jOeg3W17j47zqHRxgkCgDP1cDt89QFyNZmIy7K/u38r2wEPR25CbkMes
 Nqs=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="164582885"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:36:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/XEtjn1IvVDP/gkdrAoBJDccMC8knWLD7BAiHAqa1u9QBATn+lWD6wsz/PHNPfQQUdxK0B4dRgBcCBXbzbn9hrdVLn4GRZfTuEtvoAOL1UJ5mODatwFaGdoNijawbNRnlUnUwfvuYPxS3SiYU7hsWF5mBqjbZ/FFAjabnSV+xIbTRIwqOKzlBARXlSh0H71bjUeizhLujTIqoOF2bw5VMx1ixXiV5A9D36CttI81v3OIg0AKrWXsp8kXCz+ZdumDT9cakq548rcGFbDtoi6J/eho+k19mPlsoTKbzic19KKz3GWbmWFbFDsSrZr0do0Nso2Q+bg/EtQ0Jucq71Tgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OSTiih4v6kUG0tROqEWKYbxFA3/zQ8fQ5XP2StdYb8=;
 b=RLQrNFMyDQRcA9FEED9oWviXTPlrUX0FFLodC9to8f9LSD4yq39DeljNAtEXjHMJz8a7f2MumsIVQa0jnZAujKA3My6NzKHFWau2oOpKSQIDN9UOEGeFHnLnyTZPEnszvvzgrEpeN8fhGghf3rALLI8JFvNYJyZx+2pk+M1OKVckn6MMoXPhwSGEilvTRxukIQxTOE9x7m68HiMlkOpT/xdClsnHU2HfbUQQTq6q2cw9XrZfUIe289llb1okfvOmpZRPzp5bdUcLnYFqUWmdA/Jt+lAt4CFlvH3RTt/wxofJ4qT/5LKdXIUdgLP1e9Fsg6/6nHiHkFwpslILBOfmFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OSTiih4v6kUG0tROqEWKYbxFA3/zQ8fQ5XP2StdYb8=;
 b=u9oRHYfGKlZQ6gPgVDmtYU7XGBGeMbEDNEEL8r/BXy/dZ1lqAaMhtHlQtaY2U5GKJ0U56x2zA9uZPoHOv98Ob8sny5hS6pCtR5eWP652VQIYhKPyX7FZV4VGSM3ZMoS0YZ8NxR1tJ2mL4KbntAsf3YuuE4R+Cuq6TRiGH2pgA9k=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6528.namprd04.prod.outlook.com (2603:10b6:5:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 1 Apr
 2021 13:36:28 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:36:28 +0000
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
Subject: [PATCH v17 05/17] RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
Date:   Thu,  1 Apr 2021 19:04:23 +0530
Message-Id: <20210401133435.383959-6-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401133435.383959-1-anup.patel@wdc.com>
References: <20210401133435.383959-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:36:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5df00aa7-c774-4ef6-750c-08d8f5132715
X-MS-TrafficTypeDiagnostic: DM6PR04MB6528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB652892EA960796C81D44E00A8D7B9@DM6PR04MB6528.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: htRLQJDxorGlNOOrDUjldWZuiiBiZf86cbllm7ujRG5asWLqVRocMIMq5C0Txv83cLVuH/FB1aCg0gTzGHqj2OMhmjg31XpRYxppzGvZXsGwutpXrRzQYRnIDEaHUxLWnIr4YTx2+7Eg0WPEEkQOZYHLQI979eIpSnqi6UjUah8H7sPc2EKEuD25UfVCqHaWlj6+NnG6bHAR6TO8swIMwLgofMgrBCFtvkdsurwBtUdx3zRCvEDlmbYN6SkJrkMBmRUFf70/unFQBO3VVmcP3hVuC45GCLd5Wj+dFqH0fJzwJfGO6CgBFndb8JUVOtvrSt2sXLKDIDBklTbnLxYVtDMVJxPRxBqikucZYTUmfiYeOCH518r3ghmHdT90Lj3lMUmHBY2BxrR6huc31XQgXoHuQ1k/clBCoxci9TztMOr3iLXTm+jWxa/lctgUOTUWCyDzZA9ma3gihS4Dd1LdZFS+EUkQhA00cF9sSCGC//YqnIB0muOIDmJogfBpMGxfecPO2j14ZNEkJsBhdaIpzJ4AlKvAYRJETcBpdqFS7OWaPESakbNig/5EJmp/7P3aBXlvy5rwp4rNZ40hSQAdr9/sea5IoGQ5Y35BTkBrfRW/+0CRck6dlyPI2uOGlTPYvDu+pWCPtx1YzJ1rs6iUKJWTyYjZ1sovWo7jSgw/gLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(8886007)(16526019)(36756003)(186003)(4326008)(956004)(2616005)(6666004)(316002)(66556008)(478600001)(26005)(66476007)(2906002)(54906003)(7416002)(1076003)(8936002)(55016002)(86362001)(83380400001)(8676002)(52116002)(110136005)(7696005)(5660300002)(38100700001)(30864003)(44832011)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DAYoB3A94wGgUSBE2YTH/vVVSt/IKfDQuiPyQ5yxcEaQnCMsyu13bnJ+qjOU?=
 =?us-ascii?Q?aBHlAu2eNhOYQp1RopuAJwJaE1kOZ74m6+O8gIaQN6qfaXFLN7W0TAqeGEdI?=
 =?us-ascii?Q?8MaUzEZixPPpcVaeL89Z8qAIkgD8y/1ok/eBu6IaGM3eGDwRt+O7kOAdwhT7?=
 =?us-ascii?Q?TBVjHCSgV2LJsS3xajiXjNaayMThkNCRJ5kxcB6IemwDrjfYYrASBJAXKkeS?=
 =?us-ascii?Q?iEZ4l6Zg+9MQQDIn4HkPjT0K3m70h8vcd00BMgUgECDSNq/XuHNCyJkI9qMK?=
 =?us-ascii?Q?DaHq0XpBI55MAttnnGwiWZLCphRx0Xz6DyMvNGrSaosZ/dTlsEh+a+T8AWJ4?=
 =?us-ascii?Q?Q2qXMTG0f70et1KO9POHnaJp3GRZ8xohwoYJrfl+Qn9wASZ08vtr+6eB8bal?=
 =?us-ascii?Q?IwFg0pw9ys3fmkTnFyNr74NLG/MhNyP909KHAY1EXSZ/WLFThf05jaALoWPX?=
 =?us-ascii?Q?SK5aOjGBNiX5oS9YomcOf3hXtohdmrQDXe/0IcE6cJcm9MzbsINKz7arTUPl?=
 =?us-ascii?Q?iaCUCxfdv46DS2b3OpdSL6ix6vJ+MlJKck/mu6nm9sedmvGHfI3FO2px+V30?=
 =?us-ascii?Q?uDRags9ysDosc8xgR1yqHIHII9o/vFdI/SauYFivRWuLEDsS2erIskX/kkn8?=
 =?us-ascii?Q?H8GQQIIeldrgbGp69b/zRx1JvIez/suygpGDeVA1aoC4lXaIXOLXrt7l/QLh?=
 =?us-ascii?Q?G6nGQhSVYxplcxioHCR5Pg+Nc1QGMgm8hAmGZvsIMWVij8T0b95btEqOUuDi?=
 =?us-ascii?Q?ZW4D28gtuB1ExkckfhBiLCZ1WTlbOmMa+igYpql/5JKrnAnsgcViEEb4veUo?=
 =?us-ascii?Q?LEm4mKYqaUHazxu9EDkGu/4iWYNm76rYGq8XpFMmVVxBRpVkn2rVsVgygIcH?=
 =?us-ascii?Q?X3BGV2jIMeFgs1SFwkmTxY+HxbD4waVrTb95YzfNJTjWwPztu9jIx0Z6GWDj?=
 =?us-ascii?Q?kZclMJ3ikMCzfMt4U/R06gJK0/W7gZhk4iLyISuH1B5SP/jVJV2YCwEvvoIu?=
 =?us-ascii?Q?YbBXP/n5ytfbUDxwSSa2m4FGnG92LuN5S6rzc8mJo/1PdRXPouJ1vUqb+0/h?=
 =?us-ascii?Q?xipl8N7Fgo9xK8MeD9wM++Vmpo2EyiYPpYXVmjyAC7ihGq3bf3Kwk0z9NDwf?=
 =?us-ascii?Q?sXdXbLbRFHOjn9Q+/kk0mo4pJWzmwZI/N7eRTrlDImsoCcLI80bnjX2XzfQi?=
 =?us-ascii?Q?eX2/K6vbBjM0ILD4MNf/HIkjhY7YDwVoGFCKY7Gk078tnV7nW5YCMORmpk+c?=
 =?us-ascii?Q?k1rglt46UFOCkRd5lr71urAzF+GHZCtAF//m/pKE7Y2VR+G28HYgDJ+W6f4l?=
 =?us-ascii?Q?4RznKhVn7I6PgyNa76xsDjFF2UWCU1bt9E0mITHUbPvV+A=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df00aa7-c774-4ef6-750c-08d8f5132715
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:36:28.3945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4R6ZX41k7x/wYvAi9cGMzgZMJj/lWZ8UPiBTfx5GdIqVOJPM4fPxt1qBmLKtZd1Cdf0fFvglS4dQZhbAUdyuxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6528
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
index ae85a5d9b979..551359c9136c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -18,7 +18,6 @@
 #include <linux/fs.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
-#include <asm/delay.h>
 #include <asm/hwcap.h>
 
 struct kvm_stats_debugfs_item debugfs_entries[] = {
@@ -133,6 +132,225 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
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
@@ -157,8 +375,30 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
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

