Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A293BD6A4
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234930AbhGFMlg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:41:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6792 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241596AbhGFMUs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 08:20:48 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 166C3ce6122755;
        Tue, 6 Jul 2021 08:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LZoW+GDabL/dMI9WASNWekEZihVED6F0T5LxrzU9TSM=;
 b=LbKHOJ4mTx5T5bLAw//rcSkotdECynF88/K/a3/AWVuo3peYhJOEjf2+XJ/mxYMc0uw+
 7nKfQw9OVo6U76/kwF6VaDt+vj5F0iFRJOaiKcpab/tcPu1SakkTjZV9izPx6MsdY/C/
 1BMfwNnRZDCkZNxd6zTR8b9hk0M1hdMvU1Z0i12/EvcA6eNW0ueLpdLvMU9s07x+0Dv8
 eVOY6gw4c4bK0SRpvEslmAwpMTEtV3hF8rub2Dv4PMIqOWiRPFwSW35N8VhjyxaTuS+2
 9hagXW4FcNuxeiMIgB8Rsj9nuX9UcF1JhBxC5RRqnMqRY3InUnLWkXHxvGUlEvRLuk3t Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn89uj50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:10 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 166C4Knw127382;
        Tue, 6 Jul 2021 08:18:10 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mn89uj38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:18:09 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 166C2k6M012042;
        Tue, 6 Jul 2021 12:18:07 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hgnsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 12:18:07 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 166CGDcA34275586
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 12:16:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41CCB42052;
        Tue,  6 Jul 2021 12:18:05 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E82434204C;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Jul 2021 12:18:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 5/5] lib: s390x: Remove left behing PGM report
Date:   Tue,  6 Jul 2021 12:17:57 +0000
Message-Id: <20210706121757.24070-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706121757.24070-1-frankja@linux.ibm.com>
References: <20210706121757.24070-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jLM7wdOCAmFZwuiWcz_B3VB_IN8GzBMQ
X-Proofpoint-GUID: xWWKHdJ65mH0I3V4ycwvfHuhrIdaRtPJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_06:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When I added the backtrace support I forgot to remove the PGM report.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index 109f290..785b735 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -162,9 +162,6 @@ void handle_pgm_int(struct stack_frame_int *stack)
 		/* Force sclp_busy to false, otherwise we will loop forever */
 		sclp_handle_ext();
 		print_pgm_info(stack);
-		report_abort("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
-			     lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
-			     lc->pgm_int_id);
 	}
 
 	pgm_int_expected = false;
-- 
2.30.2

