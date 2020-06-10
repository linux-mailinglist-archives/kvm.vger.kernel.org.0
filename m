Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9C41F57CA
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 17:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbgFJP1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 11:27:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1578 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726979AbgFJP1K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Jun 2020 11:27:10 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05AF2gsf099987;
        Wed, 10 Jun 2020 11:27:08 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31k02b592u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 11:27:08 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05AFNV0K053784;
        Wed, 10 Jun 2020 11:27:08 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31k02b591n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 11:27:07 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05AFLhcv021634;
        Wed, 10 Jun 2020 15:27:05 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 31g2s7u905-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Jun 2020 15:27:05 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05AFR2pk44171334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jun 2020 15:27:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8BC6152050;
        Wed, 10 Jun 2020 15:27:02 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.158.19])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1A9C15204E;
        Wed, 10 Jun 2020 15:27:02 +0000 (GMT)
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
 <20200610152431.358fded7.cohuck@redhat.com>
 <54b28498-a6a7-4be2-9d2c-aef46c7fc642@linux.ibm.com>
 <20200610165305.1a34c548.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <8b15139d-cd38-0861-1510-9a53530a4637@linux.ibm.com>
Date:   Wed, 10 Jun 2020 17:27:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200610165305.1a34c548.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-10_08:2020-06-10,2020-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 adultscore=0 priorityscore=1501 impostorscore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=999 suspectscore=2 bulkscore=0
 cotscore=-2147483648 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006100115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-10 16:53, Cornelia Huck wrote:
> On Wed, 10 Jun 2020 16:37:55 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2020-06-10 15:24, Cornelia Huck wrote:
>>> On Wed, 10 Jun 2020 15:11:51 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>> Protected Virtualisation protects the memory of the guest and
>>>> do not allow a the host to access all of its memory.
>>>>
>>>> Let's refuse a VIRTIO device which does not use IOMMU
>>>> protected access.
>>>>
>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/virtio/virtio_ccw.c | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
>>>> index 5730572b52cd..06ffbc96587a 100644
>>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>>> @@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
>>>>    	if (!ccw)
>>>>    		return;
>>>>    
>>>> +	/* Protected Virtualisation guest needs IOMMU */
>>>> +	if (is_prot_virt_guest() &&
>>>> +	    !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
>>>> +			status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
>>>> +
>>>
>>> set_status seems like an odd place to look at features; shouldn't that
>>> rather be done in finalize_features?
>>
>> Right, looks better to me too.
>> What about:
>>
>>
>>
>> diff --git a/drivers/s390/virtio/virtio_ccw.c
>> b/drivers/s390/virtio/virtio_ccw.c
>> index 06ffbc96587a..227676297ea0 100644
>> --- a/drivers/s390/virtio/virtio_ccw.c
>> +++ b/drivers/s390/virtio/virtio_ccw.c
>> @@ -833,6 +833,11 @@ static int virtio_ccw_finalize_features(struct
>> virtio_device *vdev)
>>                   ret = -ENOMEM;
>>                   goto out_free;
>>           }
>> +
>> +       if (is_prot_virt_guest() &&
>> +           !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
> 
> Add a comment, and (maybe) a message?
> 
> Otherwise, I think this is fine, as it should fail the probe, which is
> what we want.

yes right a message is needed.
and I extend a little the comment I had before.
thanks

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
