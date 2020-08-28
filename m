Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2404255D83
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgH1PKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 11:10:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60622 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726321AbgH1PKt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 11:10:49 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07SF2buJ051711;
        Fri, 28 Aug 2020 11:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3eWNwJ8Wf00T2lz4qt2Y64JTbxe4wIQ4V+HqrirF7o0=;
 b=Kdwrpox8RZyZLjPsNBQesttHtL561tqh77XdQBROZhEVW7Org3nf5YAUddwcQTx9jw8o
 H6E6C/CTXLnTu4DFZXizBHFHtdwFQbuDVr4RC2vurylXCr5Im/+G0SJxTopCW5u5lgTJ
 P1C6FDMRJWW6If0slJO9Lzrbj/6ftYFzCG7/XZSRHZYUq357vAjkZLAdBYtF2WIwwTxT
 P/3ru8x0k5Z9ZNhPK6ky3AMPM832CKvZUK+ifJ9a3IXtRgSSn1VGsMhm4CDVNJNikKwI
 YO/aJbAHbhgTkoe/VpDQ/3UhhbtzesNAPNjRGn3lVosJR8cPw/Z4Khoq12hRduUucHmu rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3372fykrue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 11:10:47 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07SF2fJZ051904;
        Fri, 28 Aug 2020 11:10:46 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3372fykrte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 11:10:46 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07SF2cfP019974;
        Fri, 28 Aug 2020 15:10:45 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03wdc.us.ibm.com with ESMTP id 332utrjrmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Aug 2020 15:10:45 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07SFAgd956819982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Aug 2020 15:10:42 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E3BA7805C;
        Fri, 28 Aug 2020 15:10:42 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C013778067;
        Fri, 28 Aug 2020 15:10:40 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.170.64])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Aug 2020 15:10:40 +0000 (GMT)
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-3-akrowiak@linux.ibm.com>
 <20200825121334.0ff35d7a.cohuck@redhat.com>
 <b1c6bad8-3ec6-183c-3e35-9962e9c721c7@linux.ibm.com>
 <20200828101357.2ccbc39a.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <d4faf910-ea86-bcda-13e1-544243477568@linux.ibm.com>
Date:   Fri, 28 Aug 2020 11:10:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200828101357.2ccbc39a.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_08:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 suspectscore=3 priorityscore=1501 malwarescore=0
 mlxlogscore=915 impostorscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/28/20 4:13 AM, Cornelia Huck wrote:
> On Thu, 27 Aug 2020 10:24:07 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 8/25/20 6:13 AM, Cornelia Huck wrote:
>>> On Fri, 21 Aug 2020 15:56:02 -0400
>>> Tony Krowiak<akrowiak@linux.ibm.com>  wrote:
>>>>    /**
>>>> - * vfio_ap_get_queue: Retrieve a queue with a specific APQN from a list
>>>> - * @matrix_mdev: the associated mediated matrix
>>>> + * vfio_ap_get_queue: Retrieve a queue with a specific APQN.
>>>>     * @apqn: The queue APQN
>>>>     *
>>>> - * Retrieve a queue with a specific APQN from the list of the
>>>> - * devices of the vfio_ap_drv.
>>>> - * Verify that the APID and the APQI are set in the matrix.
>>>> + * Retrieve a queue with a specific APQN from the AP queue devices attached to
>>>> + * the AP bus.
>>>>     *
>>>> - * Returns the pointer to the associated vfio_ap_queue
>>>> + * Returns the pointer to the vfio_ap_queue with the specified APQN, or NULL.
>>>>     */
>>>> -static struct vfio_ap_queue *vfio_ap_get_queue(
>>>> -					struct ap_matrix_mdev *matrix_mdev,
>>>> -					int apqn)
>>>> +static struct vfio_ap_queue *vfio_ap_get_queue(unsigned long apqn)
>>>>    {
>>>> +	struct ap_queue *queue;
>>>>    	struct vfio_ap_queue *q;
>>>> -	struct device *dev;
>>>>    
>>>> -	if (!test_bit_inv(AP_QID_CARD(apqn), matrix_mdev->matrix.apm))
>>>> -		return NULL;
>>>> -	if (!test_bit_inv(AP_QID_QUEUE(apqn), matrix_mdev->matrix.aqm))
>>> I think you should add some explanation to the patch description why
>>> testing the matrix bitmasks is not needed anymore.
>> As a result of this comment, I took a closer look at the code to
>> determine the reason for eliminating the matrix_mdev
>> parameter. The reason is because the code below (i.e., find the device
>> and get the driver data) was also repeated in the vfio_ap_irq_disable_apqn()
>> function, so I replaced it with a call to the function above; however, the
>> vfio_ap_irq_disable_apqn() function  does not have a reference to the
>> matrix_mdev, so I eliminated the matrix_mdev parameter. Note that the
>> vfio_ap_irq_disable_apqn() is called for each APQN assigned to a matrix
>> mdev, so there is no need to test the bitmasks there.
>>
>> The other place from which the function above is called is
>> the handle_pqap() function which does have a reference to the
>> matrix_mdev. In order to ensure the integrity of the instruction
>> being intercepted - i.e., PQAP(AQIC) enable/disable IRQ for aN
>> AP queue - the testing of the matrix bitmasks probably ought to
>> be performed, so it will be done there instead of in the
>> vfio_ap_get_queue() function above.
> Should you add a comment that vfio_ap_get_queue() assumes that the
> caller makes sure that this is only called for APQNs that are assigned
> to a matrix?

I suppose it wouldn't hurt.

>
>>
>>> +	queue = ap_get_qdev(apqn);
>>> +	if (!queue)
>>>    		return NULL;
>>>    
>>> -	dev = driver_find_device(&matrix_dev->vfio_ap_drv->driver, NULL,
>>> -				 &apqn, match_apqn);
>>> -	if (!dev)
>>> -		return NULL;
>>> -	q = dev_get_drvdata(dev);
>>> -	q->matrix_mdev = matrix_mdev;
>>> -	put_device(dev);
>>> +	q = dev_get_drvdata(&queue->ap_dev.device);
>>> +	put_device(&queue->ap_dev.device);
>>>    
>>>    	return q;
>>>    }
>>> (...)
>>>   

