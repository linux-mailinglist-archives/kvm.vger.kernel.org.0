Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356175676E9
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 20:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiGESyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 14:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiGESyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 14:54:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7791658C;
        Tue,  5 Jul 2022 11:54:36 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 265IkE10000897;
        Tue, 5 Jul 2022 18:54:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=k2+s5sTgIqqLhW2vKPIMrtugcEnszkrv05zEDyf/QbQ=;
 b=LFl/02wfk/7k7uwF9N9MSukQjYLM1o7CUR2c5jWq3ZsxqnE/ANW+CxRRimdjHqs4j4cc
 M/SBd6bE1YxZnoq/Yb9mVBd10eZJ5THhgdRUvo9V+jO5eh3bmIJDqZmF9tLSjt7I21kp
 yYgxPoI+1lFYdmkQqzyH/YXvGiRZaul+2HxTkUIAHFTNS2uEw7FCFD0QAfWsyNblFhvQ
 +KhUyHRMNRQk/iYtca/80HL+ct1aqk4LLB1GvecjN2xqci/8jp9tcGfGoXy0kijflT4L
 vGHk4WAKCy4PZtrgZ+OL7JJfaAuBpnadWWE/kea1dQfGZcpauE0fD8RIkOv0AhpQ8hnu BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4s61u818-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 18:54:35 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 265IlJx5006393;
        Tue, 5 Jul 2022 18:54:35 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4s61u80t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 18:54:35 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 265IoVdZ025416;
        Tue, 5 Jul 2022 18:54:34 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 3h2dn9ccmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 18:54:34 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 265IsX4u34079122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jul 2022 18:54:33 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27BF76E054;
        Tue,  5 Jul 2022 18:54:33 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D07E6E050;
        Tue,  5 Jul 2022 18:54:32 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.65.200.23])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  5 Jul 2022 18:54:32 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
Subject: [RFC] kvm: reverse call order of kvm_arch_destroy_vm() and kvm_destroy_devices()
Date:   Tue,  5 Jul 2022 14:54:30 -0400
Message-Id: <20220705185430.499688-1-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ddXMiZV97NvABjetn8h7hLjBv8_EX3Sp
X-Proofpoint-ORIG-GUID: HaTxUGUMQZo_IuWd1YvdjedRqy54riVl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_16,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=978 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207050080
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a new requirement for s390 secure execution guests that the
hypervisor ensures all AP queues are reset and disassociated from the
KVM guest before the secure configuration is torn down. It is the
responsibility of the vfio_ap device driver to handle this.

Prior to commit ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM"),
the driver reset all AP queues passed through to a KVM guest when notified
that the KVM pointer was being set to NULL. Subsequently, the AP queues
are only reset when the fd for the mediated device used to pass the queues
through to the guest is closed (the vfio_ap_mdev_close_device() callback).
This is not a problem when userspace is well-behaved and uses the
KVM_DEV_VFIO_GROUP_DEL attribute to remove the VFIO group; however, if
userspace for some reason does not close the mdev fd, a secure execution
guest will tear down its configuration before the AP queues are
reset because the teardown is done in the kvm_arch_destroy_vm function
which is invoked prior to vm_destroy_devices.

This patch proposes a simple solution; rather than introducing a new
notifier into vfio or callback into KVM, what aoubt reversing the order
in which the kvm_arch_destroy_vm and kvm_destroy_devices are called. In
some very limited testing (i.e., the automated regression tests for
the vfio_ap device driver) this did not seem to cause any problems.

The question remains, is there a good technical reason why the VM
is destroyed before the devices it is using? This is not intuitive, so
this is a request for comments on this proposed patch. The assumption
here is that the medev fd will get closed when the devices are destroyed.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a49df8988cd6..edaf2918be9b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1248,8 +1248,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
 #else
 	kvm_flush_shadow_all(kvm);
 #endif
-	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
+	kvm_arch_destroy_vm(kvm);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
 		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
-- 
2.31.1

