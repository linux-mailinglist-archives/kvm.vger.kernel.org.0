Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5120E57CCE0
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiGUOH2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiGUOHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:07:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E5245062
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:07:17 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LDhnrN035379
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=c55FnX4rb9aoOG9awBHPEwfYlz55B5wzlNLvlD5oYos=;
 b=iyDcp/wwQSfPNRFf9uDyQ9sbaIIGQYUqAERge1dEV9c/PoBCXxbrrcAUjXMrTkdgOdsj
 1x3gZ07xmChZjkmN6RaSSUx1S92IscPnZqwpdRu+iLh3gb1BDyRyghu2ggKGov8FbJzf
 j+13uql9dHkrzhgCyqGo6TIV7/WaxYRHiye7yJutyArsKsqX3ORBgu3xiFDC7HHLUr+w
 Mjgw1GMaLqUkYg+61SceeDzcCE27hkxKAEhMWcICUjzk6OgDB/p0zfV3Hm7pvJlQVpia
 7XwhmrbrKlcaxky4up7jAZbTaywFVpIVQphecb3PMYz/BHZ2DNDKo2IXOi9IH2pqo8CW WQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7xe0vx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:16 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LDi1aN035836
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:07:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf7xe0vus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:07 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LE5UML022431;
        Thu, 21 Jul 2022 14:07:04 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3hbmy8nbvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 14:07:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LE71Nm17957322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 14:07:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9ED94C040;
        Thu, 21 Jul 2022 14:07:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A1584C052;
        Thu, 21 Jul 2022 14:07:01 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 14:07:01 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 00/12] s390x: improve error reporting, more storage key tests
Date:   Thu, 21 Jul 2022 16:06:49 +0200
Message-Id: <20220721140701.146135-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fZSjnviXvcKWG62WwTOs-gTlAUsGEBWb
X-Proofpoint-GUID: sn09L4iRGleBOgszLH8KD4akwP1uiyUr
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_18,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=792 phishscore=0 adultscore=0 spamscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207210057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

please merge the following changes:
* new testcases to test storage keys functionality
* improved parsing of interrupt parameters
* readability improvements
* CI fix to overcome a qemu bug exposed by the new tests
* better error reporting for SMP tests

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/34

PIPELINE:
https://gitlab.com/imbrenda/kvm-unit-tests/-/pipelines/593541216

PULL:
https://gitlab.com/imbrenda/kvm-unit-tests.git s390x-next-2022-07


Claudio Imbrenda (5):
  lib: s390x: add functions to set and clear PSW bits
  s390x: skey.c: rework the interrupt handler
  lib: s390x: better smp interrupt checks
  s390x: intercept: fence one test when using TCG
  s390x: intercept: make sure all output lines are unique

Janis Schoetterl-Glausch (7):
  s390x: Fix sclp facility bit numbers
  s390x: lib: SOP facility query function
  s390x: Rework TEID decoding and usage
  s390x: Test TEID values in storage key test
  s390x: Test effect of storage keys on some more instructions
  s390x: Test effect of storage keys on diag 308
  s390x/intercept: Test invalid prefix argument to SET PREFIX

 lib/s390x/asm/arch_def.h  |  75 ++++++-
 lib/s390x/asm/facility.h  |  21 ++
 lib/s390x/asm/interrupt.h |  65 ++++--
 lib/s390x/asm/pgtable.h   |   2 -
 lib/s390x/fault.h         |  30 +--
 lib/s390x/sclp.h          |  18 +-
 lib/s390x/smp.h           |   8 +-
 lib/s390x/fault.c         |  58 ++++--
 lib/s390x/interrupt.c     |  79 ++++++--
 lib/s390x/mmu.c           |  14 +-
 lib/s390x/sclp.c          |   9 +-
 lib/s390x/smp.c           |  11 +
 s390x/diag288.c           |   6 +-
 s390x/edat.c              |  25 ++-
 s390x/intercept.c         |  27 +++
 s390x/selftest.c          |   4 +-
 s390x/skey.c              | 408 ++++++++++++++++++++++++++++++++++++--
 s390x/skrf.c              |  14 +-
 s390x/smp.c               |  18 +-
 s390x/unittests.cfg       |   1 +
 20 files changed, 712 insertions(+), 181 deletions(-)

-- 
2.36.1

