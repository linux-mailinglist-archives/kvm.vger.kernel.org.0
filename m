Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92A3AB004
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 03:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390689AbfIFBHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 21:07:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41110 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731344AbfIFBHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 21:07:54 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x86100V2196164;
        Fri, 6 Sep 2019 01:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Bdad3OeLVGs9UM2wRmXw480RDH6zpVcm9+JL7oSGFjk=;
 b=BjbUUqrrK+TPX3GdKMw0faFCelGMTU1tL1VEp7C8jcP/OI0cT0hhF9vgiwsxLPbpDjB0
 Uq+EAoW4mI/R7iuqStnZAmEYkYLgsu4Pg3iC8Wo75AvVhYkKit+jfI+mxp438Qf0gtCj
 qcENWn4qRpN58ra1S+s5i4EV203apAWJpaEFa/pwveCTQeFJISmPGK7puy2MKvf4oE2P
 rY0+RVx6Wev6oQVKcwFWPpy/+waGTU7DFjqgG/xAwMzeTB2VhRo/2Yl73BIpWBd6S8oq
 GxOJJo66gfNij9Vnc8hXcSDmpkIVS15IWMLiByScJgfspgPUUKnonnxSqcyh7Pkky+ln nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uud7mg1h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:07:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8614Qml010801;
        Fri, 6 Sep 2019 01:07:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2utvr4f1fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 01:07:31 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8617UoK020621;
        Fri, 6 Sep 2019 01:07:30 GMT
Received: from dhcp-10-132-91-76.usdhcp.oraclecorp.com (/10.132.91.76)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 18:07:30 -0700
Subject: Re: [kvm-unit-tests PATCH v3 7/8] x86: VMX: Make
 guest_state_test_main() check state from nested VM
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20190903215801.183193-1-oupton@google.com>
 <20190903215801.183193-8-oupton@google.com>
 <1fb19467-a743-1886-de52-a63bd19b0b00@oracle.com>
 <20190905004919.GB107023@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <133d4228-7a95-3957-b494-ce9d027d00a9@oracle.com>
Date:   Thu, 5 Sep 2019 18:07:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190905004919.GB107023@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060008
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 09/04/2019 05:49 PM, Oliver Upton wrote:
> On Wed, Sep 04, 2019 at 05:25:40PM -0700, Krish Sadhukhan wrote:
>>
>> On 09/03/2019 02:58 PM, Oliver Upton wrote:
>>> The current tests for guest state do not yet check the validity of
>>> loaded state from within the nested VM. Introduce the
>>> load_state_test_data struct to share data with the nested VM.
>>>
>>> Signed-off-by: Oliver Upton <oupton@google.com>
>>> ---
>>>    x86/vmx_tests.c | 23 ++++++++++++++++++++---
>>>    1 file changed, 20 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>> index f035f24a771a..b72a27583793 100644
>>> --- a/x86/vmx_tests.c
>>> +++ b/x86/vmx_tests.c
>>> @@ -5017,13 +5017,28 @@ static void test_entry_msr_load(void)
>>>    	test_vmx_valid_controls(false);
>>>    }
>>> +static struct load_state_test_data {
>>> +	u32 msr;
>>> +	u64 exp;
>>> +	bool enabled;
>>> +} load_state_test_data;
>> A better name is probably 'loaded_state_test_data'  as you are checking the
>> validity of the loaded MSR in the guest.
> Other usages of structs for data sharing follow the previous naming
> convention, but I slightly missed the mark with that as well. Other
> structs seem to use the same prefix that the associated tests have (e.g.
> ept_access_test_data corresponds to ept_access_test_*). To best match
> that pattern, I should instead name it "vmx_state_area_test_data" (since
> its used for both guest/host test data anyway.
>
> That isn't to say there is a better pattern we could follow for naming
> this! Which do you think is better?

'vmx_state_area_test_data' sounds fine to me. Thanks !

>
>>> +
>>>    static void guest_state_test_main(void)
>>>    {
>>> +	u64 obs;
>>> +	struct load_state_test_data *data = &load_state_test_data;
>>> +
>>>    	while (1) {
>>> -		if (vmx_get_test_stage() != 2)
>>> -			vmcall();
>>> -		else
>>> +		if (vmx_get_test_stage() == 2)
>>>    			break;
>>> +
>>> +		if (data->enabled) {
>>> +			obs = rdmsr(obs);
>> Although you fixed it in the next patch, why not use  'data->msr' in place
>> of 'obs' as the parameter to rdmsr() in this patch only ?
> Ugh, I mucked this up when reworking before sending out. 'data->msr'
> should have appeared in this patch. I'll fix this.
>
>>> +			report("Guest state is 0x%lx (expected 0x%lx)",
>>> +			       data->exp == obs, obs, data->exp);
>>> +		}
>>> +
>>> +		vmcall();
>>>    	}
>>>    	asm volatile("fnop");
>>> @@ -6854,7 +6869,9 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
>>>    	u64 i, val;
>>>    	u32 j;
>>>    	int error;
>>> +	struct load_state_test_data *data = &load_state_test_data;
>>> +	data->enabled = false;
>>>    	vmcs_clear_bits(ctrl_field, ctrl_bit);
>>>    	if (field == GUEST_PAT) {
>>>    		vmx_set_test_stage(1);
> Thanks for the review, Krish. Looks like a typo I didn't rework into
> this patch correctly, please let me know what you think on the other
> comment.
>
> --
> Thanks,
> Oliver

