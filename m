Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2970E154BCA
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 20:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgBFTRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 14:17:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56416 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFTRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 14:17:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016J8QsE182712;
        Thu, 6 Feb 2020 19:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=D35EWsKjsgC/16dRjqpZ2h/VCoX7efyqiV9D6Pdxtr0=;
 b=gMAjJX8SQOXEcRVOnB31Bp3+dusq65a8SWjo2yqeyokQYrMh+oFWwut9oDZeb+tZvlH9
 kgiZvs6qo4HPHN5qWaajpvNzLaG/Yj/jNnt0T5LyTkx9Iq4dTDwTeNRtPN+nG1MVLZUz
 Qyvp1xDhGGlxMpHvk3LNQH0w9d13QOGEbC8epelsb1rhXFSohv5Gz9riVWM0k8ykSDyM
 o2n2Qc/mUEMWcidEjhrXBvGUakFmkuiQ72Pt52WE/RJPA6BM0r/DnOSKkGXvs/5UK4wv
 FC7GpQq1t+ODsBPg8lg/WBPFvV7P8yeBkCHaxRHesxgSwZo2/ahyj0eRK/ftnrCgzA+B Jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=D35EWsKjsgC/16dRjqpZ2h/VCoX7efyqiV9D6Pdxtr0=;
 b=HYnRI7BvVYwLMbr8aiIAgFigyAcaq53tjCM5HFwP1JQ2TR0lnaWfM6bPHTlPFGdyw5Cj
 9dwj+zh6wyf4AZqhxqPD1mGFXTrGEjDR0UOeToXh77xVKno6P79RI+ZEajWG/MaSQOcA
 IS129vqg99xOUPmH7jRiXNudL81aYiXUFFzHIhea4l+4ar+E0AJiq4bENScRJEle7oN1
 xJdsmJDelZMq89UWwwjUepGNNrHtB+qdLJUb04kWRfDZBkzbfg4uDfxo/SDwK22zDqB+
 UR6zInfWADwFAabsww50/KiwzFatr9Ckv3ZVV4GcFNncBRjeFjd9Wy2MzoTV8/ie+gWW ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2xykbpbsva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:17:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 016J8RrZ113738;
        Thu, 6 Feb 2020 19:17:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2y0mjv6wbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Feb 2020 19:17:22 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 016JHKdX021474;
        Thu, 6 Feb 2020 19:17:20 GMT
Received: from localhost.localdomain (/10.159.247.143)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Feb 2020 11:17:20 -0800
Subject: Re: [PATCH v4 1/3] selftests: KVM: Replace get_gdt/idt_base() by
 get_gdt/idt()
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
References: <20200206104710.16077-1-eric.auger@redhat.com>
 <20200206104710.16077-2-eric.auger@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <3b8cdccb-7db2-fba2-6ca8-445d4a0971ae@oracle.com>
Date:   Thu, 6 Feb 2020 11:17:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200206104710.16077-2-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002060140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9523 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002060140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/6/20 2:47 AM, Eric Auger wrote:
> get_gdt_base() and get_idt_base() only return the base address
> of the descriptor tables. Soon we will need to get the size as well.
> Change the prototype of those functions so that they return
> the whole desc_ptr struct instead of the address field.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
>
> ---
>
> v3 -> v4:
> - Collected R-b's
> ---
>   tools/testing/selftests/kvm/include/x86_64/processor.h | 8 ++++----
>   tools/testing/selftests/kvm/lib/x86_64/vmx.c           | 6 +++---
>   2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index aa6451b3f740..6f7fffaea2e8 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -220,20 +220,20 @@ static inline void set_cr4(uint64_t val)
>   	__asm__ __volatile__("mov %0, %%cr4" : : "r" (val) : "memory");
>   }
>   
> -static inline uint64_t get_gdt_base(void)
> +static inline struct desc_ptr get_gdt(void)
>   {
>   	struct desc_ptr gdt;
>   	__asm__ __volatile__("sgdt %[gdt]"
>   			     : /* output */ [gdt]"=m"(gdt));
> -	return gdt.address;
> +	return gdt;
>   }
>   
> -static inline uint64_t get_idt_base(void)
> +static inline struct desc_ptr get_idt(void)
>   {
>   	struct desc_ptr idt;
>   	__asm__ __volatile__("sidt %[idt]"
>   			     : /* output */ [idt]"=m"(idt));
> -	return idt.address;
> +	return idt;
>   }
>   
>   #define SET_XMM(__var, __xmm) \
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> index 85064baf5e97..7aaa99ca4dbc 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
> @@ -288,9 +288,9 @@ static inline void init_vmcs_host_state(void)
>   	vmwrite(HOST_FS_BASE, rdmsr(MSR_FS_BASE));
>   	vmwrite(HOST_GS_BASE, rdmsr(MSR_GS_BASE));
>   	vmwrite(HOST_TR_BASE,
> -		get_desc64_base((struct desc64 *)(get_gdt_base() + get_tr())));
> -	vmwrite(HOST_GDTR_BASE, get_gdt_base());
> -	vmwrite(HOST_IDTR_BASE, get_idt_base());
> +		get_desc64_base((struct desc64 *)(get_gdt().address + get_tr())));
> +	vmwrite(HOST_GDTR_BASE, get_gdt().address);
> +	vmwrite(HOST_IDTR_BASE, get_idt().address);
>   	vmwrite(HOST_IA32_SYSENTER_ESP, rdmsr(MSR_IA32_SYSENTER_ESP));
>   	vmwrite(HOST_IA32_SYSENTER_EIP, rdmsr(MSR_IA32_SYSENTER_EIP));
>   }

Nit: The commit message header can be made better to reflect the correct 
function names. For example,

     Replace get_[gdt | idt]_base() with get_[gdt | idt]()


With that,

     Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

