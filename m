Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B0825168D
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 12:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgHYKVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 06:21:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15010 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729680AbgHYKVA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 06:21:00 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PACij1119387
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=2EmO7GuAkt2CBeoiQu48W4AhvFHCdNqQkoc/pOSQtkw=;
 b=aN2LZosWPFpvcR2gQ7wDO95i5AC/Km8NJyliG1DKg42fge6Xjp/od6DP49u0+Vmy9WNr
 XCLMGftmVlhSKrxvQ/JXzX1ouZYixNpdrmT9lYJ6mZmf+A5AOkBVFd5cx7OamBkUDX4E
 bZiW24B0kciJ2d8n5qly5+VWXdkAOxNg8hAGbwMgNCL80obc+98cFksxXxA4/kLxVlhg
 b9NnMLQgnjTAsMuFYMXMkECAq1OL706dqr2WG3dKeB0rbcTrV2fKYYWtU0W6GF+Nc+/U
 ZMhageIiGKL2hQFjAP4k03mctynuQeOxGmnL0r+AnO4jnphx5+3o0C3px9uFnoGvJGLn Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3350pjr6hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:59 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07PAG6wS127460
        for <kvm@vger.kernel.org>; Tue, 25 Aug 2020 06:20:58 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3350pjr6h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 06:20:58 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07PAFvws001176;
        Tue, 25 Aug 2020 10:20:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 332ujkua9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 10:20:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07PAKrFc30212602
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 10:20:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A80A6A404D;
        Tue, 25 Aug 2020 10:20:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F911A4040;
        Tue, 25 Aug 2020 10:20:53 +0000 (GMT)
Received: from marcibm.ibmuc.com (unknown [9.145.56.167])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Aug 2020 10:20:53 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     <kvm@vger.kernel.org>
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v2 0/2] Use same test names in the default and the TAP13 output format
Date:   Tue, 25 Aug 2020 12:20:34 +0200
Message-Id: <20200825102036.17232-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_02:2020-08-24,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For everybody's convenience there is a branch:
https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/tap_v2

Changelog:
v1 -> v2:
 + added r-b's to patch 1
 + patch 2:
  - I've not added Andrew's r-b since I've worked in the comment from
    Janosch (don't drop the first prefix)

Marc Hartmayer (2):
  runtime.bash: remove outdated comment
  Use same test names in the default and the TAP13 output format

 run_tests.sh         | 15 +++++++++------
 scripts/runtime.bash |  9 +++------
 2 files changed, 12 insertions(+), 12 deletions(-)

-- 
2.25.4

