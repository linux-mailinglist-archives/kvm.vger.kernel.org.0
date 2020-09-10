Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AA3264F0B
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 21:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgIJTdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 15:33:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59048 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgIJTcA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 15:32:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AJTibK011484;
        Thu, 10 Sep 2020 19:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=46NWe0Vb+A8wfIEGsPd+2jvvuf056Sx4VJre0mHCvPI=;
 b=Da8mOq3wtHC9JovtTSqYhytCxRp2+T1Gtq51Pfno7IhZfvvUignBX3cPrzVp44UdQks+
 W35rs3b/FLWWl4eaukkPWCT/TVmrh6AR12wj7EWPhfS0VOpd/3PkKWQRnF5pPghKv9QT
 iYeCD84JHC1N8uMDnLYiUIIhs5B1zaqqhOovW2uIFgGijY8GWxXQkclhEQKO0VOOLxPQ
 HaLEoSCYbCguprZaANAgOZeBYh4yx7drUjks3FT2KZx566dSAwntDbQ3FBVKmHIW5tfI
 4PzunS/s6jKUdaD1VRyLe7aYtas88R7CEMFMxnYMFU/D/lDe4owhpeLgJ471QHg1jJin zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 33c23ra8ek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 19:31:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08AJTXcL007409;
        Thu, 10 Sep 2020 19:29:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33cmevjmx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 19:29:52 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08AJTpXr018053;
        Thu, 10 Sep 2020 19:29:51 GMT
Received: from localhost.localdomain (/10.159.235.45)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 10 Sep 2020 12:29:51 -0700
Subject: Re: [PATCH 3/3 v2] KVM: SVM: Don't flush cache of encrypted pages if
 hardware enforces cache coherenc
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
References: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
 <20200910022211.5417-4-krish.sadhukhan@oracle.com>
 <743d5a76-4ae6-7692-70ad-eaae12edac46@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <1b3df921-9d98-b6d5-801b-ca8b201f1cad@oracle.com>
Date:   Thu, 10 Sep 2020 12:29:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <743d5a76-4ae6-7692-70ad-eaae12edac46@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100178
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9740 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100178
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/10/20 7:43 AM, Tom Lendacky wrote:
> On 9/9/20 9:22 PM, Krish Sadhukhan wrote:
>> Some hardware implementations may enforce cache coherency across 
>> encryption
>> domains. In such cases, it's not required to flush encrypted pages off
>> cache lines.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/kvm/svm/sev.c       | 3 ++-
>>   arch/x86/mm/pat/set_memory.c | 6 ++++--
>>   2 files changed, 6 insertions(+), 3 deletions(-)
>
> You should probably split this patch into two patches, one for the KVM 
> usage and one for the MM usage with appropriate subjects prefixes at 
> that point. Also, you need to then copy the proper people. Did you run 
> these patches through get_maintainer.pl?

I will split it into two patches and copy the relevant people and 
distribution lists.
>
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 402dc4234e39..8aa2209f2637 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -384,7 +384,8 @@ static void sev_clflush_pages(struct page 
>> *pages[], unsigned long npages)
>>       uint8_t *page_virtual;
>>       unsigned long i;
>>   -    if (npages == 0 || pages == NULL)
>> +    if (this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY) || npages == 0 ||
>> +        pages == NULL)
>>           return;
>>         for (i = 0; i < npages; i++) {
>> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
>> index d1b2a889f035..5e2c618cbe84 100644
>> --- a/arch/x86/mm/pat/set_memory.c
>> +++ b/arch/x86/mm/pat/set_memory.c
>> @@ -1999,7 +1999,8 @@ static int __set_memory_enc_dec(unsigned long 
>> addr, int numpages, bool enc)
>>       /*
>>        * Before changing the encryption attribute, we need to flush 
>> caches.
>>        */
>> -    cpa_flush(&cpa, 1);
>> +    if (!this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY))
>> +        cpa_flush(&cpa, 1);
>
> This bit is only about cache coherency, so the TLB flush is still 
> needed, so this should be something like:
>
>     cpa_flush(&cpa, !this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY));


Agreed. Will fix it.

>
>>         ret = __change_page_attr_set_clr(&cpa, 1);
>>   @@ -2010,7 +2011,8 @@ static int __set_memory_enc_dec(unsigned long 
>> addr, int numpages, bool enc)
>>        * flushing gets optimized in the cpa_flush() path use the same 
>> logic
>>        * as above.
>>        */
>> -    cpa_flush(&cpa, 0);
>> +    if (!this_cpu_has(X86_FEATURE_HW_CACHE_COHERENCY))
>> +        cpa_flush(&cpa, 0);
>
> This should not be changed, still need the call to do the TLB flush.
>
> Thanks,
> Tom
>
>>         return ret;
>>   }
>>
