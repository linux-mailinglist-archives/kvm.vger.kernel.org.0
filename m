Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BF131568B
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 20:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhBITKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 14:10:21 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233214AbhBIS73 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 13:59:29 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119IpMke018981
        for <kvm@vger.kernel.org>; Tue, 9 Feb 2021 13:52:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2UiLDqbQnsfFi1gvlqx443uD2xxSL5E8UhLTwo3pHO8=;
 b=CSWHSiaBoc07TKVD6x9LyfIBcK1rn+yv7vPSRILaZHIH1XScZAnswvCDiFG0x4AClHQG
 5CQPy3QgJTAHMvq6nJrJcj7M66mJBH84NtwL9aaOqkoUy4iyRWswUvQr9ENgp+vrn6Ip
 XTehzBDevLE2oEtgt5cf7gASe9iniQkYQvDFPRZdAHzP+myKucM53bEhPLuOOfU9zBhB
 51VYKcPAa+hm3yAjjuzu87MDncklB4zXNiDHJGj0FgD+/iA4RROc3NKbDxldpWT4Ogc2
 /ckmKcHeAb8DfWLV6p2cl/HmC2Pjfz6dlFL0tBKHwNppUq7CTnqOLELY69qk/UFpWDLQ eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kyhxgwnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 13:52:00 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119Ipx96025678
        for <kvm@vger.kernel.org>; Tue, 9 Feb 2021 13:51:59 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36kyhxgwn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:51:59 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119IknXL004313;
        Tue, 9 Feb 2021 18:51:58 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wjy9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 18:51:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119IpjW925755974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 18:51:45 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 188DFA4062;
        Tue,  9 Feb 2021 18:51:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A425EA405C;
        Tue,  9 Feb 2021 18:51:54 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.1.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 18:51:54 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: [kvm-unit-tests PATCH v1 0/3] s390x: mvpg test
Date:   Tue,  9 Feb 2021 19:51:51 +0100
Message-Id: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_05:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 mlxlogscore=708 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102090086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A simple unit test for the MVPG instruction.

The timeout is set to 10 seconds because the test should complete in a
fraction of a second even on busy machines. If the test is run in VSIE
and the host of the host is not handling MVPG properly, the test will
probably hang.

Testing MVPG behaviour in VSIE is the main motivation for this test.

Anything related to storage keys is not tested.

Claudio Imbrenda (3):
  s390x: introduce leave_pstate to leave userspace
  s390x: check for specific program interrupt
  s390x: mvpg: simple test

 s390x/Makefile            |   1 +
 lib/s390x/asm/arch_def.h  |   5 +
 lib/s390x/asm/interrupt.h |   1 +
 lib/s390x/interrupt.c     |  18 ++-
 s390x/mvpg.c              | 266 ++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg       |   4 +
 6 files changed, 293 insertions(+), 2 deletions(-)
 create mode 100644 s390x/mvpg.c

-- 
2.26.2

