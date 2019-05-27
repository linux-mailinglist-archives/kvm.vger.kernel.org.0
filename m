Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 157832B4B7
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 14:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfE0MPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 08:15:38 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbfE0MPi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 May 2019 08:15:38 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4RCCfxk025950
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 08:15:37 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2srdyde3ey-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 27 May 2019 08:15:36 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Mon, 27 May 2019 13:15:33 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 27 May 2019 13:15:30 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4RCFSUr32309292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 May 2019 12:15:28 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B259A405C;
        Mon, 27 May 2019 12:15:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAEEBA4065;
        Mon, 27 May 2019 12:15:27 +0000 (GMT)
Received: from [9.152.98.56] (unknown [9.152.98.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 27 May 2019 12:15:27 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v2 3/8] s390/cio: add basic protected virtualization
 support
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
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
 <20190523162209.9543-4-mimu@linux.ibm.com>
 <20190527123802.54cd3589.cohuck@redhat.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Mon, 27 May 2019 14:15:27 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190527123802.54cd3589.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19052712-0020-0000-0000-00000340E72A
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052712-0021-0000-0000-00002193DE0B
Message-Id: <6cfd1a67-b600-169e-b0c1-64362c7129f8@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 27.05.19 12:38, Cornelia Huck wrote:
> On Thu, 23 May 2019 18:22:04 +0200
> Michael Mueller <mimu@linux.ibm.com> wrote:
> 
>> From: Halil Pasic <pasic@linux.ibm.com>
>>
>> As virtio-ccw devices are channel devices, we need to use the dma area
>> for any communication with the hypervisor.
>>
>> It handles neither QDIO in the common code, nor any device type specific
>> stuff (like channel programs constructed by the DASD driver).
>>
>> An interesting side effect is that virtio structures are now going to
>> get allocated in 31 bit addressable storage.
>>
>> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> 
> [Side note: you really should add your s-o-b if you send someone else's
> patches... if Halil ends up committing them, it's fine, though.]

My real problem here is that Halil is writing comments and patches after
I have prepared all my changes. ;) And now this contnues...

Michael

> 
>> ---
>>   arch/s390/include/asm/ccwdev.h   |  4 +++
>>   drivers/s390/cio/ccwreq.c        |  9 +++---
>>   drivers/s390/cio/device.c        | 64 +++++++++++++++++++++++++++++++++-------
>>   drivers/s390/cio/device_fsm.c    | 53 ++++++++++++++++++++-------------
>>   drivers/s390/cio/device_id.c     | 20 +++++++------
>>   drivers/s390/cio/device_ops.c    | 21 +++++++++++--
>>   drivers/s390/cio/device_pgid.c   | 22 +++++++-------
>>   drivers/s390/cio/device_status.c | 24 +++++++--------
>>   drivers/s390/cio/io_sch.h        | 20 +++++++++----
>>   drivers/s390/virtio/virtio_ccw.c | 10 -------
>>   10 files changed, 164 insertions(+), 83 deletions(-)
>>
> 
> (...)
> 
>> @@ -1593,20 +1622,31 @@ struct ccw_device * __init ccw_device_create_console(struct ccw_driver *drv)
>>   		return ERR_CAST(sch);
>>   
>>   	io_priv = kzalloc(sizeof(*io_priv), GFP_KERNEL | GFP_DMA);
>> -	if (!io_priv) {
>> -		put_device(&sch->dev);
>> -		return ERR_PTR(-ENOMEM);
>> -	}
>> +	if (!io_priv)
>> +		goto err_priv;
>> +	io_priv->dma_area = dma_alloc_coherent(&sch->dev,
>> +				sizeof(*io_priv->dma_area),
>> +				&io_priv->dma_area_dma, GFP_KERNEL);
> 
> Even though we'll only end up here for 3215 or 3270 consoles, this sent
> me looking.
> 
> This code is invoked via console_init(). A few lines down in
> start_kernel(), we have
> 
>          /*
>           * This needs to be called before any devices perform DMA
>           * operations that might use the SWIOTLB bounce buffers. It will
>           * mark the bounce buffers as decrypted so that their usage will
>           * not cause "plain-text" data to be decrypted when accessed.
>           */
>          mem_encrypt_init();
> 
> So, I'm wondering if creating the console device interacts in any way
> with the memory encryption interface?
> 
> [Does basic recognition work if you start a protected virt guest with a
> 3270 console? I realize that the console is unlikely to work, but that
> should at least exercise this code path.]
> 
>> +	if (!io_priv->dma_area)
>> +		goto err_dma_area;
>>   	set_io_private(sch, io_priv);
>>   	cdev = io_subchannel_create_ccwdev(sch);
>>   	if (IS_ERR(cdev)) {
>>   		put_device(&sch->dev);
>> +		dma_free_coherent(&sch->dev, sizeof(*io_priv->dma_area),
>> +				  io_priv->dma_area, io_priv->dma_area_dma);
>>   		kfree(io_priv);
>>   		return cdev;
>>   	}
>>   	cdev->drv = drv;
>>   	ccw_device_set_int_class(cdev);
>>   	return cdev;
>> +
>> +err_dma_area:
>> +		kfree(io_priv);
>> +err_priv:
>> +	put_device(&sch->dev);
>> +	return ERR_PTR(-ENOMEM);
>>   }
>>   
>>   void __init ccw_device_destroy_console(struct ccw_device *cdev)
> 

