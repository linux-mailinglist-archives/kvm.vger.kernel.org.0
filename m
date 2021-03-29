Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9335A34C274
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 06:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhC2EUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 00:20:54 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36146 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229515AbhC2EUh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 00:20:37 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T43OlH184154;
        Mon, 29 Mar 2021 00:20:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UlOYQh0xrOiJWWEAVUUpMtPgdQv5oD1iL6P8r1YTUdM=;
 b=PiQBV9neOtDZCgPTURWqRvLLyC0Plp8IyMKF7/D/Qwu/B16ne1l0kabY0b6LcS3ZKwgS
 0ZlfjhNGUO5BwjflLzvM49S70E5FVc5l4QZQZJr1fRQPbxztvYniuyv5J2dzGTx/ONmr
 mHR0xn06BIoZ1mmKEa/g+/K8RnYnhafxFYTOpQJluKTpPioOFrzmeqgqBp9paX9yyn+b
 e58bllQ9YyywT+VSBVTzjzBiR44UrBzquII0UZpQ535Q3NU3isG3UXtdylviQA1V3903
 CRHaD+fFX/XHPJ/kf5U4SFVR9liqYULGqrHGn3HRDf5SElsah0+B8zA4/5tMZVVoOPN3 Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpmdxtp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 00:20:08 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12T4K8jB038234;
        Mon, 29 Mar 2021 00:20:08 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jpmdxtnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 00:20:07 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12T4HcLT013743;
        Mon, 29 Mar 2021 04:20:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 37hvb88rqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 04:20:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12T4K3mB35914188
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 04:20:03 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69BE04C046;
        Mon, 29 Mar 2021 04:20:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D1064C040;
        Mon, 29 Mar 2021 04:20:00 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.34.103])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 04:19:59 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: [PATCH v2 2/3] ppc: Rename current DAWR macros and variables
Date:   Mon, 29 Mar 2021 09:49:05 +0530
Message-Id: <20210329041906.213991-3-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329041906.213991-1-ravi.bangoria@linux.ibm.com>
References: <20210329041906.213991-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YGzGQgf93cqCSByohU3-rJaZmY9T4H9O
X-Proofpoint-ORIG-GUID: Ym493j6HYImBSvLOcp0vF3bqvOU5kQep
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_02:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290029
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Power10 is introducing second DAWR. Use real register names (with
suffix 0) from ISA for current macros and variables used by Qemu.

One exception to this is KVM_REG_PPC_DAWR[X]. This is from kernel
uapi header and thus not changed in kernel as well as Qemu.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 include/hw/ppc/spapr.h          | 2 +-
 target/ppc/cpu.h                | 4 ++--
 target/ppc/translate_init.c.inc | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 47cebaf..b8985fa 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -363,7 +363,7 @@ struct SpaprMachineState {
 
 /* Values for 2nd argument to H_SET_MODE */
 #define H_SET_MODE_RESOURCE_SET_CIABR           1
-#define H_SET_MODE_RESOURCE_SET_DAWR            2
+#define H_SET_MODE_RESOURCE_SET_DAWR0           2
 #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
 #define H_SET_MODE_RESOURCE_LE                  4
 
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index e73416d..cd02d65 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1459,10 +1459,10 @@ typedef PowerPCCPU ArchCPU;
 #define SPR_MPC_BAR           (0x09F)
 #define SPR_PSPB              (0x09F)
 #define SPR_DPDES             (0x0B0)
-#define SPR_DAWR              (0x0B4)
+#define SPR_DAWR0             (0x0B4)
 #define SPR_RPR               (0x0BA)
 #define SPR_CIABR             (0x0BB)
-#define SPR_DAWRX             (0x0BC)
+#define SPR_DAWRX0            (0x0BC)
 #define SPR_HFSCR             (0x0BE)
 #define SPR_VRSAVE            (0x100)
 #define SPR_USPRG0            (0x100)
diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_init.c.inc
index c03a7c4..879e6df 100644
--- a/target/ppc/translate_init.c.inc
+++ b/target/ppc/translate_init.c.inc
@@ -7748,12 +7748,12 @@ static void gen_spr_book3s_dbg(CPUPPCState *env)
 
 static void gen_spr_book3s_207_dbg(CPUPPCState *env)
 {
-    spr_register_kvm_hv(env, SPR_DAWR, "DAWR",
+    spr_register_kvm_hv(env, SPR_DAWR0, "DAWR0",
                         SPR_NOACCESS, SPR_NOACCESS,
                         SPR_NOACCESS, SPR_NOACCESS,
                         &spr_read_generic, &spr_write_generic,
                         KVM_REG_PPC_DAWR, 0x00000000);
-    spr_register_kvm_hv(env, SPR_DAWRX, "DAWRX",
+    spr_register_kvm_hv(env, SPR_DAWRX0, "DAWRX0",
                         SPR_NOACCESS, SPR_NOACCESS,
                         SPR_NOACCESS, SPR_NOACCESS,
                         &spr_read_generic, &spr_write_generic,
-- 
2.7.4

