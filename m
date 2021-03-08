Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220C63310DC
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhCHOdy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:33:54 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229697AbhCHOdn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:33:43 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EWm8m160963;
        Mon, 8 Mar 2021 09:33:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZbIWr2J5ANlQOhmjQRW2nFD7roJ7b7up328UAGygTxM=;
 b=EG779/VFjSWtn9KspTAxo1BnFRuyVYT32+3OgUgqnkKETFW/41VRQOmT4M0HbzWgg5io
 njqyXC+CpurpVAOeWBjxOrymYGgypGxMR2vlwtxb+WsMwKj4Gdq3SSSUPDKoBQfSLevZ
 /3Z7Kq9KWopC8e27Wc/DRTCURyTPjtVv/hxab7K8M8Bk34NIzo+iVI1P0sXM9FJYifI7
 u9lUvxqxNCD52lnqHFdEXSDc4VC62johVpg73Q3AHLiSd0JwB8EAlWAs2yGgPZJuGAMP
 ev7hPxGKi9aU3e0S006T9X8ZbUsiZPnk5Y7+vN4gTlTWu497V6cIunfTFPT44SDT6YVb ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375nsk80rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:42 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EXgqY167220;
        Mon, 8 Mar 2021 09:33:42 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375nsk80qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:33:42 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EX56U012033;
        Mon, 8 Mar 2021 14:33:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3741c8901x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:40 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXbWT41419044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64CB3A404D;
        Mon,  8 Mar 2021 14:33:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0319CA4040;
        Mon,  8 Mar 2021 14:33:37 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 01/16] lib/s390x/sclp: Clarify that the CPUEntry array could be at a different spot
Date:   Mon,  8 Mar 2021 15:31:32 +0100
Message-Id: <20210308143147.64755-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

The "struct CPUEntry entries[0]" in the ReadInfo structure is misleading
since the entries could be at a completely different spot. Replace it
by a proper comment instead.

Signed-off-by: Thomas Huth <thuth@redhat.com>
Message-Id: <20210121065703.561444-1-thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 9f81c0f1..85231333 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -131,10 +131,15 @@ typedef struct ReadInfo {
 	uint16_t highest_cpu;
 	uint8_t  _reserved5[124 - 122];     /* 122-123 */
 	uint32_t hmfai;
-	uint8_t reserved7[134 - 128];
+	uint8_t reserved7[134 - 128];       /* 128-133 */
 	uint8_t byte_134_diag318 : 1;
 	uint8_t : 7;
-	struct CPUEntry entries[0];
+	/*
+	 * At the end of the ReadInfo, there are also the CPU entries (see
+	 * struct CPUEntry). When the Extended-Length SCCB (ELS) feature is
+	 * enabled, the start of the CPU entries array begins at an offset
+	 * denoted by the offset_cpu field, otherwise it's at offset 128.
+	 */
 } __attribute__((packed)) ReadInfo;
 
 typedef struct ReadCpuInfo {
-- 
2.29.2

