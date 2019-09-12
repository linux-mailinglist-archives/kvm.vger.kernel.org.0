Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99BFB13DA
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 19:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfILRlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 13:41:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58264 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfILRlu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 13:41:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CHcsUe002991;
        Thu, 12 Sep 2019 17:41:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RD8KrzAKxy/XUS5OpaIH42PlqJbWkm9cbI2XwtDSLFs=;
 b=CpQw4kgoFhKYXZ6jVVduACDxYru0IX4l5qTpT9txeu8K9H/h140GrrsQ/lZ24Kyj69M3
 rx8IEetUVQ/ogSBTUz8NywIfezt8mYwhB94d8329avrXJ6bukIS6oBp0fxkXQwXgSXUH
 nI/9gjpXnz1odoRT5ottRaILZ0rXLqAi9v1IzaspU3VQbvJFcC7NVTChWhytbUheQIst
 9YLor0YrR1XTSXQS1ilZuuWPWdYsH0IGWwKxkLi6b5t6ay76lLrfbuozBRC/dF3gOUz2
 E+yA662iZRtgTQj17fNHrDDAZAtzBj2v99rSAYPcY57thsHcj0m94GDdHrjukqzeO22p pA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uytd3g2ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 17:41:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8CHc2I1177952;
        Thu, 12 Sep 2019 17:41:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uytdh8fr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Sep 2019 17:41:45 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8CHfjZX027046;
        Thu, 12 Sep 2019 17:41:45 GMT
Received: from [10.159.229.118] (/10.159.229.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Sep 2019 10:41:44 -0700
Subject: Re: [PATCH] kvm: x86: Add "significant index" flag to a few CPUID
 leaves
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>,
        Steve Rutherford <srutherford@google.com>
References: <20190912165503.190905-1-jmattson@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <900bfd96-f9da-0660-4746-6605c0ae06c4@oracle.com>
Date:   Thu, 12 Sep 2019 10:41:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190912165503.190905-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909120185
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909120185
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/12/19 9:55 AM, Jim Mattson wrote:
> According to the Intel SDM, volume 2, "CPUID," the index is
> significant (or partially significant) for CPUID leaves 0FH, 10H, 12H,
> 17H, 18H, and 1FH.
>
> Add the corresponding flag to these CPUID leaves in do_host_cpuid().
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
> ---
>   arch/x86/kvm/cpuid.c | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 22c2720cd948e..e7d25f4364664 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -304,7 +304,13 @@ static void do_host_cpuid(struct kvm_cpuid_entry2 *entry, u32 function,
>   	case 7:
>   	case 0xb:
>   	case 0xd:
> +	case 0xf:
> +	case 0x10:
> +	case 0x12:
>   	case 0x14:
> +	case 0x17:
> +	case 0x18:
> +	case 0x1f:
>   	case 0x8000001d:
>   		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
>   		break;


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

