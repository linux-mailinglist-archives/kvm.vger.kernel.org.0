Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A14F44364
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732318AbfFMQ3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:29:11 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730935AbfFMIf2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 04:35:28 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8XSsF093911
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 04:35:25 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t3k2vr2u1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 04:35:25 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 13 Jun 2019 09:35:23 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Jun 2019 09:35:20 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5D8ZIDv29425810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 08:35:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B501BA405D;
        Thu, 13 Jun 2019 08:35:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E764A404D;
        Thu, 13 Jun 2019 08:35:18 +0000 (GMT)
Received: from [9.152.97.224] (unknown [9.152.97.224])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jun 2019 08:35:18 +0000 (GMT)
Reply-To: mimu@linux.ibm.com
Subject: Re: [PATCH v5 8/8] virtio/s390: make airq summary indicators DMA
To:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
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
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
References: <20190612111236.99538-1-pasic@linux.ibm.com>
 <20190612111236.99538-9-pasic@linux.ibm.com>
From:   Michael Mueller <mimu@linux.ibm.com>
Organization: IBM
Date:   Thu, 13 Jun 2019 10:35:17 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612111236.99538-9-pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061308-0028-0000-0000-00000379E904
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061308-0029-0000-0000-00002439E09D
Message-Id: <0020cf49-1dce-d768-e497-1d4e7482fc5e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.06.19 13:12, Halil Pasic wrote:
> Hypervisor needs to interact with the summary indicators, so these

The hypervisor...

> need to be DMA memory as well (at least for protected virtualization
> guests).
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>   drivers/s390/virtio/virtio_ccw.c | 32 ++++++++++++++++++++++++--------
>   1 file changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 800252955a2f..1a55e5942d36 100644
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
> @@ -209,7 +215,7 @@ static void virtio_airq_handler(struct airq_struct *airq, bool floating)
>   			break;
>   		vring_interrupt(0, (void *)airq_iv_get_ptr(info->aiv, ai));
>   	}
> -	info->summary_indicator = 0;
> +	*(get_summary_indicator(info)) = 0;
>   	smp_wmb();
>   	/* Walk through indicators field, summary indicator not active. */
>   	for (ai = 0;;) {
> @@ -221,7 +227,7 @@ static void virtio_airq_handler(struct airq_struct *airq, bool floating)
>   	read_unlock(&info->lock);
>   }
>   
> -static struct airq_info *new_airq_info(void)
> +static struct airq_info *new_airq_info(int index)
>   {
>   	struct airq_info *info;
>   	int rc;
> @@ -237,7 +243,8 @@ static struct airq_info *new_airq_info(void)
>   		return NULL;
>   	}
>   	info->airq.handler = virtio_airq_handler;
> -	info->airq.lsi_ptr = &info->summary_indicator;
> +	info->summary_indicator_idx = index;
> +	info->airq.lsi_ptr = get_summary_indicator(info);
>   	info->airq.lsi_mask = 0xff;
>   	info->airq.isc = VIRTIO_AIRQ_ISC;
>   	rc = register_adapter_interrupt(&info->airq);
> @@ -259,7 +266,7 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
>   
>   	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
>   		if (!airq_areas[i])
> -			airq_areas[i] = new_airq_info();
> +			airq_areas[i] = new_airq_info(i);
>   		info = airq_areas[i];
>   		if (!info)
>   			return 0;
> @@ -345,7 +352,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
>   		if (!thinint_area)
>   			return;
>   		thinint_area->summary_indicator =
> -			(unsigned long) &airq_info->summary_indicator;
> +			(unsigned long) get_summary_indicator(airq_info);
>   		thinint_area->isc = VIRTIO_AIRQ_ISC;
>   		ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
>   		ccw->count = sizeof(*thinint_area);
> @@ -613,7 +620,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
>   	}
>   	info = vcdev->airq_info;
>   	thinint_area->summary_indicator =
> -		(unsigned long) &info->summary_indicator;
> +		(unsigned long) get_summary_indicator(info);
>   	thinint_area->isc = VIRTIO_AIRQ_ISC;
>   	ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
>   	ccw->flags = CCW_FLAG_SLI;
> @@ -1493,8 +1500,17 @@ static void __init no_auto_parse(void)
>   
>   static int __init virtio_ccw_init(void)
>   {
> +	int rc;
> +
>   	/* parse no_auto string before we do anything further */
>   	no_auto_parse();
> -	return ccw_driver_register(&virtio_ccw_driver);
> +
> +	summary_indicators = cio_dma_zalloc(MAX_AIRQ_AREAS);
> +	if (!summary_indicators)
> +		return -ENOMEM;
> +	rc = ccw_driver_register(&virtio_ccw_driver);
> +	if (rc)
> +		cio_dma_free(summary_indicators, MAX_AIRQ_AREAS);
> +	return rc;
>   }
>   device_initcall(virtio_ccw_init);
> 

Reviewed-by: Michael Mueller <mimu@linux.ibm.com>

Michael

