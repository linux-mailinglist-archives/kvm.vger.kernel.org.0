Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C61223EFA
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 17:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgGQO62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 10:58:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30058 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbgGQO61 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Jul 2020 10:58:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HEWtoI017229;
        Fri, 17 Jul 2020 10:58:27 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32b8k32b80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:58:26 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06HEX2bl017930;
        Fri, 17 Jul 2020 10:58:26 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32b8k32b7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 10:58:26 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06HEpNUX027866;
        Fri, 17 Jul 2020 14:58:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3274pgxkxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jul 2020 14:58:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06HEwLdR29163776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jul 2020 14:58:21 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62AD842041;
        Fri, 17 Jul 2020 14:58:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94E5742049;
        Fri, 17 Jul 2020 14:58:20 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Jul 2020 14:58:20 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/3] PV tests part 1
Date:   Fri, 17 Jul 2020 10:58:10 -0400
Message-Id: <20200717145813.62573-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_06:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=837
 impostorscore=0 bulkscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's start bringing in some more PV related code.

Somehow I missed that we can also have a key in a exception new
PSW. The interesting bit when skrf is active is that if such a PSW is
loaded on an exception it will result in a specification exception and
not a special operation exception like on all other key related
actions.

The third patch adds a basic guest UV call API test. It has mostly
been used for firmware testing but I also think it's good to have a
building block like this for more PV tests.


GIT: https://github.com/frankjaa/kvm-unit-tests/tree/queue


Janosch Frank (3):
  s390x: Add custom pgm cleanup function
  s390x: skrf: Add exception new skey test and add test to unittests.cfg
  s390x: Ultavisor guest API test

 lib/s390x/asm/interrupt.h |   1 +
 lib/s390x/asm/uv.h        |  68 +++++++++++++++++
 lib/s390x/interrupt.c     |   9 +++
 s390x/Makefile            |   1 +
 s390x/skrf.c              |  81 ++++++++++++++++++++
 s390x/unittests.cfg       |   7 ++
 s390x/uv-guest.c          | 156 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 323 insertions(+)
 create mode 100644 lib/s390x/asm/uv.h
 create mode 100644 s390x/uv-guest.c

-- 
2.25.1

