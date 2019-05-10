Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0881A5A1
	for <lists+kvm@lfdr.de>; Sat, 11 May 2019 01:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbfEJXt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 19:49:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43670 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfEJXt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 19:49:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ANmcXG194326;
        Fri, 10 May 2019 23:49:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oBZXVW2IptsAAp6XcLYvGQ1xqLS1XAEpZRuSgeN8qaQ=;
 b=kYsuAO6M5HZ8UXwDYOmWnnO3QH3/rZugbsaoYseUX/hCCxqD55kuWCQfwo7uONGkVKyH
 y5FJNrfMTHhWSBmYYiJsVfs0wHk5KnvlDBI5kmAPho5LLMdHfOej985gsQ2Os9kFGbEX
 AHdwz9DTvuqNtX4J7T6bMgce0+jQ744nCGkGQrMUgjTwV1us+jIrkI5/THhdDX4q+3Rr
 xlUUUyPtSq9Qj25I4LGzp9IZ6d15kNQG7EYJPjNoKaaw+0iEuWksndDJbDcZtVHUs0Et
 DX/JM97YSHK0wrpy9h+03agqhIfZyh9dtW1H2x8ubfT4nZasYPsbxsBnLqA0aQN6vaPX sA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s94b1bxae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 23:49:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4ANndbn099358;
        Fri, 10 May 2019 23:49:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s94ahmraa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 23:49:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4ANnk7C026826;
        Fri, 10 May 2019 23:49:46 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 23:49:45 +0000
Subject: Re: [kvm-unit-tests PATCH] x86: Restore VMCS state when
 test_vmcs_addr() is done
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190502145741.7863-1-nadav.amit@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a9417280-db71-4e24-02d6-abc00f96c402@oracle.com>
Date:   Fri, 10 May 2019 16:49:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190502145741.7863-1-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9253 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100149
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9253 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100150
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/02/2019 07:57 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>
>
> The VMCS fields of APIC_VIRT_ADDR and TPR_THRESHOLD are modified by
> test_vmcs_addr() but are not restored to their original value. Save and
> restore them.
>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>   x86/vmx_tests.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index e9010af..2d6b12d 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -4432,6 +4432,8 @@ static void test_tpr_threshold_values(void)
>   static void test_tpr_threshold(void)
>   {
>   	u32 primary = vmcs_read(CPU_EXEC_CTRL0);
> +	u64 apic_virt_addr = vmcs_read(APIC_VIRT_ADDR);
> +	u64 threshold = vmcs_read(TPR_THRESHOLD);
>   	void *virtual_apic_page;
>   
>   	if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW))
> @@ -4451,11 +4453,8 @@ static void test_tpr_threshold(void)
>   	report_prefix_pop();
>   
>   	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
> -	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES)))) {
> -		vmcs_write(CPU_EXEC_CTRL0, primary);
> -		return;
> -	}
> -
> +	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES))))
> +		goto out;
>   	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
>   
>   	if (ctrl_cpu_rev[1].clr & CPU_VINTD) {
> @@ -4505,6 +4504,9 @@ static void test_tpr_threshold(void)
>   	}
>   
>   	vmcs_write(CPU_EXEC_CTRL1, secondary);
> +out:
> +	vmcs_write(TPR_THRESHOLD, threshold);
> +	vmcs_write(APIC_VIRT_ADDR, apic_virt_addr);
>   	vmcs_write(CPU_EXEC_CTRL0, primary);
>   }
>   

The function name in the commit message (both header and body) is 
incorrect. It should be "test_tpr_threshold".
