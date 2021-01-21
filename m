Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAB2FEE4D
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732494AbhAUPSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:18:47 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732667AbhAUPPr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:15:47 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LF3Glm103071;
        Thu, 21 Jan 2021 10:15:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=c+fsPbzkg+LCngvnZRAef2u+KiCv5D0R9OnF/tRwNg4=;
 b=NKNDEetSB3M4l0AG0jg/Td2jf1iPfl+ZoKiZizdkdeCMUwpsw9rvIM9zjYMZcNblrawf
 JH8W2pzB2uZPqy17BBIoS9gwHUn4VUEwwlSxH2cGzLMG8vE/T4UwuRoc6Sf0wW8OxF5v
 22H6TdI+4t8DIz6qtuDpqtQRcVhR6E5LmtAcpbT7l3sd5XdmUDZn86uB8h9PQ1N6OJYc
 Z5edUhK4uJa82CC2iIpOQ3iV311i0PyaPF1wR3HNo9+GA8rP4HMnSI3dvPQKij6XsK5C
 Q9pcLictoZl2BZcBPUsfQfn9fIDHga0/i8WPM0I+8ZdfWmbxxDbuVrpJ84hK7dmGhY9M RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367br510ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:15:05 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LF3HlK103102;
        Thu, 21 Jan 2021 10:15:05 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367br510hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:15:05 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LFD2dG018595;
        Thu, 21 Jan 2021 15:15:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwss45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 15:15:02 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LFF0bC13893896
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:15:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E033811C050;
        Thu, 21 Jan 2021 15:14:59 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D02CC11C052;
        Thu, 21 Jan 2021 15:14:58 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 15:14:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: [PATCH v2 1/2] s390: uv: Fix sysfs max number of VCPUs reporting
Date:   Thu, 21 Jan 2021 10:14:34 -0500
Message-Id: <20210121151436.417240-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121151436.417240-1-frankja@linux.ibm.com>
References: <20210121151436.417240-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_08:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The number reported by the query is N-1 and I think people reading the
sysfs file would expect N instead. For users creating VMs there's no
actual difference because KVM's limit is currently below the UV's
limit.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: a0f60f8431999 ("s390/protvirt: Add sysfs firmware interface for Ultravisor information")
Cc: stable@vger.kernel.org
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
---
 arch/s390/boot/uv.c        | 2 +-
 arch/s390/include/asm/uv.h | 4 ++--
 arch/s390/kernel/uv.c      | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index a15c033f53ca..87641dd65ccf 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -35,7 +35,7 @@ void uv_query_info(void)
 		uv_info.guest_cpu_stor_len = uvcb.cpu_stor_len;
 		uv_info.max_sec_stor_addr = ALIGN(uvcb.max_guest_stor_addr, PAGE_SIZE);
 		uv_info.max_num_sec_conf = uvcb.max_num_sec_conf;
-		uv_info.max_guest_cpus = uvcb.max_guest_cpus;
+		uv_info.max_guest_cpu_id = uvcb.max_guest_cpu_id;
 	}
 
 #ifdef CONFIG_PROTECTED_VIRTUALIZATION_GUEST
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0325fc0469b7..7b98d4caee77 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -96,7 +96,7 @@ struct uv_cb_qui {
 	u32 max_num_sec_conf;
 	u64 max_guest_stor_addr;
 	u8  reserved88[158 - 136];
-	u16 max_guest_cpus;
+	u16 max_guest_cpu_id;
 	u8  reserveda0[200 - 160];
 } __packed __aligned(8);
 
@@ -273,7 +273,7 @@ struct uv_info {
 	unsigned long guest_cpu_stor_len;
 	unsigned long max_sec_stor_addr;
 	unsigned int max_num_sec_conf;
-	unsigned short max_guest_cpus;
+	unsigned short max_guest_cpu_id;
 };
 
 extern struct uv_info uv_info;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 883bfed9f5c2..b2d2ad153067 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -368,7 +368,7 @@ static ssize_t uv_query_max_guest_cpus(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *page)
 {
 	return scnprintf(page, PAGE_SIZE, "%d\n",
-			uv_info.max_guest_cpus);
+			uv_info.max_guest_cpu_id + 1);
 }
 
 static struct kobj_attribute uv_query_max_guest_cpus_attr =
-- 
2.25.1

