Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B06331150
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhCHOzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:55:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60402 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231215AbhCHOzc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:55:32 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EsFbu045644
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=w3BZDWUcYuJp1TvmqIBEeQLaTkDaRWxggdMzGEoKA4U=;
 b=XJn19EFFud6WczS0p21NbPT9N+H4gm6vZFnTBKLgqee2o8t5/lVJLYMHEaF1hQInf+Xh
 qg/aOq3VtSen5SV78NF3Q6n6kMQkt6FLektEmjExAcpLS5V8ATlnX8fYZt/5YqOyPPmC
 DgB99cGSSXoEeHwtGG4zVHmsYODqocVn+pqGbgZNSi0ZMXlx9/BywCZPZLiHDRrAu57k
 NeesIO8BgaZz3NpmvQOlq+WheyMbx5KSwVZLJxUgEcSuxoC8Dd+saeMaFtWHWmewwm9+
 KgQXtd/jgQF3kFv9Q3imUQ+0Xzkfk+kZasgAK4qRumswD/2zacWO2zjNMlmj2J+T59Iy sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375p3mg0pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 09:55:31 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EscIe047364
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 09:55:31 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 375p3mg0pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:55:31 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128Eriw3027787;
        Mon, 8 Mar 2021 14:55:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 37410h9xth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:55:29 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EtRt742991916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:55:27 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E93BAE059;
        Mon,  8 Mar 2021 14:55:27 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3FD9AE04D;
        Mon,  8 Mar 2021 14:55:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:55:26 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 5/6] s390x: css: testing measurement
 block format 0
To:     Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-6-git-send-email-pmorel@linux.ibm.com>
 <80e25939-239a-8579-ba48-563ca0b2960f@linux.ibm.com>
 <20210304180511.34afe9fe.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <aedc49a5-0219-df56-5c0f-3691d489b5d5@linux.ibm.com>
Date:   Mon, 8 Mar 2021 15:55:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210304180511.34afe9fe.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/4/21 6:05 PM, Cornelia Huck wrote:
> On Mon, 1 Mar 2021 16:54:57 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> On 3/1/21 12:47 PM, Pierre Morel wrote:
>>> We test the update of the measurement block format 0, the
>>> measurement block origin is calculated from the mbo argument
>>> used by the SCHM instruction and the offset calculated using
>>> the measurement block index of the SCHIB.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>   lib/s390x/css.h | 12 +++++++++
>>>   s390x/css.c     | 66 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 78 insertions(+)
>>>
> 
> (...)
> 
>>> diff --git a/s390x/css.c b/s390x/css.c
>>> index e8f96f3..3915ed3 100644
>>> --- a/s390x/css.c
>>> +++ b/s390x/css.c
>>> @@ -184,6 +184,71 @@ static void test_schm(void)
>>>   	report_prefix_pop();
>>>   }
>>>   
>>> +#define SCHM_UPDATE_CNT 10
>>> +static bool start_measuring(uint64_t mbo, uint16_t mbi, bool fmt1)
>>> +{
>>> +	int i;
>>> +
>>> +	if (!css_enable_mb(test_device_sid, mbo, mbi, PMCW_MBUE, fmt1)) {
>>> +		report(0, "Enabling measurement_block_format");
>>> +		return false;
>>> +	}
>>> +
>>> +	for (i = 0; i < SCHM_UPDATE_CNT; i++) {
>>> +		if (!do_test_sense()) {
>>> +			report(0, "Error during sense");
>>> +			return false;
>> Are these hard fails, i.e. would it make sense to stop testing if this
>> or the css_enable_mb() above fails?
> 
> I think so; if we can't even enable the mb or send a sense, there's
> something really broken.
> 
> (...)
> 
> Otherwise, this looks good to me (same for the next patch.)
> 

Yes, I will change these for report_abort().

Thanks both.
Regards,

Pierre


-- 
Pierre Morel
IBM Lab Boeblingen
