Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2212A43195C
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhJRMk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231724AbhJRMkT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:19 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICc4wP008104;
        Mon, 18 Oct 2021 08:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oW6rIaYDmjmDQRciDukvgpOCsUnwIp81nrfWD9HbNYk=;
 b=JSgf9ZizlcmXbVyPIcqj/3z0pbIGq4jEyQFhx0mfVDUb6cgZMRGgDoLa/T8O3xtWpf1E
 MumEeW79y1AZsLyVrvul609b89m0olhO74z9Iyy+oyJTZHFTBAXwvADG7dknBP5cDL27
 I5wRegf3EtAQe40pmtho4OjeCrO4E0t5iJoS75aGbAVdD8sPD4CvL0POmdhdTBLSHFnU
 5vh9UliiIaMaGeY/I+j8p/Ppa2glAwIvSVgDEJYz//9Ua/4xfb30z+eGqc2S05KufaIg
 aseQtSO9bSDbqnC9XK0djL0mG6xOlMCF3NeD9EuMbBXe/HflODsjynTVD8mo55XbXe2k Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs419f0gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:08 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICQo4s016805;
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bs419f0gd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:07 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICc4JI000967;
        Mon, 18 Oct 2021 12:38:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpca6704-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc2RF62587172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1E005205A;
        Mon, 18 Oct 2021 12:38:02 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2D2735204F;
        Mon, 18 Oct 2021 12:38:02 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 09/17] lib: s390x: uv: Add UVC_ERR_DEBUG switch
Date:   Mon, 18 Oct 2021 14:26:27 +0200
Message-Id: <20211018122635.53614-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dzIu4rE2x-2FZ82X2IhT7hnsG5pLFuuQ
X-Proofpoint-ORIG-GUID: xQxjFurZfXdVCI-q-yXekkLx8dxauHLD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Every time something goes wrong in a way we don't expect, we need to
add debug prints to some UVC to get the unexpected return code.

Let's just put the printing behind a macro so we can enable it if
needed via a simple switch.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/uv.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 2f099553..8baf896f 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -12,6 +12,11 @@
 #ifndef _ASMS390X_UV_H_
 #define _ASMS390X_UV_H_
 
+/* Enables printing of command code and return codes for failed UVCs */
+#ifndef UVC_ERR_DEBUG
+#define UVC_ERR_DEBUG	0
+#endif
+
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
 #define UVC_RC_INV_STATE	0x0003
@@ -194,6 +199,13 @@ static inline int uv_call_once(unsigned long r1, unsigned long r2)
 		: [cc] "=d" (cc)
 		: [r1] "a" (r1), [r2] "a" (r2)
 		: "memory", "cc");
+
+	if (UVC_ERR_DEBUG && cc == 1)
+		printf("UV call error: call %x rc %x rrc %x\n",
+		       ((struct uv_cb_header *)r2)->cmd,
+		       ((struct uv_cb_header *)r2)->rc,
+		       ((struct uv_cb_header *)r2)->rrc);
+
 	return cc;
 }
 
-- 
2.31.1

