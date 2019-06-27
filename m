Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC76C5754C
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 02:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfF0ANm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 20:13:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52730 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfF0ANm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 20:13:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R09rQm159735;
        Thu, 27 Jun 2019 00:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=pzSD36RkCTxZXXTaDhpTyuGuXdJLSx6Ya7LTPsidmqc=;
 b=wjrd+y9OCxrkF2ZBG4oPP13gp1lpvk6w1kzTPQ9yQBcMFsDfU/h29csjNAUQ7Mt/pPLB
 +WqWVodMxfIk0lVOoUStDD3/rS1T5qXzow1JIf24KTs1+Bb9LjPMth7Gw+fK6jeJYPR8
 fdvMAwtx3mMtQDIUwK2KyI5h/o7fVOvn1OpGOA0rBkn1FYWYE8E7Ghm479+NXGOchf6L
 6XF9w8oaoKUxgl8gwbVuuOUoNdIPUpgsiYec3jr+LtpGzhIce0LLA09EftlHfiYa0I5m
 1cz/e3DgVuFqETONeFtQYwJFpldp7V+2Ll1OPrvytlWr4tzi7jQvHKKP/Apc+diEw4vY Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t9cyqn452-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 00:13:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5R0BYos153225;
        Thu, 27 Jun 2019 00:13:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t9accyjp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 00:13:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5R0DPAt031649;
        Thu, 27 Jun 2019 00:13:25 GMT
Received: from localhost.localdomain (/10.159.235.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 17:13:25 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: vmx: Consider CMCI enabled based on
 IA32_MCG_CAP[10]
To:     Nadav Amit <nadav.amit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>
References: <20190625120756.8781-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <0f1322a1-6019-97e8-178a-70556dc349d4@oracle.com>
Date:   Wed, 26 Jun 2019 17:13:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190625120756.8781-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/25/19 5:07 AM, Nadav Amit wrote:
> CMCI is enabled if IA32_MCG_CAP[10] is set. VMX tests do not respect
> this condition. Fix it.
>
> Cc: Marc Orr <marcorr@google.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   x86/vmx_tests.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3731757..1776e46 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -5855,6 +5855,11 @@ static u64 virt_x2apic_mode_nibble1(u64 val)
>   	return val & 0xf0;
>   }
>   
> +static bool is_cmci_enabled(void)
> +{
> +	return rdmsr(MSR_IA32_MCG_CAP) & BIT_ULL(10);
> +}
> +
>   static void virt_x2apic_mode_rd_expectation(
>   	u32 reg, bool virt_x2apic_mode_on, bool disable_x2apic,
>   	bool apic_register_virtualization, bool virtual_interrupt_delivery,
> @@ -5862,8 +5867,10 @@ static void virt_x2apic_mode_rd_expectation(
>   {
>   	bool readable =
>   		!x2apic_reg_reserved(reg) &&
> -		reg != APIC_EOI &&
> -		reg != APIC_CMCI;
> +		reg != APIC_EOI;
> +
> +	if (reg == APIC_CMCI && !is_cmci_enabled())
> +		readable = false;
>   
>   	expectation->rd_exit_reason = VMX_VMCALL;
>   	expectation->virt_fn = virt_x2apic_mode_identity;
> @@ -5893,9 +5900,6 @@ static void virt_x2apic_mode_rd_expectation(
>    * For writable registers, get_x2apic_wr_val() deposits the write value into the
>    * val pointer arg and returns true. For non-writable registers, val is not
>    * modified and get_x2apic_wr_val() returns false.
> - *
> - * CMCI, including the LVT CMCI register, is disabled by default. Thus,
> - * get_x2apic_wr_val() treats this register as non-writable.
>    */
>   static bool get_x2apic_wr_val(u32 reg, u64 *val)
>   {
> @@ -5930,6 +5934,11 @@ static bool get_x2apic_wr_val(u32 reg, u64 *val)
>   		 */
>   		*val = apic_read(reg);
>   		break;
> +	case APIC_CMCI:
> +		if (!is_cmci_enabled())
> +			return false;
> +		*val = apic_read(reg);
> +		break;
>   	case APIC_ICR:
>   		*val = 0x40000 | 0xf1;
>   		break;


Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

