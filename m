Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C6F42D982
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhJNMx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:53:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14592 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229637AbhJNMx1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Oct 2021 08:53:27 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19EB2eV5030641;
        Thu, 14 Oct 2021 08:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=249FJjNc/JSAUYwPL6ayvTaSomzMHAMDlYFbc9Ul9h0=;
 b=OWc2DFsg6GQWNqUGUP6BGLqNxpj999/rzpUdHKzbdMLuzhRAgnvAfzSczZ6Mv59KnpbG
 EfrjFX2Id+Gkq9OSG8hM0rjKIt15xJNE0EQkr0fjs0qB1yO1tS0pQn97almTXK+MvOAX
 AThlcdaUwST13fijbJ8EQAmYUVys2mis2VPV1oCj1yl6e0o6lksCr6UholVbDweWgUoL
 YkypijgnfXYrNRJEvXry8f8LziUbUF7rePWtApVYmM0s+3GbqOs8/aE5kdGJ5iViDRsa
 QT1naB3Uf3AnMFbrahXY+DahrNqoEeYrS0my7Z5pr3KCDbWxO5989w7/XJ/Xyts8dTRn pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bpgv4e15k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 08:51:22 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19ECBlo8006987;
        Thu, 14 Oct 2021 08:51:21 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bpgv4e14r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 08:51:21 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19EClX7H009100;
        Thu, 14 Oct 2021 12:51:20 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3bk2qa5986-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Oct 2021 12:51:19 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19ECpG7550856324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Oct 2021 12:51:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F874A4055;
        Thu, 14 Oct 2021 12:51:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C25DA405F;
        Thu, 14 Oct 2021 12:51:15 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Oct 2021 12:51:15 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Cleanup and maintenance 3
Date:   Thu, 14 Oct 2021 12:51:04 +0000
Message-Id: <20211014125107.2877-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nT4JV5b2XqBeUih110JMwR4vY7-p36ZS
X-Proofpoint-ORIG-GUID: M_Q3SxQtTRVKurtVF4qskP58WyHMB6Rq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-14_07,2021-10-14_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=771 impostorscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110140080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Three small cleanup patches mostly improving snippet usage and small
fixes.

v2:
	* Simplified the snippet patch by always using 0x4000 as the start address
	* Removed a few commas in weird places with new patch

Janosch Frank (3):
  lib: s390x: Fix PSW constant
  lib: s390x: snippet.h: Add a few constants that will make our life
    easier
  lib: s390x: Fix copyright message

 lib/s390x/asm/arch_def.h |  2 +-
 lib/s390x/css.h          |  2 +-
 lib/s390x/sclp.h         |  2 +-
 lib/s390x/snippet.h      | 34 ++++++++++++++++++++++++++++++++++
 s390x/mvpg-sie.c         | 13 ++++++-------
 5 files changed, 43 insertions(+), 10 deletions(-)
 create mode 100644 lib/s390x/snippet.h

-- 
2.30.2

