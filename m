Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3BD17B8A
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 16:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfEHObp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 10:31:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727081AbfEHObp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 10:31:45 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48EV0WH139828
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 10:31:44 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sbya7nx73-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 10:31:44 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 8 May 2019 15:31:42 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 15:31:38 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48EVbFn45547764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 14:31:37 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20DA14204C;
        Wed,  8 May 2019 14:31:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F1D942042;
        Wed,  8 May 2019 14:31:36 +0000 (GMT)
Received: from [9.145.42.10] (unknown [9.145.42.10])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 14:31:36 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 08/10] virtio/s390: add indirection to indicators access
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
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 8 May 2019 16:31:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426183245.37939-9-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050814-0016-0000-0000-0000027998FA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050814-0017-0000-0000-000032D6491B
Message-Id: <716d47ca-016f-e8f4-6d78-7746a7d9f6ba@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080090
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/2019 20:32, Halil Pasic wrote:
> This will come in handy soon when we pull out the indicators from
> virtio_ccw_device to a memory area that is shared with the hypervisor
> (in particular for protected virtualization guests).
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>   drivers/s390/virtio/virtio_ccw.c | 40 +++++++++++++++++++++++++---------------
>   1 file changed, 25 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index bb7a92316fc8..1f3e7d56924f 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -68,6 +68,16 @@ struct virtio_ccw_device {
>   	void *airq_info;
>   };
>   
> +static inline unsigned long *indicators(struct virtio_ccw_device *vcdev)
> +{
> +	return &vcdev->indicators;
> +}
> +
> +static inline unsigned long *indicators2(struct virtio_ccw_device *vcdev)
> +{
> +	return &vcdev->indicators2;
> +}
> +
>   struct vq_info_block_legacy {
>   	__u64 queue;
>   	__u32 align;
> @@ -337,17 +347,17 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
>   		ccw->cda = (__u32)(unsigned long) thinint_area;
>   	} else {
>   		/* payload is the address of the indicators */
> -		indicatorp = kmalloc(sizeof(&vcdev->indicators),
> +		indicatorp = kmalloc(sizeof(indicators(vcdev)),
>   				     GFP_DMA | GFP_KERNEL);
>   		if (!indicatorp)
>   			return;
>   		*indicatorp = 0;
>   		ccw->cmd_code = CCW_CMD_SET_IND;
> -		ccw->count = sizeof(&vcdev->indicators);
> +		ccw->count = sizeof(indicators(vcdev));

This looks strange to me. Was already weird before.
Lucky we are indicators are long...
may be just sizeof(long)

>   		ccw->cda = (__u32)(unsigned long) indicatorp;
>   	}
>   	/* Deregister indicators from host. */
> -	vcdev->indicators = 0;
> +	*indicators(vcdev) = 0;
>   	ccw->flags = 0;
>   	ret = ccw_io_helper(vcdev, ccw,
>   			    vcdev->is_thinint ?
> @@ -656,10 +666,10 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>   	 * We need a data area under 2G to communicate. Our payload is
>   	 * the address of the indicators.
>   	*/
> -	indicatorp = kmalloc(sizeof(&vcdev->indicators), GFP_DMA | GFP_KERNEL);
> +	indicatorp = kmalloc(sizeof(indicators(vcdev)), GFP_DMA | GFP_KERNEL);
>   	if (!indicatorp)
>   		goto out;
> -	*indicatorp = (unsigned long) &vcdev->indicators;
> +	*indicatorp = (unsigned long) indicators(vcdev);
>   	if (vcdev->is_thinint) {
>   		ret = virtio_ccw_register_adapter_ind(vcdev, vqs, nvqs, ccw);
>   		if (ret)
> @@ -668,21 +678,21 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
>   	}
>   	if (!vcdev->is_thinint) {
>   		/* Register queue indicators with host. */
> -		vcdev->indicators = 0;
> +		*indicators(vcdev) = 0;
>   		ccw->cmd_code = CCW_CMD_SET_IND;
>   		ccw->flags = 0;
> -		ccw->count = sizeof(&vcdev->indicators);
> +		ccw->count = sizeof(indicators(vcdev));

same as before

>   		ccw->cda = (__u32)(unsigned long) indicatorp;
>   		ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND);
>   		if (ret)
>   			goto out;
>   	}
>   	/* Register indicators2 with host for config changes */
> -	*indicatorp = (unsigned long) &vcdev->indicators2;
> -	vcdev->indicators2 = 0;
> +	*indicatorp = (unsigned long) indicators2(vcdev);
> +	*indicators2(vcdev) = 0;
>   	ccw->cmd_code = CCW_CMD_SET_CONF_IND;
>   	ccw->flags = 0;
> -	ccw->count = sizeof(&vcdev->indicators2);
> +	ccw->count = sizeof(indicators2(vcdev));

here too

>   	ccw->cda = (__u32)(unsigned long) indicatorp;
>   	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_CONF_IND);
>   	if (ret)
> @@ -1092,17 +1102,17 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
>   			vcdev->err = -EIO;
>   	}
>   	virtio_ccw_check_activity(vcdev, activity);
> -	for_each_set_bit(i, &vcdev->indicators,
> -			 sizeof(vcdev->indicators) * BITS_PER_BYTE) {
> +	for_each_set_bit(i, indicators(vcdev),
> +			 sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
>   		/* The bit clear must happen before the vring kick. */
> -		clear_bit(i, &vcdev->indicators);
> +		clear_bit(i, indicators(vcdev));
>   		barrier();
>   		vq = virtio_ccw_vq_by_ind(vcdev, i);
>   		vring_interrupt(0, vq);
>   	}
> -	if (test_bit(0, &vcdev->indicators2)) {
> +	if (test_bit(0, indicators2(vcdev))) {
>   		virtio_config_changed(&vcdev->vdev);
> -		clear_bit(0, &vcdev->indicators2);
> +		clear_bit(0, indicators2(vcdev));
>   	}
>   }
>   
> 

Here again just a fast check.
I will go in the functional later.

Regards,
Pierre


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

