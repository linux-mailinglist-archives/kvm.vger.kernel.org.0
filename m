Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59F826696A
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 22:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgIKUM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 16:12:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgIKUMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 16:12:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BKA8Ld014539;
        Fri, 11 Sep 2020 20:10:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Gxyet+Q4AGUZq8o7VWU9MriC7pNGHg2L68F1Zf76gqc=;
 b=qNIbM5cINIQeSa9o3Lay0Z8TYaqQVuk87M6h5iR8sQ1iLrB/zzJmAsZVkjGsovSl+0TJ
 vGx9ToCoVu3xNo8c5WaSjMURwpdxp+IqpWNy6kiFOzfySIcgc4iszbc6l5geZ/DMSJzV
 HJJtnWtyvbL2exAONO5AIVslkI8oqPftSTPm1BqLwvNulQCJKjVthT0JySVnR8T5JHkX
 WQyxZJaunA0ViJkYR9My/loqFC/5KpHVXr4zyAUD1NaKF28j3/YZna5Ezfs9cAM9cjvW
 nY6jBIwligoWkmmUR7bgEvXNaDEGWbUJX/SsVPH2JXnhUAXvhyiAqK9UvE6J4w+QZAlA wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3ang6q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 20:10:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BK5EkN135057;
        Fri, 11 Sep 2020 20:10:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmkdx6ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 20:10:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08BKAesO001237;
        Fri, 11 Sep 2020 20:10:40 GMT
Received: from localhost.localdomain (/10.159.240.141)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 13:10:40 -0700
Subject: Re: [PATCH 2/4 v3] x86: AMD: Add hardware-enforced cache coherency as
 a CPUID feature
To:     Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
References: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
 <20200911192601.9591-3-krish.sadhukhan@oracle.com>
 <c5cbc91e-f576-5cc7-a40c-c11abaea4ad2@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <472e71a4-e50e-1d39-3088-cc103c79ddb3@oracle.com>
Date:   Fri, 11 Sep 2020 13:10:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <c5cbc91e-f576-5cc7-a40c-c11abaea4ad2@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110162
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/11/20 12:36 PM, Dave Hansen wrote:
> On 9/11/20 12:25 PM, Krish Sadhukhan wrote:
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index 81335e6fe47d..0e5b27ee5931 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -293,6 +293,7 @@
>>   #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
>>   #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
>>   #define X86_FEATURE_SPLIT_LOCK_DETECT	(11*32+ 6) /* #AC for split lock */
>> +#define X86_FEATURE_HW_CACHE_COHERENCY (11*32+ 7) /* AMD hardware-enforced cache coherency */
> That's an awfully generic name.  We generally have "hardware-enforced
> cache coherency" already everywhere. :)
>
> This probably needs to say something about encryption, or even SEV
> specifically.


How about X86_FEATURE_ENC_CACHE_COHERENCY ?

> I also don't see this bit in the "AMD64 Architecture
> Programmer’s Manual".  Did I look in the wrong spot somehow?
Section 7.10.6 in APM mentions this.
