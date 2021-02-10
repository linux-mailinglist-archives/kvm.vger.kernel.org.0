Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AB63167DE
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 14:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhBJNVm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 08:21:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19696 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231569AbhBJNVN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 08:21:13 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11AD3mbY036043;
        Wed, 10 Feb 2021 08:20:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=mYikVEhh903OGim8+L+O1oJur66x4sXVBL9fgpSjVyE=;
 b=j9WB20GbqQ48KOzLeRD0SRf7F4HlgQCWFqESCh95hzc7QkgPn2Uwb/hI/mjFpwBIRbi9
 8dXIhYdcAfdHmQWaQg2veLXFv1Za/6nf+soXfEHBcWmw1aTE5w8E6Tj8dwSpQPkYzbGN
 GMpIWOPGvg4wRz20zVP3GtfEiMTnEr0xkUzTB4bc9AZAZUfx0+oRsgHfAcZh+6oOVwa3
 hGkcAHnE/98+o6mLQsVsH/WCPswKf8U2tbitNvo972yRHZPAOCqsV0Kubyy7cIcL91I0
 TcdH47xnEofEPPr5sd1mEaG3poNFUP5mjKeHFmXzYr4330jIBfVSAGKQDbA4y36n4jul 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfejsqm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:21 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11AD46LM037712;
        Wed, 10 Feb 2021 08:20:20 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mfejsqk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:20:20 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ADH7MU012089;
        Wed, 10 Feb 2021 13:20:18 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wm1uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 13:20:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ADKF5n52560354
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 13:20:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90E054C04E;
        Wed, 10 Feb 2021 13:20:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33B694C044;
        Wed, 10 Feb 2021 13:20:15 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.174.85])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Feb 2021 13:20:15 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/5] CSS Mesurement Block
Date:   Wed, 10 Feb 2021 14:20:09 +0100
Message-Id: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102100126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We tests the update of the Mesurement Block (MB) format 0
and format 1 using a serie of senseid requests.

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

Regards,
Pierre

Pierre Morel (5):
  s390x: css: Store CSS Characteristics
  s390x: css: simplifications of the tests
  s390x: css: implementing Set CHannel Monitor
  s390x: css: testing measurement block format 0
  s390x: css: testing measurement block format 1

 lib/s390x/css.h     | 117 ++++++++++++++++++++++-
 lib/s390x/css_lib.c | 223 +++++++++++++++++++++++++++++++++++++++++---
 s390x/css.c         | 186 ++++++++++++++++++++++++++++++++----
 3 files changed, 493 insertions(+), 33 deletions(-)

-- 
2.17.1

changelog:

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
