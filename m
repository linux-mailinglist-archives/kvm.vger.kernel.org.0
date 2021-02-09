Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139E6315223
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhBIOzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 09:55:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232024AbhBIOzL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 09:55:11 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119EWNlr143174;
        Tue, 9 Feb 2021 09:54:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+FmDDaA5hoHJ6i2g8KzTG8V/MIMxanpp0BjaLySOiYw=;
 b=O+UXUY/kI5DIuDgt4DDnQOCYbtKzIR34OnYPJwypzaGwoojbID+c5TAF4yBw/eb00i6i
 06lhnhocu7aT2P7TrG1KB9qjInxBUcDpJ8qvR/DU1L16pLNKyob4S3Xs7vQbrMJb9wy3
 fB5szmKAe4kBVzRfSUoWgOgovsHUQqpg+K/clSj53O9lmqsOimKj4jm1X2PmrhEkslRn
 jVJ8oert6YZpwTIQlh1Ajx2jnuV9hjgMZeQVppesMnZvTKX/HdSBHflnBj/gEqZ0fNjO
 5NJaYK1DxTGL6yEFncSjMG/59d1nlAoryWd2Aff9VQrNIa2RAzEmkcbLKyN8hfRHmJEI uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kuh32rqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 09:54:30 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119EYp0n008708;
        Tue, 9 Feb 2021 09:54:30 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kuh32rnf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 09:54:30 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119EXhTA031396;
        Tue, 9 Feb 2021 14:38:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 36hjr81sc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 14:38:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119EcaYp22937980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 14:38:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DD0711C04C;
        Tue,  9 Feb 2021 14:38:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FDB411C05B;
        Tue,  9 Feb 2021 14:38:36 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.1.216])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 14:38:36 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/4] libcflat: add SZ_1M and SZ_2G
Date:   Tue,  9 Feb 2021 15:38:32 +0100
Message-Id: <20210209143835.1031617-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=974 clxscore=1015
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add SZ_1M and SZ_2G to libcflat.h

s390x needs those for large/huge pages

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/libcflat.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libcflat.h b/lib/libcflat.h
index 460a1234..8dac0621 100644
--- a/lib/libcflat.h
+++ b/lib/libcflat.h
@@ -157,7 +157,9 @@ extern void setup_vm(void);
 #define SZ_8K			(1 << 13)
 #define SZ_16K			(1 << 14)
 #define SZ_64K			(1 << 16)
+#define SZ_1M			(1 << 20)
 #define SZ_2M			(1 << 21)
 #define SZ_1G			(1 << 30)
+#define SZ_2G			(1ul << 31)
 
 #endif
-- 
2.26.2

