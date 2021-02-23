Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1EB322DF3
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 16:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhBWPvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 10:51:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41450 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233022AbhBWPup (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 10:50:45 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NFX0im039915
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:50:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jOUUzXm95wxAUhdxGw7yZknvCh+24EwYa1HAZp1rD+c=;
 b=krAOjYZkxhguTM7ieH5UPv+8i8hlsEty/7oTwoh0eGvvVP9yZKMvOTsjraMEbyCpEgA6
 xELWvasFi43AmhWsubD3cHezhe5S1y8xw1f8wnCDaZxVrVgx00h6VmRQoiHI5jRJOPvR
 QxoJcCCfmAB4YTyseympl0Vpn1VxYhXDwfE0lc48gWMcR4WauIhrh3DstCxpHODWSozk
 a7RRVz+vLQwQEOaqDckbpMOm5L1hR/MJ6VXSx/3sw+MS7+FpU9CMjnqI11xHJagnApkq
 K3xxueiwNqRyWe4lU1M1hgCDY/K318pzeP/rKw77pxpKJQGhLdvvORw1KAFUXMwitFqu Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkejqpf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:50:02 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NFYfXK047777
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 10:50:02 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vkejqpd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 10:50:02 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NFgd9o016600;
        Tue, 23 Feb 2021 15:50:00 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 36tt289edp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 15:50:00 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NFniTR35062086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:49:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6696E52052;
        Tue, 23 Feb 2021 15:49:57 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.149.57])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 23AA252054;
        Tue, 23 Feb 2021 15:49:57 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 4/5] s390x: css: testing measurement
 block format 0
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
 <1613669204-6464-5-git-send-email-pmorel@linux.ibm.com>
 <20210223142730.4509bfc3.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c0af463a-d5ae-d84e-7a37-217bed4aeb78@linux.ibm.com>
Date:   Tue, 23 Feb 2021 16:49:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223142730.4509bfc3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 impostorscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/23/21 2:27 PM, Cornelia Huck wrote:
> On Thu, 18 Feb 2021 18:26:43 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We test the update of the measurement block format 0, the
>> measurement block origin is calculated from the mbo argument
>> used by the SCHM instruction and the offset calculated using
>> the measurement block index of the SCHIB.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h | 12 +++++++++
>>   s390x/css.c     | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 79 insertions(+)
>>
> 
> (...)
> 
>> diff --git a/s390x/css.c b/s390x/css.c
>> index fc693f3..b65aa89 100644
>> --- a/s390x/css.c
>> +++ b/s390x/css.c
>> @@ -191,6 +191,72 @@ static void test_schm(void)
>>   	report_prefix_pop();
>>   }
>>   
>> +#define SCHM_UPDATE_CNT 10
>> +static bool start_measure(uint64_t mbo, uint16_t mbi, bool fmt1)
> 
> Maybe "start_measuring"? Or "start_measurements"?

OK

> 
>> +{
>> +	int i;
>> +
>> +	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
>> +		report(0, "Enabling measurement_block_format");
>> +		return false;
>> +	}
>> +
>> +	for (i = 0; i < SCHM_UPDATE_CNT; i++) {
>> +		if (!do_test_sense()) {
>> +			report(0, "Error during sense");
>> +			return false;
>> +		}
>> +	}
>> +
>> +	return true;
>> +}
>> +
>> +/*
>> + * test_schm_fmt0:
>> + * With measurement block format 0 a memory space is shared
>> + * by all subchannels, each subchannel can provide an index
>> + * for the measurement block facility to store the measures.
> 
> s/measures/measurements/

yes

> 
>> + */
>> +static void test_schm_fmt0(void)
>> +{
>> +	struct measurement_block_format0 *mb0;
>> +	int shared_mb_size = 2 * sizeof(struct measurement_block_format0);
>> +
>> +	report_prefix_push("Format 0");
>> +
>> +	/* Allocate zeroed Measurement block */
>> +	mb0 = alloc_io_mem(shared_mb_size, 0);
>> +	if (!mb0) {
>> +		report_abort("measurement_block_format0 allocation failed");
>> +		goto end;
>> +	}
>> +
>> +	schm(NULL, 0); /* Stop any previous measurement */
> 
> Probably not strictly needed, but cannot hurt.
yes

> 
>> +	schm(mb0, SCHM_MBU);
>> +
>> +	/* Expect success */
>> +	report_prefix_push("Valid MB address and index 0");
>> +	report(start_measure(0, 0, false) &&
>> +	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
>> +	       "SSCH measured %d", mb0->ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	/* Clear the measurement block for the next test */
>> +	memset(mb0, 0, shared_mb_size);
>> +
>> +	/* Expect success */
>> +	report_prefix_push("Valid MB address and index 1");
>> +	report(start_measure(0, 1, false) &&
>> +	       mb0[1].ssch_rsch_count == SCHM_UPDATE_CNT,
>> +	       "SSCH measured %d", mb0[1].ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	schm(NULL, 0); /* Stop the measurement */
> 
> Shouldn't you call css_disable_mb() here as well?

I do not think it is obligatory, measurements are stopped but it may be 
indeed better so we get a clean SCHIB.
So yes,

     css_disable_mb();
     schm(NULL, 0);

seems the right thing to do.


Thanks,
Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
