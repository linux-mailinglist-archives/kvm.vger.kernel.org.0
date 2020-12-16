Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0A52DC797
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgLPUO1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:14:27 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728783AbgLPUO1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:14:27 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK313A079780
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IERvzUj3rwx2mjIssMn/97qRkSDU1evfeQiSHjsm2Zc=;
 b=f6PyIzdVl/H8Yo9UhCeDXF+YbJFFytlPkHlGLAg4bFea9MGjb2hpodN6rluYrDBwtavw
 3QL8SiFCF8iKakiKFYrTqWwCVEfJy3I1wEhnW6/y4pdcaaG0oTWSR/TWkgCG1SIFk+RD
 8b22zGAIPNDWne2IXssQSxlfzAmisuoefOJs41vHAlZlPTDxdjam37RmiXL6f9pFWZ4+
 FDhfYdpO+8O9cxX+irWigW7O9Mi0RfH/OcQPDdWwWNWQBLbAD6mVx9w4ZhxpIOXnLv2E
 Kx45LXXzVk0kwnAGPJNXIpqlmfy8MzOsIVwQN1Wm5rYAT+EUqn1lj7E7fErEkMXbcGc7 qA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fqbqtwpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:45 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK39Mc081247
        for <kvm@vger.kernel.org>; Wed, 16 Dec 2020 15:13:44 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fqbqtwp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:13:44 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK79Tr021456;
        Wed, 16 Dec 2020 20:13:43 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 35cng8evkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:13:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKCQGb36110782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:12:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 048D342042;
        Wed, 16 Dec 2020 20:12:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9516C42047;
        Wed, 16 Dec 2020 20:12:25 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.10.74])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:12:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        pbonzini@redhat.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com
Subject: [kvm-unit-tests PATCH v1 12/12] lib/alloc_page: default flags and zero pages by default
Date:   Wed, 16 Dec 2020 21:12:00 +0100
Message-Id: <20201216201200.255172-13-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201216201200.255172-1-imbrenda@linux.ibm.com>
References: <20201216201200.255172-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new function page_alloc_set_default_flags can be used to set the
default flags for allocations. The passed value will be ORed with the
flags argument passed to the allocator at each allocation.

The default value for the default flags is FLAG_ZERO, which means that
by default all allocated memory is now zeroed, restoring the default
behaviour that had been accidentally removed by a previous commit.

If needed, a testcase can call page_alloc_set_default_flags(0) in order
to get non-zeroed pages from the allocator. For example, if the
testcase will need fresh memory, the zero flag should be removed from
the default.

Fixes: 8131e91a4b61 ("lib/alloc_page: complete rewrite of the page allocator")
Reported-by: Nadav Amit <nadav.amit@gmail.com>

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/alloc_page.h | 3 +++
 lib/alloc_page.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 1039814..8b53a58 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -22,6 +22,9 @@
 /* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
 
+/* Sets the default flags for the page allocator, the default is FLAG_ZERO */
+void page_alloc_set_default_flags(unsigned int flags);
+
 /*
  * Initializes a memory area.
  * n is the number of the area to initialize
diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 4d5722f..08e0d05 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -54,12 +54,19 @@ static struct mem_area areas[MAX_AREAS];
 static unsigned int areas_mask;
 /* Protects areas and areas mask */
 static struct spinlock lock;
+/* Default behaviour: zero allocated pages */
+static unsigned int default_flags = FLAG_ZERO;
 
 bool page_alloc_initialized(void)
 {
 	return areas_mask != 0;
 }
 
+void page_alloc_set_default_flags(unsigned int flags)
+{
+	default_flags = flags;
+}
+
 /*
  * Each memory area contains an array of metadata entries at the very
  * beginning. The usable memory follows immediately afterwards.
@@ -394,6 +401,7 @@ static void *page_memalign_order_flags(u8 ord, u8 al, u32 flags)
 	void *res = NULL;
 	int i, area, fresh;
 
+	flags |= default_flags;
 	fresh = !!(flags & FLAG_FRESH);
 	spin_lock(&lock);
 	area = (flags & AREA_MASK) ? flags & areas_mask : areas_mask;
-- 
2.26.2

