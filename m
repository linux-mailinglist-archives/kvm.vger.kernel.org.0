Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D63BC9D15
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 13:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfJCLVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 07:21:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58872 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbfJCLVs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 07:21:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93BKtFP077082;
        Thu, 3 Oct 2019 11:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=r4fTn8v6IGQxS08sc1goJtM+I/0/djaSKLGXMb40fsQ=;
 b=e5yyq1MXb9D1cVJWuSpSzQlncmeIGGVzbUJi1XYPsgWf3uJ5TmIe9IwU8e9ny9xUFe5l
 5wbE6dydFNwoYWxokzezK4H7V3w/tU9sp0W6alvQU5VvqcAkrSKIdtI/UXym9i+xuqOB
 9cvzaWMqOx3sBK3AZdouei990kc7BSUEnboi3tLw6ycwyWyCrn5SJR1Pvpz8PgNPVHbb
 Gvgbvsl2zkWDbQFqbtFPAMbUuGijQyw9SHbDRrDs4uVF3+I1lbpdv2SL01GMijCC6xx/
 3Q2WKLjRNZiQaTIv5L1iG9MoZVVkjYXUhkZJraIihTkWYe82AHLha5L2AEyLaeDh/Mvv /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2v9yfqk6nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 11:21:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x93BKLY5174632;
        Thu, 3 Oct 2019 11:21:18 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vcg63e8b2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Oct 2019 11:21:18 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x93BLECk026220;
        Thu, 3 Oct 2019 11:21:14 GMT
Received: from [10.191.0.240] (/10.191.0.240)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Oct 2019 04:21:14 -0700
Subject: Re: [PATCH v3 3/4] xen: Mark "xen_nopvspin" parameter obsolete and
 map it to "nopvspin"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1569847479-13201-1-git-send-email-zhenzhong.duan@oracle.com>
 <1569847479-13201-4-git-send-email-zhenzhong.duan@oracle.com>
 <20191002171805.GD9615@linux.intel.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <cbfb13ec-bd0c-d9df-e61e-8a08f2c9f526@oracle.com>
Date:   Thu, 3 Oct 2019 19:21:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191002171805.GD9615@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910030106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9398 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910030106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/3 1:18, Sean Christopherson wrote:
> On Mon, Sep 30, 2019 at 08:44:38PM +0800, Zhenzhong Duan wrote:
>> Fix stale description of "xen_nopvspin" as we use qspinlock now.
>>
>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>> Reviewed-by: Juergen Gross<jgross@suse.com>
>> Cc: Jonathan Corbet<corbet@lwn.net>
>> Cc: Boris Ostrovsky<boris.ostrovsky@oracle.com>
>> Cc: Juergen Gross<jgross@suse.com>
>> Cc: Stefano Stabellini<sstabellini@kernel.org>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Ingo Molnar<mingo@redhat.com>
>> Cc: Borislav Petkov<bp@alien8.de>
>> Cc: "H. Peter Anvin"<hpa@zytor.com>
>> ---
...snip
>> @@ -93,7 +92,7 @@ void xen_init_lock_cpu(int cpu)
>>   
>>   void xen_uninit_lock_cpu(int cpu)
>>   {
>> -	if (!xen_pvspin)
>> +	if (!pvspin)
>>   		return;
>>   
>>   	unbind_from_irqhandler(per_cpu(lock_kicker_irq, cpu), NULL);
>> @@ -117,9 +116,9 @@ void __init xen_init_spinlocks(void)
>>   
>>   	/*  Don't need to use pvqspinlock code if there is only 1 vCPU. */
>>   	if (num_possible_cpus() == 1)
>> -		xen_pvspin = false;
>> +		pvspin = false;
> As suggested in the other patch, if you incorporate pvspin (or nopvspin)
> into xen_pvspin then the param can be __initdata and the diff for this
> patch will be smaller, e.g. you wouldn't need the xen_domain() shenanigans
> in xen_parse_nopvspin().

Ok, will fix. Thanks

Zhenzhong

