Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5652B8D61
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 09:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgKSIci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 03:32:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36982 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726096AbgKSIch (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 03:32:37 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ83Q6K135058;
        Thu, 19 Nov 2020 03:32:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QaDbqpE8z/vvKNWTQasQcbsIH8OFuGAS+d7mrFK3LRM=;
 b=IdTyGbEeTcKKMkTBubOBd3C7N2mYUA1iOR/av/uOdjgUZSR7p8Kkr8c1O50CYzm+A1g/
 yIPdLosWAzi53uQRurxtc/4GO7nJON+Njyd/STwJBKJGAVfZ5S1WTX06AFTBCLYHtuvN
 cwgeRMM8pPT0m0Jzbrus3NOaIZikqaIcEaZUF0H9zNwRls4eI/s7+aRMH1aM/SvipPbm
 YWO2nGBAFynCYhXAFrEugZExYOLGz11NwGBGS8aFjBp7vSu9CXsPUMgYRc1Xv6k6NW9H
 7Tat3OxC76/pdNwH3dhEzRkRR1zcwGAWzAiAwwutBOGf8RYi7kln/5A0PPNZePxhTjZ6 mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg12qnru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 03:32:36 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJ86Bfi154918;
        Thu, 19 Nov 2020 03:32:36 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34wg12qnpu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 03:32:36 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJ8RrZt011874;
        Thu, 19 Nov 2020 08:32:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 34t6ghaj98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 08:32:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJ8WUNx6357728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 08:32:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2DA6AE055;
        Thu, 19 Nov 2020 08:32:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62342AE051;
        Thu, 19 Nov 2020 08:32:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.72.189])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 08:32:30 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: Add test_bit to library
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
References: <20201117154215.45855-1-frankja@linux.ibm.com>
 <20201117154215.45855-2-frankja@linux.ibm.com>
 <6d61a28d-d822-b9b5-8ec6-1ea0dca1ed70@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <b2ca7724-3390-fedc-4c4f-367ecbdea682@linux.ibm.com>
Date:   Thu, 19 Nov 2020 09:32:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <6d61a28d-d822-b9b5-8ec6-1ea0dca1ed70@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_05:2020-11-17,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/20 9:26 AM, Thomas Huth wrote:
> On 17/11/2020 16.42, Janosch Frank wrote:
>> Query/feature bits are commonly tested via MSB bit numbers on
>> s390. Let's add test bit functions, so we don't need to copy code to
>> test query bits.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>  lib/s390x/asm/bitops.h   | 16 ++++++++++++++++
>>  lib/s390x/asm/facility.h |  3 ++-
>>  2 files changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
>> index e7cdda9..a272dd7 100644
>> --- a/lib/s390x/asm/bitops.h
>> +++ b/lib/s390x/asm/bitops.h
>> @@ -7,4 +7,20 @@
>>  
>>  #define BITS_PER_LONG	64
>>  
>> +static inline bool test_bit(unsigned long nr,
>> +			    const volatile unsigned long *ptr)
>> +{
>> +	const volatile unsigned char *addr;
>> +
>> +	addr = ((const volatile unsigned char *)ptr);
>> +	addr += (nr ^ (BITS_PER_LONG - 8)) >> 3;
>> +	return (*addr >> (nr & 7)) & 1;
>> +}
>> +
>> +static inline bool test_bit_inv(unsigned long nr,
>> +				const volatile unsigned long *ptr)
>> +{
>> +	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
>> +}
> 
> I think you should mention in the patch description that these functions
> match the implementations in the kernel (and thus are good for kernel
> developers who are used to these).

There are only so many ways one can write 4 lines of code :-)

> 
> Thus I think you should also now add a license statement to this file
> ("SPDX-License-Identifier: GPL-2.0" or so).

Definitely, thanks for reminding me

> 
> With these modifications:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks

