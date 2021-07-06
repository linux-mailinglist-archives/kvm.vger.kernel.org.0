Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913623BC7F2
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 10:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbhGFIjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 04:39:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhGFIjM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 04:39:12 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1668XRHT171796;
        Tue, 6 Jul 2021 04:36:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=fPYooNumNye4ij/q5KGQzbyUd00M+Y9IRsjqPn9wIVk=;
 b=RKWdFJ6osGHW9SQYOVAXJpgx3khczccMhgvqfq5cFt17B7goK76gMYdlqRYr8mOvwOxt
 0L44wJjIuPTOqfCWlJvCqtVXJJ1r4Mcsvdp9iVix6s7XD77JQ9LbWnoWFw5LJLlvug0/
 7rrGhAbhLE6TsGaUe+t4f4Ui+hpYxMqsXMYqhDuwCbS8IbCg0nottojjdhSGy7iAa+93
 uJKJvBKXyCjsiba8cS+J7Nm05F3ot2fPrlKoq0kEf98a6ws8sSmZM2ZTm4+uY10daLJK
 zoAHFc+sqeoNRJoCynwlFGyEb8qjt+cYl3cvD81ZP5KnOv9yiE6RY/69W5K1Lsb/2k88 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m8bky1rk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:36:33 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1668Ygc1175340;
        Tue, 6 Jul 2021 04:36:33 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39m8bky1qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 04:36:33 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1668W1nv021522;
        Tue, 6 Jul 2021 08:36:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 39jf5hgm5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 08:36:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1668aR7j14811624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 08:36:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B581CAE055;
        Tue,  6 Jul 2021 08:36:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A277FAE053;
        Tue,  6 Jul 2021 08:36:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  6 Jul 2021 08:36:27 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 55053E07F7; Tue,  6 Jul 2021 10:36:27 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 0/2] KVM: selftests: Fixes for 5.14
Date:   Tue,  6 Jul 2021 10:36:24 +0200
Message-Id: <20210706083626.10941-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2L0NdF3rW4rnMgllBVbYkVPTBs9HcySp
X-Proofpoint-ORIG-GUID: Ngqz3BcgOljwGIfsnF2MrWx3U3kTpDfp
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_04:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 impostorscore=0 clxscore=1015 spamscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

The following changes since commit f8be156be163a052a067306417cd0ff679068c97:

  KVM: do not allow mapping valid but non-reference-counted pages (2021-06-24 11:55:11 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.14-1

for you to fetch changes up to cd4220d23bf3f43cf720e82bdee681f383433ae2:

  KVM: selftests: do not require 64GB in set_memory_region_test (2021-07-06 10:06:20 +0200)

----------------------------------------------------------------
KVM: selftests: Fixes

- provide memory model for  IBM z196 and zEC12
- do not require 64GB of memory

----------------------------------------------------------------
Christian Borntraeger (2):
      KVM: selftests: introduce P44V64 for z196 and EC12
      KVM: selftests: do not require 64GB in set_memory_region_test

 tools/testing/selftests/kvm/include/kvm_util.h       |  3 ++-
 tools/testing/selftests/kvm/lib/guest_modes.c        | 16 ++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c           |  5 +++++
 tools/testing/selftests/kvm/set_memory_region_test.c |  3 ++-
 4 files changed, 25 insertions(+), 2 deletions(-)
