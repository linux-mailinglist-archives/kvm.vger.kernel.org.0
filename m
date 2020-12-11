Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3654F2D8144
	for <lists+kvm@lfdr.de>; Fri, 11 Dec 2020 22:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392509AbgLKVr2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Dec 2020 16:47:28 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54148 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390810AbgLKVq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Dec 2020 16:46:58 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBLi4Bc023798;
        Fri, 11 Dec 2020 21:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7/MHF/pBuDL2hjdppy8iRHkatHDpSD0GBuW1gbAMxs8=;
 b=G6oy9wI/c/MzDo6hoXshLY3mlF7MdylymZCpuvZAjFVCBYjIL6fUSmsz3pNM9DF+q1TC
 oNeP9XpVshvWY0FKjT7kb9+GGerUSwwzfeoNPRp3VAKcEYKzCczgr2tufRkorjtSu2kB
 v0jObj6r6Sc1LASxL/0VpIKFwRra2rywBlbWwmDNwtnCGv+Z2ZxZSHRvuFOjHORklAQC
 s1j7JwvaraN09TaXf0+XGkDAbbwTrHTvMViKuN11tk9t+G+d8uvYkvdXrQXVze+DUReA
 frKaDJxRMK78mQJ6QiR4iphFPPs/8mZkBoYmYgM+7XYSm3vMYjyc1oVB3cOkp1DbfMDE Kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mrcsuh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Dec 2020 21:46:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BBLYpbK123876;
        Fri, 11 Dec 2020 21:44:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kyyq835-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Dec 2020 21:44:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BBLiBGR008570;
        Fri, 11 Dec 2020 21:44:11 GMT
Received: from [10.159.129.196] (/10.159.129.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Dec 2020 13:44:11 -0800
Subject: Re: [PATCH 1/2 v4] KVM: nSVM: Check reserved values for 'Type' and
 invalid vectors in EVENTINJ
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20201207194129.7543-1-krish.sadhukhan@oracle.com>
 <20201207194129.7543-2-krish.sadhukhan@oracle.com>
 <X86N2c7ZG5fAToND@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <76431b0c-4add-79b5-3f62-9c15306a1421@oracle.com>
Date:   Fri, 11 Dec 2020 13:44:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X86N2c7ZG5fAToND@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012110143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9832 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/7/20 12:17 PM, Sean Christopherson wrote:
> On Mon, Dec 07, 2020, Krish Sadhukhan wrote:
>> According to sections "Canonicalization and Consistency Checks" and "Event
>> Injection" in APM vol 2
>>
>>      VMRUN exits with VMEXIT_INVALID error code if either:
>>        - Reserved values of TYPE have been specified, or
>>        - TYPE = 3 (exception) has been specified with a vector that does not
>> 	correspond to an exception (this includes vector 2, which is an NMI,
>> 	not an exception).
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> ---
>>   arch/x86/include/asm/svm.h |  4 ++++
>>   arch/x86/kvm/svm/nested.c  | 14 ++++++++++++++
>>   2 files changed, 18 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 71d630bb5e08..d676f140cd19 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -341,9 +341,13 @@ struct vmcb {
>>   #define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
>>   
>>   #define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
>> +#define SVM_EVTINJ_TYPE_RESV1 (1 << SVM_EVTINJ_TYPE_SHIFT)
>>   #define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
>>   #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
>>   #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
>> +#define SVM_EVTINJ_TYPE_RESV5 (5 << SVM_EVTINJ_TYPE_SHIFT)
>> +#define SVM_EVTINJ_TYPE_RESV6 (6 << SVM_EVTINJ_TYPE_SHIFT)
>> +#define SVM_EVTINJ_TYPE_RESV7 (7 << SVM_EVTINJ_TYPE_SHIFT)
>>   
>>   #define SVM_EVTINJ_VALID (1 << 31)
>>   #define SVM_EVTINJ_VALID_ERR (1 << 11)
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 9e4c226dbf7d..fa51231c1f24 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -212,6 +212,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
>>   
>>   static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>>   {
>> +	u8 type, vector;
>> +	bool valid;
>> +
>>   	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
>>   		return false;
>>   
>> @@ -222,6 +225,17 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
>>   	    !npt_enabled)
>>   		return false;
>>   
>> +	valid = control->event_inj & SVM_EVTINJ_VALID;
>> +	type = control->event_inj & SVM_EVTINJ_TYPE_MASK;
> The mask is shifted by 8, which means type is guaranteed to be 0 since the value
> will be truncated when casting to a u8.  I'm somewhat surprised neither
> checkpatch nor checkpatch warns.  The types are also shifted, so the easiest
> thing is probably to store it as a u32, same as event_inj.  I suspect your test
> passes because type==0 is INTR and the test always injects #DE, which is likely
> an illegal vector.


My bad. Will change it back to u32.

>
>> +	if (valid && (type == SVM_EVTINJ_TYPE_RESV1 ||
>> +	    type >= SVM_EVTINJ_TYPE_RESV5))
>> +		return false;
>> +
>> +	vector = control->event_inj & SVM_EVTINJ_VEC_MASK;
>> +	if (valid && (type == SVM_EVTINJ_TYPE_EXEPT))
>> +		if (vector == NMI_VECTOR || vector > 31)
> Preferred style is to combine these into a single statement.


The reason why I split them was to avoid using too many parentheses 
which was what Paolo was objecting to. 😁

>
>> +			return false;
>> +
>>   	return true;
>>   }
>>   
>> -- 
>> 2.27.0
>>
