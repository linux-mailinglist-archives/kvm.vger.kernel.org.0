Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9562F78B6
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbhAOMVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:21:45 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:36828 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbhAOMVm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:21:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713300; x=1642249300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Q1cDrdJBixByjMYlpAAFRHl+RUI3FLR1BSJqxWQ6YDY=;
  b=RyofNzCFKTcEa/+1VY3bdK4ix+NpLiNg16RzLzAba+CyWwAQYzKMLqKQ
   045UpF1pakgSCAiixhewbYXmQ3z0Xpyprcy3xTUY1TUg0ADMR8mNCPaYM
   hJ4U+/3Ri8gjZsk9sLMx64MF2iB2sqAwzvJg8avEENqo1VRdlfNnzBSHS
   w3VVRSpAoVrg2iTvl1jutErtLYo61GNJyyZlNz5Un5CY2Tm9pPWQQ9Ai6
   JDBSvBYtDBhN3GqqHPfk2+0x057fKfBu5oriAbH+FJ57pHdchtt4xmD4P
   f5TAtYkb7pQxVjM7y4WxwCnt0W0tl5C8pJbXOZvv5KULt1ln1x+sXiAxr
   g==;
IronPort-SDR: 3pdJ+e2O+V95oOLliqjhLe1kQG5l+whCMkZA2bYkY4Zy9+qmP62ua6XcAdGlPD8Ur1K3w49693
 iFjGiAfd2f1e6igxL/OIv2qoDi446fOfMHZXIHTryHAsAhmBPLyFjrwHf9Gr5FN6plMYlEqJeb
 3gXzFe+VGLc/hQKimvdy1VP6+CE4f6cGhTJ2UV97WrkHgQKC/VpxE4Lz6vqL/PpBgf3zVywq/O
 bHxAd7njkheN8/Z4sQviRiHjaIh4OnS7ccyP4/hV0yVmgs+km/ZWE7sBVnq+tThMM4LlPbb/5j
 9zo=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="157507147"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:20:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5Q/a3U0H50BkS2s40h4YpUibUi7hOkmCM6VSvtoUn6TmScpQ56wv98uMAn0WRy5Z1DpZy7Gm6fK0dVQt6SZblRGKABYkuYUCR4BLL0mjLeiQ/G8KgO4+U6hO69G4tl+RYQT8m1ZqXxeVVILsd8kuj5QTvtymCJZ24oTfRGGDwMJJLL+AB375k9j8LXOcqxl1KstlpRqDVw8h8YvbGCHDf8jFeengD6K7bltrxgjHpUsACAM3qh3ScNGJesga7La/fEPSpIAA2vhaKCDauDeVF+yVNrePnUeVr6WqeV7uMiEP8pTNHbxFmUzaGb6cj8ecDHtAb+Gh+b49TP7RHrn8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjhSnGNVuhyJPQpHX9OIhAPtM2cJXuNYMzFPoltIfhM=;
 b=l0ASNoiOUfdL5reS77n/39q2glGFXOYhpF3j6iy9uQEO8ZJlM3nBAUSbjw/MZAc4p9uKHIrJnIWwnkaa+gz8DLQgNpkXrxLcDZ+I5OmNK0O8xck1S7fFKcpl6zNFFYXm+G72jMNzD5fpSiQwMw/9289E7zm3BkQDqnYy4gkM4Plx2NprRPueopEs1IRCQUdZfc0AZy0nwDWrEvMZ5p9/iilu83BhtVbVSQPBtvJuxU6DMo6tyjxlJH29xN+I4o6cCpehooharz/awMyCOzG/wSiUt5vsss2CpjG8HS/0QVXlIEwGGOVlzii360vwWVpeh2/recBK3dcpQlugECKALQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjhSnGNVuhyJPQpHX9OIhAPtM2cJXuNYMzFPoltIfhM=;
 b=nl9rOwqIXrSK1pkgUlo1ObrU5p64FBeE8uuMWj+YT41UNZQyst2ik7q4KZgr018Eui4pqQG4A1C6W//7i7Mg/uAqD6WJlqprndAzZJf+uELGRFpW4xLUu1MUbSbfItfJfJ+LVmfGZ/ow48PUxlvq5mQfXJcsjrYcNuHbcyQ/iDo=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4330.namprd04.prod.outlook.com (2603:10b6:5:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 15 Jan
 2021 12:20:33 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:20:33 +0000
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
Subject: [PATCH v16 15/17] RISC-V: KVM: Add SBI v0.1 support
Date:   Fri, 15 Jan 2021 17:48:44 +0530
Message-Id: <20210115121846.114528-16-anup.patel@wdc.com>
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
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:20:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4a489132-acbf-4af2-c061-08d8b94ff466
X-MS-TrafficTypeDiagnostic: DM6PR04MB4330:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4330C5047FF8511945AABBD78DA70@DM6PR04MB4330.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c1BFaIOQN4YMVrZiPn59pzHFl33dCpTqjj3/rJ6YT9zu/jvXw+banX9FAxCL9oKrnNb5GLyjZzHgmaXGzgTirED33pr9jMSBPGEM5Y7GPMyl1hKTr4ZPYAvKdIhgop5pqr7Ipb2fDFNcyHImqiyOLqQYRJ+s1N2X3go2Uac1ne8SIOPxWMLU6miwj2P1/MMj6RgCnJd9qOuLHA4Ai2zwDH5MF6ZDxmrNd/mFNzCVi+2FZw4dH7HaFH02UmB51C/mUn/q280QbuUpg7GVBpH2VlnFDn8fHo3Uhl5q/HjedeNRPK4DYKaStXcTYZEHWs4RHUNS3s7d4BCekAmBS9Pve4XvzUKnqmH12J6AKTN+b0EWSF4qoMduMuicHIhxVJCr147KXKTiU8RPKqct76Sb6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(376002)(366004)(396003)(7416002)(66946007)(316002)(1076003)(66476007)(8936002)(110136005)(186003)(66556008)(86362001)(16526019)(36756003)(44832011)(6666004)(7696005)(4326008)(26005)(52116002)(8676002)(2616005)(478600001)(2906002)(54906003)(956004)(8886007)(55016002)(83380400001)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Gnwq+zH1YuiVQ/KtmlwGcqLkIkwzgZkSyA6c1iY15TzhLhWkzJxlRiIJJhW1?=
 =?us-ascii?Q?X4c4FIIqszRNhkcXGHP2PmOk3eTAPp4GEpU+1RoMaoZtVrQ8xpnxj2LjyoYW?=
 =?us-ascii?Q?uajbt/qt+EkaRkf5ArcTUsVzlcCX9GmINGHTCb5xbYva33hZprnWBgOtwnV2?=
 =?us-ascii?Q?tKFsyOvnb2xWdYQJ2yobCKR7+U1pPDAhrDpW+y3XgAXdmyCE/f8ORpGINpVl?=
 =?us-ascii?Q?W7a/2iBB2BYlDjgec//cTwn+fJhCQmy/xdPZD0aFi48GtFOQwq6vL89G+cX0?=
 =?us-ascii?Q?ELTVSjrOyLQ+7w0cDoFxZ/mZbO7Ph5dRJXweXfMzBUNOtj2Useok44CFLoxb?=
 =?us-ascii?Q?+keFGuXXHoSfRYIiVwwMYmIWxvjeUCRijRCCoPrJIgsHP6GUB1ymMNDbYRME?=
 =?us-ascii?Q?HQLdCiDwW9uRS+g8FK6omY/lOqSJiqzRNQS/Ma+5Ajupd+u2VBu4OBStxU0M?=
 =?us-ascii?Q?JiPJ551wiZwZMiT/Hdi7zrWRQnksfDSMfZQNWSBdrSdd34sAqRSRlT12Tx/o?=
 =?us-ascii?Q?oOldiUOnZwuYTEdTjhr1J0zwC5/xxQSs6Ld2sPj7z/GkEby1OwurnQmPatOd?=
 =?us-ascii?Q?GmuvEpU5AhW9oCAurWk7S7vQ7U8BuUntFBVo04viz6XE3Y1v6mZe/PViKxf1?=
 =?us-ascii?Q?5+99XeFZimnWLhhtTkNwQA8nYzUP4/SPomvrxLEmRabERyoGf96zpyLkVWuv?=
 =?us-ascii?Q?YH6yvyxRBQX0AkLuP5diw+jrR7eRzuRaybk4CMr8z3ibElJeuE83Hqf0Ilfm?=
 =?us-ascii?Q?JXgzJdxG1YesQ67uMolabKQkCJOBmeI9+C4P/yYGyx4R/Ere+733fUgw5cGB?=
 =?us-ascii?Q?2uo5FVpTySkk+zZ0ewi9HZ8Yrm7aR3BF4l2vWiex5OINdI9gu7cGbaEUP1Ux?=
 =?us-ascii?Q?14Xm4W/XwlVglIMOaxIqNLZQuyvluXbSfHotgQJKMncMwcr2gZsvWrPciQDx?=
 =?us-ascii?Q?BZ/59dvmNkDdWwRTL31lraztdKJESWPtpyPR8auk0E7zcEen5NgUymdSiGr2?=
 =?us-ascii?Q?Ul70?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a489132-acbf-4af2-c061-08d8b94ff466
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:20:33.4889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AQWUOq1/XetZgljG6BxCjZ0Io+bCbO0eAPdYEhiIz/4qpJ5YVVO/qGf/uUKYJxhNHj2EdsuedbrOvbYRi1ASvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4330
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The KVM host kernel is running in HS-mode needs so we need to handle
the SBI calls coming from guest kernel running in VS-mode.

This patch adds SBI v0.1 support in KVM RISC-V. Almost all SBI v0.1
calls are implemented in KVM kernel module except GETCHAR and PUTCHART
calls which are forwarded to user space because these calls cannot be
implemented in kernel space. In future, when we implement SBI v0.2 for
Guest, we will forward SBI v0.2 experimental and vendor extension calls
to user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h |  10 ++
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu.c             |   9 ++
 arch/riscv/kvm/vcpu_exit.c        |   4 +
 arch/riscv/kvm/vcpu_sbi.c         | 173 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   8 ++
 6 files changed, 205 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 6d97a8eab206..dc2666b4180b 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -80,6 +80,10 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+struct kvm_sbi_context {
+	int return_handled;
+};
+
 #define KVM_MMU_PAGE_CACHE_NR_OBJS	32
 
 struct kvm_mmu_page_cache {
@@ -192,6 +196,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* SBI context */
+	struct kvm_sbi_context sbi_context;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_page_cache mmu_page_cache;
 
@@ -265,4 +272,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index a034826f9a3f..7cf0015d9142 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -10,6 +10,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 2d8bab65dec9..bcc4af9d2fa9 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -882,6 +882,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	/* Process SBI value returned from user-space */
+	if (run->exit_reason == KVM_EXIT_RISCV_SBI) {
+		ret = kvm_riscv_vcpu_sbi_return(vcpu, vcpu->run);
+		if (ret) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			return ret;
+		}
+	}
+
 	if (run->immediate_exit) {
 		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
 		return -EINTR;
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index bacad80686a2..058cfa168abe 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -678,6 +678,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
 			ret = stage2_page_fault(vcpu, run, trap);
 		break;
+	case EXC_SUPERVISOR_SYSCALL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = kvm_riscv_vcpu_sbi_ecall(vcpu, run);
+		break;
 	default:
 		break;
 	};
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
new file mode 100644
index 000000000000..9d1d25cf217f
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * Copyright (c) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_timer.h>
+
+#define SBI_VERSION_MAJOR			0
+#define SBI_VERSION_MINOR			1
+
+static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
+				    struct kvm_run *run, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off = true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&run->system_event, 0, sizeof(run->system_event));
+	run->system_event.type = type;
+	run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+}
+
+static void kvm_riscv_vcpu_sbi_forward(struct kvm_vcpu *vcpu,
+				       struct kvm_run *run)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	vcpu->arch.sbi_context.return_handled = 0;
+	vcpu->stat.ecall_exit_stat++;
+	run->exit_reason = KVM_EXIT_RISCV_SBI;
+	run->riscv_sbi.extension_id = cp->a7;
+	run->riscv_sbi.function_id = cp->a6;
+	run->riscv_sbi.args[0] = cp->a0;
+	run->riscv_sbi.args[1] = cp->a1;
+	run->riscv_sbi.args[2] = cp->a2;
+	run->riscv_sbi.args[3] = cp->a3;
+	run->riscv_sbi.args[4] = cp->a4;
+	run->riscv_sbi.args[5] = cp->a5;
+	run->riscv_sbi.ret[0] = cp->a0;
+	run->riscv_sbi.ret[1] = cp->a1;
+}
+
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	/* Handle SBI return only once */
+	if (vcpu->arch.sbi_context.return_handled)
+		return 0;
+	vcpu->arch.sbi_context.return_handled = 1;
+
+	/* Update return values */
+	cp->a0 = run->riscv_sbi.ret[0];
+	cp->a1 = run->riscv_sbi.ret[1];
+
+	/* Move to next instruction */
+	vcpu->arch.guest_context.sepc += 4;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	ulong hmask;
+	int i, ret = 1;
+	u64 next_cycle;
+	struct kvm_vcpu *rvcpu;
+	bool next_sepc = true;
+	struct cpumask cm, hm;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_cpu_trap utrap = { 0 };
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+
+	if (!cp)
+		return -EINVAL;
+
+	switch (cp->a7) {
+	case SBI_EXT_0_1_CONSOLE_GETCHAR:
+	case SBI_EXT_0_1_CONSOLE_PUTCHAR:
+		/*
+		 * The CONSOLE_GETCHAR/CONSOLE_PUTCHAR SBI calls cannot be
+		 * handled in kernel so we forward these to user-space
+		 */
+		kvm_riscv_vcpu_sbi_forward(vcpu, run);
+		next_sepc = false;
+		ret = 0;
+		break;
+	case SBI_EXT_0_1_SET_TIMER:
+#if __riscv_xlen == 32
+		next_cycle = ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle = (u64)cp->a0;
+#endif
+		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_EXT_0_1_CLEAR_IPI:
+		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_SOFT);
+		break;
+	case SBI_EXT_0_1_SEND_IPI:
+		if (cp->a0)
+			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   &utrap);
+		else
+			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (utrap.scause) {
+			utrap.sepc = cp->sepc;
+			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+			next_sepc = false;
+			break;
+		}
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
+			kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_VS_SOFT);
+		}
+		break;
+	case SBI_EXT_0_1_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		next_sepc = false;
+		ret = 0;
+		break;
+	case SBI_EXT_0_1_REMOTE_FENCE_I:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
+		if (cp->a0)
+			hmask = kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+							   &utrap);
+		else
+			hmask = (1UL << atomic_read(&kvm->online_vcpus)) - 1;
+		if (utrap.scause) {
+			utrap.sepc = cp->sepc;
+			kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+			next_sepc = false;
+			break;
+		}
+		cpumask_clear(&cm);
+		for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+			rvcpu = kvm_get_vcpu_by_id(vcpu->kvm, i);
+			if (rvcpu->cpu < 0)
+				continue;
+			cpumask_set_cpu(rvcpu->cpu, &cm);
+		}
+		riscv_cpuid_to_hartid_mask(&cm, &hm);
+		if (cp->a7 == SBI_EXT_0_1_REMOTE_FENCE_I)
+			sbi_remote_fence_i(cpumask_bits(&hm));
+		else if (cp->a7 == SBI_EXT_0_1_REMOTE_SFENCE_VMA)
+			sbi_remote_hfence_vvma(cpumask_bits(&hm),
+						cp->a1, cp->a2);
+		else
+			sbi_remote_hfence_vvma_asid(cpumask_bits(&hm),
+						cp->a1, cp->a2, cp->a3);
+		break;
+	default:
+		/* Return error for unsupported SBI calls */
+		cp->a0 = SBI_ERR_NOT_SUPPORTED;
+		break;
+	};
+
+	if (next_sepc)
+		cp->sepc += 4;
+
+	return ret;
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 374c67875cdb..2abb7bc5e2d8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -252,6 +252,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_X86_WRMSR        30
 #define KVM_EXIT_DIRTY_RING_FULL  31
 #define KVM_EXIT_AP_RESET_HOLD    32
+#define KVM_EXIT_RISCV_SBI        33
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -428,6 +429,13 @@ struct kvm_run {
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
 		} msr;
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1

