Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD46B1FD8CA
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 00:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgFQWbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 18:31:01 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39446 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726496AbgFQWbB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Jun 2020 18:31:01 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05HM2Iv1045251;
        Wed, 17 Jun 2020 18:30:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q8njm80u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 18:30:53 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05HM3OvL049051;
        Wed, 17 Jun 2020 18:30:53 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31q8njm800-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 18:30:53 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05HMPwHg005287;
        Wed, 17 Jun 2020 22:30:50 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 31q6chrqav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Jun 2020 22:30:50 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05HMUllL12714452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Jun 2020 22:30:47 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B68B042045;
        Wed, 17 Jun 2020 22:30:47 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F22A04203F;
        Wed, 17 Jun 2020 22:30:46 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.74.214])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Jun 2020 22:30:46 +0000 (GMT)
Date:   Thu, 18 Jun 2020 00:29:56 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
Message-ID: <20200618002956.5f179de4.pasic@linux.ibm.com>
In-Reply-To: <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
        <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-17_12:2020-06-17,2020-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=560 mlxscore=0 bulkscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 malwarescore=0
 clxscore=1015 phishscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006170161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 17 Jun 2020 12:43:57 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> An architecture protecting the guest memory against unauthorized host
> access may want to enforce VIRTIO I/O device protection through the
> use of VIRTIO_F_IOMMU_PLATFORM.
> 
> Let's give a chance to the architecture to accept or not devices
> without VIRTIO_F_IOMMU_PLATFORM.
> 
[..]


I'm still not really satisfied with your commit message, furthermore
I did some thinking about the abstraction you introduce here. I will
give a short analysis of that, but first things first. Your patch does
the job of preventing calamity, and the details can be changed any time,
thus: 

Acked-by: Halil Pasic <pasic@linux.ibm.com>

Regarding the interaction of architecture specific code with virtio core,
I believe we could have made the interface more generic.

One option is to introduce virtio_arch_finalize_features(), a hook that
could reject any feature that is inappropriate.

Another option would be to find a common name for is_prot_virt_guest()
(arch/s390) sev_active() (arch/x86) and is_secure_guest() (arch/powerpc)
and use that instead of arch_needs_virtio_iommu_platform() and where-ever
appropriate. Currently we seem to want this info in driver code only for
virtio, but if the virtio driver has a legitimate need to know, other
drivers may as well have a legitimate need to know. For example if we
wanted to protect ourselves in ccw device drivers from somebody
setting up a vfio-ccw device and attach it to the prot-virt guest (AFAICT
we only lack guest enablement for this) such a function could be useful.

But since this can be rewritten any time, let's go with the option
people already agree with, instead of more discussion.

Just another question. Do we want this backported? Do we need cc stable?
[..]


>  int virtio_finalize_features(struct virtio_device *dev)
>  {
>  	int ret = dev->config->finalize_features(dev);
> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct virtio_device *dev)
>  	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>  		return 0;
>  
> +	if (arch_needs_virtio_iommu_platform(dev) &&
> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
> +		dev_warn(&dev->dev,
> +			 "virtio: device must provide VIRTIO_F_IOMMU_PLATFORM\n");

I'm not sure, divulging the current Linux name of this feature bit is a
good idea, but if everybody else is fine with this, I don't care that
much. An alternative would be:
"virtio: device falsely claims to have full access to the memory,
aborting the device"


Regards,
Halil
