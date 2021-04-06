Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E33F354E10
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbhDFHlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235491AbhDFHlM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:12 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367YAH5068691
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Z9ypbj+UeivAzjmDgCPVYWQufBUsOBXwfTgtlzp+LRM=;
 b=AaAlLQ13CLbzvyR7ror06xkcLj3M8zAn5GCqSeXsmJbedrz/3/shibR9Lvf9ON19fhso
 EUKBh+0ZsKLAklrriUk9d4AJJg3Abs0sBTnVin0eV+agBY5hJCfo/zKMCpfcGdXlTkv6
 yTeoKHxLlZb5+wNgW0Ta9+iUtMbjAV+MDYC5JX3JEUpsdxZHZUyW84AZPOjpBHFH7ndW
 5bfrlc44McShbXzwz2smCtDuOnxvgSK2S8kx4FXwRTIjjYzgMBhdF7EWJ4nNzYVvPvvI
 Tt1kgyAQTNDpo9TbNhQ4TOI3wjKMCGq3qvwl6u4XpFE3CbGk9DufP1Y0xneCMwSnOTkv jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5eatcqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:04 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367Y8Ww068551
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:04 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5eatcpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367WdQI026032;
        Tue, 6 Apr 2021 07:41:02 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 37q2q5hwxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:41:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367exrf25166106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:41:00 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEB964C06D;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85F3B4C04E;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:58 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 11/16] s390x: css: No support for MIDAW
Date:   Tue,  6 Apr 2021 09:40:48 +0200
Message-Id: <1617694853-6881-12-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QJ-2BnH2I_PqK4bgYasuv-X4Pq4NDnhV
X-Proofpoint-ORIG-GUID: ZR3T2dfx6ZQvmmlgXOO4LFnTa_rc-t77
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=923 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verify that using MIDAW triggers a operand exception.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 s390x/css.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/s390x/css.c b/s390x/css.c
index f8f91cf..56adc16 100644
--- a/s390x/css.c
+++ b/s390x/css.c
@@ -197,6 +197,18 @@ static void ssch_ccw_dma31(void)
 	free_pages(ccw_high);
 }
 
+static void ssch_orb_midaw(void)
+{
+	uint32_t tmp = orb->ctrl;
+
+	orb->ctrl |= ORB_CTRL_MIDAW;
+	expect_pgm_int();
+	ssch(test_device_sid, orb);
+	check_pgm_int_code(PGM_INT_CODE_OPERAND);
+
+	orb->ctrl = tmp;
+}
+
 static struct tests ssh_tests[] = {
 	{ "privilege", ssch_privilege },
 	{ "orb cpa zero", ssch_orb_cpa_zero },
@@ -204,6 +216,7 @@ static struct tests ssh_tests[] = {
 	{ "data access", ssch_data_access },
 	{ "CCW access", ssch_ccw_access },
 	{ "CCW in DMA31", ssch_ccw_dma31 },
+	{ "ORB MIDAW unsupported", ssch_orb_midaw },
 	{ NULL, NULL }
 };
 
-- 
2.17.1

