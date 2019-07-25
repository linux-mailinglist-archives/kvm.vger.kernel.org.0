Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486B57523B
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 17:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388725AbfGYPLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 11:11:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388082AbfGYPLn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jul 2019 11:11:43 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6PF8XF8143707
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 11:11:41 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tyd1edcf0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2019 11:11:39 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 25 Jul 2019 16:11:30 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 25 Jul 2019 16:11:27 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6PFBPhG43057354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 15:11:25 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3DDB4C05A;
        Thu, 25 Jul 2019 15:11:25 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A28ED4C052;
        Thu, 25 Jul 2019 15:11:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Jul 2019 15:11:25 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 6508CE0261; Thu, 25 Jul 2019 17:11:25 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [ v2 0/1] kvm-unit-tests: s390x: add check for mandatory
Date:   Thu, 25 Jul 2019 17:11:24 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19072515-0028-0000-0000-00000387D40B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072515-0029-0000-0000-000024481446
Message-Id: <20190725151125.145362-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-25_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=836 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907250177
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let us start with all documented dependencies from chapter 4 of the POP.
we can add more tests later on. 

Christian Borntraeger (1):
  kvm-unit-tests: s390: add cpu model checks

 s390x/Makefile      |  1 +
 s390x/cpumodel.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg |  3 +++
 3 files changed, 62 insertions(+)
 create mode 100644 s390x/cpumodel.c

-- 
2.21.0

