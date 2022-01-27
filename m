Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476EB49E45F
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 15:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241786AbiA0OQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 09:16:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238954AbiA0OQI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 09:16:08 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RECja9007904;
        Thu, 27 Jan 2022 14:16:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HZOp6xuQhEFdhLeo643dmJsqyZp7t4k0hSBDqmBvtxk=;
 b=GPm2xFUMCTm/bLnqoPdQ9NO6TKBbaK+XwZY/wfM/YebglfT87iWg+8cB3eiGfXK14arr
 V/DxGngKE7fFazvGIzNWF9uzl8jVLEBsYqX2dyXP+SD+JOv8dZ4lh/OrEBfIhj2T91me
 CXyl7T8wbjr5awiY/msLs/EN7Dod/uEXlHzbtT1qYUiPDrm1IdJjYnkDPLNtFztuL0eb
 em9SILMI3SUmecu//8dYef3K6PQLQ9n3965m3dSpSBKuPg4+yyXXJ49OLW91ZBMIEM5e
 nMAxbqJUEWyo8iRPfLK2PEBppwg2bO65Yz7+6gBE3R+5JRu9EPWmPd6zuNehQpkEvJsW ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3duvxxg2a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:08 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20REFOpF022226;
        Thu, 27 Jan 2022 14:16:07 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3duvxxg293-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:07 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20REDBfd024435;
        Thu, 27 Jan 2022 14:16:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9j9xn08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:16:04 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RE6N0s30408988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 14:06:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2B64452054;
        Thu, 27 Jan 2022 14:16:01 +0000 (GMT)
Received: from linux7.. (unknown [9.114.12.92])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E276652077;
        Thu, 27 Jan 2022 14:15:59 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH 0/4] s390x: Attestation tests
Date:   Thu, 27 Jan 2022 14:15:55 +0000
Message-Id: <20220127141559.35250-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: REP7KexJmqAh51M2NItlh6HnQwf8NaBq
X-Proofpoint-ORIG-GUID: SkCMO_Od4mL0OGmVzXSXtCI6C2NXaRjy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 mlxlogscore=830 spamscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series adds some test in s390x/uv-guest.c verifying error paths of the
Request Attestation Measurement UVC.
Also adds a test in s390x/uv-host.c to verify that the
Request Attestation Measurement UVC cannot be called in guest1.

Steffen Eiden (4):
  s390x: uv-host: Add attestation test
  s390x: lib: Add QUI getter
  s390x: uv-guest: remove duplicated checks
  s390x: uv-guest: Add attestation tests

 lib/s390x/asm/uv.h |  29 ++++++-
 lib/s390x/uv.c     |  10 ++-
 lib/s390x/uv.h     |   1 +
 s390x/uv-guest.c   | 188 +++++++++++++++++++++++++++++++++++++++++----
 s390x/uv-host.c    |   3 +-
 5 files changed, 211 insertions(+), 20 deletions(-)

-- 
2.30.2

