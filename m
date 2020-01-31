Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8885314EF0C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgAaPEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:04:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729118AbgAaPD7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:03:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VEx2Dn056125
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:58 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvkrffgsh-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:03:58 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:03:56 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:03:52 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF3plb58130562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:03:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C3A3A4069;
        Fri, 31 Jan 2020 15:03:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF5CDA4065;
        Fri, 31 Jan 2020 15:03:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:03:50 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B0550E03BC; Fri, 31 Jan 2020 16:03:50 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 5/7] selftests: KVM: Add fpu and one reg set/get library functions
Date:   Fri, 31 Jan 2020 16:03:46 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150348.73360-1-borntraeger@de.ibm.com>
References: <20200131150348.73360-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20013115-0020-0000-0000-000003A5DF15
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0021-0000-0000-000021FD997B
Message-Id: <20200131150348.73360-6-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1911200001
 definitions=main-2001310127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Add library access to more registers.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20200131100205.74720-5-frankja@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  6 ++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 36 +++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 29cccaf96baf..ae0d14c2540a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -125,6 +125,12 @@ void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_sregs *sregs);
 int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_sregs *sregs);
+void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
+		  struct kvm_fpu *fpu);
+void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
+		  struct kvm_fpu *fpu);
+void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
+void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
 #ifdef __KVM_HAVE_VCPU_EVENTS
 void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_vcpu_events *events);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 41cf45416060..a6dd0401eb50 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1373,6 +1373,42 @@ int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
 	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
 }
 
+void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
+{
+	int ret;
+
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
+	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i (%s)",
+		    ret, errno, strerror(errno));
+}
+
+void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
+{
+	int ret;
+
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
+	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i (%s)",
+		    ret, errno, strerror(errno));
+}
+
+void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
+{
+	int ret;
+
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
+	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i (%s)",
+		    ret, errno, strerror(errno));
+}
+
+void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
+{
+	int ret;
+
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
+	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i (%s)",
+		    ret, errno, strerror(errno));
+}
+
 /*
  * VCPU Ioctl
  *
-- 
2.21.0

