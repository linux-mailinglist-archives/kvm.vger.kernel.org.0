Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9B92DB5E
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 13:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfE2LFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 07:05:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725894AbfE2LFw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 May 2019 07:05:52 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TAvP0i115582
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 07:05:50 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ssrpcgj6w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 07:05:50 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Wed, 29 May 2019 12:05:48 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 29 May 2019 12:05:44 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4TB5gTb41615530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 May 2019 11:05:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7A4FAE057;
        Wed, 29 May 2019 11:05:42 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08137AE053;
        Wed, 29 May 2019 11:05:42 +0000 (GMT)
Received: from [9.152.96.222] (unknown [9.152.96.222])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 May 2019 11:05:41 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v2 6/8] virtio/s390: add indirection to indicators access
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com>
 <20190523162209.9543-7-mimu@linux.ibm.com>
 <20190527130028.62e1f7d7.cohuck@redhat.com>
 <20190527135706.34837062.pasic@linux.ibm.com>
 <20190527141029.102f838a.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Wed, 29 May 2019 13:05:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527141029.102f838a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052911-0012-0000-0000-00000320901F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052911-0013-0000-0000-000021595B35
Message-Id: <08e56ae6-28ed-52ae-62ec-fde786949500@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905290074
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.05.19 14:10, Cornelia Huck wrote:
> On Mon, 27 May 2019 13:57:06 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
>> On Mon, 27 May 2019 13:00:28 +0200
>> Cornelia Huck <cohuck@redhat.com> wrote:
>>
>>> On Thu, 23 May 2019 18:22:07 +0200
>>> Michael Mueller <mimu@linux.ibm.com> wrote:
>>>    
>>>> From: Halil Pasic <pasic@linux.ibm.com>
>>>>
>>>> This will come in handy soon when we pull out the indicators from
>>>> virtio_ccw_device to a memory area that is shared with the hypervisor
>>>> (in particular for protected virtualization guests).
>>>>
>>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>>>> Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
>>>> ---
>>>>   drivers/s390/virtio/virtio_ccw.c | 40 +++++++++++++++++++++++++---------------
>>>>   1 file changed, 25 insertions(+), 15 deletions(-)
>>>>    
>>>    
>>>> @@ -338,17 +348,17 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
>>>>   		ccw->cda = (__u32)(unsigned long) thinint_area;
>>>>   	} else {
>>>>   		/* payload is the address of the indicators */
>>>> -		indicatorp = kmalloc(sizeof(&vcdev->indicators),
>>>> +		indicatorp = kmalloc(sizeof(indicators(vcdev)),
>>>>   				     GFP_DMA | GFP_KERNEL);
>>>>   		if (!indicatorp)
>>>>   			return;
>>>>   		*indicatorp = 0;
>>>>   		ccw->cmd_code = CCW_CMD_SET_IND;
>>>> -		ccw->count = sizeof(&vcdev->indicators);
>>>> +		ccw->count = sizeof(indicators(vcdev));
>>>>   		ccw->cda = (__u32)(unsigned long) indicatorp;
>>>>   	}
>>>>   	/* Deregister indicators from host. */
>>>> -	vcdev->indicators = 0;
>>>> +	*indicators(vcdev) = 0;
>>>
>>> I'm not too hot about this notation, but it's not wrong and a minor
>>> thing :)
>>
>> I don't have any better ideas :/
>>
>>>    
>>>>   	ccw->flags = 0;
>>>>   	ret = ccw_io_helper(vcdev, ccw,
>>>>   			    vcdev->is_thinint ?
>>>
>>> Patch looks reasonable and not dependent on the other patches here.
>>>    
>>
>> looks reasonable == r-b?
>>
>> Not dependent in a sense that this patch could be made a first patch in
>> the series. A subsequent patch depends on it.
> 
> What is the plan with these patches? I can either pick patch 5+6 and
> let them go through the virtio tree, or give my r-b and let them go
> through the s390 tree. The former is probably the quicker route, but
> the latter has less potential for dependency issues.

please give your r-b then for these.

> 

Michael

