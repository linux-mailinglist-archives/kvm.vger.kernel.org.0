Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3E734E4D7
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 11:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhC3Jyg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 05:54:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23270 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231532AbhC3Jyd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 05:54:33 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12U9ZAMW116432;
        Tue, 30 Mar 2021 05:54:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2eBMrW9mnM2gqfh0RjvmWC9qvaBNL0v0jN+paynb+RA=;
 b=YgCvNuvLG+xwwesKKnn0r7xo04RYpdZcvv5n+3jKpMz9s8NjJsys0v0ut0AK7p6FlJ7c
 RqfVOYlGow696vOjjXspfQWFzN8sKVKMYHN7Br2eGiNCCD6oSbPdcOXeuwLbdhzA1tpw
 /UCKIBZ5wJl6DLLEF8ywVKVDcd0EnRjjwS75FrkQy8uNAMvJVNZktWE411l1Xxjkp+Rl
 hcGLqrCn+7tDMEjLdMnM42a3/ssEes68rNesHK38Q3csXiQzmXX/57rf5mHdq1BVr38A
 aiFJ58wfuPPYXwb5DB4w6E48TUOk98WRQBP3U/GQfkBzGO2BI0dE2RNzHZIRgW83RIzx ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsbkryd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 05:54:16 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12U9ZC9h116651;
        Tue, 30 Mar 2021 05:54:15 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsbkrxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 05:54:15 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12U9qc30029753;
        Tue, 30 Mar 2021 09:54:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 37hvb8jjv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Mar 2021 09:54:13 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12U9sA8h28639560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 09:54:10 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FF4652057;
        Tue, 30 Mar 2021 09:54:10 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.47.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0C6A652050;
        Tue, 30 Mar 2021 09:54:07 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: [PATCH v3 2/3] ppc: Rename current DAWR macros and variables
Date:   Tue, 30 Mar 2021 15:23:49 +0530
Message-Id: <20210330095350.36309-3-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
References: <20210330095350.36309-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CTql1mEyrWdvEGZTaMQdS8fnWV9SzUvb
X-Proofpoint-GUID: e391RhrLAu4GVysH1KnRkDSMoleS7Hgv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_03:2021-03-26,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300066
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
index 47cebaf3ac..b8985fab5b 100644
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
index e73416da68..cd02d65303 100644
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
index c03a7c4f52..879e6df217 100644
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
2.17.1

