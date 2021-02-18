Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFDF31EE58
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhBRSck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:32:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3194 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234440AbhBRReg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:34:36 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IHWuww137831
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=XngdBw/B77KioqbuoRrCqR7QL3zmo4cvAzyuaTHcdqA=;
 b=EZneu/sgesPbYJZ1TG5OPhrFqFV0HNWO7RhhDCyT9dCVjJ50e4rKlnqKEZWpqJ8/rmyp
 9oKjPfTUBsFp7K1RxACgAd+bZCmrbg9iQTqafhDv0KK6CWO2dqGHpjGegVb955GFvfP9
 pY7eESJF98H9iKHZe+K3wSTbpu/JT6yNYz9KGZr7jMPIHf+bBt8NDAzDG8uKrOO1nwjJ
 NQFGMh36RaBuQlvOHjQ/85lb+c+HyNe3qgeMLH+B9tT6q9Xlp59K1IVh4gWUCd3/hWMl
 bNUwbB+VGJsKDfyV62WV7mjzTGimqH9abiSh+38nOt31vOW+RsxLSWfsD9EhxnCyfAdF pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36sveggggy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:33:50 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IHXEPU139182
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:33:50 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36svegggfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 12:33:50 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNv9u011693;
        Thu, 18 Feb 2021 17:33:48 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36p6d8cvs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 17:33:47 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IHXjjQ45220304
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:33:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3307DA405F;
        Thu, 18 Feb 2021 17:33:45 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFE65A4062;
        Thu, 18 Feb 2021 17:33:44 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.94.58])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 17:33:44 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com, pasic@linux.ibm.com
Subject: [PATCH 1/1] css: SCHIB measurement block origin must be aligned
Date:   Thu, 18 Feb 2021 18:33:43 +0100
Message-Id: <1613669623-7328-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613669623-7328-1-git-send-email-pmorel@linux.ibm.com>
References: <1613669623-7328-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_08:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Measurement Block Origin inside the SCHIB is used when
Mesurement Block format 1 is in used and must be aligned
on 128bits.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 target/s390x/ioinst.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/target/s390x/ioinst.c b/target/s390x/ioinst.c
index a412926d27..1ee11522e1 100644
--- a/target/s390x/ioinst.c
+++ b/target/s390x/ioinst.c
@@ -121,6 +121,12 @@ static int ioinst_schib_valid(SCHIB *schib)
     if (be32_to_cpu(schib->pmcw.chars) & PMCW_CHARS_MASK_XMWME) {
         return 0;
     }
+    /* for MB format 1 bits 26-31 of word 11 must be 0 */
+    /* MBA uses words 10 and 11, it means align on 2**6 */
+    if ((be16_to_cpu(schib->pmcw.chars) & PMCW_CHARS_MASK_MBFC) &&
+        (be64_to_cpu(schib->mba) & 0x03fUL)) {
+        return 0;
+    }
     return 1;
 }
 
-- 
2.25.1

