Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9337555E
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhEFOFA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:05:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234489AbhEFOFA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 10:05:00 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 146E3nGS046689
        for <kvm@vger.kernel.org>; Thu, 6 May 2021 10:04:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=iFQCnsQsFzVQxEI2giGcwds7XDiCZ61hdo8CyZAPTM8=;
 b=j5CSYeIOyp1GNAQc/DFDNy8yF+ffG+SGYax1yEw4+9abxg2FsWCxnENpJpmOGyCeDo8E
 DA2U7oGILxqnIgs5lYbFYWZv3qYhcuzAkoRX/dLXvr+SfmA9M2wGmBFv1DCiJH0v8Wjq
 6w9Je38dyDUEJWhAsGxjv83tJ0woi69j4s5IIf/BLKkaEuzx34zqJRbEOhvB2vhnWdB7
 HNEeKnzWvw2BzbC+/+YbTQAUyn4SNMNxSx/ploHxv9K6nsnnkR7wknPEIdKbLzVem8aP
 QSL95lK5K8xRnDaNMswQRdn5OCDLywnV1gDreN+asPHYHP48rdYGXuO4m1ypMhsyFhC6 FQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ch7k9jtv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 10:04:01 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 146E41fG051382
        for <kvm@vger.kernel.org>; Thu, 6 May 2021 10:04:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ch7k9js5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 May 2021 10:04:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 146E2cke002345;
        Thu, 6 May 2021 14:03:57 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 38bee590bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 May 2021 14:03:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 146E3TMg17236332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 May 2021 14:03:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E89BFA4068;
        Thu,  6 May 2021 14:03:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B664AA4060;
        Thu,  6 May 2021 14:03:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  6 May 2021 14:03:54 +0000 (GMT)
From:   Stefan Raspl <raspl@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, pbonzini@redhat.com
Subject: [PATCH] tools/kvm_stat: Fix documentation typo
Date:   Thu,  6 May 2021 16:03:52 +0200
Message-Id: <20210506140352.4178789-1-raspl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OTbtJEauIgG96cxNZZSZTUcB7kCY1iFr
X-Proofpoint-ORIG-GUID: yjYdPedxrzmiJP4xR2x-AfwIGYJXmq87
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-06_10:2021-05-06,2021-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1011 mlxlogscore=932 priorityscore=1501 spamscore=0 bulkscore=0
 mlxscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105060103
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Makes the dash in front of option '-z' disappear in the generated
man-page.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
---
 tools/kvm/kvm_stat/kvm_stat.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index feaf46451e83..3a9f2037bd23 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -111,7 +111,7 @@ OPTIONS
 --tracepoints::
         retrieve statistics from tracepoints
 
-*z*::
+-z::
 --skip-zero-records::
         omit records with all zeros in logging mode
 
-- 
2.25.1

