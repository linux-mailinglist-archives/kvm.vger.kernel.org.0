Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772FD31A23B
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 17:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhBLQAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 11:00:32 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21516 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229512AbhBLQA3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 11:00:29 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CFrpET025396;
        Fri, 12 Feb 2021 10:59:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GEQWDFlQMRp+SmX0S4/u3pqYX50a6k943ShiXMDPsqc=;
 b=Wc1qdC7mnxRz31zkvBhScTLyTeYv6uS6mtjvFDsNNPy5UPTL3XFRt+8ahmDXTQkbY/lA
 Q4gUMC4zEh4cwygesEcPdgLDpom70NHyVNsEzVKlSu4bK0oYUKAd/hlEmMGE1N+HY0Ro
 /fo8I2cqCB78or4ekIuZFeg8HIAJS+/3twcZ+bibnxpC87rfU6WnfpJA8/48izlGMau6
 KIS+gyEBS0rjCQfM5S0O0+QHgRtdn2J/i/xr1tKeDmH1J4VKNuFy8w1kBjIRq+TpnHm9
 riSX8fB6sAskKsiMWQEORYQ6/O+r73WYN14nHhL2ufGYppkuu157RTOFuO7sI48fWJXp Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36nvqk05v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:59:47 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11CFsKh0027137;
        Fri, 12 Feb 2021 10:59:47 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36nvqk05ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 10:59:46 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CFbsrO017025;
        Fri, 12 Feb 2021 15:59:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 36hjr8eujy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 15:59:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CFxVFL30867910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 15:59:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4150342042;
        Fri, 12 Feb 2021 15:59:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4CCF4203F;
        Fri, 12 Feb 2021 15:59:41 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 15:59:41 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 4/5] s390x: css: testing measurement
 block format 0
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
 <1612963214-30397-5-git-send-email-pmorel@linux.ibm.com>
 <20210212121245.061058ba.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <33d548d8-af56-82fc-c5e4-ae7fbca32089@linux.ibm.com>
Date:   Fri, 12 Feb 2021 16:59:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212121245.061058ba.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120118
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/21 12:12 PM, Cornelia Huck wrote:
> On Wed, 10 Feb 2021 14:20:13 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> We tests the update of the mesurement block format 0, the
> 
> s/tests/test/
> s/mesurement/measurement/

hum, yes :(

> 
>> mesurement block origin is calculated from the mbo argument
>> used by the SCHM instruction and the offset calculated using
>> the measurement block index of the SCHIB.
>>
>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>> ---
>>   lib/s390x/css.h | 14 +++++++++++++
>>   s390x/css.c     | 55 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 69 insertions(+)
>>
> 
> (...)
> 
>> +static void test_schm_fmt0(void)
>> +{
>> +	struct measurement_block_format0 *mb0;
>> +
>> +	report_prefix_push("Format 0");
>> +
>> +	mb0 = alloc_io_mem(sizeof(struct measurement_block_format0), 0);
>> +	if (!mb0) {
>> +		report_abort("measurement_block_format0 allocation failed");
>> +		goto end;
>> +	}
>> +
>> +	schm(NULL, 0); /* Clear previous MB address */
> 
> I think it would be better to clean out the mb after a particular test
> has run, so that the following tests can start with a clean slate.

The allocation includes zeroing the memory.
and I do a memset(mb, 0...) after the failed test.

Is there something else to clear?

> 
>> +	schm(mb0, SCHM_MBU);
>>   
>> +	/* Expect error for non aligned MB */
>> +	report_prefix_push("Unaligned MB index");
>> +	report_xfail(start_measure(0, 0x01, false), mb0->ssch_rsch_count != 0,
>> +		     "SSCH measured %d", mb0->ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	memset(mb0, 0, sizeof(*mb0));
>> +
>> +	/* Expect success */
>> +	report_prefix_push("Valid MB address and index");
>> +	report(start_measure(0, 0, false) &&
>> +	       mb0->ssch_rsch_count == SCHM_UPDATE_CNT,
>> +	       "SSCH measured %d", mb0->ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	free_io_mem(mb0, sizeof(struct measurement_block_format0));
> 
> Before you free the memory, you really need to stop measurements
> again... even though nothing happens right now, because you're not doing
> I/O after this point.

Yes, it is cleaner.

Thanks, pierre

-- 
Pierre Morel
IBM Lab Boeblingen
