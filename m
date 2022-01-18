Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0612492331
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbiARJw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:52:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54754 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234408AbiARJwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:33 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8bjHg030038;
        Tue, 18 Jan 2022 09:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WQJM91wV9wF0H/tPUQmZBgwvCIMc3vMZDEgCGnytoDo=;
 b=jSJdTF64xadKcYISMflyIb0VqX2RsfyzOTG9kMYs80mNC/dXmMBPKYdfjIoxvpAlI1ii
 9Yd2C4FD4po/cXm7ZP6FUYDRdNkedMb/gHSp+D9J+fHtQ1B1Hq/xSF4VkR2gbsxczVBa
 g8ZnKA/f49k+dAOEAj/y62pdXvGR9KZc2SRBmLOzyxULyymZIyoffIxVESgEI7TxfcZ0
 oHmNZgNt+nA0euHcbcBINAzb1vs8usBf/5g12RAP3OESpvAQXijuJcUUPR2aZ5mF+T+n
 Q4n3ckXQ7/a+pVoSgCWPhdVO6umrCHSlW5eSaA7jfSn/KoTssvz5+yDX/rdnYVSIgRV6 mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnq02e705-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:33 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9UBru008337;
        Tue, 18 Jan 2022 09:52:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnq02e6yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9ldrx009856;
        Tue, 18 Jan 2022 09:52:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9jmqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:30 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9qRJ641550182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:52:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4821CA4051;
        Tue, 18 Jan 2022 09:52:27 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD9BDA4053;
        Tue, 18 Jan 2022 09:52:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:26 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 09/10] KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
Date:   Tue, 18 Jan 2022 10:52:09 +0100
Message-Id: <20220118095210.1651483-10-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lLcsXn5fYlquLc6EZQ7WuSGFfRst6ShF
X-Proofpoint-GUID: tmtcFRhwhLXt6fALnN8i4QkF3LM6k6IU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Availability of the KVM_CAP_S390_MEM_OP_SKEY capability signals that:
* The vcpu MEM_OP IOCTL supports storage key checking.
* The vm MEM_OP IOCTL exists.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
Maybe this should be redesigned. As is, the capability mixes
support of storage keys for the vcpu ioctl with the availability
of the vm ioctl (which always supports storage keys).

We could have two capabilities, one to indicate the availability
of the vm memop and another used to derive the available functionality.
Janosch suggested that the second capability indicates the availability
of a "query" memop operation.

 arch/s390/kvm/kvm-s390.c | 1 +
 include/uapi/linux/kvm.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ab07389fb4d9..3c6517ad43a3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -565,6 +565,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_VCPU_RESETS:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
+	case KVM_CAP_S390_MEM_OP_SKEY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dd04170287fd..1bb38efd1156 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1134,6 +1134,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_S390_MEM_OP_SKEY 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.32.0

