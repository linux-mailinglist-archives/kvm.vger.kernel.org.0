Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDE53EA702
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 17:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237455AbhHLPAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 11:00:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237129AbhHLPAc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 11:00:32 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CEX2c1131538
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=F+DnVrixQHtphiIbwcP+pveyz6BrSx7Vwt80YqkNA2I=;
 b=EmCTQJEbY/Qg1cnM3GRPOMi+05MmYsh/9c7PUDEKMob/sfa/9M5OCh7I4bM+WjQFixqR
 R7mSGVqNrI+LB2IsAhOwe65Hj3g/WnOemmg8+7hg3HgDVYwR0/QY4lI9js5yxWWA8sLy
 eBeyPPP8Mfh98ec/k+dFGzTc+ZOAN04PcqD6/TdzBsKs7M8fY5P8avSjMz3EY7jUZlyG
 60p56nKfAUu/rRupk6eZczEJTAyX7SwK9dlTrtCDGZg5uIucH8kg5tnQS57TpE0qGDdz
 elFBscZ/saYjMyn3NfO2eavQYS3FvfcJDh47ex34sMD00bksGjXWD81PlLj2TZLn9gVN ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acy935exw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:00:06 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17CEXLC8133429
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:00:05 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3acy935eve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 11:00:05 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17CEwF1d024956;
        Thu, 12 Aug 2021 15:00:03 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3acn76a4qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 15:00:03 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17CExxOx55705996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 14:59:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C48FE4C063;
        Thu, 12 Aug 2021 14:59:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78AEB4C04A;
        Thu, 12 Aug 2021 14:59:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.85.233])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Aug 2021 14:59:59 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: css: check the CSS is working
 with any ISC
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1628769189-10699-1-git-send-email-pmorel@linux.ibm.com>
 <1628769189-10699-2-git-send-email-pmorel@linux.ibm.com>
 <87fsvevo7p.fsf@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <276c5be3-2e57-d29c-a179-3b59e8b69fe1@linux.ibm.com>
Date:   Thu, 12 Aug 2021 16:59:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87fsvevo7p.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aydZv4deCZrnUEz2Ral2wIFrDsy6xprm
X-Proofpoint-ORIG-GUID: y7gvg6rFXqKgZu-EGAW_92dXW1QutONt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-12_05:2021-08-12,2021-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/12/21 2:31 PM, Cornelia Huck wrote:
> On Thu, Aug 12 2021, Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> In the previous version we did only check that one ISC dedicated by
>> Linux for I/O is working fine.
>>
>> However, there is no reason to prefer one ISC to another ISC, we are
>> free to take anyone.
>>
>> Let's check all possible ISC to verify that QEMU/KVM is really ISC
>> independent.
> 
> It's probably a good idea to test for a non-standard isc. Not sure
> whether we need all of them, but it doesn't hurt.
> 
> Do you also have plans for a test to verify the priority handling for
> the different iscs?

No, I did not think about this yet.


> 
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 25 +++++++++++++++++--------
>>   1 file changed, 17 insertions(+), 8 deletions(-)
>>
> 
> (...)
> 
>> @@ -142,7 +143,6 @@ static void sense_id(void)
>>   
>>   static void css_init(void)
>>   {
>> -	assert(register_io_int_func(css_irq_io) == 0);
>>   	lowcore_ptr->io_int_param = 0;
>>   
>>   	report(get_chsc_scsc(), "Store Channel Characteristics");
>> @@ -351,11 +351,20 @@ int main(int argc, char *argv[])
>>   	int i;
>>   
>>   	report_prefix_push("Channel Subsystem");
>> -	enable_io_isc(0x80 >> IO_SCH_ISC);
>> -	for (i = 0; tests[i].name; i++) {
>> -		report_prefix_push(tests[i].name);
>> -		tests[i].func();
>> -		report_prefix_pop();
>> +
>> +	for (io_isc = 0; io_isc < 8; io_isc++) {
>> +		report_info("ISC: %d\n", io_isc);
>> +
>> +		enable_io_isc(0x80 >> io_isc);
>> +		assert(register_io_int_func(css_irq_io) == 0);
> 
> Why are you registering/deregistering the irq handler multiple times? It
> should be the same, regardless of the isc?

Yes, right, did not pay attention when pushing all in the loop,
I will get it out of the loop.

Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
