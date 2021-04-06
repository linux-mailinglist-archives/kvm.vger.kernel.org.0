Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EAB354E0F
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244361AbhDFHlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237025AbhDFHlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:12 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367YA9l068718
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=PDvzVSLV3tmrkcFM0KBW8ORAUDODkbz4J8Att9R5QDE=;
 b=cj11lcDwsKIu/Thq1ieIWC2ESCUdh6UKJBK+Wj23TI/mp+NfNva3x3sLa98RJS1PGl4L
 rrwycsJfjtxoVWe3/0v6i+oOkj65CmKAn55R35xdF4aBR0mQTtza2tfgnd2b05K3/xhf
 bAtr4aX9rCxgPq9wRs7GtXqD3igiCIV8S1lmWti2Hoexh2EbYd9ctl80HKhP16Htmqdq
 yK/Tslbj75F0v1c+TytcWh/RGOTI6yG/+Q8/T/8MMvqbXxcbh7+nYv+H3c9OcXDgmZu+
 fglAVc8n7ubs5td1QVszQh4uEL0PmJJzm0tGWhKJijqRcngr0poY9izF1lHl/Ba8jkyS Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5eatcpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:04 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367Z42f070983
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:03 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5eatcnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:03 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367Wp27023881;
        Tue, 6 Apr 2021 07:41:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 37q2nkh0n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367exBo40632804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19CE74C066;
        Tue,  6 Apr 2021 07:40:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5BCB4C070;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 12/16] s390x: css: Check ORB reserved bits
Date:   Tue,  6 Apr 2021 09:40:49 +0200
Message-Id: <1617694853-6881-13-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TAHeBZWSoQ3IoZD2tuEDJhhM2u-kvmAS
X-Proofpoint-ORIG-GUID: 3L0EW-t4PfFbldcIRxl_IKsn-Mgafd7W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Several bits of the ORB are reserved and must be zero.
Their use will trigger a operand exception.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index 56adc16..26f5da6 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -209,6 +209,26 @@ static void ssch_orb_midaw(void)
 	orb->ctrl = tmp;
 }
 
+static void ssch_orb_ctrl(void)
+{
+	uint32_t tmp = orb->ctrl;
+	char buffer[80];
+	int i;
+
+	/* Check the reserved bits of the ORB CTRL field */
+	for (i = 26; i <= 30; i++) {
+		orb->ctrl |= (0x01 << (31 - i));
+		snprintf(buffer, 80, " %d", i);
+		report_prefix_push(buffer);
+		expect_pgm_int();
+		ssch(test_device_sid, orb);
+		check_pgm_int_code(PGM_INT_CODE_OPERAND);
+		report_prefix_pop();
+
+		orb->ctrl = tmp;
+	}
+}
+
 static struct tests ssh_tests[] = {
 	{ "privilege", ssch_privilege },
 	{ "orb cpa zero", ssch_orb_cpa_zero },
@@ -217,6 +237,7 @@ static struct tests ssh_tests[] = {
 	{ "CCW access", ssch_ccw_access },
 	{ "CCW in DMA31", ssch_ccw_dma31 },
 	{ "ORB MIDAW unsupported", ssch_orb_midaw },
+	{ "ORB reserved CTRL bits", ssch_orb_ctrl },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

