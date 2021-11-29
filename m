Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF08C461C90
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 18:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348862AbhK2RTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 12:19:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8976 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345809AbhK2RRH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Nov 2021 12:17:07 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGlYMX015648;
        Mon, 29 Nov 2021 17:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1jbh7Bqw8aRrbB8xzKKoStQfXEKWQMi6v24QMp4/woo=;
 b=jnzFWZUMgEk+HaXrr8cMMnyOASxhG/TYnyLKRvpys4mfsUM/nFcFMyymAeB0Hb7Wwt1K
 5ffK7K+6/RdnRw15Pqp07GkxOPvCjd+xbX/uXx80K6tipEQjZsHWm3W2tMbfeFRTgE5f
 v27l2uJdBa3nawqT0ad4LbNNrmzOYphyr5Y5S8UZsAMhCId2Xa+EyCstQ+ne++g/Igkw
 W2yoC9zyN142U6VGf9gD3SxuhlZ0YCO4U/5qN8F/MSM0ebw7AhYBIy2oAbr7tEYP2CkL
 g2X7kA89mwlfB94jbie0HcylSwiYHT2dNbjpjuchlAGaw60DRC+XWmwneRqGxKWZBC4A Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn2ps8kuv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:13:45 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ATGmHif017183;
        Mon, 29 Nov 2021 17:13:45 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn2ps8ku5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:13:45 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGwKpv020894;
        Mon, 29 Nov 2021 17:13:43 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3ckca965pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:13:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATH6F6U62652798
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 17:06:15 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B13E652057;
        Mon, 29 Nov 2021 17:13:40 +0000 (GMT)
Received: from [9.171.89.183] (unknown [9.171.89.183])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 6685A52054;
        Mon, 29 Nov 2021 17:13:40 +0000 (GMT)
Message-ID: <c6b7c933-2d48-1504-7c45-110b0ab317ad@linux.ibm.com>
Date:   Mon, 29 Nov 2021 18:13:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] kvm/eventfd: fix the misleading comment in
 kvm_irqfd_assign
Content-Language: en-US
To:     "Longpeng(Mike)" <longpeng2@huawei.com>, pbonzini@redhat.com
Cc:     cornelia.huck@de.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arei.gonglei@huawei.com
References: <20211129034328.1604-1-longpeng2@huawei.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20211129034328.1604-1-longpeng2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aYs2JJN0imiYHpiviEjonQB9MY2HjiUJ
X-Proofpoint-ORIG-GUID: OslurKj-BeMRcLOA6KR381zpy9yytlT7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 priorityscore=1501 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111290081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 29.11.21 um 04:43 schrieb Longpeng(Mike):
> From: Longpeng <longpeng2@huawei.com>
> 
> The comment above the invocation of vfs_poll() is misleading, move
> it to the right place.
> 
I think that the current variant is better.
events is only used in that function to check for EPOLLIN, so the
assignment and the if belong together from a "what am I doing here" perspective.

> Fixes: 684a0b719ddb ("KVM: eventfd: Fix lock order inversion")
> Signed-off-by: Longpeng <longpeng2@huawei.com>
> ---
>   virt/kvm/eventfd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 2ad013b..cd01814 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -406,12 +406,12 @@ bool __attribute__((weak)) kvm_arch_irqfd_route_changed(
> 
>   	spin_unlock_irq(&kvm->irqfds.lock);
> 
> +	events = vfs_poll(f.file, &irqfd->pt);
> +
>   	/*
>   	 * Check if there was an event already pending on the eventfd
>   	 * before we registered, and trigger it as if we didn't miss it.
>   	 */
> -	events = vfs_poll(f.file, &irqfd->pt);
> -
>   	if (events & EPOLLIN)
>   		schedule_work(&irqfd->inject);
> 
