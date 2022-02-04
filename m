Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E635B4A9C7F
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376363AbiBDPyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376318AbiBDPyB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:01 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214EIYbU009912;
        Fri, 4 Feb 2022 15:54:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mqhCRsLu4YNLXLsVOOm/9aaHMeuA8Oa0GNLiiOM0epI=;
 b=XuEnSWHyJkipy5/Rmhtw8HMjynpqwPrKjvvG4Ct+DzOwihGjmqVqECsU0QnNejuV01Lt
 dhcZk1ABFCB99Y217N4tlg3MB5YEElvbduTObSDjEpvfUzu9fHw1isbQFepWVIW1mE2b
 VfV73k4TU9G/kbCZjkZT5XCf3CN6KW7Gt7A/u4Vn+PZxj4Ai9lKUX71pdt1+VP4mCnuS
 eUnnHzeRdeOzEK+0fnmnsn76gKNdDbIcvd52yaMA8ccXoesrx2A8BuL6xJcAiRx8Swtx
 7yHJsGP/3zFK1cDEvrE94frk64BBLqWODS3nVmxaODQfgSgg36Yf/XHN1GXKUShl1O1E LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx40shx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:01 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214Fcaoe009618;
        Fri, 4 Feb 2022 15:54:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx40sh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214FlUBG024728;
        Fri, 4 Feb 2022 15:53:58 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3e0r10eb0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:53:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214Frt8i37224862
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:53:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFFFEAE051;
        Fri,  4 Feb 2022 15:53:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E5C1AE059;
        Fri,  4 Feb 2022 15:53:54 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:54 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 07/17] KVM: s390: pv: module parameter to fence lazy destroy
Date:   Fri,  4 Feb 2022 16:53:39 +0100
Message-Id: <20220204155349.63238-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Wgppi-yMNeqNqha5NVA_YvtSKNe9Sgir
X-Proofpoint-GUID: VMy-LjI0bNV5Oz_L9OYIrnd2NvBkpav1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=984
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the module parameter "lazy_destroy", to allow the asynchronous destroy
mechanism to be switched off. This might be useful for debugging purposes.

The parameter is enabled by default.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 577f1ead6a51..1a788f45d691 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -207,6 +207,11 @@ unsigned int diag9c_forwarding_hz;
 module_param(diag9c_forwarding_hz, uint, 0644);
 MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
 
+/* allow asynchronous deinit for protected guests */
+static int lazy_destroy = 1;
+module_param(lazy_destroy, int, 0444);
+MODULE_PARM_DESC(lazy_destroy, "Asynchronous destroy for protected guests");
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
-- 
2.34.1

