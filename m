Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDC04364E1
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhJUPBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:01:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11621 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230072AbhJUPBw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:01:52 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEI3JQ012486;
        Thu, 21 Oct 2021 10:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QN1MCC3UvshCzliPSSyFD4rEzp8MyoIROXz7m0QVplM=;
 b=SHbHD7+yV2698nVN2qFOrvx4tFptIKDsX1kuDB4cW5jYW6VWMW3QAOPgjU3y0+ggak6G
 7GxN1Im6kP/rmiBx/dU+8ThiEiRIqR0yv2fmAy8Tv0GZqVnfbgowFOuH9AFngC+mmec2
 +1Nu5Ftt9MFfrRlFtdcEVoS51ttInKO5J7wU804rdenmAIMJmJURE4i/FPjVeLxtEx+V
 Spv3tvEXLSzV5GzjeMHphMNnfGu+B0ZmZWZ+7SY1PK2nqQ9IpUNB+p/92FWjnZGSi0Cw
 5YclZdIV1GPti/0eufxm35Tn/opH1yuqrBAux927NsIahRzdOwY7OvItWZJ7esUBA2Ge FA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btxutyhfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 10:59:36 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LEITQx013141;
        Thu, 21 Oct 2021 10:59:35 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btxutyhf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 10:59:35 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LEcNse020855;
        Thu, 21 Oct 2021 14:59:33 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3bqpcb84he-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 14:59:33 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LExUJR45875590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:59:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57EB44C059;
        Thu, 21 Oct 2021 14:59:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 030034C046;
        Thu, 21 Oct 2021 14:59:30 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 14:59:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, borntraeger@de.ibm.com,
        pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH] MAINTAINERS: Add Claudio as s390x maintainer
Date:   Thu, 21 Oct 2021 14:59:12 +0000
Message-Id: <20211021145912.79225-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eNA_QeZInDwjybjpKlueleCkpKpEJgjZ
X-Proofpoint-GUID: wK2W0I4NfIkQOQVxh_wt21n9ssqwnWxW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=973 clxscore=1015 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110210077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Claudio has added his own tests, reviewed the tests of others and
added to the common as well as the s390x library with excellent
results. So it's time to make him a s390x maintainer.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2d4a0872..bab08e74 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -86,8 +86,8 @@ F: lib/ppc64/
 S390X
 M: Thomas Huth <thuth@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
+M: Claudio Imbrenda <imbrenda@linux.ibm.com>
 S: Supported
-R: Claudio Imbrenda <imbrenda@linux.ibm.com>
 R: David Hildenbrand <david@redhat.com>
 L: kvm@vger.kernel.org
 L: linux-s390@vger.kernel.org
-- 
2.30.2

