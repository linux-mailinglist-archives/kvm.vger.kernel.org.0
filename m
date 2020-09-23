Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE73275911
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 15:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIWNsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 09:48:16 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726540AbgIWNsP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 09:48:15 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NDhlIm178093;
        Wed, 23 Sep 2020 09:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=f9xs6nbYQF9K0l6Z+qgw4wTquMcjdeTfunMdB8pUoLA=;
 b=VVIpT/ItrL/XtnfYEejWW7iLTtX8AlOn035ttPRF8a/jUBr1Gq1QxEq32m+oQSV0bOA5
 X5i/ALXBSHs5Dmuju0IlDv3EL2f5fxt9WQM23bfjPh4k2S56a1RYOFKevF4AckIVM+pt
 qhNiiME0Mf15AUVxA0O8/XrB6EM7qU3nUl1sDcpV7ATjPaTvXAsRR13gMMLIE/9Ml8R5
 GSV9bEB0v7qHPEtL1Sapun2DDY4SwuELbG2ZFcRbKkfQpucM89zjAgJ9IGVCjpNg6Ubs
 Pps9f5jXtjk7rvOkZeCf540U9b00GFV7bQjJ1IAeXhKj/X3GcaP6ncuJmimpyb/OQUws BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r7gg847p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08NDj8qg186490;
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33r7gg844r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 09:48:14 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08NDkeVZ025146;
        Wed, 23 Sep 2020 13:48:10 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 33n9m8c72y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Sep 2020 13:48:10 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08NDm8S116777546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 13:48:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E277E4C05E;
        Wed, 23 Sep 2020 13:48:07 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 852D84C046;
        Wed, 23 Sep 2020 13:48:07 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.64.218])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Sep 2020 13:48:07 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH kvm-unit-tests v2 0/4] s390x: Add Protected VM support
Date:   Wed, 23 Sep 2020 15:47:54 +0200
Message-Id: <20200923134758.19354-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_09:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=1 malwarescore=0 spamscore=0 clxscore=1015
 mlxscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Protected Virtual Machine (PVM) tests. For starting a
PVM guest we must be able to generate a PVM image by using the
`genprotimg` tool from the s390-tools collection. This requires the
ability to pass a machine-specific host-key document, so the option
`--host-key-document` is added to the configure script.

For everybody's convenience there is a branch:
https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/pv_v2

Changelog:
 v1 -> v2:
   + rebased
   + patches 1-3:
     - add r-b from Conny, Andrew, and David
   + patch 4:
     - add r-b from Janosch
     - renamed ${testname} to $testname (David)
     - fix `print_result` function calls and the arguments used
 RFC v2 -> v1:
  + Rebased
  + patch 1:
    - add r-b from Andrew
  + patch 2:
    - add explicit dependency on config.mak (Andrew)
    - add comment about the order of sourcing (Andrew)
  + patch 3:
    - drop dummy function (Andrew)
    - add arch_cmd hook function (Andrew)
  + patch 4:
    - rephrased the documentation of the configure option (Conny)
    - Skip test case if a PVM image wasn't built or the host-key document wasn't set (Conny)
    - Run PV tests by default
 RFC v1 -> RFC v2:
  + Remove `pv_support` option (Janosch, David)
  + Add some preliminary patches:
    - move "testname guard"
    - add support for architecture dependent functions
  + Add support for specifying a parmline file for the PV image
    generation. This is necessary for the `selftest` because the
    kernel cmdline set on the QEMU command line is ignored for PV
    guests

Marc Hartmayer (4):
  common.bash: run `cmd` only if a test case was found
  scripts: add support for architecture dependent functions
  run_tests/mkstandalone: add arch_cmd hook
  s390x: add Protected VM support

 README.md               |  3 ++-
 configure               |  9 +++++++++
 run_tests.sh            |  3 ---
 s390x/Makefile          | 17 +++++++++++++++--
 s390x/selftest.parmfile |  1 +
 s390x/unittests.cfg     |  1 +
 scripts/common.bash     | 21 +++++++++++++++++++--
 scripts/mkstandalone.sh |  4 ----
 scripts/s390x/func.bash | 36 ++++++++++++++++++++++++++++++++++++
 9 files changed, 83 insertions(+), 12 deletions(-)
 create mode 100644 s390x/selftest.parmfile
 create mode 100644 scripts/s390x/func.bash

-- 
2.25.4

