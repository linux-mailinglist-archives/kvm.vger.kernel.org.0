Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78400395A0F
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 14:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhEaMJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 08:09:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51474 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231367AbhEaMJ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 08:09:26 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VC2wcm093773;
        Mon, 31 May 2021 08:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=cF+VNI/kMHoKxm9fU7usl9VWLr5Esc6VMdvAiwlDG8Y=;
 b=h3+een4EKdk2oWZT+FnUthlq7xSxezltljIxebIQlnMYlXKp6sM7xSGYhR0YFAIACOOu
 if9aEEB1Y9vkVgsFUvNz2+diOkC/VGPg4qbPs8MbWd1JiKFGcKwMFtm5eBMRBmeks5AE
 y+Ll6LGHR0eFUsXLTKLIV3lShgtslupn21+yFlnOfGBDc4ETK2Mnvv/Hd9WkaPIn4YTp
 tFY2+TiZKeAJZuZa8gm8dELeoXwk6fuzdT60Nj/dLA2XplefPiPi14kMTf1l0ctilYQP
 J5tJzazdK9uPtTXmmaEj4ykekNDvpYVOvFWedxab6LLKwAG2jQ+Ld33PqtANn6zyIn0s DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vy6p0kut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 08:07:47 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14VC3HPK095286;
        Mon, 31 May 2021 08:07:46 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38vy6p0kte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 08:07:46 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14VC4rNf005756;
        Mon, 31 May 2021 12:07:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 38ud87rj1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 12:07:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14VC7fTD25887152
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 May 2021 12:07:41 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B732A4068;
        Mon, 31 May 2021 12:07:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45F4EA4064;
        Mon, 31 May 2021 12:07:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.89.221])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 May 2021 12:07:41 +0000 (GMT)
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, cohuck@redhat.com
References: <20210531105003.44737-1-frankja@linux.ibm.com>
 <53383a4f-8841-ae12-3fd0-14bda08801e2@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] s390x: selftest: Fix report output
Message-ID: <333346a3-7ca9-03a5-c01e-43d040aaddff@linux.ibm.com>
Date:   Mon, 31 May 2021 14:07:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <53383a4f-8841-ae12-3fd0-14bda08801e2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yGIsVVbsWh3gdbOHp4qVCR5DnlsR9gJi
X-Proofpoint-GUID: NWkn9OJHJzjsDwg1k51SKgc1MTy11uE9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_08:2021-05-31,2021-05-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105310087
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/31/21 1:15 PM, David Hildenbrand wrote:
> On 31.05.21 12:50, Janosch Frank wrote:
>> To make our TAP parser (and me) happy we don't want to have to reports
>> with exactly the same wording.
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> ---
>>   s390x/selftest.c | 18 +++++++++++++-----
>>   1 file changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/s390x/selftest.c b/s390x/selftest.c
>> index b2fe2e7b..c2ca9896 100644
>> --- a/s390x/selftest.c
>> +++ b/s390x/selftest.c
>> @@ -47,12 +47,19 @@ static void test_malloc(void)
>>   	*tmp2 = 123456789;
>>   	mb();
>>   
>> -	report((uintptr_t)tmp & 0xf000000000000000ul, "malloc: got vaddr");
>> -	report(*tmp == 123456789, "malloc: access works");
>> +	report_prefix_push("malloc");
>> +	report_prefix_push("ptr_0");
> 
> instead of this "ptr_0" vs. "ptr_1" I'd just use
> 
> "allocated 1st page"
> "wrote to 1st page"
> "allocated 2nd page"
> "wrote to 2nd page"
> "1st and 2nd page differ"
> 
> Avoids one hierarchy of prefix_push ...
I'd like to keep them since I'll also move the allocation and writes
into a prefix section for the v2 which will provide me with better error
reports if we trigger asserts.

Also from the allocation alone these could be on the same page since we
allocate ints.

> 
>> +	report((uintptr_t)tmp & 0xf000000000000000ul, "allocated memory");
>> +	report(*tmp == 123456789, "wrote allocated memory");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("ptr_1");
>>   	report((uintptr_t)tmp2 & 0xf000000000000000ul,
>> -	       "malloc: got 2nd vaddr");
>> -	report((*tmp2 == 123456789), "malloc: access works");
>> -	report(tmp != tmp2, "malloc: addresses differ");
>> +	       "allocated memory");
>> +	report((*tmp2 == 123456789), "wrote allocated memory");
>> +	report_prefix_pop();
>> +
>> +	report(tmp != tmp2, "allocated memory addresses differ");
>>   
>>   	expect_pgm_int();
>>   	configure_dat(0);
>> @@ -62,6 +69,7 @@ static void test_malloc(void)
>>   
>>   	free(tmp);
>>   	free(tmp2);
>> +	report_prefix_pop();
>>   }
>>   
>>   int main(int argc, char**argv)
>>
> 
> 

