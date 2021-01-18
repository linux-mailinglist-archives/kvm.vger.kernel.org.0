Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827462FA12C
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 14:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404007AbhARNSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 08:18:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392128AbhARNSh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 08:18:37 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10ID3YJB019940;
        Mon, 18 Jan 2021 08:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=8tkeQGsFBR/19zcWcJgkcGEoGDrufQhBcasXaTGWg7k=;
 b=ByWD7pDIfYf3wyXqbQRR1fzo3SW8h1KBpBYjehTgDt0Guu4/c77prxGgo7f+/pYT4RPy
 twWqFFhrBBE26D1GF9C7Va914vfxt3KxpwRB7390iR2uwWKEt2QRZX6JkQ7K4+uo/6ZG
 YtTgp14O2Fc9Y8fjQlhl175FmJqF83kZ5HuBb8ba7AFkugKoXMArNi2EtIK083fhiAA8
 RLht0u9b4jmcyweiANTf84YXPRZbFiLOr0X9kEa1PY/4rUd9/PPJXhNeffTG+tf1kX6y
 UQ0X7+jRlxypaEwA9NJHg0nwxQKcAm89N30FvIJpYoUH0IuSTKUdhkO/pAs2Z8+685+K 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36586hchur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 08:17:46 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10ID3u3M023436;
        Mon, 18 Jan 2021 08:17:46 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36586hchtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 08:17:45 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10IDHIup010618;
        Mon, 18 Jan 2021 13:17:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 363qdh92te-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jan 2021 13:17:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10IDHdCk39387466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 13:17:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D844242047;
        Mon, 18 Jan 2021 13:17:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C547D42045;
        Mon, 18 Jan 2021 13:17:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 13:17:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 6FDC5E02A3; Mon, 18 Jan 2021 14:17:39 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH 0/1] diag9c forwarding
Date:   Mon, 18 Jan 2021 14:17:38 +0100
Message-Id: <20210118131739.7272-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-18_11:2021-01-18,2021-01-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=880 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch will forward the yieldto hypercall (diag9c) if in the host
the target CPU is also not running. As we do not yet have performance
data (and recommendations) the default is turned off, but this can
be changed during runtime.

Pierre Morel (1):
  s390:kvm: diag9c forwarding

 arch/s390/include/asm/kvm_host.h |  1 +
 arch/s390/include/asm/smp.h      |  1 +
 arch/s390/kernel/smp.c           |  1 +
 arch/s390/kvm/diag.c             | 31 ++++++++++++++++++++++++++++---
 arch/s390/kvm/kvm-s390.c         |  6 ++++++
 arch/s390/kvm/kvm-s390.h         |  8 ++++++++
 6 files changed, 45 insertions(+), 3 deletions(-)

-- 
2.28.0

