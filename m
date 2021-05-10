Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32C4A3791E9
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbhEJPGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:06:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63167 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230449AbhEJPDH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 11:03:07 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14AEaCA6137361;
        Mon, 10 May 2021 11:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=Hx/5zR/k53Kf7li0NdC6hyS24oZzz50dQguaxaXkf4Q=;
 b=gIDOgwCGEGwewdIqDQ8UCe5BkFqqVQfi5EmqA2QJqGjLt88ukJgz6YdGt+XcKXnfa/mT
 tPPoVvsTo79WiIbt+HVXy8p+yRx+yUiqFOJhysoFY3BQ/VOhT44fU8R6/3516kxwFgI+
 Asqy0U+WqY9IO6fOXXe5I8GwHjqxt7my0rcnucedkstF2xLY0DMAY9lJmAU5pRTBH18+
 B7FOtefxnWONxsnTUF92WxAAZ/kR2Q/j4lO7ZTw14NRmUsthgNS5TJRmyPQTBV0K4ram
 hxpIRvjNYrchefCGLXUuPLaEzv3LTdqd5Jw2EGrnp+ASshOQ4ugPYPBliinQm0ZyscIx +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f487wkcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:01 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14AEaelO140130;
        Mon, 10 May 2021 11:02:00 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38f487wkbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 11:02:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14AEqeKc006431;
        Mon, 10 May 2021 15:01:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 38dj9891w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 May 2021 15:01:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14AF1tMs29688120
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 May 2021 15:01:55 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B35EBAE057;
        Mon, 10 May 2021 15:01:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E510BAE056;
        Mon, 10 May 2021 15:01:54 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 May 2021 15:01:54 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH 0/4] s390x: cpumodel: Add sclp checks
Date:   Mon, 10 May 2021 15:00:11 +0000
Message-Id: <20210510150015.11119-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UZJiiUjQE-151fYV8XfrnvfXgS-etEsR
X-Proofpoint-GUID: sPD8wiwQyUIMEv8Rbok5nE3iFZ2I5zEB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-10_09:2021-05-10,2021-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105100105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SCLP facilities have been a bit overlooked in cpumodel tests and have
recently caused some headaches. So lets extend the tests and the
library with a bit of sclp feature checking.

Based on the uv_host branch / patches.

Janosch Frank (4):
  s390x: sclp: Only fetch read info byte 134 if cpu entries are above it
  lib: s390x: sclp: Extend feature probing
  s390x: cpumodel: FMT4 SCLP test
  s390x: cpumodel: FMT2 SCLP implies test

 lib/s390x/sclp.c | 23 +++++++++++++++-
 lib/s390x/sclp.h | 38 ++++++++++++++++++++++++--
 s390x/cpumodel.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 127 insertions(+), 5 deletions(-)

-- 
2.30.2

