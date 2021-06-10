Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEB83A2F93
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhFJPoo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:44:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4072 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231356AbhFJPom (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 11:44:42 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15AFWqd8029246;
        Thu, 10 Jun 2021 11:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HiYTFe6cLtCeeuwsccFxR5V37AhXH40ycT5J1sYOiQU=;
 b=b0Svo2+V1B1qZwO64HVWeZ194zZ/Cr9rjrfhhHWpFtuFdlcee5sJ9Mv4xJLXeR6SH+vh
 vr3eFcTJ3LrZKerDN+gqK72ioxb1giyI8qutxnWP+BFf5G1sA1qi9ebKFZgVH3vD8XyY
 ooChX1blJ9XSgQhs4eRk221EAq8FNYGS3Z83GM/EnuOmBFljCTlqkfYcT2foCXm3MWJm
 Oocziz8q3p0odry++X48fuakBpFix9q6tLd6y7/BAQrUmbyoSCJGxJKCXiWpIiBNE4Fb
 q6bmWLXCzJOSydLexvLBNBZbSyR4VlfOfk9hyLjrwJRhW4nWhuf2K1xDdH9rE3uTVl12 lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393nf189ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:42:27 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15AFZwr2039081;
        Thu, 10 Jun 2021 11:42:27 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 393nf189qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 11:42:27 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15AFXZuk032143;
        Thu, 10 Jun 2021 15:42:24 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3900w8jwt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Jun 2021 15:42:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15AFgLtH29622546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 15:42:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A17C24203F;
        Thu, 10 Jun 2021 15:42:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBA4442049;
        Thu, 10 Jun 2021 15:42:20 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.240])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 10 Jun 2021 15:42:20 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        david@redhat.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 0/2] mm: add vmalloc_no_huge and use it
Date:   Thu, 10 Jun 2021 17:42:18 +0200
Message-Id: <20210610154220.529122-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dJ15_EumK2J4urMghMx0IOHKOjEmGRF0
X-Proofpoint-ORIG-GUID: -GO27a1NJRTid1GfxKozKvRSQh4iN4Mw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-10_10:2021-06-10,2021-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 clxscore=1011 spamscore=0 lowpriorityscore=0 mlxlogscore=588
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vmalloc_no_huge and export it, so modules can allocate memory with
small pages.

Use the newly added vmalloc_no_huge in KVM on s390 to get around a
hardware limitation.

v2->v3:
* do not export __vmalloc_node_range
* add vmalloc_no_huge as a wrapper around __vmalloc_node_range
* use vmalloc_no_huge instead of __vmalloc_node_range in kvm on s390x

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Hellwig <hch@infradead.org>

Claudio Imbrenda (2):
  mm/vmalloc: add vmalloc_no_huge
  KVM: s390: fix for hugepage vmalloc

 arch/s390/kvm/pv.c      |  2 +-
 include/linux/vmalloc.h |  1 +
 mm/vmalloc.c            | 16 ++++++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

-- 
2.31.1

