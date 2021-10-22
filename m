Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7FA437654
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhJVMEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 08:04:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhJVME1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 08:04:27 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19MB0gbf009312
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 08:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UkvepZMIHJbhajMT/2CtC25dRRNNft+Ms5mu6eQvO8M=;
 b=j6vaczF7DDEb8f+xvQs0FhAH6Ahl1zZM4oRVpj1gp88QuoOUtWqWO7UxXmxQ8B6vD1dG
 ykuHDn9lJao8EbEyE3ntNFv3gGBdYr14uTnI5wL0M2Nk6cRtPZ+n2jg0YStpyaYB0i+R
 NkMz1TYWN222o9QcaSftAmLj/Gntchm1lMYn5csuNO7vq0tchcSjtWkLnnXCS3oBWAzb
 Dg9oFtfZm4SMRDw1L+ktcGsKTz5wG6BQzeq/ooWRrN4HCMfYAW761U006eUA+k6r9LPC
 mc3UVhGjcBh0uXWSq9/36ziO/va/xgCpfLiRmJx+WysXaYZmiP0SXaCRbus0U03YmypJ LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3busa14p1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 08:02:10 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19MBolIb030647
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 08:02:09 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3busa14p0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 08:02:09 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19MBwZxQ028808;
        Fri, 22 Oct 2021 12:02:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3bqp0kvk6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 12:02:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19MBu4fK53870892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 11:56:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECDBB52075;
        Fri, 22 Oct 2021 12:01:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C0CB552063;
        Fri, 22 Oct 2021 12:01:59 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 0/2] Add specification exception tests
Date:   Fri, 22 Oct 2021 14:01:54 +0200
Message-Id: <20211022120156.281567-1-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f4L0a6rNXu_fEakta2qEwgw0gGygt5OI
X-Proofpoint-ORIG-GUID: ei-oVzEvvX3kJbugzu89P_XwfvTJHf9D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110220068
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test that specification exceptions cause the correct interruption code
during both normal and transactional execution.

v2 -> v3
	remove non-ascii symbol
	clean up load_psw
	fix nits

v1 -> v2
	Add license and test description
	Split test patch into normal test and transactional execution test
	Add comments to
		invalid PSW fixup function
		with_transaction
	Rename some variables/functions
	Pass mask as single parameter to asm
	Get rid of report_info_if macro
	Introduce report_pass/fail and use them
Janis Schoetterl-Glausch (2):
  s390x: Add specification exception test
  s390x: Test specification exceptions during transaction

 s390x/Makefile           |   1 +
 lib/s390x/asm/arch_def.h |   1 +
 s390x/spec_ex.c          | 343 +++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 4 files changed, 348 insertions(+)
 create mode 100644 s390x/spec_ex.c


base-commit: 3ac97f8fc847d05d0a5555aefd34e2cac26fdc0c
-- 
2.31.1

