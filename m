Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A902171854C
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjEaOse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 10:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjEaOsb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 10:48:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AEC98;
        Wed, 31 May 2023 07:48:29 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VEhcBa019044;
        Wed, 31 May 2023 14:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Jf3ESBiV0WYmua8oMWSDBRYW5TNiZaTmcKkan9Ai01Q=;
 b=jJB1OTV8exMXNfX0PfeZbLN1m+wVqLQji+T8a2tkEI6RmZJuIN3TNO8VzHqQAH+DE518
 ttG0sRVOroXshGGXI8IltNTfEiv1qYr4dQWFWB/m/qcD8wrkg2mRth88SmqTeUmSMdDM
 qiWOkuGZqugLsd/ulkg/N9t/49j0H944Oty2BuGxC5jIdqHStdhNlilLhYHtXesYhQ7Z
 aMA5xdinz6V20sTJXoYWS9rWG7xda/N0ZAbFQZdkcQz7p1UJpcbWguFtd6CPTgvqK3m9
 NTImCzWhNTwhZqr4/lKZwTV1whsxw6JMrUco7F/GSemQFDOPCKfyeLDBmm6LpU2NXE/S MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx88f05kx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:48:28 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VEj5oL024343;
        Wed, 31 May 2023 14:48:27 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx88f05kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:48:27 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34VBLtRY008119;
        Wed, 31 May 2023 14:48:27 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([9.208.130.98])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3qu9g8c4u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:48:27 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VEmQCS61866290
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 14:48:26 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 289AC58060;
        Wed, 31 May 2023 14:48:26 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DBAF5805F;
        Wed, 31 May 2023 14:48:25 +0000 (GMT)
Received: from [9.61.34.174] (unknown [9.61.34.174])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 14:48:25 +0000 (GMT)
Message-ID: <9837da27-e224-aded-fe3e-4f4db6b1599c@linux.ibm.com>
Date:   Wed, 31 May 2023 10:48:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 0/3] s390/vfio-ap: fix hang when mdev attached to guest is
 removed
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230530223538.279198-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d4jZX2YW3q2NdfP1uTw-0zf27mojLwKt
X-Proofpoint-ORIG-GUID: yPzsWQv9FV8o2XPRUDbje4Hnsswno19e
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 spamscore=0 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2304280000 definitions=main-2305310124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/23 6:35 PM, Tony Krowiak wrote:
> When a user attempts to remove a vfio-ap mediated device attached to a
> guest, the operation hangs until the mdev's fd is closed by the guest
> (i.e., the hostdev is detached or the guest is shut down). This patch 
> series provides kernel-side code that allows userspace to set up a 
> communication channel that will allow the vfio_ap device driver to notify 
> userspace when a request to release the mdev is received, so that userspace
> can close the mdev fd and avoid the hang. The patch series provides the 
> following:  
> 
> 1. Introduces code to handle the VFIO_DEVICE_GET_IRQ_INFO and 
>    VFIO_DEVICE_SET_IRQS ioctl calls to set the eventfd_ctx for signaling a
>    device request to userspace. 
> 
> 2. Wires up the VFIO bus driver callback to request a release of the mdev.
>    When invoked, the vfio_ap device driver will use the eventfd_ctx set up
>    in #1 to signal a request to userspace to release the mdev.
> 
> 
> Note:
> ----
> If a user subsequently attempts to restart the guest or re-attach the mdev,
> the operation will fail with a message indicating the domain is already
> active. This is a libvirt problem resolved with the following commit:
> 
> commit ebd004a03dbd ("security: do not remember/recall labels for VFIO 
> MDEVs") 

For the series: 

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>


I also did some testing using the companion qemu series at
https://lore.kernel.org/qemu-devel/20230530225544.280031-1-akrowiak@linux.ibm.com

Before kernel+qemu changes:
1. mdevctl start -u <uuid>, where <uuid> references a vfio-ap mdev
2. start a qemu guest with <uuid> attached
3. mdvectl stop -u <uuid>
4. -mdevctl will now hang indefinitely; the mdev remains in-use by the guest-
Note: detaching the device or powering off the guest will allow the mdevctl command to complete.

After kernel+qemu changes:
1. mdevctl start -u <uuid>, where <uuid> references a vfio-ap mdev
2. start a qemu guest with <uuid> attached
3. mdvectl stop -u <uuid>
4. -device is detached from the guest and stopped-
5. Using a libvirt that includes ebd004a03dbd I also verified that the mdev can be started again and re-attached to the running guest without error.


> 
> Tony Krowiak (3):
>   vfio: ap: realize the VFIO_DEVICE_GET_IRQ_INFO ioctl
>   vfio: ap: realize the VFIO_DEVICE_SET_IRQS ioctl
>   s390/vfio-ap: Wire in the vfio_device_ops request callback
> 
>  drivers/s390/crypto/vfio_ap_ops.c     | 134 +++++++++++++++++++++++++-
>  drivers/s390/crypto/vfio_ap_private.h |   3 +
>  include/uapi/linux/vfio.h             |   9 ++
>  3 files changed, 145 insertions(+), 1 deletion(-)
> 

