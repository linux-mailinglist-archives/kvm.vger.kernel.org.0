Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0AE72FE630
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 10:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbhAUJUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 04:20:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728502AbhAUJOO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 04:14:14 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10L91lM9055296;
        Thu, 21 Jan 2021 04:13:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=FT6aVVT/EIDQ2qhbr6PLGxD5HMtkOfxnITx0veMWTeo=;
 b=dKJg0o79XyIdT4+MWY8oY6P4uulwkNK4f6xL61lJHAUIZZLORV4MRkCAbklUliLVMNJB
 wrjb4xhl1QFHnpLxcP7ij9P7SR3W/W9yd7XCEqGpsHxIeAtgCdfdXp0RpKalZB6jURNs
 rNstMyfpFM/W2qSrXPHy9Pbv0KUetiCvK/3D34YWfrXyiFeiPUCtKJuLVOEEUereirbP
 ZrhgUu2ptvMdCZKTWRWeqQiEXFDNAhuhXtoBpy2djpCTlXCoblXQVuihwq1zu+cxUnwH
 bOdQsWoJHElVjMRpLXvtGDXsexD8p5gUX1Du6pJvSzEUVJtU/h4LfZ8yxjCaLQOEwUEw Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3675ychcbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:13:20 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10L91q4r055554;
        Thu, 21 Jan 2021 04:13:20 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3675ychca9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 04:13:19 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10L984bG031640;
        Thu, 21 Jan 2021 09:13:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3668pasfu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 09:13:17 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10L9DEO750528732
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 09:13:14 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FE984203F;
        Thu, 21 Jan 2021 09:13:14 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 299A842047;
        Thu, 21 Jan 2021 09:13:14 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.36.14])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 09:13:14 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v4 0/3] s390x: css: pv: css test adaptation for PV
Date:   Thu, 21 Jan 2021 10:13:09 +0100
Message-Id: <1611220392-22628-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_03:2021-01-20,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210045
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

To adapt the CSS I/O tests to protected virtualisation we need
utilities to:

1- allocate the I/O buffers in a private page using (patch 2)
   It must be in a dedicated page to avoid exporting code or
   guest private data to the host.
   We accept a size in byte and flags and allocate page integral
   memory to handle the Protected Virtualization.

2- share the I/O buffers with the host (patch 1)
   This patch uses the page allocator reworked by Claudio.

The 2 first patches are the implementation of the tools,
patch 3 is the modification of the css.c test for PV.

The checkpatch always asked me to modify MAINTAINERS,
so I added me as reviewer to be in copy for CSS at least.
May be we could create a finer grain MAINTAINERS in the
future.

regards,
Pierre

Pierre Morel (3):
  s390x: pv: implement routine to share/unshare memory
  s390x: define UV compatible I/O allocation
  s390x: css: pv: css test adaptation for PV

 MAINTAINERS           |  1 +
 lib/s390x/asm/uv.h    | 38 +++++++++++++++++++++++
 lib/s390x/css.h       |  3 +-
 lib/s390x/css_lib.c   | 28 +++++------------
 lib/s390x/malloc_io.c | 70 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 45 ++++++++++++++++++++++++++++
 s390x/Makefile        |  1 +
 s390x/css.c           | 43 ++++++++++++++++++--------
 8 files changed, 195 insertions(+), 34 deletions(-)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

-- 
2.17.1

changelog:

from v3:
- add failure report to the new allocations in css.c
  (Thomas)

- rework alloc_io_page and free_io_page
  (Thomas, Claudio)

- add SPDX licenses
  (Thomas)

- add comment for the functions declaration.

- add me as reviewer for the CSS

from v2:

- use the page allocator reworked by Claudio

from v1:

- add the kvm-unit-test header

- correct checks for errors on Set/Remove Shared Access

- Add report for uv Set/Remove Shared Access

- zero the allocated I/O page before use

- free the page on error.

