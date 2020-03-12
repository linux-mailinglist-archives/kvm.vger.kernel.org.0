Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3A31832F7
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 15:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgCLO2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 10:28:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727208AbgCLO2h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Mar 2020 10:28:37 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CEMPJW063261
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 10:28:35 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yqksa85r6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 10:28:33 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 12 Mar 2020 14:27:55 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 14:27:52 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CERpUF44302818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 14:27:51 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AC2B11C054;
        Thu, 12 Mar 2020 14:27:51 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34F2111C04C;
        Thu, 12 Mar 2020 14:27:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 12 Mar 2020 14:27:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id D9006E02CF; Thu, 12 Mar 2020 15:27:50 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 0/1] KVM: s390: Fix for 5.6
Date:   Thu, 12 Mar 2020 15:27:49 +0100
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20031214-4275-0000-0000-000003AB325B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031214-4276-0000-0000-000038C0514D
Message-Id: <20200312142750.3603-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_06:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=572 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003120078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

one fix for the reset that was detected by some improved selftests:

The following changes since commit d718fdc3e752ba51ddb2b5554d3db98a09355cc2:

  KVM: x86: remove stale comment from struct x86_emulate_ctxt (2020-03-03 17:38:22 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.6-1

for you to fetch changes up to e93fc7b4544a5475cfdbc22f87e89f9829bf801c:

  KVM: s390: Also reset registers in sync regs for initial cpu reset (2020-03-11 08:25:26 +0100)

----------------------------------------------------------------
KVM: s390: Fully do the CPU resets as intended

With 7de3f1423ff9 ("KVM: s390: Add new reset vcpu API") we clarified
the meaning of the reset ioctl to fully reset the CPU and not only the
parts that can not be handled by userspace. Turns out that we missed
some parts.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: Also reset registers in sync regs for initial cpu reset

 arch/s390/kvm/kvm-s390.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

