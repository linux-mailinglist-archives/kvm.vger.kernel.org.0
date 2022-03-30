Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75B34EC6F5
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 16:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347123AbiC3OqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 10:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347164AbiC3Opq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 10:45:46 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B00F78907;
        Wed, 30 Mar 2022 07:43:57 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UDwouc004713;
        Wed, 30 Mar 2022 14:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+ypfw1DcsfrtS1EDOsZ61j9cykXQpXIN5Jh0hpdXLSE=;
 b=iKDTE2jTN6+qpn9QcW1VgZEbj78qSXPrL96RmNAL+K+kMrgB15EOfzrm8BrTHkOFt7i1
 BaaLan8KEdRkoWshcRZItTZY+/aXj0zRpM/HDBiAkNb44UvxacwXnBH69HsWlHlvCNQk
 Px2jxmPofvwA2kUOevtjrkZiikYQDkTaa/Y94J4cd917H+3xJA5R4dIsHWQ04ooK5x9f
 oN4RSFu9xOoc5DhKGdCA7jl5MyrzdJ+GbdcnDdlakhuJ2WxWNp2iXZ1+xR4AbUt+3W/Z
 CJ7H4zeEAz/o1PdnSoptmV5W0bi/5kqeQo8naQomYOcYtLr9shfTKOWN986FLbhthVD2 Tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f4rjn13du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:56 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UEQMeE004133;
        Wed, 30 Mar 2022 14:43:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f4rjn13cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UEdC0k012503;
        Wed, 30 Mar 2022 14:43:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3f1tf8ygbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UEhoUj36962618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 14:43:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BB274C044;
        Wed, 30 Mar 2022 14:43:50 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17C774C040;
        Wed, 30 Mar 2022 14:43:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 14:43:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, borntraeger@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v1 4/4] lib: s390x: stidp wrapper and move get_machine_id
Date:   Wed, 30 Mar 2022 16:43:39 +0200
Message-Id: <20220330144339.261419-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330144339.261419-1-imbrenda@linux.ibm.com>
References: <20220330144339.261419-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: weDkcEGLLA1MynzeGrhJ0C8FHrpkBrfg
X-Proofpoint-GUID: lBbHsZUErIUyC2F8IPKJPd5c9dUlnZlc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=946
 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300071
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
index fb6565ad..8783ae9c 100644
--- a/lib/s390x/hardware.h
+++ b/lib/s390x/hardware.h
@@ -43,6 +43,11 @@ enum s390_host {
 
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

