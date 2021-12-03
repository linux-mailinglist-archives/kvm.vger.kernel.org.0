Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A90467C01
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382427AbhLCRCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:02:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46810 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1382243AbhLCRB4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:56 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GqSVd007036;
        Fri, 3 Dec 2021 16:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OGnjOtnRwXdWYCWfAZ0oleDtk/u5jJs2fRwaqG7IYcw=;
 b=SVaN7kLVjlE/Z1Zqud+2n0VVwrLbCYVDDElhdyAX1M7vZlg75M1fttvKFZ72oO9MZztD
 gbqyApy5aWHN3oIJpnN9wjLBnYOdrYpGa0rNEmYJINoeRJb4vCCHFiDBbvi8VybWoZGF
 yNiJDXGWJtW+Yp+ATIqO9EM/RVdyOVV176FvTVUqg6R0b/MHUtXCj4w3I+zi581r4K4v
 w42iK9ysWAL8VL1cX5wVT3CM/uGh//h1nc7JVFcdoKFthfMkrYrEgyQkJbd0dqpI4dud
 LaLu/p18bnPvIjOy8v4VRHl+Py9FG/BrxNTuwTTkLgTbXYFBUa2fRkYkZYyvE1KXvA36 wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cqq52g2am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:29 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3Gu821017334;
        Fri, 3 Dec 2021 16:58:29 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cqq52g2aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:29 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GvTFs011813;
        Fri, 3 Dec 2021 16:58:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ckcaacxvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:27 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwOMQ29098282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 488A75204E;
        Fri,  3 Dec 2021 16:58:24 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B86335204F;
        Fri,  3 Dec 2021 16:58:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 15/17] KVM: s390: pv: api documentation for asynchronous destroy
Date:   Fri,  3 Dec 2021 17:58:12 +0100
Message-Id: <20211203165814.73016-16-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Wy3L0_HGTzkwUJl82_-8_ZEqbKGwvVve
X-Proofpoint-ORIG-GUID: XLYCJXkYleIj2nEl-1cDN8PW4JPAih4H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 clxscore=1015 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for the new commands added to the KVM_S390_PV_COMMAND
ioctl.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aeeb071c7688..f4d981cd58fa 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4975,11 +4975,13 @@ KVM_PV_ENABLE
   =====      =============================
 
 KVM_PV_DISABLE
-
   Deregister the VM from the Ultravisor and reclaim the memory that
   had been donated to the Ultravisor, making it usable by the kernel
-  again.  All registered VCPUs are converted back to non-protected
-  ones.
+  again. All registered VCPUs are converted back to non-protected
+  ones. If a previous VM had been prepared for asynchonous teardown
+  with KVM_PV_ASYNC_DISABLE_PREPARE and not actually torn down with
+  KVM_PV_ASYNC_DISABLE, it will be torn down in this call together with
+  the current VM.
 
 KVM_PV_VM_SET_SEC_PARMS
   Pass the image header from VM memory to the Ultravisor in
@@ -4992,6 +4994,19 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+KVM_PV_ASYNC_DISABLE_PREPARE
+  Prepare the current protected VM for asynchronous teardown. The current
+  VM will then continue immediately as non-protected. If a protected VM had
+  already been set aside without starting the teardown process, this call
+  will fail. In this case the userspace process should issue a normal
+  KVM_PV_DISABLE.
+
+KVM_PV_ASYNC_DISABLE
+  Tear down the protected VM previously set aside for asynchronous teardown.
+  This PV command should ideally be issued by userspace from a separate
+  thread. If a fatal signal is received (or the process terminates
+  naturally), the command will terminate immediately without completing.
+
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
 
-- 
2.31.1

