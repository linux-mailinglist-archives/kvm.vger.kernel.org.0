Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D40453C57F
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241639AbiFCG5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 02:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241778AbiFCG5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 02:57:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873BD1082;
        Thu,  2 Jun 2022 23:56:55 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2536soLU027667;
        Fri, 3 Jun 2022 06:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EQMV1zvcpkRCGhCZSkwNh3VXv0Yx0P1ztIsZhZUiqJU=;
 b=KK02iWOknCnIp0wKqGqGGFr4c77yHROhDASgKgK5gCXGN/LkwJz5UGBwwDAq9mS8w1E1
 gQzAoLg+ekzXR2Ojn7Hpzl5MzY/QBqS4ht4h6Vh3JYWeaL5ItZFCvtCiA8cSI8foBtUe
 gS5FqKRVVGy74zu5qmXAEYYAEbQKxWQFhVSSXQF9DqJ/0reykxG2OwwHhdQp3QKvtpxt
 J7y3y9MGjL/psMF41Ut4OBkA1rz04zbjVD9DSwhdHDRLgnVQnmOw0aD12d5FEA9Xsrlv
 +WLUlXu2OhcKoiAUmYsSQg1z67+7Kq2s9R4nGhfYb/wCsZ8evcoNIz7kkMX3JHIdxfDg cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfdepg0w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:54 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2536tV0j000495;
        Fri, 3 Jun 2022 06:56:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gfdepg0vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2536pC9o007349;
        Fri, 3 Jun 2022 06:56:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3gbc7h81x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jun 2022 06:56:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2536uoTQ23527702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jun 2022 06:56:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FB5742049;
        Fri,  3 Jun 2022 06:56:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA12742042;
        Fri,  3 Jun 2022 06:56:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jun 2022 06:56:48 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v11 07/19] KVM: s390: pv: module parameter to fence asynchronous destroy
Date:   Fri,  3 Jun 2022 08:56:33 +0200
Message-Id: <20220603065645.10019-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603065645.10019-1-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HTlBs_64oDuhrVFDXwGceqmSejwpXXzD
X-Proofpoint-GUID: IK3uLqC-fFE7W_UbmFNeENiLHbY-zLfr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-03_02,2022-06-02_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 clxscore=1015 bulkscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 impostorscore=0
 adultscore=0 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2206030027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the module parameter "async_destroy", to allow the asynchronous
destroy mechanism to be switched off.  This might be useful for
debugging purposes.

The parameter is enabled by default.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 76ad6408cb2c..49e27b5d7c3a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -206,6 +206,11 @@ unsigned int diag9c_forwarding_hz;
 module_param(diag9c_forwarding_hz, uint, 0644);
 MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
 
+/* allow asynchronous deinit for protected guests, enable by default */
+static int async_destroy = 1;
+module_param(async_destroy, int, 0444);
+MODULE_PARM_DESC(async_destroy, "Asynchronous destroy for protected guests");
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
-- 
2.36.1

