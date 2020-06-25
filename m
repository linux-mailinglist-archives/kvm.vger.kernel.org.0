Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23AC20A191
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 17:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405751AbgFYPHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 11:07:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405552AbgFYPHl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Jun 2020 11:07:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PF2LQ7116909;
        Thu, 25 Jun 2020 11:07:40 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31uwyg381f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 11:07:39 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05PF2Lon116917;
        Thu, 25 Jun 2020 11:07:39 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31uwyg3814-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 11:07:39 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05PF6DJR020140;
        Thu, 25 Jun 2020 15:07:38 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 31uurycwka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 15:07:38 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05PF7aX848759276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 15:07:36 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E5D2AC05F;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0624DAC05B;
        Thu, 25 Jun 2020 15:07:36 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.85.202.75])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 25 Jun 2020 15:07:35 +0000 (GMT)
From:   Collin Walling <walling@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2 0/2] s390: Add API Docs for DIAGNOSE 0x318 and fix rst
Date:   Thu, 25 Jun 2020 11:07:22 -0400
Message-Id: <20200625150724.10021-1-walling@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_10:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=876 mlxscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 cotscore=-2147483648 lowpriorityscore=0 bulkscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Changelog:

    v2

    • Reworded patch 1 doc text

    • Added "Introduced in commit..." for rst fix patch

    • Added r-b's (thanks!)

Adds documentation for the s390-specfic DIAGNOSE 0x318 instruction, as
well as fixes some missing rst symbols for the neighboring entries.

Suggested-by: Cornelia Huck <cohuck@redhat.com>

Collin Walling (2):
  docs: kvm: add documentation for KVM_CAP_S390_DIAG318
  docs: kvm: fix rst formatting

 Documentation/virt/kvm/api.rst | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

-- 
2.26.2

