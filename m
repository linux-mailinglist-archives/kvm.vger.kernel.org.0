Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15A111473C5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 23:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgAWWYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 17:24:25 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45124 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgAWWYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 17:24:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NMI8Z3141000;
        Thu, 23 Jan 2020 22:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Hw2/S4vaNiTXKlqiCOITg7iPR0ZQVU5JqzeRfGkronA=;
 b=PbR0it8Zlbh4/77MfrnojakG/slM/Rc5CMoPKjcbmICq8Np0CGZOaKDV2+OxyOm+Unsj
 tdscx0Vd+tu+HUFn/SnkPZgiN3v8u3gN4Bdyp/H8WXwvck8aXXlZx4xeIaaJBqca4KDY
 uk7pjrGwD7y/xJ9ndPH1KDFxsQ3zqV11/cJ2LY727veUdbdxGb3/GGdfoYO9pRLUCqAl
 X+MdjKQHyXFNMH6PrxdcHL3OX/mdBF/bzs90iZ9UjPPzUmjkkkv1UMIUGWOyT7Ff3+XI
 8IVLmH6LZ4P+muE8U2T+oqVDmC+rBKmMm78waRFZRCJRKLNZGnAI4g+MWFAPfORJTyrt eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xkseuwgcd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 22:23:09 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00NMJCpU153399;
        Thu, 23 Jan 2020 22:21:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xpq7ns4ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jan 2020 22:21:08 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00NML4TP002231;
        Thu, 23 Jan 2020 22:21:04 GMT
Received: from dhcp-10-132-95-72.usdhcp.oraclecorp.com (/10.132.95.72)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 14:21:04 -0800
Subject: Re: [PATCH] KVM: nVMX: delete meaningless nested_vmx_run()
 declaration
To:     linmiaohe <linmiaohe@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1579745300-13029-1-git-send-email-linmiaohe@huawei.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <bf9d650d-36c3-b88f-df4a-e37ed0dae2a7@oracle.com>
Date:   Thu, 23 Jan 2020 14:21:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <1579745300-13029-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001230166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001230166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/22/2020 06:08 PM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The function nested_vmx_run() declaration is below its implementation. So
> this is meaningless and should be removed.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 95b3f4306ac2..7608924ee8c1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4723,8 +4723,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>   	return nested_vmx_succeed(vcpu);
>   }
>   
> -static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch);
> -
>   /* Emulate the VMLAUNCH instruction */
>   static int handle_vmlaunch(struct kvm_vcpu *vcpu)
>   {
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
