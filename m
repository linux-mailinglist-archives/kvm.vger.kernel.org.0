Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC64932A6F6
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1838920AbhCBPzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:55:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243412AbhCBIYB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 03:24:01 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12283Rbj119801
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 03:22:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iSsI7EMR5XqwfxXXWxmiI7aXS+At0vvT/UuYpDl2tyA=;
 b=W/3CAZh5CXtdM+F8mSHk4kHr8FobnSmrmqtjX7ZpaCdXUyL95GCo2l4XQnvjWutq3R1k
 3yDPspq89CphOBrzZoqVaQ7JJ5H8zkIDvTn93pJMLL8fGHHrkJCJFmWnTBNjbL/vXvX8
 ACH/xL2uNNcqblbv6qoAn2S8ncfjxZEfeLdc0o+z+yCUdFIUoOxX4TJj7rCAWu9BF6SE
 pHdE7lFKCyxqViKcwq99uw4gwmxvMozmEjUsMIHF/X1qNSrEymL1999eSHaohO3IKQ03
 DHzl4qv0W1OYUEec7Jv1v6BY9mag+c1RTTOhfvF7cGSbePt5fsjIB7lXlEqzd7bOXa7P 6g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371f73mvj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 03:22:30 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12283j64120806
        for <kvm@vger.kernel.org>; Tue, 2 Mar 2021 03:22:29 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 371f73mvhg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 03:22:29 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1228DUjE021893;
        Tue, 2 Mar 2021 08:22:27 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 36yj5319mw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Mar 2021 08:22:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1228MAU436307386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Mar 2021 08:22:10 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FB0CAE04D;
        Tue,  2 Mar 2021 08:22:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24E18AE061;
        Tue,  2 Mar 2021 08:22:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.12.104])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  2 Mar 2021 08:22:24 +0000 (GMT)
To:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com
References: <20210301182830.478145-1-imbrenda@linux.ibm.com>
 <20210301182830.478145-4-imbrenda@linux.ibm.com>
 <2104a18d-e68b-cae8-8f9c-3b49bdde3f19@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: mvpg: skip some tests when
 using TCG
Message-ID: <3b357040-0ddd-eece-39af-0ca04fdf036b@linux.ibm.com>
Date:   Tue, 2 Mar 2021 09:22:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <2104a18d-e68b-cae8-8f9c-3b49bdde3f19@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_02:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1015 adultscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103020066
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/21 6:59 AM, Thomas Huth wrote:
> On 01/03/2021 19.28, Claudio Imbrenda wrote:
>> TCG is known to fail these tests, so add an explicit exception to skip them.
>>
>> Once TCG has been fixed, it will be enough to revert this patch.
>>
>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>> ---
>>   s390x/mvpg.c | 31 +++++++++++++++++++------------
>>   1 file changed, 19 insertions(+), 12 deletions(-)
>>
>> diff --git a/s390x/mvpg.c b/s390x/mvpg.c
>> index 792052ad..148095e0 100644
>> --- a/s390x/mvpg.c
>> +++ b/s390x/mvpg.c
>> @@ -20,6 +20,7 @@
>>   #include <smp.h>
>>   #include <alloc_page.h>
>>   #include <bitops.h>
>> +#include <vm.h>
>>   
>>   /* Used to build the appropriate test values for register 0 */
>>   #define KFC(x) ((x) << 10)
>> @@ -224,20 +225,26 @@ static void test_mmu_prot(void)
>>   	report(clear_pgm_int() == PGM_INT_CODE_PROTECTION, "destination read only");
>>   	fresh += PAGE_SIZE;
>>   
>> -	protect_page(fresh, PAGE_ENTRY_I);
>> -	cc = mvpg(CCO, fresh, source);
>> -	report(cc == 1, "destination invalid");
>> -	fresh += PAGE_SIZE;
>> +	if (vm_is_tcg()) {
>> +		report_skip("destination invalid");
>> +		report_skip("source invalid");
>> +		report_skip("source and destination invalid");
> 
> You could also use report_xfail(vm_is_tcg(), ...) instead. That shows that 
> there are still problems without failing CI runs.

If I remember correctly we fail with a PGM so we would also need to add
a expect_pgm_int() call before each test when running under tcg
therefore it's not just a 1:1 replacement in this case.

But yes, I'd also like an indication why we're skipping. A comment and a
TCG prefix for skips should be enough.


> 
> Anyway:
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

