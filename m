Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31864431963
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhJRMkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 08:40:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31206 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231768AbhJRMkX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 08:40:23 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19ICMnXY000564;
        Mon, 18 Oct 2021 08:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4qwWhUj8XEFvOK3UOB/YNH34WGITsov9c7Vz2xEHNtk=;
 b=MC7L+9TI/rjGCSeNx5+i8TewRYLsMtngeUn+g+nnt7fduLBgdodgLirkgu6OAyof35dJ
 dWn38H2uBwKeepnv+To1RRN6RkEQ/kG3rsEx6aBiidAW5SUo2JH77uK/FrcDkFJe3yYp
 xe59CLKWGSdf2wRAIF3DUpddOHbwr7rKgt0UsAKwIEk84fCI+xeEmlb+UH/dXpBODeX0
 P3yX6T7MbSfnosRU2bcNpygvDGrz33f9uw3P2UWEX5dpfRT01QkgOHjdF6yDym8Z/aw1
 p5wpsFPeGrgD2Y7tZ5zehDWrMqH29CrFZGkRQjO5jx45awr6SsiQxdh5iuXPAOJITs9M gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs8vkr9gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:11 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ICQXm0012132;
        Mon, 18 Oct 2021 08:38:11 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bs8vkr9fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 08:38:11 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19ICbmW9022613;
        Mon, 18 Oct 2021 12:38:09 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bqpc9e5vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Oct 2021 12:38:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ICc5p240632588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Oct 2021 12:38:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C684C5205A;
        Mon, 18 Oct 2021 12:38:05 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.80.123])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5022352077;
        Mon, 18 Oct 2021 12:38:05 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 15/17] lib: s390x: Fix PSW constant
Date:   Mon, 18 Oct 2021 14:26:33 +0200
Message-Id: <20211018122635.53614-16-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018122635.53614-1-frankja@linux.ibm.com>
References: <20211018122635.53614-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: grwO4XQf6u7GYGN5phwWU_1OyQz65SiC
X-Proofpoint-ORIG-GUID: 8t_YEpITIOttbOKP2ECa_DaFOBHJxzIs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_05,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=867 bulkscore=0 clxscore=1015 suspectscore=0
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110180075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Somehow the ";" got into that patch and now complicates compilation.
Let's remove it and put the constant in braces.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 lib/s390x/asm/arch_def.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index b34aa792..40626d72 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -53,7 +53,7 @@ struct psw {
 #define PSW_MASK_PSTATE			0x0001000000000000UL
 #define PSW_MASK_EA			0x0000000100000000UL
 #define PSW_MASK_BA			0x0000000080000000UL
-#define PSW_MASK_64			PSW_MASK_BA | PSW_MASK_EA;
+#define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
 
 #define CTL0_LOW_ADDR_PROT		(63 - 35)
 #define CTL0_EDAT			(63 - 40)
-- 
2.31.1

