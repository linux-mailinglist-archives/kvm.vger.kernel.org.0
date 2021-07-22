Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280153D2AC1
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 19:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhGVQWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jul 2021 12:22:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233829AbhGVQWO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Jul 2021 12:22:14 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MGlT0K062493;
        Thu, 22 Jul 2021 13:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=6TVmLsoFKmvY10YxmHyVkALKccJ2y7fUYOrKlnLe6lg=;
 b=noRGTNpBUO1u6JVoOFWbr78dQa5xBu6W262JVDliQknGzxWXAE1wj7KL6/8z44v64VGE
 NKCISGTig7eFH0XbkOmy56b8WGq2uwzaABIex0SHlEKZ17eMf9DFUavhISg3JtxYDnuA
 jBI/Iroir7NcO1VUbx/DsEe2bGOWhc4Le61Q0Z7HvzKRThK8E9cnQMj+oNLGalAvkneH
 8EpZ2BtvfzUoOsRvMq0mS3Zi2hoOBlcPZWRQf+ZlWr5TJ8V9qOCHPavwQ1glNa+5Rf8y
 O2G02hSLiNs1pHt1ijYSTMT73F9a/5NtVEMfF2GmeNwAwaQBKwpkZcjlB359m03Okmpe wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ycge8d43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 13:02:48 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16MGpGY3081012;
        Thu, 22 Jul 2021 13:02:48 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39ycge8d2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 13:02:48 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16MGxHWt032723;
        Thu, 22 Jul 2021 17:02:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 39vng727gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jul 2021 17:02:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16MH2gvt11796872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 17:02:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88973AE057;
        Thu, 22 Jul 2021 17:02:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05AC6AE051;
        Thu, 22 Jul 2021 17:02:42 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.18.177])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jul 2021 17:02:41 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v2 2/2] s390:kvm: Topology expose TOPOLOGY facility
Date:   Thu, 22 Jul 2021 19:02:33 +0200
Message-Id: <1626973353-17446-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
References: <1626973353-17446-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sySRMIDBn7Mv9FaU3s-Lz0DAHNirrAQC
X-Proofpoint-ORIG-GUID: TLueNPNqU5m56NNm0OnoDyqZnKYayh2g
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_09:2021-07-22,2021-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add a KVM extension KVM_CAP_S390_CPU_TOPOLOGY to tell the
userland hypervisor it is safe to activate the CPU Topology facility.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 1 +
 include/uapi/linux/kvm.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b655a7d82bf0..8c695ee79612 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -568,6 +568,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_S390_VCPU_RESETS:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
+	case KVM_CAP_S390_CPU_TOPOLOGY:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..081ce0cd44b9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1112,6 +1112,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_S390_CPU_TOPOLOGY 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.1

