Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8E538858D
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353141AbhESDjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:39:18 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58342 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353224AbhESDix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395453; x=1652931453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6AwjqQ7dESTZD/QWerjieBVW+t2zT9KSb13ePdZ/fW0=;
  b=Q/AaBMYWlkmC2uy+N3wtqbH/XMqRTzk6G02iyNeaanhVcUo9r3qtE1p7
   CxXyAF0FOx34hulRJitnoSxXOA+3G2MNpQ3UqDqWkO9DKAMOhIcHO0L7E
   Hp104+zFpbpBHnNxCxTSa9MMlpD2aSASyEFHw3HrRRzmrqEiCNq/UqIMq
   RkQI5gwuv+v9SY87/lrJE61jcQDdRc2TXyrKjBjpm+5PJYsEKMyUFOgva
   0GPZgIR3reqDMH3wOrzqsGT+196U4wuMY94R2ndJwg0H9kmmnGbJvV4c1
   1ZjZmjiK7hpR6Duq+Jjjluw3jGhNxpzlUe3ivbHdvXrJENAD8z+dmn3Or
   A==;
IronPort-SDR: /EQWqdqaKiDhrSzl6SYKNg0ZFleyiXR7D4oMhQLPtWbVG5p45RNCO2N4Pb2U5n0K0q953abs0O
 tvlNKMPuZbdjw0K8kmradLyQX1nwclHW+UdodWL6iRuAMfDLSXAM/5SwgrBXqEjiepewTgNvMV
 SHUm6GZFs8219dHPqztcEDJ9PNPl0LuY9WHipw1p9pBXjhzWKH5jwk0myJr3FHyeJf3LI7Offf
 ofiC1jm6hzv8fdfh3ufg52lmqDX9dZ48BV+NOTNS2lKQcd84yf7JFb9MwNKMxqJWG6Lrh/QS9L
 XBI=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="168652870"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Znhx/jQGIY0ObmA7XVkUwgwTFh/uXw7S3vZb4lxWbl0l30judgKZWufMsUgARxVepLX+rFBOWtWb13CBhsV3fvDtUNqMkP0L/4v4F3xN6Ot0utaTKe1hQ/8G7Plb5UkKRCy9i2eXmRDhf++d4eOYcPyhlvIOGnKs2w7SlYB4nS3wls4n6A3zRi4NwlzPKP7m1Cle3SjLVa7tnNvQszhFqj0jXPkDE2h+QscEe8pjdMZplERtgrF2MUKQ5lFJRoT5pCpG7FTSd1vhGXI8pGe8yIf8uYXNPw0HpIQCETctK6r9uqgURGhU69T7q/gctVkxx8oGoTGpymFguMpbmqs51Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtYHyuK9ed9r6R6VCOmVcBcDNYA6rm3ZbOODFAvP+/M=;
 b=N7gL0Y7F28TJiDFOaVB+IWwDv6aLscQwfg9h+jxtanVBFnMDhnHXF5/f+s/wfyz8iRUx6Mfbttw+g7MoNlFl15HDSt2F8X2UlxzL9hMhP1JIpSh5KmhsP0lTsGbuvlPmK2Pb+xTs+wOf+P7lVP4HpG8ORJtjGeqqXtIOTxYTBKvooO6z5tFz6UnLqwS75xxgYkMqwBI02kgGOk4mYVcjKeuKvE//Mw5RWOSxzD+ozplipIOIbJSCB7nKtkpuBnaIqxbZOeNZRk6VbOzKG7R6e7wDHE/uKWMzeKMd7X9l/y49CAt6dSOZAVX1wcGZu7ePg3Fp1u6Hwc9MCAQdwzGT6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtYHyuK9ed9r6R6VCOmVcBcDNYA6rm3ZbOODFAvP+/M=;
 b=NWnSeW7tspobO0MDY3WIjif98IWqziVr5uj9p3GWF2WPR6nXD0zXvPySFiLuJO2DiqG9BU7swOTeCIlNKHg1/f3cPVkpxT52k+O84GBWAeKEOb7dfO/ivwqEY1cezGFRjlrvjeUnl4ELGSOWC8wI9sK/lmK3cIQZHq66KQSr7zI=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7745.namprd04.prod.outlook.com (2603:10b6:5:35a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 19 May
 2021 03:37:32 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:32 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 15/18] RISC-V: KVM: Add SBI v0.1 support
Date:   Wed, 19 May 2021 09:05:50 +0530
Message-Id: <20210519033553.1110536-16-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41998c90-22cf-461c-a6b7-08d91a776f34
X-MS-TrafficTypeDiagnostic: CO6PR04MB7745:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7745265B7A1E22E6A2439C068D2B9@CO6PR04MB7745.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEZasBKiAxlR/jbA1UX2iSxh9H7eQl4ApXXGdYxVTZ66kcxit+bAuvo8JQAq6NlWJS8K4+m2xnyztaNifbmHGuCu8Owx4067BxXU3a5Ra6A2HFKYbw/lkN++PYFPz+5ISTVym6bFDEqhihZyHYi2Kt8O7Qjswlw7N9nlVzxgPk/2yJ6QzQyS06p0UiOmFLaLhFX41hXWnGWdklYiLbnNxu1O4sOxWiNLmKq9q4k23NQNZSKq3r6zbkLpgrtQiuNb3p2CKYKcu6nXeqGQXwPsTlCRQUH+pqxTfiNbTNoiirp9IiRylhd3ZLmlP2OzcfgT3YR71Tc/Bn2K2U5S+n4kzExvV7CWItz+64VM+jOZr4LknC8InQOmDIV8rI3m+60htGMou3+exxC3YXsTs7mzi7lVoF5yZlsKoothd/1FwR0Czm4d1M5sZZUpEIatZuYPYX0Xr7G7XYTet68bg/AK10AQ3RLasNRiv8/GE2Vqs8iQUzii59pDB+Dy0bkfnbKMKbtlbIZ4uXXAzG3mpyOA9fmeEf+CFr/P5LEsQuiry/jEY985XCPPMiKCWc0a7Mf68dTYtP00pQC7pEUqAfsgsPdJa+PsMRXBWEyqeH7ilFSShy6czKWZ2fFKqGmd8V7+lvZnFvXuXWL6Ov8lIcE1zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(7416002)(1076003)(66946007)(478600001)(2906002)(186003)(956004)(2616005)(26005)(16526019)(36756003)(8676002)(44832011)(6666004)(55016002)(7696005)(52116002)(8886007)(86362001)(38350700002)(66476007)(4326008)(54906003)(5660300002)(110136005)(83380400001)(66556008)(316002)(38100700002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KMJUf+A6L4RQfoZa2fgCPVTKarQXcVm5ECB+xmSWtz/VO4cTbQGGFeehAttX?=
 =?us-ascii?Q?XuOgvpR6S/kU9Rq5gFOo1OD2kPkxuwbjAufxnobR+L1YECV2y5UCaV55nyAy?=
 =?us-ascii?Q?MvTJTYGe42q1h93JUQNhP0bC+6thNF7VW6G/4UxpRjyeqA5En8cmNNQRDe9+?=
 =?us-ascii?Q?8wQvucOl2o7oqYD/EKX/DItwcJoZ4NLA4sTG7ZC2J637PwpXHyDJ5+K50ZXC?=
 =?us-ascii?Q?SLcs2Tlxtoe8+JBRyCbrkoNsCEquztEqe2jE9+/q4fYsaMyVz1x/pooX3qZT?=
 =?us-ascii?Q?SsIu6bOgF1hvwe2KW+XDeMJdo5L0suzcuQXEyjvkgzEGA7REpC75jtzKb98e?=
 =?us-ascii?Q?DbaKFcyx/QtUF4kzCvRs7NgHvwbhte2+ybMNX9UQZwX4QFhZ/VXX3nOqC3Dg?=
 =?us-ascii?Q?vqys1jze9iik/OVG9fnCaLxSC8m9PS/Q3nlF5dUjNaLoi+IAB36ofa6hRARV?=
 =?us-ascii?Q?ijVQ9cWH5tYR9tC3NCn3dnX8jIVf5w3FBvwOHZ6NPJG4WgpyExQvP1VhpZ9z?=
 =?us-ascii?Q?kfBO1vqqIShj9l0++ZkVpL0WHYcnLJ7zaP2W6nwJYnBOrPHa+q973bgIQ6+r?=
 =?us-ascii?Q?WqNcCLoohdmnFL13wYIguQC97Vg5ILbnHZRGUuLAkak2tSFMzOAYEkdRyw6t?=
 =?us-ascii?Q?BrHTbK//H6FDd2t2YvTPvDr7kQb0WDXq9/YTiY0l9RQltSILRv/c7HJXyE8l?=
 =?us-ascii?Q?0Sy6DjLemYuYNb4sVd0I/9D30lwudCN3WJhvouzMG3EQhhYrklCycydyPzy8?=
 =?us-ascii?Q?lBlBOrx7Cq0rqux3qoliwRD73+KskZPhgyLQMtnapBhHvdWIuUUV1LrvUf3Z?=
 =?us-ascii?Q?84n+OuK/RQRaecp0RPTBQUBqmJcDnRTnQ/L5P6XUzS11bn0+saa/c/n27Nub?=
 =?us-ascii?Q?V580J8/nd3SQMsOcDTuGq2rO0Y77HQ9oTb2ipKniectyG+8j0lUnLpjiTCQ7?=
 =?us-ascii?Q?Czr2Id3I1fdBQyReX9ey865l+LwLG68+mRdY9ZxmxPOLXy1RUInKBivpcrrv?=
 =?us-ascii?Q?nAeizadbecezjixWhS3hQ7SL3SNIgEaKoI9nYr2qh3SDbldPScpmXLI0B4/H?=
 =?us-ascii?Q?6zrLmEo/rVc4l0xaJcwrY1o1ieZHGDB4On06wQpm+ViYPDsTJP00xeyl3jed?=
 =?us-ascii?Q?v2iI2xS/WtO6f82E2z6B0oXFF3h+1cd2Lc9UwVDMYbE2vcTa3Xfprid23gtQ?=
 =?us-ascii?Q?IX4UR/lbFzHiFGKRdMNtJAOCLO6qMwf8s2tbvnQG5xIWk59jEppXWnet49Mv?=
 =?us-ascii?Q?vlfKSxUXv5qc7+Ye6xeQqiA2gknDzAyGaOC8C/nYazcg9dvIhoRqf/NbBKxi?=
 =?us-ascii?Q?flvPmPDR3XLsFDFSistu3Q1m?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41998c90-22cf-461c-a6b7-08d91a776f34
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:31.9972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFTZMCTiepHZt+hotY4KCBL7IVen44iQA44oJZqJfqrhnA13GHbxtra6w2edfqRZKok7ZB035PL3EpWY7MYr0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7745
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
index 834c6986cc2d..29cbdccfa65d 100644
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
 
@@ -258,4 +265,7 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 
+int kvm_riscv_vcpu_sbi_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 4f90443ab1ef..938584254aad 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -10,7 +10,7 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
 
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 7119158b370f..fe028d977745 100644
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
index 34d9bd9da585..6a97db14b7b2 100644
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
index 000000000000..a5f7da5f33c8
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
+#include <asm/kvm_csr.h>
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
index 3fd9a7e9d90c..ed5fd5863361 100644
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

