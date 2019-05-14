Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048BE1CAB3
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 16:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfENOrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 10:47:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725901AbfENOrm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 10:47:42 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4EEkoLN179804
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 10:47:41 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sfyqw818a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 10:47:41 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <jjherne@linux.ibm.com>;
        Tue, 14 May 2019 15:47:40 +0100
Received: from b01cxnp22034.gho.pok.ibm.com (9.57.198.24)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 May 2019 15:47:37 +0100
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4EElYmh11927646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 14:47:34 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86A0B28060;
        Tue, 14 May 2019 14:47:34 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3856828058;
        Tue, 14 May 2019 14:47:34 +0000 (GMT)
Received: from [9.60.75.213] (unknown [9.60.75.213])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 May 2019 14:47:34 +0000 (GMT)
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH 06/10] s390/cio: add basic protected virtualization
 support
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
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
 <20190426183245.37939-7-pasic@linux.ibm.com>
 <20190513114136.783c851c.cohuck@redhat.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
Date:   Tue, 14 May 2019 10:47:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190513114136.783c851c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051414-2213-0000-0000-0000038D9A3A
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011096; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01203230; UDB=6.00631560; IPR=6.00984152;
 MB=3.00026883; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-14 14:47:39
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051414-2214-0000-0000-00005E6E8108
Message-Id: <d0ffefec-a14e-ee83-0aae-df288c3ffda4@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/19 5:41 AM, Cornelia Huck wrote:
> On Fri, 26 Apr 2019 20:32:41 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
>> As virtio-ccw devices are channel devices, we need to use the dma area
>> for any communication with the hypervisor.
>>
>> This patch addresses the most basic stuff (mostly what is required for
>> virtio-ccw), and does take care of QDIO or any devices.
> 
> "does not take care of QDIO", surely? (Also, what does "any devices"
> mean? Do you mean "every arbitrary device", perhaps?)
> 
>>
>> An interesting side effect is that virtio structures are now going to
>> get allocated in 31 bit addressable storage.
> 
> Hm...
> 
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/ccwdev.h   |  4 +++
>>   drivers/s390/cio/ccwreq.c        |  8 ++---
>>   drivers/s390/cio/device.c        | 65 +++++++++++++++++++++++++++++++++-------
>>   drivers/s390/cio/device_fsm.c    | 40 ++++++++++++-------------
>>   drivers/s390/cio/device_id.c     | 18 +++++------
>>   drivers/s390/cio/device_ops.c    | 21 +++++++++++--
>>   drivers/s390/cio/device_pgid.c   | 20 ++++++-------
>>   drivers/s390/cio/device_status.c | 24 +++++++--------
>>   drivers/s390/cio/io_sch.h        | 21 +++++++++----
>>   drivers/s390/virtio/virtio_ccw.c | 10 -------
>>   10 files changed, 148 insertions(+), 83 deletions(-)
> 
> (...)
> 
>> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
>> index 6d989c360f38..bb7a92316fc8 100644
>> --- a/drivers/s390/virtio/virtio_ccw.c
>> +++ b/drivers/s390/virtio/virtio_ccw.c
>> @@ -66,7 +66,6 @@ struct virtio_ccw_device {
>>   	bool device_lost;
>>   	unsigned int config_ready;
>>   	void *airq_info;
>> -	u64 dma_mask;
>>   };
>>   
>>   struct vq_info_block_legacy {
>> @@ -1255,16 +1254,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
>>   		ret = -ENOMEM;
>>   		goto out_free;
>>   	}
>> -
>>   	vcdev->vdev.dev.parent = &cdev->dev;
>> -	cdev->dev.dma_mask = &vcdev->dma_mask;
>> -	/* we are fine with common virtio infrastructure using 64 bit DMA */
>> -	ret = dma_set_mask_and_coherent(&cdev->dev, DMA_BIT_MASK(64));
>> -	if (ret) {
>> -		dev_warn(&cdev->dev, "Failed to enable 64-bit DMA.\n");
>> -		goto out_free;
>> -	}
> 
> This means that vring structures now need to fit into 31 bits as well,
> I think? Is there any way to reserve the 31 bit restriction for channel
> subsystem structures and keep vring in the full 64 bit range? (Or am I
> fundamentally misunderstanding something?)
> 

I hope I've understood everything... I'm new to virtio. But from what I'm understanding, 
the vring structure (a.k.a. the VirtQueue) needs to be accessed and modified by both host 
and guest. Therefore the page(s) holding that data need to be marked shared if using 
protected virtualization. This patch set makes use of DMA pages by way of swiotlb (always 
below 32-bit line right?) for shared memory. Therefore, a side effect is that all shared 
memory, including VirtQueue data will be in the DMA zone and in 32-bit memory.

I don't see any restrictions on sharing pages above the 32-bit line. So it seems possible. 
I'm not sure how much more work it would be. I wonder if Halil has considered this? Are we 
worried that virtio data structures are going to be a burden on the 31-bit address space?


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)

