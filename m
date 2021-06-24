Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6813B2E77
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhFXMEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:04:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31550 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229948AbhFXME2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 08:04:28 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15OBX2fv136326;
        Thu, 24 Jun 2021 08:02:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=oGTLzecMcrPee+aQZhur6G5UjI8AHMexsJJpdtM0O3g=;
 b=V3mshNibL44Nmh4a4I9v6AAchlUI0g6XWarB0MGRBgowCBOJjX8RAAKqlaIEjP0IjQlu
 VBnzv3eZ6eMoo5HvzedLSErsIJrkZdIc/9u7GU+3buDdgjtWTjoUal3UU4WuS0hxklg/
 ohIOS4mjZ8CUKwmvDlVa61vNcmHKBHM2ifONv+sd6SaPVJvsJQbiiG1iCBCi//B/RIL2
 5Im1XNyuyO1bPAP8xKFdjCr6iuzkiKyrHn9qRZhhAfzsf9qUSM9A24Fl8BGtpnMm7tkm
 ixgWiVCR5/6QiJeJyaHtPh5eQjAQ7sDapei1py6/5DQAnftGojPNuUqtN/33wqDgT9EC hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cp57qpps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:08 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15OBX2YN136248;
        Thu, 24 Jun 2021 08:02:08 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39cp57qpnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 08:02:08 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15OBvmbV011526;
        Thu, 24 Jun 2021 12:02:06 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 399878ahfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Jun 2021 12:02:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15OC23Vc25166286
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Jun 2021 12:02:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65CACAE051;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F8D6AE055;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Jun 2021 12:02:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        seiden@linux.ibm.com
Subject: [PATCH 0/3] s390x: Add snippet support
Date:   Thu, 24 Jun 2021 12:01:49 +0000
Message-Id: <20210624120152.344009-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mIvIfzTGTkLEha0UdIH_IBIIFQuXPUId
X-Proofpoint-GUID: cd03Egn7wxs_0XdONM5MgTWJEPjPa43t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-24_11:2021-06-24,2021-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106240062
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
 s390x/mvpg-sie.c                | 150 ++++++++++++++++++++++++++++++++
 s390x/snippets/c/cstart.S       |  15 ++++
 s390x/snippets/c/flat.lds       |  51 +++++++++++
 s390x/snippets/c/mvpg-snippet.c |  33 +++++++
 s390x/unittests.cfg             |   3 +
 7 files changed, 276 insertions(+), 6 deletions(-)
 create mode 100644 s390x/mvpg-sie.c
 create mode 100644 s390x/snippets/c/cstart.S
 create mode 100644 s390x/snippets/c/flat.lds
 create mode 100644 s390x/snippets/c/mvpg-snippet.c

-- 
2.27.0

