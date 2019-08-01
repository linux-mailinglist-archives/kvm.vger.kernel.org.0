Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD567D236
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 02:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfHAATw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 20:19:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35152 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfHAATw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 20:19:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x710J0lq020741;
        Thu, 1 Aug 2019 00:19:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=NwTUhBa2pGAirQxYZmWa0hrLdVAupmUuCAnymoKD3AA=;
 b=leEyxnzbfZxX1ngVAifWcLf1WLHxgDmjq8/A+zTOJEXvPa+DBH2jHhrlxIZ2yYjAdLJd
 CUyVGHA5glIq89f5L843OOErehVkvH0MMv0TL78vf/H12JJFmChEXdhQ6tM4O9EmPsaF
 MUqJNjwvirfkHcGzcc/xp11i7Spz9xN+2D9sQxvX3QgMNvFgK8SwCumZcEQF/3FVVqIB
 /z0IbtcwUKNuGu/4Na5KQJAU6y6Y5ELlq20KQfxxRyYNr/UTE1m7OPv4efi7+aXbZafB
 cmTNuWojsKGus/EJcI/1tgy6vK6/3UX3FDFZpcTmw6SEpv162xNAw9h/nBdxTIKe3a66 dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u0e1u0gjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 00:19:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x710IIOt170989;
        Thu, 1 Aug 2019 00:19:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u2jp5mfwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 00:19:25 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x710JOMd015810;
        Thu, 1 Aug 2019 00:19:24 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 17:19:23 -0700
Subject: Re: [PATCH 2/3] KVM: X86: Remove tailing newline for tracepoints
To:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-3-peterx@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <ba2516a4-9e82-bc4c-e3a9-c5bb26ff6d6e@oracle.com>
Date:   Wed, 31 Jul 2019 17:19:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190729053243.9224-3-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/28/2019 10:32 PM, Peter Xu wrote:
> It's done by TP_printk() already.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   arch/x86/kvm/trace.h | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 26423d2e45df..76a39bc25b95 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1323,7 +1323,7 @@ TRACE_EVENT(kvm_avic_incomplete_ipi,
>   		__entry->index = index;
>   	),
>   
> -	TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u\n",
> +	TP_printk("vcpu=%u, icrh:icrl=%#010x:%08x, id=%u, index=%u",
>   		  __entry->vcpu, __entry->icrh, __entry->icrl,
>   		  __entry->id, __entry->index)
>   );
> @@ -1348,7 +1348,7 @@ TRACE_EVENT(kvm_avic_unaccelerated_access,
>   		__entry->vec = vec;
>   	),
>   
> -	TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x\n",
> +	TP_printk("vcpu=%u, offset=%#x(%s), %s, %s, vec=%#x",
>   		  __entry->vcpu,
>   		  __entry->offset,
>   		  __print_symbolic(__entry->offset, kvm_trace_symbol_apic),
> @@ -1368,7 +1368,7 @@ TRACE_EVENT(kvm_hv_timer_state,
>   			__entry->vcpu_id = vcpu_id;
>   			__entry->hv_timer_in_use = hv_timer_in_use;
>   			),
> -		TP_printk("vcpu_id %x hv_timer %x\n",
> +		TP_printk("vcpu_id %x hv_timer %x",
>   			__entry->vcpu_id,
>   			__entry->hv_timer_in_use)
>   );

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
