Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F52F2F7A23
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388107AbhAOMp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:45:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733007AbhAOMpU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:45:20 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10FCZEZk196375;
        Fri, 15 Jan 2021 07:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5xPxsI6PlfJ2XD0UTxH/GUA7rr+qBpV6LHpc0QDBqYo=;
 b=pEVxKW2x++hOctUXaMhkBDe76PbNfS2WR58mMYcRefAOnBp/IN2EVqwI4XURTPjC+1K5
 uR+3NRiKCoJXRv8T4Km2Ds5G1gphqDCfO+OFM5gMaxU2LKSEl2AiJoG9MQFSKLNXmrxi
 oItIwiBH3CAMvfwV6YfWPXrRRDTy+NgfM1dXGwquUByJ+6T+VQ0lJr8N3GJPLh8+8xXG
 LIf+SF/EvTD4XD4LsAhNL654jUTkhC+IgZIkFanE4VH6QnNTTgHX7yUIBrRCi8pBkN+E
 pAv0piVunAqCAmf02uYATAYQonctVPnFk2oKPrdmCRH5/QYKRKJeZulxdSHX6Ga+ivua Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 363af5s9ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:37 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10FCZ9UL195902;
        Fri, 15 Jan 2021 07:37:37 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 363af5s9kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 07:37:36 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10FC8GCT023595;
        Fri, 15 Jan 2021 12:37:35 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 35y448bynw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 12:37:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10FCbWsD50528608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 12:37:32 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEBE3AE056;
        Fri, 15 Jan 2021 12:37:32 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47224AE055;
        Fri, 15 Jan 2021 12:37:32 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 Jan 2021 12:37:32 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com
Subject: [kvm-unit-tests PATCH v2 02/11] lib/list.h: add list_add_tail
Date:   Fri, 15 Jan 2021 13:37:21 +0100
Message-Id: <20210115123730.381612-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210115123730.381612-1-imbrenda@linux.ibm.com>
References: <20210115123730.381612-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_07:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 priorityscore=1501
 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150075
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a list_add_tail wrapper function to allow adding elements to the end
of a list.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
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

