Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F433E7D67
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 18:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbhHJQWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 12:22:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13170 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230052AbhHJQWy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 12:22:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17AG4VhB055940;
        Tue, 10 Aug 2021 12:22:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=TqEb3YXVdmvtihnv3Ts1FELMlkG3VUAx9t44xwZUj2w=;
 b=Gligt6y7kxgUNflsYZ5mQKCITlM/wPEHZptvPwUaam6YsbDV+jp0LzoPKOWx/D3u+1fD
 gBsw1/ae2tOoiJo3Yt4Zvi05IXEBUt4EdDEU6UoGi8OkETFnGIt3RFSnVStN8C0sv3Hg
 vh44LWfcpPXr8JXygOdfm2Acg/qzBggjHmLim7PjzoS9IjEtnvHB1qW1Tg8EgGPBxpSG
 MRhb5FKNVJoTh2Lu+Cv1hDG4iU3ww6guH+3Hh+FMV7UqqJcajdFtjne7p+2GYY5zo4F9
 QUlBy+CXa6X1Nb8iDfRd1NQ94Ad+2cO9uxQ+WrJYh9yHZegJjq8kbETtzW4gwLDdZCJX Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abr2us9a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:32 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17AG5DE0058632;
        Tue, 10 Aug 2021 12:22:31 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3abr2us99f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 12:22:31 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17AGGHTp001173;
        Tue, 10 Aug 2021 16:22:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3a9ht8xe2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Aug 2021 16:22:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17AGMQ2d41419210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 16:22:26 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D282AE057;
        Tue, 10 Aug 2021 16:22:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9890AE045;
        Tue, 10 Aug 2021 16:22:25 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.176.19])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Aug 2021 16:22:25 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v2 1/4] s390x: lib: Add SCLP toplogy nested level
Date:   Tue, 10 Aug 2021 18:22:21 +0200
Message-Id: <1628612544-25130-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
References: <1628612544-25130-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oJXqtzi4WfjqGMGPfb-40zqxXlvWCoCN
X-Proofpoint-ORIG-GUID: yjHafdrkRrcdiLLW6dhEdk_AlDycSJX8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_07:2021-08-10,2021-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum CPU Topology nested level is available with the SCLP
READ_INFO command inside the byte at offset 15 of the ReadInfo
structure.

Let's return this information to check the number of topology nested
information available with the STSI 15.1.x instruction.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/sclp.c | 6 ++++++
 lib/s390x/sclp.h | 4 +++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 9502d161..ee379ddf 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -123,6 +123,12 @@ int sclp_get_cpu_num(void)
 	return read_info->entries_cpu;
 }
 
+int sclp_get_stsi_parm(void)
+{
+	assert(read_info);
+	return read_info->stsi_parm;
+}
+
 CPUEntry *sclp_get_cpu_entries(void)
 {
 	assert(read_info);
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 28e526e2..1a365958 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -146,7 +146,8 @@ typedef struct ReadInfo {
 	SCCBHeader h;
 	uint16_t rnmax;
 	uint8_t rnsize;
-	uint8_t  _reserved1[16 - 11];       /* 11-15 */
+	uint8_t  _reserved1[15 - 11];       /* 11-14 */
+	uint8_t stsi_parm;
 	uint16_t entries_cpu;               /* 16-17 */
 	uint16_t offset_cpu;                /* 18-19 */
 	uint8_t  _reserved2[24 - 20];       /* 20-23 */
@@ -322,6 +323,7 @@ void sclp_console_setup(void);
 void sclp_print(const char *str);
 void sclp_read_info(void);
 int sclp_get_cpu_num(void);
+int sclp_get_stsi_parm(void);
 CPUEntry *sclp_get_cpu_entries(void);
 void sclp_facilities_setup(void);
 int sclp_service_call(unsigned int command, void *sccb);
-- 
2.25.1

