Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0841FC8E2
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 10:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgFQIg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 04:36:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22684 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726280AbgFQIg1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 04:36:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05H8VjBM092449;
        Wed, 17 Jun 2020 04:36:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hdebe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 04:36:26 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05H8VlWD092647;
        Wed, 17 Jun 2020 04:36:25 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31q6hdebdm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 04:36:25 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05H8VJ9N022432;
        Wed, 17 Jun 2020 08:36:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 31q6c8r97v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 08:36:24 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05H8aMXV64684036
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 08:36:22 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E24CA4C04A;
        Wed, 17 Jun 2020 08:36:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD9BC4C040;
        Wed, 17 Jun 2020 08:36:21 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 17 Jun 2020 08:36:21 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 59558E027E; Wed, 17 Jun 2020 10:36:21 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: s390: reduce number of IO pins to 1
Date:   Wed, 17 Jun 2020 10:36:20 +0200
Message-Id: <20200617083620.5409-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-16_13:2020-06-16,2020-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 cotscore=-2147483648 malwarescore=0
 suspectscore=2 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
allocation (32kb) for each guest start/restart. This can result in OOM
killer activity even with free swap when the memory is fragmented
enough:

kernel: qemu-system-s39 invoked oom-killer: gfp_mask=0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_COMP|__GFP_ZERO), order=3, oom_score_adj=0
kernel: CPU: 1 PID: 357274 Comm: qemu-system-s39 Kdump: loaded Not tainted 5.4.0-29-generic #33-Ubuntu
kernel: Hardware name: IBM 8562 T02 Z06 (LPAR)
kernel: Call Trace:
kernel: ([<00000001f848fe2a>] show_stack+0x7a/0xc0)
kernel:  [<00000001f8d3437a>] dump_stack+0x8a/0xc0
kernel:  [<00000001f8687032>] dump_header+0x62/0x258
kernel:  [<00000001f8686122>] oom_kill_process+0x172/0x180
kernel:  [<00000001f8686abe>] out_of_memory+0xee/0x580
kernel:  [<00000001f86e66b8>] __alloc_pages_slowpath+0xd18/0xe90
kernel:  [<00000001f86e6ad4>] __alloc_pages_nodemask+0x2a4/0x320
kernel:  [<00000001f86b1ab4>] kmalloc_order+0x34/0xb0
kernel:  [<00000001f86b1b62>] kmalloc_order_trace+0x32/0xe0
kernel:  [<00000001f84bb806>] kvm_set_irq_routing+0xa6/0x2e0
kernel:  [<00000001f84c99a4>] kvm_arch_vm_ioctl+0x544/0x9e0
kernel:  [<00000001f84b8936>] kvm_vm_ioctl+0x396/0x760
kernel:  [<00000001f875df66>] do_vfs_ioctl+0x376/0x690
kernel:  [<00000001f875e304>] ksys_ioctl+0x84/0xb0
kernel:  [<00000001f875e39a>] __s390x_sys_ioctl+0x2a/0x40
kernel:  [<00000001f8d55424>] system_call+0xd8/0x2c8

As far as I can tell s390x does not use the iopins as we bail our for
anything other than KVM_IRQ_ROUTING_S390_ADAPTER and the chip/pin is
only used for KVM_IRQ_ROUTING_IRQCHIP. So let us use a small number to
reduce the memory footprint.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cee3cb6455a2..6ea0820e7c7f 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -31,12 +31,12 @@
 #define KVM_USER_MEM_SLOTS 32
 
 /*
- * These seem to be used for allocating ->chip in the routing table,
- * which we don't use. 4096 is an out-of-thin-air value. If we need
- * to look at ->chip later on, we'll need to revisit this.
+ * These seem to be used for allocating ->chip in the routing table, which we
+ * don't use. 1 is as small as we can get to reduce the needed memory. If we
+ * need to look at ->chip later on, we'll need to revisit this.
  */
 #define KVM_NR_IRQCHIPS 1
-#define KVM_IRQCHIP_NUM_PINS 4096
+#define KVM_IRQCHIP_NUM_PINS 1
 #define KVM_HALT_POLL_NS_DEFAULT 50000
 
 /* s390-specific vcpu->requests bit members */
-- 
2.25.4

