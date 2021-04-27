Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B18A36C5E8
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 14:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhD0MQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 08:16:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28092 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235410AbhD0MQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 08:16:57 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13RC2liB152839
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 08:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=yhD1YNM89K2upDWov/ofq8a0LRVkPrK1zUWQRmieaHU=;
 b=B+nDHxD/BPOd9pg/iMebZ8xnM9QGbTEhdkoPXnRLegmpvRMMfy9V4Dugcfb2aVkwrRfB
 rJ7vIdNTdT+n8l8Zy5U7aXsGv9G7cE16ZP+NmB8JMOHUbx8dT+CIi9fQGUaCezs83Fuz
 OSUBjJSH/gYrWIbgOix3I4lqFc0CQZ7bgfdyeGSizVrftVYHPrlM6K7XAgo2n4X8V+h0
 9vEdg9K1wNPoVkEGv/KFbh+puCwp09cCdMxrKwWGWvoQ/W+qaLPb242IMHikfYfN16qw
 TtMPVPPxtXo5vuD56emhxnU6hW5sY+oLPDTifiFGnNqj3WoT1c1gAwdIxpqFFjUUGirt RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 386gvx2y6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 08:16:14 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13RC38Q0154800
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 08:16:13 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 386gvx2y5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 08:16:13 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13RCDkTZ029038;
        Tue, 27 Apr 2021 12:16:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 384ay8hawc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 12:16:12 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13RCG9bQ32768496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 12:16:09 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EEEEA4062;
        Tue, 27 Apr 2021 12:16:09 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E48EA4064;
        Tue, 27 Apr 2021 12:16:08 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.13.42])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 27 Apr 2021 12:16:08 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, cohuck@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v1 1/1] MAINTAINERS: s390x: add myself as reviewer
Date:   Tue, 27 Apr 2021 14:16:08 +0200
Message-Id: <20210427121608.157783-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _5K0ZkG2p1D7oxj7ah_t0IA6fRnsYbi-
X-Proofpoint-GUID: HjXb49lfKUPLpfZHNfK3WkigpMi91nhA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_06:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=984 suspectscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e2505985..aaa404cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -85,6 +85,7 @@ M: Thomas Huth <thuth@redhat.com>
 M: David Hildenbrand <david@redhat.com>
 M: Janosch Frank <frankja@linux.ibm.com>
 R: Cornelia Huck <cohuck@redhat.com>
+R: Claudio Imbrenda <imbrenda@linux.ibm.com>
 L: kvm@vger.kernel.org
 L: linux-s390@vger.kernel.org
 F: s390x/*
-- 
2.26.3

