Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81C843B7312
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhF2NVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:21:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15196 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232487AbhF2NV3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:21:29 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TD2cbV041588;
        Tue, 29 Jun 2021 09:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=5mJyeoSgiCJBCuUvAXdNqxFN4rmBeAsNZ6heEGqm5cI=;
 b=AlYPaZbBbssWDHWiI3XGvJbCm8/DhfJXlb25tNqz4LZ7MKwxZ37Vs3uYDZPVMXhAmovA
 GhpSykKO+7H4oBC/GYjWKNIvIlZS8OX8n6IL9lMOLIE0ybsTFJGZ/rK+znZv4eN0+3SR
 XbMLIUtWk98mAyRm6YziBTqJG1okv166wXAVpdaFBGuGFwQSNNNy4fLLDXVvSlm3aQvm
 GE62i7LAVTDxlZLKIZ+5VHMrtCassUy8ElQf2FE2EeYE8epfuHEnvvL484Op0xZkf1p4
 WZZqhtVb37qrgA66CB1QYGdJPA/Ud3rUGsIr9dX+x2eSW1pcB6eh1Sd1k+OE6gS0JIgM gg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g3fq9k52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:19:02 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TD4WG9052335;
        Tue, 29 Jun 2021 09:19:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39g3fq9k4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:19:01 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDE5Sf018223;
        Tue, 29 Jun 2021 13:19:00 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 39dughhadn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:18:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDIviX34210114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:18:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7FC94C063;
        Tue, 29 Jun 2021 13:18:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 757794C058;
        Tue, 29 Jun 2021 13:18:57 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:18:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Add snippet support
Date:   Tue, 29 Jun 2021 13:18:38 +0000
Message-Id: <20210629131841.17319-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _Uc0CwCuvgFXMREvTbE6d-r0zwj8ChLB
X-Proofpoint-ORIG-GUID: al6rjPHZmE0Lv0SvjSxZxsLhmWDwRmV9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 adultscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106290088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SIE support allows us to run guests and test the hypervisor's
(V)SIE implementation. However it requires that the guest instructions
are binary which limits the complexity of the guest code.

The snippet support provides a way to write guest code as ASM or C and
simply memcpy it into guest memory. Some of the KVM-unit-test library
can be re-used which further speeds up guest code development.

The included mvpg-sie test helped us to deliver the KVM mvpg fixes
which Claudio posted a short while ago. In the future I'll post Secure
Execution snippet support patches which was my initial goal with this
series anyway.

v2:
    * Minor flat.lds fixes
    * mvpg-sie.c include cleanup
    * mvpg-sie.c added some comments
    * mvpg-sie.c replace pei report calculations with variables src/dst

RFC -> V1:
    * Replaced handle_validity() with assert()
    * Added clearing of registers before sigp in cstart.S
    * Added a nice way to compile the snippets

Janosch Frank (2):
  s390x: snippets: Add gitignore as well as linker script and start
    assembly
  s390x: mvpg: Add SIE mvpg test

Steffen Eiden (1):
  s390x: snippets: Add snippet compilation

 .gitignore                      |   1 +
 s390x/Makefile                  |  29 ++++--
 s390x/mvpg-sie.c                | 151 ++++++++++++++++++++++++++++++++
 s390x/snippets/c/cstart.S       |  16 ++++
 s390x/snippets/c/flat.lds       |  51 +++++++++++
 s390x/snippets/c/mvpg-snippet.c |  33 +++++++
 s390x/unittests.cfg             |   3 +
 7 files changed, 278 insertions(+), 6 deletions(-)
 create mode 100644 s390x/mvpg-sie.c
 create mode 100644 s390x/snippets/c/cstart.S
 create mode 100644 s390x/snippets/c/flat.lds
 create mode 100644 s390x/snippets/c/mvpg-snippet.c

-- 
2.30.2

