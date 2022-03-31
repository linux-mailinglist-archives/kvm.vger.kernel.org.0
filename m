Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4FE4EDE52
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 18:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbiCaQG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 12:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239608AbiCaQGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 12:06:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42BAB879;
        Thu, 31 Mar 2022 09:04:37 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VEDdRS020596;
        Thu, 31 Mar 2022 16:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=xldSF39mUuRll1043UB57opeZCqbLkGfiTZQPtI7n9g=;
 b=kr1HHF2msGlfbqpGIBz9KALFJ/y6AmZsmtD/Tew9mjGaX5OVoUAPO1sajwotXeunZoeQ
 LGmx29FhTNHDd7NEW61vil8rz8IvKAQ0OavVu2E2vwmH9moCXFWwnEA/R9d1yZRL1a9+
 ZWTM/hZIUSvBkzSuFodCUaXfSN1MKy3j4F3k5VUu6uSVfeC/zS8GvnxAzZA0bugTCwZq
 yOJBvz8fZB81Jrnc3HKQVf+e8jRN9fc36pYzyX6j7xhBX+5XCEW5Irvih1OfWOvZSqww
 ADDmVDYpUe3nG3Ki901prsXJ9d6PcW70vGD92UCEBAkLb/8sHOax241LfJXVoWm5UCF3 +Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f562rw8n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:37 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VFt5bD013549;
        Thu, 31 Mar 2022 16:04:36 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f562rw8me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:36 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VFxT3v013363;
        Thu, 31 Mar 2022 16:04:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3f3rs3p4p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 16:04:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VFqTxO21037438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 15:52:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4985411C05B;
        Thu, 31 Mar 2022 16:04:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA03111C04C;
        Thu, 31 Mar 2022 16:04:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 16:04:30 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, borntraeger@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 5/5] lib: s390x: stidp wrapper and move get_machine_id
Date:   Thu, 31 Mar 2022 18:04:19 +0200
Message-Id: <20220331160419.333157-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220331160419.333157-1-imbrenda@linux.ibm.com>
References: <20220331160419.333157-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zmH4QL2vNgXxSx_GdALXBVKCqdrqkDE6
X-Proofpoint-ORIG-GUID: g0hgtXhG54UzULEbXIMq2mT4zsFnuvme
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=997 impostorscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310089
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor get_machine_id in arch_def.h into a simple wrapper around
stidp, add back get_machine_id in hardware.h using the stidp wrapper.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 4 +---
 lib/s390x/hardware.h     | 5 +++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 8d860ccf..bab3c374 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -219,13 +219,11 @@ static inline unsigned short stap(void)
 	return cpu_address;
 }
 
-static inline uint16_t get_machine_id(void)
+static inline uint64_t stidp(void)
 {
 	uint64_t cpuid;
 
 	asm volatile("stidp %0" : "=Q" (cpuid));
-	cpuid = cpuid >> 16;
-	cpuid &= 0xffff;
 
 	return cpuid;
 }
diff --git a/lib/s390x/hardware.h b/lib/s390x/hardware.h
index af20be18..01eeb261 100644
--- a/lib/s390x/hardware.h
+++ b/lib/s390x/hardware.h
@@ -25,6 +25,11 @@ enum s390_host {
 
 enum s390_host detect_host(void);
 
+static inline uint16_t get_machine_id(void)
+{
+	return stidp() >> 16;
+}
+
 static inline bool host_is_tcg(void)
 {
 	return detect_host() == HOST_IS_TCG;
-- 
2.34.1

