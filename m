Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5193C4788F6
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 11:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233421AbhLQKcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 05:32:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52590 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233340AbhLQKcD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 05:32:03 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH953lG012338;
        Fri, 17 Dec 2021 10:32:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mIJ4ScjN7+s12MvsaXIUS4vFDYAd2KI/9ZUWSdbJW5o=;
 b=EDf7xN7aqa598hItLsJNvRTpa7DSohZDbJ3xF6fADpYdQzl6NY7iHdnzvLaQOyyvNtyM
 7TkPb2e5lEPzPc+IE2BUATIl2uNXn+4BJfVy43sLrZKejwGR0dUmoazs5FJHqxXjvL7V
 +vLMzOLc/jLnJPyCK4kU5HoOmSfM1qPDPk/A56HjuoxiXabtC8VE8vJTJNVpaHi+iN2p
 wNa7vnDoCmyEf02jfe7VYvkon/mlidFimU13hWhbadBHNnzGqgZO6KDUkwa9ZCiC4qWJ
 f5t7Ki7aU/aTxdoFGTkFQ2/Dl0zYx3U/6AFU3LIkL8PmmhI/siLJSLHSumtv77sjgopk 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyq8vhsjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:32:02 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BH9TaAI016057;
        Fri, 17 Dec 2021 10:32:01 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cyq8vhsj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:32:01 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHABpUw003612;
        Fri, 17 Dec 2021 10:31:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3cy7qwg52e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 10:31:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHAVtHE38207822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 10:31:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DF7EA406B;
        Fri, 17 Dec 2021 10:31:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44FBEA4073;
        Fri, 17 Dec 2021 10:31:55 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 10:31:55 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [PATCH kvm-unit-tests 2/2] s390x: diag288: Improve readability
Date:   Fri, 17 Dec 2021 11:31:37 +0100
Message-Id: <20211217103137.1293092-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217103137.1293092-1-nrb@linux.ibm.com>
References: <20211217103137.1293092-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2oNUGRKch4sGTcFp6p8yjgEUFaHt8iO2
X-Proofpoint-GUID: M9CTr5_hVEqRWYHaRIzbXaPLUk5FunSZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_03,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 mlxlogscore=733 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112170060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a more descriptive name instead of the magic number 424 (address of
restart new PSW in the lowcore).

In addition, add a comment to make it more obvious what the ASM snippet
does.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/diag288.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/s390x/diag288.c b/s390x/diag288.c
index da7b06c365bf..a2c263e38338 100644
--- a/s390x/diag288.c
+++ b/s390x/diag288.c
@@ -94,12 +94,15 @@ static void test_bite(void)
 	/* Arm watchdog */
 	lc->restart_new_psw.mask = extract_psw_mask() & ~PSW_MASK_EXT;
 	diag288(CODE_INIT, 15, ACTION_RESTART);
+	/* Wait for restart interruption */
 	asm volatile("		larl	0, 1f\n"
-		     "		stg	0, 424\n"
+		     "		stg	0, %[restart_new_psw]\n"
 		     "0:	nop\n"
 		     "		j	0b\n"
 		     "1:"
-		     : : : "0");
+		     :
+		     : [restart_new_psw] "T" (lc->restart_new_psw.addr)
+		     : "0");
 	report_pass("restart");
 }
 
-- 
2.31.1

