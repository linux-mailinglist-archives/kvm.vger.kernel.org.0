Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAB7D27B6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 13:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbfJJLF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 07:05:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727116AbfJJLF0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Oct 2019 07:05:26 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9A9RYMV157650
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 07:05:25 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vj0kdx4v8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 07:05:25 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 10 Oct 2019 12:05:23 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 10 Oct 2019 12:05:19 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9AB4moI40108368
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 11:04:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEC5842047;
        Thu, 10 Oct 2019 11:05:18 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA1A342042;
        Thu, 10 Oct 2019 11:05:18 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 10 Oct 2019 11:05:18 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 79D3FE01C6; Thu, 10 Oct 2019 13:05:18 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 0/2] diag 9c improvements
Date:   Thu, 10 Oct 2019 13:05:16 +0200
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101011-0028-0000-0000-000003A8D31E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101011-0029-0000-0000-0000246ADB2A
Message-Id: <20191010110518.129256-1-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=402 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910100084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christian Borntraeger (2):
  KVM: s390: count invalid yields
  KVM: s390: Do not yield when target is already running

 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/kvm/diag.c             | 22 ++++++++++++++++++----
 arch/s390/kvm/kvm-s390.c         |  1 +
 3 files changed, 20 insertions(+), 4 deletions(-)

-- 
2.21.0

