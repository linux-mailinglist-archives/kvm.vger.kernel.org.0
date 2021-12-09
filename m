Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FD346E94F
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 14:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbhLINtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 08:49:39 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238128AbhLINtg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 08:49:36 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9DRW12007001;
        Thu, 9 Dec 2021 13:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=hkD3Hz5z0C5vZKNiVyF82tkZKrIyICsKZzPX/c931d0=;
 b=iRMu1y+qhf4mR0UoWhWplKf5psX4K2SIE0Mm9PLCjiMGg1XRTmLrmZY7qFHtyV8K5Yva
 O9F8hJ9oCGTLqcBONaMT9iSbd1C304TeOuXA0ds+cjqADFqx3lW+kDWEPpSqHju1J7VI
 MJ6VfulAviS5AkL/Ik2dFSYD02n4lSPz48znhSgcE3ube4gF9NH4V7CloNlMnMJYksIP
 FBNSsuEs4gpw/QNX9Z7yWoLx6YIbZpR+0Y3J7Vk6RpWGqOMTWkEzHVK69XzPsXzSNlcC
 Us1ZLF0wkV09576a3tglquBO8DcwQpTH0yxHEUWcw27Ty3iMhjeXO0aGsNwWtxHv9vr6 WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cujpygc6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:53 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B9DgEZV029318;
        Thu, 9 Dec 2021 13:45:53 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cujpygc68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:53 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Dj9nn026047;
        Thu, 9 Dec 2021 13:45:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3cqykjt0jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Dec 2021 13:45:50 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B9DjlII15204624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Dec 2021 13:45:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48E2E11C05B;
        Thu,  9 Dec 2021 13:45:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A68611C050;
        Thu,  9 Dec 2021 13:45:46 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.63.16])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Dec 2021 13:45:46 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, philmd@redhat.com, eblake@redhat.com,
        armbru@redhat.com
Subject: [PATCH v5 01/12] s390x: cpu topology: update linux headers
Date:   Thu,  9 Dec 2021 14:46:32 +0100
Message-Id: <20211209134643.143866-2-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211209134643.143866-1-pmorel@linux.ibm.com>
References: <20211209134643.143866-1-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CqCOUsF5DaoRBVFU5ZgEfcuCDJu07ZsM
X-Proofpoint-GUID: hNsTycwQy9_En45a04dsTsaWXdN4Yqjh
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-09_04,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch is only here to facilitate the review and the testing.
It should be updated from the Linux sources when available.
The current Linux patch can be found at:

https://lkml.org/lkml/2021/11/22/361

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 linux-headers/linux/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index bcaf66cc4d..940289c52d 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1112,6 +1112,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_S390_CPU_TOPOLOGY 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.27.0

