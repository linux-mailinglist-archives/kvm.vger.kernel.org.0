Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F183B354E0C
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 09:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244348AbhDFHlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 03:41:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235757AbhDFHlK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Apr 2021 03:41:10 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1367YAH0068691
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=mG3ygt0DNjAl2DIIWNoi6pGHQtTpEjZYTGyQpnVFPJs=;
 b=SWYRdol44bg/zlV71ziI8o6frm+2/GQWNiWqQGp97mwtXgZTfkPhtE0EwCSa1Ktq13h3
 njcXId8AK8H7Ju6qJHxMhsB6x+Pvttf1okN1nXf5VwZfDEN40s4pmiPTBLhGnvd7zqa6
 PuzYtc72NB873LkF0mJqzoMjZyPTadl3ryhJhv6lTxbOEvNkmPk1yE133qRMgo6peTva
 vgiUEm+AJzfD0MBpmn7Km15bW/tQ47aTMjEfg7ZT3+Vj2KGa+5Zxyii6ZNFoE2I4+Vle
 gtvYorACiuBVmQhnnYQMEQcwnbFt5V+PUv1PTlTTwqdkX+DqvXhnvlm4Wro4wU+qTGZc HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5eatcne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 06 Apr 2021 03:41:02 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1367Z6Au071076
        for <kvm@vger.kernel.org>; Tue, 6 Apr 2021 03:41:02 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37q5eatcku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 03:41:02 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1367WTED011497;
        Tue, 6 Apr 2021 07:40:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 37q3cf10dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Apr 2021 07:40:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1367eteR32964960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Apr 2021 07:40:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6A644C052;
        Tue,  6 Apr 2021 07:40:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 647C94C050;
        Tue,  6 Apr 2021 07:40:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.42.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  6 Apr 2021 07:40:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 02/16] s390x: lib: css: SCSW bit definitions
Date:   Tue,  6 Apr 2021 09:40:39 +0200
Message-Id: <1617694853-6881-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
References: <1617694853-6881-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MN-L7lk_1suBOvjDAULKYq8OtXnwXrcL
X-Proofpoint-ORIG-GUID: dJExRxzLDXIWB8HQ8FOB2A70qF5Q8UzW
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-06_01:2021-04-01,2021-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need the SCSW definitions to test clear and halt subchannel.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 lib/s390x/css.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index b0de3a3..0058355 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -67,6 +67,29 @@ struct scsw {
 #define SCSW_SC_PRIMARY		0x00000004
 #define SCSW_SC_INTERMEDIATE	0x00000008
 #define SCSW_SC_ALERT		0x00000010
+#define SCSW_AC_SUSPENDED	0x00000020
+#define SCSW_AC_DEVICE_ACTIVE	0x00000040
+#define SCSW_AC_SUBCH_ACTIVE	0x00000080
+#define SCSW_AC_CLEAR_PEND	0x00000100
+#define SCSW_AC_HALT_PEND	0x00000200
+#define SCSW_AC_START_PEND	0x00000400
+#define SCSW_AC_RESUME_PEND	0x00000800
+#define SCSW_FC_CLEAR		0x00001000
+#define SCSW_FC_HALT		0x00002000
+#define SCSW_FC_START		0x00004000
+#define SCSW_QDIO_RESERVED	0x00008000
+#define SCSW_PATH_NON_OP	0x00010000
+#define SCSW_EXTENDED_CTRL	0x00020000
+#define SCSW_ZERO_COND		0x00040000
+#define SCSW_SUPPRESS_SUSP_INT	0x00080000
+#define SCSW_IRB_FMT_CTRL	0x00100000
+#define SCSW_INITIAL_IRQ_STATUS	0x00200000
+#define SCSW_PREFETCH		0x00400000
+#define SCSW_CCW_FORMAT		0x00800000
+#define SCSW_DEFERED_CC		0x03000000
+#define SCSW_ESW_FORMAT		0x04000000
+#define SCSW_SUSPEND_CTRL	0x08000000
+#define SCSW_KEY		0xf0000000
 	uint32_t ctrl;
 	uint32_t ccw_addr;
 #define SCSW_DEVS_DEV_END	0x04
-- 
2.17.1

