Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2296F1B5D3
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 14:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfEMM1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 08:27:44 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36176 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727414AbfEMM1o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 May 2019 08:27:44 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4DCQZSD090474
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 08:27:43 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sf8k4r169-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 08:27:42 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 13 May 2019 13:27:40 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 13 May 2019 13:27:38 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4DCRbND20316262
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 12:27:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3B764C044;
        Mon, 13 May 2019 12:27:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C03E4C04A;
        Mon, 13 May 2019 12:27:36 +0000 (GMT)
Received: from [9.152.97.147] (unknown [9.152.97.147])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 13 May 2019 12:27:36 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH 01/10] virtio/s390: use vring_create_virtqueue
To:     Cornelia Huck <cohuck@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
 <20190426183245.37939-2-pasic@linux.ibm.com>
 <20190503111724.70c6ec37.cohuck@redhat.com>
 <20190503160421-mutt-send-email-mst@kernel.org>
 <20190504160340.29f17b98.pasic@linux.ibm.com>
 <20190505131523.159bec7c.cohuck@redhat.com>
 <ed6cbf63-f2ff-f259-ccb0-3b9ba60f2b35@de.ibm.com>
 <20190510160744.00285367.cohuck@redhat.com>
 <20190512124730-mutt-send-email-mst@kernel.org>
 <20190513115227.1d316ec8.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 13 May 2019 14:27:35 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513115227.1d316ec8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051312-0008-0000-0000-000002E61C43
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051312-0009-0000-0000-00002252B0D5
Message-Id: <f2e52c29-ed4e-cf49-0fbf-e3bac97124e9@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-13_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905130088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.05.19 11:52, Cornelia Huck wrote:
> On Sun, 12 May 2019 12:47:39 -0400
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
>> On Fri, May 10, 2019 at 04:07:44PM +0200, Cornelia Huck wrote:
>>> On Tue, 7 May 2019 15:58:12 +0200
>>> Christian Borntraeger <borntraeger@de.ibm.com> wrote:
>>>    
>>>> On 05.05.19 13:15, Cornelia Huck wrote:
>>>>> On Sat, 4 May 2019 16:03:40 +0200
>>>>> Halil Pasic <pasic@linux.ibm.com> wrote:
>>>>>      
>>>>>> On Fri, 3 May 2019 16:04:48 -0400
>>>>>> "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>>>>>     
>>>>>>> On Fri, May 03, 2019 at 11:17:24AM +0200, Cornelia Huck wrote:
>>>>>>>> On Fri, 26 Apr 2019 20:32:36 +0200
>>>>>>>> Halil Pasic <pasic@linux.ibm.com> wrote:
>>>>>>>>        
>>>>>>>>> The commit 2a2d1382fe9d ("virtio: Add improved queue allocation API")
>>>>>>>>> establishes a new way of allocating virtqueues (as a part of the effort
>>>>>>>>> that taught DMA to virtio rings).
>>>>>>>>>
>>>>>>>>> In the future we will want virtio-ccw to use the DMA API as well.
>>>>>>>>>
>>>>>>>>> Let us switch from the legacy method of allocating virtqueues to
>>>>>>>>> vring_create_virtqueue() as the first step into that direction.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>>>>>>>>> ---
>>>>>>>>>   drivers/s390/virtio/virtio_ccw.c | 30 +++++++++++-------------------
>>>>>>>>>   1 file changed, 11 insertions(+), 19 deletions(-)
>>>>>>>>
>>>>>>>> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
>>>>>>>>
>>>>>>>> I'd vote for merging this patch right away for 5.2.
>>>>>>>
>>>>>>> So which tree is this going through? mine?
>>>>>>>        
>>>>>>
>>>>>> Christian, what do you think? If the whole series is supposed to go in
>>>>>> in one go (which I hope it is), via Martin's tree could be the simplest
>>>>>> route IMHO.
>>>>>
>>>>>
>>>>> The first three patches are virtio(-ccw) only and the those are the ones
>>>>> that I think are ready to go.
>>>>>
>>>>> I'm not feeling comfortable going forward with the remainder as it
>>>>> stands now; waiting for some other folks to give feedback. (They are
>>>>> touching/interacting with code parts I'm not so familiar with, and lack
>>>>> of documentation, while not the developers' fault, does not make it
>>>>> easier.)
>>>>>
>>>>> Michael, would you like to pick up 1-3 for your tree directly? That
>>>>> looks like the easiest way.
>>>>
>>>> Agreed. Michael please pick 1-3.
>>>> We will continue to review 4- first and then see which tree is best.
>>>
>>> Michael, please let me know if you'll pick directly or whether I should
>>> post a series.
>>>
>>> [Given that the patches are from one virtio-ccw maintainer and reviewed
>>> by the other, picking directly would eliminate an unnecessary
>>> indirection :)]
>>
>> picked them
> 
> Thanks!
> 

Connie,

if I get you right here, you don't need a v2 for the
patches 1 through 3?

Thanks,
Michael

