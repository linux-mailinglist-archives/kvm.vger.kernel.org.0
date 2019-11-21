Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12B21059DB
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 19:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfKUSo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 13:44:26 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfKUSo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 13:44:26 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALIi4YF182586;
        Thu, 21 Nov 2019 18:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=SPXQVD6RC8shnzp+HzAckjYrp8WJ7qrn12ygq+Dj2x4=;
 b=D/RQeb0sTwBPWYBaTUMv3yvq69Uhe7SwXyXwwabhjmZMxzacFCyxXpay+aNGSn5+boDr
 p1wIeQRZSliQcdjcsTH7ixvMMvzrEbX5aMJ/UUSO9AGbwcb+ysCv/UL4uVeFR+h57zf6
 EfJqtmxc9JjnuoSMDDC2yVgEvbDNpxsgCsae6Fzb2rE0nIzzJrouVET+MhzPZ2DNAQzZ
 si73LwLP4SOk4zrHDgkJC1g9E5fpa76F4Ry3ycZYtzVVqW4Dqx5NqEX2apY3XNX3TShV
 stacW229rSdwxzqWCuobYEzkKC9KuLuKJQBOL4QpyThcOMi6sD5memsaBjrAiqwfDJcl MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2wa9rqx63p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 18:44:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xALIcKup113349;
        Thu, 21 Nov 2019 18:42:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2wda06gfb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Nov 2019 18:42:20 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xALIgJ94000846;
        Thu, 21 Nov 2019 18:42:19 GMT
Received: from [10.159.158.222] (/10.159.158.222)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 Nov 2019 10:42:19 -0800
Subject: Re: [PATCH] KVM: nVMX: expose "load IA32_PERF_GLOBAL_CTRL" controls
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>
References: <1574346557-18344-1-git-send-email-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <7fea1f06-9abb-cdd1-9cb9-8655fe207e96@oracle.com>
Date:   Thu, 21 Nov 2019 10:42:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1574346557-18344-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911210157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9448 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911210158
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/21/19 6:29 AM, Paolo Bonzini wrote:
> These controls were added by the recent commit 03a8871add95 ("KVM:
> nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control",
> 2019-11-13), so we should advertise them to userspace from
> KVM_GET_MSR_FEATURE_INDEX_LIST, as well.
>
> Cc: Oliver Upton <oupton@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 4aea7d304beb..4b4ce6a804ff 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5982,6 +5982,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
>   #ifdef CONFIG_X86_64
>   		VM_EXIT_HOST_ADDR_SPACE_SIZE |
>   #endif
> +		VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
>   		VM_EXIT_LOAD_IA32_PAT | VM_EXIT_SAVE_IA32_PAT;
>   	msrs->exit_ctls_high |=
>   		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |
> @@ -6001,6 +6002,7 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
>   #ifdef CONFIG_X86_64
>   		VM_ENTRY_IA32E_MODE |
>   #endif
> +		VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
>   		VM_ENTRY_LOAD_IA32_PAT;
>   	msrs->entry_ctls_high |=
>   		(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR | VM_ENTRY_LOAD_IA32_EFER);
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
