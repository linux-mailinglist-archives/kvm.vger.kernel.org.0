Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370C43F7A64
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbhHYQVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:21:31 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12829 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241374AbhHYQVR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Aug 2021 12:21:17 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PG3Rip126682
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=V+rHpkdZZ0qVCxilLDRrdPcU51oJjYyeh5rFNNBX0mE=;
 b=KZ8o/KXNDhB3yNe4yCI9KTNU9raR6keQIMhBwBEyekJvuw/CGWErO0RSwvr/WB0dUGoc
 EcZZlL3BVIF6SatHDVL5RFuv952EryeT9l7GVPmH6Kx4oAxEX8uU9546tYHVI44BG3rX
 CqYjLgYY/QxI8U3oBz56w55emUUMKggTeFB8djliKYWfMCJzP0+193cEd8APa4nHRRpG
 YBxdCQBFeue/X2mIMmfE0UWx+ffwjDimc6P+v0BNV6KuiJdmjS0rRUxziqYuC2mSSVln
 MQAiDTFDeDNjZsaGROWCPPV4ZxddWzx1pXIzwjRdd58lBCYQ0NeScLPMOyZ2/JoTjNAV nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3anqy4b3qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:29 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17PG3pJc128235
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 12:20:28 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3anqy4b3pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 12:20:28 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17PGGKRl023907;
        Wed, 25 Aug 2021 16:20:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ajs48eb84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Aug 2021 16:20:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17PGGawU52101596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Aug 2021 16:16:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28BEA11C050;
        Wed, 25 Aug 2021 16:20:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBF8811C052;
        Wed, 25 Aug 2021 16:20:22 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.34.28])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 25 Aug 2021 16:20:22 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/2] Two fixes for KVM unit tests
Date:   Wed, 25 Aug 2021 18:20:19 +0200
Message-Id: <1629908421-8543-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nribjg8TFSBAj1AdvDADMXA2CnSCt_K4
X-Proofpoint-ORIG-GUID: Z92RJfwSMYOPsQJgemQO-SJLbXS1ZS1z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_06:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 mlxscore=0 spamscore=0
 mlxlogscore=897 malwarescore=0 bulkscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108250096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I am not sure about the first one, cscope, it works for me
but may be someone has a better solution.

The second one fixes a bug of mine...

Regards,
Pierre

Pierre Morel (2):
  Makefile: Fix cscope
  s390x: fixing I/O memory allocation

 Makefile              | 2 +-
 lib/s390x/malloc_io.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.25.1

