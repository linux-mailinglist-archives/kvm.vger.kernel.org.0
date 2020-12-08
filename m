Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C222D2DE5
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 16:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbgLHPJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 10:09:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51546 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727925AbgLHPJy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Dec 2020 10:09:54 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8F3OGV136929;
        Tue, 8 Dec 2020 10:09:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=DDTALXsM0JFGwV6p5LS+C2/BmUHS2x1iSw4xTD1U66U=;
 b=EZ6gTxX3zUYCUBZmPQ141rMilaEktLX6T0jfswRNGttkCWjsYJjSq7FEKY7OvpHRHBX1
 LpwNBUiNGyaJFxo4YCznO2AQUsZOJZe35njVdaJOor+XVUHtIl4UrTX+oyg6ndbAEUMq
 ntS48etwgWv2vAthhiG0O3JYU8WRKBE4C9UHZu+mmPZ/XDZoyyO/NMXAqjPEp/loKCYH
 9R3CqKesejKxDI9i1j9IqBL2hQfu1fOVMtd0zSNmeo2hjMasih0vTtlrgkqlEdUQafoJ
 VFHAB9oBtVdkfUvfLEB4dAnP4GXXMfkKfVcfbGlZmFXAriNVLsBNozlq8VyolY0vw8o1 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359s1ee81h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 10:09:14 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B8F3bSR139249;
        Tue, 8 Dec 2020 10:09:13 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 359s1ee80d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 10:09:13 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8F828K018362;
        Tue, 8 Dec 2020 15:09:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8ne3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 15:09:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8F98Eh6685284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 15:09:09 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C981FAE05A;
        Tue,  8 Dec 2020 15:09:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35DF1AE065;
        Tue,  8 Dec 2020 15:09:08 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 15:09:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/2] s390x: Move from LGPL 2 to GPL 2
Date:   Tue,  8 Dec 2020 10:09:00 -0500
Message-Id: <20201208150902.32383-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_09:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=1 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM and the KVM unit tests should be able to share code to improve
development speed and the LGPL is currently preventing us from doing
exactly that. Additionally we have a multitude of different licenses
in s390x files: GPL 2 only, GPL 2 or greater, LGPL 2 and LGPL 2.1 or
later.

This patch set tries to move the licenses to GPL 2 where
possible. Also we introduce the SPDX identifiers so the file headers
are more readable.

Janosch Frank (2):
  s390x: Move to GPL 2 and SPDX license identifiers
  s390x: lib: Move to GPL 2 and SPDX license identifiers

 lib/s390x/asm-offsets.c     | 4 +---
 lib/s390x/asm/arch_def.h    | 4 +---
 lib/s390x/asm/asm-offsets.h | 4 +---
 lib/s390x/asm/barrier.h     | 4 +---
 lib/s390x/asm/cpacf.h       | 1 +
 lib/s390x/asm/facility.h    | 4 +---
 lib/s390x/asm/float.h       | 4 +---
 lib/s390x/asm/interrupt.h   | 4 +---
 lib/s390x/asm/io.h          | 4 +---
 lib/s390x/asm/mem.h         | 4 +---
 lib/s390x/asm/page.h        | 4 +---
 lib/s390x/asm/pgtable.h     | 4 +---
 lib/s390x/asm/sigp.h        | 4 +---
 lib/s390x/asm/spinlock.h    | 4 +---
 lib/s390x/asm/stack.h       | 4 +---
 lib/s390x/asm/time.h        | 4 +---
 lib/s390x/css.h             | 4 +---
 lib/s390x/css_dump.c        | 4 +---
 lib/s390x/css_lib.c         | 4 +---
 lib/s390x/interrupt.c       | 4 +---
 lib/s390x/io.c              | 4 +---
 lib/s390x/mmu.c             | 4 +---
 lib/s390x/mmu.h             | 4 +---
 lib/s390x/sclp-console.c    | 5 +----
 lib/s390x/sclp.c            | 4 +---
 lib/s390x/sclp.h            | 5 +----
 lib/s390x/smp.c             | 4 +---
 lib/s390x/smp.h             | 4 +---
 lib/s390x/stack.c           | 4 +---
 lib/s390x/vm.c              | 3 +--
 lib/s390x/vm.h              | 3 +--
 s390x/cmm.c                 | 4 +---
 s390x/cpumodel.c            | 4 +---
 s390x/css.c                 | 4 +---
 s390x/cstart64.S            | 4 +---
 s390x/diag10.c              | 4 +---
 s390x/diag288.c             | 4 +---
 s390x/diag308.c             | 5 +----
 s390x/emulator.c            | 4 +---
 s390x/gs.c                  | 4 +---
 s390x/iep.c                 | 4 +---
 s390x/intercept.c           | 4 +---
 s390x/pfmf.c                | 4 +---
 s390x/sclp.c                | 4 +---
 s390x/selftest.c            | 4 +---
 s390x/skey.c                | 4 +---
 s390x/skrf.c                | 4 +---
 s390x/smp.c                 | 4 +---
 s390x/sthyi.c               | 4 +---
 s390x/sthyi.h               | 4 +---
 s390x/stsi.c                | 4 +---
 s390x/uv-guest.c            | 4 +---
 s390x/vector.c              | 4 +---
 53 files changed, 53 insertions(+), 157 deletions(-)

-- 
2.25.1

