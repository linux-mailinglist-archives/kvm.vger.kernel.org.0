Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1B02FEE4A
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732764AbhAUPSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:18:10 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21334 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732666AbhAUPPr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:15:47 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LFBfZX172422;
        Thu, 21 Jan 2021 10:15:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ODDEjf45lSiu/+GG5Htm9GDO/8ZGKF2Y5B09yaOS7KY=;
 b=d2uRWzOJRIfI+5I6y1qFg+PyF1E3CxBis3XzXNIZhQiFW1nI4jwNXnImk5sPExFhCL3L
 1qqwz7jkspmLmErn1ClNrAnoaBqftpxZbW2S4zLiSjbRniRc3038XHZeTj3ivRHRU9d3
 jRnne1lYBoCtWMxGrC3fi6Wz3QsBm5GkTQ9qkpz263FFDOlT/UHf7ytOItMPXtP6JJ7Q
 g56XE1lyqN78iG+7FIoMTuaB9c86zf3DhIkaH9kgToEkOtdPpahfPVlivMBDrzGqP/U3
 UYJ1O0Hil9qkpLZul5O7MNwBB1l2d4VB+yEg4OKld8YlmVwsrYb3YtSEi1vdRxhgyFJT KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367c1pr4h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:15:03 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LFBp3Q173000;
        Thu, 21 Jan 2021 10:15:03 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367c1pr4g7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:15:03 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LFDVOp002522;
        Thu, 21 Jan 2021 15:15:01 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3668pass62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 15:15:01 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LFEwdG47710466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:14:58 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A90F311C058;
        Thu, 21 Jan 2021 15:14:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DBF411C050;
        Thu, 21 Jan 2021 15:14:57 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 15:14:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: [PATCH v2 0/2] s390: uv: small UV fixes
Date:   Thu, 21 Jan 2021 10:14:33 -0500
Message-Id: <20210121151436.417240-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_08:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=860 suspectscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two small fixes:
    * Handle 3d PGMs where the address space id is not known
    * Clean up the UV query VCPU number field naming (it's N-1 not N as number in this context means ID)

v2:
	* Renamed the struct member from max_guest_cpu to max_guest_cpu_id
	* Improved a comment text

Janosch Frank (2):
  s390: uv: Fix sysfs max number of VCPUs reporting
  s390: mm: Fix secure storage access exception handling

 arch/s390/boot/uv.c        |  2 +-
 arch/s390/include/asm/uv.h |  4 ++--
 arch/s390/kernel/uv.c      |  2 +-
 arch/s390/mm/fault.c       | 14 ++++++++++++++
 4 files changed, 18 insertions(+), 4 deletions(-)

-- 
2.25.1

