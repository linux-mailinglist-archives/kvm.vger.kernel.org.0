Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63351B6CF3
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 07:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgDXFAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 01:00:22 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:57967 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgDXFAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 01:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587704420; x=1619240420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9TZKFN70WqKudIvHylul3i6+8Yt2GNTWaHlG3fnfXc0=;
  b=O7U6IFxqdct0jbj9hLVJzEHYkfiVZ3oeZp+/PDRgR0rfUJrfUzGwgHLa
   H5dbFX4g1tQNdBK0NDmYb97OcAP/zNXZF54iZ1/VWF9iOKbVUpaglfpvf
   k+NpCC0OPOzxOLwFDiAzLM6QjgY179JdSsLMgeA9mJjpegwCcOvFPHCpj
   MS7R1QR5c/FB8xu1Fj18VnZxTs4Vkg7Wxrg0oJA40KkzD87BJbsPaEOZK
   1qptCveu3R5Dkmsoh5zejpT+54l1JOhdNR7u5iD2o+hJ+XlKEtkTdKuvU
   UyO3CDPOzkzqV8Vnfft3qtqKXEXOggOrsnrSngXR7p7BfsTe+t/xJXHXm
   A==;
IronPort-SDR: pVzrA5NqSJNBO8rvBgVn+hBIzHL3duMAjOuHp0XVDcwylpvY76U2ZoHQ8yGWi/nntNtAvJEcVc
 5m6gL6fWXAK95Mq4N+HqmOQTtND2F/1l9Er3e6EapKNN/eAQLdokAlx9zGhVimkVg2DdS5c7uw
 FD8TxZVpW6OyUVUdiSCuPLojfG0MVgFoJKjO9iWHQMNM5ku0mnqrtir8W90SOU1otABANzxtT0
 o0t0HYa6w0v10sZqxdi1958NS53GdK5WxYb8wkPI5T7B0pXoug/E+/BbdiVEQCFytEsGQb1ct3
 JHk=
X-IronPort-AV: E=Sophos;i="5.73,310,1583164800"; 
   d="scan'208";a="136050477"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 24 Apr 2020 13:00:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDn4YRN6y8wnq16UkMbsjUdamxXezpAs+DB8Fw3YXUg6m8jjmo5t65Pq7/pv7XI6QQcfeu4uMYWoX6p2hvHu8SkO5tx7H15vWDfCzr4MzvY0d82tYuqiRqHha04CaT7TnnPEBxhmS914dkOzIE6BhOziKQ9L0tyCONMy6CFnk/CAst30Jhf+toe76Y2hTiK0qvBj+bo+CZU//c5jtGFh9VngODJbgjGo78iec70Cuj2g8KL5mgNMzm1GIvHypypmrcNfTxL8yAFjb+OBwvQQJSFYR2v+GnaQJbmD30uZGYQNltmcJaHa3AwvuFAnyK88zO3/ZFQ8sek3WmUbTTNQPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl6Gy1sZP6WITFuw1lylVY/qGiEL4U21EOf9JQzzjX0=;
 b=LoR0NhPeJ9/njmxiMQlYfliZvIiIMe1JXRWQeowbQxzZ7Ieplg1hD+/kig9CsTLb+gAuM/tVfR7hJrIAgYxWGKItyXvd8ORQdKnQPz/Vdp6YCywxy/l6rbMFcb6yzNi4Bzy5SiNB7xZ15yHp77yT0T7oW6Kpz23OPIbZE03MkNU3RT8Xf9U6+FD1mC+cHBBlM9lOmmFiK54/NdW7iE2rRYs78p2hXtJSZzQ74eW2zbeoZd5ToFTBlkKE/JJ8taZ87REMZAWKA7F0E7lx0QoX4ZNtTIcEqRiCGe62z2B43L7qCEfzIRY+jDMDokS8s34WlnWrQIJNiuaGT4YI/+6aMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl6Gy1sZP6WITFuw1lylVY/qGiEL4U21EOf9JQzzjX0=;
 b=jLUaibd8fdUX6JN+gy2VneIC+wqx2OeV2sJ/VrosPT0+QSlbo+CSIyY+D2hK/4tnfao1osgrRBTuAabp7WQLTpuDqmMyP0O8xrbEQp4d2614jcMxA6Bx8nWzjqOV9MMNgDipnq95UFgrnTOLOQFu5iT/vJRLR9TuGB3CBFyRCtc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (20.178.225.224) by
 DM6PR04MB5467.namprd04.prod.outlook.com (20.178.25.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Fri, 24 Apr 2020 05:00:17 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2921.030; Fri, 24 Apr 2020
 05:00:17 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH 1/3] RISC-V: Export riscv_cpuid_to_hartid_mask() API
Date:   Fri, 24 Apr 2020 10:29:26 +0530
Message-Id: <20200424045928.79324-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424045928.79324-1-anup.patel@wdc.com>
References: <20200424045928.79324-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0130.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::24) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.136) by MA1PR01CA0130.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:35::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 05:00:12 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [49.207.59.136]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb9e8edd-9bd5-4f69-5c1e-08d7e80c61d2
X-MS-TrafficTypeDiagnostic: DM6PR04MB5467:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB54675AAED1D26AEE033028B18DD00@DM6PR04MB5467.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(54906003)(110136005)(55016002)(52116002)(7696005)(16526019)(8936002)(5660300002)(7416002)(4326008)(2906002)(8886007)(6666004)(81156014)(478600001)(1006002)(186003)(316002)(1076003)(55236004)(36756003)(4744005)(44832011)(8676002)(2616005)(26005)(956004)(66556008)(66476007)(86362001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nxPUh7wZf1+YzdpJpoPs4/9RHtfvzaJkdFx5Sdbn7cggFx9NEImW14JY4rfh5WPSUVy85itGk49NnXALQVNcbWpzCX7KpBMjYnIlVJTK4w5wKl507/gayKmbtnH/dlKytaon1eclWu2iQti1sdQfXAnihdgNndVMtHtraRyeFU8RREgzTcm7V4eV7OnGt4yYZQe+Ob98Ro/exGGAHWjXZ0jHgYEAM/r1iWs+DWOXLuT6igGupxpQEs7kEaTg23oHaF7/73U46iExvglyXpDsQu2Zh1Cvv4LqyE2HVS+b82yDPQj8QFPWP6SvSdsfSmB+Hz/JP4C+z2T6UrYMqYh0VbPitQpdCbUWd0ZDU1f59hsr7S2lQFkljikucN8nnCZZ/kF8X/JOcwHQXx8iWjU6/54jSzzHvfAeMQVOBfMeots5neo56CtNMfKk3o9Dx2o0
X-MS-Exchange-AntiSpam-MessageData: ljx1o1u/BhLMjjjV7/mDOYhRWbxo5QhnkqfkknT2hqOP1uvxc6iBLvog0NN4STqZsns+xt4Nh9TR42nGCyKcOIgfArOav1S1jVCc/953CoJ9dodBhWoHCLc3VCNjlb39e9266EXMIAObyREhdvBZUQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb9e8edd-9bd5-4f69-5c1e-08d7e80c61d2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 05:00:17.8370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p5xDU0W9arBlfOxdtJlYMl8E4TpLQ4X4LGZ48VA3VkR14udShIsPLqCHakJfDT/4+VNoYuXtU0LfeMdqnMvODA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5467
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The riscv_cpuid_to_hartid_mask() API should be exported to allow
building KVM RISC-V as loadable module.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
---
 arch/riscv/kernel/smp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index e0a6293093f1..a65a8fa0c22d 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -10,6 +10,7 @@
 
 #include <linux/cpu.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/profile.h>
 #include <linux/smp.h>
 #include <linux/sched.h>
@@ -63,6 +64,7 @@ void riscv_cpuid_to_hartid_mask(const struct cpumask *in, struct cpumask *out)
 	for_each_cpu(cpu, in)
 		cpumask_set_cpu(cpuid_to_hartid_map(cpu), out);
 }
+EXPORT_SYMBOL_GPL(riscv_cpuid_to_hartid_mask);
 
 bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {
-- 
2.25.1

