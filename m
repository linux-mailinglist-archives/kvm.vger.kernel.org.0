Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51EBDE025E
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 12:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730166AbfJVKxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 06:53:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5584 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730556AbfJVKxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 06:53:13 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9MAldTD048195
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:53:12 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vsx14w71e-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:53:12 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 22 Oct 2019 11:53:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 22 Oct 2019 11:53:07 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9MAr6HW40370218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 10:53:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E45FF52052;
        Tue, 22 Oct 2019 10:53:05 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 9FDD252050;
        Tue, 22 Oct 2019 10:53:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 3/5] s390x: sclp: expose ram_size and max_ram_size
Date:   Tue, 22 Oct 2019 12:53:02 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102210-0012-0000-0000-0000035B6D1C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102210-0013-0000-0000-0000219697A1
Message-Id: <1571741584-17621-4-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910220098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose ram_size and max_ram_size through accessor functions.

We only use get_ram_size in an upcoming patch, but having an accessor
for the other one does not hurt.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 lib/s390x/sclp.h | 2 ++
 lib/s390x/sclp.c | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index f00c3df..6d40fb7 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -272,5 +272,7 @@ void sclp_console_setup(void);
 void sclp_print(const char *str);
 int sclp_service_call(unsigned int command, void *sccb);
 void sclp_memory_setup(void);
+uint64_t get_ram_size(void);
+uint64_t get_max_ram_size(void);
 
 #endif /* SCLP_H */
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 56fca0c..a57096c 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -167,3 +167,12 @@ void sclp_memory_setup(void)
 
 	mem_init(ram_size);
 }
+
+uint64_t get_ram_size(void)
+{
+	return ram_size;
+}
+uint64_t get_max_ram_size(void)
+{
+	return max_ram_size;
+}
-- 
2.7.4

