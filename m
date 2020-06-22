Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE12203C67
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgFVQVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:21:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729407AbgFVQVr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 12:21:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MG0gGr017121
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:47 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysprtwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:46 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05MG1BS5019793
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 12:21:46 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31tysprtv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 12:21:46 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05MG0LBJ019102;
        Mon, 22 Jun 2020 16:21:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 31sa37umsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 16:21:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05MGLfhf64749648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 16:21:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C491452051;
        Mon, 22 Jun 2020 16:21:41 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.197])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 734345204F;
        Mon, 22 Jun 2020 16:21:41 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/8] Minor fixes, improvements,  and cleanup
Date:   Mon, 22 Jun 2020 18:21:33 +0200
Message-Id: <20200622162141.279716-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_09:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxlogscore=749 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 clxscore=1015 cotscore=-2147483648 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220116
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series provides a bunch of small improvements, fixes and
cleanups.
Some of these fixes are needed for an upcoming series that will
significantly refactor and improve the memory allocators.

Claudio Imbrenda (8):
  x86/cstart.S: initialize stack before using it
  x86: add missing PAGE_ALIGN macro from page.h
  lib: use PAGE_ALIGN
  lib/alloc.c: add overflow check for calloc
  lib: Fix a typo and add documentation comments
  lib/vmalloc: fix potential race and non-standard pointer arithmetic
  lib/alloc_page: make get_order return unsigned int
  lib/vmalloc: add locking and a check for initialization

 lib/x86/asm/page.h |  2 ++
 lib/alloc_page.h   |  2 +-
 lib/alloc_phys.h   |  2 +-
 lib/vmalloc.h      |  8 ++++++++
 lib/alloc.c        | 36 +++++++++++++++++++++++++++++++++++-
 lib/alloc_page.c   |  2 +-
 lib/vmalloc.c      | 34 +++++++++++++++++++++++-----------
 x86/cstart.S       |  2 +-
 8 files changed, 72 insertions(+), 16 deletions(-)

-- 
2.26.2

