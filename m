Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3786D326372
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 14:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBZNk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 08:40:57 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36632 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhBZNky (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Feb 2021 08:40:54 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11QDYO7s010274
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 08:40:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=hsgjqBWvj/TaMQNYXjHOWhm3mGFd9jLViTVoGF0p0eg=;
 b=moBOJJfpa+2TNjrm1kqccTjhwhR58MTvHuPTPLnhDXiN5LFo9aLu1pjNpZqM1dVsfzlL
 ek44eZMpXASnzI72IYrD44Tt3+8Lv09k1OjNq50EqeFwEHWNxoCmfEHiNcytbiG9EDJh
 uQV6UhYLb/bJezQWfTp+jZHZ2fEtEOQkf/xE2+a5vcv4Rg3AnqHugcnHm4ndbMW1c/Xg
 BGKypbiJwUZ+tUBqj5o4KJBs7WeLFSAcQzRthxV2Rmab/akzFuWe+esTZz6I9hVF7Ltm
 pSVIUACk4XAtBCQxN/hvJSRniEdDJgJZ1tOJLdzFjAxfEKPRMUVcBGJSMOe60ccTLjFq oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36y02sv1b5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 08:40:13 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11QDYXlD010822
        for <kvm@vger.kernel.org>; Fri, 26 Feb 2021 08:40:12 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36y02sv1ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 08:40:12 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11QDcLUf024054;
        Fri, 26 Feb 2021 13:40:10 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt285c00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 13:40:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11QDcdpJ32440804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 13:38:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D642F11C050;
        Fri, 26 Feb 2021 13:38:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 883CD11C04C;
        Fri, 26 Feb 2021 13:38:52 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.145.240])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Feb 2021 13:38:52 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v3 1/5] s390x: css: Store CSS
 Characteristics
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
References: <1613669204-6464-1-git-send-email-pmorel@linux.ibm.com>
 <1613669204-6464-2-git-send-email-pmorel@linux.ibm.com>
 <6577ebb9-5f61-e70a-cf72-4f428b9db4f4@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <c9935059-35d7-c995-d95d-de6a91049eeb@linux.ibm.com>
Date:   Fri, 26 Feb 2021 14:38:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <6577ebb9-5f61-e70a-cf72-4f428b9db4f4@linux.ibm.com>
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



On 2/26/21 10:50 AM, Janosch Frank wrote:
> On 2/18/21 6:26 PM, Pierre Morel wrote:

>>   
>> +/*
>> + * CHSC definitions
>> + */
>> +struct chsc_header {
>> +	u16 len;
>> +	u16 code;
> 
> uint*_t types please

OK

> 
>> +};

>> +static int check_response(void *p)
>> +{
>> +	struct chsc_header *h = p;
>> +
>> +	if (h->code == CHSC_RSP_OK) {
>> +		report(1, "CHSC command completed.");
> 
> I'm not a big fan of using integer constants for boolean type arguments.

hum, right, I will rework all these reports that should not appear here
anyway

> 
>> +		return 0;
>> +	}
>> +	if (h->code > CHSC_RSP_MAX)
>> +		h->code = 0;
>> +	report(0, "Response code %04x: %s", h->code, chsc_rsp_description[h->code]);
>> +	return -1;
>> +}
>> +
>> +int chsc(void *p, uint16_t code, uint16_t len)
>> +{
>> +	struct chsc_header *h = p;
>> +	int cc;
>> +
>> +	report_prefix_push("Channel Subsystem Call");
>> +	h->code = code;
>> +	h->len = len;
>> +	cc = _chsc(p);
>> +	switch (cc) {
>> +	case 3:
>> +		report(0, "Subchannel invalid or not enabled.");
>> +		break;
>> +	case 2:
>> +		report(0, "CHSC subchannel busy.");
>> +		break;
>> +	case 1:
>> +		report(0, "Subchannel invalid or not enabled.");
>> +		break;
> 
> I don't think that this is how we want to handle error reporting in lib
> files.
> 
> Please don't use report for library error reporting if it's not needed.
> 
> Most of the times you should return an error code or simply
> abort()/assert() if for instance a library init function fails and you
> can assume that most of the test code is dependent on that librarie's
> initialization. Sometimes report_abort() is also ok.
> 
> Test code should not be part of the library if possible!

Yes, will take care of that.

>>   static struct {
>>   	const char *name;
>>   	void (*func)(void);
>>   } tests[] = {
>> +	/* The css_init test is needed to initialize the CSS Characteristics */
>> +	{ "initialize CSS (chsc)", css_init },
> 
> Is css_init() really a test or does it only setup state for further tests?

Yes it is a test too
I rework that.

> 
>>   	{ "enumerate (stsch)", test_enumerate },
>>   	{ "enable (msch)", test_enable },
>>   	{ "sense (ssch/tsch)", test_sense },
>>
> 

-- 
Pierre Morel
IBM Lab Boeblingen
