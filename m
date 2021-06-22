Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0D83AFF1C
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 10:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhFVIX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 04:23:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230312AbhFVIXx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 04:23:53 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M8BgYJ086540;
        Tue, 22 Jun 2021 04:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9ejHKvv8rT4b6NpinOQzw3f66b/0Az5ildR5JWwkwKE=;
 b=HAMsxfIBZvXzG1kcyDxbaqKlgMbRR3MjTHTqjiN82XQo9E7fwTlHPdNF+q6+i9+NaVVI
 IOzWBEH/dvbewhVo9it3AKLGdcWKqgn2Rxw72nfz2p383Nr7PyOeYEzEF/b0JbEzJMcT
 wXXbYPuoy/tHXy3D9uZbVYAx3kfFIfYIdpJcBV+m0V7ZXP6BW7Wq5TCercey5qzyKici
 FR7uJX2XGmk+yHapi99Hxz2iSiUtSI62IQlWf3YPBOkoUhzbtGLQjGz/aQrKpuFCwnU/
 OnB5Ifx6jcwq5uOJ73IRW17mDh2iTO3+tNgwUAiFjlH45kZJoTE0Bfn1xQw41HrRt3f1 GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39b94q4h5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:37 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M8DElp089676;
        Tue, 22 Jun 2021 04:21:37 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39b94q4h4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 04:21:37 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15M8EB7g031963;
        Tue, 22 Jun 2021 08:21:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3998788q38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 08:21:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15M8LWFV33423792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 08:21:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B510AE04D;
        Tue, 22 Jun 2021 08:21:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7BF2BAE051;
        Tue, 22 Jun 2021 08:21:31 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.182.30])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 08:21:31 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 04/12] configure: s390x: Check if the host key document exists
Date:   Tue, 22 Jun 2021 10:20:34 +0200
Message-Id: <20210622082042.13831-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622082042.13831-1-frankja@linux.ibm.com>
References: <20210622082042.13831-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rh3I-tGj4vZ62a_X344KhG4SU-3HOIod
X-Proofpoint-ORIG-GUID: b4MBaw0X97AUeTNFSDxGRnpRLXwhvFWp
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'd rather have a readable error message than make failing the build
with cryptic errors.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 configure | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/configure b/configure
index b8442d61..71aaad43 100755
--- a/configure
+++ b/configure
@@ -137,6 +137,11 @@ while [[ "$1" = -* ]]; do
     esac
 done
 
+if [ -n "$host_key_document" ] && [ ! -f "$host_key_document" ]; then
+    echo "Host key document doesn't exist at the specified location."
+    exit 1
+fi
+
 if [ "$erratatxt" ] && [ ! -f "$erratatxt" ]; then
     echo "erratatxt: $erratatxt does not exist or is not a regular file"
     exit 1
-- 
2.31.1

