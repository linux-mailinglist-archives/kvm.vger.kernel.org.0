Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809793EB195
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 09:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbhHMHiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 03:38:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19228 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230469AbhHMHiB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 03:38:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D7Xsvn032863;
        Fri, 13 Aug 2021 03:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=PCdSy6CZzbGdUlP6VF2k3S1KxfR9Tj1pK3QCJ6Rp5SE=;
 b=ZO7vc/CfF2DmTFEwdhW++jSFmFyBbRZyL4nWjAWYIgoZMGEDD2XWdt8gg2lZyl+dSHmw
 M/3HQlCah55hI0BG46LR6Vq4eRjv+VgLSpI+aLktMgSRjup7Un1NQVZIs3Q7yYhZe0/l
 PZVSccf50XMhK7YneK/NbdYvTwv+MlCChjBsmge+jAWLpobcNyjHqMLWoq07GiHGh+sz
 U91lyKXG2s6bbgbVY1FTz5PqNOA/Zha2SdUQsoq77nwuUSPQ/KEFa/n7ghCDxSWHXE0g
 jRhnPNuRvMZ/u5r7hwhoTnZ/P729CfJzzbWKzICOZID7vlzEW6IC1tZjVvhdB4X1oIUa 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad56qergj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:34 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D7Z2fU040387;
        Fri, 13 Aug 2021 03:37:34 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ad56qerg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 03:37:34 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D7NhHT007475;
        Fri, 13 Aug 2021 07:37:32 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3abujqvhav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 07:37:32 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D7bUqR53871100
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 07:37:30 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DF2242056;
        Fri, 13 Aug 2021 07:37:30 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBD754203F;
        Fri, 13 Aug 2021 07:37:29 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Aug 2021 07:37:29 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 0/8] s390x: Cleanup and maintenance
Date:   Fri, 13 Aug 2021 07:36:07 +0000
Message-Id: <20210813073615.32837-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Sqpf7S34F8TIDifewPpGwUf3E9yzfIP0
X-Proofpoint-GUID: cwFoHCU3SSAGkrdxfudbvX19Q7lEHjtS
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A bit more cleanup and some extensions before I start adding the PV
SIE support.

https://gitlab.com/frankja/kvm-unit-tests/-/tree/lib_clean_ext

Janosch Frank (8):
  s390x: lib: Extend bitops
  lib: s390x: Add 0x3d, 0x3e and 0x3f PGM constants
  lib: s390x: Print addressing related exception information
  lib: s390x: Start using bitops instead of magic constants
  s390x: uv-host: Explain why we set up the home space and remove the
    space change
  lib: s390x: Add PSW_MASK_64
  lib: s390x: Control register constant cleanup
  lib: s390x: uv: Add rc 0x100 query error handling

 lib/s390x/asm/arch_def.h |  39 +++++++++------
 lib/s390x/asm/bitops.h   | 102 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/interrupt.c    |  80 +++++++++++++++++++++++++++++-
 lib/s390x/smp.c          |   4 +-
 lib/s390x/uv.c           |   4 +-
 s390x/Makefile           |   1 +
 s390x/mvpg-sie.c         |   2 +-
 s390x/sie.c              |   2 +-
 s390x/skrf.c             |   8 +--
 s390x/uv-host.c          |  11 +++--
 10 files changed, 223 insertions(+), 30 deletions(-)

-- 
2.30.2

