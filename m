Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C330351B4C
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236601AbhDASH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:27 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:36913 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235931AbhDASCA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300120; x=1648836120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=BQZ1Za9H9U0aUcvgBReFX+tUxwlb3hEC3mtu5JmRPXg=;
  b=MpV37Q7a5Ld2BSVL1LE+5vPtCIukrFg/UcpHGDskSs/VACtEa8/s2suW
   UWDa1EcaVeN7xDJG8xreJDSAcr8kX2S/8NzOQdA/6V9Nhyau2IygeT3/4
   /e4aavXDgRlAJXpGhSE+6p6i7nhd/YGDwUpYXQoJZzd3KnqLjQ/r24Z1F
   f//e6gwKI5YvrFbi6thQ1YsSAfpMpv/DXUHHFKnCUdH2xBFENIWuZHYwa
   HDOr9eliIOuAtFn5jRdpVPvnhMY48jeWJ7WcsE1aiTsVtYnUrUqR2IciE
   DFl8UR2W7nPIi0nR3z2NldKE5DFkku3qa7ZHWOShbqtrp7ltNM7VwYnvg
   w==;
IronPort-SDR: TQPGKOO31WUfhIMg0f6ajoDLzgoAQuw1l318CSD7aRqHLHkQm0LhsggqgxpVQI0l1iQZwpk49d
 rXglqlsZW0lyJeSib5pBK5l3FVQEO9LYJpnLNkbATZiwxxMSankoweciaJk5+wkqXMImzLsYBW
 0D4neoeM80aqppVImFN0fDWdulSVjmuDFUn02YLqFPF5M9cnf6xPfMW1DVNJaSXf//cZoMyj13
 TYt+9Uho5Gz8V6LWqrhpR5U9v/L22ChI0t9xjw+w5Mx3UVckvSHYR+y0kUoTaBk3ZSkEtJ/4NP
 57Q=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="163447790"
Received: from mail-sn1nam04lp2051.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.51])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:42:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/w1J9eAdtbny/nsPTXzFjxgTwgC2fbsrr7Bd3koZeGRi9IIbRczK+RT/wCGTOH0ANN3HOG3iFu1t6u/hbMALW9xHXDwNfTPlARSM6byWiYtAusJyizprkbDzPxI0DIH0LWc9ReJZ9/sstcclkLdpY+XdszrlVgU3ElN35X/Ep3lewf0GpPNNGxf7qwjgwlnxhVegSOj+3Cc6iqud2LCMbw3YWTNlKtVQD+lFrOWiiMpGWrC5xnQ9KLzB9yjdH7yfpB7tF1rX2ZEHJVZZ47Z6ARFiok3vML4h1IU4eDQ9LViLgFJoCkynLvNfMeJ7q8lM3S2WYWDCClCq6G8fCvl3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=oBezosxUk/xShmDer/MoDh2YCYhVrTkYVsxdSB4E1kkGnloVZrfgjLyHTs+p+bkpoOLXW+lsA5aHgyiXTLfY82g2y71742pSQd7sBDlRt6dkNC3Q4aonK22D8AvjMXpmH3IOGyMKcifUmYhgCDSY5daswFlxLLmBmnV9m6p/El7KexoqrZy5PK0iO8zpM55fkVgaMgdx4MUbccQQ2newHpsaGjRbO2eGpSNrM09VxxfjBNwIy+PPtspUP9QVLp7veBpNIoZxnic3CsV3iGcOSDGLyRt2p3RHS9B419HuW0GijVb6CzWBodr+qSPiTOSVbFOyygdHQaCWk9xF4xF/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/IR3wBcbUaY52UvbQXJeYgkLVfOx+Vj1u/MVm22uS1s=;
 b=Nx+lVOuxsTXmD42u87IkaMw46lg/6ajAHt/TZ5+XmIrqsKcaOu3gtEVRCphO//7OXkt71IohrDjLgg98Roo31BuhrC8au+R9eVLA0j7c4+JHJergJ7HeLYss0U0nXCuRb5SLRCQw3ai8a0CfT6ZE1jZqaYXFXnwq/4X4iCtlbT4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6493.namprd04.prod.outlook.com (2603:10b6:5:1bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 13:42:17 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:42:17 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 4/8] riscv: Implement Guest/VM VCPU arch functions
Date:   Thu,  1 Apr 2021 19:10:52 +0530
Message-Id: <20210401134056.384038-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401134056.384038-1-anup.patel@wdc.com>
References: <20210401134056.384038-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::29) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:42:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c53c301-1723-42a2-58d3-08d8f513f741
X-MS-TrafficTypeDiagnostic: DM6PR04MB6493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB64935BF37F6F8AD0C40589158D7B9@DM6PR04MB6493.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZJzVgC5et4O1qooCZ2fx18natMnUU2j0+7IqfNiaKQTtv1uQTKFhgDDKZWcxdvkbqaQG82QeA/VUE1jTeh2Jlt5MO6fkq7vYX4S1WBEdBzsyf2Qd/PGPBop6EAqn8sthk1jUG6NZJaoPjudN1HAneR8wNe7o2petdF1U/uiN4AHQImkqmsqr6DtcOxoSolFjClydiqCmUTH3G6lYEEk8JrwXCgZpMgeF6clHgkvdTrxJc4KpzhrpX4Z7fbDxS0uJiD1p05iB6o/lAkG9iuTfB4aOojni2wQuZXnheXRS7C3u0SXXX/OQ2SiSqwnKuemj0/dIYVYlFSuGPO3P63FtdqNXmt1lP2b5BFguv6lyeJhx3BCWLLswi+6xyAK3disgE9iD93RPD7VahCOeRf04VgM018UGixZ61dpfeTwzGjk8/ahbxTeg+6U757P82Je7nGK4JeQwbBviIou9cF5Jha3mfeb6jlLOzAarV2EqwewYHmbIXm7ZLhSr5OxOkXI21f5Fc2+JbGU20coRJLNhUhwc+U63US60DBpxsze5vvuAISLGrFmIfZjt2YM25y6pH/JMZrIyXWhxTNUayOKen+liyle9EzzEnyqrXW5BB5WDp2TWPNytKKwETZgB25HdwqIrXkkMx9roodnfUIyIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(478600001)(26005)(66476007)(186003)(16526019)(30864003)(8886007)(6916009)(66556008)(8936002)(316002)(66946007)(8676002)(5660300002)(38100700001)(52116002)(7696005)(44832011)(956004)(83380400001)(2906002)(6666004)(54906003)(86362001)(55016002)(2616005)(4326008)(1076003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Sxz4zD9R75UdOZGdx/vG9CyjklDz9iv2LL+51RMU1f0FkFpqJjy8RnRB2z7Q?=
 =?us-ascii?Q?k/B/jtD391RqJG9IKlXSJAlPxSVgZHzZrMXfLoc0+0tSYVyaNCXe6xRpHkOe?=
 =?us-ascii?Q?LARV3nxgbaURtyyEQ6o4xvvmOenBiZCpOYBIO5hbxMXsPFvhnLa2FPRe8cAy?=
 =?us-ascii?Q?qKLi+FFbeFTvI9MgdmRxXX6/Asvg+2G5jS7grlg4EvR9oTZVMh43Mqrz8v/X?=
 =?us-ascii?Q?WkLLHbNCn+cqfmvVc1aovio+0tXI5fPwKTt766vMxEUrYPYYWcEkAEPMioKL?=
 =?us-ascii?Q?79V2fiHyFCHnvhwVVe8Mtz0Zs9HUKAqcG/tzufaihESvX70/O9VetRF+AyO8?=
 =?us-ascii?Q?IzlGhvlqsY3Bod0DPDSIgGZt9nQAGqBYj0k2H1coXz+pILqhKtYXw/fKoZcp?=
 =?us-ascii?Q?2KCHYW8rMCfWA6RuikKq5p0dHiZIE2WttmDec7DIOi3G+x6DeLLanD0axO84?=
 =?us-ascii?Q?1jiLVkV0CyALZ7EBq75PQC4D5MF+dhV/O6pBhNmcIYZsqi9hgiw1+GMdveQO?=
 =?us-ascii?Q?jtJ585pfsjGy0JheYT2bK4idr5MkKC6BOdUbpTfeWblvsar5FSiz9pDJLWEF?=
 =?us-ascii?Q?/2snKNsLd0t5tX1r7a7wtiFd6vDAYmNHbSfHtgWrF12L5arWBCWAbvrEIl4s?=
 =?us-ascii?Q?YPHzyfH8Ja5lHQY8WSHXoZs/DJklp+tniPtoqTB+nYVRjW0XUT0w6i/xwIGA?=
 =?us-ascii?Q?MIWoNT73FkHUSF0MtF2+c+lEBov7gngZN0Ku3IxhzVU3UKK/kniPO5nQfBzZ?=
 =?us-ascii?Q?/4KL8dnUBhf/vNwowXRI5YMLVMjlE/wz1zEQCjUfhtkv9IhDyrkqJpoMASFC?=
 =?us-ascii?Q?LSpEbtealirGSFURKKRSKovOmzn6aUMZv/AvPt1fpyWcY3wnPTGGZLafbXaF?=
 =?us-ascii?Q?CRgQoIGdqC01IVg/t0Tr18veuPY3EoQ3WKKVe7edqoDA+SY/PNzR3iyQut7r?=
 =?us-ascii?Q?oQPx008TZqdeHfuuT9oSyp29JhyzzkRIjVd01CoF999igRoUKH7BsedRN4TR?=
 =?us-ascii?Q?RdUmEt19KABXjW4IxO7G04tZhwjR6czB2jNhXvUkajlWiwMCTEszqHkeaDsG?=
 =?us-ascii?Q?yB75Z//o9Xk0V2+Y3JitI+gYCuXXXnkEa1ZkrbkXooITLzTkftcgQp/kCuMH?=
 =?us-ascii?Q?BYPmIzIDUh1Z32eMLeSCq1qVrHBUN10spZFJe/2tU6uEqKPdi0f6raxGS1mJ?=
 =?us-ascii?Q?R7UxltjELSZHwsDvo8Z6na2fFnV4MKX12BFWiELpX4stVArTC8m9PubaoR3i?=
 =?us-ascii?Q?JwNj5ABWXP05o+JgdyZsEcCFzlr1hVaIoIlu2UZxVJGrQJnUZQAgOLNVu7zx?=
 =?us-ascii?Q?uE4b3fKbJTs2qKWamK2NqPAW?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c53c301-1723-42a2-58d3-08d8f513f741
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:42:17.7611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRrclE0+PrxtJzw0bIqXHVa387wCFVEGp03bDaPQIiWU2y3qz8DuPO9kvU50bzQhPCwHIijXtQAhP5/xnwKPRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6493
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements kvm_cpu__<xyz> Guest/VM VCPU arch functions.

These functions mostly deal with:
1. VCPU allocation and initialization
2. VCPU reset
3. VCPU show/dump code
4. VCPU show/dump registers

We also save RISC-V ISA, XLEN, and TIMEBASE frequency for each VCPU
so that it can be later used for generating Guest/VM FDT.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 riscv/include/kvm/kvm-cpu-arch.h |   4 +
 riscv/kvm-cpu.c                  | 393 ++++++++++++++++++++++++++++++-
 2 files changed, 390 insertions(+), 7 deletions(-)

diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
index ae6ae0a..78fcd01 100644
--- a/riscv/include/kvm/kvm-cpu-arch.h
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -12,6 +12,10 @@ struct kvm_cpu {
 
 	unsigned long   cpu_id;
 
+	unsigned long	riscv_xlen;
+	unsigned long	riscv_isa;
+	unsigned long	riscv_timebase;
+
 	struct kvm	*kvm;
 	int		vcpu_fd;
 	struct kvm_run	*kvm_run;
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index e4b8fa5..8adaddd 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -17,10 +17,88 @@ int kvm_cpu__get_debug_fd(void)
 	return debug_fd;
 }
 
+static __u64 __kvm_reg_id(__u64 type, __u64 idx, __u64  size)
+{
+	return KVM_REG_RISCV | type | idx | size;
+}
+
+#if __riscv_xlen == 64
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U64
+#else
+#define KVM_REG_SIZE_ULONG	KVM_REG_SIZE_U32
+#endif
+
+#define RISCV_CONFIG_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CONFIG, \
+					     KVM_REG_RISCV_CONFIG_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_CORE_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CORE, \
+					     KVM_REG_RISCV_CORE_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_CSR_REG(name)	__kvm_reg_id(KVM_REG_RISCV_CSR, \
+					     KVM_REG_RISCV_CSR_REG(name), \
+					     KVM_REG_SIZE_ULONG)
+
+#define RISCV_TIMER_REG(name)	__kvm_reg_id(KVM_REG_RISCV_TIMER, \
+					     KVM_REG_RISCV_TIMER_REG(name), \
+					     KVM_REG_SIZE_U64)
+
 struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 {
-	/* TODO: */
-	return NULL;
+	struct kvm_cpu *vcpu;
+	u64 timebase = 0;
+	unsigned long isa = 0;
+	int coalesced_offset, mmap_size;
+	struct kvm_one_reg reg;
+
+	vcpu = calloc(1, sizeof(struct kvm_cpu));
+	if (!vcpu)
+		return NULL;
+
+	vcpu->vcpu_fd = ioctl(kvm->vm_fd, KVM_CREATE_VCPU, cpu_id);
+	if (vcpu->vcpu_fd < 0)
+		die_perror("KVM_CREATE_VCPU ioctl");
+
+	reg.id = RISCV_CONFIG_REG(isa);
+	reg.addr = (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (config.isa)");
+
+	reg.id = RISCV_TIMER_REG(frequency);
+	reg.addr = (unsigned long)&timebase;
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (timer.frequency)");
+
+	mmap_size = ioctl(kvm->sys_fd, KVM_GET_VCPU_MMAP_SIZE, 0);
+	if (mmap_size < 0)
+		die_perror("KVM_GET_VCPU_MMAP_SIZE ioctl");
+
+	vcpu->kvm_run = mmap(NULL, mmap_size, PROT_RW, MAP_SHARED,
+			     vcpu->vcpu_fd, 0);
+	if (vcpu->kvm_run == MAP_FAILED)
+		die("unable to mmap vcpu fd");
+
+	coalesced_offset = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION,
+				 KVM_CAP_COALESCED_MMIO);
+	if (coalesced_offset)
+		vcpu->ring = (void *)vcpu->kvm_run +
+			     (coalesced_offset * PAGE_SIZE);
+
+	reg.id = RISCV_CONFIG_REG(isa);
+	reg.addr = (unsigned long)&isa;
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die("KVM_SET_ONE_REG failed (config.isa)");
+
+	/* Populate the vcpu structure. */
+	vcpu->kvm		= kvm;
+	vcpu->cpu_id		= cpu_id;
+	vcpu->riscv_isa		= isa;
+	vcpu->riscv_xlen	= __riscv_xlen;
+	vcpu->riscv_timebase	= timebase;
+	vcpu->is_running	= true;
+
+	return vcpu;
 }
 
 void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
@@ -29,7 +107,7 @@ void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
 
 void kvm_cpu__delete(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	free(vcpu);
 }
 
 bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
@@ -40,12 +118,43 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 
 void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
 }
 
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mp_state mp_state;
+	struct kvm_one_reg reg;
+	unsigned long data;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_MP_STATE, &mp_state) < 0)
+		die_perror("KVM_GET_MP_STATE failed");
+
+	/*
+	 * If MP state is stopped then it means Linux KVM RISC-V emulates
+	 * SBI v0.2 (or higher) with HART power managment and give VCPU
+	 * will power-up at boot-time by boot VCPU. For such VCPU, we
+	 * don't update PC, A0 and A1 here.
+	 */
+	if (mp_state.mp_state == KVM_MP_STATE_STOPPED)
+		return;
+
+	reg.addr = (unsigned long)&data;
+
+	data	= kvm->arch.kern_guest_start;
+	reg.id	= RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (pc)");
+
+	data	= vcpu->cpu_id;
+	reg.id	= RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a0)");
+
+	data	= kvm->arch.dtb_guest_start;
+	reg.id	= RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+		die_perror("KVM_SET_ONE_REG failed (a1)");
 }
 
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
@@ -55,10 +164,280 @@ int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 
 void kvm_cpu__show_code(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (unsigned long)&data;
+
+	dprintf(debug_fd, "\n*PC:\n");
+	reg.id = RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ PC)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+
+	dprintf(debug_fd, "\n*RA:\n");
+	reg.id = RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (show_code @ RA)");
+
+	kvm__dump_mem(vcpu->kvm, data, 32, debug_fd);
+}
+
+static void kvm_cpu__show_csrs(struct kvm_cpu *vcpu)
+{
+	struct kvm_one_reg reg;
+	struct kvm_riscv_csr csr;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+
+	reg.addr = (unsigned long)&data;
+	dprintf(debug_fd, "\n Control Status Registers:\n");
+	dprintf(debug_fd,   " ------------------------\n");
+
+	reg.id		= RISCV_CSR_REG(sstatus);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sstatus)");
+	csr.sstatus = data;
+
+	reg.id		= RISCV_CSR_REG(sie);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sie)");
+	csr.sie = data;
+
+	reg.id		= RISCV_CSR_REG(stvec);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (stvec)");
+	csr.stvec = data;
+
+	reg.id		= RISCV_CSR_REG(sip);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sip)");
+	csr.sip = data;
+
+	reg.id		= RISCV_CSR_REG(satp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (satp)");
+	csr.satp = data;
+
+	reg.id		= RISCV_CSR_REG(stval);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (stval)");
+	csr.stval = data;
+
+	reg.id		= RISCV_CSR_REG(scause);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (SCAUSE)");
+	csr.scause = data;
+
+	reg.id		= RISCV_CSR_REG(sscratch);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sscartch)");
+	csr.sscratch = data;
+	dprintf(debug_fd, " SSTATUS:  0x%016lx\n", csr.sstatus);
+	dprintf(debug_fd, " SIE:      0x%016lx\n", csr.sie);
+	dprintf(debug_fd, " STVEC:    0x%016lx\n", csr.stvec);
+	dprintf(debug_fd, " SIP:      0x%016lx\n", csr.sip);
+	dprintf(debug_fd, " SATP:     0x%016lx\n", csr.satp);
+	dprintf(debug_fd, " STVAL:    0x%016lx\n", csr.stval);
+	dprintf(debug_fd, " SCAUSE:   0x%016lx\n", csr.scause);
+	dprintf(debug_fd, " SSCRATCH: 0x%016lx\n", csr.sscratch);
 }
 
 void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
 {
-	/* TODO: */
+	struct kvm_one_reg reg;
+	unsigned long data;
+	int debug_fd = kvm_cpu__get_debug_fd();
+	struct kvm_riscv_core core;
+
+	reg.addr = (unsigned long)&data;
+
+	reg.id		= RISCV_CORE_REG(mode);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (mode)");
+	core.mode = data;
+
+	reg.id		= RISCV_CORE_REG(regs.pc);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (pc)");
+	core.regs.pc = data;
+
+	reg.id		= RISCV_CORE_REG(regs.ra);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (ra)");
+	core.regs.ra = data;
+
+	reg.id		= RISCV_CORE_REG(regs.sp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (sp)");
+	core.regs.sp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.gp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (gp)");
+	core.regs.gp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.tp);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (tp)");
+	core.regs.tp = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t0)");
+	core.regs.t0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t1)");
+	core.regs.t1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t2)");
+	core.regs.t2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s0)");
+	core.regs.s0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s1)");
+	core.regs.s1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a0);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a0)");
+	core.regs.a0 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a1);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a1)");
+	core.regs.a1 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a2)");
+	core.regs.a2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a3)");
+	core.regs.a3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a4)");
+	core.regs.a4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a5)");
+	core.regs.a5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a6)");
+	core.regs.a6 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.a7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (a7)");
+	core.regs.a7 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s2);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s2)");
+	core.regs.s2 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s3)");
+	core.regs.s3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s4)");
+	core.regs.s4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s5)");
+	core.regs.s5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s6)");
+	core.regs.s6 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s7);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s7)");
+	core.regs.s7 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s8);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s8)");
+	core.regs.s8 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s9);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s9)");
+	core.regs.s9 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s10);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s10)");
+	core.regs.s10 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.s11);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (s11)");
+	core.regs.s11 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t3);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t3)");
+	core.regs.t3 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t4);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t4)");
+	core.regs.t4 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t5);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t5)");
+	core.regs.t5 = data;
+
+	reg.id		= RISCV_CORE_REG(regs.t6);
+	if (ioctl(vcpu->vcpu_fd, KVM_GET_ONE_REG, &reg) < 0)
+		die("KVM_GET_ONE_REG failed (t6)");
+	core.regs.t6 = data;
+
+	dprintf(debug_fd, "\n General Purpose Registers:\n");
+	dprintf(debug_fd,   " -------------------------\n");
+	dprintf(debug_fd, " MODE:  0x%lx\n", data);
+	dprintf(debug_fd, " PC: 0x%016lx   RA: 0x%016lx SP: 0x%016lx GP: 0x%016lx\n",
+		core.regs.pc, core.regs.ra, core.regs.sp, core.regs.gp);
+	dprintf(debug_fd, " TP: 0x%016lx   T0: 0x%016lx T1: 0x%016lx T2: 0x%016lx\n",
+		core.regs.tp, core.regs.t0, core.regs.t1, core.regs.t2);
+	dprintf(debug_fd, " S0: 0x%016lx   S1: 0x%016lx A0: 0x%016lx A1: 0x%016lx\n",
+		core.regs.s0, core.regs.s1, core.regs.a0, core.regs.a1);
+	dprintf(debug_fd, " A2: 0x%016lx   A3: 0x%016lx A4: 0x%016lx A5: 0x%016lx\n",
+		core.regs.a2, core.regs.a3, core.regs.a4, core.regs.a5);
+	dprintf(debug_fd, " A6: 0x%016lx   A7: 0x%016lx S2: 0x%016lx S3: 0x%016lx\n",
+		core.regs.a6, core.regs.a7, core.regs.s2, core.regs.s3);
+	dprintf(debug_fd, " S4: 0x%016lx   S5: 0x%016lx S6: 0x%016lx S7: 0x%016lx\n",
+		core.regs.s4, core.regs.s5, core.regs.s6, core.regs.s7);
+	dprintf(debug_fd, " S8: 0x%016lx   S9: 0x%016lx S10: 0x%016lx S11: 0x%016lx\n",
+		core.regs.s8, core.regs.s9, core.regs.s10, core.regs.s11);
+	dprintf(debug_fd, " T3: 0x%016lx   T4: 0x%016lx T5: 0x%016lx T6: 0x%016lx\n",
+		core.regs.t3, core.regs.t4, core.regs.t5, core.regs.t6);
+
+	kvm_cpu__show_csrs(vcpu);
 }
-- 
2.25.1

