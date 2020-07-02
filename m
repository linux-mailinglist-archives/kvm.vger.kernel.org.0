Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB0D212418
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgGBNFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:05:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726343AbgGBNFc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Jul 2020 09:05:32 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062D51uS049499;
        Thu, 2 Jul 2020 09:05:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3212atdq6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 09:05:25 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 062D5Orp052085;
        Thu, 2 Jul 2020 09:05:24 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3212atdpfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 09:05:21 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 062Cso7p024179;
        Thu, 2 Jul 2020 13:03:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 31wyyaun24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 13:03:55 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 062D3q0N58196058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jul 2020 13:03:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C053511C052;
        Thu,  2 Jul 2020 13:03:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F257411C04C;
        Thu,  2 Jul 2020 13:03:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.146.43])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jul 2020 13:03:51 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
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
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <26ecd4c6-837b-1ce6-170b-a0155e4dd4d4@linux.ibm.com>
Date:   Thu, 2 Jul 2020 15:03:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629180526.41d0732b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_08:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 mlxlogscore=881 suspectscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007020094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-29 18:05, Cornelia Huck wrote:
> On Mon, 29 Jun 2020 11:57:14 -0400
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
>> On Wed, Jun 17, 2020 at 12:43:57PM +0200, Pierre Morel wrote:
>>> An architecture protecting the guest memory against unauthorized host
>>> access may want to enforce VIRTIO I/O device protection through the
>>> use of VIRTIO_F_IOMMU_PLATFORM.
>>>
>>> Let's give a chance to the architecture to accept or not devices
>>> without VIRTIO_F_IOMMU_PLATFORM.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>> ---
>>>   arch/s390/mm/init.c     |  6 ++++++
>>>   drivers/virtio/virtio.c | 22 ++++++++++++++++++++++
>>>   include/linux/virtio.h  |  2 ++
>>>   3 files changed, 30 insertions(+)
> 
>>> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct virtio_device *dev)
>>>   	if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>>>   		return 0;
>>>   
>>> +	if (arch_needs_virtio_iommu_platform(dev) &&
>>> +		!virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>>> +		dev_warn(&dev->dev,
>>> +			 "virtio: device must provide VIRTIO_F_IOMMU_PLATFORM\n");
>>> +		return -ENODEV;
>>> +	}
>>> +
>>>   	virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>>>   	status = dev->config->get_status(dev);
>>>   	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>
>> Well don't you need to check it *before* VIRTIO_F_VERSION_1, not after?
> 
> But it's only available with VERSION_1 anyway, isn't it? So it probably
> also needs to fail when this feature is needed if VERSION_1 has not been
> negotiated, I think.
> 

Yes, clearly, I will add this.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
