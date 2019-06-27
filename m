Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E2358D8C
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 00:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfF0WEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 18:04:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55592 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbfF0WEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 18:04:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RLxoc7189007;
        Thu, 27 Jun 2019 22:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=yuWToA9F9gqE9EXvoCHEeyAiI1Uqts8XDZbsf9D0CjY=;
 b=aPvqLTmr1mL9xEOfXCbDicIp4SA367hq7Q/kZa3aStiyxO72Sj06S+T/Nf4G0+Df8/oC
 EDuvaeT9LcjtghMACOFqiHaSeOvCwOk1/RQKXABCdo2AGuD1CcUvH6OuQU03MEnLnpUK
 MkFcgiou67FSq1al3/TxEzSAIHpXeWLUo9XSmtBsFcVcPDcDWfPAVo+KPxOnEuBca7qu
 o6w23lG9xlOyVLEErCORCViBF64NkhuzUH8hl4rBpCQSMFXVGmNIoHQkXcVgFRTYd1ju
 2hXMIPGSjb12HaL/C0dqP4Gy0RmZ1nmi04/GIBPTJsdV0JPk/qXYTlSmW1aIUduCU346 OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2t9cyqtjtx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 22:03:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5RM3ZFx152873;
        Thu, 27 Jun 2019 22:03:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2t9acdgbry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 22:03:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5RM3jqS026518;
        Thu, 27 Jun 2019 22:03:45 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Jun 2019 15:03:45 -0700
Subject: Re: [kvm-unit-tests PATCH] x86: Mark APR as reserved in x2APIC
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marc Orr <marcorr@google.com>
References: <20190625120627.8705-1-nadav.amit@gmail.com>
 <367500e0-c8f8-f7ca-7f07-5424a05eea80@oracle.com>
 <BABD010E-DF8D-46F1-B279-4357690261A3@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <227f1744-2f67-60bb-9f58-cd13b45a7f90@oracle.com>
Date:   Thu, 27 Jun 2019 15:03:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <BABD010E-DF8D-46F1-B279-4357690261A3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906270253
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9301 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906270252
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/27/2019 11:19 AM, Nadav Amit wrote:
>> On Jun 26, 2019, at 3:32 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>
>>
>> On 6/25/19 5:06 AM, Nadav Amit wrote:
>>> Cc: Marc Orr <marcorr@google.com>
>>> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
>>> ---
>>>   lib/x86/apic.h | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/lib/x86/apic.h b/lib/x86/apic.h
>>> index 537fdfb..b5bf208 100644
>>> --- a/lib/x86/apic.h
>>> +++ b/lib/x86/apic.h
>>> @@ -75,6 +75,7 @@ static inline bool x2apic_reg_reserved(u32 reg)
>>>   	switch (reg) {
>>>   	case 0x000 ... 0x010:
>>>   	case 0x040 ... 0x070:
>>> +	case 0x090:
>>>   	case 0x0c0:
>>>   	case 0x0e0:
>>>   	case 0x290 ... 0x2e0:
>>
>>   0x02f0 which is also reserved, is missing from the above list.
> I tried adding it, and I get on bare-metal:
>
>    FAIL: x2apic - reading 0x2f0: x2APIC op triggered GP.
>
> And actually, the SDM table 10-6 “Local APIC Register Address Map Supported
> by x2APIC” also shows this register (LVT CMCI) as "Read/write”. So I don’t
> know why you say it is reserved.
>

Sorry, my bad !  I was looking at an older version (318148) of the SDM 
in which it was showing as reserved.

We are good.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
