Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B14618966
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 14:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEIMBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 08:01:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38196 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726491AbfEIMBT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 May 2019 08:01:19 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49Bq7Pm071118
        for <kvm@vger.kernel.org>; Thu, 9 May 2019 08:01:17 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2schw45p6v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 08:01:16 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 9 May 2019 13:01:08 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 9 May 2019 13:01:05 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x49C13rc25886830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 May 2019 12:01:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5BAC542054;
        Thu,  9 May 2019 12:01:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 029C14203F;
        Thu,  9 May 2019 12:01:02 +0000 (GMT)
Received: from [9.145.47.201] (unknown [9.145.47.201])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 May 2019 12:01:01 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 08/10] virtio/s390: add indirection to indicators access
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-9-pasic@linux.ibm.com>
 <716d47ca-016f-e8f4-6d78-7746a7d9f6ba@linux.ibm.com>
Date:   Thu, 9 May 2019 14:01:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <716d47ca-016f-e8f4-6d78-7746a7d9f6ba@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050912-0016-0000-0000-00000279ECB4
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050912-0017-0000-0000-000032D6A135
Message-Id: <a4bf1976-8037-63bb-2cf6-c389edbd2e89@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/05/2019 16:31, Pierre Morel wrote:
> On 26/04/2019 20:32, Halil Pasic wrote:
>> This will come in handy soon when we pull out the indicators from
>> virtio_ccw_device to a memory area that is shared with the hypervisor
>> (in particular for protected virtualization guests).
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   drivers/s390/virtio/virtio_ccw.c | 40 
>> +++++++++++++++++++++++++---------------
>>   1 file changed, 25 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/s390/virtio/virtio_ccw.c 
>> b/drivers/s390/virtio/virtio_ccw.c
>> index bb7a92316fc8..1f3e7d56924f 100644
>> --- a/drivers/s390/virtio/virtio_ccw.c
>> +++ b/drivers/s390/virtio/virtio_ccw.c
>> @@ -68,6 +68,16 @@ struct virtio_ccw_device {
>>       void *airq_info;
>>   };
>> +static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
>> +{
>> +    return &vcdev->indicators;
>> +}
>> +
>> +static inline unsigned long *indicators2(struct virtio_ccw_device 
>> *vcdev)
>> +{
>> +    return &vcdev->indicators2;
>> +}
>> +
>>   struct vq_info_block_legacy {
>>       __u64 queue;
>>       __u32 align;
>> @@ -337,17 +347,17 @@ static void virtio_ccw_drop_indicator(struct 
>> virtio_ccw_device *vcdev,
>>           ccw->cda = (__u32)(unsigned long) thinint_area;
>>       } else {
>>           /* payload is the address of the indicators */
>> -        indicatorp = kmalloc(sizeof(&vcdev->indicators),
>> +        indicatorp = kmalloc(sizeof(indicators(vcdev)),
>>                        GFP_DMA | GFP_KERNEL);
>>           if (!indicatorp)
>>               return;
>>           *indicatorp = 0;
>>           ccw->cmd_code = CCW_CMD_SET_IND;
>> -        ccw->count = sizeof(&vcdev->indicators);
>> +        ccw->count = sizeof(indicators(vcdev));
> 
> This looks strange to me. Was already weird before.
> Lucky we are indicators are long...
> may be just sizeof(long)


AFAIK the size of the indicators (AIV/AIS) is not restricted by the 
architecture.
However we never use more than 64 bits, do we ever have an adapter 
having more than 64 different interrupts?

May be we can state than we use a maximal number of AISB of 64 and 
therefor use indicators with a size of unsigned long, or __u64 or 
whatever is appropriate. Please clear this.

With this cleared:
Reviewed-by: Pierre Morel<pmorel@linux.ibm.com>


Regards,
Pierre


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

