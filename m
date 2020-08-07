Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E0B23EC2C
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 13:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHGLQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 07:16:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34878 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726058AbgHGLQF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 07:16:05 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 077B1k0E074946;
        Fri, 7 Aug 2020 07:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=XQhED+tjxcBk2z9E75rFyuvJ1LMrPUPqrx1hrdAqRtc=;
 b=eWJeJF2OOILOhqXPjoBfjKTJQXuwhbLau2+orlw9n7SFiGa8uNSLGO321ZULxEPc4aSC
 qwcZP6Kzki/3AsOSu68hHGvUmDXFHsBOeNk1430TAI2rSgnJ8I/Dpoi2zTDd8FdUsr+7
 2STYfAYXwoM3fmGcRhAhPhgtIvFJF/TPoVjAHiwnV/AF5E4Go8KplWrRvKZdsZkrIeGA
 JAbK+yOZkeE6pBvoep0Xl3uhEhejopF3iKaHpaqw+ynibiqRyvXlvxvY7ob0sih9Pji2
 aceXRld4UpyjTAdCxZ4CeIeHFL+qhiH+7Vd8PUuKIgBu0BCuKv4rOG1r8ZqXxERun/jr SQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32rg3p9wy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 07:16:03 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 077B1xj4075530;
        Fri, 7 Aug 2020 07:16:03 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32rg3p9wxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 07:16:03 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 077Asjp3002750;
        Fri, 7 Aug 2020 11:16:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 32n0186k0u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Aug 2020 11:16:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 077BFwmQ13566346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Aug 2020 11:15:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59A91AE057;
        Fri,  7 Aug 2020 11:15:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96EADAE059;
        Fri,  7 Aug 2020 11:15:57 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  7 Aug 2020 11:15:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/3] PV tests part 1
Date:   Fri,  7 Aug 2020 07:15:52 -0400
Message-Id: <20200807111555.11169-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-07_06:2020-08-06,2020-08-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0
 mlxlogscore=960 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008070077
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's start bringing in some more PV related code.

Somehow I missed that we can also have a key in a exception new
PSW. The interesting bit is that if such a PSW is loaded on an
exception it will result in a specification exception and not a
special operation exception.

The third patch adds a basic guest UV call API test. It has mostly
been used for firmware testing but I also think it's good to have a
building block like this for more PV tests.


GIT: https://gitlab.com/frankja/kvm-unit-tests/-/tree/queue


v2:
	* Renamed pgm_int_func to pgm_cleanup_func() and moved the call to handle_pgm_int()
	* Added page allocation to UV test
	* Cleanups

Janosch Frank (3):
  s390x: Add custom pgm cleanup function
  s390x: skrf: Add exception new skey test and add test to unittests.cfg
  s390x: Ultravisor guest API test

 lib/s390x/asm/interrupt.h |   1 +
 lib/s390x/asm/uv.h        |  74 +++++++++++++++++
 lib/s390x/interrupt.c     |  12 ++-
 s390x/Makefile            |   1 +
 s390x/skrf.c              |  79 +++++++++++++++++++
 s390x/unittests.cfg       |   7 ++
 s390x/uv-guest.c          | 162 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 335 insertions(+), 1 deletion(-)
 create mode 100644 lib/s390x/asm/uv.h
 create mode 100644 s390x/uv-guest.c

-- 
2.25.1

