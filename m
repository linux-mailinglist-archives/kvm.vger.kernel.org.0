Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27B42C2381
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 12:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbgKXLCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 06:02:03 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732447AbgKXLCD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 06:02:03 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AOAW7IA179620;
        Tue, 24 Nov 2020 06:01:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=lVsos4lno+eB5udRSRAS82PyJA/Ru4W3MJVpinWqJn4=;
 b=brYKCB/3idy/CnIJVkj/VwKMTjEg7xIRCEhbBsd6fSRwFF+PmUkFf8WZqhrvOKIWJNyW
 IrwVp3iXJsCH8MuJi2Up2k0VHQbRS1EeIiEqmYrA3igbXZVRIfWtvCuABFrEVf4Wj2eC
 +kf0g9bsF8Xa28+5gWu7dZkQaM9Q+CQmE4xH1GRVhEK5jvbQLmspaiU1mBO29D/FRmDT
 sD/j6kM8GI9l21Q/2xk6hXKc6hYGNe4f7he+Mnn/vHvu73BZVGaL/2rs4s0lPKhqnK0c
 1982OiuU+xgZQsxAMic+NM5Yo62IIj5MysVd359k1Z07+7x0AKM3kB7cdYUGGIq6zxRg Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb0ysr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 06:01:46 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AOB0aCR093282;
        Tue, 24 Nov 2020 06:01:46 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 350rb0ysmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 06:01:46 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AOAr6Iw017837;
        Tue, 24 Nov 2020 11:01:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 350cvrs0tk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 11:01:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AOB0O4B852534
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Nov 2020 11:00:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E1D942061;
        Tue, 24 Nov 2020 11:00:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7AACD4205C;
        Tue, 24 Nov 2020 11:00:21 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.32.189])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 24 Nov 2020 11:00:21 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     mpe@ellerman.id.au, paulus@samba.org
Cc:     ravi.bangoria@linux.ibm.com, mikey@neuling.org, npiggin@gmail.com,
        leobras.c@gmail.com, pbonzini@redhat.com, christophe.leroy@c-s.fr,
        jniethe5@gmail.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 4/4] KVM: PPC: Introduce new capability for 2nd DAWR
Date:   Tue, 24 Nov 2020 16:29:53 +0530
Message-Id: <20201124105953.39325-5-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124105953.39325-1-ravi.bangoria@linux.ibm.com>
References: <20201124105953.39325-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxlogscore=920
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011240061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce KVM_CAP_PPC_DAWR1 which can be used by Qemu to query whether
kvm supports 2nd DAWR or not.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 arch/powerpc/kvm/powerpc.c | 3 +++
 include/uapi/linux/kvm.h   | 1 +
 2 files changed, 4 insertions(+)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 13999123b735..48763fe59fc5 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -679,6 +679,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			!kvmppc_hv_ops->enable_svm(NULL);
 		break;
 #endif
+	case KVM_CAP_PPC_DAWR1:
+		r = cpu_has_feature(CPU_FTR_DAWR1);
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f6d86033c4fa..0f32d6cbabc2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1035,6 +1035,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_LAST_CPU 184
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_PPC_DAWR1 187
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.26.2

