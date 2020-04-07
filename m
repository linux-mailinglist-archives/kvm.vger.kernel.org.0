Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 420E61A0CFD
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 13:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgDGLmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 07:42:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24248 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726562AbgDGLmr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Apr 2020 07:42:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 037BX9rB011151
        for <kvm@vger.kernel.org>; Tue, 7 Apr 2020 07:42:46 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3082j8nqk7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 07 Apr 2020 07:42:45 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 7 Apr 2020 12:42:31 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 7 Apr 2020 12:42:30 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 037Bgf3G53280988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Apr 2020 11:42:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 15BD1A405F;
        Tue,  7 Apr 2020 11:42:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04AF9A405B;
        Tue,  7 Apr 2020 11:42:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  7 Apr 2020 11:42:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B62EBE08E5; Tue,  7 Apr 2020 13:42:40 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 0/3] KVM: s390: Fixes for vsie (nested hypervisors)
Date:   Tue,  7 Apr 2020 13:42:37 +0200
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20040711-0012-0000-0000-0000039FF3FB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040711-0013-0000-0000-000021DD14F7
Message-Id: <20200407114240.156419-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-07_03:2020-04-07,2020-04-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 mlxlogscore=771 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004070100
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

some fixes for 5.7. The commits are new due to late additions of
Reviewed-by tags, but I have been testing these for a while now.
The following changes since commit 8c1b724ddb218f221612d4c649bc9c7819d8d7a6:

  Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2020-04-02 15:13:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.7-1

for you to fetch changes up to 1493e0f944f3c319d11e067c185c904d01c17ae5:

  KVM: s390: vsie: Fix possible race when shadowing region 3 tables (2020-04-07 13:12:38 +0200)

----------------------------------------------------------------
KVM: s390: Fixes for vsie (nested hypervisors)

- Several fixes for corner cases of nesting. Still relevant as it might
  crash host or first level guest or temporarily leak memory.

----------------------------------------------------------------
David Hildenbrand (3):
      KVM: s390: vsie: Fix region 1 ASCE sanity shadow address checks
      KVM: s390: vsie: Fix delivery of addressing exceptions
      KVM: s390: vsie: Fix possible race when shadowing region 3 tables

 arch/s390/kvm/vsie.c | 1 +
 arch/s390/mm/gmap.c  | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

