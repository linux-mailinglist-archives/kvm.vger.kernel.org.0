Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC4258B47
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 11:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgIAJSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 05:18:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgIAJSo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Sep 2020 05:18:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08192BNA072232;
        Tue, 1 Sep 2020 05:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YPtWkQi0eSQq6qd/NvhgsXggL4arpiXRt718grYJzIk=;
 b=sDtQLGkwgeaoTn8wTe9ZLOkPIvQBVuPyYppM0bBY9OrpnfXKkUX8STkfcG8VraTjkv7U
 sT4G04uHPI6c92/2N3GQtOK4eEEzo/XhYf0W2CZjX0q6fTARQpRPXeFGyd4EBMY0rkOj
 kCJIiStdbHZqtmxGYR6TeONplpohU1cmaW4WUkP6hJzBwNcfRcxSroYMwM904D85BjB8
 wESzRpuhIxHaZZlSGHih7KX/NB3U94H4tZr3xk460WNgAJPGg0Gjt7UCn4rfmPa7yqGs
 8cikMglBU0JF7wCjShbbnkpRnI0PXQTBxRMoLesTRTCqx0QX9lRsFZzxGwQTqOZbppNp GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 339gd0nwx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 05:18:43 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08192CgC072408;
        Tue, 1 Sep 2020 05:18:43 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 339gd0nwv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 05:18:43 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0819Cmpd004135;
        Tue, 1 Sep 2020 09:18:40 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 339ap7r9n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Sep 2020 09:18:40 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0819Ibap11731408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 1 Sep 2020 09:18:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DEB84C044;
        Tue,  1 Sep 2020 09:18:37 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 117794C04E;
        Tue,  1 Sep 2020 09:18:37 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.37.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  1 Sep 2020 09:18:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 0/3] s390x skrf and ultravisor patches
Date:   Tue,  1 Sep 2020 11:18:20 +0200
Message-Id: <20200901091823.14477-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_04:2020-09-01,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010075
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

initially I wanted to wait with this pull until I picked more patches,
but it doesn't look like that will happen soon and my vacation is
getting closer. So here we go:

The following changes since commit 1b53866b0b494277ab41c7c0cec4ee00969dd32e:

  Merge tag 's390x-2020-31-07' of https://github.com/frankjaa/kvm-unit-tests into HEAD (2020-08-09 18:06:26 +0200)

are available in the Git repository at:

  git@gitlab.com:frankja/kvm-unit-tests.git tags/s390x-2020-01-09

for you to fetch changes up to 2ea7afb64d34b5dd841334f72b99251ab56433cd:

  s390x: Ultravisor guest API test (2020-08-11 03:19:46 -0400)

----------------------------------------------------------------
* Added first Ultravisor tests
* Added SKRF key in PSW test
* Added custom program exception cleanup hook
----------------------------------------------------------------
Janosch Frank (3):
      s390x: Add custom pgm cleanup function
      s390x: skrf: Add exception new skey test and add test to unittests.cfg
      s390x: Ultravisor guest API test

 lib/s390x/asm/interrupt.h |   1 +
 lib/s390x/asm/uv.h        |  74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/interrupt.c     |  12 +++++++++++-
 s390x/Makefile            |   1 +
 s390x/skrf.c              |  79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg       |   7 +++++++
 s390x/uv-guest.c          | 150 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 323 insertions(+), 1 deletion(-)
 create mode 100644 lib/s390x/asm/uv.h
 create mode 100644 s390x/uv-guest.c



Janosch Frank (3):
  s390x: Add custom pgm cleanup function
  s390x: skrf: Add exception new skey test and add test to unittests.cfg
  s390x: Ultravisor guest API test

 lib/s390x/asm/interrupt.h |   1 +
 lib/s390x/asm/uv.h        |  74 +++++++++++++++++++
 lib/s390x/interrupt.c     |  12 ++-
 s390x/Makefile            |   1 +
 s390x/skrf.c              |  79 ++++++++++++++++++++
 s390x/unittests.cfg       |   7 ++
 s390x/uv-guest.c          | 150 ++++++++++++++++++++++++++++++++++++++
 7 files changed, 323 insertions(+), 1 deletion(-)
 create mode 100644 lib/s390x/asm/uv.h
 create mode 100644 s390x/uv-guest.c

-- 
2.25.4

