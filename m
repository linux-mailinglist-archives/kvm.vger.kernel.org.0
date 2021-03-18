Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F89D3406D3
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCRN0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:26:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5868 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230289AbhCRN0g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:26:36 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ID3Smm135167
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=s8L3soJmvXz6s2xty6hD6XjKwzxbPwj2Vh+6wJuJTEY=;
 b=OKz1toiYO34kRtOHSLucu208YrG/VYOZNcOrTizusnc+Lbr3LD4T5GPD4IqnkghqWBTL
 L/RzNgnGa15xNQJnUzesWKblfCOBCwF9n21ByEpeyyExcsW7bV2/z22bZee9+LrOXF+l
 Z04m6OS8KCFff0T1aW7H/5btFwdad0yPv0RyxN2qkH92JvaghzaefucAglPTh+W8NhQo
 OPxyJuY11gruigbNvLIu2kOqlY96uyTG7RxnwponIIWD76hUTRyWl562BBFobFbXVlbS
 7SJaoh00o7J44d7urjHnUEll0R/GWfjF3sI6nJ7c50obrxrR+2FR1PcYP6Vg/lYFj+hu Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10fm7tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:35 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ID3gPL136055
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:35 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c10fm7t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 09:26:35 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IDMth6007380;
        Thu, 18 Mar 2021 13:26:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 378n18mt0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 13:26:33 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IDQDTx15401270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:26:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95B9A4C046;
        Thu, 18 Mar 2021 13:26:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BFA84C066;
        Thu, 18 Mar 2021 13:26:30 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 13:26:30 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 2/6] s390x: lib: css: SCSW bit definitions
Date:   Thu, 18 Mar 2021 14:26:24 +0100
Message-Id: <1616073988-10381-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 mlxlogscore=969
 adultscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We need the SCSW definitions to test clear and halt subchannel.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/css.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/lib/s390x/css.h b/lib/s390x/css.h
index b0de3a3..460b0bd 100644
--- a/lib/s390x/css.h
+++ b/lib/s390x/css.h
@@ -67,6 +67,29 @@ struct scsw {
 #define SCSW_SC_PRIMARY		0x00000004
 #define SCSW_SC_INTERMEDIATE	0x00000008
 #define SCSW_SC_ALERT		0x00000010
+#define SCSW_AC_SUSPEND_PEND	0x00000020
+#define SCSW_AC_DEVICE_PEND	0x00000040
+#define SCSW_AC_SUBCHANNEL_PEND	0x00000080
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

