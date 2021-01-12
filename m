Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058932F318B
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387429AbhALNWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:22:06 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733164AbhALNWD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:22:03 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CD4bx3160665;
        Tue, 12 Jan 2021 08:21:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=z0KUrILbnCB/14DwbsiY2AomilgKtDh1jKZtYPRzXH8=;
 b=ThAdNU+ky9NjR6/wb/V4qy+Alt1IGfia//VmA1K8HxkgE/5BA2wfcpX5jKs3K/paLO3F
 WCqo3006pRLxy05GTpIsLjsXz9zXc+M8/x/us8Q7S9x7P/xOkqX844OYHb4yBJn2YIwk
 1rAsQetIpOiXbsMAooxDpPAxkdUkextvYQO+Jb63kxaAroqgMByI7a0wECXXE3kirt+B
 5b2+Smr6zAnXxn9quGmB576O1ZmjrgkFnN/yDfbPrQe3y9aT+Uz+DObltDQeXjY0sZ5q
 VKmPMTjc/8mf64sRi/0EZ5ScKgUv0VQR/5jqDmNYUak09zu5EVlC6WCTdyKL8zfotO2Y 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361c19h7he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:23 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CD56hD163582;
        Tue, 12 Jan 2021 08:21:22 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361c19h7gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:22 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDIE7b026421;
        Tue, 12 Jan 2021 13:21:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 35y448bp1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDLHNP46530840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AFCA24C04E;
        Tue, 12 Jan 2021 13:21:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEF4A4C044;
        Tue, 12 Jan 2021 13:21:16 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:16 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 9/9] s390x: sclp: Add CPU entry offset comment
Date:   Tue, 12 Jan 2021 08:20:54 -0500
Message-Id: <20210112132054.49756-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's make it clear that there is something at the end of the
struct. The exact offset is reported by the cpu_offset member.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index dccbaa8..395895f 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -134,7 +134,10 @@ typedef struct ReadInfo {
 	uint8_t reserved7[134 - 128];
 	uint8_t byte_134_diag318 : 1;
 	uint8_t : 7;
-	struct CPUEntry entries[0];
+	/*
+	 * The cpu entries follow, they start at the offset specified
+	 * in offset_cpu.
+	 */
 } __attribute__((packed)) ReadInfo;
 
 typedef struct ReadCpuInfo {
-- 
2.25.1

