Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E41A3B7341
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 15:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhF2NgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Jun 2021 09:36:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233005AbhF2NgD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Jun 2021 09:36:03 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TDRqLT029400;
        Tue, 29 Jun 2021 09:33:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=JdrluYEpvHQkQbgK6FgEYQpDB+rOOkQfHRnVhxFU9wM=;
 b=m/oKcI1g/DEGIgK/QCbu2saZnZVKdJE5GO9mDAzkfKYsibB7ZIBjmCmOZJtZyhFyB0Ma
 CjsS4Sv18JkLcoQ3WVml+0OYiQERFX1v1wY/ZXmAkQzhoatyyyJNfKUh0YGcDc4u5YTe
 06lfhq5ylE4nyCqDvYu0HWBjqLHOs3rBG/8aGqVQYg2OfYoHJrvdCncU/uTqVNcpu/LA
 pgdvgPnYB21UA8ggxoleeC0YU3wykCXFCNfHiCXC6b+QCKSqAK1mQZfUqeGNwecsOh7L
 XYQhkFYNig1jngr0njJycx/jsoxkXhoQwt+NuaHfs84Sl7f4gA1xLu4wLfHT7je5+J5j Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g4e3r419-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:36 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15TDU8Xe037935;
        Tue, 29 Jun 2021 09:33:35 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39g4e3r407-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 09:33:35 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15TDSJwK004310;
        Tue, 29 Jun 2021 13:33:33 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 39duv8gp5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Jun 2021 13:33:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15TDXU6l25952704
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 13:33:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA526A40E5;
        Tue, 29 Jun 2021 13:33:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70BA7A40D8;
        Tue, 29 Jun 2021 13:33:30 +0000 (GMT)
Received: from t46lp67.lnxne.boe (unknown [9.152.108.100])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 29 Jun 2021 13:33:30 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH 0/5] s390x: sie and uv cleanups
Date:   Tue, 29 Jun 2021 13:33:17 +0000
Message-Id: <20210629133322.19193-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 32ZrWR8UpSlVkqGcAVRE8wV2x3ldJx5N
X-Proofpoint-ORIG-GUID: rS88GiHF3xZHVkbo7RKcqAjLJst9HkIt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-29_06:2021-06-28,2021-06-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 bulkscore=0 spamscore=0 adultscore=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=790 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UV and SIE additions brought in some minor problems which I want
to address now.

Janosch Frank (5):
  s390x: sie: Add missing includes
  s390x: sie: Fix sie.h integer types
  lib: s390x: uv: Int type cleanup
  lib: s390x: uv: Add offset comments to uv_query and extend it
  lib: s390x: Print if a pgm happened while in SIE

 lib/s390x/asm/uv.h    | 145 +++++++++++++++++++++---------------------
 lib/s390x/interrupt.c |  17 ++++-
 lib/s390x/sie.h       |  11 ++--
 3 files changed, 95 insertions(+), 78 deletions(-)

-- 
2.30.2

