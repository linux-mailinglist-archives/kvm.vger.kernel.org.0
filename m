Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3813A67BE
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 15:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbhFNN01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 09:26:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233224AbhFNN00 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Jun 2021 09:26:26 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15ED37dM184565;
        Mon, 14 Jun 2021 09:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=AOd7hT6IqUJsqtAr/hajjvw5zxOTDer/KKMrZIafiWQ=;
 b=hlRYDCKlwNFrFKg9Ss3RfUAxuhI+MkRZ4mxNZ0HA2TCMpsF4DSLvPOKKqMe9e/ANSdrr
 v7acOImlVice4cPAxk61B/W7TpQ+m2i8BPZqQDhBeU4WI6sNtkJVXoCxBg/Q9G34NHhj
 bVpQwNTVWJ9126dihZafHRXLTETMmdNCiii7A7Ky3TUt18tyApak+cY9eVwY4WmaEBur
 ch1qxv9MhLURLLt5+67DqDBpJ7r8i8tHHP6OSFYc4SiihEWtb+N+ZN/lbghMxooUmoBa
 gEvNIIjS0zmHeppi5QXjYB9SRVkD0NILto3p3eNMcKGchRRpq96czwJaueUuILiu2nPv Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39673fsu1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 09:24:04 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15ED3J66187742;
        Mon, 14 Jun 2021 09:24:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39673fsu0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 09:24:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15EDO14J001901;
        Mon, 14 Jun 2021 13:24:01 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 394mj8rych-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 13:24:01 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15EDMx1M28901652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 13:22:59 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF3AF52054;
        Mon, 14 Jun 2021 13:23:58 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.73])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F18F65204E;
        Mon, 14 Jun 2021 13:23:57 +0000 (GMT)
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
Subject: [PATCH v4 0/2] mm: add vmalloc_no_huge and use it
Date:   Mon, 14 Jun 2021 15:23:55 +0200
Message-Id: <20210614132357.10202-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: f6LuAo1etUlBZ1PUEMEEyzesdKRCqQfk
X-Proofpoint-GUID: uSO97Z_Tmc4NkHhim8c2LbWtvWR-aVVK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_07:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 spamscore=0 mlxlogscore=522 impostorscore=0 suspectscore=0 clxscore=1015
 mlxscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106140089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add vmalloc_no_huge and export it, so modules can allocate memory with
small pages.

Use the newly added vmalloc_no_huge in KVM on s390 to get around a
hardware limitation.

v3->v4:
* reword commit messages to be more clear
* add comment in the second patch

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
  KVM: s390: prepare for hugepage vmalloc

 arch/s390/kvm/pv.c      |  7 ++++++-
 include/linux/vmalloc.h |  1 +
 mm/vmalloc.c            | 16 ++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

-- 
2.31.1

