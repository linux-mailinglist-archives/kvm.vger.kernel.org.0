Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEB9204DFB
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732198AbgFWJbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:31:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1942 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731945AbgFWJbA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:31:00 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N922Vq034764;
        Tue, 23 Jun 2020 05:31:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysr85dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 05:30:59 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05N9Uxhm158687;
        Tue, 23 Jun 2020 05:30:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysr82ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 05:30:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05N9OP7x008836;
        Tue, 23 Jun 2020 09:24:25 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 31sa37vuup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 09:24:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05N9OMTY50921618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 09:24:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B3125205A;
        Tue, 23 Jun 2020 09:24:22 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.62.182])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 19AE75204F;
        Tue, 23 Jun 2020 09:24:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/1] KVM: s390: Fix for 5.8
Date:   Tue, 23 Jun 2020 11:23:40 +0200
Message-Id: <20200623092341.10348-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 cotscore=-2147483648 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please pull this fix reducing the number of (currently unused) iopins
for kvm/master.


The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:

  Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-5.8-3

for you to fetch changes up to 774911290c589e98e3638e73b24b0a4d4530e97c:

  KVM: s390: reduce number of IO pins to 1 (2020-06-18 09:48:19 +0200)

----------------------------------------------------------------
The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
allocation (32kb) for each guest start/restart which can result in OOM
killer activity when kernel memory is fragmented enough.

This fix reduces the number of iopins as s390 doesn't use them, hence
reducing the memory footprint.

----------------------------------------------------------------

Christian Borntraeger (1):
  KVM: s390: reduce number of IO pins to 1

 arch/s390/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.4

