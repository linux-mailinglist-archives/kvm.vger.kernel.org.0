Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88D61F959A
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 13:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgFOLvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 07:51:05 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39498 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729682AbgFOLvF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 07:51:05 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05FA2gg4102076;
        Mon, 15 Jun 2020 07:51:03 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31p5erdtkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 07:51:03 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05FA3w3T107339;
        Mon, 15 Jun 2020 07:51:02 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31p5erdtjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 07:51:02 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05FBjY22032443;
        Mon, 15 Jun 2020 11:51:00 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 31mpe7ufaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 11:51:00 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05FBovbF56033282
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 11:50:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8141AAE05A;
        Mon, 15 Jun 2020 11:50:57 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 07EE8AE045;
        Mon, 15 Jun 2020 11:50:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.1.141])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 15 Jun 2020 11:50:56 +0000 (GMT)
Subject: Re: [PATCH] s390: protvirt: virtio: Refuse device without IOMMU
To:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org
Cc:     pasic@linux.ibm.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        mst@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <1591794711-5915-1-git-send-email-pmorel@linux.ibm.com>
 <467d5b58-b70c-1c45-4130-76b6e18c05af@redhat.com>
 <f7eb1154-0f52-0f12-129f-2b511f5a4685@linux.ibm.com>
 <6356ba7f-afab-75e1-05ff-4a22b88c610e@linux.ibm.com>
 <a02b9f94-eb48-4ae2-0ade-a4ce26b61ad8@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <52cde80c-f33a-dbb7-d0b0-2733b3eb85c3@linux.ibm.com>
Date:   Mon, 15 Jun 2020 13:50:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a02b9f94-eb48-4ae2-0ade-a4ce26b61ad8@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_02:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 cotscore=-2147483648 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006150082
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-06-15 05:01, Jason Wang wrote:
> 
> On 2020/6/12 下午7:38, Pierre Morel wrote:
>>
>>
>> On 2020-06-12 11:21, Pierre Morel wrote:
>>>
>>>
>>> On 2020-06-11 05:10, Jason Wang wrote:
>>>>
>>>> On 2020/6/10 下午9:11, Pierre Morel wrote:
>>>>> Protected Virtualisation protects the memory of the guest and
>>>>> do not allow a the host to access all of its memory.
>>>>>
>>>>> Let's refuse a VIRTIO device which does not use IOMMU
>>>>> protected access.
>>>>>
>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>> ---
>>>>>   drivers/s390/virtio/virtio_ccw.c | 5 +++++
>>>>>   1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/drivers/s390/virtio/virtio_ccw.c 
>>>>> b/drivers/s390/virtio/virtio_ccw.c
>>>>> index 5730572b52cd..06ffbc96587a 100644
>>>>> --- a/drivers/s390/virtio/virtio_ccw.c
>>>>> +++ b/drivers/s390/virtio/virtio_ccw.c
>>>>> @@ -986,6 +986,11 @@ static void virtio_ccw_set_status(struct 
>>>>> virtio_device *vdev, u8 status)
>>>>>       if (!ccw)
>>>>>           return;
>>>>> +    /* Protected Virtualisation guest needs IOMMU */
>>>>> +    if (is_prot_virt_guest() &&
>>>>> +        !__virtio_test_bit(vdev, VIRTIO_F_IOMMU_PLATFORM))
>>>>> +            status &= ~VIRTIO_CONFIG_S_FEATURES_OK;
>>>>> +
>>>>>       /* Write the status to the host. */
>>>>>       vcdev->dma_area->status = status;
>>>>>       ccw->cmd_code = CCW_CMD_WRITE_STATUS;
>>>>
>>>>
>>>> I wonder whether we need move it to virtio core instead of ccw.
>>>>
>>>> I think the other memory protection technologies may suffer from 
>>>> this as well.
>>>>
>>>> Thanks
>>>>
>>>
>>>
>>> What would you think of the following, also taking into account 
>>> Connie's comment on where the test should be done:
>>>
>>> - declare a weak function in virtio.c code, returning that memory 
>>> protection is not in use.
>>>
>>> - overwrite the function in the arch code
>>>
>>> - call this function inside core virtio_finalize_features() and if 
>>> required fail if the device don't have VIRTIO_F_IOMMU_PLATFORM.
> 
> 
> I think this is fine.
> 

Thanks,
I try this.

Regards,
Pierre




-- 
Pierre Morel
IBM Lab Boeblingen
