Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6AC2FBDFF
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389448AbhASOum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:50:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64088 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389581AbhASKGR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:06:17 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JA1X6G151764;
        Tue, 19 Jan 2021 05:05:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=MvkOlGB+RFnvJiq75XxoiH7oyCh3GyINVvbzK2tCWM4=;
 b=K9U6X4TN/FiYk/SyYKH13ymxkQjDqsLpZxYnTW3BkrL5BRs6s1RkT+6bKGFTBO7SS7Ht
 CoJTdETT+FEyu7Pbpti2cHsprWZ3AnQxOPG/JHvdMZV2wTSyal1GN5e0HKvW+pBTEoq7
 j3idvfbP6d7TYhYwvGzlO/rbVC/oz+BmzHJqn9f9LWzvs3pX95T8mx7zq5qeELAQw1M6
 NfkkqdEprbwJ40CZ6dntk/clGg8PqTVv7Al4FGPTh9+TxJEMErVl0nijp8ZNoN6SwUvx
 ooHAiATBj5IxyQxAHQXnA5F33MZsyggd8XU6Omo4dZrnDH0lbfRa8woIvlppXldF5aSu tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365vx10rf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:05:35 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JA1X3u151767;
        Tue, 19 Jan 2021 05:05:28 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365vx10r3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:05:28 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JA3xb0022520;
        Tue, 19 Jan 2021 10:05:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 363qdh9h41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:05:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JA4rdZ16122366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:04:53 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65E804C04A;
        Tue, 19 Jan 2021 10:04:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 57E324C05C;
        Tue, 19 Jan 2021 10:04:58 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:04:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
Subject: [PATCH 0/2] s390: uv: small UV fixes
Date:   Tue, 19 Jan 2021 05:04:00 -0500
Message-Id: <20210119100402.84734-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=719 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two small fixes:
    * Handle 3d PGMs where the address space id is not known
    * Clean up the UV query VCPU number field naming (it's N-1 not N as number in this context means ID)

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

