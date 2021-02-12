Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D61931A251
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 17:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231708AbhBLQFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 11:05:55 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43432 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231725AbhBLQFt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 11:05:49 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11CFWqa9054094;
        Fri, 12 Feb 2021 11:05:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=oZ/Or/hBnwRHsmHB6q9dDlaWqCXF5dYNjEqo2bAz9RQ=;
 b=M46BoC3IpzfWLLMXAtGntH1RuLDEy88mY1otm+ZLt8UR6f8trjRziDJtf8IoCrEvVkuH
 UUHx7VaC2UXxYQxRmOWy5BP3OpVmHsvGIN+jLDPTRgalNDEwySn8BNszQ4zKbUE2uS4C
 Yy3AbK+J1/VEujm8QET09juCWbzBtwKiYpFLVWTs2i9x1j6FYPUwnulTL8IwdneH1sjq
 tIdUwBs6+8SCKD5oOEKm418D0YMYw8cxbfOoTimoyrUgFBv4xAQuv77Xcg9WVS6odUjx
 BefxyT+K1ReWbJA9Pm5rlbU68DMcBXEP+cAIhUjwvl3671/ArWmC5i9Vz79UULHziFVb OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nvcc9c8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 11:05:06 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11CFX5Ho056573;
        Fri, 12 Feb 2021 11:05:06 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36nvcc9c66-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 11:05:05 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11CG3Smk011882;
        Fri, 12 Feb 2021 16:05:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36hjr8euqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 16:05:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11CG50Lf19530054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 16:05:01 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 822CD42045;
        Fri, 12 Feb 2021 16:04:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E0614204F;
        Fri, 12 Feb 2021 16:04:59 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.28.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Feb 2021 16:04:59 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v2 5/5] s390x: css: testing measurement
 block format 1
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
 <1612963214-30397-6-git-send-email-pmorel@linux.ibm.com>
 <20210212121545.44e13bd8.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <6e49d579-ecd7-f39c-e0d8-412c4bbacbdb@linux.ibm.com>
Date:   Fri, 12 Feb 2021 17:04:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210212121545.44e13bd8.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120121
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/12/21 12:15 PM, Cornelia Huck wrote:
> On Wed, 10 Feb 2021 14:20:14 +0100
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> Measurement block format 1 is made available by the extended
>> mesurement block facility and is indicated in the SCHIB by
> 
> s/mesurement/measurement/

50% good and yes, 50% bad, I change it thanks.

> 
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
>>   lib/s390x/css.h | 14 ++++++++++++++
>>   s390x/css.c     | 36 ++++++++++++++++++++++++++++++++++++
>>   2 files changed, 50 insertions(+)
> 
> (...)
> 
>> +static void test_schm_fmt1(void)
>> +{
>> +	struct measurement_block_format1 *mb1;
>> +
>> +	report_prefix_push("Format 1");
>> +
>> +	mb1 = alloc_io_mem(sizeof(struct measurement_block_format1), 0);
>> +	if (!mb1) {
>> +		report_abort("measurement_block_format1 allocation failed");
>> +		goto end;
>> +	}
>> +
>> +	schm(NULL, 0); /* Clear previous MB address */
> 
> Same comment as for the last patch.

Yes,

> 
>> +	schm(0, SCHM_MBU);
>> +
>> +	/* Expect error for non aligned MB */
>> +	report_prefix_push("Unaligned MB origin");
>> +	report_xfail(start_measure((u64)mb1 + 1, 0, true), mb1->ssch_rsch_count != 0,
>> +		     "SSCH measured %d", mb1->ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	memset(mb1, 0, sizeof(*mb1));
>> +
>> +	/* Expect success */
>> +	report_prefix_push("Valid MB address and index");
>> +	report(start_measure((u64)mb1, 0, true) &&
>> +	       mb1->ssch_rsch_count == SCHM_UPDATE_CNT,
>> +	       "SSCH measured %d", mb1->ssch_rsch_count);
>> +	report_prefix_pop();
>> +
>> +	free_io_mem(mb1, sizeof(struct measurement_block_format1));
> 
> Also here, you need to stop the measurements before freeing the block.

yes, I will.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
