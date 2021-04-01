Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939BD351B57
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbhDASHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:50 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24190 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237444AbhDASDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300223; x=1648836223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=I/wX95OwMFckb2QEJZVP/gqMf4+Jr4ICjcdTO339L9c=;
  b=iYXJVJbcTG8Ig7FbKbVuCpaoe9fLtyJg8q9FxYXxX8zBXIOVUea/7d9c
   4ydjHJqcTWwUB1E40E2KxayRMbmzuOK14M+REIewuynMfJrT02k3auCb1
   CZv5+q3o5yCsY73/7YBw2NK8MkbgYLzKdSb41dIwmvRfr/Xj6kudJZc5y
   fznb8mYf3NipxFt4Dx9hfuoHwGexlJnrNZTNbO4JkUtuQiQj/pw+mkdJ/
   VinUF+OEU9TZa0kEt0C5IUQCDjbvjfERgR1ZbeTcPeTXzEXCTiVsdtpXI
   ZddpuEJkUjhq6wwydiYuwlrnV6BaoEqT3TNZL1tAREeoWDEVA8QiTT2Sc
   Q==;
IronPort-SDR: JjNBCXQh6Ezh4xIW4Q9ZXuL+5tk8i7ilvYSjJpIiPjvlJay0ijO5iEhh3+yGW5hecrHPpinJvL
 M+O8oSfUo/DT67HrvBHRPI+Y0Z2UcvoczcM16tuNLdFfxfiDD2ornEpONzNlpk/n98Pa9wwZwG
 Rrf1AOMTk6tBtxfF6euM0uGadYAAS3RnzN9j7J+nxiCUc1xBZnxjSafXjrYR/lrkXcPDuFqzYO
 Fp4GC1W6Q0N45P3i/d0F5WnxZKwX5wOsA0/IlY12rwlOK3Ik0rJse8JyNf7dQEaDSQWOThT8hd
 QB0=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041667"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:39:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSlKnub+lJERXHJXxFQz01q32hV2dRtUzopUzVj6Rhkn5jROz6r7ol/GN0v7MdIUv6iARQyJV5brYtJmW92d6lHhXALoJ5VozOy07mgi7DVBvRrDdO8VReWbCQUOm/GFc+ZcbiuH3LNW9ucfzRPsbqdBt1+fS3ENAbsSQseMHAMZe+TRyFCUDiel080oq4TmGa84nru+TjbIC/tgGFnec0AnH793gnssvRecgCBqXjJ4gA6FfpYcjpeTcokmEfHpwj+OflmIL+xpwAue4X8idi2XZ7CdvDa6Nlk6j8SGGCICNO7CQjyz7usX2eLlID4P/f4W0kjEUA/cfY9gOR4nKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwnWglrjN8OEYofSPsCJqhYotPbPnWmLNZYclYUSlwg=;
 b=US2fMR49gwv7XTomYBXsewL3xBQauv72vNovXJzoMff80bBahBRac4XOYoIzZf9M+S3gWanJ3EzIybI6pCyTzf3oF65cKBPt9WcN9mVuhOAh2bsX/n5nOFcOwy6RFulPAZcfoaur+vOEJDmkvrwA4e9BUAVE9jW66k9ho8R3VLiFgaIT/U6t8Cz8t6S5T/ik+EscOHYoVxPDaFxRgFsUO36a6G54ea5UV13RMQ35820mqERMMdxmJkTj+geArNwS7VWw2lN54q5LPmIN6Aht+0OYS4DJLPPParfmqWTaqeNE+ZO/f4gCukUUeeieBiZb2GEciCjICV+Z0sEcv3PJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iwnWglrjN8OEYofSPsCJqhYotPbPnWmLNZYclYUSlwg=;
 b=TBYKvsaUgdJ7UYW1mupNiVv3Ifjnv/znX955zsq9FyYetAeFo3oirg+5jgQ20s0m9V8W1qmCOEBzG9VMP5PAKWEdO7FnsbwRknQzyYF+pOdMgf3o4qKRg+/dvDvIFvIMIiQOk6V8jR8zJiEUqR29eCKoepUBEa6aZ83iczuqJPY=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR0401MB3624.namprd04.prod.outlook.com (2603:10b6:4:78::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Thu, 1 Apr
 2021 13:39:03 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:39:03 +0000
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
Subject: [PATCH v17 15/17] RISC-V: KVM: Add SBI v0.1 support
Date:   Thu,  1 Apr 2021 19:04:33 +0530
Message-Id: <20210401133435.383959-16-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:38:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a283fe24-439a-4e64-0dae-08d8f51383a9
X-MS-TrafficTypeDiagnostic: DM5PR0401MB3624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR0401MB3624B91F03C1C3B4998E78228D7B9@DM5PR0401MB3624.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57fFXlg+QOMKGG6bjnMefBLjCnTssjpqoaRRkvBJmCeFzLwTgchBDNjL9AxEWZJRdILXRbLkRid+OB05Yp6kmv1ZbStFjpu3ZXF+sAiycoKtACS4g/4bdXz1DUYysFlUbbiJkLpNO3OQRMR/QIvL+2ONjqDBeP4LDLUg2E1F2fSzFr2TU+VpgDMB+gr1divgkN6qTr/nQIHUdaa4bTRJiQdGR4DcAccxmtLCsEDc8HMjTfllJWSxYeXagOle3f/DRF8pjmteJN/EKUrbw2owjvE7do17DyswzzjjAVNd5y8O5pPjzrjiN3c7ePm8SWAXFnt1aBz2YbLQ3zml8z3pGM1zgk9EB1MOghNb3lhcE9XVHmZkngKOjUbECmscHC8WRfZgXTRguAV2NpAcvmXYW31GmALDvYP5TZ/j+xPJ6P5CGwGSk3+D1cKhvkGevg/RM8VJuWacBvEbi4ebODD8mP9mOaAW9VMbbdOKIgSOkgH6BONFHgwzosdjdLc7KORGOJhItVhogYag/oSJBXyqVMDjQ0tlAIq5Zv5gb0kmWsxUKJb/pL5wa4/Q8Nbl2Zo3/qKcWMqQmY9GAFJazOESc3b9dZdyIqiFeLWEDZmRoON+Q+h85Q8iuazOKmPBn82dyc0EdQJbX3azVH7u5Lvc2HIwYM/WZyoEnZgJKIr6pz4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(5660300002)(55016002)(956004)(2616005)(7696005)(83380400001)(8886007)(38100700001)(86362001)(26005)(44832011)(4326008)(7416002)(8676002)(66476007)(66946007)(478600001)(36756003)(1076003)(316002)(54906003)(110136005)(186003)(16526019)(8936002)(6666004)(52116002)(66556008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DF+SfoGRvSbMkGDAtQ8pu/whAokgI7I/OCzVRO31IHSg0qqzWX+Dgsq70p+A?=
 =?us-ascii?Q?bLZ//FOwzLNN6B3jKXBOGoxXkcXUN2rko3L9ric5Zfoq4tdzAvGX7U2Mn9Rd?=
 =?us-ascii?Q?Rdn6GPIqrtHE8I05QW25rEGWtAaQ/8agEQwzSwzNUF3sBDw0l5E/iAwgotU3?=
 =?us-ascii?Q?EHaSYrTpCT+gNAQlSDqoFQi9MiADBNQ944z7ELAIsxk1zHSe2VKGB4Ny1c37?=
 =?us-ascii?Q?v7RoNrUzW7ooVq9UW3ox/SL7nFtFxi3qoggjxbwMApdpA+tnVjI9+F+mkKVA?=
 =?us-ascii?Q?A0K5FshoB2tDhY1eC0k/ikzLhiZ8bUrLDvWMXDzLde8RxTQYER8odLrDfX4z?=
 =?us-ascii?Q?VCd8Le37+2FLg5xRenvQRAaGMg6wk42NvoQt+Y5u2lhyOZsDVsw/W0JmURnK?=
 =?us-ascii?Q?bYpi5rfq6UmNyyWa5fNkeff5+BU6EgN72r/u/Lx/Cnvv4nsrEHwBMxMJew8Q?=
 =?us-ascii?Q?qkLU7fR5uEe2lThrx97GExr1cO6AQ4HHdQW+x7Nzumbm1IhcqQwWuLv1atFh?=
 =?us-ascii?Q?SNnekZnzXeBWSHtbZ97pPseTEux2Mr9ZnGizMDR4YAqaV2irlwjEKebQWsat?=
 =?us-ascii?Q?76LzlFX9ql/qH0G5mHum3Vf5hMOwuyqBowIDm9h4qJFiPUPeiU2CL9AKkLfv?=
 =?us-ascii?Q?O/BU/hDwfIFkJ1jumNcwges0IK4lYCqwyLvLYpNpZARviAxMokUYiO9NUhkr?=
 =?us-ascii?Q?wO1DOKEuPQ+UuSqm68qi4SbaJmXRWX4e54WWsKRr4BFfv9ErOuF+oHlgYsH6?=
 =?us-ascii?Q?h/5HCh8YAaDCNk7KCQqKIPB7zISmM8HpImUTYn6C1upBob/Tgln9Sb7H+8Ee?=
 =?us-ascii?Q?hxzNZDdDT98oZigLB8WkMS1W8Lte66o8PLr7kyc38kJfuEC9O4i487x3Fxob?=
 =?us-ascii?Q?OfvXtTlNZ2ujvOy4W/V1I8ssDHJi3+Mf9gfNVAIoxCczoUEx/MVzfCsagkS2?=
 =?us-ascii?Q?TvPBryhc6tgF0q/zfwjNwAQWta4EfmQuF0p/l6GjExehx/L8tyrKVUKd+Dp2?=
 =?us-ascii?Q?MZmXYuAEAfGsrfktTeLaEHxhNZu1ZYZfrvGPtD7q10T6WmpqecA76Ao89hX9?=
 =?us-ascii?Q?zXpFa4+qV/OEGFAFgqD1XSe6tzxxyh2JSeYEh6QBVjjpfZfb6/pIa84r3/C2?=
 =?us-ascii?Q?XzWvOCCnquRIXa46NviaiXAClQrbiusN5S6EG610RuQPoXH+pTYiASr43G5A?=
 =?us-ascii?Q?5Zbxd7jBvfR//nPY9dvMPN+J1dXMuVzYmZLHXOvudwI8W5Ep8awAx6K20SFb?=
 =?us-ascii?Q?1xPv+LEs8VxZLSC3lwqLhOaw8ieMPa+AQRRCuK2RWdetS9U81XRr7n3wOhdM?=
 =?us-ascii?Q?JEDJKmDLiCaPRbN5L+s9ieGY?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a283fe24-439a-4e64-0dae-08d8f51383a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:39:03.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICAlym26whkr8Fa0YaI/HA3Ngtms2ZRerAGWi4z1T9mQeQslsBK5WiWF8MdMDDhmoGX444rTwPJmv8t5Jw5nig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3624
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
index c6e717087a25..0818705e3c2b 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -79,6 +79,10 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+struct kvm_sbi_context {
+	int return_handled;
+};
+
 #define KVM_MMU_PAGE_CACHE_NR_OBJS	32
 
 struct kvm_mmu_page_cache {
@@ -191,6 +195,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* SBI context */
+	struct kvm_sbi_context sbi_context;
+
 	/* Cache pages needed to program page tables with spinlock held */
 	struct kvm_mmu_page_cache mmu_page_cache;
 
@@ -264,4 +271,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
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
index a797f247db64..2c2c5e078c30 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -867,6 +867,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
index f6afee209620..da0c11c13f5a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -268,6 +268,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_RISCV_SBI        35
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -446,6 +447,13 @@ struct kvm_run {
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

