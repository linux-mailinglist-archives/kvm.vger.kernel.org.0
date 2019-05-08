Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E40717CE0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 17:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfEHPLY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 11:11:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47048 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727367AbfEHPLX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 May 2019 11:11:23 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48F7RJ7121465
        for <kvm@vger.kernel.org>; Wed, 8 May 2019 11:11:22 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sbyqn6nmj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 11:11:22 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 8 May 2019 16:11:20 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 16:11:17 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48FBFWJ48037982
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 15:11:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 239CD42049;
        Wed,  8 May 2019 15:11:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D2C142041;
        Wed,  8 May 2019 15:11:14 +0000 (GMT)
Received: from [9.145.42.10] (unknown [9.145.42.10])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 15:11:14 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH 10/10] virtio/s390: make airq summary indicators DMA
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
 <20190426183245.37939-11-pasic@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 8 May 2019 17:11:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190426183245.37939-11-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050815-0008-0000-0000-000002E493AF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050815-0009-0000-0000-0000225115A0
Message-Id: <74ff9a63-891a-7e24-0865-8cc91a95cada@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/04/2019 20:32, Halil Pasic wrote:
> Hypervisor needs to interact with the summary indicators, so these
> need to be DMA memory as well (at least for protected virtualization
> guests).
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>   drivers/s390/virtio/virtio_ccw.c | 24 +++++++++++++++++-------
>   1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 613b18001a0c..6058b07fea08 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -140,11 +140,17 @@ static int virtio_ccw_use_airq = 1;
>   
>   struct airq_info {
>   	rwlock_t lock;
> -	u8 summary_indicator;
> +	u8 summary_indicator_idx;
>   	struct airq_struct airq;
>   	struct airq_iv *aiv;
>   };
>   static struct airq_info *airq_areas[MAX_AIRQ_AREAS];
> +static u8 *summary_indicators;
> +
> +static inline u8 *get_summary_indicator(struct airq_info *info)
> +{
> +	return summary_indicators + info->summary_indicator_idx;
> +}
>   
>   #define CCW_CMD_SET_VQ 0x13
>   #define CCW_CMD_VDEV_RESET 0x33
> @@ -225,7 +231,7 @@ static void virtio_airq_handler(struct airq_struct *airq)
>   			break;
>   		vring_interrupt(0, (void *)airq_iv_get_ptr(info->aiv, ai));
>   	}
> -	info->summary_indicator = 0;
> +	*(get_summary_indicator(info)) = 0;
>   	smp_wmb();
>   	/* Walk through indicators field, summary indicator not active. */
>   	for (ai = 0;;) {
> @@ -237,7 +243,8 @@ static void virtio_airq_handler(struct airq_struct *airq)
>   	read_unlock(&info->lock);
>   }
>   
> -static struct airq_info *new_airq_info(void)
> +/* call with airq_areas_lock held */
> +static struct airq_info *new_airq_info(int index)
>   {
>   	struct airq_info *info;
>   	int rc;
> @@ -252,7 +259,8 @@ static struct airq_info *new_airq_info(void)
>   		return NULL;
>   	}
>   	info->airq.handler = virtio_airq_handler;
> -	info->airq.lsi_ptr = &info->summary_indicator;
> +	info->summary_indicator_idx = index;
> +	info->airq.lsi_ptr = get_summary_indicator(info);
>   	info->airq.lsi_mask = 0xff;
>   	info->airq.isc = VIRTIO_AIRQ_ISC;
>   	rc = register_adapter_interrupt(&info->airq);
> @@ -273,8 +281,9 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
>   	unsigned long bit, flags;
>   
>   	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
> +		/* TODO: this seems to be racy */

yes, my opinions too, was already racy, in my opinion, we need another 
patch in another series to fix this.

However, not sure about the comment.

>   		if (!airq_areas[i])
> -			airq_areas[i] = new_airq_info();
> +			airq_areas[i] = new_airq_info(i);
>   		info = airq_areas[i];
>   		if (!info)
>   			return 0;
> @@ -359,7 +368,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
>   		if (!thinint_area)
>   			return;
>   		thinint_area->summary_indicator =
> -			(unsigned long) &airq_info->summary_indicator;
> +			(unsigned long) get_summary_indicator(airq_info);
>   		thinint_area->isc = VIRTIO_AIRQ_ISC;
>   		ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
>   		ccw->count = sizeof(*thinint_area);
> @@ -624,7 +633,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
>   	}
>   	info = vcdev->airq_info;
>   	thinint_area->summary_indicator =
> -		(unsigned long) &info->summary_indicator;
> +		(unsigned long) get_summary_indicator(info);
>   	thinint_area->isc = VIRTIO_AIRQ_ISC;
>   	ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
>   	ccw->flags = CCW_FLAG_SLI;
> @@ -1500,6 +1509,7 @@ static int __init virtio_ccw_init(void)
>   {
>   	/* parse no_auto string before we do anything further */
>   	no_auto_parse();
> +	summary_indicators = cio_dma_zalloc(MAX_AIRQ_AREAS);
>   	return ccw_driver_register(&virtio_ccw_driver);
>   }
>   device_initcall(virtio_ccw_init);
> 



-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

