Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B513437
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 21:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfECT57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 15:57:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35770 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfECT57 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 15:57:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43Jrx5q107228;
        Fri, 3 May 2019 19:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=lzy+7RAxCzHkZHr4K/n5hXAdKCjWLRSsrsEUcieRAgc=;
 b=y19CpNv5Uv/EGnhLEZFZzCHyKVoJLYAPdvMK6OtH5yt9cr6sAGHvGJT22aPkSyhSAIFL
 tdAi+j30aN5CW42AjVelAlArHCoGF1XLM7lcavhCk3ng1c/Z1s0baXE0T+cX4kILi/V1
 totwPIq03cUxeOyUJt/HQsEhQPXnEP05WakiU3MCY0+GKNtGy2SIBQjOjMr1LYjkc+2x
 L1LtSwuI5wJyzyGiWkghcdPKhu1xG49az4lVQt5vGE4vWIW8iY5MEfTK0q6tvNrR9M6+
 8+t1pEnOLAm1BvWUJZ/hF6t7N0QReJ9Bpjc6h+wSUv9oX0DMmZ2x41oTcd9l1Cdu4xD+ CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s6xj00x62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:57:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43JuoeX191358;
        Fri, 3 May 2019 19:57:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2s7rtcfm7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 19:57:42 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x43Jvevl015315;
        Fri, 3 May 2019 19:57:41 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 May 2019 12:57:40 -0700
Subject: Re: [kvm-unit-tests PATCH v2 3/4] lib: Remove redeundant page zeroing
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
 <20190503103207.9021-4-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a4e09bda-e8fb-9241-bbe9-3a307ca26c05@oracle.com>
Date:   Fri, 3 May 2019 12:57:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190503103207.9021-4-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030131
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/03/2019 03:32 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> Now that alloc_page() zeros the page, remove the redundant page zeroing.
>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   lib/virtio-mmio.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
> index 57fe78e..e5e8f66 100644
> --- a/lib/virtio-mmio.c
> +++ b/lib/virtio-mmio.c
> @@ -56,7 +56,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev,
>   	vq = calloc(1, sizeof(*vq));
>   	assert(VIRTIO_MMIO_QUEUE_SIZE_MIN <= 2*PAGE_SIZE);
>   	queue = alloc_pages(1);
> -	memset(queue, 0, 2*PAGE_SIZE);
>   	assert(vq && queue);
>   
>   	writel(index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
