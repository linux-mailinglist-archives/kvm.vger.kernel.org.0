Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3945526871F
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 10:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgINIWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 04:22:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11726 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbgINIWc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 04:22:32 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08E82pPR126012;
        Mon, 14 Sep 2020 04:22:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=WnIPdjUKoeLAe7veVDsA/TJZABPslb4ZWvsP/a6LVyw=;
 b=VrYMcWxhmskx9LGYvMFOdNOnYm93z02JgpABsII4LuQv5f4w7t25eBNrPU2+j9nvQtBP
 ldQ6DnrJTvkOS4U75qA5oEzzLtyYCs0739sUpvqecFja4tT4294Nby9M+Codj6MhInGj
 14trxij3n1o6A40qiG+7GqRlOz11Y4ZH992wWT+sJWrOtohQ9KkN5hdHAkMU7Xn0qUm5
 UbS3kF0w4tVFUV2O3d/eX5x0V5ZNTNvyO2CybG8/9X/31dC0Qhsky3r8EswJSghaglE7
 cQu3aIVeZ6Po4ueWVUhVNCth4pZf1fNmqau+FAs4WoK3hVaprxoHQmOTo8YdWp+MK1F7 lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j2m5khye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:22:31 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08E8357Z126780;
        Mon, 14 Sep 2020 04:22:30 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33j2m5khu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 04:22:28 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08E8Lq66001852;
        Mon, 14 Sep 2020 08:22:19 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33hb1j134a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 08:22:19 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08E8MGiA18219338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 08:22:16 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BAC74C040;
        Mon, 14 Sep 2020 08:22:16 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7903A4C059;
        Mon, 14 Sep 2020 08:22:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 14 Sep 2020 08:22:16 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 31562E235D; Mon, 14 Sep 2020 10:22:16 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 0/1] KVM: s390: add documentation for KVM_CAP_S390_DIAG318 (5.9)
Date:   Mon, 14 Sep 2020 10:22:14 +0200
Message-Id: <20200914082215.6143-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.4
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-13_09:2020-09-10,2020-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=857
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

one missing piece of documentation for the diag318 interface that was
added in 5.9-rc1.

The following changes since commit 37f66bbef0920429b8cb5eddba849ec4308a9f8e:

  KVM: emulator: more strict rsm checks. (2020-09-12 12:22:55 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.9-1

for you to fetch changes up to f20d4e924b4465822c4a35290b85aadf88ddf466:

  docs: kvm: add documentation for KVM_CAP_S390_DIAG318 (2020-09-14 09:08:10 +0200)

----------------------------------------------------------------
KVM: s390: add documentation for KVM_CAP_S390_DIAG318

diag318 code was merged in 5.9-rc1, let us add some
missing documentation

----------------------------------------------------------------
Collin Walling (1):
      docs: kvm: add documentation for KVM_CAP_S390_DIAG318

 Documentation/virt/kvm/api.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
