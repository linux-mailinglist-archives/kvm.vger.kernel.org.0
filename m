Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EC63311E4
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 16:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhCHPPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 10:15:43 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57656 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229627AbhCHPPO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 10:15:14 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128F3rq7013457
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 10:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ivdxmV/EPYLnVmz/Y0QCjNlZRRyfv84WWqGP21twIiU=;
 b=JOf9JxoDeHzsA8anSohQYabsib3J0Gx502FDcSNydKyGn10de8ajYv7nC8qeEJPF7GLH
 6jN0UznE23nrU0pxxQkIi2GjdXIWcSMm9UTD+QXAoo4lnt4EgwJxXg0nk9teZY+N54Vl
 F3dBhSaI9/YX/Q++wpMcxaiuX+dADe8OklkMVjJBIscTskwQjAutjOr8wIxu7v/bs8hC
 GBxYljV3uD5eib3QGJcY5/1p5COmP5M9Iz3boeSigZo8lWxOaKBJhqO0owGWdz3elrw1
 ci7TTpKq/k0VFugBLDl6PzSf6F6NkrhWS+m8KoFyAtNB6h/6xW0xQdoHOuW/6hhxTM7P ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375ns2s8m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 10:15:12 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128F4Hn3015476
        for <kvm@vger.kernel.org>; Mon, 8 Mar 2021 10:14:57 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375ns2s8dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:14:57 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128FCDva013791;
        Mon, 8 Mar 2021 15:14:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3741c8hxd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 15:14:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128FEV9559834770
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 15:14:31 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6262AE04D;
        Mon,  8 Mar 2021 15:14:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A7F1DAE051;
        Mon,  8 Mar 2021 15:14:30 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.87.232])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 15:14:30 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: css: simplifications of the
 tests
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <1614599225-17734-1-git-send-email-pmorel@linux.ibm.com>
 <1614599225-17734-3-git-send-email-pmorel@linux.ibm.com>
 <70bbccca-6372-ee9a-37ae-913f5cc6a700@linux.ibm.com>
 <25d4a855-903a-32e7-d0de-dc5f4401b8a9@linux.ibm.com>
 <3e59a15b-a2d0-4527-edb3-582c723ab526@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <60b13345-539c-7cd9-882e-4ca77405afa8@linux.ibm.com>
Date:   Mon, 8 Mar 2021 16:14:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3e59a15b-a2d0-4527-edb3-582c723ab526@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103080083
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/8/21 3:41 PM, Thomas Huth wrote:
> On 08/03/2021 15.13, Pierre Morel wrote:
>>
>>
>> On 3/1/21 4:00 PM, Janosch Frank wrote:
>>> On 3/1/21 12:47 PM, Pierre Morel wrote:
>>>> In order to ease the writing of tests based on:
>>
>> ...snip...
>>
>>>> -static void test_sense(void)
>>>> +static bool do_test_sense(void)
>>>>   {
>>>>       struct ccw1 *ccw;
>>>> +    bool success = false;
>>>
>>> That is a very counter-intuitive name, something like "retval" might be
>>> better.
>>> You're free to use the normal int returns but unfortunately you can't
>>> use the E* error constants like ENOMEM.
>>
>> hum, I had retval and changed it to success on a proposition of Thomas...
>> I find it more intuitive as a bool since this function succeed or 
>> fail, no half way and is used for the reporting.
>>
>> other opinion?
> 
> I'd say either "static int ..." + retval (with 0 for success), or 
> "static bool ..." and "success" (with true for success) ... but "bool" + 
> "retval" sounds confusing to me.
> 
>   Thomas
> 

OK, thanks, then I keep bool success :)

Thanks
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
