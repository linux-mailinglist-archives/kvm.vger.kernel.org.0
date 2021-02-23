Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF400322E09
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 16:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhBWPxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 10:53:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233330AbhBWPxj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 10:53:39 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NFWxor119989
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:52:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O8xzakvZZ4I29eWmlvk1GTXlxNvfoAym8blyw6df/C8=;
 b=SdEU/l7tL56URq/4T7FjVOp++WqbHDiijF0Kmr2oUJEEF61ehjoAywlNFqvWGfPkT+ao
 B0O+fnyL5LHxMzdJfoaYwK1bWegm5biPIdVsQP0iwAMGEjrtiNaRx308MEUoUgUwr3p/
 SgX4nBe3dapraJfjHKMFN+VyPYdz26+4sBy4vqB9vHTAccDlMQHQ9BBfcv3GmJe0CKhG
 nyDlHfi43434zgFuIZZKj8E5h70p1g/+HTZKlkMGP68pvaNYddwxF4cg/bMCMR3JHOnl
 RdDsVSPlF7DLObE2c1Ox2FMQZftx/KWVMH7MzgkLCnhDogdx95sugy3u5WcXs/5PXnKb bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg36anx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:52:57 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NFY99I125383
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:52:57 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg36amv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:52:57 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NFpw2H025146;
        Tue, 23 Feb 2021 15:52:54 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 36tt289eep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:52:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NFqpME41550334
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:52:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF77652052;
        Tue, 23 Feb 2021 15:52:51 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.57])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 855F952054;
        Tue, 23 Feb 2021 15:52:51 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 5/5] s390x: css: testing measurement
 block format 1
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
 <1613669204-6464-6-git-send-email-pmorel@linux.ibm.com>
 <20210223142946.2ac05ca7.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <b5654d8b-f12f-055f-9abb-250cb6e9c561@linux.ibm.com>
Date:   Tue, 23 Feb 2021 16:52:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223142946.2ac05ca7.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=999 mlxscore=0 impostorscore=0 bulkscore=0 spamscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102230131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/23/21 2:29 PM, Cornelia Huck wrote:
> On Thu, 18 Feb 2021 18:26:44 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Measurement block format 1 is made available by the extended
>> measurement block facility and is indicated in the SCHIB by
>> the bit in the PMCW.
>>
>> The MBO is specified in the SCHIB of each channel and the MBO
>> defined by the SCHM instruction is ignored.
>>
>> The test of the MB format 1 is just skipped if the feature is
>> not available.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h     | 16 ++++++++++++++
>>   lib/s390x/css_lib.c | 25 ++++++++++++++++++++-
>>   s390x/css.c         | 53 +++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 93 insertions(+), 1 deletion(-)
>>
> 
> (...)
> 
>> diff --git a/lib/s390x/css_lib.c b/lib/s390x/css_lib.c
>> index 4c8a6ae..1f09f93 100644
>> --- a/lib/s390x/css_lib.c
>> +++ b/lib/s390x/css_lib.c
>> @@ -298,7 +298,7 @@ static bool schib_update_mb(int schid, uint64_t mb, uint16_t mbi,
>>   			pmcw->flags2 &= ~PMCW_MBF1;
>>   
>>   		pmcw->mbi = mbi;
>> -		schib.mbo = mb;
>> +		schib.mbo = mb & ~0x3f;

indeed, looks like a later change.


...snip...
>> + */
>> +static void test_schm_fmt1(void)
>> +{
>> +	
...snip...
>> +	/* Expect success */
>> +	report_prefix_push("Valid MB address and index");
>> +	report(start_measure((u64)mb1, 0, true) &&
>> +	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
>> +	       "SSCH measured %d", mb1->ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	schm(NULL, 0); /* Stop the measurement */
> 
> Same here, I think you should call css_disable_mb().

I agree.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
