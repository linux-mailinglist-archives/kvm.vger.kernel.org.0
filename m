Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032D3447F86
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhKHMjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:39:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54950 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237481AbhKHMjK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:39:10 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CMKPS029119
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hP4LTI10injJDak9lhqWUQZYdgomdQ6buRRZNygQvZE=;
 b=D4BV3bCstVC3j2tHVgItScfiQoUie2KxoBFQgUkFF3a3bkAs+aYIU2/N86SVA/Cwx741
 RgtRk9eCbTvKXVVUaMvRN5W/0iPw71lGg+yimNILK8SjNxBvJp4wA1XmgwpwghqtiBB7
 e1ShJA9UjmqLpH1AAHwYz/O+aK1SZP06NkPxkFmyPbdcz9OehtO5YJq/9hmxGzy/XZ5D
 V5/TRoECqMH3MwrQXN6W/aio6nlDT5OdEBUxcdTCG3pcMnWWdDVtZYhS4mGCZYijRI67
 5eeUJ4z0xanYrYnp+8ogrlkQPPQTWPYZQRAnc8l3t3Tu0Fyf283NQYMfRhVM+CSEhzR4 JA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c66u16q2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:36:25 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8BrKlX018686
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:36:25 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3c66u16q24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:36:25 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CK9tD027803;
        Mon, 8 Nov 2021 12:36:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3c5hb9ms86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:36:23 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CaJev38928874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:36:20 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1F774207A;
        Mon,  8 Nov 2021 12:36:19 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA64F42045;
        Mon,  8 Nov 2021 12:36:18 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:36:18 +0000 (GMT)
Message-ID: <5c073705-b6ca-e64d-31fa-1bd5aaedb45c@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:36:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 5/7] virtio: implement the virtio_add_inbuf
 routine
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-6-git-send-email-pmorel@linux.ibm.com>
 <20211103075131.xgnysvcfbal2r6z4@gator.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211103075131.xgnysvcfbal2r6z4@gator.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wORYH-NB8O_UPV3dk1dvUMjhMYPdKJpn
X-Proofpoint-ORIG-GUID: dAP8vgdgn7Ttmso6uapaI-K0EVuEtOMV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_03,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111080079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 08:51, Andrew Jones wrote:
> On Fri, Aug 27, 2021 at 12:17:18PM +0200, Pierre Morel wrote:
>> To communicate in both directions with a VIRTIO device we need
>> to add the incoming communication to the VIRTIO level.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/virtio.c | 32 ++++++++++++++++++++++++++++++++
>>   lib/virtio.h |  2 ++
>>   2 files changed, 34 insertions(+)
>>
>> diff --git a/lib/virtio.c b/lib/virtio.c
>> index e10153b9..b84bc680 100644
>> --- a/lib/virtio.c
>> +++ b/lib/virtio.c
>> @@ -47,6 +47,38 @@ void vring_init_virtqueue(struct vring_virtqueue *vq, unsigned index,
>>   	vq->data[i] = NULL;
>>   }
>>   
>> +int virtqueue_add_inbuf(struct virtqueue *_vq, char *buf, unsigned int len)
>> +{
>> +	struct vring_virtqueue *vq = to_vvq(_vq);
>> +	unsigned int avail;
>> +	int head;
>> +
>> +	assert(buf);
>> +	assert(len);
>> +
>> +	if (!vq->vq.num_free)
>> +		return -1;
>> +
>> +	--vq->vq.num_free;
>> +
>> +	head = vq->free_head;
>> +
>> +	vq->vring.desc[head].flags = 0;
>> +	vq->vring.desc[head].addr = virt_to_phys(buf);
>> +	vq->vring.desc[head].len = len;
>> +
>> +	vq->free_head = vq->vring.desc[head].next;
>> +
>> +	vq->data[head] = buf;
>> +
>> +	avail = (vq->vring.avail->idx & (vq->vring.num - 1));
>> +	vq->vring.avail->ring[avail] = head;
>> +	wmb();	/* be sure to update the ring before updating the idx */
>> +	vq->vring.avail->idx++;
>> +	vq->num_added++;
>> +
>> +	return 0;
>> +}
>>   int virtqueue_add_outbuf(struct virtqueue *_vq, char *buf, unsigned int len)
>>   {
>>   	struct vring_virtqueue *vq = to_vvq(_vq);
>> diff --git a/lib/virtio.h b/lib/virtio.h
>> index 2c31fdc7..44b727f8 100644
>> --- a/lib/virtio.h
>> +++ b/lib/virtio.h
>> @@ -141,6 +141,8 @@ extern void vring_init_virtqueue(struct vring_virtqueue *vq, unsigned index,
>>   				 const char *name);
>>   extern int virtqueue_add_outbuf(struct virtqueue *vq, char *buf,
>>   				unsigned int len);
>> +extern int virtqueue_add_inbuf(struct virtqueue *vq, char *buf,
>> +			       unsigned int len);
>>   extern bool virtqueue_kick(struct virtqueue *vq);
>>   extern void detach_buf(struct vring_virtqueue *vq, unsigned head);
>>   extern void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len);
>> -- 
>> 2.25.1
>>
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
