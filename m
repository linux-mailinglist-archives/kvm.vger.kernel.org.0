Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFF12B4393
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730054AbgKPMUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:20:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35202 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgKPMUk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:20:40 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGC331a150243;
        Mon, 16 Nov 2020 07:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=aKyc9fIlCB1NAJIHYJRL2WFrO9tcsS9P236KmnyqNcM=;
 b=eMdOFn4Qcxa4BeYbDw60+aprbsUNjED3jdWNbNiUc7VDyqk8qjDLSyZa2D/6WenWhU5w
 FHGFgjF+GjVIpJvvR1RjYZX+t5P7Xw5GoW8Y9YJW8t7wZ1/rxfl244wCz7wEjW/lKUua
 l2ECsxeds5tQ/SQ5BX/m84bL6f+AYFO1x2M3MiEpkuNF8Tgoe9h7k3ZDlDGusHn/VG0P
 jMZdSzc6o1jxY9I/pw5u9bWy2mN6sv6aTfpK70oKJhiGI0Xp4HE7H53x/kfPs3Fb+SmF
 8JK4euxLF4Q9xQKll2GdDk8mP1d8w3GGbnVFNEHRcnyN1FaOC1Zb6z5o5nC36FIAO3rf ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34urwh0qb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 07:20:39 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AGC9U0J193682;
        Mon, 16 Nov 2020 07:20:39 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34urwh0q9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 07:20:39 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGCCvqe010422;
        Mon, 16 Nov 2020 12:20:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 34t6v891pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 12:20:36 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGCKY3x66126196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 12:20:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6003AE053;
        Mon, 16 Nov 2020 12:20:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D24A4AE051;
        Mon, 16 Nov 2020 12:20:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 16 Nov 2020 12:20:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 88103E0367; Mon, 16 Nov 2020 13:20:33 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Collin Walling <walling@linux.ibm.com>
Subject: [GIT PULL 0/2] KVM: s390: Fixes for 5.10
Date:   Mon, 16 Nov 2020 13:20:31 +0100
Message-Id: <20201116122033.382372-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
X-TM-AS-GCONF: 00
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_03:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 phishscore=0 bulkscore=0 mlxlogscore=747 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011160073
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

2 fixes for KVM on s390 for 5.10.

The following changes since commit 6d6a18fdde8b86b919b740ad629153de432d12a8:

  KVM: selftests: allow two iterations of dirty_log_perf_test (2020-11-09 09:45:17 -0500)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.10-1

for you to fetch changes up to 6cbf1e960fa52e4c63a6dfa4cda8736375b34ccc:

  KVM: s390: remove diag318 reset code (2020-11-11 09:31:52 +0100)

----------------------------------------------------------------
KVM: s390: Fixes for 5.10

- do not reset the global diag318 data for per-cpu reset
- do not mark memory as protected too early

----------------------------------------------------------------
Collin Walling (1):
      KVM: s390: remove diag318 reset code

Janosch Frank (1):
      KVM: s390: pv: Mark mm as protected after the set secure parameters and improve cleanup

 arch/s390/kvm/kvm-s390.c | 4 +---
 arch/s390/kvm/pv.c       | 3 ++-
 arch/s390/mm/gmap.c      | 2 ++
 3 files changed, 5 insertions(+), 4 deletions(-)
