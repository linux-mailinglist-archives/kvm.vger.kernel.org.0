Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975FA373673
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 10:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhEEIob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 04:44:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15444 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231430AbhEEIoa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 04:44:30 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1458XTBs015630;
        Wed, 5 May 2021 04:43:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=v6CsMcHduA5axeK0MLOuGHcm5Oh6nbRO8VXofHRQz7w=;
 b=HsyKMew3MZvNh7mZW2enOhOTFkETyRUm/y9quIiMVOfk+7KjET9jOnVjsLrBh2jXD3T0
 9Yvwm00Cro15ys/v6kER/RwnBZH9gSwEySD589njpV6aQxw+LUPSZhdtSD7ZZgWvxJMM
 QVeWEbiHfOJbhYrjfjyWSXZ5PJoOPWeCiREYqIGv86e6XUp2Bi3a5HJqumKyWPEot0oG
 1HF9qjC9OR6VJxvZBfFaAgdYnKMqf9qIu9uuogQTu6WQ+sl3C7n/Uamjeydw7etldVxY
 iNqYSIj88hoiTCeOmJg0aCpjc0scohep7FEnUcPVj6xI1lIhNMyWGDjOv4fxIu6kuYOG AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bnfsc2ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:33 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1458YvCv022817;
        Wed, 5 May 2021 04:43:33 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38bnfsc2dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 04:43:32 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1458h3G3022508;
        Wed, 5 May 2021 08:43:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 38beeeg6d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 May 2021 08:43:30 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1458hRv630278008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 May 2021 08:43:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 704CAA4054;
        Wed,  5 May 2021 08:43:27 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7601A405C;
        Wed,  5 May 2021 08:43:26 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.65.32])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 May 2021 08:43:26 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests GIT PULL 0/9] s390x update 2021-05-05
Date:   Wed,  5 May 2021 10:42:52 +0200
Message-Id: <20210505084301.17395-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5qfF_SE0RZDVNfYMuO_zlOFVeSGBHvT4
X-Proofpoint-ORIG-GUID: 7FqTWzjVT3m2NjaZceQrQLNe9fQrkJZL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-05_02:2021-05-05,2021-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105050063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Paolo,

please merge or pull the following changes:
* IO extensions (Pierre)
* New reviewer (Claudio)
* Minor changes

MERGE:
https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/merge_requests/7

PIPELINE:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/297509337

PULL:
The following changes since commit abe823807d13e451ca5c37f1b5ada5847e08084f:

  nSVM: Test addresses of MSR and IO permissions maps (2021-04-22 11:59:25 -0400)

are available in the Git repository at:

  https://gitlab.com/frankja/kvm-unit-tests.git s390x-pull-2021-05-05

for you to fetch changes up to 7231778d3773f70582e705cf910976c79138d0c9:

  s390x: Fix vector stfle checks (2021-05-05 08:01:45 +0000)


Claudio Imbrenda (2):
  s390x: mvpg: add checks for op_acc_id
  MAINTAINERS: s390x: add myself as reviewer

Janosch Frank (1):
  s390x: Fix vector stfle checks

Pierre Morel (6):
  s390x: css: Store CSS Characteristics
  s390x: css: simplifications of the tests
  s390x: css: extending the subchannel modifying functions
  s390x: css: implementing Set CHannel Monitor
  s390x: css: testing measurement block format 0
  s390x: css: testing measurement block format 1

 MAINTAINERS         |   1 +
 lib/s390x/css.h     | 115 ++++++++++++++++++++-
 lib/s390x/css_lib.c | 236 ++++++++++++++++++++++++++++++++++++++++----
 s390x/css.c         | 216 ++++++++++++++++++++++++++++++++++++++--
 s390x/mvpg.c        |  28 +++++-
 s390x/vector.c      |   4 +-
 6 files changed, 568 insertions(+), 32 deletions(-)

-- 
2.30.2

