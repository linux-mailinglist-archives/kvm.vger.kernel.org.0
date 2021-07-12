Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6CE33C6173
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhGLRG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:06:57 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32290 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235290AbhGLRGz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Jul 2021 13:06:55 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16CGvCGP017159;
        Mon, 12 Jul 2021 17:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NPhc5mxfcQOV73V7MTFx8KERIgZs/BG2uCuksy4GbNA=;
 b=HKJQeUxMVqW4Lj1RVReMuLuTp6BkgYx+zlh0ahT7qqyvAuZTM4+E3cm+CPSs5za0ml0G
 DGtAfym3Sc5l4TImovztcjvAije6N99QJHEIj3h6Z7eGp1fKOO8ctVswtWI8RHHk4k4V
 MVRtZzx8oJdHn5w0rLC6ZOeqq9KpAQqol0TJhGZhbiOhrkXXhRVt+PS5JPTCY3cqxxxL
 K6dOix3xkwNKanF4Yz1RfA3nQ1xtSd4R2jVj83rNmZt3l/tnX+OWKbMPBmGYkepuL7Ek
 Nh/mKdz1uirim5o7SSaCF/2llYv/tvOUkNByXLTnhB3v92zxb1EzL21HYrLD3IGKP9TN lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rnxdgmuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 17:04:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16CGt3sd186637;
        Mon, 12 Jul 2021 17:04:00 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by aserp3030.oracle.com with ESMTP id 39qycs8t9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Jul 2021 17:03:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1cmI4yQrCrijNI1Of9Oh9EqHSbXVzSAslfBszvDGAkC3aba6S7Se7v5ATSnNyVK+vK7Yc/9s/Dv+7ZOLKXhpvXps6M+EnyH68urjbZrMIHck9AyKd7LHm8uZBtrLwOTTrLYdsKe0sA4t2B/w6zBkVNmXq5HCHw5zsUGHASY3a7bTkL9YtiqlPN79qSZntyL7A7mZFN9x37tygRd5fGlh5rNaG87yB+K+SKTApb1Jbx5BUqT33ByI+smFX52s0DISiayAzJvkS4SRjodw9Tl/izUohFVNDewqDTzqigr0GbzjyQBpSWCJoyIpy0L+GJadJ6X0s7xzUoHVXtodTZadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPhc5mxfcQOV73V7MTFx8KERIgZs/BG2uCuksy4GbNA=;
 b=bOKMgARQD9RI9hO2r750sS+39CWAn7Ky/y+hymEQCUdTXtazS1e/1639v0kqSJ7WaqUXTOp8SBFkV0f7DWdUWbIR1rTg1uzmM5y2ed7TCEaCBrQdpRFvMCENoMXX5ZaAMmKnOD3lb3kXJ62bdy/FMmusi3eVByqxrDAyVE3RWfd2IW/7rYxNgJBjydda4mY59xU/luRaNNr9l8Mipni5eP+uMj/E8VGqlnegAMj0s8tcRL4nKruvwpXlG4y0th7ouWqTtwUQ7A4lC+DgyBkGWFGbIxHRB1YTf2V7maDUEvDLAE+13bj3jCUVyYpKnpKlsEvHkzNv0JxKfoFdShpvkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPhc5mxfcQOV73V7MTFx8KERIgZs/BG2uCuksy4GbNA=;
 b=n4UXhEoKJj8TMNwHiQO/yaDoX2HRwl6WoCk9E3EcJF/HKU4utvvlMwOGyg6UWl0gMwtVAwIv/tUjcWKawaHOjNt8l5HeGtAv3YaT8Ql4ushEiUVpVjBI88Zje4Pw7BoLJptIGFxsIO/ma948vYZzaaKJSRR0LSBhZYBcebOAQwk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4391.namprd10.prod.outlook.com (2603:10b6:610:7d::11)
 by CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 17:03:57 +0000
Received: from CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15]) by CH2PR10MB4391.namprd10.prod.outlook.com
 ([fe80::b895:ab48:fa35:3f15%4]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 17:03:57 +0000
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
        alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     konrad.wilk@oracle.com, alexandre.chartre@oracle.com
Subject: [PATCH v3] KVM: arm64: Disabling disabled PMU counters wastes a lot of time
Date:   Mon, 12 Jul 2021 19:03:45 +0200
Message-Id: <20210712170345.660272-1-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0139.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::18) To CH2PR10MB4391.namprd10.prod.outlook.com
 (2603:10b6:610:7d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.nl.oracle.com (2a01:cb15:8010:b100:76dc:8169:72eb:62ac) by LO4P123CA0139.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:193::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21 via Frontend Transport; Mon, 12 Jul 2021 17:03:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a3d0b1b-cb1b-4d88-8665-08d94557098e
X-MS-TrafficTypeDiagnostic: CH0PR10MB5115:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH0PR10MB51154ABFC8E30F67F11D960B9A159@CH0PR10MB5115.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:53;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9781wdqfdVOtlx/R/TuhVB/o7OmjmaiSNoGuUC88vg5WA2plaz9lAUjtThqwyp6yHkvMH4JpT6pu4+vpU/A2fRKiL0DqixiB6v91fWXvOtrQYyKTisZfOsN6YeRDTNkI3oCz2gnjpfx05wb147fzS2UQD9bhWZE16hXfZ9a8eKvZzxt87nC1yCLsMyQHDF5SZFp9HCBfVTRskHoS6/o0MnAAzTqOe/aPv+oNCXYSLGKGpy4hLak4Isvdtroz0TWuF3EnwMyPnfnhlEbXEVwYuRhoDUVtrajPYvfw+/h65KkGli0d9moif+MkK0NwFsSHALzIMEzbZnQhAcFitzwD589GHYZhvRc+JYc0Qvg/xdKpelXHu+LNMXvBE5QVe8kICLInp07dmawn7gMuUxBYgH5sIM7SI2wUqNZ9MJRmMY9IqPte7a/6D0LSmzX1WY0nHs0LjEH/VdX9eD8Es2tiyMrpFLiBlutcA6iYMJXcZPQHx0oRQ4c5jLKMbNUzfBPQfBJWZiAYqMUVZYE7l3EOY2DL9NoQ1gN58Z4TfKLJXRG6uYlBIBAC2K6HOTaReGwbE8cbvCpmBBneWn12+2B4sEhQtwUqeOyOAeepqn/z+EhFd7pVybQGL2W7ZMR6mr9A81CQN6YvqkepnxbNDVHs6lXoKZnkT0+x5UXqyejFy3bl1j/ApE0aF0OK4Zd2smLf4jEqD0iNV48w7KvO0r1hXN39MCEgAe/Oh9gHQGg+XFA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4391.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(366004)(136003)(83380400001)(66946007)(66476007)(6666004)(38100700002)(5660300002)(7696005)(52116002)(316002)(66556008)(36756003)(2906002)(966005)(4326008)(8676002)(107886003)(86362001)(6486002)(478600001)(8936002)(1076003)(186003)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLuTpFPb+s4qhhHtEXlLdhigm2jZYGHENPQ3bVqwQoNy6kwCie9oGVYNRX/t?=
 =?us-ascii?Q?wxI/0oeTVzyd01Jv8ZODi8/0KHyjmFh4VxSWbQvTSLYuwf+siy29OE+3JJ+4?=
 =?us-ascii?Q?B+MTThQ6y7HfCMqGh2eQ5fNC67zTZP8+S3fd9jowLjNRY+Xrff5e+/oLvexq?=
 =?us-ascii?Q?PpD7dXxPiwFLPV3rFyAzC2sOzJkAXVvDIhgTr0+MMNVc2aeh+qwJZNXXajBy?=
 =?us-ascii?Q?+TiXxrwUsmcGT5Cx+KECWv5ULGl/Y9VO4aBgk9wq19MX7MpSKMOSVkFicT+q?=
 =?us-ascii?Q?BaolD/meiHC7yHZ+kGFqonW8amonUnP8qIGVUw7U75SbvshW3nQhXIPlbp9S?=
 =?us-ascii?Q?q5mN0Ns6ZOQQq+EEFzp/ofU4avINj0H8bI5TNXp8UxtPHZfY7ObsuyDdxOYn?=
 =?us-ascii?Q?5+pvQU0YpS/a/trFaS8mc3JxROkYUJtsMYENNwXiDQnorn6kfFppH7av5IHk?=
 =?us-ascii?Q?GU/JfUEAoU+1cUKWMNds1K+eCj03PPmNc8oB84soKE/Q74N40saS/Pjsr4Vj?=
 =?us-ascii?Q?3VfkP4CeoBnchZ8OAFliKNWix6kakM70kZI9pPYFz3Elnb9yVEjXwAWbq4Ta?=
 =?us-ascii?Q?Gata7O0nPNCnlGC9otVNZYgzgjFDtioBJH0S+bWZonBBVAZKfAruI15kEhfk?=
 =?us-ascii?Q?AfcB5mR+TUoNnTw/9T5RHp5vtAIs7xC1v2WQvQwvGEXffw3oy28APK+etmB4?=
 =?us-ascii?Q?ir/P/74iV39P8L3IRc2JATEchCCnIArZjKYwa51wjSAOwyR5A3753ZX1X0tX?=
 =?us-ascii?Q?pbFgQduqXRdGx/x/wfjO1QDVraoGemDENSQ545QA/xrGKx+iMHbkjKvRffEN?=
 =?us-ascii?Q?4865obB1SkeFv78NpI++GW1HO3ycromKsiF/S0I1X1V/KPy+1lamSyF4/Lks?=
 =?us-ascii?Q?cyBj05Fh7Nzc8mv6JZ4qXx21VddiVavUDHaoEgkl3U/Xy6SfMC5bFa0ZxIvW?=
 =?us-ascii?Q?VsPEEp8XsViYKJubqPTpiYMvIs7ydndVGltQ4dtwjm7CidMeTheJoEIBsPwQ?=
 =?us-ascii?Q?rGvuZiahiZSh2VjG7OnTKQVG+5Tnbx+SQ6bAO2UJgrqwzkxPsCrCvqyCwJLi?=
 =?us-ascii?Q?fSPq5S0k/YNBca4QOiR1OCEkfp4O2KEuEUm8OsMA/VC3aBmjMK83HPyvENAe?=
 =?us-ascii?Q?jyHZeR8JuYR5epEG6Mj1fr8rezMaOD/jUVpcXoUDzTvlz3VpUUnwxir+95uO?=
 =?us-ascii?Q?i0O+5rsu9k0ghFn++rhVQ27/1IUR4UI9gypafe0zB4CBvl+SCwVcrjDqkths?=
 =?us-ascii?Q?C1dqFZQEDNRBzNE7mpiH9RLOFwv/Jfecwad8JRRsFHsqL/lntXDT3JMHx8qR?=
 =?us-ascii?Q?0+FFD82qH7bicgL29Bw1pUAAHI40uLv9nnhqGw+6oVet2J5J/PZEx0LL9nzp?=
 =?us-ascii?Q?zWVxYh7TgaE+M16fmADnh9e4XtXO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3d0b1b-cb1b-4d88-8665-08d94557098e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4391.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 17:03:57.5756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/iUc80gS264ZKYxdoe+clzEbwdWMBWC9tsVd+em86s+D1vMqEBvoOVpo8c0r5wPeydQs//GoVPN895eWbR43dpB60K3w8j/HT4WARNJhMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107120126
X-Proofpoint-GUID: rXapSZxtehFgI2QrA8YksA1mUmorCkT2
X-Proofpoint-ORIG-GUID: rXapSZxtehFgI2QrA8YksA1mUmorCkT2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a KVM guest on arm64, performance counters interrupts have an
unnecessary overhead which slows down execution when using the "perf
record" command and limits the "perf record" sampling period.

The problem is that when a guest VM disables counters by clearing the
PMCR_EL0.E bit (bit 0), KVM will disable all counters defined in
PMCR_EL0 even if they are not enabled in PMCNTENSET_EL0.

KVM disables a counter by calling into the perf framework, in particular
by calling perf_event_create_kernel_counter() which is a time consuming
operation. So, for example, with a Neoverse N1 CPU core which has 6 event
counters and one cycle counter, KVM will always disable all 7 counters
even if only one is enabled.

This typically happens when using the "perf record" command in a guest
VM: perf will disable all event counters with PMCNTENTSET_EL0 and only
uses the cycle counter. And when using the "perf record" -F option with
a high profiling frequency, the overhead of KVM disabling all counters
instead of one on every counter interrupt becomes very noticeable.

The problem is fixed by having KVM disable only counters which are
enabled in PMCNTENSET_EL0. If a counter is not enabled in PMCNTENSET_EL0
then KVM will not enable it when setting PMCR_EL0.E and it will remain
disabled as long as it is not enabled in PMCNTENSET_EL0. So there is
effectively no need to disable a counter when clearing PMCR_EL0.E if it
is not enabled PMCNTENSET_EL0.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
The patch is based on https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/pmu/reset-values
v2 - fix commit messages and rebase on kvm-arm64/pmu/reset-values
v3 - add missing ~ (stupid me)

 arch/arm64/kvm/pmu-emul.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fae4e95b586c..c64e35534694 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -563,21 +563,23 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
  */
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
-	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
+	unsigned long mask;
 	int i;
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	} else {
-		kvm_pmu_disable_counter_mask(vcpu, mask);
+		kvm_pmu_disable_counter_mask(vcpu,
+		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	}
 
 	if (val & ARMV8_PMU_PMCR_C)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
+		mask = kvm_pmu_valid_counter_mask(vcpu)
+			& ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_counter_value(vcpu, i, 0);
 	}

base-commit: 83f870a663592797c576846db3611e0a1664eda2
-- 
2.27.0

