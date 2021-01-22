Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1094300433
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 14:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbhAVN3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 08:29:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58188 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727681AbhAVN2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 08:28:46 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MD3dI0112907;
        Fri, 22 Jan 2021 08:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=wkt/YZgm4OBhVRTTECT6wzWMp0unp4VmQx7dqCR87iE=;
 b=CdbGTsDCrLf3peitYtOVUXBYyLLqsxeeJar3nVK/3AnUj724gv1LM4DaoXnYy984NWeL
 f+D6besvaG8SHeUOGD68e4BM4ku+8ggISfU+pLp6cwxKRD1ehNrFWD3SUs6hx2bJO9lA
 kptr/BUGd+KlxLndR/fIBjo01sDBCGkMbm0QoUmgvHfwIyiECNHKCncLzJcyUOWEFcfI
 aJMgIWgsy1ttquRI0uqw03VR1DLCFwDOYT0MmP6ugBmivfPSeRl3oHaB155/CtETufOT
 p5vW/kpX2yQmQ79Pfbm2/5BAs6goyzSAvSk2x19zpoSuGutGcZ8HH7JD14kAj7M0Gklk bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367x37b33r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:27:48 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MD4kkX121641;
        Fri, 22 Jan 2021 08:27:48 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367x37b32x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:27:48 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MDRJhu003178;
        Fri, 22 Jan 2021 13:27:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 367k0s8kv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 13:27:45 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MDRgrs49807620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 13:27:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4996A4057;
        Fri, 22 Jan 2021 13:27:42 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B360A4040;
        Fri, 22 Jan 2021 13:27:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.82.252])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 13:27:42 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v5 0/3] s390x: css: pv: css test adaptation for PV
Date:   Fri, 22 Jan 2021 14:27:37 +0100
Message-Id: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_09:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220071
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

 lib/s390x/asm/uv.h    | 39 ++++++++++++++++++++++++
 lib/s390x/css.h       |  3 +-
 lib/s390x/css_lib.c   | 28 +++++------------
 lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
 s390x/Makefile        |  1 +
 s390x/css.c           | 43 ++++++++++++++++++--------
 7 files changed, 196 insertions(+), 34 deletions(-)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

-- 
2.17.1

changelog:

from v4:

- better SPDX license
  (Thomast, Janosch)

- use get_order instead of a false calculation
  (Thomas)

- rename functions malloc_io_pages to malloc_io_mem
  (Thomas)

- Explicit error sentence for share errors
  (Janosch)

- use UVC_RC_EXECUTED instead of bare hexa in share
  (Janosch)

- removed MAINTAINERS changes, will be in another patch if ever
  (Janosch, Thomas)

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

