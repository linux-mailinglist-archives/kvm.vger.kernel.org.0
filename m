Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9401D223E48
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 16:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgGQOjK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:39:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12670 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728023AbgGQOjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 10:39:08 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HEUlIX056793;
        Fri, 17 Jul 2020 10:38:56 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32b61k6dv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:38:56 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06HEasI5012140;
        Fri, 17 Jul 2020 14:38:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 328rbqt6s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 14:38:54 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06HEcpDU59244622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:38:51 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4C6F4C040;
        Fri, 17 Jul 2020 14:38:51 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC5564C046;
        Fri, 17 Jul 2020 14:38:48 +0000 (GMT)
Received: from localhost.localdomain.localdomain (unknown [9.77.207.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 14:38:48 +0000 (GMT)
From:   Athira Rajeev <atrajeev@linux.vnet.ibm.com>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        mikey@neuling.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org
Subject: [v3 06/15] powerpc/xmon: Add PowerISA v3.1 PMU SPRs
Date:   Fri, 17 Jul 2020 10:38:18 -0400
Message-Id: <1594996707-3727-7-git-send-email-atrajeev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=724 adultscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=1 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Madhavan Srinivasan <maddy@linux.ibm.com>

PowerISA v3.1 added three new perfromance
monitoring unit (PMU) speical purpose register (SPR).
They are Monitor Mode Control Register 3 (MMCR3),
Sampled Instruction Event Register 2 (SIER2),
Sampled Instruction Event Register 3 (SIER3).

Patch here adds a new dump function dump_310_sprs
to print these SPR values.

Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
---
 arch/powerpc/xmon/xmon.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 7efe4bc..16f5493 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -2022,6 +2022,18 @@ static void dump_300_sprs(void)
 #endif
 }
 
+static void dump_310_sprs(void)
+{
+#ifdef CONFIG_PPC64
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
+		return;
+
+	printf("mmcr3  = %.16lx, sier2  = %.16lx, sier3  = %.16lx\n",
+		mfspr(SPRN_MMCR3), mfspr(SPRN_SIER2), mfspr(SPRN_SIER3));
+
+#endif
+}
+
 static void dump_one_spr(int spr, bool show_unimplemented)
 {
 	unsigned long val;
@@ -2076,6 +2088,7 @@ static void super_regs(void)
 		dump_206_sprs();
 		dump_207_sprs();
 		dump_300_sprs();
+		dump_310_sprs();
 
 		return;
 	}
-- 
1.8.3.1

