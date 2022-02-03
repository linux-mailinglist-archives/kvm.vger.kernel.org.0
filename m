Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9D84A815B
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 10:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239790AbiBCJTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 04:19:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36460 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230259AbiBCJTn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 04:19:43 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21398U28010843;
        Thu, 3 Feb 2022 09:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=GrT1KThpskblIJhBRz1KgYFwrMCZvyDDmjGU2XElfSs=;
 b=AqUaUNLhnHKSxinyCt3XCw1u6Um6XGQEMEBzfm2JDxhrXJbMnfJRonXD03Xu3bCao7BX
 8wcRr43pDGmMrmFyh4yo75aZT3eO4D0JSSYjd6mSEineLlhaLvIQnEKeGnzbFMsiAn5T
 wbMeJaOqGCJNLCoZkvVDcigEc3PlhJutPfE+tNBA6IMwTGVFe8jT/sqSO2iTDXt+avXy
 Cc3oMkahLyyaf2kMfpFy8vQtAZFVYLc0qMrvfUXVcnUxHjdwbJp+ZdrTj32kaTw7RFbk
 gZsQh8dtBV+bJPYF/gh7NjFSbT0DtjbgNP4WwnuXVpHW/zU66nErr80k4t8RITVmUsyX iQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e09h03fma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:43 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2139DZPq004458;
        Thu, 3 Feb 2022 09:19:43 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e09h03fkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:42 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2139HJkO004438;
        Thu, 3 Feb 2022 09:19:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3dvw79tajw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 09:19:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21399iOJ35651926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 09:09:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B1A852065;
        Thu,  3 Feb 2022 09:19:37 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 443A95204F;
        Thu,  3 Feb 2022 09:19:36 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/4] s390x: Attestation tests
Date:   Thu,  3 Feb 2022 09:19:31 +0000
Message-Id: <20220203091935.2716-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3xGpmLeXa6MZnlR_u04kagF9SYA1HC51
X-Proofpoint-GUID: AXnknwjIspHX60NSODF3QfIYbtyWaF9L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_02,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=892 clxscore=1015 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds some test in s390x/uv-guest.c verifying error paths of the
Request Attestation Measurement UVC.
Also adds a test in s390x/uv-host.c to verify that the
Request Attestation Measurement UVC cannot be called in guest1.

v1->v2:
  * renamed 'uv_get_info(void)' to 'uv_get_query_data(void)'
  * renamed various fields in 'struct uv_arcb_v1'
  * added a test for invalid additional size
  * added r-b from Janosch in PATCH 1/4
  * added r-b from Janosch in PATCH 3/4

Steffen Eiden (4):
  s390x: uv-host: Add attestation test
  s390x: lib: Add QUI getter
  s390x: uv-guest: remove duplicated checks
  s390x: uv-guest: Add attestation tests

 lib/s390x/asm/uv.h |  28 ++++++-
 lib/s390x/uv.c     |   8 ++
 lib/s390x/uv.h     |   1 +
 s390x/uv-guest.c   | 196 +++++++++++++++++++++++++++++++++++++++++----
 s390x/uv-host.c    |   1 +
 5 files changed, 216 insertions(+), 18 deletions(-)

-- 
2.30.2

