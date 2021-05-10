Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D953791F5
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbhEJPGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:06:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43191 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232772AbhEJPDQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 11:03:16 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AEaE0v148725;
        Mon, 10 May 2021 11:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qmWTO6Jpcomzj7wYTwIK2pecoL7VSoFFO1RSCnOZ0J8=;
 b=slW+KlkyDAzDiZXi4fSODKZOHjLGXgRB1enLVkZlpEXHZHH91H2Gk6c2thtBCrw4Isq8
 rKW8asMIyrgFMfAkr6ROAMiPXouAjVjBl/O2xRu7bhUJBGynOc5j4Td2jEhBXjsVgBui
 lEri/KG+m9oQ0NmZ3x5Zruyz5fYFWiLI0x1ck+ALOhAnB98WfccpHo8mWPEBrliVwyo8
 xjrCYG9/GIenQXmxZ378G2LiSYid4qowLCVkh8EPIEntjBKwAnZ4eg1Owe/jnvLV1FQ5
 rZDWr5LxqdbjxkduHcE/xt625bZ2qxrmCz0bHPJae1ZDocEOxb/ih+dgdgMEoRHtZSS2 Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3dbf2hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AEaVdd151054;
        Mon, 10 May 2021 11:02:08 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3dbf2gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:08 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AErOBv009509;
        Mon, 10 May 2021 15:02:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 38dj988jgs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 15:02:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AF1xUg33620304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 15:01:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64577AE053;
        Mon, 10 May 2021 15:01:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A27AFAE051;
        Mon, 10 May 2021 15:01:58 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 15:01:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH 4/4] s390x: cpumodel: FMT2 SCLP implies test
Date:   Mon, 10 May 2021 15:00:15 +0000
Message-Id: <20210510150015.11119-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210510150015.11119-1-frankja@linux.ibm.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X5LFWpYHUIDedv5t-2FnRQTpmJPFJDII
X-Proofpoint-ORIG-GUID: lj9rlZBJ77BCqqK6f3PjhDrCkp1R4_TN
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The sie facilities require sief2 to also be enabled, so lets check if
that's the case.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/cpumodel.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
index 619c3dc7..67bb6543 100644
--- a/s390x/cpumodel.c
+++ b/s390x/cpumodel.c
@@ -56,12 +56,24 @@ static void test_sclp_features_fmt4(void)
 	report_prefix_pop();
 }
 
+static void test_sclp_features_fmt2(void)
+{
+	if (sclp_facilities.has_sief2)
+		return;
+
+	report_prefix_push("!sief2 implies");
+	test_sclp_missing_sief2_implications();
+	report_prefix_pop();
+}
+
 static void test_sclp_features(void)
 {
 	report_prefix_push("sclp");
 
 	if (uv_os_is_guest())
 		test_sclp_features_fmt4();
+	else
+		test_sclp_features_fmt2();
 
 	report_prefix_pop();
 }
-- 
2.30.2

