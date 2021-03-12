Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE021338A69
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 11:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhCLKmR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 05:42:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232834AbhCLKmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 05:42:01 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CAXqXZ026375
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=W9YfApTZEIevFkpbGRU4KI4Um4jKSbrDeVz6GrgLw9A=;
 b=sZK+V53Xz6UeCKLwFnMcIG3AJAw6f9N5AHrR9Ud7ThWeziqkiefTuwTUBFET1F94nyJW
 qE07VQ36fzqKWPolmmZhye5U/MIlQb1omzd2yKpo/zVaSoN2ThWRsCazZu3/Ca8JndA2
 5jXoIzfJWp+jfWp3fUwQ8q+wOerWn0yR+gQ1p77p16EQVkFBkjjm9b2FFU/NKBxXftp9
 BSGWtumo7PAOZZWrg49CXFMNhUKfIQ0ru0nsqKP3FFUPt/Tvi/V1r8pVf2CHCZod8v0v
 wx5y5CwoOJxK/6QvCLFYBIRg2+XS3B/DhsgkaVh5rQzuR0DeykAQHbTz3KaMpBy6RTLB 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774kyx442-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:01 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12CAYsDM030355
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 05:42:00 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3774kyx433-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 05:42:00 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12CAfq6Q009032;
        Fri, 12 Mar 2021 10:41:58 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3768t4jruu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 10:41:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12CAft2j56099136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Mar 2021 10:41:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 949F3AE05A;
        Fri, 12 Mar 2021 10:41:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D24DAE051;
        Fri, 12 Mar 2021 10:41:55 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.32.251])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Mar 2021 10:41:55 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v6 0/6] CSS Mesurement Block
Date:   Fri, 12 Mar 2021 11:41:48 +0100
Message-Id: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_03:2021-03-10,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103120072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We tests the update of the Mesurement Block (MB) format 0
and format 1 using a serie of senseid requests.

*Warning*: One of the tests for format-1 will unexpectedly fail for QEMU elf
unless the QEMU patch "css: SCHIB measurement block origin must be aligned"
is applied.
This patch has recently hit QEMU master ...
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
 3 files changed, 539 insertions(+), 28 deletions(-)

-- 
2.17.1

changelog:

from v5:

- moved the renaming of css_xxx_feature to patch 1 were it is introduced
  (Connie)

- moved some refactoring introduced in patch 5 test_fmt0 to refactoring patch
  (Connie)

- move ccw and senseid allocation outside the test loop
  (Connie)
- and put ccw pointer global.
  (Pierre)

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
