Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45A431965
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhJRMke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231760AbhJRMkY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:24 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19IBkbnk022925;
        Mon, 18 Oct 2021 08:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PelIzxrY05n41vhqsG9wQC1az5eex47tqnRbgFz0j0Y=;
 b=WeRlDWwjzmfvKVLldv4VhYifofnEzsfS2eJqUaPrYcveN2EjuemBivv39BkAHCPHG2K3
 /86TA/zPNXR7T/iqZQnmQ9qRR2nLxuwQWjY2wi+PCxs9c0ZgASMW1oIJMV8Zlrmnrava
 K6dF4B3wc0JJa2Xpb91LUq7Ib7hs5XHsqPkU8a8Bw76U09kBILD6SxJyJ6F5mVhj85ok
 Dc+SBSTOOAhrFUmnQZ5s8ilYkcOgBWhaTcBZS3Q3rJ/KYByzj8pAK7B+RFQPoy1VcB39
 K7EwKh3HBuZd7gHluaJz1qED0kI6OMePQ6SOAwfM05eJau0bmuWEhkPmmHtZh+/NDOmX Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs8bp92g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:12 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICYVc2003775;
        Mon, 18 Oct 2021 08:38:12 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs8bp92fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:12 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICc8TI022610;
        Mon, 18 Oct 2021 12:38:10 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3bqp0jn114-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:10 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc6SR65536306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:07 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC36752067;
        Mon, 18 Oct 2021 12:38:06 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5D83252052;
        Mon, 18 Oct 2021 12:38:06 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 17/17] lib: s390x: Fix copyright message
Date:   Mon, 18 Oct 2021 14:26:35 +0200
Message-Id: <20211018122635.53614-18-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JBRfwqEOqELlWIzN2TuAj5rbRkTvi9-L
X-Proofpoint-ORIG-GUID: bNU_D3sSUirU0V88LgYHI85vgIgVZOpU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxscore=0 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=951 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The comma makes no sense, so let's remove it.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/css.h  | 2 +-
 lib/s390x/sclp.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index d644971f..0db8a281 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -2,7 +2,7 @@
 /*
  * CSS definitions
  *
- * Copyright IBM, Corp. 2020
+ * Copyright IBM Corp. 2020
  * Author: Pierre Morel <pmorel@linux.ibm.com>
  */
 
diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 28e526e2..61e9cf51 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -6,7 +6,7 @@
  * Copyright (c) 2013 Alexander Graf <agraf@suse.de>
  *
  * and based on the file include/hw/s390x/sclp.h from QEMU
- * Copyright IBM, Corp. 2012
+ * Copyright IBM Corp. 2012
  * Author: Christian Borntraeger <borntraeger@de.ibm.com>
  */
 
-- 
2.31.1

