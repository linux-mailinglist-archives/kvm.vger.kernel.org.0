Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0454B373683
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhEEIok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232168AbhEEIoe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:34 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458XZ36015774;
        Wed, 5 May 2021 04:43:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Z3VZQUtWJ1X6pNtb4EmisIFvsmeGIONO+y/C3ScZuo4=;
 b=ecQsaRTb/CscUw+RSqJqT4Y5P2oZWNRJn+j2SnjNnowiXrGQBb2T+UlSXi78ubQCcSXh
 AJTXNMUjpimtOmvMZCTTWUNgoaRz14rM9V5OkPjXEcGa+zHde8ewnSXlWNzFz1TmTC3l
 RlwbEldmO+KWzEuV/zT5OJwvEPS0msGkrqsLYQNPv7Ky61SYv4KTxRTwnRt599V9Q9tS
 9x1fCTNuRwT+W1apLsTaNJOU9IX4MKYogYQyQl8eztlnvkgLrxyfZJ8WiXkB66J+lBTt
 0FLCNToJOqtx3QPpjrrrf4v22qJot82VPBwU8don/oxuqmCm3nsCZXgh5Wvh/xwyELSw 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bnfsc2h0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:38 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458b6A4032267;
        Wed, 5 May 2021 04:43:38 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bnfsc2ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:37 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458gaUT012628;
        Wed, 5 May 2021 08:43:35 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 38bee586ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:35 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458hWlF44761374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA56BA4054;
        Wed,  5 May 2021 08:43:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36442A405B;
        Wed,  5 May 2021 08:43:32 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:32 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 8/9] MAINTAINERS: s390x: add myself as reviewer
Date:   Wed,  5 May 2021 10:43:00 +0200
Message-Id: <20210505084301.17395-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505084301.17395-1-frankja@linux.ibm.com>
References: <20210505084301.17395-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: blCgiD66xZGTt-HnUTf87klv_d891EFW
X-Proofpoint-ORIG-GUID: SJ7-yy6TYqP0msyxWGFxMUWmJIytVGft
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_02:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Message-Id: <20210427121608.157783-1-imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/kvm/20210427121608.157783-1-imbrenda@linux.ibm.com/
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e2505985..aaa404cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -85,6 +85,7 @@ M: Thomas Huth <thuth@redhat.com>
 M: David Hildenbrand <david@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
 R: Cornelia Huck <cohuck@redhat.com>
+R: Claudio Imbrenda <imbrenda@linux.ibm.com>
 L: kvm@vger.kernel.org
 L: linux-s390@vger.kernel.org
 F: s390x/*
-- 
2.30.2

