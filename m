Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A93B816B639
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 01:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbgBYACr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 19:02:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbgBYACr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 19:02:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P01MhI027842;
        Tue, 25 Feb 2020 00:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=L9fyC16dmA1kfDXCiD6ng+Ni6BdC1r9errPPLzLDBMk=;
 b=zs+ahMgnxsPO3Sj+MLaxP/5hHf1yT4etT6IoI5tQtTs9dybFNcHlY2NT4ta7viNAaIyV
 10oGpBsXkuuuKMZLXTR/End37uPC+jFs/2A+CcsdUgztJrggXYnjNeTvcgcO/wf5bFfy
 5rx5hV2H93b8htua1suz0xrktfhFs9XnvEEy7I8Tq0mm0LTfJTdqQsyh6uuPXDnl6KKw
 QhQOpyaVv3OmYWM4SYSUfTwVEAmw/e9W4xVieUXy0Q8PAZqpZjITCW3YCiB96HE9g4o9
 SeTnaIAqhcmbQ4jKCLRs2ddW+5oCjK8NH2dTCz8iil5zrj524aSOerGt3tnm5FgtFKsg Ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ycppr8fcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:02:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P02Hrh143719;
        Tue, 25 Feb 2020 00:02:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2yby5e8cn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:02:35 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P02Zik024999;
        Tue, 25 Feb 2020 00:02:35 GMT
Received: from dhcp-10-132-97-93.usdhcp.oraclecorp.com (/10.132.97.93)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:02:34 -0800
Subject: Re: [PATCH] KVM: nVMX: Consolidate nested MTF checks to helper
 function
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>
References: <20200224202744.221487-1-oupton@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <06e2e585-a7be-ce0f-4c7d-add8ce0c43b0@oracle.com>
Date:   Mon, 24 Feb 2020 16:02:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20200224202744.221487-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=3 mlxlogscore=999 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 suspectscore=3 impostorscore=0
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02/24/2020 12:27 PM, Oliver Upton wrote:
> commit 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing
> instruction emulation") introduced a helper to check the MTF
> VM-execution control in vmcs12. Change pre-existing check in
> nested_vmx_exit_reflected() to instead use the helper.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index e920d7834d73..b9caad70ac7c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5627,7 +5627,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>   	case EXIT_REASON_MWAIT_INSTRUCTION:
>   		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
>   	case EXIT_REASON_MONITOR_TRAP_FLAG:
> -		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_TRAP_FLAG);
> +		return nested_cpu_has_mtf(vmcs12);
>   	case EXIT_REASON_MONITOR_INSTRUCTION:
>   		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
>   	case EXIT_REASON_PAUSE_INSTRUCTION:
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
