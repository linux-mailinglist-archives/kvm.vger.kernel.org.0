Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63D6248596
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 15:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHRNFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 09:05:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726145AbgHRNEz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Aug 2020 09:04:55 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ID3CeN015352;
        Tue, 18 Aug 2020 09:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HMiQAFf5HGojfQGl+89e7ASM4BszeeXwNiXrohrM/C8=;
 b=Tmxyrv99CmW12Tst7WM66DVMt87AePuTTcjpRjoVEZK+qA3EVUMmKqzvZ4MbCZaGIRvz
 GVOYdfS02mjoBP9odGKynmnMx1/9Wh9ElaB7nRD7dABK0IlMjTHD63Ab7vMibaYVLxyO
 GCRtXUaqchjS1ofDkD7QjUwUCwQqCL642l+lDHMGizUiO0SRCfcdA4QSPuY1R85vawHC
 Xh0x3F2J/fiKshxlzd39WXKHu14XsBfoE59XUJ+TfpGunItgXl3KMGRf9VVcAV3SMtFv
 /oMiiguLsqux1P4yveI5VVkLXJ9UEpK4BnrS49Grz38R0jsrDS55zUS3eewEITT9opcz 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304u7167p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:54 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07ID3Jav016015;
        Tue, 18 Aug 2020 09:04:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3304u7166n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 09:04:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07ID0jYN022901;
        Tue, 18 Aug 2020 13:04:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3304cc0p81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Aug 2020 13:04:50 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07ID4muF29622644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 13:04:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37DA14C040;
        Tue, 18 Aug 2020 13:04:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC6D14C046;
        Tue, 18 Aug 2020 13:04:47 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.52.109])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Aug 2020 13:04:47 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/4] s390x: Add Protected VM support
Date:   Tue, 18 Aug 2020 15:04:20 +0200
Message-Id: <20200818130424.20522-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_09:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 spamscore=0
 suspectscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for Protected Virtual Machine (PVM) tests. For starting a
PVM guest we must be able to generate a PVM image by using the
`genprotimg` tool from the s390-tools collection. This requires the
ability to pass a machine-specific host-key document, so the option
`--host-key-document` is added to the configure script.

For everybody's convenience there is a branch:
https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/pv_v1

Changelog:
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
 scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
 9 files changed, 82 insertions(+), 12 deletions(-)
 create mode 100644 s390x/selftest.parmfile
 create mode 100644 scripts/s390x/func.bash

-- 
2.25.4

