Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F82719BC7
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjFAMQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 08:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjFAMQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 08:16:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6040AE5B;
        Thu,  1 Jun 2023 05:15:33 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351Bi332000405;
        Thu, 1 Jun 2023 12:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Mlje/RaJdlmD9ePUf3BFJnhwhirMg1nNdyphFJM62R8=;
 b=YtBuJNW1q+7RYiica59ME6cYRZbBEkKfnkCCEhDyU/yXY6/Dac8YUlDJahT60HpTXaCD
 B/mzD52fZXwv7S+eSrMoUbibtshqyHFhY8mC2n8Si82MQDusW4lk/XOljLgR45hjDkVn
 GUfW51Gj5r9UExHyLhCq37l23MlzIK8QnGNNSjGD9f1If57s3ufGB0u1I9ri60qoAk1o
 PBgyinrJ/6Ef/DQ8Wm5BWp4+t5XND94h+Shd7yQZDHJZAcP2hQrmVPzr7s+LQFSZIe8U
 FW/tiTwXDj+sz37enCzZxe5fThKMaO0GdwzCPBmWJ09LBgDy2ycsaEDCnl7x0Y5Fmc0Y JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxtqerx2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:15:32 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351C9JwP031544;
        Thu, 1 Jun 2023 12:15:31 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxtqerx21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:15:31 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 351AV70u016822;
        Thu, 1 Jun 2023 12:15:31 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3qu9g6yf5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 12:15:31 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351CFT9W46006680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 12:15:29 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9E0E5805E;
        Thu,  1 Jun 2023 12:15:28 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F10C58043;
        Thu,  1 Jun 2023 12:15:28 +0000 (GMT)
Received: from [9.61.88.233] (unknown [9.61.88.233])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 12:15:28 +0000 (GMT)
Message-ID: <17cf1288-03c5-4143-c62b-9234ed9c4d9a@linux.ibm.com>
Date:   Thu, 1 Jun 2023 08:15:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/3] s390/vfio-ap: fix hang when mdev attached to guest is
 removed
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, alex.williamson@redhat.com
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
 <9837da27-e224-aded-fe3e-4f4db6b1599c@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <9837da27-e224-aded-fe3e-4f4db6b1599c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TezVMj9sko83d63D3C8eAoqm9aFBu3l8
X-Proofpoint-ORIG-GUID: K3fMyt5eZNMG7j-xWpFuz07VIipQ4NVX
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010107
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/31/23 10:48 AM, Matthew Rosato wrote:
> On 5/30/23 6:35 PM, Tony Krowiak wrote:
>> When a user attempts to remove a vfio-ap mediated device attached to a
>> guest, the operation hangs until the mdev's fd is closed by the guest
>> (i.e., the hostdev is detached or the guest is shut down). This patch
>> series provides kernel-side code that allows userspace to set up a
>> communication channel that will allow the vfio_ap device driver to notify
>> userspace when a request to release the mdev is received, so that userspace
>> can close the mdev fd and avoid the hang. The patch series provides the
>> following:
>>
>> 1. Introduces code to handle the VFIO_DEVICE_GET_IRQ_INFO and
>>     VFIO_DEVICE_SET_IRQS ioctl calls to set the eventfd_ctx for signaling a
>>     device request to userspace.
>>
>> 2. Wires up the VFIO bus driver callback to request a release of the mdev.
>>     When invoked, the vfio_ap device driver will use the eventfd_ctx set up
>>     in #1 to signal a request to userspace to release the mdev.
>>
>>
>> Note:
>> ----
>> If a user subsequently attempts to restart the guest or re-attach the mdev,
>> the operation will fail with a message indicating the domain is already
>> active. This is a libvirt problem resolved with the following commit:
>>
>> commit ebd004a03dbd ("security: do not remember/recall labels for VFIO
>> MDEVs")
> 
> For the series:
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Thanks for the review.

> 
> 
> I also did some testing using the companion qemu series at
> https://lore.kernel.org/qemu-devel/20230530225544.280031-1-akrowiak@linux.ibm.com

Shall I credit you with Tested-by also?

> 
> Before kernel+qemu changes:
> 1. mdevctl start -u <uuid>, where <uuid> references a vfio-ap mdev
> 2. start a qemu guest with <uuid> attached
> 3. mdvectl stop -u <uuid>
> 4. -mdevctl will now hang indefinitely; the mdev remains in-use by the guest-
> Note: detaching the device or powering off the guest will allow the mdevctl command to complete.
> 
> After kernel+qemu changes:
> 1. mdevctl start -u <uuid>, where <uuid> references a vfio-ap mdev
> 2. start a qemu guest with <uuid> attached
> 3. mdvectl stop -u <uuid>
> 4. -device is detached from the guest and stopped-
> 5. Using a libvirt that includes ebd004a03dbd I also verified that the mdev can be started again and re-attached to the running guest without error.
> 
> 
>>
>> Tony Krowiak (3):
>>    vfio: ap: realize the VFIO_DEVICE_GET_IRQ_INFO ioctl
>>    vfio: ap: realize the VFIO_DEVICE_SET_IRQS ioctl
>>    s390/vfio-ap: Wire in the vfio_device_ops request callback
>>
>>   drivers/s390/crypto/vfio_ap_ops.c     | 134 +++++++++++++++++++++++++-
>>   drivers/s390/crypto/vfio_ap_private.h |   3 +
>>   include/uapi/linux/vfio.h             |   9 ++
>>   3 files changed, 145 insertions(+), 1 deletion(-)
>>
> 
