Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03D33D6E72
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235775AbhG0F5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:57:22 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:33799 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbhG0F4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365384; x=1658901384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=yyrEO9d/5c+YBhKziR0pj+P553lQA1zDvHwRrj9lKi0=;
  b=qeZg+9AcHTzt5fzoLKe3wWFWqvIJ/o4K0Q2X0uuMTIKTmx+i4MC3EXhO
   FWSFJsiF7wbKkba35YRzGgMgejnytwMwofxofRX1I03udN/UcJSjpv/rP
   A0OY2nnfDVhgCJunUQI4FEyku31AYdAgne3G4RCQG4MOJGgu7hhlgiqDJ
   KremmGQtz9Hf559s5csfYak612c84FtJcrBIsNXngbbddFMGdf6vQHpjD
   vl7TMA9HgHAhK5mrykSXA5pQY9AJ0qOzW8XVhnGk8NDc0T7tIscYg3dtZ
   to50qkMRbrhoIapbY0CQoBIzSLRSiAsGN1UzOAzobSylbgp3SGjvAuqNc
   w==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="287130043"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:56:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVo0udeYJBt7urMxwZ9I/HuFMx3nKk5jCeQfGj49SVIAIcawLRdWD5AlxNggKURyDgnF/REljgxC1mzHJAC9tXa4nKyfatI2Tk81EN4hME6paRyec6l6aKugWiTRuONJnHAl+z82s23EMro++9DIUlV752VKXjAi5nZ5YEFTRzJosQh/rqbRw5HqwIYjz2T7uYfRga1Cn/pKb/fumyW7QLPUMpWn++jM7U1H+A9UGIboh3ETW04+HFdsSK/3p2oJkXyjpTD/Zx4R9RzCwkzb0wuNmWKoy2LwWxscNwnTquGBboSf+M6RVo8+XQ1Q3dlVk1aA8tL0hHjYCrCQ80qZ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTC6b7FHUiALN8AEc/37yB5lHMHBwVUR2sn+obvr7is=;
 b=bCZHOSlQ4Gfbp8chxkPBtqbXbmD9V+vkbJMybvHnWxm+09Lw4zHHX7Hs9YMoTZKcY+5uqlKKtCVTPmFLGi0nTBmwdtdrrftSluBUTd5b49JJIs/eQUrir2cQJDrwBouWx63zygbNG1Rze+oaVdody3xxpCmeE2LjYeXm9DLpWUXQk3ifAw0IEJj2kkvbfyNc0F4STE+vuuuksVkihDtWqLz/Z9tWpwu29ZNj7CxT/oehYg5AD888PmwgmE61m9UadZ/QhMKhD6ldbIQ2qe+PxgluJs4SzN7AqSiRcwLEFmBrvgIgWDgczR82IOeBVP5XKjVXwSP0yHk8hr3bzEmIZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTC6b7FHUiALN8AEc/37yB5lHMHBwVUR2sn+obvr7is=;
 b=DK4RRMixVd5aK0iFPk47U+ZTRxQU0nERy1tY57AaGvUAsove/IKXAzR0F+NYCZWg8BZr5TdmMG4nioel+/h3FMsTrFOwKIXal/pwq9Lg+T8t7HyEuFMXeM0h2EtkW8k5SUYLIkKGFSv6OrUm7TyA/jzv0+Q6jr8BbjHHK9hL7kg=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8284.namprd04.prod.outlook.com (2603:10b6:303:153::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 05:56:22 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:56:22 +0000
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
Subject: [PATCH v19 15/17] RISC-V: KVM: Add SBI v0.1 support
Date:   Tue, 27 Jul 2021 11:24:48 +0530
Message-Id: <20210727055450.2742868-16-anup.patel@wdc.com>
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
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:56:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6817c93b-7bc8-41ad-bfb4-08d950c342e6
X-MS-TrafficTypeDiagnostic: CO1PR04MB8284:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB8284C11D058FD5F8541BD9FF8DE99@CO1PR04MB8284.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: slzr5dSOJ09rpHtUaNiRwFglIOkG57kO1l6QHm9FY7SITieOD6QQx/UgzDqRRrQ1+TMVIwUFVJUqdH3C4ITlEetH2PPCaHEQ/lU0et6iddpmmzibB3TfUkcYx4f6VchskYIkajGK5TQTXwdxe9pNF+wQmkl4qPrb6ht1VJAJAoNQm+IfNex92FW8KtwhzGfheaLjXsp7v0Vivv7COeWSORHq/8OYPCgr6msN8QZLzULnnk+vugv/ilDE3c8FIjbAZy1rlBGMXy4KVXC5mDpO1qZ91CoEoi4BZ9n6M7n6aTPZWh7xJzMBy3wXjzABXQ3N76+2G0YItrYNL0WSQtztu6LS0K2kVlvbJzuKkgPM92VOwgrCE2+AZr2DWjOSi6OTo3RDI9uaYXFIgguec0re+VOUvTLPuzw3dq8sIepYbl6q+XZ/ENaJnyauao2JnMBXXrvm77WvR9O5dkDLQn3L2mh0pgMQEMaiJtY7+kbObtIhWAF9MPa9pdyfYnY9Q/LqWL0+rvrZMK4e3yFsNJTkKI38uSX+x9MjlBpI0dW2WIsvuEw04THmn5I0CbW77jzzcWtxnLiCPdQMD/3gEibCycYZd3LznYZq1l6nlYLIPu7NWtWXgAksoJ6WUKV0gHBjXWvecev0zXuO46y/HvxoRSx60y2NIZxp4ulzYuw4mSTHQyWkQdSJ7xCmofF0CA18qu/xv4jE+6v94TwtB796NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(66946007)(66476007)(66556008)(956004)(478600001)(38100700002)(38350700002)(26005)(54906003)(55016002)(36756003)(110136005)(1076003)(2616005)(5660300002)(2906002)(8676002)(6666004)(44832011)(83380400001)(4326008)(7416002)(8886007)(316002)(86362001)(186003)(52116002)(7696005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+XKhIp+Npjfi5cYSLpBU+pon1ZetYfWw993T4HV4dxgtLffDXAEJlvtk26Mt?=
 =?us-ascii?Q?uv85L1k8viuaFllKRI8oCTDDrLQX4d9yGwqb1+tMR7x/uHyv74n3xWmEbCuc?=
 =?us-ascii?Q?AXfuMFTwkAGcmx9CWVD8DF8Fuh2AlCT3GhjzmBEthKizxvrsec09ZlGLhTey?=
 =?us-ascii?Q?eY2pR0b/f7yf8h1M00wEKidqwrJ/MNaHfwcz02kb4/6PAh5PaUVO7PWc1v5U?=
 =?us-ascii?Q?1UVVhAKw9z2lCjK+AU5T+LNHkBQEt+tfijG9TXmJPBXQ34wAxJNbZiLuPtmg?=
 =?us-ascii?Q?Mmr9qj/ylN4kB10uv0jtNdsfFueT1I3y81h5B52V8US6jq/ZxzKjcyYcBYdV?=
 =?us-ascii?Q?TC12qlUzTp34rfHh7gDiS4OcKjxbgyyqr0XWuQwF5o1wlpAbSXGZhq5KGBhu?=
 =?us-ascii?Q?/7l8U9p2k364JFi9u+5nCCHWQ6aTbCLG2ci+trIts59AFCrBhXUovyNj1dM/?=
 =?us-ascii?Q?G+eqTdbKpihUD8KwlXGk+5EcH4Ljzw2+27HEooSfedvpTr92g+8km8eeKS9+?=
 =?us-ascii?Q?0PJEZHoAFwxvBRAhTTnf6edTQlgpDDWN2y3WyTFD9IdPKPyGUNP/qT+q7U84?=
 =?us-ascii?Q?aYkQFbl4BSC+T0nlBzPZYcyxaWOPEBvIw8KUGWwZlFtdgCKuMqWVa4hjTKed?=
 =?us-ascii?Q?c7BaQWrWIH3Pezxp9NRb1413hhNZjGtM79UCjk7IPIaIJQbYJ0M8rn9zxrRj?=
 =?us-ascii?Q?zzFyGYu8FW+MNPx/3yvaw8sqKfdnmtN2s3A/PSMhzZ/nNXwVqWKKHu0V3Kku?=
 =?us-ascii?Q?iOzI54Kt+h8n0JvVJZcR/uUM0HEho5c5eQv6cUQXU4vCNCS+Got68BCg5PlV?=
 =?us-ascii?Q?hM5iNgFBkglyIS4tZMLDACD7nczOeAvwWmpjhMVZz6k3OFTk9zluuEpLdUeY?=
 =?us-ascii?Q?zGOQ+gkfhN+zviXtCbYWWvwjGxSK2MVoVLJNFEMfHpQCOvWmzEsDix8w+0ga?=
 =?us-ascii?Q?SlyMD6+pMtKJx8OfXwSFlshGn/Ww5ggEQ7Cpwf5X63AMlaVaTZw75VhcbfdO?=
 =?us-ascii?Q?atoHQO0lBxKSTN9blvesoe+OKLx1U5XERV6ZxOV/7P/GhVWVa22nwdtt17OQ?=
 =?us-ascii?Q?F6lXrLDBdtxaNxt2vAVIDLSmj/CsQJihpnb0taMM/BE55be4Qh3DrUMqRvMR?=
 =?us-ascii?Q?3TX1BKxkCrBnHInXvup1KHi6o0cQSTrWCtPNnL8DpYyYFjX4SJfpMgkZi7SE?=
 =?us-ascii?Q?kbnQel97u7W85tgU3dEavtpaIoDfcZe45EC2ds9a1jU0FBZ8OIEQG96NTQ4X?=
 =?us-ascii?Q?yrpXqiKkrvhEU6bR+Em9gBGkrw3OxtASe0pF1A59MDC2rOSYy7reLwE79nhV?=
 =?us-ascii?Q?uwOgB0W5x42dWRR9H8tdAT3M?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6817c93b-7bc8-41ad-bfb4-08d950c342e6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:56:22.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JrL14fOksy2x3mTdh7oQDf4tCQs36vxWz8l7FiWitE/bG0p7pef6rLM6mbJVRUeKrzsh9ei5lruZyMbVbwfew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8284
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
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/vcpu.c             |   9 ++
 arch/riscv/kvm/vcpu_exit.c        |   4 +
 arch/riscv/kvm/vcpu_sbi.c         | 173 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   8 ++
 6 files changed, 205 insertions(+)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 99b43229fe7a..d948e17bd59b 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -74,6 +74,10 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+struct kvm_sbi_context {
+	int return_handled;
+};
+
 #define KVM_MMU_PAGE_CACHE_NR_OBJS	32
 
 struct kvm_mmu_page_cache {
@@ -186,6 +190,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* SBI context */
+	struct kvm_sbi_context sbi_context;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_page_cache mmu_page_cache;
 
@@ -253,4 +260,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4beb4e277e96..3226696b8340 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -21,4 +21,5 @@ kvm-y += mmu.o
 kvm-y += vcpu.o
 kvm-y += vcpu_exit.o
 kvm-y += vcpu_switch.o
+kvm-y += vcpu_sbi.o
 kvm-y += vcpu_timer.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 333d84015047..98adf112ed31 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -872,6 +872,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
index 1873b8c35101..6d4e98e2ad6f 100644
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
index d9e4aabcb31a..8b0f50ca0a4f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -269,6 +269,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_RISCV_SBI        35
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -469,6 +470,13 @@ struct kvm_run {
 		} msr;
 		/* KVM_EXIT_XEN */
 		struct kvm_xen_exit xen;
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

