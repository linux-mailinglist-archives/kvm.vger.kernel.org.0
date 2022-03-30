Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC114EC6EE
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347131AbiC3OqK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 10:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347173AbiC3Opv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 10:45:51 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97B48908D;
        Wed, 30 Mar 2022 07:43:58 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UDfBuF011029;
        Wed, 30 Mar 2022 14:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LTMljJOOPp378oux6hBciPV/9YXm+DR31cW8efnxgyc=;
 b=bVvo72jle6jUqwYhHzKbCmNZJFtqaoXbaezrMqq6EudvH1+BwSVUOcXPnMQIfFE+hcse
 iDxA74yDm7BgrW+ujy4Tnhe8kALJhGERKZz9oe2RN3J7FOIQ8JyhGbUOyfzSX4Ekha4C
 t+q4myfESsgFrOujiLdTRXgmucEi56Xhl6nX9ODjBB1kO1Br9nAZ259xra5l49u8ET1S
 eFwfWCezADLO2Uhvzl00LMkdLMm3MdNBYXYCEjxSVoH4d6/KFB5xy06gddxHefgqFlvH
 oYNUJglSTH8TGopf8/MXLXliUSkBDf8Tu0kJDeJ4lrRvdcFV7sEACOYNlQtOoF0rVsW8 Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3ydcsmxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:57 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UEDn7R027794;
        Wed, 30 Mar 2022 14:43:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f3ydcsmvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UEcmbD015456;
        Wed, 30 Mar 2022 14:43:51 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8qgc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 14:43:51 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UEhmE143385316
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 14:43:48 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 131F94C044;
        Wed, 30 Mar 2022 14:43:48 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8962B4C040;
        Wed, 30 Mar 2022 14:43:47 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 14:43:47 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        scgl@linux.ibm.com, borntraeger@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, nrb@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v1 0/4] lib: s390x: Refactor and rename vm.[ch]
Date:   Wed, 30 Mar 2022 16:43:35 +0200
Message-Id: <20220330144339.261419-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZAfxmmFdDQnVLexoG3uXbFEhelTubXbb
X-Proofpoint-GUID: xC2soxHcQh25nhUhly4Rwq_akm_GZ2Os
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 mlxlogscore=641 suspectscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203300071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor and rename vm.[ch] to hardware.[ch]

* Remove some uneeded #includes for vm.h
* Rename vm.[ch] to hardware.[ch]
* Move host_is_zvm6 to the library (was in a testcase)
* Consolidate all detection functions into detect_host, which returns
  what host system the test is running on
* Rename vm_is_* functions to host_is_*, which are then just wrappers
  around detect_host
* Move machine type macros from arch_def.h to hardware.h, add machine
  types for all known machines
* Add machine_is_* functions
* Refactor and rename get_machine_id to be a simple wrapper for stidp
* Add back get_machine_id using the stidp wrapper

Claudio Imbrenda (4):
  s390x: remove spurious includes
  lib: s390: rename and refactor vm.[ch]
  lib: s390x: functions for machine models
  lib: s390x: stidp wrapper and move get_machine_id

 s390x/Makefile           |   2 +-
 lib/s390x/asm/arch_def.h |   7 +-
 lib/s390x/hardware.h     | 134 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/vm.h           |  15 -----
 lib/s390x/hardware.c     |  86 +++++++++++++++++++++++++
 lib/s390x/vm.c           |  92 ---------------------------
 s390x/cpumodel.c         |   4 +-
 s390x/mvpg-sie.c         |   1 -
 s390x/mvpg.c             |   4 +-
 s390x/pv-diags.c         |   1 -
 s390x/skey.c             |  28 +-------
 s390x/spec_ex-sie.c      |   1 -
 s390x/uv-host.c          |   4 +-
 13 files changed, 230 insertions(+), 149 deletions(-)
 create mode 100644 lib/s390x/hardware.h
 delete mode 100644 lib/s390x/vm.h
 create mode 100644 lib/s390x/hardware.c
 delete mode 100644 lib/s390x/vm.c

-- 
2.34.1

