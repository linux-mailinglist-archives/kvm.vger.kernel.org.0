Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025AD3F473A
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 11:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbhHWJRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 05:17:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230137AbhHWJRV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 05:17:21 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17N991Rs126581
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 05:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=R5qbfCPhf9j6EaMWIRQ4j6gGy2lfz/DM7A47VYlkYFI=;
 b=FL0Sw+0q1/nYt9p50yr3VQdbz53q3qb6CHxcPfZP8ZnyYc0v6/snciAQjvQCMwFYqIra
 WSrBoWHKenVQxtWKicywN1jWGQbqqO+07TzEM9OpTSGC8XuKqSavX0Cy/rr0vW6wBp6k
 AkcWj79HWensdLPrNi9LchmR1/xa+TlJPsTB25nvP5YGNjsoPJwwAJsuVQlURcxA0Q80
 nHFXe3zH7d8YGw0Oz/LX9OhaFmYsfLMM3Qtg/7rPlv1+pjDYNnmd4PCQ6bbEHm2NRtXQ
 pWJpoginX+GqMlhUepKrGc3Qli6blBL3l2J3CJ30zRuOOa3syDiGFUG7wYqTRbPokWUU NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3am3588dxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 05:16:37 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17N9CE4E140365
        for <kvm@vger.kernel.org>; Mon, 23 Aug 2021 05:16:37 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3am3588dx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 05:16:36 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17N9DPni016848;
        Mon, 23 Aug 2021 09:16:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma05fra.de.ibm.com with ESMTP id 3ajs48ak2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 09:16:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17N9GQRg52691228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 09:16:26 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CAAF5207E;
        Mon, 23 Aug 2021 09:16:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.22.253])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 59C3152057;
        Mon, 23 Aug 2021 09:16:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH 1/1] s390x: css: check the CSS is working
 with any ISC
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1628769189-10699-1-git-send-email-pmorel@linux.ibm.com>
 <1628769189-10699-2-git-send-email-pmorel@linux.ibm.com>
 <b9191517-a20b-f5e4-0e78-a819512ee328@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <be294c38-76c5-ed8a-39ea-478b760eedf3@linux.ibm.com>
Date:   Mon, 23 Aug 2021 11:16:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b9191517-a20b-f5e4-0e78-a819512ee328@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _ok9ppD0qGMV_eo9AKqpxi-EY0SWnSX1
X-Proofpoint-GUID: CGFRH5T-rXD2namdVnlhpOnbw-U5bj7M
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_02:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/18/21 9:40 AM, Thomas Huth wrote:
> On 12/08/2021 13.53, Pierre Morel wrote:
>> In the previous version we did only check that one ISC dedicated by
>> Linux for I/O is working fine.
>>
>> However, there is no reason to prefer one ISC to another ISC, we are
>> free to take anyone.
>>
>> Let's check all possible ISC to verify that QEMU/KVM is really ISC
>> independent.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   s390x/css.c | 25 +++++++++++++++++--------
>>   1 file changed, 17 insertions(+), 8 deletions(-)
>>
>> diff --git a/s390x/css.c b/s390x/css.c
>> index c340c539..aa005309 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -22,6 +22,7 @@
>>   #define DEFAULT_CU_TYPE        0x3832 /* virtio-ccw */
>>   static unsigned long cu_type = DEFAULT_CU_TYPE;
>> +static int io_isc;
>>   static int test_device_sid;
>>   static struct senseid *senseid;
>> @@ -46,7 +47,7 @@ static void test_enable(void)
>>           return;
>>       }
>> -    cc = css_enable(test_device_sid, IO_SCH_ISC);
>> +    cc = css_enable(test_device_sid, io_isc);
>>       report(cc == 0, "Enable subchannel %08x", test_device_sid);
>>   }
>> @@ -67,7 +68,7 @@ static void test_sense(void)
>>           return;
>>       }
>> -    ret = css_enable(test_device_sid, IO_SCH_ISC);
>> +    ret = css_enable(test_device_sid, io_isc);
>>       if (ret) {
>>           report(0, "Could not enable the subchannel: %08x",
>>                  test_device_sid);
>> @@ -142,7 +143,6 @@ static void sense_id(void)
>>   static void css_init(void)
>>   {
>> -    assert(register_io_int_func(css_irq_io) == 0);
>>       lowcore_ptr->io_int_param = 0;
>>       report(get_chsc_scsc(), "Store Channel Characteristics");
>> @@ -351,11 +351,20 @@ int main(int argc, char *argv[])
>>       int i;
>>       report_prefix_push("Channel Subsystem");
>> -    enable_io_isc(0x80 >> IO_SCH_ISC);
>> -    for (i = 0; tests[i].name; i++) {
>> -        report_prefix_push(tests[i].name);
>> -        tests[i].func();
>> -        report_prefix_pop();
>> +
>> +    for (io_isc = 0; io_isc < 8; io_isc++) {
>> +        report_info("ISC: %d\n", io_isc);
> 
> Would it make sense to add the "ISC" string as a prefix with 
> report_prefix_push() instead, so that the tests get individual test names?
> 
>   Thomas
> 

Yes, this would make a better description I think.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
