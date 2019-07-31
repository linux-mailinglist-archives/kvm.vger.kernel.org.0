Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAAA7D047
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 23:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbfGaVuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 17:50:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40716 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729472AbfGaVuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 17:50:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6VLne5u118033;
        Wed, 31 Jul 2019 21:49:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=r4Zi+6BIBluGOzcRqoiDPAygyExOFTGCHzb+lcOWRyU=;
 b=olTHyfKWxCzqItGuucpTfh+qL27NLjY+d1sw3ubtnglXVLpvrGGJPb+iXgnyJ+JhrDHQ
 r5OHbusimrqdUn0ZwdsFqWUgLH1GL3rQx097ms9JvOhSo1lzg6cpMCinkXnhAO2DNY+S
 YeiS1VYfawOg8vJgJYPQvLIFjLKNl/ipWhCuaIlJPeTrCyl0gNk/w7s1m4lCiJPJzK99
 91AdQ/XUBTa5rcoKXPey1BUh0RIAyUVqjnJ4vx4j/8OV90aDWYR2tR3ddsR730X4osmL
 kK6au0saRh7Vfyi3pmTfXnt0Our2FCmYgSPJYa/apYIaCzcvf0VG1AoZGB0BuDx1PrQx 4w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u0f8r7vcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 21:49:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6VLmLmD130836;
        Wed, 31 Jul 2019 21:49:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2u349db3xv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Jul 2019 21:49:55 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6VLntKn008788;
        Wed, 31 Jul 2019 21:49:55 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 31 Jul 2019 14:49:55 -0700
Subject: Re: [PATCH 1/3] KVM: X86: Trace vcpu_id for vmexit
To:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-2-peterx@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4cf0d8e6-7e5d-5372-3d7f-429b82034f60@oracle.com>
Date:   Wed, 31 Jul 2019 14:49:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190729053243.9224-2-peterx@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907310218
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9335 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907310218
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/28/2019 10:32 PM, Peter Xu wrote:
> It helps to pair vmenters and vmexis with multi-core systems.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>   arch/x86/kvm/trace.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 4d47a2631d1f..26423d2e45df 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -232,17 +232,20 @@ TRACE_EVENT(kvm_exit,
>   		__field(	u32,	        isa             )
>   		__field(	u64,	        info1           )
>   		__field(	u64,	        info2           )
> +		__field(	int,	        vcpu_id         )
>   	),
>   
>   	TP_fast_assign(
>   		__entry->exit_reason	= exit_reason;
>   		__entry->guest_rip	= kvm_rip_read(vcpu);
>   		__entry->isa            = isa;
> +		__entry->vcpu_id        = vcpu->vcpu_id;
>   		kvm_x86_ops->get_exit_info(vcpu, &__entry->info1,
>   					   &__entry->info2);
>   	),
>   
> -	TP_printk("reason %s rip 0x%lx info %llx %llx",
> +	TP_printk("vcpu %d reason %s rip 0x%lx info %llx %llx",
> +		  __entry->vcpu_id,
>   		 (__entry->isa == KVM_ISA_VMX) ?
>   		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
>   		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
