Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA28015CB04
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 20:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgBMTQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 14:16:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59676 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbgBMTP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 14:15:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DJDQC9185826;
        Thu, 13 Feb 2020 19:14:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OEuCbiEvIiQVXLl2pCrqBGmbUcJGpiJBcGSmK0rtNRI=;
 b=FuuX3DgQgUvVzHFcbhXs9LAl0NqHxmmlNYCXVW/AyiAQCNXzKQIAAcW5/qzzNUyXzYIJ
 bVZ7V+U6pWSksLPfAQdQlZRhILIulpnkqLXhK9iRK1IjAF3QBNPnz+07JGl1daMuSWsq
 D4V2e9Mpee4sf8XtcwztWlW9ih+CNtZtpDeKQPJtLM+ZukHgGyuPw0Og0qyvpAAgUndw
 1YKG/9GcGwowCV9X9vfwgNvbk26yAuEoYmBoCLYslIN1pTtk4uYxWMwUlK4K7pSyhxPL
 2aMdDiYnFfHHHpqCXZjVwf6EkhV1Ov6zlknIn5oGGJ28Hvw4ZuQfQFYpg17ZNcaMcMDP 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2y2p3svhbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 19:14:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01DJBx4G187623;
        Thu, 13 Feb 2020 19:14:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2y4k80ek4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Feb 2020 19:14:33 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01DJEUaO023529;
        Thu, 13 Feb 2020 19:14:30 GMT
Received: from localhost.localdomain (/10.159.243.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 13 Feb 2020 11:14:30 -0800
Subject: Re: [PATCH] KVM: apic: remove unused function apic_lvt_vector()
To:     linmiaohe <linmiaohe@huawei.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1581561464-3893-1-git-send-email-linmiaohe@huawei.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <2fb684de-30c1-ed67-600f-08168e64d6c7@oracle.com>
Date:   Thu, 13 Feb 2020 11:14:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1581561464-3893-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002130135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9530 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 impostorscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002130135
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/12/20 6:37 PM, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The function apic_lvt_vector() is unused now, remove it.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>   arch/x86/kvm/lapic.c | 5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index eafc631d305c..0b563c280784 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -294,11 +294,6 @@ static inline int apic_lvt_enabled(struct kvm_lapic *apic, int lvt_type)
>   	return !(kvm_lapic_get_reg(apic, lvt_type) & APIC_LVT_MASKED);
>   }
>   
> -static inline int apic_lvt_vector(struct kvm_lapic *apic, int lvt_type)
> -{
> -	return kvm_lapic_get_reg(apic, lvt_type) & APIC_VECTOR_MASK;
> -}
> -
>   static inline int apic_lvtt_oneshot(struct kvm_lapic *apic)
>   {
>   	return apic->lapic_timer.timer_mode == APIC_LVT_TIMER_ONESHOT;

There is one place, lapic_timer_int_injected(), where this function be 
used :

         struct kvm_lapic *apic = vcpu->arch.apic;
-       u32 reg = kvm_lapic_get_reg(apic, APIC_LVTT);

         if (kvm_apic_hw_enabled(apic)) {

-                int vec = reg & APIC_VECTOR_MASK;

+               int vec = apic_lvt_vector(APIC_LVTT);
                  void *bitmap = apic->regs + APIC_ISR;


But since that's the only place I can find, we probably don't need a 
separate function.


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

