Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4728C58EC6F
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiHJM4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiHJM4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:56:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD435C349;
        Wed, 10 Aug 2022 05:56:34 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ACoQHD012665;
        Wed, 10 Aug 2022 12:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=V6rtpLyoj2p21V5xVcf7iAEm2EV2Yi51fN5ZdGNfEZU=;
 b=E8VXrJyXmIJKdbLeNbUTad2a/C0bhQMMBXf+oto55P256oxK5Xt6FzHKK+JYANuJ+yOB
 qAQETbefoqQysT1sp4cvkC+Mq8JRKTOerHpfCtzfI48N8KthJhVFTceJrCMvOePME+6g
 SO5dcmzQ76ZIP8ALhto0sWHQVNDr85b80FSXMbUGYoy0E59N0OqCCRN+E9H3Zp5PEJS+
 ywCIT3gRAlUTWGUaBlmqmE9izDsJGEvkrwF0wcyMAn+4My+U2caZ9dnvu502Sj8/kMwA
 poq+3yi56D++cIxkE1mDEVM3M1feAd1v/7zN2WvKYlNnopBPwhjPlUQCT0telkYgdyCY ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv6dcw2e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:34 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27AConlt016134;
        Wed, 10 Aug 2022 12:56:33 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv6dcw2cv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:33 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ACuJSL012766;
        Wed, 10 Aug 2022 12:56:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3huww0ru71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:56:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ACrvai32375250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 12:53:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 210C64C046;
        Wed, 10 Aug 2022 12:56:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B8914C040;
        Wed, 10 Aug 2022 12:56:27 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.0.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 12:56:27 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v13 2/6] KVM: s390: pv: api documentation for asynchronous destroy
Date:   Wed, 10 Aug 2022 14:56:21 +0200
Message-Id: <20220810125625.45295-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810125625.45295-1-imbrenda@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OAwbhDxWgYD-uvt3LNOWZjSENNsX_Dba
X-Proofpoint-GUID: mpdmHUIR2XFfigsR0O-Y2vHdM7WZhu5p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_07,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 malwarescore=0
 adultscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for the new commands added to the KVM_S390_PV_COMMAND
ioctl.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9788b19f9ff7..5bd151b601b4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5163,8 +5163,11 @@ KVM_PV_ENABLE
 KVM_PV_DISABLE
   Deregister the VM from the Ultravisor and reclaim the memory that
   had been donated to the Ultravisor, making it usable by the kernel
-  again.  All registered VCPUs are converted back to non-protected
-  ones.
+  again. All registered VCPUs are converted back to non-protected
+  ones. If a previous VM had been set aside for asynchonous teardown
+  with KVM_PV_ASYNC_CLEANUP_PREPARE and not actually torn down with
+  KVM_PV_ASYNC_CLEANUP_PERFORM, it will be torn down in this call
+  together with the current VM.
 
 KVM_PV_VM_SET_SEC_PARMS
   Pass the image header from VM memory to the Ultravisor in
@@ -5287,6 +5290,29 @@ KVM_PV_DUMP
     authentication tag all of which are needed to decrypt the dump at a
     later time.
 
+KVM_PV_ASYNC_CLEANUP_PREPARE
+  Prepare the current protected VM for asynchronous teardown. Most
+  resources used by the current protected VM will be set aside for a
+  subsequent asynchronous teardown. The current protected VM will then
+  resume execution immediately as non-protected. There can be at most
+  one protected VM set aside at any time. If a protected VM had
+  already been set aside without starting the asynchronous teardown
+  process, this call will fail. In that case, the userspace process
+  should issue a normal KVM_PV_DISABLE. The resources set aside with
+  this call will need to be cleaned up with a subsequent call to
+  KVM_PV_ASYNC_CLEANUP_PERFORM or KVM_PV_DISABLE, otherwise they will
+  be cleaned up when KVM terminates.
+
+KVM_PV_ASYNC_CLEANUP_PERFORM
+  Tear down the protected VM previously set aside with
+  KVM_PV_ASYNC_CLEANUP_PREPARE. The resources that had been set aside
+  will be freed during the execution of this command. This PV command
+  should ideally be issued by userspace from a separate thread. If a
+  fatal signal is received (or the process terminates naturally), the
+  command will terminate immediately without completing, and the normal
+  KVM shutdown procedure will take care of cleaning up all remaining
+  protected VMs.
+
 
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
-- 
2.37.1

