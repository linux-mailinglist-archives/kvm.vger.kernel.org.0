Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B607C51C9
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 13:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346246AbjJKLWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 07:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234928AbjJKLWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 07:22:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094469E;
        Wed, 11 Oct 2023 04:22:12 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BB4lqK003021;
        Wed, 11 Oct 2023 11:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6gROS3qXdhSOJuGbJADjOjlUvL5wwG681207GI53R8I=;
 b=ZZZnbTPUPLXaNUexT+h9sDDQukFaDL6/BcWf8jGJXRok4Mr+DN5xui52i0s8oy4heNta
 utrqmZsto9XYODPc+4ZmLLadEQ9d063vCi9I3PQiLfzXqZo8enOv/60JnvTMLo72wxGg
 F6wC0iinywezaUNg1I3EDoTZsoU4yOWje5HwYtbP4qE+r0Vw3ML8hN2TGfb6Nptz2mGR
 /QX3rVkkAgDuYQvm+jU7XIuMAsugHyMSDjYOH09nrNeiIqz2dkEYNbFDH3oHZKAbenY7
 LgLScxyAwFl/Q7wuXGgbihZcAjc6LFnOidHZmw3Xy8Zdz6LiUwpi8DfRHCI3D1+ZFkr7 tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnth00m9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:22:08 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39BB4xwF004015;
        Wed, 11 Oct 2023 11:22:08 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnth00m8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:22:07 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39BAI38C023021;
        Wed, 11 Oct 2023 11:22:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkmc1q3ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:22:07 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39BBM4gJ17760836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 11:22:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3529120043;
        Wed, 11 Oct 2023 11:22:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7611420040;
        Wed, 11 Oct 2023 11:22:03 +0000 (GMT)
Received: from [9.171.88.83] (unknown [9.171.88.83])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 11:22:03 +0000 (GMT)
Message-ID: <37a91515-38d9-420f-89e9-cf18ab1ef997@linux.ibm.com>
Date:   Wed, 11 Oct 2023 13:22:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 5/9] s390x: topology: Refine stsi header
 test
Content-Language: en-US
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
 <20231011085635.1996346-6-nsg@linux.ibm.com>
 <fc59fb56-4848-4282-bec5-bdef40c817ff@linux.ibm.com>
 <58d8c91480041e3516837ec2d26562de656ea7b9.camel@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <58d8c91480041e3516837ec2d26562de656ea7b9.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: u6Na0GpRuuEYFN0yfFIowQ3g721VTcXj
X-Proofpoint-GUID: CsOldsNWby6NEpMa6V6sxbUJO_yuAOk1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_08,2023-10-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 clxscore=1015 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2309180000 definitions=main-2310110097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/23 13:19, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-10-11 at 13:16 +0200, Janosch Frank wrote:
>> On 10/11/23 10:56, Nina Schoetterl-Glausch wrote:
>>> Add checks for length field.
>>> Also minor refactor.
>>>
>>> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>> ---
>>>    s390x/topology.c | 15 +++++++++------
>>>    1 file changed, 9 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/s390x/topology.c b/s390x/topology.c
>>> index 5374582f..0ba57986 100644
>>> --- a/s390x/topology.c
>>> +++ b/s390x/topology.c
>>> @@ -187,18 +187,22 @@ static void stsi_check_maxcpus(struct sysinfo_15_1_x *info)
>>>    }
>>>    
>>>    /*
>>> - * stsi_check_mag
>>> + * stsi_check_header
>>>     * @info: Pointer to the stsi information
>>> + * @sel2: stsi selector 2 value
>>>     *
>>>     * MAG field should match the architecture defined containers
>>>     * when MNEST as returned by SCLP matches MNEST of the SYSIB.
>>>     */
>>> -static void stsi_check_mag(struct sysinfo_15_1_x *info)
>>> +static void stsi_check_header(struct sysinfo_15_1_x *info, int sel2)
>>>    {
>>>    	int i;
>>>    
>>> -	report_prefix_push("MAG");
>>> +	report_prefix_push("Header");
>>>    
>>> +	report(IS_ALIGNED(info->length, 8), "Length %d multiple of 8", info->length);
>>
>> STSI 15 works on Words, not DWords, no?
>> So we need to check length against 4, not 8.
> 
> The header is 16 bytes.
> Topology list entries are 8 or 16, so it must be a multiple of 8 at least.

Fair enough

> 
>>
>>> +	report(info->length < PAGE_SIZE, "Length %d in bounds", info->length);
>>> +	report(sel2 == info->mnest, "Valid mnest");
>>>    	stsi_check_maxcpus(info);
>>>    
>>>    	/*
>>> @@ -326,7 +330,6 @@ static int stsi_get_sysib(struct sysinfo_15_1_x *info, int sel2)
>>>    
>>>    	if (max_nested_lvl >= sel2) {
>>>    		report(!ret, "Valid instruction");
>>> -		report(sel2 == info->mnest, "Valid mnest");
>>>    	} else {
>>>    		report(ret, "Invalid instruction");
>>>    	}
>>> @@ -365,7 +368,7 @@ static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
>>>    		goto vertical;
>>>    	}
>>>    
>>> -	stsi_check_mag(info);
>>> +	stsi_check_header(info, sel2);
>>>    	stsi_check_tle_coherency(info);
>>>    
>>>    vertical:
>>> @@ -378,7 +381,7 @@ vertical:
>>>    		goto end;
>>>    	}
>>>    
>>> -	stsi_check_mag(info);
>>> +	stsi_check_header(info, sel2);
>>>    	stsi_check_tle_coherency(info);
>>>    	report_prefix_pop();
>>>    
>>
> 

