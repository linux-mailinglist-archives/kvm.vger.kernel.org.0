Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3C63ED6C4
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhHPNYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:24:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3360 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239406AbhHPNVw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 09:21:52 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GD2rYS125242;
        Mon, 16 Aug 2021 09:21:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uEaLK6nDUpygQq0Ox9juFF9OKFUA0vk5HyRQwUtpNCg=;
 b=VrjMFDiKYZwO5AyhyMqDzLQ/VHgkgpBqstR5mkYzGQEOmgXCtbIjd0ILX3rQjT6UYfAX
 1RWJYSSS8Of79+9xMIr9v8xPQHoZpWtMA44vjEo0XlLG22qGix/VIIG+YpCOqotCR4S0
 AtGHU6UkKMzBh0J9I/m0ePsUOGX7G/Ohgv/uDCx1bFAbWVJqG+Ul/O2euQJ5mFi58I7G
 5rFf+j/NGH2FmKWbfHGzS52eWmq20uOyG3f8Gi+YpVrPVhofOr8XezpIZmi5qIMII6JT
 1JNgqI48VTe0zgDnWnSR1z9lnLl1GY/A9Keoo/iGqh8FDEnofj/tRbe7NCaYfQ+gwLmH zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeu59f0vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:20 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GD39lI127376;
        Mon, 16 Aug 2021 09:21:20 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aeu59f0uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 09:21:20 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GDCnKx020365;
        Mon, 16 Aug 2021 13:21:18 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3ae5f8ba03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 13:21:18 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GDHqe358982876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 13:17:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7479011C04C;
        Mon, 16 Aug 2021 13:21:15 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D966211C058;
        Mon, 16 Aug 2021 13:21:14 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.144.221])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 13:21:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 10/11] lib: s390x: uv: Add rc 0x100 query error handling
Date:   Mon, 16 Aug 2021 15:20:53 +0200
Message-Id: <20210816132054.60078-11-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816132054.60078-1-frankja@linux.ibm.com>
References: <20210816132054.60078-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9s3Gby-tHnFFGF6LbQm7zbZYtj_Sjf_F
X-Proofpoint-GUID: oFDEu4Peau82j3B2pHBBlO8-gyXjy6Qz
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_04:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's not get bitten by an extension of the query struct and handle
the rc 0x100 error properly which does indicate that the UV has more
data for us.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/uv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index fd9de944..c5c69c47 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -49,6 +49,8 @@ int uv_setup(void)
 	if (!test_facility(158))
 		return 0;
 
-	assert(!uv_call(0, (u64)&uvcb_qui));
+	uv_call(0, (u64)&uvcb_qui);
+
+	assert(uvcb_qui.header.rc == 1 || uvcb_qui.header.rc == 0x100);
 	return 1;
 }
-- 
2.31.1

