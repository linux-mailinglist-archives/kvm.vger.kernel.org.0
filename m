Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E95A2158AA
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgGFNht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 09:37:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18842 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729125AbgGFNht (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 09:37:49 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066DWac6149203;
        Mon, 6 Jul 2020 09:37:44 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322nx5m4ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 09:37:43 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 066DWhRl149913;
        Mon, 6 Jul 2020 09:37:43 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322nx5m4d9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 09:37:43 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066Daptr027619;
        Mon, 6 Jul 2020 13:37:40 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 322h1h2b6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 13:37:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066DbclL43384854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 13:37:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CDEA5204E;
        Mon,  6 Jul 2020 13:37:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.49.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4B97452052;
        Mon,  6 Jul 2020 13:37:37 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, jasowang@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
 <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
 <20200629115651-mutt-send-email-mst@kernel.org>
 <20200629180526.41d0732b.cohuck@redhat.com>
 <26ecd4c6-837b-1ce6-170b-a0155e4dd4d4@linux.ibm.com>
Message-ID: <a677decc-5be3-8095-bc33-0f95634011f6@linux.ibm.com>
Date:   Mon, 6 Jul 2020 15:37:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <26ecd4c6-837b-1ce6-170b-a0155e4dd4d4@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_11:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=957 lowpriorityscore=0
 mlxscore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007060104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-02 15:03, Pierre Morel wrote:
> 
> 
> On 2020-06-29 18:05, Cornelia Huck wrote:
>> On Mon, 29 Jun 2020 11:57:14 -0400
>> "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>
>>> On Wed, Jun 17, 2020 at 12:43:57PM +0200, Pierre Morel wrote:
>>>> An architecture protecting the guest memory against unauthorized host
>>>> access may want to enforce VIRTIO I/O device protection through the
>>>> use of VIRTIO_F_IOMMU_PLATFORM.
>>>>
>>>> Let's give a chance to the architecture to accept or not devices
>>>> without VIRTIO_F_IOMMU_PLATFORM.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> ---
>>>>   arch/s390/mm/init.c     |  6 ++++++
>>>>   drivers/virtio/virtio.c | 22 ++++++++++++++++++++++
>>>>   include/linux/virtio.h  |  2 ++
>>>>   3 files changed, 30 insertions(+)
>>
>>>> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct 
>>>> virtio_device *dev)
>>>>       if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>>>>           return 0;
>>>> +    if (arch_needs_virtio_iommu_platform(dev) &&
>>>> +        !virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>>>> +        dev_warn(&dev->dev,
>>>> +             "virtio: device must provide VIRTIO_F_IOMMU_PLATFORM\n");
>>>> +        return -ENODEV;
>>>> +    }
>>>> +
>>>>       virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>>>>       status = dev->config->get_status(dev);
>>>>       if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>
>>> Well don't you need to check it *before* VIRTIO_F_VERSION_1, not after?
>>
>> But it's only available with VERSION_1 anyway, isn't it? So it probably
>> also needs to fail when this feature is needed if VERSION_1 has not been
>> negotiated, I think.


would be something like:

-       if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
-               return 0;
+       if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
+               ret = arch_accept_virtio_features(dev);
+               if (ret)
+                       dev_warn(&dev->dev,
+                                "virtio: device must provide 
VIRTIO_F_VERSION_1\n");
+               return ret;
+       }


just a thought on the function name:
It becomes more general than just IOMMU_PLATFORM related.

What do you think of:

arch_accept_virtio_features()

?

Regards,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
