Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A752127AFE8
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 16:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgI1OXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 10:23:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38292 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726327AbgI1OXp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 10:23:45 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08SE2RmA090294;
        Mon, 28 Sep 2020 10:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=XRXRkWlANitcZgKg896dnP8UeTTtQftCziZtY5iTuV8=;
 b=r1lVjEDUQ4QEEs3T0cxtWEL6XsxI6uIzLS/UbioGcDpJA38TmQxGguHhXbk4CuXJ8D2b
 Q5zZfzOh4hm+J5k12BlMK3QACHy+ZiB+DJbXd0MWYVR45x5yUsurTkMSfrXdOOXCSEi+
 wbflvh6kYoNomezjKDfB+nGQqmR0+4wrmeCEy2jZIWjxjo8pl0hOP0bUdLU2x7TExAvf
 RHChVeXl743sKo+4LCxd0j7HHGWnx76EbrQJh0Rr20dTRrtwcEzuYwaIhpk0y4HOd54w
 Buq4AJx/v3/+FDilMzYONS5ZEStvsxbx0mvi3Q5FoYA8qBdrR8IwyqndhrqLP/3uaDpL BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ufvy441x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08SE2tcb092161;
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ufvy4410-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:43 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08SENDwW009075;
        Mon, 28 Sep 2020 14:23:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 33u5r9gmee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 14:23:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08SENcUM31719790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 14:23:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5DF042049;
        Mon, 28 Sep 2020 14:23:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BD474203F;
        Mon, 28 Sep 2020 14:23:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.66.164])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 14:23:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/4] s390x: css: pv: css test adaptation for PV
Date:   Mon, 28 Sep 2020 16:23:33 +0200
Message-Id: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_14:2020-09-28,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

I send a v2 even I got not a lot of answers for v1 because:
1 I forgot the kvm-unit-test header
2 the patch on uv.h was very bad
3 I saw some stupid errors I can correct myself like
  to zero the allocated page before use or free it on error.

That said, here what is done:

To adapt the CSS I/O tests to protected virtualisation we need
utilities to:

1- allocate the I/O buffers in a private page (patch 3)
   It must be in a dedicated page to avoid exporting code or
   guest private data to the host.

2- share  the I/O buffer with the host (patch 2)

3- be sure to allocate memory under 2Gb (patch 1)

The 3 first patches are the implementation of the tools,
patch 4 is the modification of the css.c test for PV.

regards,
Pierre

Pierre Morel (4):
  memory: allocation in low memory
  s390x: pv: implement routine to share/unshare memory
  s390x: define UV compatible I/O allocation
  s390x: css: pv: css test adaptation for PV

 lib/alloc_dma_page.c  | 57 +++++++++++++++++++++++++++++++++++++++++++
 lib/alloc_dma_page.h  | 24 ++++++++++++++++++
 lib/s390x/asm/uv.h    | 50 +++++++++++++++++++++++++++++++++++++
 lib/s390x/css.h       |  3 +--
 lib/s390x/css_lib.c   | 28 ++++++---------------
 lib/s390x/malloc_io.c | 49 +++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 18 ++++++++++++++
 lib/s390x/sclp.c      |  2 ++
 s390x/Makefile        |  2 ++
 s390x/css.c           | 35 +++++++++++++++++---------
 10 files changed, 235 insertions(+), 33 deletions(-)
 create mode 100644 lib/alloc_dma_page.c
 create mode 100644 lib/alloc_dma_page.h
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

-- 
2.25.1

changelog:

from v1:

- add the kvm-unit-test header

- correct checks for errors on Set/Remove Shared Access

- Add report for uv Set/Remove Shared Access

- zero the allocated I/O page before use

- free the page on error.

