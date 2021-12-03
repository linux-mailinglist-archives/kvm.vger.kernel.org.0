Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1984676B1
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 12:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380543AbhLCLt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 06:49:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28602 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234517AbhLCLty (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 06:49:54 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3BGTpM029109;
        Fri, 3 Dec 2021 11:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7nEPitOQgvr+4RmmwmtposdjRghdpHuA5VE2oEPOO4A=;
 b=SuHXHhoJqB+BrFMeNMRLQo7UIM8QUL8hk+BVt+i7d4J3KWa2tPUNvF0ZpTXRN0cnTwYN
 rlAU18pnsB77RNxK52oRQQkDaeTs2xpX6MHN6SasncclNvUNxYX4fipNEHFUyQvp3usU
 7JfTh1Wg4aFeqQiHH0gEH5+3VVQApuZEdSn8OCLCLaxaYbiAAAQhPaF3+OZmmBIMRBC8
 Kx14IxyHgal7KTtcZ/pLfw3wZlaRk37YrndBntAcVU9dX/fvt1dk0JC7jUV1Ry7rPB+n
 bcJfY+dNzoJlIEtMRc86935pPAvIvGBZHEEaUQ+MPrpoHJkyWnXBFPeTf3ra7p9aF9cJ eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqj7j8emu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:46:31 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3BHTBk005211;
        Fri, 3 Dec 2021 11:46:30 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqj7j8em8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:46:30 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3Bdi91017632;
        Fri, 3 Dec 2021 11:46:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3ckcaaaks9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 11:46:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3BkOrk26214692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 11:46:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30A4811C05B;
        Fri,  3 Dec 2021 11:46:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C78D011C04C;
        Fri,  3 Dec 2021 11:46:23 +0000 (GMT)
Received: from [9.171.91.109] (unknown [9.171.91.109])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Dec 2021 11:46:23 +0000 (GMT)
Message-ID: <81dce30b-5432-05ab-f2a5-1d995ff51d81@linux.vnet.ibm.com>
Date:   Fri, 3 Dec 2021 12:46:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH] s390x: Add strict mode to specification
 exception interpretation test
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <82750b44-6246-3f3c-4562-3d64d7378448@redhat.com>
 <20211125144726.1414645-1-scgl@linux.ibm.com>
 <6e8f0354-bf35-3e59-c99d-046ee1979d1f@redhat.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <6e8f0354-bf35-3e59-c99d-046ee1979d1f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bqnHSYoOJ1QLe6ujDlskY9cib91EVbJo
X-Proofpoint-GUID: xNV2JNdD2N7mUXGSRVx5d1l5VctocJrO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_06,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/3/21 12:15, Thomas Huth wrote:
> On 25/11/2021 15.47, Janis Schoetterl-Glausch wrote:
>> While specification exception interpretation is not required to occur,
>> it can be useful for automatic regression testing to fail the test if it
>> does not occur.
>> Add a `--strict` argument to enable this.
> 
> Thank you very much for adding this!

Sure :)
> 
> Some comments below...
> 
>> `--strict` takes a list of machine types (as reported by STIDP)
>> for which to enable strict mode, for example
>> `--strict 8562,8561,3907,3906,2965,2964`
>> will enable it for models z15 - z13.
>> Alternatively, strict mode can be enabled for all but the listed machine
>> types by prefixing the list with a `!`, for example
>> `--strict !1090,1091,2064,2066,2084,2086,2094,2096,2097,2098,2817,2818,2827,2828`
>> will enable it for z/Architecture models except those older than z13.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>
>> Apparently my message with inline patch did not make it to the mailing
>> list for some reason, so here's the patch again.
>>
>>   s390x/spec_ex-sie.c | 59 ++++++++++++++++++++++++++++++++++++++++-----
>>   1 file changed, 53 insertions(+), 6 deletions(-)
>>
>> diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
>> index 5dea411..9a063f9 100644
>> --- a/s390x/spec_ex-sie.c
>> +++ b/s390x/spec_ex-sie.c
>> @@ -7,6 +7,7 @@
>>    * specification exception interpretation is off/on.
>>    */
>>   #include <libcflat.h>
>> +#include <stdlib.h>
>>   #include <sclp.h>
>>   #include <asm/page.h>
>>   #include <asm/arch_def.h>
>> @@ -36,7 +37,7 @@ static void reset_guest(void)
>>       vm.sblk->icptcode = 0;
>>   }
>>   -static void test_spec_ex_sie(void)
>> +static void test_spec_ex_sie(bool strict)
>>   {
>>       setup_guest();
>>   @@ -61,14 +62,60 @@ static void test_spec_ex_sie(void)
>>       report(vm.sblk->icptcode == ICPT_PROGI
>>              && vm.sblk->iprcc == PGM_INT_CODE_SPECIFICATION,
>>              "Received specification exception intercept");
>> -    if (vm.sblk->gpsw.addr == 0xdeadbeee)
>> -        report_info("Interpreted initial exception, intercepted invalid program new PSW exception");
>> -    else
>> -        report_info("Did not interpret initial exception");
>> +    {
>> +        const char *msg;
> 
> Could you please move the variable declaration to the beginning of the function? Then you could get rid of the curly brackets and one level of indentation.

Yes.
> 
>> +        msg = "Interpreted initial exception, intercepted invalid program new PSW exception";
>> +        if (strict)
>> +            report(vm.sblk->gpsw.addr == 0xdeadbeee, msg);
>> +        else if (vm.sblk->gpsw.addr == 0xdeadbeee)
>> +            report_info(msg);
>> +        else
>> +            report_info("Did not interpret initial exception");
>> +    }
>>       report_prefix_pop();
>>       report_prefix_pop();
>>   }
>>   +static bool parse_strict(char **argv)
>> +{
>> +    uint16_t machine_id;
>> +    char *list;
>> +    bool ret;
>> +
>> +    if (!*argv)
>> +        return false;
> 
> I think this works ok with out current implementation of argv, but that's an "inofficial" implementation detail, so in case this ever gets changed, it might be better to check argc first before dereferencing argv here ... so could you please add a check for argc, too?

This is required by POSIX, isn't it? But then whether or not we comply with it is another question.
> 
>> +    if (strcmp("--strict", *argv))
>> +        return false;
>> +
>> +    machine_id = get_machine_id();
>> +    list = argv[1];

This needs to be covered by the argc check too, then.

>> +    if (!list) {
>> +        printf("No argument to --strict, ignoring\n");
>> +        return false;
> 
> You could also support --strict without arguments - that could turn on the strict mode unconditionally, I think.

--strict ! works. Granted it's not the best UI, but it is more consistent,
you could do --strict $(get list of ids from somewhere) and if the list is empty the semantics stay the same. 
> 
>> +    }
>> +    if (list[0] == '!') {
>> +        ret = true;
>> +        list++;
>> +    } else
>> +        ret = false;
>> +    while (true) {
>> +        long input = 0;
>> +
>> +        if (strlen(list) == 0)
>> +            return ret;
>> +        input = strtol(list, &list, 16);
>> +        if (*list == ',')
>> +            list++;
>> +        else if (*list != '\0')
>> +            break;
>> +        if (input == machine_id)
>> +            return !ret;
>> +    }
>> +    printf("Invalid --strict argument \"%s\", ignoring\n", list);
>> +    return ret;
>> +}
>> +
>>   int main(int argc, char **argv)
>>   {
>>       if (!sclp_facilities.has_sief2) {
>> @@ -76,7 +123,7 @@ int main(int argc, char **argv)
>>           goto out;
>>       }
>>   -    test_spec_ex_sie();
>> +    test_spec_ex_sie(parse_strict(argv + 1));
>>   out:
>>       return report_summary();
>>   }
>>
> 
>  Thomas
> 

