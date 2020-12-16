Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6BC2DC788
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgLPUNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:13:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728533AbgLPUNG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:13:06 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK2gIC046294
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yts+v++psXJeaC4CFiqms3Pr5Ycb3y3LxQ3h0Qaz7mQ=;
 b=lstpuioAhasKO65jn7v3oKnH11BdkYyyhX5ep31VYNDrZihfoCr1AW0GN6/kHdT/clRP
 wBbNF0sMZneANFiBAY8cDQqQJAWU2Hjb3Gz4w+nxHz7FOC8YdprMESB2cbLLSW6BhDf7
 OgZFhy2JjQt3QdqhiyLDPXVNvlffpiul+vB3Ba+vFbY8XaZ8H09qMCmILepSjVbHXehM
 DLFVNwwcoXRSFd3P51QddXj6yzdk8yLohNRE3OkllyjH12yMNQM05PlS9dWcvQMO2GuW
 VpgTUJGrRyThluvcyyaT0w7YbmwqU0FuSTEQKuZuNcLxiyd7CBQLtrSfJ1uk/jV6e70d Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fr7usctf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:26 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK3BTO049049
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:12:25 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35fr7uscsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:12:25 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK8MFj003486;
        Wed, 16 Dec 2020 20:12:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 35d310a4u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:12:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCLsX26477024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED57E42042;
        Wed, 16 Dec 2020 20:12:20 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80B8D4203F;
        Wed, 16 Dec 2020 20:12:20 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:20 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 02/12] lib/list.h: add list_add_tail
Date:   Wed, 16 Dec 2020 21:11:50 +0100
Message-Id: <20201216201200.255172-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=997
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a list_add_tail wrapper function to allow adding elements to the end
of a list.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/list.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/list.h b/lib/list.h
index 18d9516..7f9717e 100644
--- a/lib/list.h
+++ b/lib/list.h
@@ -50,4 +50,13 @@ static inline void list_add(struct linked_list *head, struct linked_list *li)
 	head->next = li;
 }
 
+/*
+ * Add the given element before the given list head.
+ */
+static inline void list_add_tail(struct linked_list *head, struct linked_list *li)
+{
+	assert(head);
+	list_add(head->prev, li);
+}
+
 #endif
-- 
2.26.2

