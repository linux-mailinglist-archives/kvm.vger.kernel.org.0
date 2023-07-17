Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49AC7559A8
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 04:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjGQCf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 22:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjGQCfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 22:35:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2042.outbound.protection.outlook.com [40.92.18.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5CEE54;
        Sun, 16 Jul 2023 19:35:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGzGaz6yRQv/6l7Mh4hZ3jq3AYBBWXg/Tzh3P8aHjvEZycJ81L+D58V+/O0qeb4MCowJqYxuG8nqo8qH3H1NbgAZz5zxoUOcFOzVQdDKTSi5M9PHjzC0kiYIP8iBOrzk8NR5o2xnBPa0M2XN33L8JPbvSxbJeezH71H5BWeMhZi+vmBBKtpIPyV9DCEdGhKxYzZ5GOycizxErQD4WPJk0YMyfWQMmvLWbZUA1cY1J5OqGZiPf1DTuKE9vjAEu+oISKaAoTlnlg8ug0jn+xBlWTuyg0HO8MIKX9cY73VLpSEEe7ehITy5nyBLBYAO65B5UV1rhHTnr7SwNeUOvz8i3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dl5dxU7ZwrZInovT+SUPvp4WBcYQp3NwqtzzJoAHNtM=;
 b=aexZHEJETDvznswYAttq+4tfgQ4MrQkPxknje84gJmw8fUnI8Uz0eaEbmn+J4AddQahzJ1195B7ZX14z2pPdi9aln9snycIl5q8sFaFs8jGLiBGTVvIdt0v9VX4NMFkizOisS1MVSlpUYerNQd5aOqSVUVn/Xk1uIkjaVY3uvFoLY5+vpY+6rtRw+DKpVLofW+PcL+3GyJpOLv/Pqb2fDwfonc4N2fn7vhQruKG838z7aJGp9PMZc4zSxj0EPDY/IfmxX+jpHap1tHXo/1AUbDEjX1tIz1+5A7z8bJp+oF1A44glcdv3pNknIaOb7VLKaudAfZL6T8ICzvEBVIBWeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dl5dxU7ZwrZInovT+SUPvp4WBcYQp3NwqtzzJoAHNtM=;
 b=fnM+VPd0HiYnasFsyEG2d4XMFTVpkvjL4bsNSBkKCKbSoJcyef40LGvQRUmeepPAuftCgyJkFClnMeQkvnNSfXkpU6gkNnHaq2/MsRPayjjcQ5yazFDMq9nU+Sb5t1F0S+45oibhd7p6yf8GgII3vh37RBAp6yGqDXfyA96vp6V0/dGwhS1POfeFZ+TWzG8MAAgpwvtVxUMn5dueUFQ9pW8o0MApoql0lcNqo9HRWkgNgyfVHlEcuc1Ckpmpywb6R4DMFZzuMa2Uq/Kya6yyeEv6Q6tqxgv22o7kaTRNkB/tne3vmpHqQ7j0JMW84UnJ3EhbpP+RFOOIQBCeEt6Blg==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by PH0PR03MB6512.namprd03.prod.outlook.com (2603:10b6:510:be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 02:35:50 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 02:35:50 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, zhi.wang.linux@gmail.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC V3 3/6] x86/apic: switch set_next_event to lazy tscdeadline version
Date:   Mon, 17 Jul 2023 10:35:20 +0800
Message-ID: <BYAPR03MB41337FFC875975099BE27A6DCD3BA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
References: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [6tYgx3S2smJ4YWcptjOPpCbWbsUY6ZUuV35Q4bjQscw=]
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1689561323-3695-4-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|PH0PR03MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: cedf609d-881a-4268-9df7-08db866e88c5
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnqpUrHVo6HYXI9uowj33ZBSMxyGCs8oe2A/oKvmeUs/WsuRNhA6f+yXNNJ7+kusVma9NdcMKeEDFW/IheRXGFPtYBMaXL5zsrJrymBcnfSwbVq+JgAEI4YI4YRqI4jxHKEXu+bBHaxkHx78hwXule29hKMkNXYzOf09UUxuf6HKIRftjv7x/3HU/wIQLVRH6i9pzg4kgWYvkngabTU/+NBzsm4ZhaK+BJ0lkNCZN6t+EIE24HIst//m0PB/Kh8qPJokF/kdHGWWag1x0HUb+g2uJ01njnO/fGehzytm2TcmLAc5ZxJ74dScLwUcz0YueWOCXCNcJux7Aw6OLwl/M8dNgMvLjVHJjCvvE4LdwRpaBERbsGXU/2K85drdzMIKh6mNZTcWKutwofIDFNXcoRV1Y5MKB5fj3k5Nr3A5d6dQm/ziUc4Ps5SPmGc2LA7543ucFMiwAjme7SbFh4yTrntInYm4ao/AJ3e4m7T0ZUyBEdmly9RsBA8/NpBQWgc2bZGB+vNc8Gra8bgOaGJmHJKRjiCrH8lT/WdjbT7hb35M6+cbAWjoxElsfgu7cGW96llkAcb1dEn3HivacpnyPzlPbASq22stkQsU7LyfZeZ+ns12tj391xKjCQp2uBHVMeUJpWyN+RD8iD1fpMOEnQktZKess1IwQXZv77+CHK5UMWuGV+I/Az0YOF+A8G5d7TCO4LkRsfWMQ0QKvAB9Bp/RhJ15Cb9JtZlx5ggee/u8ks5ATcRv4PKFR0/aCHz3fO4=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfZIFyKRQwZBG98E4Atc+Iowt4YmaPVC9XbotJZp+E3S3Z6qv3ynA/Hr5h+KfGthL7NOXXeSXif/81MGPnrqPMumCHq8s4+AjXmFmd2iBM5MCFxlGGbAzpHovlYJ/1Lkqcf/wbbBq503U1fMdBpclhIl3DmoWh0uQILnUbXLknqO0Y+8TymwXUUt84VMlbvea3jDQa9nh1APYaDJ8De5Nj2NdXtTume/dVy7bII2kZGeDDJy+UhfNVfzILQ8HYhk03lcRVZmpBYEAFcvfHCPYW8IlUOKFNptQWK1POtYGxZAanL8yNNeTxPoIzlEJHSdlYscMrT4hJ50sy+wkzsoHUgsTKXTy/fB2qTNTzJUBisBOfZhLzE/9SxsiamjEoXyHa8DS1JcrR887GGroAZV2LVyG0qvKfR+cB/XoxbgWFrQMpDJ9/BcStkl3oM0jmC/6KZ3hnz1ReiXijxSca5Wc5tnY0aaSOAcpis6KXauhY7pO7re+qbkGv/rOVpAvX++wVirpOO/74p/f3seeLMExpAcUSvherpWgB2xRfb0b3SZdxXUsDBDgRZhcXLWQeUC
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qjqPEjy1QsGWKQy5PNCDaR0GV7adgnPEijtrEvoTxBZXjQjY2/WyUoNdUX/5?=
 =?us-ascii?Q?VUBdGVPV7KmkALJrX/U8WjLBl5eb+U4+HmwgEwOe/xkXHoaD1tJ2VXAYjbeD?=
 =?us-ascii?Q?2OZv6Jy7VPwjEeGctYgWlBM9pLJT+D0GsLAl8+FfRidSaVlkv7yGDjvGkbX4?=
 =?us-ascii?Q?O8VdFLvrEA3RFsrYt+UJ5WzyaGXZl8qRoZyZijZBw+vZwezVoyXFEoTS5Llq?=
 =?us-ascii?Q?n0mUZ2kOlw46hKJB2kzHxUHi+7xQ3yBeLXrjWSUF1JfzON9h5n1k+69CvgYl?=
 =?us-ascii?Q?qEb25JmvwP1eaCBFPnEM/dfV8ttQlT7KrpHLq8OvoAyomlAUji7Y3D2AFJuM?=
 =?us-ascii?Q?SAxlREwnWl/Jyz3sNbC23ojjhgLhHJwdXYC3wGm9QdU2tCfA5yf7oiZuoNLL?=
 =?us-ascii?Q?LewPglxogJTyyaJooNAilkcGh7fhyDxJ6gZ+/lpW2VPs3SFdGBjqdcn9oBjk?=
 =?us-ascii?Q?9SBaxAXgQiuYlgjMAtJnwXiV6Vm5xAlyh1gKvxgmmULFU3ze7IZnW6DnwH43?=
 =?us-ascii?Q?uNiW9O6CUTvxWqUJqZYIxUInYjTWTQE57u/XuOcd3K7QVchHax4ZQ3jGKOrG?=
 =?us-ascii?Q?owKOFa3xhQwE3XHSD1MfCgO/s3oNTbVhDC+zA1lmB9NhhTl+cey9pCzL4jwq?=
 =?us-ascii?Q?snSXr9Ttgzfc3g88nZA+Z/BAiX93fbEvmkKziGu25wGZnZ3UPczNl2CPyRGB?=
 =?us-ascii?Q?GA2CA5ScrJZOGzqOkSXBPGRVSfjAugHeql1I5KkziiF1sBFLuvvo/3bJmj5C?=
 =?us-ascii?Q?oQgE7d6Qoy3VU6q2QbVARkUJFjgA5fnCWEMuy1WeeDxbfi0yHCsOYckGAkKY?=
 =?us-ascii?Q?U6CRW9i6MYMjWM1anooplmTWs+yLoFXbWhJ16hGaAwT6xaXaz6CtlEtgGi4t?=
 =?us-ascii?Q?pqlCTTfyzzOqqmWO4XzQfUAUEonKSDHDBJZjZjCzdsn8g6zubMyGsGaShDev?=
 =?us-ascii?Q?oJ1626LZ8Kex2iFsk+L2AlM41w/3GtH/Tx8Tk/FGRtefeXMGj95fgkC3E3YY?=
 =?us-ascii?Q?kSVvBoEKIlb+sI+H/aD1EujJpLvllvVocAhEVzrJYBHsF92DhWtV/O1o8hyg?=
 =?us-ascii?Q?8VFp41rNWuL/Xnht1DUItwXEP9K3AWyIk4nMW49CYc19IX6ScPq0C6LgW/tI?=
 =?us-ascii?Q?tt15M51T8l8d2J00kr0K2L+euPgKRzn+ppYjKAzw3woK5f0HCmG6x2WJ9cM1?=
 =?us-ascii?Q?AVaWqnBG96AzF67qOHdMN7w2j33w6G2zg66BD4VXANRu0IRMglNSSCqdfFk?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cedf609d-881a-4268-9df7-08db866e88c5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 02:35:50.3966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the guest side code of lazy tscdeadline. If the cpuid
tell us lazy tscdeadline is enabled, swtich .set_next_event to
lazy tscdeadline version. And Let's explain the core idea here.

Every time guest start or modify a hrtimer, we need to write the
msr of tsc deadline, a vm-exit occurs and host arms a hv or sw
timer for it. However, in some workload that needs setup timer
frequently, msr of tscdeadline is usually overwritten many times
before the timer expires.

w: write msr         x: vm-exit t:        hv or sw timer

1. write to msr with t1
Guest
         w1
---------------------------------------->  Time
Host     x1             t1
...

n. write to msr with tn
Guest
                    wn
------------------------------------------>  Time
Host                xn         tn-1 -> tn

What this patch want to do is to eliminate the vm-exit of x2 ... xn

Firstly, we have two fields shared between guest and host as other
pv features, saying,
 - armed, the value of tscdeadline that has a timer in host side,
   only updated by HOST side
 - pending, the next value of tscdeadline, only updated by GUEST
   side

1. write to msr with t1
     armed : t1     pending : t1
Guest
         w1
---------------------------------------->  Time
Host     x1             t1

vm-exit occurs and arms a timer for t1 in host side

2. write to msr with t2
    armed : t1      pending : t2
Guest
             w2
------------------------------------------>  Time
Host                     t1

the value of tsc deadline that has been armed, namely t1, is smaller
than t2, needn't to write to msr but just update pending to t2
dd
...
n.  write to msr with tn
    armed : t1      pending : tn
Guest
                      wn
------------------------------------------>  Time
Host                       t1

Similar with step 2, just update pending field with tn, no vm-exit

n+1.  t1 expires, arm tn
    armed : tn     pending : tn
Guest

------------------------------------------>  Time
Host                       t1  ------> tn

When we try to update the tscdeadline, if the 'pending' field is
smaller, then we know there is a pending timer, needn' to do msr
write.

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/kernel/apic/apic.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index af49e24..5aea74f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,6 +62,9 @@
 #include <asm/intel-family.h>
 #include <asm/irq_regs.h>
 #include <asm/cpu.h>
+#include <linux/kvm_para.h>
+
+DECLARE_PER_CPU_DECRYPTED(struct kvm_lazy_tscdeadline, kvm_lazy_tscdeadline);
 
 unsigned int num_processors;
 
@@ -495,6 +498,26 @@ static int lapic_next_deadline(unsigned long delta,
 	return 0;
 }
 
+static int kvm_lapic_next_deadline(unsigned long delta,
+			       struct clock_event_device *evt)
+{
+	struct kvm_lazy_tscdeadline *lazy_tscddl = this_cpu_ptr(&kvm_lazy_tscdeadline);
+	u64 tsc;
+
+	tsc =  rdtsc() + (((u64) delta) * TSC_DIVISOR);
+	lazy_tscddl->pending = tsc;
+	/*
+	 * There fence can have two functions:
+	 *  - avoid the wrmsrl is reordered
+	 *  - avoid the reorder of writing to pending and reading from armed
+	 */
+	weak_wrmsr_fence();
+	if (!lazy_tscddl->armed || tsc < lazy_tscddl->armed)
+		wrmsrl(MSR_IA32_TSC_DEADLINE, tsc);
+
+	return 0;
+}
+
 static int lapic_timer_shutdown(struct clock_event_device *evt)
 {
 	unsigned int v;
@@ -639,7 +662,12 @@ static void setup_APIC_timer(void)
 		levt->name = "lapic-deadline";
 		levt->features &= ~(CLOCK_EVT_FEAT_PERIODIC |
 				    CLOCK_EVT_FEAT_DUMMY);
-		levt->set_next_event = lapic_next_deadline;
+		if (kvm_para_available() &&
+		    kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE)) {
+			levt->set_next_event = kvm_lapic_next_deadline;
+		} else {
+			levt->set_next_event = lapic_next_deadline;
+		}
 		clockevents_config_and_register(levt,
 						tsc_khz * (1000 / TSC_DIVISOR),
 						0xF, ~0UL);
-- 
2.7.4

