Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5EE57580
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 02:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfF0A02 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 20:26:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59788 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfF0A02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 20:26:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R0O60q163484;
        Thu, 27 Jun 2019 00:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=6nzqScvxDeX0oOPsA3KRKG2EEMvWiVjL1ERqQ9d6dw8=;
 b=JCKNOGACbV6WBpGHjq7V9dMv+tgcsIHNZzcdEgi5ZEWJO4gfw/Rm6E4L6TenDuImX3DR
 evYzU3QWHwFHedW7oN18TWOdHt9jqy8boM9C0RPAGqPysf1qg37wMP466qumYsV7gx8u
 iuC03trVH1h+3Bxt4UZbKQTZwAehDFxbrboN38ntyZisv/YolaSmkLidqVDPmk02MIm0
 Y2BNcDx9Joa76o5MEKnQ77anA+zEwLrDiyQbKsHSwgy/usHTfWcczr8eTJ/itKju8Tho
 hPfTeDbucCyxVgqa36oWMrYlH0zSX6HplX3PchusmThK1Xp1UkKE/6vBSHqxckMCBIIa Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brtd8yv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 00:26:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R0Q6lx043942;
        Thu, 27 Jun 2019 00:26:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2t99f4r4ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 00:26:16 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5R0QFx1005268;
        Thu, 27 Jun 2019 00:26:15 GMT
Received: from localhost.localdomain (/10.159.235.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 17:26:15 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Reset lapic after boot
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190625121042.8957-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <9df90756-003e-0c0f-984e-07293fdc2eb1@oracle.com>
Date:   Wed, 26 Jun 2019 17:26:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190625121042.8957-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/19 5:10 AM, Nadav Amit wrote:
> Do not assume that the local APIC is in a xAPIC mode after reset.
> Instead reset it first, since it might be in x2APIC mode, from which a
> transition in xAPIC is invalid.
>
> Note that we do not use the existing disable_apic() for the matter,
> since it also re-initializes apic_ops.


Is there any issue if apic_ops is reset ?


>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   x86/cstart64.S | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/x86/cstart64.S b/x86/cstart64.S
> index 9791282..03726a6 100644
> --- a/x86/cstart64.S
> +++ b/x86/cstart64.S
> @@ -118,6 +118,15 @@ MSR_GS_BASE = 0xc0000101
>   	wrmsr
>   .endm
>   
> +lapic_reset:
> +	mov $0x1b, %ecx


Why not use MSR_IA32_APICBASE instead of 0x1b ?


> +	rdmsr
> +	and $~(APIC_EN | APIC_EXTD), %eax
> +	wrmsr
> +	or $(APIC_EN), %eax
> +	wrmsr
> +	ret
> +
>   .macro setup_segments
>   	mov $MSR_GS_BASE, %ecx
>   	rdmsr
> @@ -228,6 +237,7 @@ save_id:
>   	retq
>   
>   ap_start64:
> +	call lapic_reset
>   	call load_tss
>   	call enable_apic
>   	call save_id
> @@ -240,6 +250,7 @@ ap_start64:
>   	jmp 1b
>   
>   start64:
> +	call lapic_reset
>   	call load_tss
>   	call mask_pic_interrupts
>   	call enable_apic
