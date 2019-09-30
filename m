Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A54C3C21BF
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 15:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbfI3NUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 09:20:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731262AbfI3NUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Sep 2019 09:20:06 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8UDIGJS134011
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:04 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vbjd70brb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2019 09:20:03 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 30 Sep 2019 14:20:01 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 30 Sep 2019 14:19:57 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8UDJRtX29819256
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Sep 2019 13:19:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD078A4054;
        Mon, 30 Sep 2019 13:19:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B645CA4067;
        Mon, 30 Sep 2019 13:19:55 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 30 Sep 2019 13:19:55 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 588C0E01C8; Mon, 30 Sep 2019 15:19:55 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        qemu-s390x <qemu-s390x@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PULL 00/12] s390x qemu updates 20190930
Date:   Mon, 30 Sep 2019 15:19:43 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19093013-0016-0000-0000-000002B21347
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19093013-0017-0000-0000-00003312EE86
Message-Id: <20190930131955.101131-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-30_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909300138
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

