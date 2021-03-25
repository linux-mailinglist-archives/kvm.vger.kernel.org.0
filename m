Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFC9348D2E
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhCYJjx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:39:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52184 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229798AbhCYJjP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 05:39:15 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P9XJmv056091
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=HfqYEgg5r52ECmTPxfHKDqbw+r9wAcFmm3Eq6ZowKH4=;
 b=H6o+hmqgtzbwWt/dMH6gj26kmq6bqSFuUWbQ+matd19ZzvrBn+CwWJ6GVW7OnlX+DRGt
 Wxaf2tT2ot3sclY/0odXGolK1+nAf5J/+Q83Vk9oPrYWzNabQbHvlG/PBNt5xY3i4sGH
 9EPYhR7Z47dlbmpEvCAmo48FGB7eT255a6xwbOGWBrcAlEp9X98kr8ywrbDoomQQ30le
 lPbjKiZ8OquxY6hr/PO6kT2ErMHKyNZr62pYCEWo+fik+RVvIDgyUmQz8EaXbv39J7wM
 gIONf18b63uIJFgfbn1srLibrM8IEmJlmTbU9bAJVtOewb4r+W9nhhzj+/Jph7iQVGSc hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gaaabfwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:14 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12P9Z8TB065604
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 05:39:14 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gaaabfw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 05:39:14 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12P9RXxi017333;
        Thu, 25 Mar 2021 09:39:12 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37d9bmn72e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 09:39:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12P9d98O36831602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 09:39:09 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C38411C050;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 49AE111C05C;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.41.31])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 09:39:09 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/8] s390x: lib: css: SCSW bit definitions
Date:   Thu, 25 Mar 2021 10:39:01 +0100
Message-Id: <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_02:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need the SCSW definitions to test clear and halt subchannel.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
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

