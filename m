Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CB3378FE5
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbhEJN5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:57:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64988 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237059AbhEJNxQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:53:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14ADXJjQ154698;
        Mon, 10 May 2021 09:52:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Q+7Zj+sId07YdnyuQKTNdwpNALxH64Rq4oYQa5Y8ywQ=;
 b=fmentmrNlw1A+V+zOpRM2YmkrbdKEVsKkT27wlE8HgWk0VfjqxDJrnnflAnsABmUmh2G
 IH57mcQTb5ARMIC8u0Oh+8trvjvQNkHibdzXGrjdJnzahUGxcMuKbnJPKVDpsVrTByiQ
 buEn1l/vTK4s1ZXa25gZHddb+t/sS8CbOAolRgX6PUJ/HJW2rrKn0/tzy5unIYyI0vGP
 h0DtIDUI0K3zMXWqFICC1ligeXJZsU3n3RD2XYEO2xRBPFujNAcaIhaoFT+l0L3PF65R
 2XuqCrp8VFMam85G5jXWOcGXQg6TKQ/1jI7k/FpQq53CnWQKQ276poQpv7Gcg9XMNMpG wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3scvyf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:08 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14ADXhwk158340;
        Mon, 10 May 2021 09:52:08 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38f3scvye4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 09:52:08 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14ADgeBA001637;
        Mon, 10 May 2021 13:52:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 38dj9890cn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 13:52:05 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14ADq16p38732266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 13:52:01 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1F36A405F;
        Mon, 10 May 2021 13:52:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EEBB4A4055;
        Mon, 10 May 2021 13:52:00 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 13:52:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/6] s390x: uv: Extend guest test and add host test
Date:   Mon, 10 May 2021 13:51:42 +0000
Message-Id: <20210510135148.1904-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 34i-dDaPE6WTEsU0Q8v7mE5HVw-4d5te
X-Proofpoint-GUID: FP-gzwibUrgvf7F1ZUoySFVU_T4RCifs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_07:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 mlxscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105100096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

My stack of patches is starting to lean, so lets try to put some of
them upstream...

The first part is just additions to the UV guest test and a library
that makes checking the installed UV calls easier. Additionally we now
check for the proper UV share/unshare availability when allocating IO
memory instead of only relying on stfle 158.

The second part adds a UV host test with a large number UV of return
code checks.

v2:
	* Added rev-bys
	* Added stfle 158 check to uv_os_is_host/guest
	* Added asserts to uv_query_test_feature()
	  * Prevent specifying bit nr outside of range
	  * Prevent checking for features without having queried them
	* Added !feature bit check to uv guest/host invalid command test
	* Renamed uv_query_test_feature() to uv_query_test_call()

Janosch Frank (6):
  s390x: uv-guest: Add invalid share location test
  s390x: Add more Ultravisor command structure definitions
  s390x: uv: Add UV lib
  s390x: Test for share/unshare call support before using them
  s390x: uv-guest: Test invalid commands
  s390x: Add UV host test

 lib/s390x/asm/uv.h    | 152 ++++++++++++-
 lib/s390x/io.c        |   2 +
 lib/s390x/malloc_io.c |   5 +-
 lib/s390x/uv.c        |  45 ++++
 lib/s390x/uv.h        |  10 +
 s390x/Makefile        |   2 +
 s390x/uv-guest.c      |  60 +++++-
 s390x/uv-host.c       | 480 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 743 insertions(+), 13 deletions(-)
 create mode 100644 lib/s390x/uv.c
 create mode 100644 lib/s390x/uv.h
 create mode 100644 s390x/uv-host.c

-- 
2.30.2

