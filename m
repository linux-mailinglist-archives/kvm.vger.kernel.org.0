Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5BF244BA9
	for <lists+kvm@lfdr.de>; Fri, 14 Aug 2020 17:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgHNPKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Aug 2020 11:10:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28434 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726270AbgHNPKR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Aug 2020 11:10:17 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07EF5mpX176841
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UBY2P5ekcgoY8kYJVVlfVycQIuOjU1fhSxJBnYhyneE=;
 b=FlIm1bn6tVBtVEZQzrs3v8uJWt7M9pUcNVmTOxk6vOV7vLWd0iJ8tP/gK/aJfXI8/2lC
 G9g3hW5E/6RaDwMPnmfy51rT/mXXtnDDTQRqVxNviPOxOwS5/iZsqLIZnCPZ8nvYKchs
 SmY/J5HPDBexH5TZ+ZHoiUFY/GVLPU/vFy8QYNCzeKspCApbbIzyTv+nnG5ZCwyaFPcB
 MsbJbds5hMx+XZCg6jwgKNeaA2O0bYoISo1QA8L2+wnpB5JKjD4ykPDyxlexXcG2D1qP
 Deoej20NFws+dUMa8c+5QSXtXtpPy35Hq0lGcHLuMHv/YlITDh3Awx3v0ZQHn6DgDqGY Hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w6tccahb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:15 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07EF9kEG191265
        for <kvm@vger.kernel.org>; Fri, 14 Aug 2020 11:10:15 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w6tccaft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 11:10:15 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07EF17e0023777;
        Fri, 14 Aug 2020 15:10:13 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 32skp8eqqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Aug 2020 15:10:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07EFAAhL24838452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Aug 2020 15:10:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FB42A4057;
        Fri, 14 Aug 2020 15:10:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC5A5A404D;
        Fri, 14 Aug 2020 15:10:09 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.223])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Aug 2020 15:10:09 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
Subject: [kvm-unit-tests RFC v1 0/5] Rewrite the allocators
Date:   Fri, 14 Aug 2020 17:10:04 +0200
Message-Id: <20200814151009.55845-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-14_09:2020-08-14,2020-08-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=2
 malwarescore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 adultscore=0 spamscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008140114
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM unit tests are increasingly being used to test more than just
KVM.  They are being used to test TCG, qemu I/O device emulation, other
hypervisors, and even actual hardeware.

The existing memory allocators are becoming more and more inadequate to
the needs of the upcoming unit tests (but also some existing ones, see
below).

Some important features that are lacking:
* ability to perform a small physical page allocation with a big
  alignment withtout wasting huge amounts of memory
* ability to allocate physical pages from specific pools/areaas (e.g.
  below 16M, or 4G, etc)
* ability to reserve arbitrary pages (if free), removing them from the
  free pool

Some other features that are nice, but not so fundamental:
* no need for the generic allocator to keep track of metadata
  (i.e. allocation size), this is now handled by the lower level
  allocators
* coalescing small blocks into bigger ones, to allow contiguous memory
  freed in small blocks in a random order to be used for large
  allocations again

This is achieved in the following ways:

For the virtual allocator:
* only the virtul allocator needs one extra page of metadata, but only
  for allocations that wouldn't fit in one page

For the page allocator:
* page allocator has up to 4 memory pools, each pool has a metadata
  area; the metadata has a byte for each page in the area, describing
  the order of the block it belongs to, and whether it is free
* if there are no free blocks of the desired size, a bigger block is
  split until we reach the required size; the unused parts of the block
  are put back in the free lists
* if an allocation needs an allocation with a larger alignment than its
  size, a larger block of (at least) the required order is split; the
  unused parts put back in the free lists
* if the allocation could not be satisfied, the next allowed area is
  searched; the allocation fails only when all allowed areas have been
  tried
* new functions to perform allocations from specific areas; the areas
  are arch-dependent and should be set up by the arch code
* for now x86 has a memory area for "low" memory under 4GB and one for
  the rest, while s390x has one for under 2GB and one for the rest;
  suggestions more fine grained areas are welcome
* upon freeing a block, an attempt is made to coalesce it into the
  appropriate neighbour (if it is free), and so on for the resulting
  larger block thus obtained

For the physical allocator:
* the minimum alignment is now handled manually, since it has been
  removed from the common struct


This patchset addresses some current but otherwise unsolvable issues on
s390x, such as the need to allocate a block under 2GB for each SMP CPU
upon CPU activation.

This patch has been tested on s390x, amd64 and i386. It has also been
compiled on aarch64.

Claudio Imbrenda (5):
  lib/vmalloc: vmalloc support for handling allocation metadata
  lib/alloc_page: complete rewrite of the page allocator
  lib/alloc: simplify free and malloc
  lib/alloc.h: remove align_min from struct alloc_ops
  lib/alloc_page: allow reserving arbitrary memory ranges

 lib/alloc.h      |   3 +-
 lib/alloc_page.h |  81 +++++++-
 lib/alloc.c      |  42 +---
 lib/alloc_page.c | 510 ++++++++++++++++++++++++++++++++++++++---------
 lib/alloc_phys.c |   9 +-
 lib/arm/setup.c  |   2 +-
 lib/s390x/sclp.c |  11 +-
 lib/s390x/smp.c  |   6 +-
 lib/vmalloc.c    | 121 +++++++++--
 s390x/smp.c      |   4 +-
 10 files changed, 617 insertions(+), 172 deletions(-)

-- 
2.26.2

