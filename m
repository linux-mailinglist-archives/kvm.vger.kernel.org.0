Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E261125FD02
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 17:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgIGPZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 11:25:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17674 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730174AbgIGPYk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 11:24:40 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087FLJmB015920;
        Mon, 7 Sep 2020 11:23:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pFAH4kKoxvJA1wLSTzhFSk4grLkcCyjjuenbU1qPJZs=;
 b=c3j3W2ZqWi6XxEgH3p7xXiFsCi8CCa7mPueJxyBln93m4P41wznnFwccECO1FLsuUaaH
 zaOJkEWTvpNCj0lKmp9MjhsCZf13FV+fiLWKx/WGTVMZXxHbK2rf5aZ4Elr9jfzaYsla
 EdEz7Rcnzwh1piM7H9+g3OB7V0HxKPoKExd5BaNN0knrv05mAZNLyIKbtBMPKaFJ3drr
 sF+XxV3QAee1ap37rWBBRUFBSScxxZmG76CLT4VRx613OoTX5I/fjYUWFn9ko/i0/P1B
 yO1Y+4pP90g1TTYO+ochey6vp1GhDnI/3s1x1E1Cv03gm6V/cjXTRFKdT5VliGM7bVlu CQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dqear0uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 11:23:32 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 087FLmW7016865;
        Mon, 7 Sep 2020 11:23:31 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33dqear0uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 11:23:31 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 087FHw7C029042;
        Mon, 7 Sep 2020 15:23:29 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33c2a81hy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 15:23:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 087FNRqC25887090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 15:23:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3FACAE051;
        Mon,  7 Sep 2020 15:23:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11C78AE045;
        Mon,  7 Sep 2020 15:23:26 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.173.93])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 15:23:25 +0000 (GMT)
Date:   Mon, 7 Sep 2020 17:22:53 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200907172253.0a51f5f7.pasic@linux.ibm.com>
In-Reply-To: <20200724025744.69644-11-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-11-david@gibson.dropbear.id.au>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_10:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jul 2020 12:57:44 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> At least some s390 cpu models support "Protected Virtualization" (PV),
> a mechanism to protect guests from eavesdropping by a compromised
> hypervisor.
> 
> This is similar in function to other mechanisms like AMD's SEV and
> POWER's PEF, which are controlled bythe "host-trust-limitation"
> machine option.  s390 is a slightly special case, because we already
> supported PV, simply by using a CPU model with the required feature
> (S390_FEAT_UNPACK).
> 
> To integrate this with the option used by other platforms, we
> implement the following compromise:
> 
>  - When the host-trust-limitation option is set, s390 will recognize
>    it, verify that the CPU can support PV (failing if not) and set
>    virtio default options necessary for encrypted or protected guests,
>    as on other platforms.  i.e. if host-trust-limitation is set, we
>    will either create a guest capable of entering PV mode, or fail
>    outright

Shouldn't we also fail outright if the virtio features are not PV
compatible (invalid configuration)?

I would like to see something like follows as a part of this series.
----------------------------8<--------------------------
From: Halil Pasic <pasic@linux.ibm.com>
Date: Mon, 7 Sep 2020 15:00:17 +0200
Subject: [PATCH] virtio: handle host trust limitation

If host_trust_limitation_enabled() returns true, then emulated virtio
devices must offer VIRTIO_F_ACCESS_PLATFORM, because the device is not
capable of accessing all of the guest memory. Otherwise we are in
violation of the virtio specification.

Let's fail realize if we detect that VIRTIO_F_ACCESS_PLATFORM feature is
obligatory but missing.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
---
 hw/virtio/virtio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index 5bd2a2f621..19b4b0a37a 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -27,6 +27,7 @@
 #include "hw/virtio/virtio-access.h"
 #include "sysemu/dma.h"
 #include "sysemu/runstate.h"
+#include "exec/host-trust-limitation.h"
 
 /*
  * The alignment to use between consumer and producer parts of vring.
@@ -3618,6 +3619,12 @@ static void virtio_device_realize(DeviceState *dev, Error **errp)
     /* Devices should either use vmsd or the load/save methods */
     assert(!vdc->vmsd || !vdc->load);
 
+    if (host_trust_limitation_enabled(MACHINE(qdev_get_machine()))
+        && !virtio_host_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM)) {
+        error_setg(&err, "devices without VIRTIO_F_ACCESS_PLATFORM are not compatible with host trust imitation");
+        error_propagate(errp, err);
+        return;
+    }
     if (vdc->realize != NULL) {
         vdc->realize(dev, &err);
         if (err != NULL) {
-- 
2.21.0

