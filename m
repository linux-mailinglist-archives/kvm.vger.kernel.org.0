Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACB9292CCE
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 19:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgJSRbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 13:31:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45722 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgJSRbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 13:31:14 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JHSnKe023314;
        Mon, 19 Oct 2020 17:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sTISVW5UIF05mErN2RLtxp/CTMB2VDTEIR9n23R1hQc=;
 b=F92V9WSTkk1dAYAxxdvh/B08Z0gdSdP/84YxR78kTwHo+IeZbtDgDhWquXLoiJnaVxzW
 wdqdUAngUjfK99Ckn6dQ+fXSIUGOWJVjvhuwkSGFnA2/XniC16iTDZZj6xG4YhyUXC1E
 1FO3+MyZuIC5Q/7mNRikqdHZjsRoaOPfHwiOpcW4w+mhMTBG42CGhd5W4sqJTvH6OX3W
 sQZqY8qIPLSwzHm0u8o/lfMuyLUo9nzvDWCyxsoNNMnflRugI77/2+chDw0gWIkpS4rA
 qZGWjH2zGYv4c9TJxY3mZJ7D/VH23fTwflY0qNU8XVGuiim/0Guc26hcPJcJfYsJSPUk RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 347p4apxc3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Oct 2020 17:31:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09JHPXkE126327;
        Mon, 19 Oct 2020 17:31:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 348agwd5t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Oct 2020 17:31:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09JHV7ur020241;
        Mon, 19 Oct 2020 17:31:07 GMT
Received: from localhost.localdomain (/10.159.224.206)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Oct 2020 10:31:07 -0700
Subject: Re: [PATCH 2/2] nSVM: Test reserved values for 'Type' and invalid
 vectors in EVENTINJ
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
References: <20201017000234.42326-1-krish.sadhukhan@oracle.com>
 <20201017000234.42326-3-krish.sadhukhan@oracle.com>
 <3C14E481-3298-41CD-A04F-4AC46F9E2C1A@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <0df2bf25-b21c-4709-40b6-fcec2a1e2ca5@oracle.com>
Date:   Mon, 19 Oct 2020 10:30:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <3C14E481-3298-41CD-A04F-4AC46F9E2C1A@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9779 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010190119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/16/20 11:12 PM, Nadav Amit wrote:
>> On Oct 16, 2020, at 5:02 PM, Krish Sadhukhan <krish.sadhukhan@oracle.com> wrote:
>>
>> According to sections "Canonicalization and Consistency Checks" and "Event
>> Injection" in APM vol 2
>>
>>     VMRUN exits with VMEXIT_INVALID error code if either:
>>       - Reserved values of TYPE have been specified, or
>>       - TYPE = 3 (exception) has been specified with a vector that does not
>> 	correspond to an exception (this includes vector 2, which is an NMI,
>> 	not an exception).
>>
>> Existing tests already cover part of the second rule. This patch covers the
>> the first rule and the missing pieces of the second rule.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>> x86/svm_tests.c | 40 ++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 40 insertions(+)
>>
>> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
>> index f78c9e4..e6554e4 100644
>> --- a/x86/svm_tests.c
>> +++ b/x86/svm_tests.c
>> @@ -2132,6 +2132,45 @@ static void test_dr(void)
>> 	vmcb->save.dr7 = dr_saved;
>> }
>>
>> +static void test_event_inject(void)
>> +{
>> +	u32 i;
>> +	u32 event_inj_saved = vmcb->control.event_inj;
>> +
>> +	handle_exception(DE_VECTOR, my_isr);
>> +
>> +	report (svm_vmrun() == SVM_EXIT_VMMCALL && count_exc == 0, "Test "
>> +	    "No EVENTINJ");
>> +
>> +	/*
>> +	 * Reserved values for 'Type' in EVENTINJ causes VMEXIT_INVALID.
>> +	 */
>> +	for (i = 1; i < 8; i++) {
>> +		if (i != 1 && i < 5)
>> +			continue;
>> +		vmcb->control.event_inj = DE_VECTOR |
>> +		    i << SVM_EVTINJ_TYPE_SHIFT | SVM_EVTINJ_VALID;
>> +		report(svm_vmrun() == SVM_EXIT_ERR && count_exc == 0,
>> +		    "Test invalid TYPE (%x) in EVENTINJ", i);
>> +	}
>> +
>> +	/*
>> +	 * Invalid vector number for event type 'exception' in EVENTINJ
>> +	 * causes VMEXIT_INVALID.
>> +	 */
>> +	i = 32;
>> +	while (i < 256) {
>> +		vmcb->control.event_inj = i | SVM_EVTINJ_TYPE_EXEPT |
>> +		    SVM_EVTINJ_VALID;
>> +		report(svm_vmrun() == SVM_EXIT_ERR && count_exc == 0,
>> +		    "Test invalid vector (%u) in EVENTINJ for event type "
>> +		    "\'exception\'", i);
>> +		i += 4;
>> +	}
> I know that kvm-unit-tests has nothing to do with style, but can’t this loop
> be turned into a for-loop for readability?


Yes, it's possible in this case.

>
> And why "i += 4" ?
>
Just wanted to limit the number of tests :-)
