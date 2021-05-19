Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D1B38857F
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353196AbhESDik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:38:40 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:13957 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbhESDi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395430; x=1652931430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=OsDEKE+NgOSt6iUo1xufigzqrWQDPgy81WXCeYaFl30=;
  b=Pi8fUooGm972AKIJBDiYJCN2UHcTS9+/WOx6WSfvPV87RQDOGz92VXHJ
   FwnAFUVk2nFiPW4NIlJCSxtWNn4MhzopJgK8HyDaiadXDAMAgh8Ka8ygb
   lBP6XImZGvYffZPlsE50KutdzC2Rw1SRJ7oV4SIKgQBJzMg+3ZtFPKvwm
   bcAHV7sQpaqN1qonPdAeoYhLT4AZ2Db+1oBNoDaIA/b/aQY5n7rMCS8U3
   BdVtC4wq88JdjuEGFd1eWu25b2eLqpCsnOQNflOiG5Eq9DSWc+/iGLdhM
   QHiNpfCO5Y/lI7CD3FKzxadZqwl7haJ64QtStY3RTw0ZFyr2xszPUSUZ0
   Q==;
IronPort-SDR: kvFpT944G0VFye6MJVNqjNg72dZ6iSEaOMbhWid436B/AXzn4tTu4Y0slxAh1sginzJzZEyYTv
 q2oRIKbXy4cVbsK2N6I0kG6ZfRKgs7Po6mjErgOEmEVfEZRQH469fB7t1gXsbFdBekpMK6/Wax
 Q1BkynM73HXaInwClcPr1FSUaDVCVzSkd8UY8QnUkQ2LqQj7VYOZkmcFGuS1G+tkEr+vdmbN7t
 skhK2KDbGnf6HB2+AEdPg9CUYMayDvkrNR9FpRtwyc5IzHbwfgrRSS05KjCFPEDaAYYXfO9oBM
 PQs=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="272597267"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:37:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbfwxSQKUpxf6f+CgUspg+/Y+fM7jj7oPyB1P/s9EmZZlKNypTalQ5f50weCe524w0iqTg9j0mUfOYNfM4nwtXA1DwM7M9cyCS0mPxpob44zTEhFdm+PybOQzg0pYMwNXo1BftP2CwIRR0fbAoXa/KGLEMgFmAdrKT3Ri+MfxgTGU7d0cybyfcQTnQZ/5p4lauv8NUCAkj/fV6vcp+9yYsVHEHZznIbHLsIS4lyet5i7r5vjangk8uOJbsLvXAK6kNsONMfbMesdSi9kucjKl/FQ2j9o11p7wwyrzQYL+saHJvBUPFBgx7DTxSXy2vxt38EaXNCoS6i1zTyTDJk8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/He+kn3tNeeHjL6mC5pGHnGDNcmJrouh4qLYFCsxzeU=;
 b=RUiNiogZTfT+vUqIYqeERr1DAqqB0YCUNiitO50nX0fWVLzncMqdf1sNfClpsCePDGjPVv2pLQBhGzsvuyjamyprMtCWP+ufFtPN3OeQE9gdJMFtDts0XIlfes3HeUo3/Rinqgb9gG6hEUevVIgDbvNBGx5UhToKRIUZmlLcZKjaoqC/Sc87LKLxMGYwHjioY7ZtfsGeOKG56hJmon1qTaL8hzNDwii7N4rpAzScL9A8Eqww/IspZJi39O/IQ1PquRIl3HuPrZdMA4X3qjGmQUnnr7CdlgUxnieLaphX5mC3vff2BJ3cMIvhMTzy5gUpgHf5Qtf01PHDsyWxZshRIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/He+kn3tNeeHjL6mC5pGHnGDNcmJrouh4qLYFCsxzeU=;
 b=K38GjHPRQBeCh4If0ErbJ2Vwc+ZvBDOCNZ7/Qqnm8df0o1fI2ugtDo+xuJKpr4rw5kNM84Sr1F/l1xRQ0TxmfIKL+wHKuCg11gQMeJmxURoKCcThsgIcKAgUJVBOxXT7mHjdrj2e1iKujUNqj2X16J6kedKhOlNCVj3TseWhDK8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:37:07 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:37:07 +0000
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
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>,
        Yifei Jiang <jiangyifei@huawei.com>
Subject: [PATCH v18 10/18] RISC-V: KVM: Implement stage2 page table programming
Date:   Wed, 19 May 2021 09:05:45 +0530
Message-Id: <20210519033553.1110536-11-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:37:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e56a099-7865-4128-b940-08d91a776047
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7761D331CB5EE6569722CB2A8D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksMbGQv0rWmWKa55nDwRVsim0Njbsb578MpxSyCEUDzWtdc1zDflKsjgAbl1ddDdTq8CyA3dFPWjR8JExorKxbQVyPSYpjCaMfcuHglMeerFklwf/HclWrrRk/nsnyNwUxA7mFNZQQui8wd9E17G/eVbTSJn9cm3kfIIIUs0RaWqrL55oxXmNMv0ZnrmV+sSiQ5bBh3BGKCQxyrvYbicEIgw8VwYkC0OK4EHyVXUyKSC5FMvho7S8yUjtUsv+UWsbL/x8aVdBA0vw3ZyLFNLOpoVyPCdNNMY0ft7JlEK609G5nB58Sg3wr7juUNpoyv/K9W/Yz9siTYPGaZ5AprShHQpwYuSpRKhtRm6RVENgnINprbFPLk7HxNU1PFyV0mq5dtqEtsPEWw1EQ9eBlN9KKgr3xDZCRec/yK0L0O3+wQHJv2XQ1tPm6xYbIf3OtaQFlxNk1uob5Mor6xxyPMKs74UXvxmHm6z/qPUN+jWpYeNBr6LKjSAanPqKl8aqeG/BcuSwKFgfuz/1mQD8BreyHFZe+8i2PQZq2w518ZLRU/8g89mAipWb2NKYHlqbVFR2bcK8kFx+WUPt/+LprkMnmIcdMdY1zAwBLEf/I+wh1uB29X0vRc5s6kMSq6UCSVoTH3Zvn88nZCVrjIk6qQCIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(6666004)(66556008)(36756003)(30864003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?320KZjPQMlXMYsgRlI4GhFxXYZr+oVbWLxLpRa7bkiefw9TPDWfHnSXHgSop?=
 =?us-ascii?Q?rJhTHiEAxsERimnO6IYY1niWoJfmty69CcymXK0GumNF2Xp6tI8gIOKOdnXj?=
 =?us-ascii?Q?bvp1Qq19EBgfnjK3O5L7Pf+ZlLYHq1I0iN2l0GUgTLTnsmJ2DzOFfjY1Von3?=
 =?us-ascii?Q?gaw5E/WXqWJb9OKYivbiZKoY1RTMQBjTe9+NorrP9ldLw0oqrW7DaUf4Qev4?=
 =?us-ascii?Q?Dw8pfIredzyGWFWvpwAdl0po4jUy80PTn6zj0+CXCTPDJ9ptH181IRElHZ1R?=
 =?us-ascii?Q?SrnjgTrkY8K481AIFo+Yi6ofEoUzQaEOAsFf9rvQPj7qNOdUTE1slh0bGkwD?=
 =?us-ascii?Q?NwGT96B4+a7w6fILQQ7QUzWWR+hDJonMq9uDYXi/sTR2bzkRa3FpWUoAeEUw?=
 =?us-ascii?Q?ut6rqdJCFRHKtZogEDASltRunD2UR2DVVu7ImIelCyPmLQHSw6Q2XHyl/oXV?=
 =?us-ascii?Q?F2dk9Y90yTbPBW/9gl/EtTrkb5Oo/Xqq1dvUPyIGuX0R+p9wUR/q80UMzv2C?=
 =?us-ascii?Q?94Rhn0kVprWmMjWyy1oHn3mNb0D/kkb/o8hEbn07k6kcwwtZsDtHjcsOmiz4?=
 =?us-ascii?Q?mLuXFP+9XRMhhVWSvrGvb6vT/HdLhnV/0yBTH1akR3dNB5Enj7tJTSsx8z3A?=
 =?us-ascii?Q?fZOsHa1x74WaKsXa69EBbScWB8BTAxJQ8KilQvvA6YM24wdNQUMd+PcBhuh4?=
 =?us-ascii?Q?zCWXOcAR/8LyEaHollNy6XxLyJ6stCPIYeYFs35m7wjuZ9SqawbUFywWVL16?=
 =?us-ascii?Q?jyRz9G4F/8OBjWnh7OWVzAb31qIiAdxVG5IDM40AOM/sXHJI/duGfiw8SL7t?=
 =?us-ascii?Q?QIF8MHVgsIczDUC0AOoAsvTY1CwyJa4RQJUzkoc6pnTWEsrsdTYEAdjrkzt+?=
 =?us-ascii?Q?Is+tIgs2g3A9kbFh+yB1GYWXuN8w3I2wez1ylcJEq9isEMKfCVo4OeM+huPb?=
 =?us-ascii?Q?PbeR8Dgatl8h7g5kriRj60EEvmWjtotrAwfLuLtu1Wq2PzkLDPHmra1ER2+o?=
 =?us-ascii?Q?KqS17gBCrCMCCWryYpD3i9a7Nw9fCVslrLhSlQc8vZTW8BxbeIk+6/vTDRkm?=
 =?us-ascii?Q?csi4q4/JX/FPsp4lwUVRQGEgAVr9K6sgHFR+GY3xllW4K9Nz/g1GN2KK164r?=
 =?us-ascii?Q?FvIEZeMQtxcpQJLBHpQAe/viwbH3adRTPpc/boQ9LgeITGyr5amJBUK90eXJ?=
 =?us-ascii?Q?gob+P08Au69BcPHGEdAhLFIyb8Q3W9v9E/75VexgBxDoy2Fe4aTkMOehCIdj?=
 =?us-ascii?Q?vzfGj9qJ2FYeKydJ1JOXvi3nVpQ/+SHar1UAwlN1yslqbymd2SSWk3r1Ejy3?=
 =?us-ascii?Q?tlbMAZgeAIeStjf1c0S9wDai?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e56a099-7865-4128-b940-08d91a776047
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:37:07.1575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Q72tOWv+CNBuN5NiW7SKFcrC6t7oRYGq25tXOdsrXyb6FVntsymqIMmvJk0P2M4BpWFsmYKOhq0iJj4GG8Mkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements all required functions for programming
the stage2 page table for each Guest/VM.

At high-level, the flow of stage2 related functions is similar
from KVM ARM/ARM64 implementation but the stage2 page table
format is quite different for KVM RISC-V.

[jiangyifei: stage2 dirty log support]
Signed-off-by: Yifei Jiang <jiangyifei@huawei.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h |  12 +
 arch/riscv/kvm/Kconfig            |   1 +
 arch/riscv/kvm/main.c             |  19 +
 arch/riscv/kvm/mmu.c              | 654 +++++++++++++++++++++++++++++-
 arch/riscv/kvm/vm.c               |   6 -
 5 files changed, 676 insertions(+), 16 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 40449ab2916d..d2a7d299d67c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -75,6 +75,13 @@ struct kvm_mmio_decode {
 	int return_handled;
 };
 
+#define KVM_MMU_PAGE_CACHE_NR_OBJS	32
+
+struct kvm_mmu_page_cache {
+	int nobjs;
+	void *objects[KVM_MMU_PAGE_CACHE_NR_OBJS];
+};
+
 struct kvm_cpu_trap {
 	unsigned long sepc;
 	unsigned long scause;
@@ -176,6 +183,9 @@ struct kvm_vcpu_arch {
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
+	/* Cache pages needed to program page tables with spinlock held */
+	struct kvm_mmu_page_cache mmu_page_cache;
+
 	/* VCPU power-off state */
 	bool power_off;
 
@@ -203,6 +213,8 @@ void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
+void kvm_riscv_stage2_mode_detect(void);
+unsigned long kvm_riscv_stage2_mode(void);
 
 void kvm_riscv_stage2_vmid_detect(void);
 unsigned long kvm_riscv_stage2_vmid_bits(void);
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index b42979f84042..633063edaee8 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -23,6 +23,7 @@ config KVM
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	select KVM_MMIO
+	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select HAVE_KVM_VCPU_ASYNC_IOCTL
 	select HAVE_KVM_EVENTFD
 	select SRCU
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 998110227d1e..2860cb7b348d 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -64,6 +64,8 @@ void kvm_arch_hardware_disable(void)
 
 int kvm_arch_init(void *opaque)
 {
+	const char *str;
+
 	if (!riscv_isa_extension_available(NULL, h)) {
 		kvm_info("hypervisor extension not available\n");
 		return -ENODEV;
@@ -79,10 +81,27 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	kvm_riscv_stage2_mode_detect();
+
 	kvm_riscv_stage2_vmid_detect();
 
 	kvm_info("hypervisor extension available\n");
 
+	switch (kvm_riscv_stage2_mode()) {
+	case HGATP_MODE_SV32X4:
+		str = "Sv32x4";
+		break;
+	case HGATP_MODE_SV39X4:
+		str = "Sv39x4";
+		break;
+	case HGATP_MODE_SV48X4:
+		str = "Sv48x4";
+		break;
+	default:
+		return -ENODEV;
+	}
+	kvm_info("using %s G-stage page table format\n", str);
+
 	kvm_info("VMID %ld bits available\n", kvm_riscv_stage2_vmid_bits());
 
 	return 0;
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 8ec10ef861e7..fcf9967f4b29 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -15,13 +15,421 @@
 #include <linux/vmalloc.h>
 #include <linux/kvm_host.h>
 #include <linux/sched/signal.h>
+#include <asm/kvm_csr.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/sbi.h>
+
+#ifdef CONFIG_64BIT
+static unsigned long stage2_mode = (HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
+static unsigned long stage2_pgd_levels = 3;
+#define stage2_index_bits	9
+#else
+static unsigned long stage2_mode = (HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
+static unsigned long stage2_pgd_levels = 2;
+#define stage2_index_bits	10
+#endif
+
+#define stage2_pgd_xbits	2
+#define stage2_pgd_size	(1UL << (HGATP_PAGE_SHIFT + stage2_pgd_xbits))
+#define stage2_gpa_bits	(HGATP_PAGE_SHIFT + \
+			 (stage2_pgd_levels * stage2_index_bits) + \
+			 stage2_pgd_xbits)
+#define stage2_gpa_size	((gpa_t)(1ULL << stage2_gpa_bits))
+
+#define stage2_pte_leaf(__ptep)	\
+	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
+
+static inline unsigned long stage2_pte_index(gpa_t addr, u32 level)
+{
+	unsigned long mask;
+	unsigned long shift = HGATP_PAGE_SHIFT + (stage2_index_bits * level);
+
+	if (level == (stage2_pgd_levels - 1))
+		mask = (PTRS_PER_PTE * (1UL << stage2_pgd_xbits)) - 1;
+	else
+		mask = PTRS_PER_PTE - 1;
+
+	return (addr >> shift) & mask;
+}
+
+static inline unsigned long stage2_pte_page_vaddr(pte_t pte)
+{
+	return (unsigned long)pfn_to_virt(pte_val(pte) >> _PAGE_PFN_SHIFT);
+}
+
+static int stage2_page_size_to_level(unsigned long page_size, u32 *out_level)
+{
+	u32 i;
+	unsigned long psz = 1UL << 12;
+
+	for (i = 0; i < stage2_pgd_levels; i++) {
+		if (page_size == (psz << (i * stage2_index_bits))) {
+			*out_level = i;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+static int stage2_level_to_page_size(u32 level, unsigned long *out_pgsize)
+{
+	if (stage2_pgd_levels < level)
+		return -EINVAL;
+
+	*out_pgsize = 1UL << (12 + (level * stage2_index_bits));
+
+	return 0;
+}
+
+static int stage2_cache_topup(struct kvm_mmu_page_cache *pcache,
+			      int min, int max)
+{
+	void *page;
+
+	BUG_ON(max > KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (pcache->nobjs >= min)
+		return 0;
+	while (pcache->nobjs < max) {
+		page = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return -ENOMEM;
+		pcache->objects[pcache->nobjs++] = page;
+	}
+
+	return 0;
+}
+
+static void stage2_cache_flush(struct kvm_mmu_page_cache *pcache)
+{
+	while (pcache && pcache->nobjs)
+		free_page((unsigned long)pcache->objects[--pcache->nobjs]);
+}
+
+static void *stage2_cache_alloc(struct kvm_mmu_page_cache *pcache)
+{
+	void *p;
+
+	if (!pcache)
+		return NULL;
+
+	BUG_ON(!pcache->nobjs);
+	p = pcache->objects[--pcache->nobjs];
+
+	return p;
+}
+
+static bool stage2_get_leaf_entry(struct kvm *kvm, gpa_t addr,
+				  pte_t **ptepp, u32 *ptep_level)
+{
+	pte_t *ptep;
+	u32 current_level = stage2_pgd_levels - 1;
+
+	*ptep_level = current_level;
+	ptep = (pte_t *)kvm->arch.pgd;
+	ptep = &ptep[stage2_pte_index(addr, current_level)];
+	while (ptep && pte_val(*ptep)) {
+		if (stage2_pte_leaf(ptep)) {
+			*ptep_level = current_level;
+			*ptepp = ptep;
+			return true;
+		}
+
+		if (current_level) {
+			current_level--;
+			*ptep_level = current_level;
+			ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+			ptep = &ptep[stage2_pte_index(addr, current_level)];
+		} else {
+			ptep = NULL;
+		}
+	}
+
+	return false;
+}
+
+static void stage2_remote_tlb_flush(struct kvm *kvm, u32 level, gpa_t addr)
+{
+	struct cpumask hmask;
+	unsigned long size = PAGE_SIZE;
+	struct kvm_vmid *vmid = &kvm->arch.vmid;
+
+	if (stage2_level_to_page_size(level, &size))
+		return;
+	addr &= ~(size - 1);
+
+	/*
+	 * TODO: Instead of cpu_online_mask, we should only target CPUs
+	 * where the Guest/VM is running.
+	 */
+	preempt_disable();
+	riscv_cpuid_to_hartid_mask(cpu_online_mask, &hmask);
+	sbi_remote_hfence_gvma_vmid(cpumask_bits(&hmask), addr, size,
+				    READ_ONCE(vmid->vmid));
+	preempt_enable();
+}
+
+static int stage2_set_pte(struct kvm *kvm, u32 level,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t addr, const pte_t *new_pte)
+{
+	u32 current_level = stage2_pgd_levels - 1;
+	pte_t *next_ptep = (pte_t *)kvm->arch.pgd;
+	pte_t *ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+
+	if (current_level < level)
+		return -EINVAL;
+
+	while (current_level != level) {
+		if (stage2_pte_leaf(ptep))
+			return -EEXIST;
+
+		if (!pte_val(*ptep)) {
+			next_ptep = stage2_cache_alloc(pcache);
+			if (!next_ptep)
+				return -ENOMEM;
+			*ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
+					__pgprot(_PAGE_TABLE));
+		} else {
+			if (stage2_pte_leaf(ptep))
+				return -EEXIST;
+			next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+		}
+
+		current_level--;
+		ptep = &next_ptep[stage2_pte_index(addr, current_level)];
+	}
+
+	*ptep = *new_pte;
+	if (stage2_pte_leaf(ptep))
+		stage2_remote_tlb_flush(kvm, current_level, addr);
+
+	return 0;
+}
+
+static int stage2_map_page(struct kvm *kvm,
+			   struct kvm_mmu_page_cache *pcache,
+			   gpa_t gpa, phys_addr_t hpa,
+			   unsigned long page_size,
+			   bool page_rdonly, bool page_exec)
+{
+	int ret;
+	u32 level = 0;
+	pte_t new_pte;
+	pgprot_t prot;
+
+	ret = stage2_page_size_to_level(page_size, &level);
+	if (ret)
+		return ret;
+
+	/*
+	 * A RISC-V implementation can choose to either:
+	 * 1) Update 'A' and 'D' PTE bits in hardware
+	 * 2) Generate page fault when 'A' and/or 'D' bits are not set
+	 *    PTE so that software can update these bits.
+	 *
+	 * We support both options mentioned above. To achieve this, we
+	 * always set 'A' and 'D' PTE bits at time of creating stage2
+	 * mapping. To support KVM dirty page logging with both options
+	 * mentioned above, we will write-protect stage2 PTEs to track
+	 * dirty pages.
+	 */
+
+	if (page_exec) {
+		if (page_rdonly)
+			prot = PAGE_READ_EXEC;
+		else
+			prot = PAGE_WRITE_EXEC;
+	} else {
+		if (page_rdonly)
+			prot = PAGE_READ;
+		else
+			prot = PAGE_WRITE;
+	}
+	new_pte = pfn_pte(PFN_DOWN(hpa), prot);
+	new_pte = pte_mkdirty(new_pte);
+
+	return stage2_set_pte(kvm, level, pcache, gpa, &new_pte);
+}
+
+enum stage2_op {
+	STAGE2_OP_NOP = 0,	/* Nothing */
+	STAGE2_OP_CLEAR,	/* Clear/Unmap */
+	STAGE2_OP_WP,		/* Write-protect */
+};
+
+static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
+			  pte_t *ptep, u32 ptep_level, enum stage2_op op)
+{
+	int i, ret;
+	pte_t *next_ptep;
+	u32 next_ptep_level;
+	unsigned long next_page_size, page_size;
+
+	ret = stage2_level_to_page_size(ptep_level, &page_size);
+	if (ret)
+		return;
+
+	BUG_ON(addr & (page_size - 1));
+
+	if (!pte_val(*ptep))
+		return;
+
+	if (ptep_level && !stage2_pte_leaf(ptep)) {
+		next_ptep = (pte_t *)stage2_pte_page_vaddr(*ptep);
+		next_ptep_level = ptep_level - 1;
+		ret = stage2_level_to_page_size(next_ptep_level,
+						&next_page_size);
+		if (ret)
+			return;
+
+		if (op == STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			stage2_op_pte(kvm, addr + i * next_page_size,
+					&next_ptep[i], next_ptep_level, op);
+		if (op == STAGE2_OP_CLEAR)
+			put_page(virt_to_page(next_ptep));
+	} else {
+		if (op == STAGE2_OP_CLEAR)
+			set_pte(ptep, __pte(0));
+		else if (op == STAGE2_OP_WP)
+			set_pte(ptep, __pte(pte_val(*ptep) & ~_PAGE_WRITE));
+		stage2_remote_tlb_flush(kvm, ptep_level, addr);
+	}
+}
+
+static void stage2_unmap_range(struct kvm *kvm, gpa_t start, gpa_t size)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	unsigned long page_size;
+	gpa_t addr = start, end = start + size;
+
+	while (addr < end) {
+		found_leaf = stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_CLEAR);
+
+next:
+		addr += page_size;
+	}
+}
+
+static void stage2_wp_range(struct kvm *kvm, gpa_t start, gpa_t end)
+{
+	int ret;
+	pte_t *ptep;
+	u32 ptep_level;
+	bool found_leaf;
+	gpa_t addr = start;
+	unsigned long page_size;
+
+	while (addr < end) {
+		found_leaf = stage2_get_leaf_entry(kvm, addr,
+						   &ptep, &ptep_level);
+		ret = stage2_level_to_page_size(ptep_level, &page_size);
+		if (ret)
+			break;
+
+		if (!found_leaf)
+			goto next;
+
+		if (!(addr & (page_size - 1)) && ((end - addr) >= page_size))
+			stage2_op_pte(kvm, addr, ptep,
+				      ptep_level, STAGE2_OP_WP);
+
+next:
+		addr += page_size;
+	}
+}
+
+static void stage2_wp_memory_region(struct kvm *kvm, int slot)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
+	phys_addr_t start = memslot->base_gfn << PAGE_SHIFT;
+	phys_addr_t end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	spin_lock(&kvm->mmu_lock);
+	stage2_wp_range(kvm, start, end);
+	spin_unlock(&kvm->mmu_lock);
+	kvm_flush_remote_tlbs(kvm);
+}
+
+static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
+			  unsigned long size, bool writable)
+{
+	pte_t pte;
+	int ret = 0;
+	unsigned long pfn;
+	phys_addr_t addr, end;
+	struct kvm_mmu_page_cache pcache = { 0, };
+
+	end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
+	pfn = __phys_to_pfn(hpa);
+
+	for (addr = gpa; addr < end; addr += PAGE_SIZE) {
+		pte = pfn_pte(pfn, PAGE_KERNEL);
+
+		if (!writable)
+			pte = pte_wrprotect(pte);
+
+		ret = stage2_cache_topup(&pcache,
+					 stage2_pgd_levels,
+					 KVM_MMU_PAGE_CACHE_NR_OBJS);
+		if (ret)
+			goto out;
+
+		spin_lock(&kvm->mmu_lock);
+		ret = stage2_set_pte(kvm, 0, &pcache, addr, &pte);
+		spin_unlock(&kvm->mmu_lock);
+		if (ret)
+			goto out;
+
+		pfn++;
+	}
+
+out:
+	stage2_cache_flush(&pcache);
+	return ret;
+
+}
+
+void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
+					     struct kvm_memory_slot *slot,
+					     gfn_t gfn_offset,
+					     unsigned long mask)
+{
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+
+	stage2_wp_range(kvm, start, end);
+}
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 }
 
+void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
+					const struct kvm_memory_slot *memslot)
+{
+	kvm_flush_remote_tlbs(kvm);
+}
+
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
 {
 }
@@ -32,7 +440,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
-	/* TODO: */
+	kvm_riscv_stage2_free_pgd(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
@@ -46,7 +454,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_memory_slot *new,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
+	/*
+	 * At this point memslot has been committed and there is an
+	 * allocated dirty_bitmap[], dirty pages will be tracked while
+	 * the memory slot is write protected.
+	 */
+	if (change != KVM_MR_DELETE && mem->flags & KVM_MEM_LOG_DIRTY_PAGES)
+		stage2_wp_memory_region(kvm, mem->slot);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -54,35 +468,255 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
-	/* TODO: */
-	return 0;
+	hva_t hva = mem->userspace_addr;
+	hva_t reg_end = hva + mem->memory_size;
+	bool writable = !(mem->flags & KVM_MEM_READONLY);
+	int ret = 0;
+
+	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
+			change != KVM_MR_FLAGS_ONLY)
+		return 0;
+
+	/*
+	 * Prevent userspace from creating a memory region outside of the GPA
+	 * space addressable by the KVM guest GPA space.
+	 */
+	if ((memslot->base_gfn + memslot->npages) >=
+	    (stage2_gpa_size >> PAGE_SHIFT))
+		return -EFAULT;
+
+	mmap_read_lock(current->mm);
+
+	/*
+	 * A memory region could potentially cover multiple VMAs, and
+	 * any holes between them, so iterate over all of them to find
+	 * out if we can map any of them right now.
+	 *
+	 *     +--------------------------------------------+
+	 * +---------------+----------------+   +----------------+
+	 * |   : VMA 1     |      VMA 2     |   |    VMA 3  :    |
+	 * +---------------+----------------+   +----------------+
+	 *     |               memory region                |
+	 *     +--------------------------------------------+
+	 */
+	do {
+		struct vm_area_struct *vma = find_vma(current->mm, hva);
+		hva_t vm_start, vm_end;
+
+		if (!vma || vma->vm_start >= reg_end)
+			break;
+
+		/*
+		 * Mapping a read-only VMA is only allowed if the
+		 * memory region is configured as read-only.
+		 */
+		if (writable && !(vma->vm_flags & VM_WRITE)) {
+			ret = -EPERM;
+			break;
+		}
+
+		/* Take the intersection of this VMA with the memory region */
+		vm_start = max(hva, vma->vm_start);
+		vm_end = min(reg_end, vma->vm_end);
+
+		if (vma->vm_flags & VM_PFNMAP) {
+			gpa_t gpa = mem->guest_phys_addr +
+				    (vm_start - mem->userspace_addr);
+			phys_addr_t pa;
+
+			pa = (phys_addr_t)vma->vm_pgoff << PAGE_SHIFT;
+			pa += vm_start - vma->vm_start;
+
+			/* IO region dirty page logging not allowed */
+			if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+				ret = -EINVAL;
+				goto out;
+			}
+
+			ret = stage2_ioremap(kvm, gpa, pa,
+					     vm_end - vm_start, writable);
+			if (ret)
+				break;
+		}
+		hva = vm_end;
+	} while (hva < reg_end);
+
+	if (change == KVM_MR_FLAGS_ONLY)
+		goto out;
+
+	spin_lock(&kvm->mmu_lock);
+	if (ret)
+		stage2_unmap_range(kvm, mem->guest_phys_addr,
+				   mem->memory_size);
+	spin_unlock(&kvm->mmu_lock);
+
+out:
+	mmap_read_unlock(current->mm);
+	return ret;
 }
 
 int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 			 struct kvm_memory_slot *memslot,
 			 gpa_t gpa, unsigned long hva, bool is_write)
 {
-	/* TODO: */
-	return 0;
+	int ret;
+	kvm_pfn_t hfn;
+	bool writeable;
+	short vma_pageshift;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	struct vm_area_struct *vma;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page_cache *pcache = &vcpu->arch.mmu_page_cache;
+	bool logging = (memslot->dirty_bitmap &&
+			!(memslot->flags & KVM_MEM_READONLY)) ? true : false;
+	unsigned long vma_pagesize;
+
+	mmap_read_lock(current->mm);
+
+	vma = find_vma_intersection(current->mm, hva, hva + 1);
+	if (unlikely(!vma)) {
+		kvm_err("Failed to find VMA for hva 0x%lx\n", hva);
+		mmap_read_unlock(current->mm);
+		return -EFAULT;
+	}
+
+	if (is_vm_hugetlb_page(vma))
+		vma_pageshift = huge_page_shift(hstate_vma(vma));
+	else
+		vma_pageshift = PAGE_SHIFT;
+	vma_pagesize = 1ULL << vma_pageshift;
+	if (logging || (vma->vm_flags & VM_PFNMAP))
+		vma_pagesize = PAGE_SIZE;
+
+	if (vma_pagesize == PMD_SIZE || vma_pagesize == PGDIR_SIZE)
+		gfn = (gpa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
+
+	mmap_read_unlock(current->mm);
+
+	if (vma_pagesize != PGDIR_SIZE &&
+	    vma_pagesize != PMD_SIZE &&
+	    vma_pagesize != PAGE_SIZE) {
+		kvm_err("Invalid VMA page size 0x%lx\n", vma_pagesize);
+		return -EFAULT;
+	}
+
+	/* We need minimum second+third level pages */
+	ret = stage2_cache_topup(pcache, stage2_pgd_levels,
+				 KVM_MMU_PAGE_CACHE_NR_OBJS);
+	if (ret) {
+		kvm_err("Failed to topup stage2 cache\n");
+		return ret;
+	}
+
+	hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
+	if (hfn == KVM_PFN_ERR_HWPOISON) {
+		send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
+				vma_pageshift, current);
+		return 0;
+	}
+	if (is_error_noslot_pfn(hfn))
+		return -EFAULT;
+
+	/*
+	 * If logging is active then we allow writable pages only
+	 * for write faults.
+	 */
+	if (logging && !is_write)
+		writeable = false;
+
+	spin_lock(&kvm->mmu_lock);
+
+	if (writeable) {
+		kvm_set_pfn_dirty(hfn);
+		mark_page_dirty(kvm, gfn);
+		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, false, true);
+	} else {
+		ret = stage2_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
+				      vma_pagesize, true, true);
+	}
+
+	if (ret)
+		kvm_err("Failed to map in stage2\n");
+
+	spin_unlock(&kvm->mmu_lock);
+	kvm_set_pfn_accessed(hfn);
+	kvm_release_pfn_clean(hfn);
+	return ret;
 }
 
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	stage2_cache_flush(&vcpu->arch.mmu_page_cache);
 }
 
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	struct page *pgd_page;
+
+	if (kvm->arch.pgd != NULL) {
+		kvm_err("kvm_arch already initialized?\n");
+		return -EINVAL;
+	}
+
+	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				get_order(stage2_pgd_size));
+	if (!pgd_page)
+		return -ENOMEM;
+	kvm->arch.pgd = page_to_virt(pgd_page);
+	kvm->arch.pgd_phys = page_to_phys(pgd_page);
+
 	return 0;
 }
 
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 {
-	/* TODO: */
+	void *pgd = NULL;
+
+	spin_lock(&kvm->mmu_lock);
+	if (kvm->arch.pgd) {
+		stage2_unmap_range(kvm, 0UL, stage2_gpa_size);
+		pgd = READ_ONCE(kvm->arch.pgd);
+		kvm->arch.pgd = NULL;
+		kvm->arch.pgd_phys = 0;
+	}
+	spin_unlock(&kvm->mmu_lock);
+
+	if (pgd)
+		free_pages((unsigned long)pgd, get_order(stage2_pgd_size));
 }
 
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	unsigned long hgatp = stage2_mode;
+	struct kvm_arch *k = &vcpu->kvm->arch;
+
+	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) &
+		 HGATP_VMID_MASK;
+	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
+
+	csr_write(CSR_HGATP, hgatp);
+
+	if (!kvm_riscv_stage2_vmid_bits())
+		__kvm_riscv_hfence_gvma_all();
+}
+
+void kvm_riscv_stage2_mode_detect(void)
+{
+#ifdef CONFIG_64BIT
+	/* Try Sv48x4 stage2 mode */
+	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
+	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
+		stage2_mode = (HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
+		stage2_pgd_levels = 4;
+	}
+	csr_write(CSR_HGATP, 0);
+
+	__kvm_riscv_hfence_gvma_all();
+#endif
+}
+
+unsigned long kvm_riscv_stage2_mode(void)
+{
+	return stage2_mode >> HGATP_MODE_SHIFT;
 }
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 282d67617229..6cde69a82252 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -12,12 +12,6 @@
 #include <linux/uaccess.h>
 #include <linux/kvm_host.h>
 
-int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
-{
-	/* TODO: To be added later. */
-	return -EOPNOTSUPP;
-}
-
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	int r;
-- 
2.25.1

