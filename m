Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C4732636D
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 14:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBZNfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 08:35:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3894 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhBZNfM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 08:35:12 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11QDYOQv010280
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 08:34:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bJYQ9p9kpDti/puJPsPLZx/hHwTQz9jfxXRxivB1xY0=;
 b=KA4yNGID2p19q+zCp3ynhawFhKVSqmWugjswqjFOcCtOFRIKVyk0juwAxKkrovRKYqm6
 Kqw2YRzM9kTlwHzMScrA8gaxndB1odGvdZvwZ1u8eqZroF5cQ/Xo0xM5/m2bdns8Ewhl
 CIXnREdHzox7G0GJ1V7z1I1BUwrzhYAhfH/7E9BlmFlk0wIR06AWHTnuk7yWPdyFMOVP
 V6itk9MDxwGij8Aut5pkz9p4ydm4vd9jMsr0beeaObKLCXUgv5Bhchglba5ez5fkvpH6
 H57rOyYHpDGVANY99xe2jSvY3oWp12jyB1O/hrJnHYTBsVNw2qwSOMVnCO9oL8VJYWhZ 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36y02suuum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 08:34:29 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11QDYTve010650
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 08:34:29 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36y02suuty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 08:34:29 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11QDVxgR015192;
        Fri, 26 Feb 2021 13:34:27 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 36tt28atgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 13:34:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11QDYO5t42402114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 13:34:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A06711C04A;
        Fri, 26 Feb 2021 13:34:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E21F11C050;
        Fri, 26 Feb 2021 13:34:24 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.145.240])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Feb 2021 13:34:24 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 5/5] s390x: css: testing measurement
 block format 1
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
 <1613669204-6464-6-git-send-email-pmorel@linux.ibm.com>
 <3041cee9-a5b8-1745-5455-f7728ae4d232@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <47029f68-2bdc-a5ed-f3be-2573b5989899@linux.ibm.com>
Date:   Fri, 26 Feb 2021 14:34:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3041cee9-a5b8-1745-5455-f7728ae4d232@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-26_02:2021-02-24,2021-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/26/21 11:02 AM, Janosch Frank wrote:
> On 2/18/21 6:26 PM, Pierre Morel wrote:
>> Measurement block format 1 is made available by the extended
>> measurement block facility and is indicated in the SCHIB by
>> the bit in the PMCW.

...

>> +void msch_with_wrong_fmt1_mbo(unsigned int schid, uint64_t mb)
>> +{
>> +	struct pmcw *pmcw = &schib.pmcw;
>> +	int cc;
>> +
>> +	/* Read the SCHIB for this subchannel */
>> +	cc = stsch(schid, &schib);
>> +	if (cc) {> +		report(0, "stsch: sch %08x failed with cc=%d", schid, cc);
>> +		return;
>> +	}
>> +
>> +	/* Update the SCHIB to enable the measurement block */
>> +	pmcw->flags |= PMCW_MBUE;
>> +	pmcw->flags2 |= PMCW_MBF1;
>> +	schib.mbo = mb;
>> +
>> +	/* Tell the CSS we want to modify the subchannel */
>> +	expect_pgm_int();
>> +	cc = msch(schid, &schib);
>> +	check_pgm_int_code(PGM_INT_CODE_OPERAND);
> 
> Why would you expect a PGM in a library function are PGMs normal for IO
> instructions? oO
> 
> Is this a test function which should be part of your test file in
> s390x/*.c or is it part of the IO library which should:
> 
>   - Abort if an initialization failed and we can assume that future tests
> are now useless
>   - Return an error so the test can report an error
>   - Return success



Now it looks clear to me that this test belongs to the tests and not the 
lib.
I put it there to avoid exporting the SCHIB, but after all, why not 
exporting the SCHIB, we may need access to it from other tests again in 
the future.



> 
>> +}
>> diff --git a/s390x/css.c b/s390x/css.c
>> index b65aa89..576df48 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -257,6 +257,58 @@ end:
>>   	report_prefix_pop();
>>   }
>>   
>> +/*
>> + * test_schm_fmt1:
>> + * With measurement block format 1 the mesurement block is
>> + * dedicated to a subchannel.
>> + */
>> +static void test_schm_fmt1(void)
>> +{
>> +	struct measurement_block_format1 *mb1;
>> +
>> +	report_prefix_push("Format 1");
>> +
>> +	if (!test_device_sid) {
>> +		report_skip("No device");
>> +		goto end;
>> +	}

...

>> +	report(start_measure((u64)mb1, 0, true) &&
>> +	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
>> +	       "SSCH measured %d", mb1->ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	schm(NULL, 0); /* Stop the measurement */
>> +	free_io_mem(mb1, sizeof(struct measurement_block_format1));
>> +end:
>> +	report_prefix_pop();
>> +}
>> +
>>   static struct {
>>   	const char *name;
>>   	void (*func)(void);
>> @@ -268,6 +320,7 @@ static struct {
>>   	{ "sense (ssch/tsch)", test_sense },
>>   	{ "measurement block (schm)", test_schm },
>>   	{ "measurement block format0", test_schm_fmt0 },
>> +	{ "measurement block format1", test_schm_fmt1 },
> 
> Output will then be:
> "measurement block format1: Format 1: Report message"
> 
> Wouldn't it make more sense to put the format 0 and 1 tests into
> test_schm() so we'd have:
> "measurement block (schm): Format 0: Report message" ?

too much prefix push...
rationalizing will make the goto disapear...

Thanks for review
Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
