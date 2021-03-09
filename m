Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A023325CC
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 13:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhCIMvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 07:51:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231264AbhCIMvY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 07:51:24 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 129CXcBV031526
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=hWzhu368mYkRmLRSSxtlvSUwq74LObVkUqkHJlmUkFg=;
 b=RBiMeUpDPgkt1coEx7uGJ4+dwdna2YlO9A/uLDbNX8wpwLovmXLw2LYJSrmCoMFr85j8
 FXiYkmxLxWCe692Ex9iwirsU06IML2iEuy/P2uWAi1xVAMExsuqpyts5ATGRzqjwrnDj
 DKkJIGUa0+f4KWNbhnJqO/wEsTsdLWgjmkOIo73MfoHYSK/kV8qANzp7+Aa8ro+NzIE0
 2G+s4jW88aaRMMVJvnKminLNTZ9SrkC41HkX2r+zNGOxwXVm9v9ehqr1ADLdLG17sgHG
 fFzH1asR2JQi59wMB5CalNndJi/dTB0+yJ1+V0h5CmFtS+rmsP6PmDjR9C3Pc8S8z22o PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375whhgsw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 07:51:24 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 129CYNRP034449
        for <kvm@vger.kernel.org>; Tue, 9 Mar 2021 07:51:23 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375whhgsun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 07:51:23 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 129CTZAI008604;
        Tue, 9 Mar 2021 12:51:21 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3768urr0ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Mar 2021 12:51:21 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 129CpIpE42926346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Mar 2021 12:51:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D25EE52050;
        Tue,  9 Mar 2021 12:51:18 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.156.215])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8DABE52054;
        Tue,  9 Mar 2021 12:51:18 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 0/6] CSS Mesurement Block
Date:   Tue,  9 Mar 2021 13:51:11 +0100
Message-Id: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-09_11:2021-03-08,2021-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103090062
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We tests the update of the Mesurement Block (MB) format 0
and format 1 using a serie of senseid requests.

*Warning*: One of the tests for format-1 will unexpectedly fail for QEMU elf
unless the QEMU patch "css: SCHIB measurement block origin must be aligned"
is applied.
With Protected Virtualization, the PGM is correctly recognized.

The MB format 1 is only provided if the Extended mesurement Block
feature is available.

This feature is exposed by the CSS characteristics general features
stored by the Store Channel Subsystem Characteristics CHSC command,
consequently, we implement the CHSC instruction call and the SCSC CHSC
command.

In order to ease the writing of new tests using:
- interrupt
- enablement of a subchannel
- multiple I/O on a subchannel

We do the following simplifications:
- we create a CSS initialization routine
- we register the I/O interrupt handler on CSS initialization
- we do not enable or disable a subchannel in the senseid test,
  assuming this test is done after the enable test, this allows
  to create traffic using the SSCH used by senseid.
- failures not part of the feature under test will stop the tests.
- we add a css_enabled() function to test if a subchannel is enabled.

*note*:
    I rearranged the use of the senseid for the tests, by not modifying
    the existing test and having a dedicated senseid() function for
    the purpose of the tests.
    I think that it is in the rigght way so I kept the RB and ACK on
    the simplification, there are less changes, if it is wrong from me
    I suppose I will see this in the comments.
    Since the changed are moved inside the fmt0 test which is not approved
    for now I hope it is OK.

Regards,
Pierre

Pierre Morel (6):
  s390x: css: Store CSS Characteristics
  s390x: css: simplifications of the tests
  s390x: css: extending the subchannel modifying functions
  s390x: css: implementing Set CHannel Monitor
  s390x: css: testing measurement block format 0
  s390x: css: testing measurement block format 1

 lib/s390x/css.h     | 115 ++++++++++++++++++++-
 lib/s390x/css_lib.c | 236 ++++++++++++++++++++++++++++++++++++++++----
 s390x/css.c         | 216 ++++++++++++++++++++++++++++++++++++++--
 3 files changed, 540 insertions(+), 27 deletions(-)

-- 
2.17.1

changelog:

from v4:

- no modification of test_senseid() in the simplification patch,
  replaced by a new function in the fmt0 patch
  (Pierre)

- suppress report_info() in the interrupt routine.
  (Pierre)

- in chsc_scsc, rationalise the reserved area name.
  (Janosch)

- use assert for errors that should never happen
  like register_io_int_func()
  (Janosch)

- Changed css_general_feature to css_test_general_feature
  same for css_test_chsc_feature
  (Janosch)

- use report_abort() for hard failures in tests
  (Janosch, Connie)


from v3:

- stay coherent and use uintX_t types in css.h
  (Janosch)

- reworking test versus library to leave the reports
  mostly inside the tests
  (Janosh)

- Restructured some tests to use booleans instead of int
  this simplifies testing.
  (inspired by comments from Janosch)

- rewordings and orthograph (Measurement !!!)
  (Connie)

- stop measurement at the channel too before freeing the
  MB memory.
  (Connie)

- split out the subchannel-modifying functions into a
  separate patch
  (Connie)

- move msch_with_wrong_fmt1_mbo() from the library
  into the tests
  (Janosch)

- Suppress redundancy in the prefixes of format0/1 tests
  (Janosch)

from v2:

- stop measurement before freeing memory
  (Connie)

- added a css_disable_mb()
  (Connie)

- several rewriting of comments and commits
  (Connie)

- modified eroneous test for MB index for fmt0
  (Pierre)

- modified eroneous test for unaligned MBO for fmt1
  (Pierre)

- several small coding style issues corrected
  (Pierre)

from v1:

- check the return code of CHSC
  (Connie)

- reporting in css_init
  (Connie)

- added braces when a loop contains several statement
  (Thomas)

- changed retval to success in boolean function
  (Thomas)

- suppress goto retries
  (thomas)

- rewording and use correct return types in css_enabled
  (Janosch)
