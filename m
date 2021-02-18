Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22C631EE4E
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhBRSaG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:30:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36822 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232578AbhBRR1o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:27:44 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11IHLk3r091642
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=w+dV+TFFLs0rNFFqR7W1VBHLOA/FfMn9YTisvNm65Os=;
 b=qwVeKl5Fgfv49+xQN2TR8RzJwqC50eS/rM+7FJLtM7W3+ZhUdE/3mu0actIkX32dx1ob
 P3/pDmm1Zzsm+9ojrhGefdwzBuRB4TaujVKENCeMxlbKidChGJ1G4qVkPJkdxMRr4c4G
 0o/C7cQC+uXA3yM6xqaCo0G2WagRaJ3aTNVQtl/zJaOvb06fqxi9UxvDSyd+nfg/3mbo
 bFVc7jLaUYgx2yYjfatBZ3IPDbz0imM67Y6kraFJL6fECX2W7iD2IepQoNnhFPfjvPZe
 uKjJjy8hYeRipm9qtaB0xp3RISrmRZz+pKoY5JeAONXpJYfnJ8YykZwxjFBNIbtf6VU2 cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36suuc9gdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:51 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11IHMQHs093200
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 12:26:50 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36suuc9gd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 12:26:50 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11IHNmoN011291;
        Thu, 18 Feb 2021 17:26:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36p6d8cvkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 17:26:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11IHQk2s44433822
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Feb 2021 17:26:46 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10758A4051;
        Thu, 18 Feb 2021 17:26:46 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6241A404D;
        Thu, 18 Feb 2021 17:26:45 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.94.58])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Feb 2021 17:26:45 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3 0/5] CSS Mesurement Block
Date:   Thu, 18 Feb 2021 18:26:39 +0100
Message-Id: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_08:2021-02-18,2021-02-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102180144
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

 lib/s390x/css.h     | 117 ++++++++++++++++++-
 lib/s390x/css_lib.c | 270 ++++++++++++++++++++++++++++++++++++++++++--
 s390x/css.c         | 214 +++++++++++++++++++++++++++++++----
 3 files changed, 568 insertions(+), 33 deletions(-)

-- 
2.25.1

changelog:

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
