Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19FDB14EEF5
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbgAaPCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:02:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20369 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729164AbgAaPCW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:02:22 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF13CU056630
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:21 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvfy9812c-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:02:19 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:02:12 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:02:09 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF28PC47841342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:02:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AAD7EAE059;
        Fri, 31 Jan 2020 15:02:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98793AE04D;
        Fri, 31 Jan 2020 15:02:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:02:08 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 549D1E0378; Fri, 31 Jan 2020 16:02:08 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PULL 00/12] s390x qemu updates 20190930
Date:   Fri, 31 Jan 2020 16:01:55 +0100
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013115-0020-0000-0000-000003A5DEF7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0021-0000-0000-000021FD995D
Message-Id: <20200131150207.73127-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001310126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter,

The following changes since commit 786d36ad416c6c199b18b78cc31eddfb784fe15d:

  Merge remote-tracking branch 'remotes/pmaydell/tags/pull-target-arm-20190927' into staging (2019-09-30 11:02:22 +0100)

are available in the Git repository at:

  git://github.com/borntraeger/qemu.git tags/s390x-20190930

for you to fetch changes up to c5b9ce518c0551d0198bcddadc82e03de9ac8de9:

  s390/kvm: split kvm mem slots at 4TB (2019-09-30 13:51:50 +0200)

----------------------------------------------------------------
- do not abuse memory_region_allocate_system_memory and split the memory
  according to KVM memslots in KVM code instead (Paolo, Igor)
- change splitting to split at 4TB (Christian)
- do not claim s390 (31bit) support in configure (Thomas)
- sclp error checking (Janosch, Claudio)
- new s390 pci maintainer (Matt, Collin)
- fix s390 pci (again) (Matt)

----------------------------------------------------------------
Christian Borntraeger (1):
      s390/kvm: split kvm mem slots at 4TB

Claudio Imbrenda (1):
      s390x: sclp: Report insufficient SCCB length

Igor Mammedov (2):
      kvm: split too big memory section on several memslots
      s390: do not call memory_region_allocate_system_memory() multiple times

Janosch Frank (3):
      s390x: sclp: refactor invalid command check
      s390x: sclp: boundary check
      s390x: sclp: fix error handling for oversize control blocks

Matthew Rosato (2):
      MAINTAINERS: Update S390 PCI Maintainer
      s390: PCI: fix IOMMU region init

Paolo Bonzini (2):
      kvm: extract kvm_log_clear_one_slot
      kvm: clear dirty bitmaps from all overlapping memslots

Thomas Huth (1):
      configure: Remove s390 (31-bit mode) from the list of supported CPUs

 MAINTAINERS                |   2 +-
 accel/kvm/kvm-all.c        | 237 ++++++++++++++++++++++++++++-----------------
 configure                  |   2 +-
 hw/s390x/event-facility.c  |   3 -
 hw/s390x/s390-pci-bus.c    |   7 +-
 hw/s390x/s390-virtio-ccw.c |  30 +-----
 hw/s390x/sclp.c            |  37 ++++++-
 include/sysemu/kvm_int.h   |   1 +
 target/s390x/kvm.c         |  10 ++
 9 files changed, 202 insertions(+), 127 deletions(-)

