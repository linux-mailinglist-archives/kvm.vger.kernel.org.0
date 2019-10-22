Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624E7E025F
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 12:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbfJVKxO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 06:53:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28164 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730379AbfJVKxN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Oct 2019 06:53:13 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9MAmSWY071852
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:53:12 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vsweyxp5j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 06:53:12 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Tue, 22 Oct 2019 11:53:10 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 22 Oct 2019 11:53:06 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9MAr5Iu24772646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 10:53:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 521D052050;
        Tue, 22 Oct 2019 10:53:05 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.39])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 0FF575204E;
        Tue, 22 Oct 2019 10:53:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/5] s390x: remove redundant defines
Date:   Tue, 22 Oct 2019 12:53:00 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
References: <1571741584-17621-1-git-send-email-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19102210-0012-0000-0000-0000035B6D1B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102210-0013-0000-0000-0000219697A0
Message-Id: <1571741584-17621-2-git-send-email-imbrenda@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-22_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=915 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910220098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/sclp.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/s390x/sclp.h b/lib/s390x/sclp.h
index 4e69845..f00c3df 100644
--- a/lib/s390x/sclp.h
+++ b/lib/s390x/sclp.h
@@ -27,8 +27,6 @@
 #define SCLP_ASSIGN_STORAGE                     0x000D0001
 #define SCLP_CMD_READ_EVENT_DATA                0x00770005
 #define SCLP_CMD_WRITE_EVENT_DATA               0x00760005
-#define SCLP_CMD_READ_EVENT_DATA                0x00770005
-#define SCLP_CMD_WRITE_EVENT_DATA               0x00760005
 #define SCLP_CMD_WRITE_EVENT_MASK               0x00780005
 
 /* SCLP Memory hotplug codes */
-- 
2.7.4

