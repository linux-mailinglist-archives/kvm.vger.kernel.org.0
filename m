Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1861C6FC9
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgEFL7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:59:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgEFL7x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:59:53 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046BWqkX056618;
        Wed, 6 May 2020 07:59:53 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30uf8hwhtn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 07:59:53 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 046BjNZ2116765;
        Wed, 6 May 2020 07:59:52 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30uf8hwhsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 07:59:52 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 046BoePO014961;
        Wed, 6 May 2020 11:59:50 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 30s0g5kp0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 May 2020 11:59:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 046Bxlt451118108
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 May 2020 11:59:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DB2511C050;
        Wed,  6 May 2020 11:59:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED00511C054;
        Wed,  6 May 2020 11:59:46 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  6 May 2020 11:59:46 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A6AB3E0554; Wed,  6 May 2020 13:59:46 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 0/1] KVM: s390: Fix for running nested under z/VM
Date:   Wed,  6 May 2020 13:59:44 +0200
Message-Id: <20200506115945.13132-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_04:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=879 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005060088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,
a fix for kvm/master.

The following changes since commit 2a173ec993baa6a97e7b0fb89240200a88d90746:

  MAINTAINERS: add a reviewer for KVM/s390 (2020-04-20 11:24:00 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-master-5.7-3

for you to fetch changes up to 5615e74f48dcc982655543e979b6c3f3f877e6f6:

  KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction (2020-05-05 11:15:05 +0200)

----------------------------------------------------------------
KVM: s390: Fix for running nested uner z/VM

There are circumstances when running nested under z/VM that would trigger a
WARN_ON_ONCE. Remove the WARN_ON_ONCE. Long term we certainly want to make this
code more robust and flexible, but just returning instead of WARNING makes
guest bootable again.

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: Remove false WARN_ON_ONCE for the PQAP instruction

 arch/s390/kvm/priv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
