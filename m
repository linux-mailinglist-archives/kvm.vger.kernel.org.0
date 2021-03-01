Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15746327D83
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 12:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbhCALsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 06:48:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28036 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234206AbhCALr5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 06:47:57 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 121BblMx032412
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=FMygeHcg7EQMrlWf+owqbybxpRxFeDKvqbBpl0XLMfY=;
 b=ZY6OloeoY017ULFazCT1mkV/sP530cYXITUde3MT2AWgB00DuYbpnLc+Ct9sUFHHYBoD
 58cC57eaOe2h1UNNoDxjeNzteR3gvktrazvXjMypkb9d0955Wjw4jznqSNBFnsW3dMzm
 eEKghtUx0xa4ZBgnfAz8Vrdoz/mPPTTUWoMElbg6THSrPF+iWsQDhKohbhTDWOEGg8mL
 29UBHy4ocQ9ZzvJINC1z0PbardVEtT1A1FSKc2W5Vgqe9k7WyQvbk3ktDSwXmpcBHbWC
 4s9HSPdyltFb2/3w8TgzJHqqwcqYC+7/zE5sWzIyAaldC+XTHHMOjcLnjQn7zONiv72a Cg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370ve8euv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 06:47:14 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 121Bbu6I033221
        for <kvm@vger.kernel.org>; Mon, 1 Mar 2021 06:47:12 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 370ve8euua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 06:47:12 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 121Bhr0x024762;
        Mon, 1 Mar 2021 11:47:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 36ydq88xg7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Mar 2021 11:47:09 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 121Bl6D257606560
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Mar 2021 11:47:07 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE65BAE053;
        Mon,  1 Mar 2021 11:47:06 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8293FAE051;
        Mon,  1 Mar 2021 11:47:06 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.52.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Mar 2021 11:47:06 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 0/6] CSS Mesurement Block
Date:   Mon,  1 Mar 2021 12:46:59 +0100
Message-Id: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-01_06:2021-02-26,2021-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010098
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
- we add a css_enabled() function to test if a subchannel is enabled.

@Connie, I restructured the patches but I did not modify the
functionalities, so I kept your R-B, I hope you are OK with this.

Regards,
Pierre

Pierre Morel (6):
  s390x: css: Store CSS Characteristics
  s390x: css: simplifications of the tests
  s390x: css: extending the subchannel modifying functions
  s390x: css: implementing Set CHannel Monitor
  s390x: css: testing measurement block format 0
  s390x: css: testing measurement block format 1

 lib/s390x/css.h     | 116 +++++++++++++++++++++-
 lib/s390x/css_lib.c | 232 +++++++++++++++++++++++++++++++++++++++++---
 s390x/css.c         | 228 +++++++++++++++++++++++++++++++++++++++----
 3 files changed, 542 insertions(+), 34 deletions(-)

-- 
2.17.1

changelog:

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
